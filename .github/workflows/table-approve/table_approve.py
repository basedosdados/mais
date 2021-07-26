import json
import os
import traceback
from pathlib import Path

import basedosdados as bd
import yaml
from basedosdados import Dataset, Storage
from basedosdados.upload.base import Base


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
    print("REPLACE PUBLISH.SQL")
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

    print("user_prod_id: ", user_prod_id)
    print("user_staging_id: ", user_staging_id)
    print("bq_prod_id: ", bq_prod_id)
    print("bq_staging_id: ", bq_staging_id)

    # load publish.sql file with the query for create the VIEW in production
    sql_file = Path(table_path + "/publish.sql").open("r").read()

    # replace the project id name of the source for the production (basedosdados project)
    sql_final = sql_file.replace(f"{user_prod_id}.", f"{bq_prod_id}.", 1)
    sql_final = sql_final.replace(f"{user_staging_id}.", f"{bq_staging_id}.")

    print(sql_final)

    # write the replaced file
    Path(table_path + "/publish.sql").open("w").write(sql_final)


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

    # MAKE A BACKUP OF OLD DATA
    if len(list(destination_ref)):
        print(
            f"\n########################################### COPY BACKUP ###########################################\n"
        )
        ref.copy_table(
            source_bucket_name=destination_bucket_name,
            destination_bucket_name=backup_bucket_name,
        )
        print(
            f"\n########################################## DELETE OLD DATA  ##########################################\n"
        )
        # DELETE OLD DATA FROM PROD
        ref.delete_table(not_found_ok=True)
    print(
        f"\n########################################### COPY NEW DATA  ###########################################\n"
    )
    # COPIES DATA TO DESTINATION
    ref.copy_table(source_bucket_name=source_bucket_name)


def get_table_dataset_id():
    # load the change files in PR || diff between PR and master
    changes = json.load(Path("/github/workspace/files.json").open("r"))
    print(changes)
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
        else:
            print(
                "\n###==============================================================================================###",
                f"\n{str(filepath)} does not exist on current commit",
                "\n###==============================================================================================###\n",
            )
    return dataset_table_ids


def push_table_to_bq(
    dataset_id,
    table_id,
    source_bucket_name="basedosdados-dev",
    destination_bucket_name="basedosdados",
    backup_bucket_name="basedosdados-staging",
):

    # Copies proprosed data between storage buckets.
    # Creates a backup of old data, then delete it and copies new data into the destination bucket.
    sync_bucket(
        source_bucket_name,
        dataset_id,
        table_id,
        destination_bucket_name,
        backup_bucket_name,
    )

    # laod the table_config.yalm to get the metadata IDs
    table_config, configs_path = load_configs(dataset_id, table_id)
    # adjust the correct project ID in publish sql
    replace_project_id_publish_sql(configs_path, dataset_id, table_id)

    # create Table object of selected table and dataset ID
    tb = bd.Table(table_id, dataset_id)

    # delete table from staging and prod if exists
    tb.delete("all")

    # create the staging table in bigquery
    tb.create(
        path=None,
        if_table_exists="replace",
        if_storage_data_exists="pass",
        if_table_config_exists="pass",
    )
    # publish the table in prod bigquery
    tb.publish(if_exists="replace")
    # updates the table description
    tb.update("prod")
    # updates the dataset description
    Dataset(dataset_id).update("prod")


def main():
    print(os.environ.get("INPUT_PROJECT_ID"))
    print(Path.home())
    
    # find the dataset and tables of the PR
    dataset_table_ids = get_table_dataset_id()

    print(f"Tables found: {dataset_table_ids}")
    # iterate over each table in dataset of the PR
    for table_id in dataset_table_ids.keys():
        dataset_id = dataset_table_ids[table_id]["dataset_id"]
        source_bucket_name = dataset_table_ids[table_id]["source_bucket_name"]
        # push the table to bigquery
        try:
            push_table_to_bq(
                dataset_id,
                table_id,
                source_bucket_name,
                destination_bucket_name=os.environ.get("INPUT_DESTINATION_BUCKET_NAME"),
                backup_bucket_name=os.environ.get("INPUT_BACKUP_BUCKET_NAME"),
            )
        except Exception as error:
            print(
                "\n###====================================================================================================###",
                f"\n{dataset_id}.{table_id}",
            )
            traceback.print_exc()
            print(
                "\n###====================================================================================================###\n",
            )


if __name__ == "__main__":
    main()
