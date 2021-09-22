from copy import deepcopy
from functools import lru_cache
from collections import defaultdict

import requests
import ruamel.yaml as ryaml
from ruamel.yaml.compat import ordereddict

from ckanapi import RemoteCKAN
from ckanapi.errors import ValidationError, NotAuthorized

from basedosdados.upload.base import Base
from basedosdados.exceptions import BaseDosDadosException


class Metadata(Base):
    def __init__(self, dataset_id, table_id=None, **kwargs):
        super().__init__(**kwargs)

        self.dataset_id = dataset_id
        self.table_id = table_id

        self.CKAN_CONFIG = self.config.get("ckan", {})
        self.CKAN_URL = (
            "https://staging.basedosdados.org"
            if self.CKAN_CONFIG.get("url") is None or self.CKAN_CONFIG.get("url") == ""
            else self.CKAN_CONFIG.get("url")
        )
        self.CKAN_API_KEY = self.config.get("ckan", {}).get("api_key")

    @property
    def obj_path(self):

        if self.table_id is None:
            return self.metadata_path / self.dataset_id / "dataset_config.yaml"
        else:
            return (
                self.metadata_path
                / self.dataset_id
                / self.table_id
                / "table_config.yaml"
            )

    @property
    def local_config(self):
        if self.obj_path.exists():
            return ryaml.safe_load(open(self.obj_path, "r", encoding="utf-8").read())
        else:
            return {}

    @property
    @lru_cache(256)
    def ckan_config(self) -> dict:

        pkg_list = requests.get(self.CKAN_URL + "/api/3/action/package_list").json()[
            "result"
        ]

        if self.dataset_id in pkg_list:
            dataset_id = self.dataset_id
        elif self.dataset_id.replace("_", "-") in pkg_list:
            dataset_id = self.dataset_id.replace("_", "-")
        else:
            return defaultdict(lambda: dict())

        dataset_config = requests.get(
            self.CKAN_URL + f"/api/3/action/package_show?id={dataset_id}"
        ).json()["result"]

        # unpack extras
        dataset_args = [
            d for d in dataset_config["extras"] if d["key"] == "dataset_args"
        ]

        if dataset_args:
            dataset_args = dataset_args[0]["value"]
            dataset_config.update(dataset_args)

        if self.table_id is not None:
            return [
                r for r in dataset_config["resources"] if r["name"] == self.table_id
            ][0]

        else:
            return dataset_config

    @property
    @lru_cache(256)
    def ckan_raw_metadata(self):

        endpoint_url = (
            f"{self.CKAN_URL}/api/3/action/bd_bdm_dataset_show?dataset_id="
            f"{self.dataset_id}"
        )
        bdm_ckan_dataset_metadata = requests.get(endpoint_url).json()["result"]

        if self.table_id:
            endpoint_url = (
                f"{self.CKAN_URL}/api/3/action/bd_bdm_table_show?dataset_i"
                f"d={self.dataset_id}&table_id={self.table_id}"
            )
            bdm_ckan_table_metadata = requests.get(endpoint_url).json()["result"]

        else:
            bdm_ckan_table_metadata = None

        return bdm_ckan_dataset_metadata, bdm_ckan_table_metadata

    @property
    def ckan_data_dict(self) -> dict:
        """
        Helper function to structure local config files data for validation.

        Args:
            dataset_id (str):
                The dataset_id that corresponds to the data subject to validation.

        Returns:
            dict
        """

        bdm_ckan_dataset_metadata, bdm_ckan_table_metadata = self.ckan_raw_metadata

        if self.table_id:

            data = {
                "id": bdm_ckan_dataset_metadata["id"],
                "name": bdm_ckan_dataset_metadata["name"],
                "type": bdm_ckan_dataset_metadata["type"],
                "title": bdm_ckan_dataset_metadata["title"],
                "private": bdm_ckan_dataset_metadata["private"],
                "owner_org": bdm_ckan_dataset_metadata["owner_org"],
                "resources": [
                    {
                        "id": bdm_ckan_table_metadata["id"],
                        "description": self.local_config["description"],
                        "name": self.local_config["table_id"],
                        "resource_type": bdm_ckan_table_metadata["resource_type"],
                        "version": self.local_config["version"],
                        "table_id": self.local_config["table_id"],
                        "spatial_coverage": self.local_config["spatial_coverage"],
                        "metadata_modified": self.local_config["metadata_modified"],
                    }
                ],
            }

        else:

            data = {
                "id": bdm_ckan_dataset_metadata["id"],
                "name": bdm_ckan_dataset_metadata["name"],
                "title": self.local_config["title"],
                "type": bdm_ckan_dataset_metadata["type"],
                "metadata_modified": self.local_config["metadata_modified"],
                "private": bdm_ckan_dataset_metadata["private"],
                "owner_org": bdm_ckan_dataset_metadata["owner_org"],
                "resources": bdm_ckan_dataset_metadata["resources"],
                "groups": [{"name": group} for group in self.local_config["groups"]],
                "organization": {
                    "id": self.local_config["organization"]["id"],
                    "name": self.local_config["organization"]["name"],
                    "title": self.local_config["organization"]["title"],
                    "type": self.local_config["organization"]["type"],
                    "description": self.local_config["organization"]["description"],
                    "image_url": self.local_config["organization"]["image_url"],
                    "created": self.local_config["organization"]["created"],
                    "is_organization": self.local_config["organization"][
                        "is_organization"
                    ],
                    "approval_status": self.local_config["organization"][
                        "approval_status"
                    ],
                    "state": self.local_config["organization"]["state"],
                },
                "tags": [{"name": tag} for tag in self.local_config["tags"]],
                "extras": [
                    {
                        "key": "dataset_args",
                        "value": {
                            "dataset_id": self.local_config["dataset_id"],
                        },
                    }
                ],
            }

        return data

    @property
    @lru_cache(256)
    def columns_schema(self) -> dict:
        """Returns a dictionary with the schema of the columns.

        Returns:
        """

        return requests.get(
            self.CKAN_URL + "/api/3/action/bd_bdm_columns_schema"
        ).json()["result"]

    @property
    @lru_cache(256)
    def metadata_schema(self):
        """Get metadata schema from CKAN API endpoint.

        Returns:
        """

        dataset_schema = requests.get(
            self.CKAN_URL + "/api/3/action/bd_dataset_schema"
        ).json()["result"]
        table_schema = requests.get(
            self.CKAN_URL + "/api/3/action/bd_bdm_table_schema"
        ).json()["result"]

        if self.table_id is None:
            return dataset_schema
        else:
            return table_schema

    def is_updated(self):

        if self.table_id:
            exists_in_ckan = requests.get(
                self.CKAN_URL
                + f"/api/3/action/bd_bdm_table_show?dataset_id={self.dataset_id}&table_id={self.table_id}"
            ).json()["success"]
        else:
            exists_in_ckan = requests.get(
                self.CKAN_URL
                + f"/api/3/action/bd_bdm_dataset_show?dataset_id={self.dataset_id}"
            ).json()["success"]

        if self.local_config.get("metadata_modified") is None and exists_in_ckan:
            return False
        elif self.local_config.get("metadata_modified") is None and not exists_in_ckan:
            return True
        else:
            return self.ckan_config.get("metadata_modified") == self.local_config.get(
                "metadata_modified"
            )

    def create(
        self, if_exists="raise", columns=[], partition_columns=[], force_columns=False
    ):
        """Create metadata file based on the current version saved to
        CKAN database

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

        if self.obj_path.exists() and if_exists == "raise":
            raise FileExistsError(
                f"{self.obj_path} already exists. Set the arg `if_exists`"
                " to `replace` to replace it."
            )
        elif if_exists != "pass":

            data = self.ckan_config

            # adds local columns if 1. columns is empty and 2. force_columns is True

            if (
                (not data.get("columns")) or force_columns == True
            ) and self.table_id is not None:
                data["columns"] = [{"name": c} for c in columns]

            yaml_obj = builds_yaml_object(
                self.dataset_id,
                self.table_id,
                self.metadata_schema,
                data,
                columns_schema=self.columns_schema,
                partition_columns=partition_columns,
            )
            self.obj_path.parent.mkdir(parents=True, exist_ok=True)

            ruamel = ryaml.YAML()
            ruamel.preserve_quotes = True
            ruamel.indent(mapping=4, sequence=6, offset=4)
            ruamel.dump(yaml_obj, open(self.obj_path, "w", encoding="utf-8"))

        return self

    def validate(self):
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
        error_dict = {}

        bdm_ckan = RemoteCKAN(self.CKAN_URL, user_agent="", apikey=None)

        response = bdm_ckan.action.bd_dataset_validate(**self.ckan_data_dict)

        if response["errors"]:
            error_dict[self.ckan_config["name"]] = response["errors"]
            raise BaseDosDadosException(
                f"{self.obj_path} has validation errors: {error_dict}"
            )

        return True

    def publish(self):
        """Publish local metadata modifications. `Metadata.validate` is used
        to make sure no local invalid metadata is published to CKAN. The `co
        nfig.toml` `api_key` variable must be set at the `[ckan]` section fo
        r this method to work.

        Returns:
            dict:
                In case of success, a `dict` with the modified data is retur
                ned.

        Raises:
            BaseDosDadosException:
                In case of CKAN's ValidationError or NotAuthorized exception
                s.
        """

        if self.CKAN_API_KEY is None or self.CKAN_API_KEY == "":
            raise BaseDosDadosException(
                "You can't use `Metadata.publish` without setting an `api_key"
                "` in your ~/.basedosdados/config.toml. Please set it like th"
                'is: \n\n```\n[ckan]\nurl="<CKAN_URL>"\napi_key="<API_KEY>'
                '"\n```'
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

                response = bdm_ckan.call_action(
                    action="resource_patch", data_dict=data_dict
                )

                return response

            else:
                response = bdm_ckan.call_action(
                    action="package_patch", data_dict=self.ckan_data_dict
                )

                return response

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

    # If no data is found for that key, uses pydantic default, else uses
    # local default

    selected = data.get(k)
    if not selected:
        selected = schema[k].get("user_input_hint", local_default)

    # In some cases like `tags`, `groups`, `organization`
    # the API default is to return a dict or list[dict] with all info.
    # But, we just use `name` to build the yaml
    _selected = deepcopy(selected)

    if _selected == []:
        return _selected

    if not isinstance(_selected, list):
        _selected = [_selected]
    elif isinstance(_selected[0], dict):
        if _selected[0].get("id") is not None:
            return [s.get("name") for s in _selected]

    return selected


def handle_complex_fields(yaml_obj, k, properties, definitions, data):
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


def builds_yaml_object(
    dataset_id,
    table_id,
    schema,
    data=dict(),
    columns_schema=dict(),
    partition_columns=list(),
):
    def comment_treatment(c):
        if COLUMNS:
            return None
        else:
            return "\n" + "".join(c.get("description", [""]))

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
