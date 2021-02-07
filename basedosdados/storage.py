from pathlib import Path
from tqdm import tqdm

from basedosdados.base import Base


class Storage(Base):
    """
    Manage files on Google Cloud Storage.
    """

    def __init__(self, dataset_id=None, table_id=None, **kwargs):
        super().__init__(**kwargs)

        self.bucket = self.client["storage_staging"].bucket(self.bucket_name)
        self.dataset_id = dataset_id.replace("-", "_")
        self.table_id = table_id.replace("-", "_")

    def _resolve_partitions(self, partitions):

        if isinstance(partitions, dict):

            return "/".join([f"{k}={v}" for k, v in partitions.items()]) + "/"

        elif isinstance(partitions, str):

            if partitions.endswith("/"):
                partitions = partitions[:-1]

            # If there is no partition
            if len(partitions) == 0:
                return ""

            # It should fail if there is folder which is not a partition
            try:
                # check if it fits rule
                {b.split("=")[0]: b.split("=")[1] for b in partitions.split("/")}
            except IndexError:
                raise Exception(f"The path {partitions} is not a valid partition")

            return partitions + "/"

        else:

            raise Exception(f"Partitions format or type not accepted: {partitions}")

    def _build_blob_name(self, filename, mode, partitions=None):

        # table folder
        blob_name = f"{mode}/{self.dataset_id}/{self.table_id}/"

        # add partition folder
        if partitions is not None:

            blob_name += self._resolve_partitions(partitions)

        # add file name
        blob_name += filename

        return blob_name

    def init(self, replace=False, very_sure=False):
        """Initializes bucket and folders.

        Folder should be:

        * `raw` : that contains really raw data
        * `staging` : preprocessed data ready to upload to BigQuery

        Args:
            replace (bool): Optional.
                Whether to replace if bucket already exists
            very_sure (bool): Optional.
                Are you aware that everything is going to be erased if you
                replace the bucket?

        Raises:
            Warning: very_sure argument is still False.
        """

        if replace:
            if not very_sure:
                raise Warning(
                    "\n********************************************************"
                    "\nYou are trying to replace all the data that you have "
                    f"in bucket {self.bucket_name}.\nAre you sure?\n"
                    "If yes, add the flag --very_sure\n"
                    "********************************************************"
                )
            else:
                self.bucket.delete(force=True)

        self.client["storage_staging"].create_bucket(self.bucket)

        for folder in ["staging/", "raw/"]:

            self.bucket.blob(folder).upload_from_string("")

    def upload(
        self,
        path,
        mode="all",
        partitions=None,
        if_exists="raise",
        **upload_args,
    ):
        """Upload to storage at `<bucket_name>/<mode>/<dataset_id>/<table_id>`. You can:

        * Add a single **file** setting `path = <file_path>`.

        * Add a **folder** with multiple files setting `path =
          <folder_path>`. *The folder should just contain the files and
          no folders.*

        * Add **partitioned files** setting `path = <folder_path>`.
          This folder must follow the hive partitioning scheme i.e.
          `<table_id>/<key>=<value>/<key2>=<value2>/<partition>.csv`
          (ex: `mytable/country=brasil/year=2020/mypart.csv`).

        *Remember all files must follow a single schema.* Otherwise, things
        might fail in the future.

        There are 3 modes:

        * `raw` : should contain raw files from datasource
        * `staging` : should contain pre-treated files ready to upload to BiqQuery
        * `all`: if no treatment is needed, use `all`.

        Args:
            path (str or pathlib.PosixPath): Where to find the file or
                folder that you want to upload to storage

            mode (str): Folder of which dataset to update [raw|staging|all]

            partitions (str, pathlib.PosixPath, or dict): Optional.
                *If adding a single file*, use this to add it to a specific partition.

                * str : `<key>=<value>/<key2>=<value2>`
                * dict: `dict(key=value, key2=value2)`

            if_exists (str): Optional.
                What to do if data exists

                * 'raise' : Raises Conflict exception
                * 'replace' : Replace table
                * 'pass' : Do nothing

            upload_args ():
                Extra arguments accepted by [`google.cloud.storage.blob.Blob.upload_from_file`](https://googleapis.dev/python/storage/latest/blobs.html?highlight=upload_from_filename#google.cloud.storage.blob.Blob.upload_from_filename)
        """

        if (self.dataset_id is None) or (self.table_id is None):
            raise Exception("You need to pass dataset_id and table_id")

        path = Path(path)

        if path.is_dir():
            paths = [f for f in path.glob("**/*") if f.is_file() and f.suffix == ".csv"]

            parts = [
                (
                    str(filepath)
                    .replace(str(path) + "/", "")
                    .replace(str(filepath.name), "")
                )
                for filepath in paths
            ]

        else:
            paths = [path]
            parts = [partitions or None]

        self._check_mode(mode)

        if mode == "all":
            mode = ["raw", "staging"]
        else:
            mode = [mode]

        for m in mode:

            for filepath, part in tqdm(list(zip(paths, parts)), desc="Uploading files"):

                blob_name = self._build_blob_name(filepath.name, m, part)

                blob = self.bucket.blob(blob_name)

                if not blob.exists() or if_exists == "replace":

                    upload_args["timeout"] = upload_args.get("timeout", None)

                    blob.upload_from_filename(str(filepath), **upload_args)

                elif if_exists == "pass":

                    pass

                else:
                    raise Exception(
                        f"Data already exists at {self.bucket_name}/{blob_name}. "
                        "Set if_exists to 'replace' to overwrite data"
                    )

    def delete_file(self, filename, mode, partitions=None, not_found_ok=False):
        """Deletes file from path `<bucket_name>/<mode>/<dataset_id>/<table_id>/<partitions>/<filename>`.

        Args:
            filename (str): Name of the file to be deleted

            mode (str): Folder of which dataset to update [raw|staging|all]

            partitions (str, pathlib.PosixPath, or dict): Optional.
                Hive structured partition as a string or dict

                * str : `<key>=<value>/<key2>=<value2>`
                * dict: `dict(key=value, key2=value2)`

            not_found_ok (bool): Optional.
                What to do if file not found
        """

        self._check_mode(mode)

        if mode == "all":
            mode = ["raw", "staging"]
        else:
            mode = [mode]

        for m in mode:

            blob = self.bucket.blob(self._build_blob_name(filename, m, partitions))

            if blob.exists():
                blob.delete()
            elif not_found_ok:
                return
            else:
                blob.delete()

    def delete_table(self, mode="staging", bucket_name=None, not_found_ok=False):
        """Deletes a table from storage, sends request in batches.
        If your request requires more than 1000 blobs, you should divide it in multiple requests.

        #TODO: auto divides into multiple requests

        Args:
            mode (str): Optional
                Folder of which dataset to update.

            bucket_name (str):
                The bucket name from which to delete the table. If None, defaults to the bucket initialized when instantiating the Storage object.
                (You can check it with the Storage().bucket property)

            not_found_ok (bool): Optional.
                What to do if table not found

        """
        prefix = f"{mode}/{self.dataset_id}/{self.table_id}/"

        if bucket_name is not None:

            table_blobs = self.bucket(f"{bucket_name}").list_blobs(prefix=prefix)

        else:

            table_blobs = self.bucket.list_blobs(prefix=prefix)

        with self.client["storage_staging"].batch():

            for blob in table_blobs:
                self.delete_file(
                    filename=str(blob.name).replace(prefix, ""),
                    mode=mode,
                    not_found_ok=not_found_ok,
                )
                print(f"{blob.name} deleted sucessfully!")

    def copy_table(
        self,
        source_bucket_name="basedosdados",
        destination_bucket_name=None,
        mode="staging",
    ):
        """Copies table from a source bucket to your bucket, sends request in batches.
        If your request requires more than 1000 blobs, you should divide it in multiple requests.

        #TODO: auto divides into multiple requests

        Args:
            source_bucket_name (str):
                The bucket name from which to copy data. You can change it
                to copy from other external bucket.

            destination_bucket_name(str): Optional
                The bucket name where data will be copied to.
                If None, defaults to the bucket initialized when instantiating the Storage object (You can check it with the
                Storage().bucket property)

            mode (str): Optional
                Folder of which dataset to update. Defaults to "staging".
        """

        source_table_ref = (
            self.client["storage_staging"]
            .bucket(source_bucket_name)
            .list_blobs(prefix=f"{mode}/{self.dataset_id}/{self.table_id}")
        )

        if destination_bucket_name is None:

            destination_bucket = self.bucket

        else:

            destination_bucket = self.client["storage_staging"].bucket(
                destination_bucket_name
            )

        with self.client["storage_staging"].batch():

            for blob in source_table_ref:
                self.bucket.copy_blob(
                    blob, destination_bucket=destination_bucket
                )
                print(f"{blob.name} copied sucessfully to {destination_bucket.name}")
