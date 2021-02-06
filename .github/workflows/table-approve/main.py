import os
from pathlib import Path
import yaml
import json

import basedosdados as bd
from basedosdados.base import Base
from basedosdados.storage import Storage
import basedosdados


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


def main():

    print(json.load(Path("/github/workspace/files.json").open("r")))
    
    print(os.environ.get("INPUT_PROJECT_ID"))
    
    

if __name__ == "__main__":
    main()
