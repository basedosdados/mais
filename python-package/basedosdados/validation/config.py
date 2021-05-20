from ckanapi import RemoteCKAN
from ckanapi import errors
from basedosdados.validation.exceptions import BaseDosDadosException
from basedosdados.upload.table import Table
from pathlib import Path
import ckanapi
import os
import yaml

CKAN_URL = os.environ.get("CKAN_URL", "http://localhost:5000")

basedosdados = RemoteCKAN(CKAN_URL, user_agent="", apikey=None)


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


class Config(Table):
    def __init__(self, dataset_id, table_id, **kwargs):

        super().__init__(dataset_id, table_id)

        self.path = Path(self.table_folder / "table_config.yaml")

        with open(self.path, "r") as f:
            table_config = yaml.load(f, Loader=NoDatesSafeLoader)

        table_config["resource_type"] = "bdm_table"
        table_config["name"] = table_config.pop("table_id")
        table_config["spatial_coverage"] = table_config.pop("coverage_geo")
        table_config["temporal_coverage"] = table_config.pop("coverage_time")
        table_config["update_frequency"] = table_config.pop("data_update_frequency")
        self.yaml = table_config

    def validate(self):
        error_dict = {}
        try:
            response = basedosdados.action.package_validate(
                resources=self.yaml,
                dataset_id=self.yaml["dataset_id"],
                name=self.yaml["table_id"],
                title="Validate",
            )
        except ckanapi.errors.ValidationError as e:
            if e.error_dict["resources"]:
                error_dict[self.yaml["name"]] = e.error_dict["resources"]
            else:
                print("Valid!")
                return
            if error_dict:
                raise BaseDosDadosException(
                    f"table_config.yaml is invalid. \nValidation Errors: {error_dict}"
                )
