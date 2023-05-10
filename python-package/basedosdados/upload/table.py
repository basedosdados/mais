"""
Class for manage tables in Storage and Big Query
"""
# pylint: disable=invalid-name, too-many-locals, too-many-branches, too-many-arguments,line-too-long,R0801,consider-using-f-string
from pathlib import Path
import json
from copy import deepcopy
import textwrap
import inspect
from io import BytesIO
from functools import lru_cache

from loguru import logger
from google.cloud import bigquery
import requests
import pandas as pd
import google.api_core.exceptions

from basedosdados.upload.base import Base
from basedosdados.upload.connection import Connection
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
        # self.dataset_folder = Path(self.metadata_path / self.dataset_id)
        # self.table_folder = self.dataset_folder / table_id
        self.table_full_name = dict(
            prod=f"{self.client['bigquery_prod'].project}.{self.dataset_id}.{self.table_id}",
            staging=f"{self.client['bigquery_staging'].project}.{self.dataset_id}_staging.{self.table_id}",
        )
        self.table_full_name.update(dict(all=deepcopy(self.table_full_name)))
        # self.metadata = Metadata(self.dataset_id, self.table_id, **kwargs)

    @property
    @lru_cache(256)
    def table_config(self):
        """
        Load table_config.yaml
        """
        # return self._load_yaml(self.table_folder / "table_config.yaml")
        return self._backend.get_table_config(self.dataset_id, self.table_id)

    def _get_table_obj(self, mode):
        """
        Get table object from BigQuery
        """
        return self.client[f"bigquery_{mode}"].get_table(self.table_full_name[mode])

    def _load_schema(self, mode="staging"):
        """Load schema from table config

        Args:
            mode (bool): Which dataset to create [prod|staging].
        """
        # TODO: review this function

        self._check_mode(mode)

        columns = self.table_config["columns"]

        if mode == "staging":
            new_columns = []
            for c in columns:
                # case is_in_staging are None then must be True
                is_in_staging = c["isInStaging"]
                # append columns declared in table config to schema only if is_in_staging: True
                if is_in_staging and not c["isPartition"]:
                    c["type"] = "STRING"
                    new_columns.append(c)

            del columns
            columns = new_columns

        elif mode == "prod":
            schema = self._get_table_obj(mode).schema

            # get field names for fields at schema and at table config
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
                        project_id=self.table_config["dataset"]["organization"]["slug"],
                        dataset_id=self.table_config["dataset"]["slug"],
                        table_id=self.table_config["slug"],
                    )
                )

            # raise if field is not in schema
            if not_in_schema:
                raise BaseDosDadosException(
                    "Column {error_columns} was not found in publish.sql. Are you sure that "
                    "all your column names between table_config.yaml, publish.sql and "
                    "{project_id}.{dataset_id}.{table_id} are the same?".format(
                        error_columns=not_in_schema,
                        project_id=self.table_config["dataset"]["organization"]["slug"],
                        dataset_id=self.table_config["dataset"]["slug"],
                        table_id=self.table_config["slug"],
                    )
                )

            # if field is in schema, get field_type and field_mode
            for c in columns:
                for s in schema:
                    if c["name"] == s.name:
                        c["type"] = s.field_type
                        c["mode"] = s.mode
                        break
        ## force utf-8, write JSON to BytesIO
        json_buffer = BytesIO()
        json.dump(columns, json_buffer, ensure_ascii=False)

        # load new created schema
        return self.client[f"bigquery_{mode}"].schema_from_json(json_buffer)

    def _get_columns_from_data(
        self,
        data_sample_path=None,
        source_format="csv",
        mode="staging",
    ):  # sourcery skip: low-code-quality
        """
        Get the partition columns from the structure of data_sample_path.

        Args:
            data_sample_path (str, pathlib.PosixPath): Optional.
                Data sample path to auto complete columns names
                It supports Comma Delimited CSV, Apache Avro and
                Apache Parquet.
            source_format (str): Optional
                Data source format. Only 'csv', 'avro' and 'parquet'
                are supported. Defaults to 'csv'.
        """

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

        return {"columns": columns, "partition_columns": partition_columns}

    def _get_columns_from_api(
        self,
    ):
        """
        Get columns and partition columns from API.
        """
        partition_columns = [
            col.get("name")
            for col in self.table_config.get("columns")
            if col.get("isPartition") is True
        ]
        columns = [
            col.get("name")
            for col in self.table_config.get("columns")
            if col.get("isPartition") is False
        ]

        return {"columns": columns, "partition_columns": partition_columns}

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

        # TODO: review this method

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

        return publish_txt

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

    def _get_biglake_connection_id(
        self, set_biglake_connection_permissions=True, location=None, mode="staging"
    ):
        biglake_connection_id: str = None
        connection = Connection(name="biglake", location=location, mode="staging")
        if not connection.exists:
            try:
                logger.info("Creating BigLake connection...")
                connection.create()
                logger.success("BigLake connection created!")
            except google.api_core.exceptions.Forbidden as exc:
                logger.error(
                    "You don't have permission to create a BigLake connection. "
                    "Please contact an admin to create one for you."
                )
                raise BaseDosDadosException(
                    "You don't have permission to create a BigLake connection. "
                    "Please contact an admin to create one for you."
                ) from exc
            except Exception as exc:
                logger.error(
                    "Something went wrong while creating the BigLake connection. "
                    "Please contact an admin to create one for you."
                )
                raise BaseDosDadosException(
                    "Something went wrong while creating the BigLake connection. "
                    "Please contact an admin to create one for you."
                ) from exc
        if set_biglake_connection_permissions:
            try:
                logger.info("Setting permissions for BigLake service account...")
                connection.set_biglake_permissions()
                logger.success("Permissions set successfully!")
            except google.api_core.exceptions.Forbidden as exc:
                logger.error(
                    "Could not set permissions for BigLake service account. "
                    "Please make sure you have permissions to grant roles/storage.objectViewer"
                    f" to the BigLake service account. ({connection.service_account})."
                    " If you don't, please ask an admin to do it for you or set "
                    "set_biglake_connection_permissions=False."
                )
                raise BaseDosDadosException(
                    "Could not set permissions for BigLake service account. "
                    "Please make sure you have permissions to grant roles/storage.objectViewer"
                    f" to the BigLake service account. ({connection.service_account})."
                    " If you don't, please ask an admin to do it for you or set "
                    "set_biglake_connection_permissions=False."
                ) from exc
            except Exception as exc:
                logger.error(
                    "Something went wrong while setting permissions for BigLake service account. "
                    "Please make sure you have permissions to grant roles/storage.objectViewer"
                    f" to the BigLake service account. ({connection.service_account})."
                    " If you don't, please ask an admin to do it for you or set "
                    "set_biglake_connection_permissions=False."
                )
                raise BaseDosDadosException(
                    "Something went wrong while setting permissions for BigLake service account. "
                    "Please make sure you have permissions to grant roles/storage.objectViewer"
                    f" to the BigLake service account. ({connection.service_account})."
                    " If you don't, please ask an admin to do it for you or set "
                    "set_biglake_connection_permissions=False."
                ) from exc
        biglake_connection_id = connection.connection_id

        return biglake_connection_id

    def create(  # pylint: disable=too-many-statements
        self,
        path=None,
        force_dataset=True,
        if_table_exists="raise",
        if_storage_data_exists="raise",
        source_format="csv",
        dataset_is_public=True,
        location=None,
        chunk_size=None,
        biglake_table=False,
        set_biglake_connection_permissions=True,
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

            biglake_table (bool): Optional
                Sets this as a BigLake table. BigLake tables allow end users to query from external data (such as GCS) even if
                they don't have access to the source data. IAM is managed like any other BigQuery native table. See
                https://cloud.google.com/bigquery/docs/biglake-intro for more on BigLake.

            set_biglake_connection_permissions (bool): Optional
                If set to `True`, attempts to grant the BigLake connection service account access to the table's data in GCS.
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
                path=path,
                mode="staging",
                if_exists=if_storage_data_exists,
                chunk_size=chunk_size,
            )

        # Create Dataset if it doesn't exist

        if force_dataset:
            dataset_obj = Dataset(self.dataset_id, **self.main_vars)

            dataset_obj.create(
                if_exists="pass",
                mode="staging",
                location=location,
                dataset_is_public=dataset_is_public,
            )

        data_columns = self._get_columns_from_data(
            data_sample_path=path,
            source_format=source_format,
            mode="staging",
        )
        if biglake_table:
            biglake_connection_id = self._get_biglake_connection_id(
                self,
                set_biglake_connection_permissions=set_biglake_connection_permissions,
                location=location,
                mode="staging",
            )
        else:
            biglake_connection_id = None

        table = bigquery.Table(self.table_full_name["staging"])

        table.external_data_configuration = Datatype(
            self,
            source_format,
            "staging",
            partitioned=bool(data_columns["partition_columns"]),
            biglake_connection_id=biglake_connection_id,
        ).external_config

        # When using BigLake tables, schema must be provided to the `Table` object
        if biglake_table:
            table.schema = self._load_schema("staging")
            logger.info(f"Using BigLake connection {biglake_connection_id}")

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

        try:
            self.client["bigquery_staging"].create_table(table)
        except google.api_core.exceptions.Forbidden as exc:
            if biglake_table:
                raise BaseDosDadosException(
                    "Permission denied. The service account used to create the BigLake connection"
                    " does not have permission to read data from the source bucket. Please grant"
                    f" the service account {connection.service_account} the Storage Object Viewer"
                    " (roles/storage.objectViewer) role on the source bucket (or on the project)."
                    " Or, you can try running this again with set_biglake_connection_permissions=True."
                ) from exc
            raise BaseDosDadosException(
                "Something went wrong when creating the table. Please check the logs for more information."
            ) from exc
        except Exception as exc:
            raise BaseDosDadosException(
                "Something went wrong when creating the table. Please check the logs for more information."
            ) from exc

        logger.success(
            "{object} {object_id} was {action} in {mode}!",
            object_id=self.table_id,
            mode="staging",
            object="Table",
            action="created",
        )
        # return None

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
                " {object} {object_id} was {action} in {mode}!",
                object_id=self.table_id,
                mode=m["mode"],
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
        # TODO: review this method

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
                    mode=m["mode"],
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
