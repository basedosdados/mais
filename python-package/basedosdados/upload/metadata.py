"""
Class to manage the metadata of datasets and tables
"""
# pylint: disable=fixme, invalid-name, redefined-builtin, too-many-arguments, undefined-loop-variable
from __future__ import annotations

from copy import deepcopy
from functools import lru_cache
from loguru import logger

import requests
from ckanapi import RemoteCKAN
from ckanapi.errors import NotAuthorized, ValidationError
from ruamel.yaml.comments import CommentedMap
from ruamel.yaml.compat import ordereddict
import ruamel.yaml as ryaml

from basedosdados.exceptions import BaseDosDadosException
from basedosdados.upload.base import Base


class Metadata(Base):
    """
    Manage metadata in CKAN backend.
    """

    def __init__(self, dataset_id, table_id=None, **kwargs):
        super().__init__(**kwargs)

        self.table_id = table_id
        self.dataset_id = dataset_id

        if self.table_id:
            self.dataset_metadata_obj = Metadata(self.dataset_id, **kwargs)

        url = "https://basedosdados.org"
        self.CKAN_API_KEY = self.config.get("ckan", {}).get("api_key")
        self.CKAN_URL = self.config.get("ckan", {}).get("url", "") or url

    @property
    def filepath(self) -> str:
        """Build the dataset or table filepath"""

        filename = "dataset_config.yaml"
        if self.table_id:
            filename = f"{self.table_id}/table_config.yaml"
        return self.metadata_path / self.dataset_id / filename

    @property
    def local_metadata(self) -> dict:
        """Load dataset or table local metadata"""

        if self.filepath.exists():
            with open(self.filepath, "r", encoding="utf-8") as file:
                return ryaml.safe_load(file.read())
        return {}

    @property
    def ckan_metadata(self) -> dict:
        """Load dataset or table metadata from Base dos Dados CKAN"""

        ckan_dataset, ckan_table = self.ckan_metadata_extended
        return ckan_table or ckan_dataset

    @property
    def ckan_metadata_extended(self) -> dict:
        """Load dataset and table metadata from Base dos Dados CKAN"""

        dataset_id = self.dataset_id.replace("_", "-")
        url = f"{self.CKAN_URL}/api/3/action/package_show?id={dataset_id}"

        ckan_response = requests.get(url, timeout=10).json()
        dataset = ckan_response.get("result")

        if not ckan_response.get("success"):
            return {}, {}

        if self.table_id:
            for resource in dataset["resources"]:
                if resource["name"] == self.table_id:
                    return dataset, resource

        return dataset, {}

    @property
    def owner_org(self):
        """
        Build `owner_org` field for each use case: table, dataset, new
        or existing.
        """

        # in case `self` refers to a CKAN table's metadata
        if self.table_id and self.exists_in_ckan():
            return self.dataset_metadata_obj.ckan_metadata.get("owner_org")

        # in case `self` refers to a new table's metadata
        if self.table_id and not self.exists_in_ckan():
            if self.dataset_metadata_obj.exists_in_ckan():
                return self.dataset_metadata_obj.ckan_metadata.get("owner_org")
            # mock `owner_org` for validation
            return "3626e93d-165f-42b8-bde1-2e0972079694"

        # for datasets, `owner_org` must come from the YAML file
        organization_id = "".join(self.local_metadata.get("organization") or [])
        url = f"{self.CKAN_URL}/api/3/action/organization_show?id={organization_id}"
        response = requests.get(url, timeout=10).json()

        if not response.get("success"):
            raise BaseDosDadosException("Organization not found")

        owner_org = response.get("result", {}).get("id")

        return owner_org

    @property
    def ckan_data_dict(self) -> dict:
        """Helper function that structures local metadata for validation"""

        ckan_dataset, ckan_table = self.ckan_metadata_extended

        metadata = {
            "id": ckan_dataset.get("id"),
            "name": ckan_dataset.get("name") or self.dataset_id.replace("_", "-"),
            "type": ckan_dataset.get("type") or "dataset",
            "title": self.local_metadata.get("title"),
            "private": ckan_dataset.get("private") or False,
            "owner_org": self.owner_org,
            "resources": ckan_dataset.get("resources", [])
            or [{"resource_type": "external_link", "name": ""}]
            or [{"resource_type": "information_request", "name": ""}],
            "groups": [
                {"name": group} for group in self.local_metadata.get("groups", []) or []
            ],
            "tags": [
                {"name": tag} for tag in self.local_metadata.get("tags", []) or []
            ],
            "organization": {"name": self.local_metadata.get("organization")},
            "extras": [
                {
                    "key": "dataset_args",
                    "value": {
                        "short_description": self.local_metadata.get(
                            "short_description"
                        ),
                        "description": self.local_metadata.get("description"),
                        "ckan_url": self.local_metadata.get("ckan_url"),
                        "github_url": self.local_metadata.get("github_url"),
                    },
                }
            ],
        }

        if self.table_id:
            metadata["resources"] = [
                {
                    "id": ckan_table.get("id"),
                    "description": self.local_metadata.get("description"),
                    "name": self.local_metadata.get("table_id"),
                    "resource_type": ckan_table.get("resource_type") or "bdm_table",
                    "version": self.local_metadata.get("version"),
                    "dataset_id": self.local_metadata.get("dataset_id"),
                    "table_id": self.local_metadata.get("table_id"),
                    "spatial_coverage": self.local_metadata.get("spatial_coverage"),
                    "temporal_coverage": self.local_metadata.get("temporal_coverage"),
                    "update_frequency": self.local_metadata.get("update_frequency"),
                    "observation_level": self.local_metadata.get("observation_level"),
                    "last_updated": self.local_metadata.get("last_updated"),
                    "published_by": self.local_metadata.get("published_by"),
                    "data_cleaned_by": self.local_metadata.get("data_cleaned_by"),
                    "data_cleaning_description": self.local_metadata.get(
                        "data_cleaning_description"
                    ),
                    "data_cleaning_code_url": self.local_metadata.get(
                        "data_cleaning_code_url"
                    ),
                    "partner_organization": self.local_metadata.get(
                        "partner_organization"
                    ),
                    "raw_files_url": self.local_metadata.get("raw_files_url"),
                    "auxiliary_files_url": self.local_metadata.get(
                        "auxiliary_files_url"
                    ),
                    "architecture_url": self.local_metadata.get("architecture_url"),
                    "source_bucket_name": self.local_metadata.get("source_bucket_name"),
                    "project_id_prod": self.local_metadata.get("project_id_prod"),
                    "project_id_staging": self.local_metadata.get("project_id_staging"),
                    "partitions": self.local_metadata.get("partitions"),
                    "uncompressed_file_size": self.local_metadata.get(
                        "uncompressed_file_size"
                    ),
                    "compressed_file_size": self.local_metadata.get(
                        "compressed_file_size"
                    ),
                    "columns": self.local_metadata.get("columns"),
                    "metadata_modified": self.local_metadata.get("metadata_modified"),
                    "package_id": ckan_dataset.get("id"),
                }
            ]

        return metadata

    @property
    @lru_cache(256)
    def columns_schema(self) -> dict:
        """Returns a dictionary with the schema of the columns"""

        url = f"{self.CKAN_URL}/api/3/action/bd_bdm_columns_schema"

        return requests.get(url, timeout=10).json().get("result")

    @property
    @lru_cache(256)
    def metadata_schema(self) -> dict:
        """Get metadata schema from CKAN API endpoint"""

        if self.table_id:
            table_url = f"{self.CKAN_URL}/api/3/action/bd_bdm_table_schema"
            return requests.get(table_url, timeout=10).json().get("result")

        dataset_url = f"{self.CKAN_URL}/api/3/action/bd_dataset_schema"
        return requests.get(dataset_url, timeout=10).json().get("result")

    def exists_in_ckan(self) -> bool:
        """Check if Metadata object refers to an existing CKAN package or reso
        urce.

        Returns:
            bool: The existence condition of the metadata in CKAN. `True` if i
            t exists, `False` otherwise.
        """

        if self.table_id:
            url = f"{self.CKAN_URL}/api/3/action/bd_bdm_table_show?"
            url += f"dataset_id={self.dataset_id}&table_id={self.table_id}"
        else:
            id = self.dataset_id.replace("_", "-")
            # TODO: use `bd_bdm_dataset_show` when it's available for empty packages
            url = f"{self.CKAN_URL}/api/3/action/package_show?id={id}"

        exists_in_ckan = requests.get(url, timeout=10).json().get("success")

        return exists_in_ckan

    def is_updated(self) -> bool:
        """Check if a dataset or table is updated

        Returns:
            bool: The update condition of local metadata. `True` if it corresp
            onds to the most recent version of the given table or dataset's me
            tadata in CKAN, `False` otherwise.
        """

        if not self.local_metadata.get("metadata_modified"):
            return bool(not self.exists_in_ckan())
        ckan_modified = self.ckan_metadata.get("metadata_modified")
        local_modified = self.local_metadata.get("metadata_modified")
        return ckan_modified == local_modified

    def create(
        self,
        if_exists: str = "raise",
        columns: list = None,
        partition_columns: list = None,
        force_columns: bool = False,
        table_only: bool = True,
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
                A `list` with the name of the table columns that partition the
                 data.
            force_columns (bool): Optional.
                If set to `True`, overwrite CKAN's columns with the ones provi
                ded.
                If set to `False`, keep CKAN's columns instead of the ones pro
                vided.
            table_only (bool): Optional. If set to `True`, only `table_config.
                yaml` is created, even if there is no `dataset_config.yaml` fo
                r the correspondent dataset metadata. If set to `False`, both
                files are created if `dataset_config.yaml` doesn't exist yet.
                Defaults to `True`.

        Returns:
            Metadata: An instance of the `Metadata` class.

        Raises:
            FileExistsError: If the correspodent YAML configuration file alrea
            dy exists and `if_exists` is set to `"raise"`.
        """

        # see: https://docs.python.org/3/reference/compound_stmts.html#function-definitions
        columns = [] if columns is None else columns
        partition_columns = [] if partition_columns is None else partition_columns

        if self.filepath.exists() and if_exists == "raise":
            raise FileExistsError(
                f"{self.filepath} already exists."
                + " Set the arg `if_exists` to `replace` to replace it."
            )
        if if_exists != "pass":
            ckan_metadata = self.ckan_metadata

            # Add local columns if
            # 1. columns is empty and
            # 2. force_columns is True

            # TODO: Is this sufficient to add columns?
            if self.table_id and (force_columns or not ckan_metadata.get("columns")):
                ckan_metadata["columns"] = [{"name": c} for c in columns]

            yaml_obj = build_yaml_object(
                dataset_id=self.dataset_id,
                table_id=self.table_id,
                config=self.config,
                schema=self.metadata_schema,
                metadata=ckan_metadata,
                columns_schema=self.columns_schema,
                partition_columns=partition_columns,
            )

            self.filepath.parent.mkdir(parents=True, exist_ok=True)

            with open(self.filepath, "w", encoding="utf-8") as file:
                ruamel = ryaml.YAML()
                ruamel.preserve_quotes = True
                ruamel.indent(mapping=4, sequence=6, offset=4)
                ruamel.dump(yaml_obj, file)

            # if `dataset_config.yaml` doesn't exist but user wants to create
            # it alongside `table_config.yaml`
            dataset_config_exists = (
                self.metadata_path / self.dataset_id / "dataset_config.yaml"
            ).exists()
            if self.table_id and not table_only and not dataset_config_exists:
                self.dataset_metadata_obj.create(if_exists=if_exists)

            logger.success(
                " {object} {object_id} was {action}!",
                object_id=self.table_id,
                object="Metadata",
                action="created",
            )

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

        ckan = RemoteCKAN(self.CKAN_URL, user_agent="", apikey=None)
        response = ckan.action.bd_dataset_validate(**self.ckan_data_dict)

        if response.get("errors"):
            error = {self.ckan_data_dict.get("name"): response["errors"]}
            message = f"{self.filepath} has validation errors: {error}"
            raise BaseDosDadosException(message)

        logger.success(
            " {object} {object_id} was {action}!",
            object_id=self.table_id,
            object="Metadata",
            action="validated",
        )

        return True

    def publish(
        self,
        all: bool = False,
        if_exists: str = "raise",
        update_locally: bool = False,
    ) -> dict:
        """Publish local metadata modifications.
        `Metadata.validate` is used to make sure no local invalid metadata is
        published to CKAN. The `config.toml` `api_key` variable must be set
        at the `[ckan]` section for this method to work.

        Args:
            all (bool): Optional. If set to `True`, both `dataset_config.yaml`
                and `table_config.yaml` are published for the given dataset_id
                and table_id.
            if_exists (str): Optional. What to do if config exists
                * raise : Raises BaseDosDadosException if metadata already exi
                sts in CKAN
                * replace : Overwrite metadata in CKAN if it exists
                * pass : Do nothing
            update_locally (bool): Optional. If set to `True`, update the local
                metadata with the one published to CKAN.

        Returns:
            dict:
                In case of success, a `dict` with the modified data
                is returned.

        Raises:
            BaseDosDadosException:
                In case of CKAN's ValidationError or
                NotAuthorized exceptions.
        """

        # alert user if they don't have an api_key set up yet
        if not self.CKAN_API_KEY:
            raise BaseDosDadosException(
                "You can't use `Metadata.publish` without setting an `api_key`"
                "in your ~/.basedosdados/config.toml. Please set it like this:"
                '\n\n```\n[ckan]\nurl="<CKAN_URL>"\napi_key="<API_KEY>"\n```'
            )

        # check if metadata exists in CKAN and handle if_exists options
        if self.exists_in_ckan():
            if if_exists == "raise":
                raise BaseDosDadosException(
                    f"{self.dataset_id or self.table_id} already exists in CKAN."
                    f" Set the arg `if_exists` to `replace` to replace it."
                )
            if if_exists == "pass":
                return {}

        ckan = RemoteCKAN(self.CKAN_URL, user_agent="", apikey=self.CKAN_API_KEY)

        try:
            self.validate()

            assert self.is_updated(), (
                f"Could not publish metadata due to out-of-date config file. "
                f"Please run `basedosdados metadata create {self.dataset_id} "
                f"{self.table_id or ''}` to get the most recently updated met"
                f"adata and apply your changes to it."
            )

            data_dict = self.ckan_data_dict.copy()

            if self.table_id:

                # publish dataset metadata first if user wants to publish both
                if all:
                    self.dataset_metadata_obj.publish(if_exists=if_exists)

                data_dict = data_dict["resources"][0]

                published = ckan.call_action(
                    action="resource_patch"
                    if self.exists_in_ckan()
                    else "resource_create",
                    data_dict=data_dict,
                )

            else:
                data_dict["resources"] = []

                published = ckan.call_action(
                    action="package_patch"
                    if self.exists_in_ckan()
                    else "package_create",
                    data_dict=data_dict,
                )

            # recreate local metadata YAML file with the published data
            if published and update_locally:
                self.create(if_exists="replace")
                self.dataset_metadata_obj.create(if_exists="replace")

            logger.success(
                " {object} {object_id} was {action}!",
                object_id=data_dict,
                object="Metadata",
                action="published",
            )

            return published

        except (BaseDosDadosException, ValidationError) as e:
            message = (
                f"Could not publish metadata due to a validation error. Pleas"
                f"e see the traceback below to get information on how to corr"
                f"ect it.\n\n{repr(e)}"
            )
            raise BaseDosDadosException(message) from e

        except NotAuthorized as e:
            message = (
                "Could not publish metadata due to an authorization error. Pl"
                "ease check if you set the `api_key` at the `[ckan]` section "
                "of your ~/.basedosdados/config.toml correctly. You must be a"
                "n authorized user to publish modifications to a dataset or t"
                "able's metadata."
            )
            raise BaseDosDadosException(message) from e


###############################################################################
# Helper Functions
###############################################################################


def handle_data(k, data, local_default=None):
    """Parse API's response data so that it is used in the YAML configuration
    files.

    Args:
        k (str): a key of the CKAN API's response metadata dictionary.
        data (dict): a dictionary of metadata generated from the API.
        local_default (Any): the default value of the given key in ca
            se its value is set to `None` in CKAN.

    Returns:
        list: a list of metadata values
    """

    # If no data is None then return a empty dict
    data = data if data is not None else {}
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
        if _selected[0].get("id") is not None:
            return [s.get("name") for s in _selected]

    return selected


def handle_complex_fields(yaml_obj, k, properties, definitions, data):
    """Parse complex fields and send each part of them to `handle_data`.

    Args:
        yaml_obj (ruamel.yaml.CommentedMap): A YAML object with complex fields
            .
        k (str): The name of the key of the complex field.
        properties (dict): A dictionary that contains the description of the c
            omplex field.
        definitions (dict): A dictionary with the schemas of the each component
            of the complex field.
        data (dict): A dictionary with the metadata of the complex field.

    Returns:
        CommentedMap: A YAML object augmented with the complex field.
    """

    yaml_obj[k] = ryaml.CommentedMap()

    # Parsing 'allOf': [{'$ref': '#/definitions/PublishedBy'}]
    # To get PublishedBy
    d = properties[k]["allOf"][0]["$ref"].split("/")[-1]
    if "properties" in definitions[d].keys():
        for dk, _ in definitions[d]["properties"].items():

            yaml_obj[k][dk] = handle_data(
                k=dk,
                data=data.get(k, {}),
            )

    return yaml_obj


def add_yaml_property(
    yaml: CommentedMap,
    properties: dict = None,
    definitions: dict = None,
    metadata: dict = None,
    goal=None,
    has_column=False,
):
    """Recursivelly adds properties to yaml to maintain order.

    Args:
        yaml (CommentedMap): A YAML object with complex fields.
        properties (dict): A dictionary that contains the description of the c
            omplex field.
        definitions (dict): A dictionary with the schemas of each complex fiel
            d.
        metadata (dict): A dictionary with the metadata to fill the YAML.
        goal (str): The next key to be added to the YAML.
        has_column (bool): If the goal is a column, no comments are written.
    """

    # see: https://docs.python.org/3/reference/compound_stmts.html#function-definitions
    properties = {} if properties is None else properties
    definitions = {} if definitions is None else definitions
    metadata = {} if metadata is None else metadata

    # Looks for the key
    # If goal is none has to look for id_before == None
    for key, property in properties.items():
        goal_was_reached = key == goal
        goal_was_reached |= property["yaml_order"]["id_before"] is None

        if goal_was_reached:
            if "allOf" in property:
                yaml = handle_complex_fields(
                    yaml_obj=yaml,
                    k=key,
                    properties=properties,
                    definitions=definitions,
                    data=metadata,
                )

                if yaml[key] == ordereddict():
                    yaml[key] = handle_data(k=key, data=metadata)
            else:
                yaml[key] = handle_data(k=key, data=metadata)

            # Add comments
            comment = None
            if not has_column:
                description = properties[key].get("description", [])
                comment = "\n" + "".join(description)
            yaml.yaml_set_comment_before_after_key(key, before=comment)
            break

    # Return a ruaml object when property doesn't point to any other property
    id_after = properties[key]["yaml_order"]["id_after"]

    if id_after is None:
        return yaml
    if id_after not in properties.keys():
        raise BaseDosDadosException(
            f"Inconsistent YAML ordering: {id_after} is pointed to by {key}"
            f" but doesn't have itself a `yaml_order` field in the JSON S"
            f"chema."
        )
    updated_props = deepcopy(properties)
    updated_props.pop(key)
    return add_yaml_property(
        yaml=yaml,
        properties=updated_props,
        definitions=definitions,
        metadata=metadata,
        goal=id_after,
        has_column=has_column,
    )


def build_yaml_object(
    dataset_id: str,
    table_id: str,
    config: dict,
    schema: dict,
    metadata: dict = None,
    columns_schema: dict = None,
    partition_columns: list = None,
):
    """Build a dataset_config.yaml or table_config.yaml

    Args:
        dataset_id (str): The dataset id.
        table_id (str): The table id.
        config (dict): A dict with the `basedosdados` client configurations.
        schema (dict): A dict with the JSON Schema of the dataset or table.
        metadata (dict): A dict with the metadata of the dataset or table.
        columns_schema (dict): A dict with the JSON Schema of the columns of
            the table.
        partition_columns (list): A list with the partition columns of the
            table.

    Returns:
        CommentedMap: A YAML object with the dataset or table metadata.
    """

    # see: https://docs.python.org/3/reference/compound_stmts.html#function-definitions
    metadata = {} if metadata is None else metadata
    columns_schema = {} if columns_schema is None else columns_schema
    partition_columns = [] if partition_columns is None else partition_columns

    properties: dict = schema["properties"]
    definitions: dict = schema["definitions"]

    # Drop all properties without yaml_order
    properties = {
        key: value for key, value in properties.items() if value.get("yaml_order")
    }

    # Add properties
    yaml = add_yaml_property(
        yaml=ryaml.CommentedMap(),
        properties=properties,
        definitions=definitions,
        metadata=metadata,
    )

    # Add columns
    if metadata.get("columns"):
        yaml["columns"] = []
        for metadatum in metadata.get("columns"):
            properties = add_yaml_property(
                yaml=ryaml.CommentedMap(),
                properties=columns_schema["properties"],
                definitions=columns_schema["definitions"],
                metadata=metadatum,
                has_column=True,
            )
            yaml["columns"].append(properties)

    # Add partitions in case of new dataset/talbe or local overwriting
    if partition_columns and partition_columns != ["[]"]:
        yaml["partitions"] = ""
        for local_column in partition_columns:
            for remote_column in yaml["columns"]:
                if remote_column["name"] == local_column:
                    remote_column["is_partition"] = True
        yaml["partitions"] = partition_columns

    # Nullify `partitions` field in case of other-than-None empty values
    if yaml.get("partitions") == "":
        yaml["partitions"] = None

    if table_id:
        # Add dataset_id and table_id
        yaml["dataset_id"] = dataset_id
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
