from __future__ import annotations

from copy import deepcopy
from functools import lru_cache
from pathlib import Path

import requests
import ruamel.yaml as ryaml
from ckanapi import RemoteCKAN
from ckanapi.errors import NotAuthorized, ValidationError
from ruamel.yaml.comments import CommentedMap
from ruamel.yaml.compat import ordereddict

from basedosdados.exceptions import BaseDosDadosException
from basedosdados.upload.base import Base


class Metadata(Base):
    def __init__(self, dataset_id: str, table_id: str = None, **kwargs):
        super().__init__(**kwargs)
        self.kwargs = kwargs

        self.dataset_id = dataset_id
        self.table_id = table_id or ""

        self.dataset_path = self.metadata_path / dataset_id / "dataset_config.yaml"
        self.dataset_path.parent.mkdir(parents=True, exist_ok=True)

        self.table_path = Path("")
        if table_id:
            self.table_path = self.metadata_path / dataset_id
            self.table_path = self.table_path / table_id
            self.table_path = self.table_path / "table_config.yaml"
            self.table_path.parent.mkdir(parents=True, exist_ok=True)

        url = "https://basedosdados.org"
        self.CKAN_API_KEY = self.config.get("ckan", {}).get("api_key")
        self.CKAN_URL = self.config.get("ckan", {}).get("url", "") or url

    @property
    def local_metadata(self) -> dict:
        """Load dataset with tables metadata"""

        metadata = {}
        if self.dataset_path.exists():
            with open(self.dataset_path, "r", encoding="utf-8") as file:
                yaml = ryaml.YAML(typ="safe", pure=True)
                metadata = yaml.load(file.read())
                metadata["resources"] = []
            metadata["notes"] = metadata["description"]

        metadata["resources"] = []
        for table in self.dataset_path.parent.glob("**/*table_config.yaml"):
            with open(table, "r", encoding="utf-8") as file:
                yaml = ryaml.YAML(typ="safe", pure=True)
                metadatum = yaml.load(file.read())
                metadata["resources"].append(metadatum)

        return metadata

    @property
    @lru_cache(256)
    def remote_metadata(self) -> dict:
        """CKAN dataset with tables metadata"""

        name = self.dataset_id.replace("_", "-")
        url = f"{self.CKAN_URL}/api/3/action/package_show?id={name}"
        response = requests.get(url).json()
        dataset = response.get("result")

        if not response.get("success"):
            return {}

        return dataset

    @property
    @lru_cache(256)
    def updated_metadata(self) -> dict:
        """Helper function that structures local metadata for validation"""

        local = self.local_metadata
        updated = self.remote_metadata

        # Dataset Metadata
        # Priorities: Local > CKAN > Fallback

        choose = lambda x, y=None: local.get(x) or updated.get(x) or y

        updated["id"] = choose("id")
        updated["title"] = choose("title")
        updated["name"] = choose("name")
        updated["dataset_id"] = choose("")
        updated["type"] = choose("type", "dataset")
        updated["notes"] = choose("notes")
        updated["description"] = updated["notes"]

        updated["owner_org"] = self.owner_org
        updated["organization"] = self.organization

        updated["tags"] = choose("tags", [])
        updated["groups"] = choose("groups", [])
        for prop in ["tags", "groups"]:
            if len(updated[prop]) and type(updated[prop][0]) is str:
                updated[prop] = [{"name": p} for p in updated[prop]]
            elif len(updated[prop]) and type(updated[prop][0]) is dict:
                updated[prop] = [{"name": p.get("name")} for p in updated[prop]]

        if "extras" in updated:
            del updated["extras"]

        if not "resources" in updated:
            updated["resources"] = []

        # Table Properties
        # Priorities: Local > CKAN > Metadata

        ids = [t.get("table_id") for t in updated.get("resources", [])]

        if self.table_id and self.table_id not in ids:
            resource = {"table_id": self.table_id}
            updated["resources"].append(resource)

        for resl in local.get("resources", []):
            table_id = resl.get("table_id")

            if not table_id:
                continue

            if table_id not in ids:
                updated["resources"].append(resl)
                continue

            i = ids.index(table_id)
            res = updated["resources"][i]
            choose = lambda x, y=None: resl.get(x) or res.get(x) or y

            res["description"] = choose("description")
            res["name"] = choose("name")
            res["resource_type"] = choose("resource_type", "bdm_table")
            res["version"] = choose("version")
            res["dataset_id"] = self.dataset_id
            res["table_id"] = choose("table_id")
            res["spatial_coverage"] = choose("spatial_coverage")
            res["temporal_coverage"] = choose("temporal_coverage")
            res["update_frequency"] = choose("update_frequency")
            res["entity"] = choose("entity")
            res["time_unit"] = choose("time_unit")
            res["identifying_columns"] = choose("identifying_columns")
            res["last_updated"] = choose("last_updated")
            res["published_by"] = choose("published_by")
            res["data_cleaned_by"] = choose("data_cleaned_by")
            res["data_cleaning_description"] = choose("data_cleaning_description")
            res["raw_files_url"] = choose("raw_files_url")
            res["auxiliary_files_url"] = choose("auxiliary_files_url")
            res["architecture_url"] = choose("architecture_url")
            res["covered_by_dictionary"] = choose("covered_by_dictionary")
            res["source_bucket_name"] = choose("source_bucket_name")
            res["project_id_prod"] = choose("project_id_prod")
            res["project_id_staging"] = choose("project_id_staging")
            res["partitions"] = choose("partitions")
            res["bdm_file_size"] = choose("bdm_file_size")
            res["columns"] = choose("columns")
            res["metadata_modified"] = choose("metadata_modified")
            res["package_id"] = choose("package_id")

            updated["resources"][i] = res

        return updated

    @property
    @lru_cache(256)
    def owner_org(self) -> str:
        """Organization UUID"""

        if name := self.local_metadata.get("organization"):
            url = f"{self.CKAN_URL}/api/3/action/organization_show?id={name}"
            response = requests.get(url).json()

            if not response.get("success"):
                raise BaseDosDadosException("Organization not found")

            return response.get("result", {}).get("id")

        return self.remote_metadata.get("owner_org") or ""

    @property
    @lru_cache(256)
    def organization(self) -> str:
        """Organization name"""

        local_org = self.local_metadata.get("organization")
        remote_org = self.remote_metadata.get("organization", {}).get("name")

        return local_org or remote_org or ""

    @property
    @lru_cache(256)
    def dataset_schema(self) -> dict:
        """Get metadata schema from CKAN API endpoint"""
        url = f"{self.CKAN_URL}/api/3/action/bd_dataset_schema"
        return requests.get(url).json().get("result")

    @property
    @lru_cache(256)
    def table_schema(self) -> dict:
        """Get metadata schema from CKAN API endpoint"""
        url = f"{self.CKAN_URL}/api/3/action/bd_bdm_table_schema"
        return requests.get(url).json().get("result")

    @property
    @lru_cache(256)
    def columns_schema(self) -> dict:
        """Returns a dictionary with the schema of the columns"""
        url = f"{self.CKAN_URL}/api/3/action/bd_bdm_columns_schema"
        return requests.get(url).json().get("result")

    def create(
        self,
        if_exists: str = "raise",
        columns: list = [],
        partition_columns: list = [],
        force_columns: bool = False,
    ) -> Metadata:
        """Create metadata file based on the current version saved to CKAN database

        Args:
            if_exists (str): Optional. What to do if config exists
                * raise : Raises Conflict exception
                * replace : Replaces config file with most recent
                * pass : Do nothing
            columns (list): Optional.
                A `list` with the table columns' names.
            partition_columns(list): Optional.
                A `list` with the name of the table columns that partition the data.
            force_columns (bool): Optional.
                If set to `True`, overwrite CKAN's columns with the ones provided.
                If set to `False`, keep CKAN's columns instead of the ones provided.
        """

        metadata = self.updated_metadata

        # Dataset create is mandatory
        self.create_metadatum(
            metadata,
            if_exists=if_exists,
            columns=columns,
            partition_columns=partition_columns,
            force_columns=force_columns,
        )

        # Table create with one table
        if self.table_id:
            try:
                ids = [r.get("table_id") for r in metadata.get("resources", [])]
                idx = ids.index(self.table_id)
                resource = metadata["resources"][idx]
            except:
                # TODO: ACESSANDO ERRADO AQUI
                resource = {"table_id": self.table_id}

            self.create_metadatum(
                resource,
                if_exists=if_exists,
                columns=columns,
                partition_columns=partition_columns,
                force_columns=force_columns,
            )

        # Table create for multiple tables
        else:
            for resource in metadata.get("resources", []):
                if resource.get("resource_type") == "bdm_table":
                    self.create_metadatum(
                        resource,
                        if_exists=if_exists,
                        columns=columns,
                        partition_columns=partition_columns,
                        force_columns=force_columns,
                    )

        return self

    def create_metadatum(
        self,
        metadata: dict,
        if_exists: str = "raise",
        columns: list = [],
        partition_columns: list = [],
        force_columns: bool = False,
    ):

        if not "table_id" in metadata:
            metadata_schema = self.dataset_schema
            filepath = self.dataset_path
        else:
            metadata_schema = self.table_schema
            filepath = self.dataset_path.parent / metadata["table_id"]
            filepath = filepath / "table_config.yaml"

        if filepath.exists() and if_exists == "raise":
            raise FileExistsError(
                f"{filepath} already exists."
                + " Set the arg `if_exists` to `replace` to replace it."
            )
        elif if_exists != "pass":
            if "table_id" in metadata and (
                force_columns or not metadata.get("columns")
            ):
                metadata["columns"] = [{"name": c} for c in columns]

            yaml_obj = build_yaml_object(
                self.dataset_id,
                self.table_id,
                self.config,
                metadata_schema,
                metadata,
                columns_schema=self.columns_schema,
                partition_columns=partition_columns,
            )

            filepath.parent.mkdir(parents=True, exist_ok=True)

            with open(filepath, "w", encoding="utf-8") as file:
                ruamel = ryaml.YAML()
                ruamel.preserve_quotes = True
                ruamel.indent(mapping=4, sequence=6, offset=4)
                ruamel.dump(yaml_obj, file)

        return self

    def validate(self) -> bool:
        """Validate dataset_config.yaml or table_config.yaml files.
        The yaml file should be located at
        metadata_path/dataset_id[/table_id/],
        as defined in your config.toml

        Returns:
            bool:
                True if the metadata is valid. False if it is invalid.

        Raises:
            BaseDosDadosException:
                when the file has validation errors.
        """

        # Validate Metadata Version

        message = (
            f"Could not publish metadata due to out of date config file. "
            f"Please run `basedosdados metadata create {self.dataset_id} "
            f"{self.table_id}` to get the most recently updated metadata "
            f"and apply your changes to it."
        )

        if not self.local_metadata.get("metadata_modified"):
            assert True if not self.local_metadata.get("id") else False, message
        else:
            local_modified = self.local_metadata.get("metadata_modified")
            remote_modified = self.remote_metadata.get("metadata_modified")
            assert local_modified == remote_modified, message

        # Validate Metadata Model

        ckan = RemoteCKAN(self.CKAN_URL, user_agent="", apikey=None)
        response = ckan.action.bd_dataset_validate(**self.updated_metadata)

        if response.get("errors"):
            error = {self.updated_metadata.get("name"): response["errors"]}
            message = f"{self.dataset_id} has validation errors: {error}"
            raise BaseDosDadosException(message)

        return True

    def publish(self) -> dict:
        """Publish local metadata modifications.
        `Metadata.validate` is used to make sure no local invalid metadata is
        published to CKAN. The `config.toml` `api_key` variable must be set
        at the `[ckan]` section for this method to work.

        Returns:
            dict:
                In case of success, a `dict` with the modified data
                is returned.

        Raises:
            BaseDosDadosException:
                In case of CKAN's ValidationError or
                NotAuthorized exceptions.
        """

        if not self.CKAN_API_KEY:
            raise BaseDosDadosException(
                "You can't use `Metadata.publish` without setting an `api_key`"
                "in your ~/.basedosdados/config.toml. Please set it like this:"
                '\n\n```\n[ckan]\nurl="<CKAN_URL>"\napi_key="<API_KEY>"\n```'
            )

        ckan = RemoteCKAN(self.CKAN_URL, apikey=self.CKAN_API_KEY)

        try:
            self.validate()

            metadata = self.updated_metadata.copy()

            if "id" not in metadata:
                return ckan.action.package_create(**metadata)

            return ckan.action.package_update(**metadata)

        except (BaseDosDadosException, ValidationError) as e:
            raise BaseDosDadosException(
                f"Could not publish metadata due to a validation error. Pleas"
                f"e see the traceback below to get information on how to corr"
                f"ect it.\n\n{repr(e)}"
            )
        except NotAuthorized as e:
            raise BaseDosDadosException(
                f"Could not publish metadata due to an authorization error. P"
                f"lease check if you set the `api_key` at the `[ckan]` sectio"
                f"n of your ~/.basedosdados/config.toml correctly. You must b"
                f"e an authorized user to publish modifications to a dataset "
                f"or table's metadata."
            )


###############################################################################
# Helper Functions
###############################################################################


def handle_data(k, schema, data, local_default=None):
    """"""

    # If no data is found for that key, uses local default
    selected = data.get(k, local_default)

    # In some cases like `tags`, `groups`, `organization`
    # the API default is to return a dict or list[dict] with all info.
    # But, we just use `name` to build the yaml
    _selected = deepcopy(selected)

    if _selected == []:
        return _selected

    if not isinstance(_selected, list):
        _selected = [_selected]

    if isinstance(_selected[0], dict):
        return [s.get("name") for s in _selected]

    return selected


def handle_complex_fields(yaml_obj, k, properties, definitions, data):
    """"""

    yaml_obj[k] = ryaml.CommentedMap()

    # Parsing 'allOf': [{'$ref': '#/definitions/PublishedBy'}]
    # To get PublishedBy
    d = properties[k]["allOf"][0]["$ref"].split("/")[-1]
    if "properties" in definitions[d].keys():
        for dk, dv in definitions[d]["properties"].items():
            yaml_obj[k][dk] = handle_data(
                dk,
                definitions[d]["properties"],
                data.get(k, {}),
            )

    return yaml_obj


def add_yaml_property(
    yaml: CommentedMap,
    properties: dict = {},
    definitions: dict = {},
    metadata: dict = {},
    goal=None,
    has_column=False,
):
    """Recursivelly adds properties to yaml to maintain order"""

    # Looks for the key
    # If goal is none has to look for id_before == None
    pkey = ""
    for key, property in properties.items():
        goal_was_reached = key == goal
        goal_was_reached |= property["yaml_order"]["id_before"] == None

        if goal_was_reached:
            if "allOf" in property:
                yaml = handle_complex_fields(
                    yaml,
                    key,
                    properties,
                    definitions,
                    metadata,
                )

                if yaml[key] == ordereddict():
                    yaml[key] = handle_data(key, properties, metadata)
            else:
                yaml[key] = handle_data(key, properties, metadata)

            # Add comments
            comment = None
            if not has_column:
                description = properties[key].get("description", [])
                comment = "\n" + "".join(description)
            yaml.yaml_set_comment_before_after_key(key, before=comment)
            pkey = key
            break

    # Return a ruaml object when property doesn't point to any other property
    id_after = properties[pkey]["yaml_order"]["id_after"]

    if id_after is None:
        return yaml
    elif id_after not in properties.keys():
        raise BaseDosDadosException(
            f"Inconsistent YAML ordering: {id_after} is pointed to by {pkey}"
            f" but doesn't have itself a `yaml_order` field in the JSON S"
            f"chema."
        )
    else:
        updated_props = deepcopy(properties)
        updated_props.pop(pkey)
        return add_yaml_property(
            yaml,
            updated_props,
            definitions,
            metadata,
            goal=id_after,
            has_column=has_column,
        )


def build_yaml_object(
    dataset_id: str,
    table_id: str,
    config: dict,
    schema: dict,
    metadata: dict = dict(),
    columns_schema: dict = dict(),
    partition_columns: list = list(),
):
    """Build a dataset_config.yaml or table_config.yaml"""

    properties: dict = schema["properties"]
    definitions: dict = schema["definitions"]

    # Drop all properties without yaml_order
    properties = {
        key: value for key, value in properties.items() if value.get("yaml_order")
    }

    # Add properties
    yaml = add_yaml_property(
        ryaml.CommentedMap(),
        properties,
        definitions,
        metadata,
    )

    # Add columns
    if metadata.get("columns"):
        yaml["columns"] = []
        for metadatum in metadata.get("columns", []):
            properties = add_yaml_property(
                ryaml.CommentedMap(),
                columns_schema["properties"],
                columns_schema["definitions"],
                metadatum,
                has_column=True,
            )
            yaml["columns"].append(properties)

    # Add partitions in case of new dataset/table or local overwriting
    if partition_columns and partition_columns != ["[]"]:
        yaml["partitions"] = ""
        for local_column in partition_columns:
            for remote_column in yaml.get("columns", []):
                if remote_column["name"] == local_column:
                    remote_column["is_partition"] = True
        yaml["partitions"] = ", ".join(partition_columns)

    # Nullify `partitions` field in case of other-than-None empty values
    if yaml.get("partitions") == "":
        yaml["partitions"] = None

    # Add dataset_id and table_id
    yaml["dataset_id"] = dataset_id
    if table_id:
        yaml["table_id"] = table_id

        # Add gcloud config variables
        yaml["source_bucket_name"] = str(config.get("bucket_name"))
        yaml["project_id_prod"] = str(
            config.get("gcloud-projects", {}).get("prod", {}).get("name")
        )
        yaml["project_id_staging"] = str(
            config.get("gcloud-projects", {}).get("staging", {}).get("name")
        )

    return yaml
