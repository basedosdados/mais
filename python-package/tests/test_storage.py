import pytest
from pathlib import Path
from google.cloud import storage
import shutil
from google.api_core.exceptions import NotFound
from basedosdados import Storage

DATASET_ID = "pytest"
TABLE_ID = "pytest"
SAVEPATH = Path(__file__).parent / "tmp_bases"

TABLE_FILES = ["publish.sql", "table_config.yaml"]


@pytest.fixture
def metadatadir(tmpdir_factory):
    (Path(__file__).parent / "tmp_bases").mkdir(exist_ok=True)
    return Path(__file__).parent / "tmp_bases"


@pytest.fixture
def storage(metadatadir):
    return Storage(dataset_id=DATASET_ID, table_id=TABLE_ID, metadata_path=metadatadir)


def test_upload(storage, metadatadir):

    storage.delete_file("municipio.csv", "staging", not_found_ok=True)

    storage.upload(metadatadir / "municipio.csv", mode="staging")

    with pytest.raises(Exception):
        storage.upload(metadatadir / "municipio.csv", mode="staging")

    storage.upload(metadatadir / "municipio.csv", mode="staging", if_exists="replace")

    storage.upload(
        metadatadir / "municipio.csv",
        mode="staging",
        if_exists="replace",
        partitions="key1=value1/key2=value2",
    )

    storage.upload(
        metadatadir / "municipio.csv",
        mode="staging",
        if_exists="replace",
        partitions={"key1": "value1", "key2": "value1"},
    )

    with pytest.raises(Exception):
        storage.upload(
            metadatadir / "municipio.csv",
            mode="staging",
            if_exists="replace",
            partitions=["key1", "value1", "key2", "value1"],
        )


def test_download_not_found(storage):

    with pytest.raises(FileNotFoundError):
        storage.download(filename="not_found", savepath=SAVEPATH)

    with pytest.raises(FileNotFoundError):
        storage.download(savepath=SAVEPATH)


def test_download_filename(storage):

    storage.download(filename="municipio.csv", savepath=SAVEPATH, mode="staging")

    assert (
        Path(SAVEPATH) / "staging" / DATASET_ID / TABLE_ID / "municipio.csv"
    ).is_file()


def test_download_partitions(storage):

    storage.download(
        savepath=SAVEPATH,
        mode="staging",
        partitions="key1=value1/key2=value1/",
    )

    assert (
        Path(SAVEPATH)
        / "staging"
        / DATASET_ID
        / TABLE_ID
        / "key1=value1"
        / "key2=value1"
        / "municipio.csv"
    ).is_file()

    storage.download(
        savepath=SAVEPATH,
        mode="staging",
        partitions={"key1": "value1", "key2": "value2"},
    )

    assert (
        Path(SAVEPATH)
        / "staging"
        / DATASET_ID
        / TABLE_ID
        / "key1=value1"
        / "key2=value2"
        / "municipio.csv"
    ).is_file()


def test_download_default(storage):
    storage.download(savepath=SAVEPATH, mode="staging")

    assert (
        Path(SAVEPATH) / "staging" / DATASET_ID / TABLE_ID / "municipio.csv"
    ).is_file()

    assert (
        Path(SAVEPATH) / "staging" / DATASET_ID / TABLE_ID / "municipio2.csv"
    ).is_file()


def test_delete_file(storage):

    storage.delete_file("municipio.csv", "staging")

    with pytest.raises(NotFound):
        storage.delete_file("municipio.csv", "staging")

    storage.delete_file("municipio.csv", "staging", not_found_ok=True)


def test_copy_table(storage):

    Storage("br_ibge_pib", "municipio").copy_table()

    with pytest.raises(FileNotFoundError):
        Storage("br_ibge_pib2", "municipio2").copy_table()

    Storage("br_ibge_pib", "municipio").copy_table(
        destination_bucket_name="basedosdados-dev",
    )


def test_delete_table(storage):

    Storage("br_ibge_pib", "municipio").delete_table(bucket_name="basedosdados-dev")

    with pytest.raises(FileNotFoundError):
        Storage("br_ibge_pib", "municipio").delete_table()
