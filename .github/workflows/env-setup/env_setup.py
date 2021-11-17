import base64
import json
import os
import shutil
from pathlib import Path

import toml
from basedosdados.upload.base import Base


def decoding_base64(message):
    # decoding the base64 string
    base64_bytes = message.encode("ascii")
    message_bytes = base64.b64decode(base64_bytes)
    return message_bytes.decode("ascii")


def create_config_folder(config_folder):
    # if ~/.basedosdados folder exists delete
    if os.path.exists(Path.home() / config_folder):
        shutil.rmtree(Path.home() / config_folder, ignore_errors=True)
    # create ~/.basedosdados folder
    os.mkdir(Path.home() / config_folder)
    os.mkdir(Path.home() / config_folder / "credentials")


def save_json(json_obj, file_path, file_name):
    # function to save json file
    with open(Path(file_path) / file_name, "w", encoding="utf-8") as f:
        json.dump(json_obj, f, ensure_ascii=False, indent=2)


def create_json_file(message_base64, file_name, config_folder):
    # decode base64 script and load as a json object
    json_obj = json.loads(decoding_base64(message_base64))
    prod_file_path = Path.home() / config_folder / "credentials"
    # save the json credential in the .basedosdados/credentials/
    save_json(json_obj, prod_file_path, file_name)


def save_toml(config_dict, file_name, config_folder):
    # save the config.toml in .basedosdados
    file_path = Path.home() / config_folder
    with open(file_path / file_name, "w") as toml_file:
        toml.dump(config_dict, toml_file)


def create_config_tree(prod_base64, staging_base64, config_dict):
    # execute the creation of .basedosdados
    create_config_folder(".basedosdados")
    # create the prod.json secret
    create_json_file(prod_base64, "prod.json", ".basedosdados")
    # create the staging.json secret
    create_json_file(staging_base64, "staging.json", ".basedosdados")
    # create the config.toml
    save_toml(config_dict, "config.toml", ".basedosdados")


def env_setup():
    # standard github actions home is /github/home
    # json with information of .basedosdados/config.toml
    config_dict = {
        "metadata_path": "/home/runner/work/mais/mais/bases",
        "templates_path": str(Path.home() / ".basedosdados/templates"),
        "bucket_name": os.getenv("BUCKET_NAME"),
        "gcloud-projects": {
            "prod": {
                "name": os.getenv("PROJECT_NAME_PROD"),
                "credentials_path": str(
                    Path.home() / ".basedosdados/credentials/prod.json"
                ),
            },
            "staging": {
                "name": os.getenv("PROJECT_NAME_STAGING"),
                "credentials_path": str(
                    Path.home() / ".basedosdados/credentials/staging.json"
                ),
            },
        },
        "ckan": {
            "url": os.getenv("CKAN_URL"),
            "api_key": decoding_base64(os.environ.get("CKAN_API_KEY")).replace("\n", ""),
        },
    }

    # load the secret of prod and staging data
    GCP_BD_PROD = os.getenv("GCP_BD_PROD")
    GCP_BD_STAGING = os.getenv("GCP_BD_STAGING")

    # create config and credential folders
    create_config_tree(GCP_BD_PROD, GCP_BD_STAGING, config_dict)

    # create templates at config path
    Base()._refresh_templates()

    # assert config files have been created
    assert (Path.home() / ".basedosdados" / "config.toml").is_file()
    assert (Path.home() / ".basedosdados" / "credentials" / "prod.json").is_file()
    assert (Path.home() / ".basedosdados" / "credentials" / "staging.json").is_file()


if __name__ == "__main__":
    env_setup()
