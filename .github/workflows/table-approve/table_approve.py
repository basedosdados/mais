import json
import os
import traceback
from pathlib import Path
from pprint import pprint
import sys
import time

import basedosdados as bd
import yaml
from basedosdados import Dataset, Storage
from basedosdados.upload.base import Base
from basedosdados.upload.metadata import Metadata # TODO: deprecate


def tprint(title=""):
    if not len(title):
        print(
            "\n",
            "#" * 80,
            "\n",
        )
    else:
        size = 38 - int(len(title) / 2)
        print("\n\n\n", "#" * size, title, "#" * size, "\n")


def load_configs(dataset_id, table_id):
    # get the config file in .basedosdados/config.toml
    configs_path = Base()._load_config()

    # get the path to metadata_path, where the folder bases with metadata information
    metadata_path = configs_path["metadata_path"]

    # get the path to table_config.yaml
    table_path = f"{metadata_path}/{dataset_id}/{table_id}"

    return (
        # load the table_config.yaml
        yaml.load(open(f"{table_path}/table_config.yaml", "r"), Loader=yaml.FullLoader),
        # return the path to .basedosdados configs
        configs_path,
    )


def replace_project_id_publish_sql(configs_path, dataset_id, table_id):
    tprint("REPLACE PUBLISH.SQL")

    # load the paths to metadata and configs folder
    table_config, configs_path = load_configs(dataset_id, table_id)
    metadata_path = configs_path["metadata_path"]
    table_path = f"{metadata_path}/{dataset_id}/{table_id}"

    # load the source project id to staging and pro data in bigquery
    user_staging_id = table_config["project_id_staging"]
    user_prod_id = table_config["project_id_prod"]

    # load the destination project id to staging and prod data in bigquery
    bq_prod_id = configs_path["gcloud-projects"]["prod"]["name"]
    bq_staging_id = configs_path["gcloud-projects"]["staging"]["name"]

    # load publish.sql file with the query for create the VIEW in production
    sql_file = Path(table_path + "/publish.sql").open("r").read()

    # replace the project id name of the source for the production (basedosdados project)
    sql_final = sql_file.replace(f"{user_prod_id}.", f"{bq_prod_id}.", 1)
    sql_final = sql_final.replace(f"{user_staging_id}.", f"{bq_staging_id}.")

    print(sql_final)

    # write the replaced file
    Path(table_path + "/publish.sql").open("w").write(sql_final)


def get_table_dataset_id():
    # load the change files in PR || diff between PR and master
    changes = Path("files.json").open("r")
    changes = json.load(changes)

    # create a dict to save the dataset and source_bucket related to each table_id
    dataset_table_ids = {}

    # create a list to save the table folder path, for each table changed in the commit
    table_folders = []
    for change_file in changes:
        # get the directory path for a table with changes
        file_dir = Path(change_file).parent

        # append the table directory if it was not already appended
        if file_dir not in table_folders:
            table_folders.append(file_dir)

    # construct the iterable for the table_config paths
    table_config_paths = [Path(root / "table_config.yaml") for root in table_folders]

    # iterate through each config path
    for filepath in table_config_paths:

        # check if the table_config.yaml exists in the changed folder
        if filepath.is_file():

            # load the found table_config.yaml
            table_config = yaml.load(open(filepath, "r"), Loader=yaml.SafeLoader)

            # add the dataset and source_bucket for each table_id
            dataset_table_ids[table_config["table_id"]] = {
                "dataset_id": table_config["dataset_id"],
                "source_bucket_name": table_config["source_bucket_name"],
            }

    return dataset_table_ids


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
        mode (str): Optional
            Folder of which dataset to update.[raw|staging|header|auxiliary_files|architecture]

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
        raise ValueError(
            f"No objects found on the source bucket {source_bucket_name}.{prefix}"
        )

    if len(list(destination_ref)):
        backup_bucket_blobs = list(
            ref.client["storage_staging"]
            .bucket(backup_bucket_name)
            .list_blobs(prefix=prefix)
        )
        if len(backup_bucket_blobs):
            tprint(f"{mode.upper()}: DELETE BACKUP DATA")
            ref.delete_table(
                not_found_ok=True, mode=mode, bucket_name=backup_bucket_name
            )

        tprint(f"{mode.upper()}: BACKUP OLD DATA")
        ref.copy_table(
            source_bucket_name=destination_bucket_name,
            destination_bucket_name=backup_bucket_name,
            mode=mode,
        )

        tprint(f"{mode.upper()}: DELETE OLD DATA")
        ref.delete_table(
            not_found_ok=True, mode=mode, bucket_name=destination_bucket_name
        )

    tprint(f"{mode.upper()}: TRANSFER NEW DATA")
    ref.copy_table(
        source_bucket_name=source_bucket_name,
        destination_bucket_name=destination_bucket_name,
        mode=mode,
    )


def save_header_files(dataset_id, table_id):
    ### save table header in storage
    query = f"""
    SELECT * FROM `basedosdados.{dataset_id}.{table_id}` LIMIT 20
    """
    df = bd.read_sql(query, billing_project_id="basedosdados", from_file=True)
    df.to_csv("header.csv", index=False, encoding="utf-8")
    st = bd.Storage(dataset_id=dataset_id, table_id=table_id)
    st.upload("header.csv", mode="header", if_exists="replace")


def push_table_to_bq(
    dataset_id,
    table_id,
    source_bucket_name="basedosdados-dev",
    destination_bucket_name="basedosdados",
    backup_bucket_name="basedosdados-backup",
):
    # copy proprosed data between storage buckets
    # create a backup of old data, then delete it and copies new data into the destination bucket
    modes = ["staging", "raw", "auxiliary_files", "architecture", "header"]

    for mode in modes:
        try:
            sync_bucket(
                source_bucket_name=source_bucket_name,
                dataset_id=dataset_id,
                table_id=table_id,
                destination_bucket_name=destination_bucket_name,
                backup_bucket_name=backup_bucket_name,
                mode=mode,
            )
            tprint()
        except Exception as error:
            tprint(f"DATA ERROR ON {mode}.{dataset_id}.{table_id}")
            traceback.print_exc(file=sys.stderr)
            tprint()

    # load the table_config.yaml to get the metadata IDs
    table_config, configs_path = load_configs(dataset_id, table_id)
    # adjust the correct project ID in publish sql
    replace_project_id_publish_sql(configs_path, dataset_id, table_id)
    # create table object of selected table and dataset ID
    tb = bd.Table(dataset_id=dataset_id, table_id=table_id)

    # delete table from staging and prod if exists
    tb.delete("all")

    # create the staging table in bigquery
    tb.create(
        path=None,
        if_table_exists="replace",
        if_storage_data_exists="pass",
        if_table_config_exists="pass",
        dataset_is_public=True,
    )

    # publish the table in prod bigquery
    tb.publish(if_exists="replace")

    # updates the table description
    tb.update("prod")

    # updates the dataset description
    Dataset(dataset_id).update(mode="prod")

    ### save table header in storage
    save_header_files(dataset_id, table_id)


def pretty_log(dataset_id, table_id, source_bucket_name):
    source_len = len(source_bucket_name)
    source_len -= 9 if "basedosdados" in source_bucket_name else 0

    # fmt: off
    print(
        "\n###================================================================================###",
        "\n###                                                                                ###",
        "\n###               Data successfully synced and created in bigquery                 ###",
        "\n###                                                                                ###",
        f"\n###               Dataset      : {dataset_id} ", " " * (47 - len(dataset_id)),   "###",
        f"\n###               Table        : {table_id}", " " * (48 - len(table_id)),        "###",
        f"\n###               Source Bucket: {source_bucket_name}", " " * (48 - source_len), "###",
        "\n###                                                                                ###",
        "\n###================================================================================###\n",
    )
    # fmt: on


def table_approve():
    # find the dataset and tables of the PR
    dataset_table_ids = get_table_dataset_id()

    # print dataset tables info
    tprint("TABLES FOUND")
    pprint(dataset_table_ids)
    tprint()
    # iterate over each table in dataset of the PR
    for table_id in dataset_table_ids.keys():
        dataset_id = dataset_table_ids[table_id]["dataset_id"]
        source_bucket_name = dataset_table_ids[table_id]["source_bucket_name"]

        # criate a bigquery table in prod
        try:
            # push the table to bigquery
            tprint(f"STARTING TABLE APPROVE ON {dataset_id}.{table_id}")
            push_table_to_bq(
                dataset_id=dataset_id,
                table_id=table_id,
                source_bucket_name=source_bucket_name,
                destination_bucket_name=os.environ.get("BUCKET_NAME_DESTINATION"),
                backup_bucket_name=os.environ.get("BUCKET_NAME_BACKUP"),
            )
            pretty_log(dataset_id, table_id, source_bucket_name)
            tprint()
        except Exception as error:
            tprint(f"DATA ERROR ON {dataset_id}.{table_id}")
            traceback.print_exc(file=sys.stderr)
            tprint()
        # pubish Metadata in prod
        try:
            # create table metadata object
            md = Metadata(dataset_id=dataset_id, table_id=table_id)

            # check if correspondent dataset metadata already exists in CKAN
            if not md.dataset_metadata_obj.exists_in_ckan():
                # validate dataset metadata
                md.dataset_metadata_obj.validate()
                tprint(f"SUCESS VALIDATE {dataset_id}")

                # publish dataset metadata to CKAN
                md.dataset_metadata_obj.publish()

                # run multiple tries to get published dataset metadata from
                # ckan till it is published: dataset metadata must be
                # accessible for table metadata to be published too
                tprint(f"WAITING FOR {dataset_id} METADATA PUBLISHMENT...")
                MAX_RETRIES = 80
                retry_count = 0
                while not md.dataset_metadata_obj.exists_in_ckan():
                    time.sleep(15)
                    retry_count += 1
                    if retry_count >= MAX_RETRIES:
                        break

                if md.dataset_metadata_obj.exists_in_ckan():
                    tprint(f"SUCESS PUBLISH {dataset_id}")
                else:
                    tprint(f"ERROR PUBLISH {dataset_id}")

            # validate table metadata
            md.validate()
            tprint(f"SUCESS VALIDATE {dataset_id}.{table_id}")
            # publish table metadata to CKAN
            md.publish(if_exists="replace")
            tprint(f"SUCESS PUBLISHED {dataset_id}.{table_id}")
            tprint()
        except Exception as error:
            tprint(f"METADATA ERROR ON {dataset_id}.{table_id}")
            traceback.print_exc(file=sys.stderr)
            tprint()


if __name__ == "__main__":
    table_approve()
