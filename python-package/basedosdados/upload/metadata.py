import os
import json
import sys
import ast
from pathlib import Path
from copy import deepcopy
from functools import lru_cache

import requests
import ruamel.yaml as ryaml

from google.api_core.exceptions import NotFound

import ckanapi
from ckanapi import RemoteCKAN
from ckanapi import errors

from basedosdados.upload.base import Base
from basedosdados.validation.exceptions import BaseDosDadosException

# CKAN_URL = os.environ.get("CKAN_URL", "http://localhost:5000")
CKAN_URL = "http://basedosdados.org"


class Metadata(Base):
    def __init__(self, dataset_id, table_id=None, **kwargs):
        super().__init__(**kwargs)

        self.dataset_id = dataset_id
        self.table_id = table_id

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

        return ryaml.safe_load(open(self.obj_path, "r").read())

    @property
    @lru_cache(256)
    def ckan_config(self):

        # TODO: This will not be needed after migration
        pkg_list = requests.get(CKAN_URL + "/api/3/action/package_list").json()[
            "result"
        ]

        if self.dataset_id in pkg_list:
            dataset_id = self.dataset_id
        elif self.dataset_id.replace("_", "-") in pkg_list:
            dataset_id = self.dataset_id.replace("_", "-")
        else:
            raise BaseDosDadosException(
                f"dataset_id '{self.dataset_id}' was not found in CKAN"
            )
        # ENDS HERE

        dataset_config = requests.get(
            CKAN_URL + f"/api/3/action/package_show?id={dataset_id}"
        ).json()["result"]

        if self.table_id is not None:
            return [
                r for r in dataset_config["resources"] if r["name"] == self.table_id
            ][0]

        else:
            return dataset_config

    @property
    @lru_cache(256)
    def metadata_schema(self):
        # TODO: Get it from ckan endpoint
        return ast.literal_eval(open("table_schema.txt", "r").read())["properties"]

    def is_updated(self):

        if self.local_config["metadata_modified"] is None:
            return False
        else:
            return (
                self.ckan_config["metadata_modified"]
                == self.local_config["metadata_modified"]
            )

    def create(self):
        """Create metadata file based on the current version saved to
        CKAN database

        Args:
            path (str, pathlib.Path): Optional
                Path to save downloaded files. If None is given, saves to the
                standard metadata_path as defined in your config.toml file.
                Defaults to None.
        """

        yaml_obj = builds_yaml_object(self.metadata_schema, self.ckan_config)
        ryaml.YAML().dump(yaml_obj, open(self.obj_path, "w"))

    def validate(self):
        """Validate table_config.yaml file. The yaml file should be located at
        metadata_path/dataset_id/table_id/, as defined in your config.toml

        Raises:
            BaseDosDadosException: when the file has validation errors.

        """
        error_dict = {}
        self._check_resource_last_modified()
        try:
            response = RemoteCKAN(
                CKAN_URL, user_agent="", apikey=None
            ).action.package_validate(
                resources=[self.table_config],
                private=False,
                name=self.dataset_id,
                title="Validate",
            )
        except ckanapi.errors.ValidationError as e:
            if e.error_dict:
                error_dict[self.table_config["name"]] = e.error_dict
            else:
                return True

        if error_dict:
            raise BaseDosDadosException(
                f"{self.table_metadata_path} has validation errors: {error_dict}"
            )


def comment_treatment(c):

    return "\n" + "\n".join(c.get("description", [""]))


def handle_data(k, schema, data, local_default=None):

    # If no data is found for that key, uses pydantic default, else uses
    # local default
    selected = data.get(k, schema[k].get("default", local_default))

    # In some cases like `tags`, `groups`, `organization`
    # the API default is to return a dict or list[dict] with all info.
    # But, we just use `name` to build the yaml
    _selected = deepcopy(selected)
    if not isinstance(_selected, list):
        _selected = [_selected]
    if isinstance(_selected[0], dict):
        if _selected[0].get("id") is not None:
            return [s.get("name") for s in _selected]

    return selected


def builds_yaml_object(schema, data=dict()):

    yaml_obj = ryaml.CommentedMap()

    # Drops all properties without yaml_order
    key_list = list(schema.keys())
    for k in key_list:
        if schema[k].get("yaml_order") is None:
            del schema[k]

    # Recursivelly adds properties to yaml to maintain order
    def _add_property(yaml_obj, schema, goal=None):

        for k in schema.keys():

            # Base case (goal is None) has to look for id_before == None
            # Otherwise just looks for key
            if ((goal is None) & (schema[k]["yaml_order"]["id_before"] == goal)) | (
                k == goal
            ):

                yaml_obj[k] = handle_data(k, schema, data)

                # Adds comments
                yaml_obj.yaml_set_comment_before_after_key(
                    k, before=comment_treatment(schema[k])
                )
                break

        # Returns ruaml object when property doesn't point to any other property
        id_after = schema[k]["yaml_order"]["id_after"]
        if id_after is None:
            return yaml_obj
        else:
            schema.pop(k)
            return _add_property(yaml_obj, schema, id_after)

    return _add_property(yaml_obj, schema)