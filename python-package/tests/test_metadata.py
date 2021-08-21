import pytest
from pathlib import Path

from basedosdados import Metadata


DATASET_ID = "pytest"
TABLE_ID = "pytest"

METADATA_FILES = {
    "dataset": "dataset_config.yaml",
    "table": "table_config.yaml"
}


@pytest.fixture
def metadatadir(tmpdir_factory):
    (Path(__file__).parent / "tmp_bases").mkdir(exist_ok=True)
    return Path(__file__).parent / "tmp_bases"


@pytest.fixture
def dataset_metadata(metadatadir):
    return Metadata(
        dataset_id=DATASET_ID,
        metadata_path=metadatadir
    )
    

@pytest.fixture
def table_metadata(metadatadir):
    return Metadata(
        dataset_id=DATASET_ID,
        table_id=TABLE_ID,
        metadata_path=metadatadir
    )


@pytest.fixture
def dataset_metadata_path(metadatadir):
    return Path(metadatadir) / DATASET_ID


@pytest.fixture
def table_metadata_path(metadatadir):
    return Path(metadatadir) / DATASET_ID / TABLE_ID


def test_create_with_dataset_id(dataset_metadata, dataset_metadata_path):
    dataset_metadata.create()
    assert (dataset_metadata_path / METADATA_FILES['dataset']).exists()


def test_create_with_dataset_and_table_id(table_metadata, table_metadata_path):
    table_metadata.create()
    assert (table_metadata_path / METADATA_FILES['table']).exists()
