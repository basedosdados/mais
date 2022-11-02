"""
Class for manage tables in Storage and Big Query
"""
# pylint: disable=invalid-name, too-many-locals, too-many-branches, too-many-arguments,line-too-long,R0801,consider-using-f-string
from pathlib import Path
import json
from copy import deepcopy
import textwrap
import inspect
from io import StringIO

from loguru import logger
from google.cloud import bigquery
import ruamel.yaml as ryaml
import requests
import pandas as pd
import google.api_core.exceptions

from basedosdados.upload.base import Base
from basedosdados.upload.storage import Storage
from basedosdados.upload.dataset import Dataset
from basedosdados.upload.datatypes import Datatype
from basedosdados.upload.metadata import Metadata
from basedosdados.exceptions import BaseDosDadosException


class Table(Base):
    """
    Manage tables in Google Cloud Storage and BigQuery.
    """

    def __init__(self, dataset_id, table_id, **kwargs):
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
        self.metadata = Metadata(self.dataset_id, self.table_id, **kwargs)

    @property
    def table_config(self):
        """
        Load table_config.yaml
        """
        return self._load_yaml(self.table_folder / "table_config.yaml")

    def _get_table_obj(self, mode):
        """
        Get table object from BigQuery
        """
        return self.client[f"bigquery_{mode}"].get_table(self.table_full_name[mode])

    def _is_partitioned(self):
        """
        Check if table is partitioned
        """
        ## check if the table are partitioned, need the split because of a change in the type of partitions in pydantic
        partitions = self.table_config["partitions"]
        if partitions is None or len(partitions) == 0:
            return False

        if isinstance(partitions, list):
            # check if any None inside list.
            # False if it is the case Ex: [None, 'partition']
            # True otherwise          Ex: ['partition1', 'partition2']
            return all(item is not None for item in partitions)

        raise ValueError("Partitions must be a list or None")

    def _load_schema(self, mode="staging"):
        """Load schema from table_config.yaml

        Args:
            mode (bool): Which dataset to create [prod|staging].
        """

        self._check_mode(mode)

        json_path = self.table_folder / f"schema-{mode}.json"
        columns = self.table_config["columns"]

        if mode == "staging":
            new_columns = []
            for c in columns:
                # case is_in_staging are None then must be True
                is_in_staging = (
                    True if c.get("is_in_staging") is None else c["is_in_staging"]
                )
                # append columns declared in table_config.yaml to schema only if is_in_staging: True
                if is_in_staging and not c.get("is_partition"):
                    c["type"] = "STRING"
                    new_columns.append(c)

            del columns
            columns = new_columns

        elif mode == "prod":
            schema = self._get_table_obj(mode).schema

            # get field names for fields at schema and at table_config.yaml
            column_names = [c["name"] for c in columns]
            schema_names = [s.name for s in schema]

            # check if there are mismatched fields
            not_in_columns = [name for name in schema_names if name not in column_names]
            not_in_schema = [name for name in column_names if name not in schema_names]

            # raise if field is not in table_config
            if not_in_columns:
                raise BaseDosDadosException(
                    "Column {error_columns} was not found in table_config.yaml. Are you sure that "
                    "all your column names between table_config.yaml, publish.sql and "
                    "{project_id}.{dataset_id}.{table_id} are the same?".format(
                        error_columns=not_in_columns,
                        project_id=self.table_config["project_id_prod"],
                        dataset_id=self.table_config["dataset_id"],
                        table_id=self.table_config["table_id"],
                    )
                )

            # raise if field is not in schema
            if not_in_schema:
                raise BaseDosDadosException(
                    "Column {error_columns} was not found in publish.sql. Are you sure that "
                    "all your column names between table_config.yaml, publish.sql and "
                    "{project_id}.{dataset_id}.{table_id} are the same?".format(
                        error_columns=not_in_schema,
                        project_id=self.table_config["project_id_prod"],
                        dataset_id=self.table_config["dataset_id"],
                        table_id=self.table_config["table_id"],
                    )
                )

            # if field is in schema, get field_type and field_mode
            for c in columns:
                for s in schema:
                    if c["name"] == s.name:
                        c["type"] = s.field_type
                        c["mode"] = s.mode
                        break
        ## force utf-8, write schema_{mode}.json
        json.dump(columns, (json_path).open("w", encoding="utf-8"))

        # load new created schema
        return self.client[f"bigquery_{mode}"].schema_from_json(str(json_path))

    def _make_publish_sql(self):
        """Create publish.sql with columns and bigquery_type"""

        ### publish.sql header and instructions
        publish_txt = """
        /*
        Query para publicar a tabela.

        Esse é o lugar para:
            - modificar nomes, ordem e tipos de colunas
            - dar join com outras tabelas
            - criar colunas extras (e.g. logs, proporções, etc.)

        Qualquer coluna definida aqui deve também existir em `table_config.yaml`.

        # Além disso, sinta-se à vontade para alterar alguns nomes obscuros
        # para algo um pouco mais explícito.

        TIPOS:
            - Para modificar tipos de colunas, basta substituir STRING por outro tipo válido.
            - Exemplo: `SAFE_CAST(column_name AS NUMERIC) column_name`
            - Mais detalhes: https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types
        */
        """

        # remove triple quotes extra space
        publish_txt = inspect.cleandoc(publish_txt)
        publish_txt = textwrap.dedent(publish_txt)

        # add create table statement
        project_id_prod = self.client["bigquery_prod"].project
        publish_txt += f"\n\nCREATE VIEW {project_id_prod}.{self.dataset_id}.{self.table_id} AS\nSELECT \n"

        # sort columns by is_partition, partitions_columns come first

        if self._is_partitioned():
            columns = sorted(
                self.table_config["columns"],
                key=lambda k: (k["is_partition"] is not None, k["is_partition"]),
                reverse=True,
            )
        else:
            columns = self.table_config["columns"]

        # add columns in publish.sql
        for col in columns:
            name = col["name"]
            bigquery_type = (
                "STRING"
                if col["bigquery_type"] is None
                else col["bigquery_type"].upper()
            )

            publish_txt += f"SAFE_CAST({name} AS {bigquery_type}) {name},\n"
        ## remove last comma
        publish_txt = publish_txt[:-2] + "\n"

        # add from statement
        project_id_staging = self.client["bigquery_staging"].project
        publish_txt += (
            f"FROM {project_id_staging}.{self.dataset_id}_staging.{self.table_id} AS t"
        )

        # save publish.sql in table_folder
        (self.table_folder / "publish.sql").open("w", encoding="utf-8").write(
            publish_txt
        )

    def _make_template(self, columns, partition_columns, if_table_config_exists, force_columns):
        # create table_config.yaml with metadata
        self.metadata.create(
            if_exists=if_table_config_exists,
            columns=partition_columns + columns,
            partition_columns=partition_columns,
            force_columns=force_columns,
            table_only=False,
        )

        self._make_publish_sql()

    @staticmethod
    def _sheet_to_df(columns_config_url_or_path):
        """
        Convert sheet to dataframe
        """
        url = columns_config_url_or_path.replace("edit#gid=", "export?format=csv&gid=")
        try:
            return pd.read_csv(StringIO(requests.get(url, timeout=10).content.decode("utf-8")))
        except Exception as e:
            raise BaseDosDadosException(
                "Check if your google sheet Share are: Anyone on the internet with this link can view"
            ) from e

    def table_exists(self, mode):
        """Check if table exists in BigQuery.

        Args:
            mode (str): Which dataset to check [prod|staging].
        """

        try:
            ref = self._get_table_obj(mode=mode)
        except google.api_core.exceptions.NotFound:
            ref = None

        return bool(ref)

    def update_columns(self, columns_config_url_or_path=None):
        """
        Fills columns in table_config.yaml automatically using a public google sheets URL or a local file. Also regenerate
        publish.sql and autofill type using bigquery_type.

        The sheet must contain the columns:
            - name: column name
            - description: column description
            - bigquery_type: column bigquery type
            - measurement_unit: column mesurement unit
            - covered_by_dictionary: column related dictionary
            - directory_column: column related directory in the format <dataset_id>.<table_id>:<column_name>
            - temporal_coverage: column temporal coverage
            - has_sensitive_data: the column has sensitive data
            - observations: column observations
        Args:
            columns_config_url_or_path (str): Path to the local architeture file or a public google sheets URL.
                Path only suports csv, xls, xlsx, xlsm, xlsb, odf, ods, odt formats.
                Google sheets URL must be in the format https://docs.google.com/spreadsheets/d/<table_key>/edit#gid=<table_gid>.

        """
        ruamel = ryaml.YAML()
        ruamel.preserve_quotes = True
        ruamel.indent(mapping=4, sequence=6, offset=4)
        table_config_yaml = ruamel.load(
            (self.table_folder / "table_config.yaml").open(encoding="utf-8")
        )

        if "https://docs.google.com/spreadsheets/d/" in columns_config_url_or_path:
            if (
                "edit#gid=" not in columns_config_url_or_path
                or "https://docs.google.com/spreadsheets/d/"
                not in columns_config_url_or_path
                or not columns_config_url_or_path.split("=")[1].isdigit()
            ):
                raise BaseDosDadosException(
                    "The Google sheet url not in correct format."
                    "The url must be in the format https://docs.google.com/spreadsheets/d/<table_key>/edit#gid=<table_gid>"
                )
            df = self._sheet_to_df(columns_config_url_or_path)
        else:
            file_type = columns_config_url_or_path.split(".")[-1]
            if file_type == "csv":
                df = pd.read_csv(columns_config_url_or_path, encoding="utf-8")
            elif file_type in ["xls", "xlsx", "xlsm", "xlsb", "odf", "ods", "odt"]:
                df = pd.read_excel(columns_config_url_or_path)
            else:
                raise BaseDosDadosException(
                    "File not suported. Only csv, xls, xlsx, xlsm, xlsb, odf, ods, odt are supported."
                )

        df = df.fillna("NULL")

        required_columns = [
            "name",
            "bigquery_type",
            "description",
            "temporal_coverage",
            "covered_by_dictionary",
            "directory_column",
            "measurement_unit",
            "has_sensitive_data",
            "observations",
        ]

        not_found_columns = required_columns.copy()
        for sheet_column in df.columns.tolist():
            for required_column in required_columns:
                if sheet_column == required_column:
                    not_found_columns.remove(required_column)
        if not_found_columns:
            raise BaseDosDadosException(
                f"The following required columns are not found: {', '.join(not_found_columns)}."
            )

        columns_parameters = zip(
            *[df[required_column].tolist() for required_column in required_columns]
        )
        for (
            name,
            bigquery_type,
            description,
            temporal_coverage,
            covered_by_dictionary,
            directory_column,
            measurement_unit,
            has_sensitive_data,
            observations,
        ) in columns_parameters:
            for col in table_config_yaml["columns"]:
                if col["name"] == name:
                    col["bigquery_type"] = (
                        col["bigquery_type"]
                        if bigquery_type == "NULL"
                        else bigquery_type.lower()
                    )

                    col["description"] = (
                        col["description"] if description == "NULL" else description
                    )

                    col["temporal_coverage"] = (
                        col["temporal_coverage"]
                        if temporal_coverage == "NULL"
                        else [temporal_coverage]
                    )

                    col["covered_by_dictionary"] = (
                        "no"
                        if covered_by_dictionary == "NULL"
                        else covered_by_dictionary
                    )

                    dataset = directory_column.split(".")[0]
                    col["directory_column"]["dataset_id"] = (
                        col["directory_column"]["dataset_id"]
                        if dataset == "NULL"
                        else dataset
                    )

                    table = directory_column.split(".")[-1].split(":")[0]
                    col["directory_column"]["table_id"] = (
                        col["directory_column"]["table_id"]
                        if table == "NULL"
                        else table
                    )

                    column = directory_column.split(".")[-1].split(":")[-1]
                    col["directory_column"]["column_name"] = (
                        col["directory_column"]["column_name"]
                        if column == "NULL"
                        else column
                    )
                    col["measurement_unit"] = (
                        col["measurement_unit"]
                        if measurement_unit == "NULL"
                        else measurement_unit
                    )

                    col["has_sensitive_data"] = (
                        "no" if has_sensitive_data == "NULL" else has_sensitive_data
                    )

                    col["observations"] = (
                        col["observations"] if observations == "NULL" else observations
                    )

        with open(self.table_folder / "table_config.yaml", "w", encoding="utf-8") as f:
            ruamel.dump(table_config_yaml, f)

        # regenerate publish.sql
        self._make_publish_sql()

    def init(
        self,
        data_sample_path=None,
        if_folder_exists="raise",
        if_table_config_exists="raise",
        source_format="csv",
        force_columns = False,
        columns_config_url_or_path=None,
    ):  # sourcery skip: low-code-quality
        """Initialize table folder at metadata_path at `metadata_path/<dataset_id>/<table_id>`.

        The folder should contain:

        * `table_config.yaml`
        * `publish.sql`

        You can also point to a sample of the data to auto complete columns names.

        Args:
            data_sample_path (str, pathlib.PosixPath): Optional.
                Data sample path to auto complete columns names
                It supports Comma Delimited CSV, Apache Avro and
                Apache Parquet.
            if_folder_exists (str): Optional.
                What to do if table folder exists

                * 'raise' : Raises FileExistsError
                * 'replace' : Replace folder
                * 'pass' : Do nothing
            if_table_config_exists (str): Optional
                What to do if table_config.yaml and publish.sql exists

                * 'raise' : Raises FileExistsError
                * 'replace' : Replace files with blank template
                * 'pass' : Do nothing
            source_format (str): Optional
                Data source format. Only 'csv', 'avro' and 'parquet'
                are supported. Defaults to 'csv'.
            force_columns (bool): Optional.
                If set to `True`, overwrite CKAN's columns with the ones provi
                ded.
                If set to `False`, keep CKAN's columns instead of the ones pro
                vided.
            columns_config_url_or_path (str): Path to the local architeture file or a public google sheets URL.
                Path only suports csv, xls, xlsx, xlsm, xlsb, odf, ods, odt formats.
                Google sheets URL must be in the format https://docs.google.com/spreadsheets/d/<table_key>/edit#gid=<table_gid>.

        Raises:
            FileExistsError: If folder exists and replace is False.
            NotImplementedError: If data sample is not in supported type or format.
        """
        if not self.dataset_folder.exists():

            raise FileExistsError(
                f"Dataset folder {self.dataset_folder} folder does not exists. "
                "Create a dataset before adding tables."
            )

        try:
            self.table_folder.mkdir(exist_ok=(if_folder_exists == "replace"))
        except FileExistsError as e:
            if if_folder_exists == "raise":
                raise FileExistsError(
                    f"Table folder already exists for {self.table_id}. "
                ) from e
            if if_folder_exists == "pass":
                return self

        if not data_sample_path and if_table_config_exists != "pass":
            raise BaseDosDadosException(
                "You must provide a path to correctly create config files"
            )

        partition_columns = []
        if isinstance(
            data_sample_path,
            (
                str,
                Path,
            ),
        ):
            # Check if partitioned and get data sample and partition columns
            data_sample_path = Path(data_sample_path)

            if data_sample_path.is_dir():

                data_sample_path = [
                    f
                    for f in data_sample_path.glob("**/*")
                    if f.is_file() and f.suffix == f".{source_format}"
                ][0]

                partition_columns = [
                    k.split("=")[0]
                    for k in data_sample_path.as_posix().split("/")
                    if "=" in k
                ]

            columns = Datatype(self, source_format).header(data_sample_path)

        else:

            columns = ["column_name"]

        if if_table_config_exists == "pass":
            # Check if config files exists before passing
            if (
                Path(self.table_folder / "table_config.yaml").is_file()
                and Path(self.table_folder / "publish.sql").is_file()
            ):
                pass
            # Raise if no sample to determine columns
            elif not data_sample_path:
                raise BaseDosDadosException(
                    "You must provide a path to correctly create config files"
                )
            else:
                self._make_template(columns, partition_columns, if_table_config_exists, force_columns=force_columns)

        elif if_table_config_exists == "raise":

            # Check if config files already exist
            if (
                Path(self.table_folder / "table_config.yaml").is_file()
                and Path(self.table_folder / "publish.sql").is_file()
            ):

                raise FileExistsError(
                    f"table_config.yaml and publish.sql already exists at {self.table_folder}"
                )
            # if config files don't exist, create them
            self._make_template(columns, partition_columns, if_table_config_exists, force_columns=force_columns)

        else:
            # Raise: without a path to data sample, should not replace config files with empty template
            self._make_template(columns, partition_columns, if_table_config_exists, force_columns=force_columns)

        if columns_config_url_or_path is not None:
            self.update_columns(columns_config_url_or_path)

        return self

    def create(
        self,
        path=None,
        force_dataset=True,
        if_table_exists="raise",
        if_storage_data_exists="raise",
        if_table_config_exists="raise",
        source_format="csv",
        force_columns=False,
        columns_config_url_or_path=None,
        dataset_is_public=True,
        location=None,
        chunk_size=None,
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
        - Apache Avro
        - Apache Parquet

        Data can also be partitioned following the hive partitioning scheme
        `<key1>=<value1>/<key2>=<value2>` - for instance,
        `year=2012/country=BR`. The partition is automatcally detected
        by searching for `partitions` on the `table_config.yaml`.

        Args:
            path (str or pathlib.PosixPath): Where to find the file that you want to upload to create a table with
            job_config_params (dict): Optional.
                Job configuration params from bigquery
            if_table_exists (str): Optional
                What to do if table exists

                * 'raise' : Raises Conflict exception
                * 'replace' : Replace table
                * 'pass' : Do nothing
            force_dataset (bool): Creates `<dataset_id>` folder and BigQuery Dataset if it doesn't exists.
            if_table_config_exists (str): Optional.
                What to do if config files already exist

                 * 'raise': Raises FileExistError
                 * 'replace': Replace with blank template
                 * 'pass'; Do nothing
            if_storage_data_exists (str): Optional.
                What to do if data already exists on your bucket:

                * 'raise' : Raises Conflict exception
                * 'replace' : Replace table
                * 'pass' : Do nothing
            source_format (str): Optional
                Data source format. Only 'csv', 'avro' and 'parquet'
                are supported. Defaults to 'csv'.
            force_columns (bool): Optional.
                If set to `True`, overwrite CKAN's columns with the ones provi
                ded.
                If set to `False`, keep CKAN's columns instead of the ones pro
                vided.
            columns_config_url_or_path (str): Path to the local architeture file or a public google sheets URL.
                Path only suports csv, xls, xlsx, xlsm, xlsb, odf, ods, odt formats.
                Google sheets URL must be in the format https://docs.google.com/spreadsheets/d/<table_key>/edit#gid=<table_gid>.

            dataset_is_public (bool): Control if prod dataset is public or not. By default staging datasets like `dataset_id_staging` are not public.

            location (str): Optional. Location of dataset data.
                List of possible region names locations: https://cloud.google.com/bigquery/docs/locations

            chunk_size (int): Optional
                The size of a chunk of data whenever iterating (in bytes).
                This must be a multiple of 256 KB per the API specification.
                If not specified, the chunk_size of the blob itself is used. If that is not specified, a default value of 40 MB is used.
        """

        if path is None:

            # Look if table data already exists at Storage
            data = self.client["storage_staging"].list_blobs(
                self.bucket_name, prefix=f"staging/{self.dataset_id}/{self.table_id}"
            )

            # Raise: Cannot create table without external data
            if not data:
                raise BaseDosDadosException(
                    "You must provide a path for uploading data"
                )

        # Add data to storage
        if isinstance(
            path,
            (
                str,
                Path,
            ),
        ):

            Storage(self.dataset_id, self.table_id, **self.main_vars).upload(
                path,
                mode="staging",
                if_exists=if_storage_data_exists,
                chunk_size=chunk_size,
            )

        # Create Dataset if it doesn't exist
        if force_dataset:

            dataset_obj = Dataset(self.dataset_id, **self.main_vars)

            try:
                dataset_obj.init()
            except FileExistsError:
                pass

            dataset_obj.create(
                if_exists="pass", location=location, dataset_is_public=dataset_is_public
            )

        self.init(
            data_sample_path=path,
            if_folder_exists="replace",
            if_table_config_exists=if_table_config_exists,
            columns_config_url_or_path=columns_config_url_or_path,
            source_format=source_format,
            force_columns=force_columns
        )

        table = bigquery.Table(self.table_full_name["staging"])
        table.external_data_configuration = Datatype(
            self, source_format, "staging", partitioned=self._is_partitioned()
        ).external_config

        # Lookup if table alreay exists
        table_ref = None
        try:
            table_ref = self.client["bigquery_staging"].get_table(
                self.table_full_name["staging"]
            )

        except google.api_core.exceptions.NotFound:
            pass

        if isinstance(table_ref, google.cloud.bigquery.table.Table):

            if if_table_exists == "pass":

                return None

            if if_table_exists == "raise":

                raise FileExistsError(
                    "Table already exists, choose replace if you want to overwrite it"
                )

        if if_table_exists == "replace":

            self.delete(mode="staging")

        self.client["bigquery_staging"].create_table(table)

        logger.success(
            "{object} {object_id} was {action}!",
            object_id=self.table_id,
            object="Table",
            action="created",
        )
        return None

    def update(self, mode="all"):
        """Updates BigQuery schema and description.
        Args:
            mode (str): Optional.
                Table of which table to update [prod|staging|all]
            not_found_ok (bool): Optional.
                What to do if table is not found
        """

        self._check_mode(mode)

        mode = ["prod", "staging"] if mode == "all" else [mode]
        for m in mode:

            try:
                table = self._get_table_obj(m)
            except google.api_core.exceptions.NotFound:
                continue

            # if m == "staging":

            table.description = self._render_template(
                Path("table/table_description.txt"), self.table_config
            )

            # save table description
            with open(
                self.metadata_path
                / self.dataset_id
                / self.table_id
                / "table_description.txt",
                "w",
                encoding="utf-8",
            ) as f:
                f.write(table.description)

            # when mode is staging the table schema already exists
            table.schema = self._load_schema(m)
            fields = ["description", "schema"] if m == "prod" else ["description"]
            self.client[f"bigquery_{m}"].update_table(table, fields=fields)

        logger.success(
            " {object} {object_id} was {action}!",
            object_id=self.table_id,
            object="Table",
            action="updated",
        )

    def publish(self, if_exists="raise"):
        """Creates BigQuery table at production dataset.

        Table should be located at `<dataset_id>.<table_id>`.

        It creates a view that uses the query from
        `<metadata_path>/<dataset_id>/<table_id>/publish.sql`.

        Make sure that all columns from the query also exists at
        `<metadata_path>/<dataset_id>/<table_id>/table_config.sql`, including
        the partitions.

        Args:
            if_exists (str): Optional.
                What to do if table exists.

                * 'raise' : Raises Conflict exception
                * 'replace' : Replace table
                * 'pass' : Do nothing

        Todo:

            * Check if all required fields are filled
        """

        if if_exists == "replace":
            self.delete(mode="prod")

        self.client["bigquery_prod"].query(
            (self.table_folder / "publish.sql").open("r", encoding="utf-8").read()
        ).result()

        self.update()
        logger.success(
            " {object} {object_id} was {action}!",
            object_id=self.table_id,
            object="Table",
            action="published",
        )

    def delete(self, mode):
        """Deletes table in BigQuery.

        Args:
            mode (str): Table of which table to delete [prod|staging]
        """

        self._check_mode(mode)

        if mode == "all":
            for m, n in self.table_full_name[mode].items():
                self.client[f"bigquery_{m}"].delete_table(n, not_found_ok=True)
            logger.info(
                " {object} {object_id}_{mode} was {action}!",
                object_id=self.table_id,
                mode=mode,
                object="Table",
                action="deleted",
            )
        else:
            self.client[f"bigquery_{mode}"].delete_table(
                self.table_full_name[mode], not_found_ok=True
            )

            logger.info(
                " {object} {object_id}_{mode} was {action}!",
                object_id=self.table_id,
                mode=mode,
                object="Table",
                action="deleted",
            )

    def append(
        self,
        filepath,
        partitions=None,
        if_exists="replace",
        chunk_size=None,
        **upload_args,
    ):
        """Appends new data to existing BigQuery table.

        As long as the data has the same schema. It appends the data in the
        filepath to the existing table.

        Args:
            filepath (str or pathlib.PosixPath): Where to find the file that you want to upload to create a table with
            partitions (str, pathlib.PosixPath, dict): Optional.
                Hive structured partition as a string or dict

                * str : `<key>=<value>/<key2>=<value2>`
                * dict: `dict(key=value, key2=value2)`
            if_exists (str): 0ptional.
                What to do if data with same name exists in storage

                * 'raise' : Raises Conflict exception
                * 'replace' : Replace table
                * 'pass' : Do nothing
            chunk_size (int): Optional
                The size of a chunk of data whenever iterating (in bytes).
                This must be a multiple of 256 KB per the API specification.
                If not specified, the chunk_size of the blob itself is used. If that is not specified, a default value of 40 MB is used.
        """
        if not self.table_exists("staging"):
            raise BaseDosDadosException(
                "You cannot append to a table that does not exist"
            )
        Storage(self.dataset_id, self.table_id, **self.main_vars).upload(
            filepath,
            mode="staging",
            partitions=partitions,
            if_exists=if_exists,
            chunk_size=chunk_size,
            **upload_args,
        )
        logger.success(
            " {object} {object_id} was {action}!",
            object_id=self.table_id,
            object="Table",
            action="appended",
        )
