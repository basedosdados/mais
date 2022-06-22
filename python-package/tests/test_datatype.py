"""
Tests for DataType class
"""
# pylint: disable=too-many-arguments, invalid-name

from pathlib import Path

import pytest
from google.cloud.bigquery.external_config import (
    ExternalConfig,
    HivePartitioningOptions,
)
import basedosdados as bd
from basedosdados.upload.datatypes import Datatype


@pytest.fixture(name="metadatadir")
def fixture_metadatadir():
    """
    Fixture for metadatadir
    """
    (Path(__file__).parent / "tmp_bases").mkdir(exist_ok=True)
    return Path(__file__).parent / "tmp_bases"


@pytest.fixture(name="sample_data")
def fixture_sample_data(metadatadir):
    """
    Fixture for sample_data
    """
    return metadatadir.parent / "sample_data" / "table"


@pytest.fixture(name="data_csv_path")
def fixture_data_csv_path(sample_data):
    """
    Fixture for data_csv_path
    """
    return sample_data / "municipio.csv"


@pytest.fixture(name="data_parquet_path")
def fixture_data_parquet_path(sample_data):
    """
    Fixture for data_parquet_path
    """
    return sample_data / "municipio.parquet"


@pytest.fixture(name="data_avro_path")
def fixture_data_avro_path(sample_data):
    """
    Fixture for data_avro_path
    """
    return sample_data / "municipio.avro"


def test_header_avro(data_avro_path):
    """
    Test if header is returned for avro format
    """
    table = bd.Table("ds_test", "tb_test")
    dt = Datatype(table, source_format="avro")
    cols = dt.header(data_avro_path)
    assert cols == [
        "ano",
        "id_municipio",
        "pib",
        "impostos_liquidos",
        "va",
        "va_agropecuaria",
        "va_industria",
        "va_servicos",
        "va_adespss",
    ]


def test_header_parquet(data_parquet_path):
    """
    Test if header is returned for parquet format
    """
    table = bd.Table("ds_test", "tb_test")
    dt = Datatype(table, source_format="parquet")
    cols = dt.header(data_parquet_path)
    assert cols == [
        "ano",
        "id_municipio",
        "pib",
        "impostos_liquidos",
        "va",
        "va_agropecuaria",
        "va_industria",
        "va_servicos",
        "va_adespss",
    ]


def test_header_csv(data_csv_path):
    """
    Test if header is returned for avro format
    """
    table = bd.Table("ds_test", "tb_test")
    dt = Datatype(table, source_format="csv")
    cols = dt.header(data_csv_path)
    assert cols == [
        "ano",
        "id_municipio",
        "pib",
        "impostos_liquidos",
        "va",
        "va_agropecuaria",
        "va_industria",
        "va_servicos",
        "va_adespss",
    ]


def test_partition_avro():
    """
    Test if partition config is returned for avro format
    """
    table = bd.Table("ds_test", "tb_test")
    dt = Datatype(table, source_format="avro")
    partition = dt.partition()
    assert isinstance(partition, HivePartitioningOptions)


def test_partition_parquet():
    """
    Test if partition config is returned for parquet format
    """
    table = bd.Table("ds_test", "tb_test")
    dt = Datatype(table, source_format="parquet")
    partition = dt.partition()
    assert isinstance(partition, HivePartitioningOptions)


def test_partition_csv():
    """
    Test if partition config is returned for csv format
    """
    table = bd.Table("ds_test", "tb_test")
    dt = Datatype(table, source_format="csv")
    partition = dt.partition()
    assert isinstance(partition, HivePartitioningOptions)


def test_external_config_parquet():
    """
    Test if external config is returned for parquet format
    """
    # must be a dataset_id and table_id in BQ
    table = bd.Table("br_poder360_pesquisas", "microdados")
    dt = Datatype(table, source_format="parquet")
    assert isinstance(dt.external_config, ExternalConfig)


def test_external_config_avro():
    """
    Test if external config is returned for avro format
    """
    # must be a dataset_id and table_id in BQ
    table = bd.Table("br_poder360_pesquisas", "microdados")
    dt = Datatype(table, source_format="avro")
    assert isinstance(dt.external_config, ExternalConfig)


def test_external_config_csv():
    """
    Test if external config is returned for csv format
    """
    # must be a dataset_id and table_id in BQ
    table = bd.Table("br_poder360_pesquisas", "microdados")
    dt = Datatype(table, source_format="csv")
    assert isinstance(dt.external_config, ExternalConfig)
