cdimport os
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

    return (
        yaml.load(open(f"{table_path}/table_config.yaml", "r"), Loader=yaml.FullLoader),
        configs_path,
    )


def replace_project_id(configs_path, dataset_id, table_id):

    table_config, configs_path = load_configs(dataset_id, table_id)

    metadata_path = configs_path["metadata_path"]
    table_path = f"{metadata_path}/{dataset_id}/{table_id}"

    user_staging_id = table_config["project_id_staging"]
    user_prod_id = table_config["project_id_prod"]

    bq_prod_id = configs_path["gcloud-projects"]["prod"]["name"]
    bq_staging_id = configs_path["gcloud-projects"]["staging"]["name"]

    sql_file = Path(table_path + "/publish.sql").open("r").read()

    sql_final = sql_file.replace(f"{user_prod_id}.", f"{bq_prod_id}.")
    sql_final = sql_final.replace(f"{user_staging_id}.", f"{bq_staging_id}.")

    Path(table_path + "/publish.sql").open("w").write(sql_final)


def is_partitioned(table_config):
    return table_config["partitions"] is not None


def get_table_dataset_id():
    changes = json.load(Path("/github/workspace/files.json").open("r"))
    dict_id = {}
    for change_file in changes:
        if "table_config.yaml" in change_file:
            keys = yaml.load(open(change_file, "r"), Loader=yaml.SafeLoader)
            dict_id[keys["table_id"]] = {
                "dataset_id": keys["dataset_id"],
                "source_bucket_name": keys["source_bucket_name"],
            }
    return dict_id


def push_table_to_bq(
    dataset_id,
    table_id,
    source_bucket_name="basedosdados-dev",
    destination_bucket_name="basedosdados",
    backup_bucket_name="basedosdados-staging",
):

    sync_bucket(
        source_bucket_name,
        dataset_id,
        table_id,
        destination_bucket_name,
        backup_bucket_name,
    )

    table_config, configs_path = load_configs(dataset_id, table_id)
    replace_project_id(configs_path, dataset_id, table_id)

    tb = bd.Table(table_id, dataset_id)
    tb.create(
        "",
        if_table_exists="replace",
        if_storage_data_exists="pass",
        if_table_config_exists="pass",
        partitioned=is_partitioned(table_config),
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
        "metadata_path": "/github/workspace/bases",
        "gcloud-projects": {
            "staging": {
                "name": "test13-01",
                "credentials_path": "/github/home/.basedosdados/credentials/staging.json",
            },
            "prod": {
                "name": "test13-01",
                "credentials_path": "/github/home/.basedosdados/credentials/prod.json",
            },
        },
    }

    # prod_base64 = os.environ.get("INPUT_PROD_JSON")
    # staging_base64 = os.environ.get("INPUT_STAGING_JSON")
    prod_base64 = """'ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAidGVzdDEzLTAx
IiwKICAicHJpdmF0ZV9rZXlfaWQiOiAiODZhOGM4MmYwMWZhNTgzOTYzNTU3MzFkZmYxMTI4NWEz
MWQ3ZDllZSIsCiAgInByaXZhdGVfa2V5IjogIi0tLS0tQkVHSU4gUFJJVkFURSBLRVktLS0tLVxu
TUlJRXZBSUJBREFOQmdrcWhraUc5dzBCQVFFRkFBU0NCS1l3Z2dTaUFnRUFBb0lCQVFDNjNhMlJa
VUx0bGw2b1xuT0QyQ0lhKzNDaVBadDhicUxpZG81RHcyV3VDOHo4UmJTWlNDM3RlUTVlQW1IMTNI
TzVtYTZ3QkxHYXYyNWNNN1xuenFsRVphdERnY3I4S2xXTUhnZGdYRjNwU0JDTEdlbEpEVS82NW9U
SXZuYnlTU3h4cFliUFdzWWRIZGNjbEhFQ1xuSXdqNEREMmFneWJmT2M4M1BKQWYzZkM1T1lUbXBL
dUl4T0owTEdxaVlVdkFZY2k4QTlqVWRUalhvbUtlMzlyZFxuM1hySGtJWHZoWHM1cklRTEozVVJZ
NXJwRklSYnV5MWJ0UHpndHd2eUZWQWo1K3RJMk1PUDUraHA4ODEyTHlScVxuUkhmTUxOYlJteGhy
YkF3Zk1ycW1qSS9sRytucndWY1dFcGNEVFpCS0xjdDc5RzYra2QwWFNxNzB0Mk5YeUdka1xuQ1Ix
ODlSbnpBZ01CQUFFQ2dnRUFDUVVTcVlMK3gyL2xTV0tiK2tCRE5uUURjcGQvdnhqVG9QWHJXVk9F
ZEY4WVxubkxBNnZsUUc4Q0Q0YzNIVWpNcGdTZTF2L1RBSENmRklDcUJtRjZRWDR0Rk0xbVJndTRp
QVZYTC83a084Y0xEV1xuZnVCcEJvR1BPSFZoSG5JRHcyRmZDWHJabmFYSFNpbXNJZm1zSjF0aGdF
R2N5b2VlQmZSV09XbjA2TjhlR0NTd1xuWHl6cEUxZ0VVRnF5a0lkNDBQNUZaeFpkZWJwQlZTTFl3
OUk0TmNhUjQyZElSUVBVRUFoN1ZhckxvNjVIdzVVWFxuMzgwb21JWWlGbXJxV2lrbXBrYWFWTUpB
emYxUS9qcTRHdGxtYmtPVERuMmQ0VC9abHpTRHBUaXJCN08vdHAzdFxuVmV0V0xtYm5tSzlRd3lB
Y1MyZENSaG9CNEJ5SG04SzN3NUdMY0s1ditRS0JnUURlY3RHN1ROZEQvSFJwM3h2TVxuT0RHcFpK
RjNianVXSXFoTU5CWDUyUlZIcS9hZ1Z1SlBzZnlBMTN3S1Y4TzRTM1F5aUl1ZjJvVVNhNEg1MUI3
WlxuLzJYTTZ3Lys5OGdJdWN3eitaR05rdGU5TlkxaitWeTMwaHRtdTBRaXFVTm9LVTN5b1ZsR3g0
SUUyWkdFUmhHSFxuUSt3amx4Q25BcThMeElBc3FVK21uNENJOXdLQmdRRFhEUEc1ZXBqNlpuNnpY
SjRCWmNZOXN4T2lWQ3diVHJURlxuK25yRWVQSmNTaGxreXBuelM1dng1bEJuUGFsSERKaytnTnVM
cWJ4Q2FVZTlLWE5oOTdHZGtHdEh4UGJZTmdJd1xubmVVNlhoSjlEOVgvZ2J1VmtqM2NTSzJVV3ds
QlZGTHR6SklqSlpVSWlSYm9zOGpVRUYwTUZKOFh2Nm9CYWlWQ1xuYlRCZ0srSFQ1UUtCZ0NvNWNV
WTBWOGczNjRFTk1LR2JLUklXWE9abXJqalphMGpMdWtBcXpMZEdGUkpxYTVybFxuRmlEK3hqVFFZ
LzVmbERialpGMTdoVGJ4NFVJaTJaaFh1bU1qVzIzeWFxMzlWcDJuQ2RIdHhiWE1ySUlGbTJ2cFxu
SGZwcUlZelN4RkRKUmxwLzlncFJaSVMzSjhBTDdOZllOTUtzc2lTQmhlaWQ3QmFPTE9oYjduSVJB
b0dBYmhZZFxuUkJMamJ3TzdCbng2RWtNVVdZOXJsS1M4TTNwMkJnYzBnNUZhbUM0Q2s5czNOaG5W
aWQ2WitFL1RjU0NjN2ljdVxudkc4MmhWUzV1YmNYYnVaS2tWdFYzOWFQZXAwalA5b0VkMzJpdjB5
MUF1aFpxN2JDWGhzQ2FMaTFvekRVaHhFN1xuR2l6cC93V1dxYWNuUG8vbDRnSkljdkxWeDRXYjcw
WlFCbHRRYnBVQ2dZQVQwV2hxeTUrejR6NWtkUEh4ZkxpY1xuZ2gvZm53OFJLR0FoTmNubjZXdGFB
MzVWRXZCaHJPRGJxK1g3MWlKSXpqYk5sa2ZqRzU0MjlFcmJQTmhaTzB4Z1xuT3NWSmZiM2Z5SmRO
YTRvNFdsOThJTFVPQlRUMjBFNHJtd09mcmUxamh1QzM2YXlOYldQTi9vWEhGNWxKUU0zclxubFlQ
dFk5VGFOWHR5ckdmZi91WWJYdz09XG4tLS0tLUVORCBQUklWQVRFIEtFWS0tLS0tXG4iLAogICJj
bGllbnRfZW1haWwiOiAiY2Fpby04MTdAdGVzdDEzLTAxLmlhbS5nc2VydmljZWFjY291bnQuY29t
IiwKICAiY2xpZW50X2lkIjogIjEwMTIzMTk3ODk0OTEzNDk2ODExOSIsCiAgImF1dGhfdXJpIjog
Imh0dHBzOi8vYWNjb3VudHMuZ29vZ2xlLmNvbS9vL29hdXRoMi9hdXRoIiwKICAidG9rZW5fdXJp
IjogImh0dHBzOi8vb2F1dGgyLmdvb2dsZWFwaXMuY29tL3Rva2VuIiwKICAiYXV0aF9wcm92aWRl
cl94NTA5X2NlcnRfdXJsIjogImh0dHBzOi8vd3d3Lmdvb2dsZWFwaXMuY29tL29hdXRoMi92MS9j
ZXJ0cyIsCiAgImNsaWVudF94NTA5X2NlcnRfdXJsIjogImh0dHBzOi8vd3d3Lmdvb2dsZWFwaXMu
Y29tL3JvYm90L3YxL21ldGFkYXRhL3g1MDkvY2Fpby04MTclNDB0ZXN0MTMtMDEuaWFtLmdzZXJ2
aWNlYWNjb3VudC5jb20iCn0K'"""
    staging_base64 = prod_base64

    create_config_folder(".basedosdados")
    create_json_file(prod_base64, "prod.json", ".basedosdados")
    create_json_file(staging_base64, "staging.json", ".basedosdados")
    save_toml(config_dict, "config.toml", ".basedosdados")

    dict_id = get_table_dataset_id()

    for table_id in dict_id.keys():
        source_bucket_name = dict_id[table_id]["source_bucket_name"]
        dataset_id = dict_id[table_id]["dataset_id"]
        print(source_bucket_name, dataset_id)
        push_table_to_bq(
            dataset_id=dataset_id,
            table_id=table_id,
            source_bucket_name=source_bucket_name,
            destination_bucket_name="test-13-01-bucket",
            backup_bucket_name="test-13-01-backup",
        )

    # "/github/workspace/files.json"

    check_function()

    print("\n/github folders")
    print([f for f in Path("/github").iterdir() if f.is_dir()])

    print("\n/workspace folders")
    print([f for f in Path("/github/workspace").iterdir() if f.is_dir()])


if __name__ == "__main__":
    main()
