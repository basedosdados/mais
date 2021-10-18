import pytest
from pathlib import Path
from google.cloud import bigquery
import shutil
from google.api_core.exceptions import NotFound

from basedosdados import Dataset, Table, Storage
from basedosdados.exceptions import BaseDosDadosException

DATASET_ID = "pytest"
TABLE_ID = "pytest"

TABLE_FILES = ["publish.sql", "table_config.yaml"]


@pytest.fixture
def metadatadir(tmpdir_factory):
    (Path(__file__).parent / "tmp_bases").mkdir(exist_ok=True)
    return Path(__file__).parent / "tmp_bases"


@pytest.fixture
def table(metadatadir):

    t = Table(dataset_id=DATASET_ID, table_id=TABLE_ID, metadata_path=metadatadir)
    t._refresh_templates()
    return t


@pytest.fixture
def folder(metadatadir):
    return metadatadir / DATASET_ID / TABLE_ID


@pytest.fixture
def sample_data(metadatadir):
    return metadatadir.parent / "sample_data" / "table"


@pytest.fixture
def data_path(sample_data):
    return sample_data / "municipio.csv"


def check_files(folder):

    for file in TABLE_FILES:
        assert (folder / file).exists()


def test_init(
    table,
    metadatadir,
    folder,
    data_path,
):

    # remove folder
    shutil.rmtree(metadatadir / DATASET_ID / TABLE_ID, ignore_errors=True)

    Dataset(dataset_id=DATASET_ID, metadata_path=metadatadir).init(replace=True)

    table.init(data_sample_path=data_path)

    check_files(folder)


def test_init_file_exists_error(table, metadatadir, data_path):

    with pytest.raises(FileExistsError):
        table.init(if_folder_exists="raise", if_table_config_exists="replace")

    with pytest.raises(FileExistsError):
        table.init(
            data_sample_path=data_path,
            if_folder_exists="replace",
            if_table_config_exists="raise",
        )


def test_init_not_implemented_error(table, metadatadir, data_path):

    with pytest.raises(NotImplementedError):
        table.init(
            if_folder_exists="replace",
            if_table_config_exists="replace",
            data_sample_path=data_path,
            source_format="json",
        )


def test_init_no_path(table, metadatadir, data_path):

    with pytest.raises(BaseDosDadosException):
        table.init(if_folder_exists="replace", if_table_config_exists="replace")

    with pytest.raises(BaseDosDadosException):
        table.init(
            if_folder_exists="replace",
            if_table_config_exists="raise",
        )


def test_init_if_folder_exists_pass_if_table_config_replace(
    table, metadatadir, folder, data_path
):

    table.init(if_folder_exists="pass", if_table_config_exists="replace")

    check_files(folder)


def test_init_if_folder_exists_replace_if_table_config_raise(
    table, metadatadir, folder, data_path
):
    shutil.rmtree(table.table_folder)

    table.init(
        data_sample_path=data_path,
        if_folder_exists="replace",
        if_table_config_exists="raise",
    )
    check_files(folder)


def test_init_if_folder_exists_replace_if_table_config_exists_replace(
    table, metadatadir, folder, data_path
):

    table.init(
        data_sample_path=data_path,
        if_folder_exists="replace",
        if_table_config_exists="replace",
    )

    check_files(folder)


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


def test_create_no_path_error(table, metadatadir, data_path, sample_data):

    shutil.rmtree(metadatadir / DATASET_ID / TABLE_ID, ignore_errors=True)

    Dataset(dataset_id=DATASET_ID, metadata_path=metadatadir).create(if_exists="pass")

    with pytest.raises(BaseDosDadosException):
        table.create(if_storage_data_exists="replace")

    with pytest.raises(BaseDosDadosException):
        table.create(if_table_config_exists="replace")


def test_create_no_path(table, metadatadir, data_path, sample_data):

    Storage(dataset_id=DATASET_ID, table_id=TABLE_ID, metadata_path=metadatadir).upload(
        data_path, mode="staging", if_exists="replace"
    )

    table.init(data_sample_path=data_path, if_folder_exists="replace")

    for file in TABLE_FILES:
        shutil.copy(sample_data / file, table.table_folder / file)

    table.create(if_storage_data_exists="pass", if_table_config_exists="pass")
    assert table_exists(table, "staging")


def test_create_storage_data_exist_table_config_exist(
    table, metadatadir, data_path, sample_data
):

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


def test_create_if_table_exist_replace(table, metadatadir, data_path, sample_data):

    table.create(
        if_table_exists="replace",
        if_storage_data_exists="pass",
        if_table_config_exists="pass",
    )
    assert table_exists(table, "staging")


def table_create_not_implemented_source_format(table):

    with pytest.raises(NotImplementedError):
        table.create(
            if_table_exists="replace",
            if_storage_data_exists="pass",
            if_table_config_exists="pass",
            source_format="json",
        )


def test_create_if_table_exists_pass(table, metadatadir, data_path, sample_data):
    table.create(
        if_table_exists="pass",
        if_storage_data_exists="pass",
        if_table_config_exists="pass",
    )
    assert table_exists(table, "staging")


def test_create_if_storage_data_replace_if_table_config_pass(
    table, metadatadir, data_path, sample_data
):
    table.delete("all")

    table.create(
        data_path,
        if_storage_data_exists="replace",
        if_table_config_exists="pass",
    )
    assert table_exists(table, "staging")


def test_create_if_table_exists_raise(table, metadatadir, data_path):

    with pytest.raises(FileExistsError):
        table.create(if_storage_data_exists="pass", if_table_config_exists="pass")


def test_create_with_path(table, metadatadir, data_path, sample_data):

    table.delete("all")
    Storage(DATASET_ID, TABLE_ID).delete_table(not_found_ok=True)
    shutil.rmtree(metadatadir / DATASET_ID / TABLE_ID, ignore_errors=True)

    table.create(
        data_path,
    )
    assert table_exists(table, mode="staging")


def test_create_if_storage_data_pass_if_table_config_pass(
    table, metadatadir, data_path, sample_data
):
    for file in TABLE_FILES:
        shutil.copy(sample_data / file, table.table_folder / file)

    table.delete("all")

    table.create(
        if_storage_data_exists="pass",
        if_table_config_exists="pass",
    )
    assert table_exists(table, mode="staging")


def test_create_if_storage_data_pass_if_table_config_replace(
    table, metadatadir, data_path, sample_data
):

    table.delete("all")

    table.create(
        data_path, if_storage_data_exists="pass", if_table_config_exists="replace"
    )
    assert table_exists(table, mode="staging")


def test_create_if_folder_exists_raise(table, metadatadir, data_path, sample_data):
    with pytest.raises(FileExistsError):
        table.create(data_path, if_table_exists="pass", if_storage_data_exists="pass")


def test_create_with_upload(table, metadatadir, data_path):

    table.delete("all")

    Storage(DATASET_ID, TABLE_ID).delete_table(not_found_ok=True)

    table.create(data_path, if_table_config_exists="replace")
    assert table_exists(table, mode="staging")


def test_create_if_storage_data_replace_if_table_config_replace(
    table, metadatadir, data_path
):
    table.delete("all")
    table.create(
        data_path, if_storage_data_exists="replace", if_table_config_exists="replace"
    )
    assert table_exists(table, mode="staging")


def test_create_if_storage_data_raise(table, metadatadir, data_path):

    Storage(dataset_id=DATASET_ID, table_id=TABLE_ID, metadata_path=metadatadir).upload(
        data_path, mode="staging", if_exists="replace"
    )

    with pytest.raises(Exception):
        table.create(
            data_path,
            if_table_exists="replace",
            if_table_config_exists="replace",
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
            data_path,
            metadatadir / "partitions" / f"keys={n}" / "municipio.csv",
        )

    table_part.create(
        metadatadir / "partitions",
        if_table_exists="replace",
        if_table_config_exists="pass",
        if_storage_data_exists="replace",
    )
    assert table_exists(table_part, "staging")

    table_part.publish()

    assert table_exists(table_part, "prod")


def test_update_raises(metadatadir, sample_data, capsys):

    table_part = Table(
        dataset_id=DATASET_ID,
        table_id=TABLE_ID + "_partitioned",
        metadata_path=metadatadir,
    )

    shutil.copy(
        sample_data / "table_config_part_wrong.yaml",
        metadatadir / DATASET_ID / "pytest_partitioned" / "table_config.yaml",
    )

    with pytest.raises(Exception):
        table_part.update("all")
        out, err = capsys.readouterr()
        assert "publish.sql" in out

    shutil.copy(
        sample_data / "publish_part.sql",
        table_part.table_folder / "publish.sql",
    )
    shutil.copy(
        sample_data / "table_config.yaml",
        Path(table_part.table_folder / "table_config.yaml"),
    )

    with pytest.raises(Exception):
        table.update("all")
        assert "table_config.yaml" in out


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


def test_append(table, metadatadir, data_path):
    shutil.copy(
        data_path,
        metadatadir / "municipio2.csv",
    )

    table.append((metadatadir / "municipio2.csv"))
