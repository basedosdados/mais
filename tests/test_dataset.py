import pytest
from pathlib import Path
from google.cloud import bigquery
import shutil
from google.api_core.exceptions import Conflict

from basedosdados import Dataset

DATASET_ID = "pytest"

DATASET_FILES = ["code", "dataset_config.yaml", "README.md"]


@pytest.fixture
def metadatadir(tmpdir_factory):
    (Path(__file__).parent / "tmp_bases").mkdir(exist_ok=True)
    return Path(__file__).parent / "tmp_bases"


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

    try:
        [m["client"].get_dataset(m["id"]) for m in dataset._loop_modes("all")]
        return True
    except:
        return False


def test_delete(dataset):

    dataset.delete(mode="all")

    assert not dataset_exists(dataset)


def test_create(dataset):

    dataset.delete(mode="all")

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


def test_loop_modes(dataset):

    assert len(list(dataset._loop_modes(mode="all"))) == 2
    assert len(list(dataset._loop_modes(mode="staging"))) == 1
    assert "staging" in next(dataset._loop_modes(mode="staging"))["id"]
    assert len(list(dataset._loop_modes(mode="prod"))) == 1
