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
def metadata(metadatadir, request):
    marker = request.node.get_closest_marker("create_mode")
    if marker.args[0] == "dataset_id":
        return Metadata(dataset_id=DATASET_ID, metadata_path=metadatadir)
    elif marker.args[0] == "table_id":
        return Metadata(dataset_id=DATASET_ID, table_id=TABLE_ID, metadata_path=metadatadir)
    return None


@pytest.mark.create_mode("dataset_id")
def test_create_with_dataset_id(metadata, metadatadir):
    metadata.create()
    folder = Path(metadatadir) / DATASET_ID
    assert (folder / METADATA_FILES['dataset']).exists()


@pytest.mark.create_mode("table_id")
def test_create_with_dataset_and_table_id(metadata, metadatadir):
    metadata.create()
    folder = Path(metadatadir) / DATASET_ID / TABLE_ID
    assert (folder / METADATA_FILES['table']).exists()
