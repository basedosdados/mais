import pytest
from pathlib import Path
from google.cloud import bigquery
import shutil
from google.api_core.exceptions import NotFound

from src.core import Dataset, Table, Storage

DATASET_ID = "pytest"
TABLE_ID = "pytest"

TABLE_FILES = ["publish.sql", "table_config.yaml"]


@pytest.fixture
def metadatadir(tmpdir_factory):
    return "tests/tmp_bases/"


@pytest.fixture
def table(metadatadir):

    return Table(dataset_id=DATASET_ID, table_id=TABLE_ID, metadata_path=metadatadir)


def check_files(folder):

    for file in TABLE_FILES:
        assert (folder / file).exists()


def test_init(table, metadatadir):

    # remove folder
    shutil.rmtree(Path(metadatadir) / DATASET_ID / TABLE_ID, ignore_errors=True)

    Dataset(dataset_id=DATASET_ID, metadata_path=metadatadir).init(replace=True)

    table.init()

    folder = Path(metadatadir) / DATASET_ID / TABLE_ID

    check_files(folder)

    with pytest.raises(FileExistsError):
        table.init()

    table.init(replace=True)

    check_files(folder)

    table.init(replace=True, data_sample_path="tests/sample_data/municipios.csv")

    check_files(folder)

    with pytest.raises(NotImplementedError):
        table.init(replace=True, data_sample_path="tests/sample_data/municipios.json")


def table_exists(table, mode):

    if mode == "prod":

        l = list(table.client["bigquery"].list_tables(table.dataset_id))
    elif mode == "staging":

        l = list(table.client["bigquery"].list_tables(table.dataset_id + "_staging"))
    return len([d for d in l if TABLE_ID in d.table_id])


def test_delete(table):

    table.delete(mode="all")
    table.delete(mode="staging")
    table.delete(mode="prod")

    assert not table_exists(table, mode="staging")
    assert not table_exists(table, mode="prod")


def test_create(table, metadatadir):

    shutil.rmtree(Path(metadatadir) / DATASET_ID / TABLE_ID, ignore_errors=True)

    Dataset(dataset_id=DATASET_ID, metadata_path=metadatadir).create(if_exists="pass")

    Storage(dataset_id=DATASET_ID, table_id=TABLE_ID, metadata_path=metadatadir).upload(
        "tests/sample_data/municipios.csv", mode="staging", if_exists="replace"
    )

    table.init(data_sample_path="tests/sample_data/municipios.csv", replace=True)

    table.delete(mode="all")

    table.create()

    assert table_exists(table, mode="staging")

    table.create(if_exists="replace")

    assert table_exists(table, mode="staging")


def test_create_partitioned(metadatadir):

    shutil.rmtree(
        Path(metadatadir) / DATASET_ID / (TABLE_ID + "_partitioned"), ignore_errors=True
    )

    Dataset(dataset_id=DATASET_ID, metadata_path=metadatadir).create(if_exists="pass")

    Storage(
        dataset_id=DATASET_ID,
        table_id=TABLE_ID + "_partitioned",
        metadata_path=metadatadir,
    ).upload(
        "tests/sample_data/municipios.csv",
        mode="staging",
        if_exists="replace",
        partitions="key1=value1/key2=value2",
    )

    table = Table(
        dataset_id=DATASET_ID,
        table_id=TABLE_ID + "_partitioned",
        metadata_path=metadatadir,
    )

    table.init(data_sample_path="tests/sample_data/municipios.csv", replace=True)

    shutil.copy(
        "tests/sample_data/table/table_config_part.yaml",
        Path(metadatadir) / "pytest" / "pytest_partitioned" / "table_config.yaml",
    )
    shutil.copy(
        "tests/sample_data/table/publish_part.sql",
        Path(metadatadir) / "pytest" / "pytest_partitioned" / "publish.sql",
    )

    table.create(partitioned=True)

    table.update(mode="staging")

    table.publish(if_exists="replace")


def test_update(table):

    table.create(if_exists="pass")

    assert table_exists(table, "staging")

    table.update(mode="all")


def test_publish(table, metadatadir):

    table.create(if_exists="pass")

    shutil.copy(
        "tests/sample_data/table/table_config.yaml",
        Path(metadatadir) / "pytest" / "pytest" / "table_config.yaml",
    )
    shutil.copy(
        "tests/sample_data/table/publish.sql",
        Path(metadatadir) / "pytest" / "pytest" / "publish.sql",
    )

    table.publish(if_exists="replace")

    assert table_exists(table, "prod")
