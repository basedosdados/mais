from google.cloud import bigquery, storage
from google.oauth2 import service_account
import yaml
from jinja2 import Template
from pathlib import Path, PosixPath
import json
import csv
from enum import Enum
from copy import deepcopy

from google.api_core.exceptions import Conflict
import google.api_core.exceptions
from google.cloud.exceptions import NotFound


class Base:
    def __init__(
        self,
        key_path="secrets/cli-admin.json",
        templates="src/templates",
        bucket_name="basedosdados",
        metadata_path="bases/",
    ):
        self.templates = Path(templates)
        self.metadata_path = Path(metadata_path)
        self.bucket_name = bucket_name

        credentials = service_account.Credentials.from_service_account_file(
            key_path,
            scopes=["https://www.googleapis.com/auth/cloud-platform"],
        )
        self.client = dict(
            bigquery=bigquery.Client(
                credentials=credentials,
                project=credentials.project_id,
            ),
            storage=storage.Client(
                credentials=credentials,
                project=credentials.project_id,
            ),
        )
        self.uri = f"gs://{bucket_name}" + "/staging/{dataset}/{table}/*"

    def _load_yaml(self, file):

        try:
            return yaml.load(open(file, "r"), Loader=yaml.SafeLoader)
        except FileNotFoundError:
            return None

    def _render_template(self, template_file, kargs):

        return Template((self.templates / template_file).open("r").read()).render(
            **kargs
        )

    def _check_mode(self, mode):
        ACCEPTED_MODES = ["all", "staging", "prod"]
        if mode in ACCEPTED_MODES:
            return True
        else:
            raise Exception(
                f"Argument {mode} not supported. "
                f"Enter one of the following: "
                f'{",".join(ACCEPTED_MODES)}'
            )


class Dataset(Base):
    def __init__(self, dataset_id, **kwargs):
        super().__init__(**kwargs)

        self.dataset_id = dataset_id.replace("-", "_")
        self.dataset_folder = Path(self.metadata_path / self.dataset_id)

    @property
    def dataset_config(self):

        return self._load_yaml(
            self.metadata_path / self.dataset_id / "dataset_config.yaml"
        )

    def _create_dataset_ids(self, mode="all"):

        dataset_ids = []

        if (mode == "prod") or (mode == "all"):

            dataset_ids.append(
                f"{self.client['bigquery'].project}.{self.dataset_config['dataset_id']}"
            )

        if (mode == "staging") or (mode == "all"):

            dataset_ids.append(
                f"{self.client['bigquery'].project}.{self.dataset_config['dataset_id']}_staging"
            )

        return dataset_ids

    def _setup_dataset_object(self, dataset_id):

        dataset = bigquery.Dataset(dataset_id)
        dataset.description = self._render_template(
            "dataset/dataset_description.txt", self.dataset_config
        )

        return dataset

    def init(self, replace=False):
        """Initialize dataset folder at metadata_path at `metadata_path/<dataset_id>`.

        The folder should contain:
            - dataset_config.yaml
            - README.md

        Parameters
        ----------
        replace : bool, optional
            Whether to replace existing folder, by default False

        Raises
        ------
        FileExistsError
            If dataset folder already exists and replace is False
        """

        # Create dataset folder
        try:
            self.dataset_folder.mkdir(exist_ok=replace, parents=True)
        except FileExistsError:
            raise FileExistsError(
                f"Dataset {str(self.dataset_folder.stem)} folder does not exists. "
                "Set replace=True to replace current files."
            )

        for file in (Path(self.templates) / "dataset").glob("*"):

            if file.name in ["dataset_config.yaml", "README.md"]:

                # Load and fill template
                template = self._render_template(
                    f"dataset/{file.name}", dict(dataset_id=self.dataset_id)
                )

                # Write file
                (self.dataset_folder / file.name).open("w").write(template)

        # Add code folder
        (self.dataset_folder / "code").mkdir(exist_ok=replace, parents=True)

        return self

    def publicize(self):
        """Changes IAM configuration to turn BigQuery dataset public."""

        dataset = self.client["bigquery"].get_dataset(self.dataset_id)
        entries = dataset.access_entries

        entries.extend(
            [
                bigquery.AccessEntry(
                    role="roles/bigquery.dataViewer",
                    entity_type="iamMember",
                    entity_id="allUsers",
                ),
                bigquery.AccessEntry(
                    role="roles/bigquery.metadataViewer",
                    entity_type="iamMember",
                    entity_id="allUsers",
                ),
                bigquery.AccessEntry(
                    role="roles/bigquery.user",
                    entity_type="iamMember",
                    entity_id="allUsers",
                ),
            ]
        )
        dataset.access_entries = entries

        self.client["bigquery"].update_dataset(dataset, ["access_entries"])

    def create(self, mode="all", if_exists="raise"):
        """Creates BigQuery datasets given `dataset_id`.

        It can create two datasets:
            - <dataset_id>         (mode = 'prod')
            - <dataset_id>_staging (mode = 'staging')

        If mode is all, it creates both.

        Parameters
        ----------
        mode : str, optional
            Which dataset to create [prod|staging|all], by default "all"
        if_exists : str, optional
            What to do if dataset exists, by default "raise"
            - 'raise' : Raises Conflic exception
            - 'replace' : Drop all tables and replace dataset
            - 'update' : Update dataset description
            - 'pass' : Do nothing

        Raises
        ------
        google.api_core.exceptions.Conflict
            Dataset already exists and if_exists is set to 'raise'
        """

        if if_exists == "replace":
            self.delete(mode)
        elif if_exists == "update":
            self.update()
            return

        # Set dataset_id to the ID of the dataset to create.
        for ds_id in self._create_dataset_ids(mode):

            # Construct a full Dataset object to send to the API.
            dataset_obj = self._setup_dataset_object(ds_id)

            # Send the dataset to the API for creation, with an explicit timeout.
            # Raises google.api_core.exceptions.Conflict if the Dataset already
            # exists within the project.
            try:
                job = self.client["bigquery"].create_dataset(
                    dataset_obj
                )  # Make an API request.
            except Conflict:

                if if_exists == "pass":
                    return
                else:
                    raise Conflict(f"Dataset {self.dataset_id} already exists")

        # Make prod dataset public
        self.publicize()

    def delete(self, mode="all"):
        """Delete dataset. Toogle mode to choose which dataset to delete.

        Parameters
        ----------
        mode : str, optional
            Which dataset to delete [prod|staging|all], by default "all"
        """

        for ds_id in self._create_dataset_ids(mode):

            self.client["bigquery"].delete_dataset(
                ds_id, delete_contents=True, not_found_ok=True
            )

    def update(self, mode="all"):
        """Update dataset description. Toogle mode to choose which dataset to update.

        Parameters
        ----------
        mode : str, optional
            Which dataset to update [prod|staging|all], by default "all"
        """

        # Set dataset_id to the ID of the dataset to create.
        dataset_ids = self._create_dataset_ids(mode)

        for ds_id in dataset_ids:

            # Construct a full Dataset object to send to the API.
            dataset = self._setup_dataset_object(ds_id)

            # Send the dataset to the API to update, with an explicit timeout.
            # Raises google.api_core.exceptions.Conflict if the Dataset already
            # exists within the project.
            dataset = self.client["bigquery"].update_dataset(
                dataset, fields=["description"]
            )  # Make an API request.


class Table(Base):
    def __init__(self, table_id, dataset_id, **kwargs):
        super().__init__(**kwargs)

        self.table_id = table_id.replace("-", "_")
        self.dataset_id = dataset_id.replace("-", "_")
        self.dataset_folder = Path(self.metadata_path / self.dataset_id)
        self.table_folder = self.dataset_folder / table_id
        self.table_full_name = dict(
            prod=f"{self.client['bigquery'].project}.{self.dataset_id}.{self.table_id}",
            staging=f"{self.client['bigquery'].project}.{self.dataset_id}_staging.{self.table_id}",
        )
        self.table_full_name.update(dict(all=deepcopy(self.table_full_name)))

    @property
    def table_config(self):
        return self._load_yaml(self.table_folder / "table_config.yaml")

    def _get_table_obj(self, mode):
        return self.client["bigquery"].get_table(self.table_full_name[mode])

    def _load_schema(self, mode="staging", with_partition=True):
        """Load schema from table_config.yaml"""

        self._check_mode(mode)

        json_path = self.table_folder / f"schema-{mode}.json"

        columns = self.table_config["columns"]

        if mode == "staging":
            for c in columns:
                c["type"] = "STRING"

            columns = [c for c in columns if c["is_in_staging"]]

            if not with_partition:
                columns = [c for c in columns if not c["is_partition"]]

        elif mode == "prod":
            schema = self._get_table_obj(mode).schema

            for c in columns:
                for s in schema:
                    if c["name"] == s.name:
                        c["type"] = s.field_type

        json.dump(columns, (json_path).open("w"))

        return self.client["bigquery"].schema_from_json(str(json_path))

    def init(self, data_sample_path=None, replace=False):
        """Initialize table folder at metadata_path at
        `metadata_path/<dataset_id>/<table_id>`.

        The folder should contain:
            - table_config.yaml
            - publish.sql

        You can also point to a sample of the data to auto complete columns names.

        Parameters
        ----------
        data_sample_path : (str, pathlib.PosixPath), optional
            Data sample path to auto complete columns names, by default None.
            It supports Comma Delimited CSV.
        replace : bool, optional
            Whether to replace existing folder, by default False

        Raises
        ------
        FileExistsError
            If folder exists and replace is False.
        NotImplementedError
            If data sample is not in supported type or format.
        """

        if not self.dataset_folder.exists():
            print(self.dataset_folder)
            raise FileExistsError(
                f"Dataset folder {self.dataset_folder} folder does not exists. "
                "Create a dataset before adding tables."
            )

        try:
            self.table_folder.mkdir(exist_ok=replace)
        except FileExistsError:
            raise FileExistsError(
                f"Table folder already exists for {self.table_id}. "
                "Add --replace flag to replace current files."
            )

        if isinstance(
            data_sample_path,
            (
                str,
                PosixPath,
            ),
        ):
            data_sample_path = Path(data_sample_path)
            if data_sample_path.suffix == ".csv":

                columns = next(csv.reader(open(data_sample_path, "r")))

            else:
                raise NotImplementedError(
                    "Data sample just supports comma separated csv files"
                )
        else:
            columns = ["column_name"]

        for file in (Path(self.templates) / "table").glob("*"):

            if file.name in ["table_config.yaml", "publish.sql"]:

                # Load and fill template
                template = Template(file.open("r").read()).render(
                    table_id=self.table_id,
                    dataset_id=self.dataset_folder.stem,
                    project_id=self.client["bigquery"].project,
                    columns=columns,
                )

                # Write file
                (self.table_folder / file.name).open("w").write(template)

        return self

    def create(self, job_config_params=None, partitioned=False, if_exists="raise"):
        """Creates BigQuery table at staging dataset.

        Table should be located at `<dataset_id>_staging.<table_id>`.

        It looks for data saved in Storage at `<bucket_name>/staging/<dataset_id>/<table_id>/*`
        and builds the table.

        It currently supports the types:
            - Comma Delimited CSV

        Data can also be partitioned following the hive partitioning scheme
        `<key1>=<value1>/<key2>=<value2>`, for instance, `year=2012/country=BR`

        TODO: Implement if_exists=raise
        TODO: Implement if_exists=pass

        Parameters
        ----------
        job_config_params : dict, optional
            Job configuration params from bigquery, by default None
        partitioned : bool, optional
            Whether data is partitioned, by default False
        if_exists : str, optional
            What to do if table exists, by default "raise"
            - 'raise' : Raises Conflict exception
            - 'replace' : Replace table
            - 'pass' : Do nothing
        """

        if job_config_params is None:

            job_config_params = dict(
                write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
                source_format=bigquery.SourceFormat.CSV,
                skip_leading_rows=1,
            )

        if isinstance(job_config_params, dict):

            job_config_params.update(
                dict(
                    schema=self._load_schema("staging", with_partition=False),
                    destination_table_description=self._render_template(
                        "table/table_description.txt", self.table_config
                    ),
                )
            )

        if partitioned:

            hive_partitioning = bigquery.external_config.HivePartitioningOptions()
            hive_partitioning.mode = "AUTO"
            hive_partitioning.source_uri_prefix = self.uri.format(
                dataset=self.dataset_id, table=self.table_id
            ).replace("*", "")

            job_config_params["hive_partitioning"] = hive_partitioning

        job_config = bigquery.LoadJobConfig(**job_config_params)

        if if_exists == "replace":
            self.delete(mode="staging")

        load_job = self.client["bigquery"].load_table_from_uri(
            self.uri.format(
                dataset=self.table_config["dataset_id"],
                table=self.table_config["table_id"],
            ),
            self.table_full_name["staging"],
            job_config=job_config,
        )

        load_job.result()

        self.update(mode="staging")

    def update(self, mode="all", not_found_ok=True):
        """Updates BigQuery schema and description.

        Parameters
        ----------
        mode : str, optional
            Table of which table to update [prod|staging|all], by default "all"
        not_found_ok : bool, optional
            What to do if table is not found, by default True
        """

        self._check_mode(mode)

        if mode == "all":
            mode = ["prod", "staging"]
        else:
            mode = [mode]

        for m in mode:

            try:
                table = self._get_table_obj(m)
            except google.api_core.exceptions.NotFound:
                continue

            table.description = self._render_template(
                "table/table_description.txt", self.table_config
            )
            table.schema = self._load_schema(m)

            self.client["bigquery"].update_table(
                table, fields=["description", "schema"]
            )

    def publish(self, if_exists="raise"):
        """Creates BigQuery table at production dataset.

        Table should be located at `<dataset_id>.<table_id>`.

        It creates a view that uses the query from
        `<metadata_path>/<dataset_id>/<table_id>/publish.sql`.

        Make sure that all columns from the query also exists at
        `<metadata_path>/<dataset_id>/<table_id>/table_config.sql`, including
        the partitions.

        Parameters
        ----------
        if_exists : str, optional
            What to do if table exists, by default "raise"
            - 'raise' : Raises Conflict exception
            - 'replace' : Replace table
            - 'pass' : Do nothing
        """

        # TODO: check if all required fields are filled

        view = bigquery.Table(self.table_full_name["prod"])

        view.view_query = (self.table_folder / "publish.sql").open("r").read()

        view.description = self._render_template(
            "table/table_description.txt", self.table_config
        )

        if if_exists == "replace":
            self.delete(mode="prod")

        self.client["bigquery"].create_table(view)

        self.update("prod")

    def delete(self, mode):
        """Deletes table.

        Parameters
        ----------
        mode : str
            Table of which table to delete [prod|staging|all]
        """

        self._check_mode(mode)

        if mode == "all":
            for k, n in self.table_full_name[mode].items():
                self.client["bigquery"].delete_table(n, not_found_ok=True)
        else:
            self.client["bigquery"].delete_table(
                self.table_full_name[mode], not_found_ok=True
            )


class Storage(Base):
    def __init__(self, dataset_id=None, table_id=None, **kwargs):

        super().__init__(**kwargs)

        self.bucket = self.client["storage"].bucket(self.bucket_name)
        self.dataset_id = dataset_id.replace("-", "_")
        self.table_id = table_id.replace("-", "_")

    def _resolve_partitions(self, partitions):

        if isinstance(partitions, dict):

            return "/".join([f"{k}={v}" for k, v in partitions.items()]) + "/"

        elif isinstance(partitions, str):

            # check if it fits rule
            {b.split("=")[0]: b.split("=")[1] for b in partitions.split("/")}

            return partitions if partitions.endswith("/") else partitions + "/"

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

        self.client["storage"].create_bucket(self.bucket)

        for folder in ["staging/", "raw/"]:

            self.bucket.blob(folder).upload_from_string("")

    def upload(self, filepath, mode, partitions=None, if_exists="raise", **upload_args):
        """Upload file to storage following a structured path.

        You should expect the file to be saved at `<bucket_name>/<mode>/<dataset_id>/<table_id>`.

        There are two modes:
            `raw` : should contain raw files from datasource
            `staging` : should contain pre-treated files ready to upload to BiqQuery

        Parameters
        ----------
        filepath : str or pathlib.PosixPath
            Where the file is stored
        mode : str
            Folder of which dataset to update [raw|staging], by default "all"
        partitions : (str, pathlib.PosixPath, dict), optional
            Hive structured partition as a string or dict, by default None
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

        blob_name = self._build_blob_name(Path(filepath).name, mode, partitions)

        blob = self.bucket.blob(blob_name)

        if not blob.exists() or if_exists == "replace":

            blob.upload_from_filename(str(filepath), **upload_args)

        else:
            raise Exception(
                f"Data already exists at {blob_name}. "
                "Set if_exists to 'replace' to overwrite data"
            )

        return blob_name

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


if __name__ == "__main__":

    table = Table("test", "test", key_path="as")
    table.publish("replace")
