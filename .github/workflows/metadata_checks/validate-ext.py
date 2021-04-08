from ckanapi import RemoteCKAN
from ckanapi import errors
import ckanapi
import os
import yaml
import sys

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


def validate_metadata(path_to_yaml):
    with open(path_to_yaml) as f:
        table_config = yaml.load(f, Loader=NoDatesSafeLoader)
    table_config["resource_type"] = "bdm_table"
    table_config["name"] = table_config["table_id"]
    table_config["spatial_coverage"] = table_config["coverage_geo"]
    table_config["temporal_coverage"] = "2021"
    table_config["update_frequency"] = "one_year"
    table_config["observation_level"] = ["municipality"]
    error_dict = {}
    try:
        response = basedosdados.action.package_validate(
            resources=[table_config],
            dataset_id="123",
            name="validate_test",
            title="hahaha",
        )
    except ckanapi.errors.ValidationError as e:
        if e.error_dict["resources"]:
            error_dict[table_config["table_id"]] = e.error_dict["resources"]
        else:
            return

    if error_dict:
        print(error_dict)


if __name__ == "__main__":
    validate_metadata(path_to_yaml=sys.argv[1])
