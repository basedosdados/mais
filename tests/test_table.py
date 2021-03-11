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
    return Path("tests") / "tmp_bases"


@pytest.fixture
def table(metadatadir):

    t = Table(dataset_id=DATASET_ID, table_id=TABLE_ID, metadata_path=metadatadir)
    t._refresh_templates()
    return t


@pytest.fixture
def data_path(metadatadir):
    return Path(metadatadir) / "municipios.csv"


@pytest.fixture
def sample_data(metadatadir):
    return Path("tests") / "sample_data" / "table"


def check_files(folder):

    for file in TABLE_FILES:
        assert (folder / file).exists()


def test_init(table, metadatadir, data_path):

    # remove folder
    shutil.rmtree(metadatadir / DATASET_ID / TABLE_ID, ignore_errors=True)

    Dataset(dataset_id=DATASET_ID, metadata_path=metadatadir).init(replace=True)

    table.init(data_sample_path=data_path)

    folder = metadatadir / DATASET_ID / TABLE_ID

    check_files(folder)

    with pytest.raises(FileExistsError):
        table.init(if_folder_exists="raise", if_table_config_exists="replace")

    with pytest.raises(Exception):
        table.init(if_folder_exists="replace", if_table_config_exists="replace")

    table.init(if_folder_exists="pass", if_table_config_exists="replace")

    check_files(folder)

    with pytest.raises(FileExistsError):
        table.init(
            data_sample_path=data_path,
            if_folder_exists="replace",
            if_table_config_exists="raise",
        )

    shutil.rmtree(table.table_folder)

    with pytest.raises(Exception):
        table.init(
            if_folder_exists="replace",
            if_table_config_exists="raise",
        )

    table.init(
        data_sample_path=data_path,
        if_folder_exists="replace",
        if_table_config_exists="raise",
    )
    check_files(folder)

    table.init(
        data_sample_path=data_path,
        if_folder_exists="replace",
        if_table_config_exists="replace",
    )
    check_files(folder)

    with pytest.raises(NotImplementedError):
        table.init(
            if_folder_exists="replace",
            data_sample_path=metadatadir / "municipios.json",
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


def test_create_no_path(table, metadatadir, data_path, sample_data):

    shutil.rmtree(metadatadir / DATASET_ID / TABLE_ID, ignore_errors=True)

    Dataset(dataset_id=DATASET_ID, metadata_path=metadatadir).create(if_exists="pass")

    with pytest.raises(Exception):
        table.create(if_storage_data_exists="replace")

    Storage(dataset_id=DATASET_ID, table_id=TABLE_ID, metadata_path=metadatadir).upload(
        data_path, mode="staging", if_exists="replace"
    )

    with pytest.raises(Exception):
        table.create(if_table_config_exists="replace")

    table.init(data_sample_path=data_path, if_folder_exists="replace")

    for file in TABLE_FILES:
        shutil.copy(sample_data / file, table.table_folder / file)

    table.create(if_storage_data_exists="pass", if_table_config_exists="pass")
    assert table_exists(table, "staging")


def test_create(table, metadatadir, data_path, sample_data):

    shutil.rmtree(metadatadir / DATASET_ID / TABLE_ID, ignore_errors=True)

    Dataset(dataset_id=DATASET_ID, metadata_path=metadatadir).create(if_exists="pass")

    Storage(dataset_id=DATASET_ID, table_id=TABLE_ID, metadata_path=metadatadir).upload(
        data_path, mode="staging", if_exists="replace"
    )

    table.init(
        data_sample_path=data_path,
        if_folder_exists="replace",
        if_table_config_exists="replace",
    )

    for file in TABLE_FILES:
        shutil.copy(sample_data / file, table.table_folder / file)

    table.delete(mode="all")

    table.create(
        data_path,
        if_storage_data_exists="pass",
        if_table_config_exists="pass",
    )
    assert table_exists(table, "staging")

    table.create(
        if_table_exists="replace",
        if_storage_data_exists="pass",
        if_table_config_exists="pass",
    )
    assert table_exists(table, "staging")

    table.create(
        if_table_exists="pass",
        if_storage_data_exists="pass",
        if_table_config_exists="pass",
    )
    assert table_exists(table, "staging")

    table.delete("all")

    table.create(
        data_path,
        if_storage_data_exists="replace",
        if_table_config_exists="pass",
    )
    assert table_exists(table, "staging")

    with pytest.raises(FileExistsError):
        table.create(if_storage_data_exists="pass", if_table_config_exists="pass")


def test_create_table_config_exists(table, metadatadir, data_path, sample_data):

    table.delete("all")
    Storage(DATASET_ID, TABLE_ID).delete_table()
    shutil.rmtree(metadatadir / DATASET_ID / TABLE_ID, ignore_errors=True)

    table.create(
        data_path,
    )
    assert table_exists(table, mode="staging")

    for file in TABLE_FILES:
        shutil.copy(sample_data / file, table.table_folder / file)

    table.delete("all")

    table.create(
        if_storage_data_exists="pass",
        if_table_config_exists="pass",
    )
    assert table_exists(table, mode="staging")

    table.delete("all")

    table.create(
        data_path, if_storage_data_exists="pass", if_table_config_exists="replace"
    )
    assert table_exists(table, mode="staging")

    with pytest.raises(FileExistsError):
        table.create(data_path, if_table_exists="pass", if_storage_data_exists="pass")


def test_create_storage_data(table, metadatadir, data_path):

    table.delete("all")

    Storage(DATASET_ID, TABLE_ID).delete_table()

    table.create(data_path, if_table_config_exists="replace")
    assert table_exists(table, mode="staging")

    table.delete("all")
    table.create(
        data_path, if_storage_data_exists="replace", if_table_config_exists="replace"
    )

    table.delete("all")
    table.create(
        data_path, if_storage_data_exists="pass", if_table_config_exists="replace"
    )
    assert table_exists(table, mode="staging")

    with pytest.raises(Exception):
        table.create(
            data_path,
            if_table_exists="pass",
            if_table_config_exists="pass",
            if_storage_data_exists="raise",
        )


def test_create_auto_partitions(metadatadir, data_path, sample_data):
    shutil.rmtree(metadatadir / "partitions", ignore_errors=True)

    table_part = Table(
        dataset_id=DATASET_ID,
        table_id=TABLE_ID + "_partitioned",
        metadata_path=metadatadir,
    )

    table_part.delete("all")

    table_part.init(
        data_sample_path=data_path,
        if_folder_exists="replace",
        if_table_config_exists="replace",
    )

    Path(metadatadir / "partitions").mkdir()

    shutil.copy(
        sample_data / "table_config_part.yaml",
        Path(table_part.table_folder / "table_config.yaml"),
    )
    shutil.copy(
        sample_data / "publish_part.sql",
        table_part.table_folder / "publish.sql",
    )
    for n in [1, 2]:
        Path(metadatadir / "partitions" / f"keys={n}").mkdir()
        shutil.copy(
            metadatadir / "municipios.csv",
            metadatadir / "partitions" / f"keys={n}" / "municipios.csv",
        )

    table_part.create(
        metadatadir / "partitions",
        partitioned=True,
        if_table_exists="replace",
        if_table_config_exists="pass",
        if_storage_data_exists="replace",
    )
    assert table_exists(table_part, "staging")

    table_part.publish()

    assert table_exists(table_part, "prod")


def test_update(table, metadatadir, data_path):

    table.create(
        data_path,
        if_table_exists="pass",
        if_storage_data_exists="pass",
        if_table_config_exists="pass",
    )

    assert table_exists(table, "staging")

    ### Como dar assert que a descrição foi atualizada?

    table.update(mode="all")


def test_publish(table, metadatadir, sample_data, data_path):
    table.delete("all")
    Storage(
        dataset_id=DATASET_ID, table_id=TABLE_ID, metadata_path=metadatadir
    ).delete_table(not_found_ok=True)

    shutil.copy(
        sample_data / "publish.sql",
        metadatadir / DATASET_ID / TABLE_ID / "publish.sql",
    )

    shutil.copy(
        sample_data / "table_config.yaml",
        metadatadir / DATASET_ID / TABLE_ID / "table_config.yaml",
    )

    table.create(
        data_path,
        if_table_exists="replace",
        if_storage_data_exists="replace",
        if_table_config_exists="pass",
    )

    table.publish(if_exists="replace")

    assert table_exists(table, "prod")


def test_append(table, metadatadir):
    shutil.copy(
        metadatadir / "municipios.csv",
        metadatadir / "municipios2.csv",
    )

    table.append((metadatadir / "municipios2.csv"), if_exists="replace")
