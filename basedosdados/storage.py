from pathlib import Path
from tqdm import tqdm

from basedosdados.base import Base


class Storage(Base):
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
            - `raw` : that contains really raw data
            - `staging` : preprocessed data ready to upload to BigQuery

        Parameters
        ----------
        replace : bool, optional
            Whether to replace if bucket already exists, by default False
        very_sure : bool, optional
            Are you aware that everything is going to be erased if you
            replace the bucket?, by default False

        Raises
        ------
        Warning
            very_sure argument is still False.
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
        mode,
        partitions=None,
        if_exists="raise",
        **upload_args,
    ):
        """Upload file or folder to storage.

        The file will be saved at `<bucket_name>/<mode>/<dataset_id>/<table_id>`.

        You can add just a file, a bunch of files or partitioned files.

        To add a file, just point `path` to the filepath.

        To add a bunch a files, just point `path` to the folder with the files.
        But, the folder should just contain the files and no folders.

        To add partitioned files, you have to previously have set your folders
        following the hive partitioning scheme. The folders follow the pattern
        `<key>=<value>/<key2>=<value2>`, ex: `country=brasil/year=2020`.

        Remember that all files should follow the same schema. Otherwise, things
        might fail in the future.

        There are two modes:
            `raw` : should contain raw files from datasource
            `staging` : should contain pre-treated files ready to upload to BiqQuery

        Parameters
        ----------
        path : str or pathlib.PosixPath
            Where to find the file or folderthat you want to upload to storage
        mode : str
            Folder of which dataset to update [raw|staging], by default "all"
        partitions : (str, pathlib.PosixPath, dict), optional
            Adds data to a specific partition. Just works with single file, by default None
            str : `<key>=<value>/<key2>=<value2>`
            dict: `dict(key=value, key2=value2)`
        if_exists : str, optional
            What to do if data exists, by default "raise"
            - 'raise' : Raises Conflict exception
            - 'replace' : Replace table
            - 'pass' : Do nothing
        """

        self._check_mode(mode)

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

        for filepath, part in tqdm(list(zip(paths, parts)), desc="Uploading files"):

            blob_name = self._build_blob_name(filepath.name, mode, part)

            blob = self.bucket.blob(blob_name)

            if not blob.exists() or if_exists == "replace":

                upload_args["timeout"] = upload_args.get("timeout", None)

                blob.upload_from_filename(str(filepath), **upload_args)

            else:
                raise Exception(
                    f"Data already exists at {self.bucket_name}/{blob_name}. "
                    "Set if_exists to 'replace' to overwrite data"
                )

    def delete_file(self, filename, mode, partitions=None, not_found_ok=False):
        """Deletes file from path `<bucket_name>/<mode>/<dataset_id>/<table_id>/<partitions>/<filename>`.

        Parameters
        ----------
        filename : str
            Name of the file to be deleted
        mode : str
            Folder of which dataset to update [raw|staging], by default "all"
        partitions : (str, pathlib.PosixPath, dict), optional
            Hive structured partition as a string or dict, by default None
            str : `<key>=<value>/<key2>=<value2>`
            dict: `dict(key=value, key2=value2)`
        not_found_ok : bool, optional
            What to do if file not found, by default False
        """

        blob = self.bucket.blob(self._build_blob_name(filename, mode, partitions))

        if blob.exists():
            blob.delete()
        elif not_found_ok:
            return
        else:
            blob.delete()
