import pytest
from pathlib import Path
from google.cloud import bigquery
import shutil
from google.api_core.exceptions import Conflict

from src.core import Dataset

DATASET_ID = "pytest"

DATASET_FILES = ["code", "dataset_config.yaml", "README.md"]


@pytest.fixture
def metadatadir(tmpdir_factory):
    return "tests/tmp_bases/"


@pytest.fixture
def dataset(metadatadir):
    return Dataset(dataset_id=DATASET_ID, metadata_path=metadatadir)


def check_files(folder):

    for file in DATASET_FILES:
        assert (folder / file).exists()


def test_init(dataset, metadatadir):

    # remove folder
    shutil.rmtree(Path(metadatadir))

    folder = Path(metadatadir) / DATASET_ID

    dataset.init()
    assert folder.exists()

    check_files(folder)

    dataset.init(replace=True)
    assert folder.exists()

    check_files(folder)


def dataset_exists(dataset):

    return len(
        [
            d
            for d in list(dataset.client["bigquery"].list_datasets())
            if DATASET_ID in d.dataset_id
        ]
    )


def test_delete(dataset):

    dataset.delete(mode="all")

    assert not dataset_exists(dataset)


def test_create(dataset):

    dataset.create()

    assert dataset_exists(dataset)

    with pytest.raises(Conflict):
        dataset.create(if_exists="raise")

    dataset.create(if_exists="replace")

    dataset.create(if_exists="update")

    dataset.create(if_exists="pass")

    assert dataset_exists(dataset)


def test_update(dataset):

    dataset.create(if_exists="pass")

    assert dataset_exists(dataset)

    dataset.update()


def test_publicize(dataset):

    dataset.create(if_exists="pass")

    dataset.publicize()


def test_create_dataset_ids(dataset):

    assert len(dataset._create_dataset_ids(mode="all")) == 2
    assert len(dataset._create_dataset_ids(mode="staging")) == 1
    assert "staging" in dataset._create_dataset_ids(mode="staging")[0]
    assert len(dataset._create_dataset_ids(mode="prod")) == 1
