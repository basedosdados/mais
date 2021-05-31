from json import dump
from basedosdados.upload.base import Base
from ckanapi import RemoteCKAN
from ckanapi import errors
from basedosdados.validation.exceptions import BaseDosDadosException
from basedosdados.upload.table import Table
from pathlib import Path
import ckanapi
import os
from google.api_core.exceptions import NotFound
import yaml, json
import requests
from yaml.loader import Loader

CKAN_URL = os.environ.get("CKAN_URL", "http://localhost:5000")


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

        self.table_metadata_path = Path(self.table_folder / "table_config.yaml")
        self.dataset_metadata_path = self.dataset_folder / "dataset_config.yaml"
        with open(self.dataset_metadata_path, "r", encoding="utf-8") as f:
            dataset_config = yaml.load(f, Loader=yaml.SafeLoader)
        self.dataset_config = dataset_config

    def _get_package(self):
        api_url = CKAN_URL + "/api/3/action/package_list"
        result = requests.get(api_url)
        pkg_list = json.loads(result.text)["result"]

        if self.dataset_id in pkg_list:
            dataset_id = self.dataset_id
        elif self.dataset_id.replace("_", "-") in pkg_list:
            dataset_id = self.dataset_id.replace("_", "-")
        try:
            pkg_dict = RemoteCKAN(
                CKAN_URL, user_agent="", apikey=None
            ).action.package_show(id=dataset_id)
        except Exception as e:
            raise e
        return pkg_dict

    def _get_resource(self):
        """Get resource by trying to match CKAN package name with given dataset_id and resource name with given table_id
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
                f"You're trying to update the table {self.dataset_id}.{self.table_id} but are not using the latest metadata version, download it first, then retry updating"
            )

    def _check_package_last_modified(self):
        pkg_dict = RemoteCKAN(CKAN_URL, user_agent="", apikey=None).action.package_show(
            id=self.dataset_id
        )
        if pkg_dict["last_modified"] != self.dataset_config["last_updated"]:
            raise BaseDosDadosException(
                f"You're trying to update the dataset {self.dataset_id} but are not using the latest metadata version, download it first, then retry updating"
            )

    def generate_package_metadata(self, path=None):
        """Generate package metadata file based on the current version saved to CKAN database

        Args:
            path (str, pathlib.Path): Optional
                Path to save downloaded files. If None is given, saves to the metadata_path/dataset_id/dataset_config.yaml
                as defined in your config.toml file.
                Defaults to None.
        """

        if not path:
            dump_path = self.dataset_metadata_path
        elif Path(path).is_dir():
            dump_path = Path(path) / "dataset_config.yaml"
        else:
            dump_path = Path(Path)
        pkg_dict = self._get_package()
        pkg_dict.pop("resources")
        with open(dump_path, "w") as f:
            stream = yaml.dump(
                pkg_dict,
                line_break=False,
                sort_keys=False,
                default_flow_style=False,
                allow_unicode=True,
            )
            f.write(stream)

    def generate_resource_metadata(self, path=None):
        """Generates metadata file from last version uploaded to CKAN

        Args:
            path (str, pathlib.Path): optional.
                Path to save downloaded files. If None is given, saves to the metadata_path/dataset_id/table_id/table_config.yaml
                as defined in your config.toml file.
                Defaults to None.
        """

        resource = self._get_resource()
        if not path:
            dump_path = self.table_metadata_path
        elif Path(path).is_dir():
            dump_path = Path(path) / "table_config.yaml"
        else:
            dump_path = Path(Path)
        # Optionally select which keys will be dumped to generated metadata file
        # yaml_keys = [k for k in resource.keys()]
        with open(dump_path, "w") as f:
            stream = yaml.dump(
                resource,
                line_break=False,
                sort_keys=True,
                default_flow_style=False,
                allow_unicode=True,
            )
            f.write(stream)

    def validate_table(self):
        """Validate table_config.yaml file. The yaml file should be located at metadata_path/dataset_id/table_id/, as defined in your config.toml

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
