'''
Tests for DataType class
'''

import basedosdados as bd
from basedosdados.upload.datatypes import Datatype
import pytest
from pathlib import Path
from google.cloud.bigquery.external_config import ExternalConfig, HivePartitioningOptions


@pytest.fixture(name="metadatadir")
def fixture_metadatadir():
    '''
    Fixture for metadatadir
    '''
    (Path(__file__).parent / "tmp_bases").mkdir(exist_ok=True)
    return Path(__file__).parent / "tmp_bases"


@pytest.fixture(name="table")
def fixture_table(metadatadir):
    '''
    Fixture for table
    '''
    t = Table(dataset_id=DATASET_ID, table_id=TABLE_ID, metadata_path=metadatadir)
    t._refresh_templates()
    return t


@pytest.fixture(name="folder")
def fixture_folder(metadatadir):
    '''
    Fixture for folder
    '''
    return metadatadir / DATASET_ID / TABLE_ID


@pytest.fixture(name="sample_data")
def fixture_sample_data(metadatadir):
    '''
    Fixture for sample_data
    '''
    return metadatadir.parent / "sample_data" / "table"


@pytest.fixture(name="data_csv_path")
def fixture_data_csv_path(sample_data):
    '''
    Fixture for data_csv_path
    '''
    return sample_data / "municipio.csv"


@pytest.fixture(name="data_parquet_path")
def fixture_data_parquet_path(sample_data):
    '''
    Fixture for data_parquet_path
    '''
    return sample_data / "municipio.parquet"


@pytest.fixture(name="data_avro_path")
def fixture_data_avro_path(sample_data):
    '''
    Fixture for data_avro_path
    '''
    return sample_data / "municipio.avro"

def test_header_avro(data_avro_path):
    '''
    Test if header is returned for avro format
    '''
    table = bd.Table("ds_test", "tb_test")
    dt = Datatype(table, source_format="avro")
    cols = dt.header(data_avro_path)
    assert cols==['ano', 'id_municipio', 'pib', 'impostos_liquidos', 'va', 'va_agropecuaria', 'va_industria', 'va_servicos', 'va_adespss']

def test_header_parquet(data_parquet_path):
    '''
    Test if header is returned for parquet format
    '''
    table = bd.Table("ds_test", "tb_test")
    dt = Datatype(table, source_format="parquet")
    cols = dt.header(data_parquet_path)
    assert cols==['ano', 'id_municipio', 'pib', 'impostos_liquidos', 'va', 'va_agropecuaria', 'va_industria', 'va_servicos', 'va_adespss']

def test_header_csv(data_csv_path):
    '''
    Test if header is returned for avro format
    '''
    table = bd.Table("ds_test", "tb_test")
    dt = Datatype(table, source_format="csv")
    cols = dt.header(data_csv_path)
    assert cols==['ano', 'id_municipio', 'pib', 'impostos_liquidos', 'va', 'va_agropecuaria', 'va_industria', 'va_servicos', 'va_adespss']

def test_partition_avro():
    '''
    Test if partition config is returned for avro format
    '''
    table = bd.Table("ds_test", "tb_test")
    dt = Datatype(table, source_format="avro")
    partition = dt.partition()
    assert isinstance(partition, HivePartitioningOptions)

def test_partition_parquet():
    '''
    Test if partition config is returned for parquet format
    '''
    table = bd.Table("ds_test", "tb_test")
    dt = Datatype(table, source_format="parquet")
    partition = dt.partition()
    assert isinstance(partition, HivePartitioningOptions)

def test_partition_avro():
    '''
    Test if partition config is returned for avro format
    '''
    table = bd.Table("ds_test", "tb_test")
    dt = Datatype(table, source_format="avro")
    partition = dt.partition()
    assert isinstance(partition, HivePartitioningOptions)

@pytest.mark.skip(
    reason="This test requires a mocked CKAN server and a test dataset/table.")
def test_external_config_csv(data_csv_path):
    '''
    Test if external config is returned for csv format
    '''
    table = bd.Table("ds_test", "tb_test")
    table.create(path=data_csv_path, if_storage_data_exists="replace")
    dt = Datatype(table, source_format="csv")
    assert isinstance(dt.external_config, ExternalConfig)

@pytest.mark.skip(
    reason="This test requires a mocked CKAN server and a test dataset/table.")
def test_external_config_parquet():
    '''
    Test if external config is returned for parquet format
    '''
    table = bd.Table("ds_test", "tb_test")
    table.create(path=data_parquet_path, if_storage_data_exists="replace")
    dt = Datatype(table, source_format="parquet")
    assert isinstance(dt.external_config, ExternalConfig)

@pytest.mark.skip(
    reason="This test requires a mocked CKAN server and a test dataset/table.")
def test_external_config_avro():
    '''
    Test if external config is returned for avro format
    '''
    table = bd.Table("ds_test", "tb_test")
    table.create(path=data_avro_path, if_storage_data_exists="replace")
    dt = Datatype(table, source_format="avro")
    assert isinstance(dt.external_config, ExternalConfig)