from basedosdados.storage import Storage
from basedosdados.base import Base
import basedosdados


def sync_bucket(
    source_bucket_name,
    dataset_id,
    table_id,
    destination_bucket_name,
    backup_bucket_name,
    mode="staging",
):

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
        ref.copy_table(
            source_bucket_name=destination_bucket_name,
            destination_bucket_name=backup_bucket_name,
        )

        # DELETE OLD DATA FROM PROD
        for blob in destination_ref:
            ref.delete_file(filename=str(blob.name).replace(prefix, ""), mode=mode)

        # COPIES DATA TO DESTINATION
        ref.copy_table(source_bucket_name=source_bucket_name)
