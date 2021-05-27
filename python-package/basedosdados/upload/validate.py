from ckanapi import RemoteCKAN
from ckanapi import errors
from basedosdados.validation.exceptions import BaseDosDadosException
from basedosdados.upload.table import Table
from pathlib import Path
import ckanapi
import os
import yaml

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

        self.path = Path(self.table_folder / "table_config.yaml")

        with open(self.path, "r") as f:
            table_config = yaml.load(f, Loader=NoDatesSafeLoader)

        table_config["resource_type"] = "bdm_table"
        table_config["name"] = table_config.pop("table_id")
        table_config["spatial_coverage"] = table_config.pop("coverage_geo")
        table_config["temporal_coverage"] = str(table_config.pop("coverage_time"))
        table_config["update_frequency"] = table_config.pop("data_update_frequency")
        self.yaml = table_config

    def _get_resource(self):
        """Get resource by trying to match CKAN package name with given dataset_id and resource name with given table_id

        Raises:
            e: [description]

        Returns:
            dict: the resource dict as it is saved on the CKAN database.
        """
        try:
            pkg_dict = RemoteCKAN(
                CKAN_URL, user_agent="", apikey=None
            ).action.package_show(id=self.yaml["dataset_id"])
        except Exception as e:
            raise e
        resource = [
            r for r in pkg_dict["resources"] if r["name"] == self.yaml["table_id"]
        ][0]
        return resource

    def _check_last_modified(self):
        resource = self._get_resource()
        if resource["last_modified"] != self.yaml["last_updated"]:
            raise BaseDosDadosException(
                f"You're trying to update the table {self.yaml['dataset_id']}.{self.yaml['table_id']} but are not using the latest metadata version, download it first, then retry updating"
            )

    def generate_metadata_file(self, path=None):
        """Generates metadata file from last version uploaded to CKAN

        Args:
            path (str, pathlib.Path): optional.
                Path to save downloaded files. If None is given, saves to the metadata_path/dataset_id/table_id/table_config.yaml
                as defined in your config.toml file.
                Defaults to None.
        """
        resource = self._get_resource()
        table_config = Path(path) / "table_config.yaml" or self.path
        with open(table_config, "w") as f:
            stream = yaml.dump(
                resource,
                line_break=False,
                sort_keys=False,
                default_flow_style=False,
                allow_unicode=True,
            )
            f.write(stream)

    def validate(self):
        error_dict = {}
        self._check_last_modified()
        try:
            response = RemoteCKAN(
                CKAN_URL, user_agent="", apikey=None
            ).action.package_validate(
                resources=[self.yaml],
                private=False,
                name=self.yaml["dataset_id"],
                title="Validate",
            )
        except ckanapi.errors.ValidationError as e:
            if e.error_dict:
                error_dict[self.yaml["name"]] = e.error_dict
            else:
                return True

        if error_dict:
            raise BaseDosDadosException(
                f"{self.path} has validation errors: {error_dict}"
            )
