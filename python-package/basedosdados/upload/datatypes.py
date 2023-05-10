"""
Class for define external and partiton configs for each datatype
"""
# pylint: disable=protected-access,line-too-long
import csv

from google.cloud import bigquery
import pandas as pd
import pandavro


class Datatype:
    """
    Manage external and partition config
    """

    def __init__(  # pylint: disable=too-many-arguments
        self,
        dataset_id="",
        table_id="",
        schema=None,
        source_format="csv",
        mode="staging",
        bucket_name=None,
        partitioned=False,
        biglake_connection_id=None,
    ):
        self.dataset_id = dataset_id.replace("_staging", "")
        self.schema = schema
        self.source_format = source_format
        self.mode = mode
        self.uri = f"gs://{bucket_name}/staging/{self.dataset_id}/{table_id}/*"
        self.partitioned = partitioned
        self.biglake_connection_id = biglake_connection_id

    def header(self, data_sample_path):
        """
        Retrieve the header of the data sample
        """

        if self.source_format == "csv":
            return next(csv.reader(open(data_sample_path, "r", encoding="utf-8")))
        if self.source_format == "avro":
            dataframe = pandavro.read_avro(str(data_sample_path))
            return list(dataframe.columns.values)
        if self.source_format == "parquet":
            dataframe = pd.read_parquet(str(data_sample_path))
            return list(dataframe.columns.values)
        raise NotImplementedError(
            "Base dos Dados just supports comma separated csv, avro and parquet files"
        )

    def partition(self):
        """
        Configure the partitioning of the table
        """
        hive_partitioning = bigquery.external_config.HivePartitioningOptions()
        hive_partitioning.mode = "STRINGS"
        hive_partitioning.source_uri_prefix = self.uri.replace("*", "")

        return hive_partitioning

    @property
    def external_config(self):
        """
        Configure the external table
        """
        if self.source_format == "csv":
            _external_config = bigquery.ExternalConfig("CSV")
            _external_config.options.skip_leading_rows = 1
            _external_config.options.allow_quoted_newlines = True
            _external_config.options.allow_jagged_rows = True
            _external_config.autodetect = False
            _external_config.schema = self.schema
        elif self.source_format == "avro":
            _external_config = bigquery.ExternalConfig("AVRO")
        elif self.source_format == "parquet":
            _external_config = bigquery.ExternalConfig("PARQUET")
        else:
            raise NotImplementedError(
                "Base dos Dados just supports csv, avro and parquet files"
            )
        _external_config.source_uris = self.uri
        if self.partitioned:
            _external_config.hive_partitioning = self.partition()

        if self.biglake_connection_id:
            _external_config.connection_id = self.biglake_connection_id
            # When using BigLake tables, schema must be provided to the `Table` object, not the
            # `ExternalConfig` object.
            _external_config.schema = None

        return _external_config
