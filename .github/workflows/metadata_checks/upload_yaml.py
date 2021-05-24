import os, json, re, requests, sys
import ckanapi.errors
import yaml
from pathlib import Path
from ckanapi import RemoteCKAN
from pydantic import ValidationError

user_agent = None
CKAN_API_KEY = os.environ["CKAN_API_KEY"]
CKAN_URL = os.environ.get("CKAN_URL", "http://localhost:5000")

basedosdados = RemoteCKAN(CKAN_URL, user_agent=user_agent, apikey=CKAN_API_KEY)


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


def upload_yaml(create=False):
    ### GET ALL YAMLS FROM THE LIB
    yaml_path = [
        path for path in Path("../../../bases/").glob("**/**/**/table_config.yaml")
    ]
    ### CKAN API REQUEST TO LIST PACKAGES
    api_url = CKAN_URL + "/api/3/action/package_list"
    result = requests.get(api_url)
    ### LOADS RESULT IN INTERABLE/PARSEABLE FORMAT
    package_list = json.loads(result.text)["result"]
    error_dict = {}
    ### ITERATING THROUGH YAMLS
    for path in yaml_path:
        ### LOAD YAML DICT
        with open(path, "r", encoding="UTF-8") as f:
            table_config = yaml.load(f, Loader=NoDatesSafeLoader)
        ### CHECK IF THE EXISTING CKAN DATASET_ID NEEDS "-" OR "_"
        if table_config["dataset_id"] in package_list:
            dataset_id = table_config["dataset_id"]
        elif table_config["dataset_id"].replace("_", "-") in package_list:
            dataset_id = table_config["dataset_id"].replace("_", "-")
        ### IF THE DATASET IS ALREAY A PACKAGE, TRY TO UPDATE IT
        if dataset_id:
            ### GET CURRENT STATE OF THE PACKAGE (DATASET)
            pkg_dict = basedosdados.action.package_show(id=dataset_id)
            ### LOOP THROUGH RESOURCES, SOMETIMES CKAN GIVES str TYPE RESOURCES, WHICH ARE NOT USEFUL
            for resource in pkg_dict["resources"]:
                if type(resource) == dict:
                    ### UPDATES THE RESOURCE INSIDE THE pkg_dict WITH ALL KEY:VALUE PAIRS IT'S MISSING FROM THE YAML
                    if resource["name"] == table_config["table_id"]:
                        table_config["resource_type"] = "bdm_table"
                        missing_keys = [
                            key for key in table_config.keys() if key not in resource
                        ]
                        for key in table_config.keys():
                            resource.update({key: table_config[key]})
                        ### REMOVE OLD RESOURCE AND ADD IT'S UPDATED FORM
                        # print("UPDATED RESOURCE\n", updated_resource)
                        # # print("PRE\n", pkg_dict["resources"])
                        # pkg_dict["resources"].remove(resource)
                        # # print("MIDDLE\n", pkg_dict["resources"])s
                        # pkg_dict["resources"] += updated_resource
                ### JUST TO TRY AND SPEED UP PASSING THORUGH THE LOOP
                else:
                    pass
            try:
                # response = basedosdados.action.package_update(**pkg_dict)
                ### OPTIONALLY WE CAN TRY AND USE package_patch ACTION
                response = basedosdados.action.package_patch(**pkg_dict)
            except Exception as e:
                error_dict[
                    f"{table_config['dataset_id']}.{table_config['table_id']}"
                ] = str(e)
            # if response.status_code == 200:
            #     updated_pkg = basedosdados.action.package_show(id=dataset_id)
            #     print(
            #         f"Package Updated! {table_config['dataset_id']}.{table_config['table_id']}",
            #         f"Updated Package: {updated_pkg['resources']}",
            # )
        ### IF DATASET DON'T EXIST, TRY TO CREATE IT WITH THE YAML AS A RESOURCE
        else:
            try:
                response = basedosdados.action.package_create(
                    name=table_config["dataset_id"], resources=[table_config]
                )
            except Exception as e:
                error_dict[
                    f"{table_config['dataset_id']}.{table_config['table_id']}"
                ] = str(e)

    if error_dict:
        dump_path = Path("./error_report.json")
        with open(dump_path, "w") as f:
            json_stream = json.dumps(error_dict)
            f.write(json_stream)
        print(error_dict)


if __name__ == "__main__":
    upload_yaml()
