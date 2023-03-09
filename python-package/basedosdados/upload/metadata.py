"""
Class to manage the metadata of datasets and tables
"""
# pylint: disable=fixme, invalid-name, redefined-builtin, too-many-arguments, undefined-loop-variable, too-many-lines
from __future__ import annotations

import json

from copy import deepcopy
from datetime import datetime
from functools import lru_cache
from pathlib import Path
from typing import Tuple, Dict, Any, List

from loguru import logger

from ckanapi.errors import NotAuthorized, ValidationError
from ruamel.yaml.comments import CommentedMap
from ruamel.yaml.compat import ordereddict
import ruamel.yaml as ryaml

from basedosdados.exceptions import BaseDosDadosException
from basedosdados.upload.base import Base
from basedosdados.upload.remoteapi import RemoteAPI


class Metadata(Base):
    """
    Manage metadata in CKAN backend.
    """

    def __init__(self, dataset_id, table_id=None, **kwargs):
        super().__init__(**kwargs)

        self.dataset_uuid = self._get_dataset_id_from_slug(dataset_id)
        self.table_uuid = None

        self.table_id = table_id
        self.dataset_id = dataset_id

        if self.table_id:
            self.table_uuid = self._get_table_id_from_slug(dataset_id, table_id)
            self.dataset_metadata_obj = Metadata(self.dataset_id, **kwargs)

        url = "https://basedosdados.org"
        self.CKAN_API_KEY = self.config.get("ckan", {}).get("api_key")
        self.CKAN_URL = self.config.get("ckan", {}).get("url", "") or url

    def _get_nodes_from_edges(
        self,
        key: str,
        edge: Dict[str, Any],
    ) -> List[dict]:
        """
        Helper function to get nodes from edges and return a list
        of nodes with the given key.
        Args:
            key (str): Key to get from nodes.
            edge (Dict[str, Any]): Edge to get nodes from.
        Returns:
            List[dict]: List of nodes with the given key.
        """
        if not edge or not key:
            return []

        return [node["node"].get(key) for _, nodes in edge.items() for node in nodes]

    @property
    def filepath(self) -> Path:
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
    def api_metadata(self) -> dict:
        """Load dataset or table metadata from Base dos Dados API"""

        api_dataset, api_table = self.api_metadata_extended
        if not api_dataset:
            return {}
        api_dataset["organization_id"] = api_dataset["organization"]["_id"]
        api_dataset["organization"] = api_dataset["organization"]["slug"]
        if api_table:
            api_table[
                "update_frequency"
            ] = f"{api_table['update_frequency']['number']} {api_table['update_frequency']['period']['name'].lower()}"
            api_table["partitions"] = [
                partition["name"] for partition in api_table["partitions"]
            ]
            api_table["metadata_modified"] = api_table["metadata_modified"].split("T")[0]
            for idx, column in enumerate(api_table["columns"]):
                api_table["columns"][idx]["bigquery_type"] = column["bigquery_type"][
                    "title"
                ].lower()
        else:
            api_dataset["notes"] = api_dataset["description"]
            api_dataset["themes"] = [theme["slug"] for theme in api_dataset["themes"]]
            api_dataset["tags"] = [tag["slug"] for tag in api_dataset["tags"]]
            api_dataset["metadata_modified"] = api_dataset["metadata_modified"].split(
                "T"
            )[0]
        return api_table or api_dataset

    @property
    def api_metadata_extended(self) -> Tuple[dict, dict]:
        """Load dataset or table metadata from Base dos Dados API"""

        if not self.dataset_uuid:
            return {}, {}

        with open(
            self.graphql_queries_path / "dataset_table_by_id.graphql",
            "r",
            encoding="utf-8",
        ) as file:
            query = file.read()

        variables = {"id": self.dataset_uuid}
        api_response = self._get_graphql(query, variables)
        dataset = api_response.get("allDataset")
        if not dataset or len(dataset) == 0:
            return {}, {}

        if self.table_uuid:
            for table in dataset[0]["tables"]:
                if table["_id"] == self.table_uuid:
                    return dataset[0], table

        return dataset[0], {}

    @property
    def owner_org(self):
        """
        Build `owner_org` field for each use case: table, dataset, new
        or existing.
        """

        # in case `self` refers to a CKAN table's metadata
        if self.table_id and self.exists():
            return self.dataset_metadata_obj.api_metadata.get("organization_id")

        # in case `self` refers to a new table's metadata
        if self.table_id and not self.exists():
            if self.dataset_metadata_obj.exists():
                return self.dataset_metadata_obj.api_metadata.get("organization_id")
            # mock `owner_org` for validation
            # return "3626e93d-165f-42b8-bde1-2e0972079694"

        # for datasets, `owner_org` must come from the YAML file
        organization_id = "".join(self.local_metadata.get("organization") or [])

        if not organization_id:
            raise BaseDosDadosException("No organization found in YAML file.")

        with open(
            self.graphql_queries_path / "organization_by_id.graphql",
            "r",
            encoding="utf-8",
        ) as file:
            query = file.read()

        variables = {"organization_id": organization_id}

        response = self._get_graphql(query=query, variables=variables)

        if not response:
            raise BaseDosDadosException("Organization not found")

        owner_org = response.get("allOrganization")

        if not owner_org:
            raise BaseDosDadosException("Organization not found")

        return owner_org[0].get("_id")

    @property
    def api_data_dict(self) -> Dict[str, Any]:
        """
        Helper function that structures local metadata
        TODO: must be adapted to use translation. Also needed to check the difference between `namePt` and `title` in the YAML file.
        """

        api_dataset, api_table = self.api_metadata_extended

        metadata = {
            "id": api_dataset.get("_id"),
            "slug": api_dataset.get("slug") or self.local_metadata.get("dataset_slug"),
            "name": api_dataset.get("name") or self.local_metadata.get("name"),
            "type": api_dataset.get("__typename") or "Dataset",
            "namePt": api_dataset.get("namePt"),
            # "title": self.local_metadata.get("title"),
            # "private": False,  [DEPRECATED]
            "owner_org": api_dataset.get("organization", {}).get(
                "_id"
            ) or self.local_metadata.get("organization"),
            # "resources": [],  [DEPRECATED]
            "themes": api_dataset.get("themes", {}) or self.local_metadata.get("themes"),
            "tags": api_dataset.get("tags", {}) or self.local_metadata.get("tags"),
            "organization": {"name": api_dataset.get("organization")},
            "description": api_dataset.get("description") or self.local_metadata.get("description"),
            # "ckan_url": self.local_metadata.get("url_ckan"),  [DEPRECATED]
            # "github_url": self.local_metadata.get("url_github"),  [DEPRECATED]
            "created_at": datetime.fromisoformat(
                api_dataset.get("created_at")
            ).strftime("%Y-%m-%d %H:%M:%S")
            if api_dataset.get("created_at")
            else None,
            "updated_at": datetime.fromisoformat(
                api_dataset.get("updated_at")
            ).strftime("%Y-%m-%d %H:%M:%S")
            if api_dataset.get("updated_at")
            else None,
            "tables": [],
        }

        if self.table_id:
            metadata["tables"].append(
                {
                    "id": self.table_uuid,
                    "dataset_slug": api_table.get("dataset_slug") or self.local_metadata.get("dataset_slug"),
                    "table_slug": api_table.get("table_slug") or self.local_metadata.get("table_slug"),
                    "name": api_table.get("name") or self.local_metadata.get("name"),
                    "description": api_table.get("description") or self.local_metadata.get("description"),
                    "resource_type": api_table.get("__typename"),
                    # "version": api_table.get("version"),  # [DEPRECATED]
                    "dataset_id": self.dataset_uuid,
                    "table_id": self.table_id,
                    "spatial_coverage": api_table.get(
                        "spatialCoverage"
                    ),  # TODO: not implemented yet
                    "temporal_coverage": api_table.get(
                        "temporalCoverage"
                    ),  # TODO: not implemented yet
                    "update_frequency": api_table.get(
                        "updateFrequency"
                    ),  # TODO: not implemented yet
                    "observation_level": api_table.get(
                        "observationLevel"
                    ),  # TODO: not implemented yet
                    "last_updated": api_table.get("updatedAt"),
                    # "published_by": api_table.get(
                    #     "publishedBy"
                    # ),  # TODO: not implemented yet
                    # "data_cleaned_by": api_table.get(
                    #     "dataCleanedBy"
                    # ),  # TODO: not implemented yet
                    "data_cleaning_description": api_table.get(
                        "dataCleaningDescription"
                    ) or self.local_metadata.get("data_cleaning_description"),
                    "data_cleaning_code_url": api_table.get(
                        "dataCleaningCodeUrl"
                    ) or self.local_metadata.get("data_cleaning_code_url"),
                    "partner_organization": api_table.get(
                        "partnerOrganization"
                    ),  # TODO: not implemented yet
                    "raw_files_url": api_table.get(
                        "rawFilesUrl"
                    ) or self.local_metadata.get("raw_files_url"),
                    "auxiliary_files_url": api_table.get(
                        "auxiliaryFilesUrl"
                    ) or self.local_metadata.get("auxiliary_files_url"),
                    "architecture_url": api_table.get(
                        "architectureUrl"
                    ) or self.local_metadata.get("architecture_url"),
                    "source_bucket_name": api_table.get(
                        "sourceBucketName"
                    ) or self.local_metadata.get("source_bucket_name"),
                    "project_id_prod": api_table.get(
                        "projectIdProd"
                    ) or self.local_metadata.get("project_id_prod"),
                    "project_id_staging": api_table.get(
                        "projectIdStaging"
                    ) or self.local_metadata.get("project_id_staging"),
                    "partitions": api_table.get(
                        "partitions"
                    ) or self.local_metadata.get("partitions"),
                    "uncompressed_file_size": api_table.get(
                        "uncompressedFileSize"
                    ),  # TODO: not implemented yet
                    "compressed_file_size": api_table.get(
                        "compressedFileSize"
                    ),  # TODO: not implemented yet
                    "metadata_modified": api_table.get(
                        "updatedAt"
                    ),  # TODO: check the correct times
                    "created_at": datetime.fromisoformat(
                        api_dataset.get("created_at")
                    ).strftime("%Y-%m-%d %H:%M:%S")
                    if api_dataset.get("created_at")
                    else None,
                    "updated_at": datetime.fromisoformat(
                        api_dataset.get("updated_at")
                    ).strftime("%Y-%m-%d %H:%M:%S")
                    if api_dataset.get("updated_at")
                    else None,
                    "columns": api_table.get("columns") or self.local_metadata.get("columns"),
                }
            )

        return metadata

    @property
    @lru_cache(256)
    def columns_schema(self) -> dict:
        """
        Returns a dictionary with the schema of the columns
        To keep compatibility with the old metadata schema, the schema is
        read from a local file. In the future, this should be read from
        the API endpoint.
        """

        json_path = Path(__file__).parent.parent / "schemas/columns_schema.json"
        with open(json_path, "r", encoding="utf-8") as f:
            schema = json.loads(f.read())

        return schema.get("result")

    @property
    @lru_cache(256)
    def metadata_schema(self) -> dict:
        """
        Returns a dictionary with the schema of the metadata (table or dataset)
        To keep compatibility with the old metadata schema, the schema is
        read from a local file. In the future, this should be read from
        the API endpoint.
        """

        if self.table_id:
            json_path = Path(__file__).parent.parent / "schemas/table_schema.json"
        else:
            json_path = Path(__file__).parent.parent / "schemas/dataset_schema.json"

        with open(json_path, "r", encoding="utf-8") as f:
            schema = json.loads(f.read())

        return schema.get("result")

    def exists(self) -> bool:
        """Check if Metadata object refers to an existing dataset or table.

        The method will fetch the api to check whether the dataset or table exists.

        Returns:
            bool: The existence condition of the metadata in the API. `True` if i
            t exists, `False` otherwise.
        """
        query = """
            query ($dataset_id: String!, $table_id: String) {
              allDataset(slug: $dataset_id) {
                edges {
                  node {
                    id
                    namePt
                    tables (slug: $table_id) {
                      edges {
                        node {
                          id
                        }
                      }
                    }
                  }
                }
              }
            }
        """
        variables = {"dataset_id": self.dataset_id, "table_id": self.table_id}

        response = self._get_graphql(query, variables)

        dataset = response.get("allDataset")
        if not dataset:
            return False

        if self.table_id:
            tables = dataset[0].get("tables")
            if not tables:
                return False

        return True

    def is_updated(self) -> bool:
        """Check if a dataset or table is updated.

        The method will fetch the api to check whether the dataset or table is updated.

        Returns:
            bool: The update condition of local metadata. `True` if it corresp
            onds to the most recent version of the given table or dataset's me
            tadata in API, `False` otherwise.
        """

        api_modified = self.api_metadata.get("metadata_modified")
        local_modified = self.local_metadata.get("metadata_modified")

        return api_modified == local_modified

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
            api_metadata = self.api_metadata

            # Add local columns if
            # 1. columns is empty and
            # 2. force_columns is True

            # TODO: Is this sufficient to add columns?
            if self.table_id and (force_columns or not api_metadata.get("columns")):
                api_metadata["columns"] = [{"name": c} for c in columns]

            yaml_obj = build_yaml_object(
                dataset_id=self.dataset_uuid,
                dataset_slug=self.dataset_id,
                table_id=self.table_uuid,
                table_slug=self.table_id,
                config=self.config,
                schema=self.metadata_schema,
                metadata=api_metadata,
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
                object_id=self.table_id or self.dataset_id,
                object="Metadata",
                action="created",
            )

        return self

    def validate(self) -> bool:
        """Validate dataset_config.yaml or table_config.yaml files.
        The yaml file should be located at
        metadata_path/dataset_id[/table_id/],
        as defined in your config.toml
        TODO: check if any kind of validation is needed

        Returns:
            bool:
                True if the metadata is valid. False if it is invalid.

        Raises:
            BaseDosDadosException:
                when the file has validation errors.
        """

        # ckan = RemoteCKAN(self.CKAN_URL, user_agent="", apikey=None)
        # response = ckan.action.bd_dataset_validate(**self.ckan_data_dict)
        #
        # if response.get("errors"):
        #     error = {self.ckan_data_dict.get("name"): response["errors"]}
        #     message = f"{self.filepath} has validation errors: {error}"
        #     raise BaseDosDadosException(message)
        #
        # logger.success(
        #     " {object} {object_id} was {action}!",
        #     object_id=self.table_id,
        #     object="Metadata",
        #     action="validated",
        # )

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
        token = self.load_token()
        if not self.base_url or not token:
            raise BaseDosDadosException(
                "You can't use `Metadata.publish` without setting an `api_key`"
                "in your ~/.basedosdados/config.toml. Please set it like this:"
                '\n\n```\n[ckan]\nurl="<CKAN_URL>"\napi_key="<API_KEY>"\n```'
            )
        if not self.verify_token(token):
            # TODO: test in cli
            try:
                new_token = self.refresh_token(token)
                self.save_token(new_token)
            except Exception as e:
                print(e)
                new_token = self.get_token(username=self.username, password=None)
                self.save_token(new_token)

        # check if metadata exists in API and handle if_exists options
        if self.exists():
            if if_exists == "raise":
                raise BaseDosDadosException(
                    f"{self.dataset_id or self.table_id} already exists in CKAN."
                    f" Set the arg `if_exists` to `replace` to replace it."
                )
            if if_exists == "pass":
                return {}

        remote_api = RemoteAPI(
            self.api_graphql,
            token=self.load_token(),
        )

        try:
            self.validate()

            assert self.is_updated(), (
                f"Could not publish metadata due to out-of-date config file. "
                f"Please run `basedosdados metadata create {self.dataset_id} "
                f"{self.table_id or ''}` to get the most recently updated met"
                f"adata and apply your changes to it."
            )

            data_dict = self.api_data_dict.copy()

            if self.table_id:
                # publish dataset metadata first if user wants to publish both
                dataset_uuid = self.dataset_metadata_obj.api_data_dict["id"] or None
                if all:
                    ds_publish = self.dataset_metadata_obj.publish(if_exists=if_exists)
                    if ds_publish and dataset_uuid is None:
                        dataset_uuid = ds_publish.get("data")

                data_dict = data_dict["tables"][0]
                data_dict["dataset_id"] = dataset_uuid

                published = remote_api.call_action(
                    action="update_table"
                    if self.exists()
                    else "create_table",
                    data_dict=data_dict,
                )

            else:
                data_dict["tables"] = []

                published = remote_api.call_action(
                    action="update_dataset"
                    if self.exists()
                    else "create_dataset",
                    data_dict=data_dict,
                )

            # recreate local metadata YAML file with the published data
            if published and update_locally:
                self.create(if_exists="replace")
                if self.table_id:
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
    dataset_slug: str,
    table_id: str,
    table_slug: str,
    config: dict,
    schema: dict,
    metadata: dict = None,
    columns_schema: dict = None,
    partition_columns: list = None,
):
    """Build a dataset_config.yaml or table_config.yaml. Ids are now UUIDs.
    To keep compatibility with BigQuery, we use the previous id as the slug.

    Args:
        dataset_id (str): The dataset id.
        dataset_slug (str): The dataset slug.
        table_id (str): The table id.
        table_slug (str): The table slug.
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

    yaml["dataset_id"] = dataset_id
    yaml["dataset_slug"] = dataset_slug

    if table_id or table_slug:
        # Add dataset_id and table_id
        yaml["table_id"] = table_id
        yaml["table_slug"] = table_slug

        # Add gcloud config variables
        yaml["source_bucket_name"] = str(config.get("bucket_name"))
        yaml["project_id_prod"] = str(
            config.get("gcloud-projects", {}).get("prod", {}).get("name")
        )
        yaml["project_id_staging"] = str(
            config.get("gcloud-projects", {}).get("staging", {}).get("name")
        )

    return yaml
