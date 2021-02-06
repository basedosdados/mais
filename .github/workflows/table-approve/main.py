import os
import shutil
from pathlib import Path
import base64
import yaml
import json
import toml
import tomlkit

import basedosdados as bd
from basedosdados.base import Base
from basedosdados.storage import Storage
import basedosdados


def decogind_base64(message):
    # decoding
    base64_bytes = message.encode("ascii")
    message_bytes = base64.b64decode(base64_bytes)
    return message_bytes.decode("ascii")


def create_config_folder(config_folder):
    ## create ~/.basedosdados
    if os.path.exists(Path.home() / config_folder):
        shutil.rmtree(Path.home() / config_folder, ignore_errors=True)

    os.mkdir(Path.home() / config_folder)
    os.mkdir(Path.home() / config_folder / "credentials")


def save_json(json_obj, file_path, file_name):
    with open(f"{file_path}/{file_name}", "w", encoding="utf-8") as f:
        json.dump(json_obj, f, ensure_ascii=False, indent=2)


def create_json_file(message_base64, file_name, config_folder):
    json_obj = json.loads(decogind_base64(message_base64))
    prod_file_path = Path.home() / config_folder / "credentials"
    save_json(json_obj, prod_file_path, file_name)


def save_toml(config_dict, file_name, config_folder):
    file_path = Path.home() / config_folder
    with open(file_path / file_name, "w") as toml_file:
        toml.dump(config_dict, toml_file)


def sync_bucket(
    source_bucket_name,
    dataset_id,
    table_id,
    destination_bucket_name,
    backup_bucket_name,
    mode="staging",
):
    """Copies proprosed data between storage buckets.
    Creates a backup of old data, then delete it and copies new data into the destination bucket.

    Args:
        source_bucket_name (str):
            The bucket name from which to copy data.
        dataset_id (str):
            Dataset id available in basedosdados. It should always come with table_id.
        table_id (str):
            Table id available in basedosdados.dataset_id.
            It should always come with dataset_id.
        destination_bucket_name (str):
            The bucket name which data will be copied to.
            If None, defaults to the bucket initialized when instantianting Storage object
            (check it with the Storage.bucket proprerty)
        backup_bucket_name (str):
            The bucket name for where backup data will be stored.
        mode (str): Optional.
         Folder of which dataset to update.

    Raises:
        ValueError:
            If there are no files corresponding to the given dataset_id and table_id on the source bucket
    """

    ref = Storage(dataset_id=dataset_id, table_id=table_id)

    prefix = f"{mode}/{dataset_id}/{table_id}/"

    source_ref = (
        ref.client["storage_staging"]
        .bucket(source_bucket_name)
        .list_blobs(prefix=prefix)
    )

    destination_ref = ref.bucket.list_blobs(prefix=prefix)

    if len(list(source_ref)) == 0:

        raise ValueError("No objects found on the source bucket")

    else:
        # MAKE A BACKUP OF OLD DATA
        if len(list(destination_ref)):
            ref.copy_table(
                source_bucket_name=destination_bucket_name,
                destination_bucket_name=backup_bucket_name,
            )

            # DELETE OLD DATA FROM PROD
            ref.delete_table(not_found_ok=True)

        # COPIES DATA TO DESTINATION
        ref.copy_table(source_bucket_name=source_bucket_name)


def load_configs(dataset_id, table_id):
    configs_path = Base()._load_config()
    metadata_path = configs_path["metadata_path"]
    table_path = f"{metadata_path}/{dataset_id}/{table_id}"
    return yaml.load(
        open(f"{table_path}/table_config.yaml", "r"), Loader=yaml.FullLoader
    )


def is_partitioned(table_config):
    return table_config["partitions"] is not None


def push_table_to_bq(dataset_id, table_id):
    table_config = load_configs(dataset_id, table_id)

    tb = bd.Table(dataset_id, table_id)

    tb.create(
        partitioned=is_partitioned(table_config),
        storage_data=True,
        if_exists="pass",
    )

    tb.publish(if_exists="replace")


def check_function():
    print(
        "config.toml exists:",
        os.path.exists(Path.home() / ".basedosdados" / "config.toml"),
        "\n",
    )
    print(
        tomlkit.parse((Path.home() / ".basedosdados" / "config.toml").open("r").read()),
        "\n",
    )

    print(
        "prod.json exists:",
        os.path.exists(Path.home() / ".basedosdados" / "credentials" / "prod.json"),
        "\n",
    )

    print(
        "prod.json:",
        (Path.home() / ".basedosdados" / "credentials" / "prod.json").open("r").read(),
        "\n",
    )

    print(
        "staging.json exists:",
        os.path.exists(Path.home() / ".basedosdados" / "credentials" / "staging.json"),
        "\n",
    )

    print(
        "staging.json:",
        (Path.home() / ".basedosdados" / "credentials" / "staging.json")
        .open("r")
        .read(),
        "\n",
    )


def main():

    print(json.load(Path("/github/workspace/files.json").open("r")))
    print(os.environ.get("INPUT_PROJECT_ID"))
    print(Path.home())

    config_dict = {
        "metadata_path": "XXX",
        "templates_path": "XXX",
        "gcloud-projects": {
            "staging": {
                "name": "XXXXX",
                "credentials_path": "XXXXXX",
            },
            "prod": {
                "name": "gabinete-sv",
                "credentials_path": "XXXXXX",
            },
        },
    }

    # prod_base64 = os.environ.get("INPUT_PROD_JSON")
    # staging_base64 = os.environ.get("INPUT_STAGING_JSON")
    prod_base64 = "'eyJwcm9kX2pzb25fdGVzdCI6InByb2RfanNvbl90ZXN0In0='"
    staging_base64 = "eyJzdGFnaW5nX2pzb25fdGVzdCI6InN0YWdpbmdfanNvbl90ZXN0In0="

    create_config_folder(".basedosdados")
    create_json_file(prod_base64, "prod.json", ".basedosdados")
    create_json_file(staging_base64, "staging.json", ".basedosdados")
    save_toml(config_dict, "config.toml", ".basedosdados")

    check_function()

    print([f for f in Path().home().iterdir() if f.is_dir()])


if __name__ == "__main__":
    main()
