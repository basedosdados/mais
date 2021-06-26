from pathlib import Path
import os
import json
import requests
import yaml
from yaml.loader import Loader

from google.api_core.exceptions import NotFound

import ckanapi
from ckanapi import RemoteCKAN
from ckanapi import errors

from basedosdados.upload.base import Base
from basedosdados.validation.exceptions import BaseDosDadosException
from basedosdados.upload.table import Table

# CKAN_URL = os.environ.get("CKAN_URL", "http://localhost:5000")
CKAN_URL = "http://basedosdados.org"


class NoDatesSafeLoader(yaml.SafeLoader):
    @classmethod
    def remove_implicit_resolver(cls, tag_to_remove):
        """
        We want to load datetimes as strings, not dates, because we
        go on to serialise as json which doesn't have the advanced types
        of yaml, and leads to incompatibilities down the track.
        """
        if not "yaml_implicit_resolvers" in cls.__dict__:
            cls.yaml_implicit_resolvers = cls.yaml_implicit_resolvers.copy()
        for first_letter, mappings in cls.yaml_implicit_resolvers.items():
            cls.yaml_implicit_resolvers[first_letter] = [
                (tag, regexp) for tag, regexp in mappings if tag != tag_to_remove
            ]


NoDatesSafeLoader.remove_implicit_resolver("tag:yaml.org,2002:timestamp")


class Metadata(Table):
    def __init__(self, dataset_id, table_id, **kwargs):

        super().__init__(dataset_id, table_id, **kwargs)

        self.metadata_path = dict(
            table=Path(self.table_folder / "table_config.yaml"),
            dataset=Path(self.dataset_folder / "dataset_config.yaml"),
        )
        self.dataset_config = yaml.load(
            open(self.metadata_path["dataset"], "r", encoding="utf-8"),
            Loader=yaml.SafeLoader,
        )

    def _get_package(self):

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

        return requests.get(
            CKAN_URL + f"/api/3/action/package_show?id={dataset_id}"
        ).json()["result"]

    def _get_resource(self):
        """Get resource by trying to match CKAN package name with given
        dataset_id and resource name with given table_id

        Raises:
            e: [description]
        Returns:
            dict: the resource dict as it is saved on the CKAN database.
        """
        pkg_dict = self._get_package()
        resource = [r for r in pkg_dict["resources"] if r["name"] == self.table_id][0]
        return resource

    def _check_resource_last_modified(self):
        resource = self._get_resource()
        if resource["metadata_modified"] != self.table_config["last_updated"]:
            raise BaseDosDadosException(
                f"You're trying to update the table {self.dataset_id}.{self.table_id}"
                "but are not using the latest metadata version, download it first,"
                "then retry updating"
            )

    def _check_package_last_modified(self):
        pkg_dict = RemoteCKAN(CKAN_URL, user_agent="", apikey=None).action.package_show(
            id=self.dataset_id
        )
        if pkg_dict["last_modified"] != self.dataset_config["last_updated"]:
            raise BaseDosDadosException(
                f"You're trying to update the dataset {self.dataset_id} but are"
                "not using the latest metadata version, download it first, then retry updating"
            )

    def generate_metadata(self, obj, metadata_path=None):
        """Generate  metadata file based on the current version saved to
        CKAN database

        Args:
            obj (str):
                Either dataset or table
            path (str, pathlib.Path): Optional
                Path to save downloaded files. If None is given, saves to the
                standard metadata_path as defined in your config.toml file.
                Defaults to None.
        """

        if obj == "table":
            content = self._get_resource()
        elif obj == "dataset":
            content = self._get_package()
            content.pop("resources")
        else:
            ValueError("obj expects dataset or table but got {obj}")

        if metadata_path is None:
            metadata_path = self.metadata_path[obj]
        elif Path(metadata_path).name == f"{obj}_config.yaml":
            metadata_path = Path(metadata_path)
        else:
            metadata_path = Path(metadata_path) / f"{obj}_config.yaml"

        print(
            yaml.dump(
                content,
                line_break=False,
                sort_keys=False,
                default_flow_style=False,
                allow_unicode=True,
            )
        )
        # open(dump_path, "w").write(
        #     yaml.dump(
        #         pkg_dict,
        #         line_break=False,
        #         sort_keys=False,
        #         default_flow_style=False,
        #         allow_unicode=True,
        #     )
        # )

    def validate_table(self):
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
