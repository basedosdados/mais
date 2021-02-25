import pytest
from pathlib import Path
from google.cloud import bigquery
import shutil
from google.api_core.exceptions import NotFound

from basedosdados import Dataset, Table, Storage

DATASET_ID = "pytest"
TABLE_ID = "pytest"

TABLE_FILES = ["publish.sql", "table_config.yaml"]


@pytest.fixture
def metadatadir(tmpdir_factory):
    return "tests/tmp_bases/"


@pytest.fixture
def table(metadatadir):

    t = Table(dataset_id=DATASET_ID, table_id=TABLE_ID, metadata_path=metadatadir)
    t._refresh_templates()
    return t


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
        table.init(if_folder_exists="raise", if_table_config_exists="replace")

    table.init(if_folder_exists="replace", if_table_config_exists="replace")

    check_files(folder)

    table.init(if_folder_exists="replace", if_table_config_exists="pass")

    check_files(folder)

    table.init(if_folder_exists="pass")

    check_files(folder)

    table.init(
        if_folder_exists="replace",
        data_sample_path="tests/tmp_bases/municipios.csv",
        if_table_config_exists="replace",
    )
    check_files(folder)

    table.init(
        if_folder_exists="replace",
        data_sample_path="tests/tmp_bases/municipios.csv",
        if_table_config_exists="pass",
    )

    check_files(folder)

    with pytest.raises(NotImplementedError):
        table.init(
            if_folder_exists="replace",
            data_sample_path="tests/sample_data/municipios.json",
        )


def table_exists(table, mode):

    try:
        table.client[f"bigquery_{mode}"].get_table(table.table_full_name[mode])
        return True
    except:
        return False


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
        "tests/tmp_bases/municipios.csv", mode="staging", if_exists="replace"
    )

    table.init(
        data_sample_path="tests/tmp_bases/municipios.csv",
        if_folder_exists="replace",
        if_table_config_exists="replace",
    )

    table.delete(mode="all")

    table.create(if_table_config_exists="replace", if_storage_data_exists="replace")

    assert table_exists(table, mode="staging")

    table.create(
        if_table_config_exists="pass",
        if_storage_data_exists="pass",
        if_table_exists="replace",
    )

    assert table_exists(table, mode="staging")

    with pytest.raises(FileExistsError):
        table.create(if_table_exists="replace", if_storage_data_exists="pass")

    with pytest.raises(FileExistsError):
        table.create(
            if_table_config_exists="replace",
            if_storage_data_exists="pass",
        )

    table.create(
        if_table_exists="replace",
        if_storage_data_exists="pass",
        if_table_config_exists="pass",
    )

    assert table_exists(table, mode="staging")

    table.create(
        "tests/tmp_bases/municipios.csv",
        if_table_exists="replace",
        if_storage_data_exists="pass",
        if_table_config_exists="pass",
    )

    assert table_exists(table, mode="staging")

    table.create(
        "tests/tmp_bases/municipios.csv",
        if_table_exists="replace",
        if_storage_data_exists="replace",
        if_table_config_exists="pass",
    )

    assert table_exists(table, mode="staging")

    with pytest.raises(Exception):
        table.create(
            "tests/tmp_bases/municipios.csv",
            if_table_exists="replace",
            if_table_config_exists="replace",
        )


def test_create_auto_partitions(metadatadir):

    table_part = Table(
        dataset_id=DATASET_ID,
        table_id=TABLE_ID + "_autopartitioned",
        metadata_path=metadatadir,
    )

    table_part.create(
        "tests/sample_data/partitions", partitioned=True, if_table_exists="replace"
    )

    table_part.publish()


def test_update(table):

    table.create(
        "tests/tmp_bases/municipios.csv",
        if_table_exists="pass",
        if_storage_data_exists="pass",
        if_table_config_exists="pass",
    )

    assert table_exists(table, "staging")

    ### Como dar assert que a descrição foi atualizada?

    table.update(mode="all")


def test_publish(table, metadatadir):
    table.delete("all")

    shutil.copy(
        "tests/sample_data/table/table_config.yaml",
        Path(metadatadir) / "pytest" / "pytest" / "table_config.yaml",
    )

    table.create(
        "tests/tmp_bases/municipios.csv",
        if_table_exists="replace",
        if_storage_data_exists="replace",
        if_table_config_exists="pass",
    )

    shutil.copy(
        "tests/sample_data/table/publish.sql",
        Path(metadatadir) / "pytest" / "pytest" / "publish.sql",
    )

    table.publish(if_exists="replace")

    assert table_exists(table, "prod")


def test_append(table, metadatadir):
    shutil.copy(
        "tests/tmp_bases/municipios.csv",
        "tests/tmp_bases/municipios2.csv",
    )

    table.append("tests/tmp_bases/municipios2.csv", if_exists="replace")
