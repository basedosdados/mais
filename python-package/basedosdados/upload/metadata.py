from __future__ import annotations

from collections import defaultdict
from copy import deepcopy
from functools import lru_cache
from typing import List

import requests
import ruamel.yaml as ryaml
from ckanapi import RemoteCKAN
from ckanapi.errors import NotAuthorized, ValidationError
from ruamel.yaml.compat import ordereddict

from basedosdados.exceptions import BaseDosDadosException
from basedosdados.upload.base import Base


class Metadata(Base):
    def __init__(self, dataset_id, table_id=None, **kwargs):
        super().__init__(**kwargs)

        self.table_id = table_id
        self.dataset_id = dataset_id

        url = "http://localhost:5000"  # "https://basedosdados.org"
        self.CKAN_API_KEY = self.config.get("ckan", {}).get("api_key")
        self.CKAN_URL = self.config.get("ckan", {}).get("url", "") or url

    @property
    def metadata_path(self) -> str:
        """Build the dataset or table filepath"""

        filename = "dataset_config.yaml"
        if self.table_id:
            filename = self.table_id / "table_config.yaml"
        return self.metadata_path / self.dataset_id / filename

    @property
    def local_metadata(self) -> dict:
        """Load dataset or table local metadata"""

        if self.metadata_path.exists():
            with open(self.metadata_path, "r", encoding="utf-8") as file:
                return ryaml.safe_load(file.read())
        return {}

    @property
    @lru_cache(256)
    def ckan_metadata(self) -> List[dict, dict]:
        """Load dataset or table metadata from Base dos Dados CKAN"""

        dataset_id = self.dataset_id.replace("_", "-")
        url = f"{self.CKAN_URL}/api/3/action/package_show?id={dataset_id}"

        ckan_response = requests.get(url).json()
        dataset = ckan_response.get("result")

        if not ckan_response.get("success"):
            return {}, {}

        if self.table_id:
            for resource in dataset["resources"]:
                if resource["name"] == self.table_id:
                    return dataset, resource
            return dataset, {}

        return dataset, {}

    @property
    def ckan_data_dict(self) -> dict:
        """Helper function that structures local metadata for validation"""

        ckan_dataset, ckan_table = self.ckan_metadata

        metadata = {
            "id": ckan_dataset.get("id"),
            "name": ckan_dataset.get("name") or "",
            "type": ckan_dataset.get("type") or "ckan_dataset",
            "title": self.local_metadata.get("title"),
            "private": ckan_dataset.get("private") or "false",
            "owner_org": ckan_dataset.get("owner_org")
            or "3626e93d-165f-42b8-bde1-2e0972079694",
            "resources": ckan_dataset.get("resources", []) or [],
            "groups": [
                {"name": group} for group in self.local_metadata.get("groups", []) or []
            ],
            "tags": [
                {"name": tag} for tag in self.local_metadata.get("tags", []) or []
            ],
        }

        if self.table_id:
            metadata["resources"] = [
                {
                    "id": ckan_table.get("id"),
                    "description": self.local_metadata.get("description"),
                    "name": self.local_metadata.get("table_id"),
                    "resource_type": ckan_table.get("resource_type"),
                    "version": self.local_metadata.get("version"),
                    "dataset_id": self.local_metadata.get("dataset_id"),
                    "table_id": self.local_metadata.get("table_id"),
                    "spatial_coverage": self.local_metadata.get("spatial_coverage"),
                    "temporal_coverage": self.local_metadata.get("temporal_coverage"),
                    "update_frequency": self.local_metadata.get("update_frequency"),
                    "entity": self.local_metadata.get("entity"),
                    "time_unit": self.local_metadata.get("time_unit"),
                    "identifying_columns": self.local_metadata.get(
                        "identifying_columns"
                    ),
                    "last_updated": self.local_metadata.get("last_updated"),
                    "published_by": self.local_metadata.get("published_by"),
                    "data_cleaned_by": self.local_metadata.get("data_cleaned_by"),
                    "data_cleaning_description": self.local_metadata.get(
                        "data_cleaning_description"
                    ),
                    "raw_files_url": self.local_metadata.get("raw_files_url"),
                    "auxiliary_files_url": self.local_metadata.get(
                        "auxiliary_files_url"
                    ),
                    "architecture_url": self.local_metadata.get("architecture_url"),
                    "covered_by_dictionary": self.local_metadata.get(
                        "covered_by_dictionary"
                    ),
                    "source_bucket_name": self.local_metadata.get("source_bucket_name"),
                    "project_id_prod": self.local_metadata.get("project_id_prod"),
                    "project_id_staging": self.local_metadata.get("project_id_staging"),
                    "partitions": self.local_metadata.get("partitions"),
                    "bdm_file_size": self.local_metadata.get("bdm_file_size"),
                    "columns": self.local_metadata.get("columns"),
                    "metadata_modified": self.local_metadata.get("metadata_modified"),
                }
            ]

        return metadata

    @property
    @lru_cache(256)
    def columns_schema(self) -> dict:
        """Returns a dictionary with the schema of the columns"""

        url = f"{self.CKAN_URL}/api/3/action/bd_bdm_columns_schema"

        return requests.get(url).json().get("result")

    @property
    @lru_cache(256)
    def metadata_schema(self) -> dict:
        """Get metadata schema from CKAN API endpoint"""

        dataset_url = f"{self.CKAN_URL}/api/3/action/bd_dataset_schema"
        dataset_schema = requests.get(dataset_url).json().get("result")

        table_url = f"{self.CKAN_URL}/api/3/action/bd_bdm_table_schema"
        table_schema = requests.get(table_url).json().get("result")

        if self.table_id:
            return table_schema

        return dataset_schema

    def is_updated(self) -> bool:
        """Check if a dataset or table is updated"""

        if self.table_id:
            url = f"{self.CKAN_URL}/api/3/action/bd_bdm_table_show?"
            url += f"dataset_id={self.dataset_id}&table_id={self.table_id}"
            exists_in_ckan = requests.get(url).json().get("success")
        else:
            url = f"{self.CKAN_URL}/api/3/action/bd_bdm_dataset_show?"
            url += f"dataset_id={self.dataset_id}"
            exists_in_ckan = requests.get(url).json().get("success")

        if not self.local_metadata.get("metadata_modified"):
            return True if not exists_in_ckan else False
        else:
            ckan_modified = self.ckan_metadata.get("metadata_modified")
            local_modified = self.local_metadata.get("metadata_modified")
            return ckan_modified == local_modified

    def create(
        self,
        if_exists="raise",
        columns=[],
        partition_columns=[],
        force_columns=False,
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

        if self.metadata_path.exists() and if_exists == "raise":
            raise FileExistsError(
                f"{self.metadata_path} already exists."
                + " Set the arg `if_exists` to `replace` to replace it."
            )
        elif if_exists != "pass":
            data = self.ckan_metadata

            # Adds local columns if
            # 1. columns is empty and
            # 2. force_columns is True

            # TODO: Is this sufficient to add columns?
            if self.table_id and (force_columns or not data.get("columns")):
                data["columns"] = [{"name": c} for c in columns]

            yaml_obj = build_yaml_object(
                self.dataset_id,
                self.table_id,
                self.metadata_schema,
                data,
                columns_schema=self.columns_schema,
                partition_columns=partition_columns,
            )

            self.metadata_path.parent.mkdir(parents=True, exist_ok=True)

            ruamel = ryaml.YAML()
            ruamel.preserve_quotes = True
            ruamel.indent(mapping=4, sequence=6, offset=4)
            ruamel.dump(yaml_obj, open(self.metadata_path, "w", encoding="utf-8"))

        return self

    def validate(self) -> bool:
        """Validate dataset_config.yaml or table_config.yaml files.
        The yaml file should be located at metadata_path/dataset_id[/table_id/
        ], as defined in your config.toml

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
            message = f"{self.metadata_path} has validation errors: {error}"
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

        bdm_ckan = RemoteCKAN(self.CKAN_URL, user_agent="", apikey=self.CKAN_API_KEY)

        try:
            self.validate()

            assert self.is_updated(), (
                f"Could not publish metadata due to out of date config file. "
                f"Please run `basedosdados metadata create {self.dataset_id} "
                f"{self.table_id}` to get the most recently updated metadata "
                f"and apply your changes to it."
            )

            if self.table_id:
                data_dict = self.ckan_data_dict.copy()
                data_dict = data_dict["resources"][0]

                return bdm_ckan.call_action(
                    action="resource_patch",
                    data_dict=data_dict,
                )

            else:
                return bdm_ckan.call_action(
                    action="package_patch",
                    data_dict=self.ckan_data_dict,
                )

        except (BaseDosDadosException, ValidationError) as e:
            msg = (
                f"Could not publish metadata due to a validation error. Pleas"
                f"e see the traceback below to get information on how to corr"
                f"ect it.\n\n{repr(e)}"
            )
            raise BaseDosDadosException(msg)

        except NotAuthorized as e:
            msg = (
                f"Could not publish metadata due to an authorization error. P"
                f"lease check if you set the `api_key` at the `[ckan]` sectio"
                f"n of your ~/.basedosdados/config.toml correctly. You must b"
                f"e an authorized user to publish modifications to a dataset "
                f"or table's metadata."
            )
            raise BaseDosDadosException(msg)


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
        if _selected[0].get("id") is not None:
            if k == "organization":
                print(f"{_selected[0].get('id') is not None}")
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
                dk, definitions[d]["properties"], data.get(k, {})
            )

    return yaml_obj


def build_yaml_object(
    dataset_id,
    table_id,
    schema,
    data=dict(),
    columns_schema=dict(),
    partition_columns=list(),
):
    def comment_treatment(c):
        return None if COLUMNS else "\n" + "".join(c.get("description", [""]))

    COLUMNS = False
    yaml_obj = ryaml.CommentedMap()

    properties, definitions = schema["properties"], schema["definitions"]

    # Drops all properties without yaml_order
    key_list = list(properties.keys())
    for k in key_list:
        if properties[k].get("yaml_order") is None:
            del properties[k]

    # Recursivelly adds properties to yaml to maintain order
    def _add_property(yaml_obj, properties, goal=None):

        for k in properties.keys():

            # Base case (goal is None) has to look for id_before == None
            # Otherwise just looks for key
            if ((goal is None) & (properties[k]["yaml_order"]["id_before"] == goal)) | (
                k == goal
            ):

                if "allOf" in properties[k]:

                    yaml_obj = handle_complex_fields(
                        yaml_obj, k, properties, definitions, data
                    )

                    if yaml_obj[k] == ordereddict():
                        yaml_obj[k] = handle_data(k, properties, data)

                else:
                    yaml_obj[k] = handle_data(k, properties, data)

                # Adds comments
                yaml_obj.yaml_set_comment_before_after_key(
                    k, before=comment_treatment(properties[k])
                )
                break

        # Returns ruaml object when property doesn't point to any other property
        id_after = properties[k]["yaml_order"]["id_after"]
        if id_after is None:
            return yaml_obj
        elif id_after not in properties.keys():
            raise BaseDosDadosException(
                f"Inconsistent YAML ordering: {id_after} is pointed to by {k}"
                f" but doesn't have itself a `yaml_order` field in the JSON S"
                f"chema."
            )
        else:
            properties.pop(k)
            return _add_property(yaml_obj, properties, id_after)

    yaml_obj = _add_property(yaml_obj, properties)

    if data.get("columns"):
        COLUMNS = True
        properties, definitions = (
            columns_schema["properties"],
            columns_schema["definitions"],
        )

        yaml_obj["columns"] = []
        for data in data.get("columns"):
            prop = deepcopy(properties)
            yaml_obj["columns"].append(_add_property(ryaml.CommentedMap(), prop))

    # in case of new dataset/table or local overwriting
    partitions_writer_condition = (
        partition_columns != ["[]"]
        and partition_columns != []
        and partition_columns is not None
    )

    if partitions_writer_condition == True:
        yaml_obj["partitions"] = ""
        for local_column in partition_columns:
            for remote_column in yaml_obj["columns"]:
                if remote_column["name"] == local_column:
                    remote_column["is_partition"] = True

        yaml_obj["partitions"] = ", ".join(partition_columns)

    yaml_obj["dataset_id"] = dataset_id
    if table_id:
        yaml_obj["table_id"] = table_id

    return yaml_obj
