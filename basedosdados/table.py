from jinja2 import Template
from pathlib import Path, PosixPath
import json
import csv
from copy import deepcopy
from google.cloud import bigquery
import datetime

import google.api_core.exceptions

from basedosdados.base import Base
from basedosdados.storage import Storage
from basedosdados.dataset import Dataset


class Table(Base):
    def __init__(self, table_id, dataset_id, **kwargs):
        super().__init__(**kwargs)

        self.table_id = table_id.replace("-", "_")
        self.dataset_id = dataset_id.replace("-", "_")
        self.dataset_folder = Path(self.metadata_path / self.dataset_id)
        self.table_folder = self.dataset_folder / table_id
        self.table_full_name = dict(
            prod=f"{self.client['bigquery_prod'].project}.{self.dataset_id}.{self.table_id}",
            staging=f"{self.client['bigquery_staging'].project}.{self.dataset_id}_staging.{self.table_id}",
        )
        self.table_full_name.update(dict(all=deepcopy(self.table_full_name)))

    @property
    def table_config(self):
        return self._load_yaml(self.table_folder / "table_config.yaml")

    def _get_table_obj(self, mode):
        return self.client[f"bigquery_{mode}"].get_table(self.table_full_name[mode])

    def _load_schema(self, mode="staging", with_partition=True):
        """Load schema from table_config.yaml"""

        self._check_mode(mode)

        json_path = self.table_folder / f"schema-{mode}.json"

        columns = self.table_config["columns"]

        if mode == "staging":

            columns = [c for c in columns if c["is_in_staging"]]

            if not with_partition:
                columns = [c for c in columns if not c.get("is_partition")]

        elif mode == "prod":
            schema = self._get_table_obj(mode).schema

            for c in columns:
                for s in schema:
                    if c["name"] == s.name:
                        c["type"] = s.field_type
                        c["mode"] = s.mode
                        break
                else:
                    raise Exception(
                        f"Column {c} was not found in schema. Are you sure that "
                        "all your column names between table_config.yaml and "
                        "publish.sql are the same?"
                    )

        json.dump(columns, (json_path).open("w"))

        return self.client[f"bigquery_{mode}"].schema_from_json(str(json_path))

    def init(self, data_sample_path=None, if_exists="raise"):
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
        if_exists : str, optional
            What to do if table folder exists, by default "raise"
            - 'raise' : Raises FileExistsError
            - 'replace' : Replace folder
            - 'pass' : Do nothing

        Raises
        ------
        FileExistsError
            If folder exists and replace is False.
        NotImplementedError
            If data sample is not in supported type or format.
        """

        if not self.dataset_folder.exists():

            raise FileExistsError(
                f"Dataset folder {self.dataset_folder} folder does not exists. "
                "Create a dataset before adding tables."
            )

        try:
            self.table_folder.mkdir(exist_ok=(if_exists == "replace"))
        except FileExistsError:
            if if_exists == "raise":
                raise FileExistsError(
                    f"Table folder already exists for {self.table_id}. "
                )
            elif if_exists == "pass":
                return self

        partition_columns = []
        if isinstance(
            data_sample_path,
            (
                str,
                PosixPath,
            ),
        ):
            # Check if partitioned and get data sample and partition columns
            data_sample_path = Path(data_sample_path)
            if data_sample_path.is_dir():

                data_sample_path = [
                    f
                    for f in data_sample_path.glob("**/*")
                    if f.is_file() and f.suffix == ".csv"
                ][0]

                partition_columns = [
                    k.split("=")[0]
                    for k in str(data_sample_path).split("/")
                    if "=" in k
                ]

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
                    project_id=self.client["bigquery_staging"].project,
                    columns=columns,
                    partition_columns=partition_columns,
                    now=datetime.datetime.now().strftime("%Y-%m-%d"),
                )

                # Write file
                (self.table_folder / file.name).open("w").write(template)

        return self

    def create(
        self,
        path=None,
        job_config_params=None,
        partitioned=False,
        if_exists="raise",
        force_dataset=True,
    ):
        """Creates BigQuery table at staging dataset.

        If you add a path, it automatically saves the data in the storage,
        creates a datasets folder and BigQuery location, besides creating the
        table and its configuration files.

        The new table should be located at `<dataset_id>_staging.<table_id>` in BigQuery.

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
        path : str or pathlib.PosixPath
            Where to find the file that you want to upload to create a table with
        job_config_params : dict, optional
            Job configuration params from bigquery, by default None
        partitioned : bool, optional
            Whether data is partitioned, by default False
        if_exists : str, optional
            What to do if table exists, by default "raise"
            - 'raise' : Raises Conflict exception
            - 'replace' : Replace table
            - 'pass' : Do nothing
        force_dataset: bool, by default True
            Creates <dataset_id> folder and BigQuery Dataset if it doesn't
            exists.
        """

        # Add data to storage
        if isinstance(
            path,
            (
                str,
                PosixPath,
            ),
        ):

            Storage(self.dataset_id, self.table_id, **self.main_vars).upload(
                path, mode="staging", if_exists="replace"
            )

            # Create Dataset if it doesn't exist
            if force_dataset:

                dataset_obj = Dataset(self.dataset_id, **self.main_vars)

                try:
                    dataset_obj.init()
                except FileExistsError:
                    pass

                dataset_obj.create(if_exists="pass")

            self.init(data_sample_path=path, if_exists="replace")

        external_config = external_config = bigquery.ExternalConfig("CSV")
        external_config.options.skip_leading_rows = 1
        external_config.options.allow_quoted_newlines = True
        external_config.options.allow_jagged_rows = True
        external_config.autodetect = True

        external_config.source_uris = (
            f"gs://basedosdados/staging/{self.dataset_id}/{self.table_id}/*"
        )

        if partitioned:

            hive_partitioning = bigquery.external_config.HivePartitioningOptions()
            hive_partitioning.mode = "STRINGS"
            hive_partitioning.source_uri_prefix = self.uri.format(
                dataset=self.dataset_id, table=self.table_id
            ).replace("*", "")
            external_config.hive_partitioning = hive_partitioning

        table = bigquery.Table(self.table_full_name["staging"])
        # table.schema = self._load_schema("staging", with_partition=True)
        table.external_data_configuration = external_config

        if if_exists == "replace":
            self.delete(mode="staging")

        self.client["bigquery_staging"].create_table(table)

        table = bigquery.Table(self.table_full_name["staging"])
        print(table.schema)
        # self.update(mode="staging")

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

            # save table description
            open(
                self.metadata_path
                / self.dataset_id
                / self.table_id
                / "table_description.txt",
                "w",
            ).write(table.description)

            if m == "prod":
                table.schema = self._load_schema(m)

            self.client[f"bigquery_{m}"].update_table(
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

        self.client["bigquery_prod"].create_table(view)

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
            for m, n in self.table_full_name[mode].items():
                self.client[f"bigquery_{m}"].delete_table(n, not_found_ok=True)
        else:
            self.client[f"bigquery_{mode}"].delete_table(
                self.table_full_name[mode], not_found_ok=True
            )

    def append(self, filepath, partitions=None, if_exists="raise", **upload_args):
        """Appends new data to existing BigQuery table.

        As long as the data has the same schema. It appends the data in the
        filepath to the existing table.

        Parameters
        ----------
        filepath : str or pathlib.PosixPath
            Where to find the file that you want to upload to create a table with
        partitions : (str, pathlib.PosixPath, dict), optional
            Hive structured partition as a string or dict, by default None
            str : `<key>=<value>/<key2>=<value2>`
            dict: `dict(key=value, key2=value2)`
        if_exists : str, optional
            What to do if data with same name exists in storage, by default "raise"
            - 'raise' : Raises Conflict exception
            - 'replace' : Replace table
            - 'pass' : Do nothing
        """

        Storage(self.dataset_id, self.table_id, **self.main_vars).upload(
            filepath,
            mode="staging",
            partitions=None,
            if_exists=if_exists,
            **upload_args,
        )

        self.create(if_exists="replace")
