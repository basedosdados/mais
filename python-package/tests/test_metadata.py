import pytest
import ruamel.yaml as ryaml

from pathlib import Path
import shutil

from basedosdados import Metadata
from basedosdados.exceptions import BaseDosDadosException


DATASET_ID = "pytest"
TABLE_ID = "pytest"

METADATA_FILES = {"dataset": "dataset_config.yaml", "table": "table_config.yaml"}


@pytest.fixture
def metadatadir(tmpdir_factory):
    (Path(__file__).parent / "tmp_bases").mkdir(exist_ok=True)
    return Path(__file__).parent / "tmp_bases"


@pytest.fixture
def dataset_metadata(metadatadir):
    return Metadata(dataset_id=DATASET_ID, metadata_path=metadatadir)


@pytest.fixture
def table_metadata(metadatadir):
    return Metadata(dataset_id=DATASET_ID, table_id=TABLE_ID, metadata_path=metadatadir)


@pytest.fixture
def dataset_metadata_path(metadatadir):
    return Path(metadatadir) / DATASET_ID


@pytest.fixture
def table_metadata_path(metadatadir):
    return Path(metadatadir) / DATASET_ID / TABLE_ID


def test_create_from_dataset_id(dataset_metadata, dataset_metadata_path):
    shutil.rmtree(dataset_metadata_path, ignore_errors=True)
    dataset_metadata.create()
    assert (dataset_metadata_path / METADATA_FILES["dataset"]).exists()


def test_create_from_dataset_and_table_id(table_metadata, table_metadata_path):
    shutil.rmtree(table_metadata_path, ignore_errors=True)
    table_metadata.create()
    assert (table_metadata_path / METADATA_FILES["table"]).exists()


def test_create_if_exists_raise(dataset_metadata, table_metadata):

    with pytest.raises(FileExistsError):
        dataset_metadata.create(if_exists="raise")

    with pytest.raises(FileExistsError):
        table_metadata.create(if_exists="raise")


def test_create_if_exists_replace(
    dataset_metadata, dataset_metadata_path, table_metadata, table_metadata_path
):
    dataset_metadata.create(if_exists="replace")
    assert (dataset_metadata_path / METADATA_FILES["dataset"]).exists()

    table_metadata.create(if_exists="replace")
    assert (table_metadata_path / METADATA_FILES["table"]).exists()


def test_create_if_exists_pass(
    dataset_metadata, dataset_metadata_path, table_metadata, table_metadata_path
):

    # make sure new file is created
    dataset_metadata.create(if_exists="replace")
    assert (dataset_metadata_path / METADATA_FILES["dataset"]).exists()

    # make sure no Exception is raised on `if_exists="pass"`
    dataset_metadata.create(if_exists="pass")

    # same procedure for `Table`
    table_metadata.create(if_exists="replace")
    assert (table_metadata_path / METADATA_FILES["table"]).exists()
    table_metadata.create(if_exists="pass")


def test_create_columns(table_metadata, table_metadata_path):
    shutil.rmtree(table_metadata_path, ignore_errors=True)
    table_metadata.create(columns=["column1", "column2"])
    assert (table_metadata_path / METADATA_FILES["table"]).exists()


@pytest.fixture
def existent_metadata(metadatadir):
    table_metadata_obj = Metadata(
        dataset_id="br_me_rais",
        table_id="microdados_vinculos",
        metadata_path=metadatadir,
    )
    return table_metadata_obj


@pytest.fixture
def existent_metadata_path(metadatadir):
    return Path(metadatadir) / "br_me_rais" / "microdados_vinculos"


def test_create_partition_columns_from_existent_table(
    existent_metadata: Metadata,
    existent_metadata_path: Path,
):
    shutil.rmtree(existent_metadata_path, ignore_errors=True)

    existent_metadata.create()
    assert existent_metadata_path.exists()

    metadata_dict = existent_metadata.local_metadata
    assert metadata_dict.get("partitions") == "ano, sigla_uf"


def test_create_partition_columns_from_user_input(
    existent_metadata: Metadata,
    existent_metadata_path: Path,
):
    shutil.rmtree(existent_metadata_path, ignore_errors=True)

    existent_metadata.create(partition_columns=["id_municipio"])
    assert existent_metadata_path.exists()

    metadata_dict = existent_metadata.local_metadata
    assert metadata_dict.get("partitions") == "id_municipio"


def test_create_force_columns_is_true(
    existent_metadata: Metadata,
    existent_metadata_path: Path,
):
    shutil.rmtree(existent_metadata_path, ignore_errors=True)
    existent_metadata.create(columns=["column1", "column2"], force_columns=True)
    assert (existent_metadata_path / METADATA_FILES["table"]).exists()

    table_metadata_dict = existent_metadata.local_metadata
    assert table_metadata_dict["columns"][0]["name"] == "column1"
    assert table_metadata_dict["columns"][1]["name"] == "column2"


def test_create_force_columns_is_false(
    existent_metadata: Metadata,
    existent_metadata_path: Path,
):
    shutil.rmtree(existent_metadata_path, ignore_errors=True)
    existent_metadata.create(columns=["column1", "column2"], force_columns=False)
    assert (existent_metadata_path / METADATA_FILES["table"]).exists()

    table_metadata_dict = existent_metadata.local_metadata
    assert table_metadata_dict["columns"][0]["name"] != "column1"
    assert table_metadata_dict["columns"][1]["name"] != "column2"


@pytest.fixture
def out_of_date_metadata_obj(metadatadir):
    out_of_date_metadata = Metadata(dataset_id="br_me_caged", metadata_path=metadatadir)
    out_of_date_metadata.create(if_exists="replace")

    out_of_date_config = out_of_date_metadata.local_metadata
    out_of_date_config["metadata_modified"] = "old_date"
    ryaml.dump(
        out_of_date_config, open(out_of_date_metadata.filepath, "w", encoding="utf-8")
    )

    return out_of_date_metadata


@pytest.fixture
def updated_metadata_obj(metadatadir):
    updated_metadata = Metadata(dataset_id="br_me_caged", metadata_path=metadatadir)
    updated_metadata.create(if_exists="replace")

    updated_config = updated_metadata.local_metadata
    updated_config["metadata_modified"] = updated_metadata.ckan_metadata[
        "metadata_modified"
    ]
    ryaml.dump(updated_config, open(updated_metadata.filepath, "w", encoding="utf-8"))

    return updated_metadata


def test_is_updated_is_true(updated_metadata_obj):
    assert updated_metadata_obj.is_updated() == True


def test_is_updated_is_false(out_of_date_metadata_obj):
    assert out_of_date_metadata_obj.is_updated() == False


@pytest.fixture
def valid_metadata_dataset(metadatadir):
    dataset_metadata = Metadata(dataset_id="br_ibge_pib", metadata_path=metadatadir)
    dataset_metadata.create(if_exists="replace")
    dataset_metadata.CKAN_API_KEY = "valid-key"
    return dataset_metadata


@pytest.fixture
def valid_metadata_table(metadatadir):
    table_metadata = Metadata(
        dataset_id="br_ibge_pib",
        table_id="municipio",
        metadata_path=metadatadir,
    )
    table_metadata.create(if_exists="replace")
    dataset_metadata.CKAN_API_KEY = "valid-key"
    return table_metadata


def test_validate_is_succesful(
    valid_metadata_dataset: Metadata, valid_metadata_table: Metadata
):
    assert valid_metadata_dataset.validate() == True
    assert valid_metadata_table.validate() == True


@pytest.fixture
def invalid_dataset_metadata(metadatadir):
    invalid_dataset_metadata = Metadata(
        dataset_id="br_ibge_pib",
        metadata_path=metadatadir,
    )
    invalid_dataset_metadata.create(if_exists="replace")

    invalid_config = invalid_dataset_metadata.local_metadata
    invalid_config["metadata_modified"] = "not_a_valid_date"

    print(invalid_dataset_metadata.filepath)

    with open(invalid_dataset_metadata.filepath, "w", encoding="utf-8") as file:
        ryaml.dump(invalid_config, file)

    return invalid_dataset_metadata


@pytest.fixture
def invalid_table_metadata(metadatadir):
    invalid_dataset_metadata = Metadata(
        dataset_id="br_ibge_pib",
        table_id="municipio",
        metadata_path=metadatadir,
    )
    invalid_dataset_metadata.create(if_exists="replace")

    invalid_config = invalid_dataset_metadata.local_metadata
    invalid_config["table_id"] = None

    with open(invalid_dataset_metadata.filepath, "w", encoding="utf-8") as file:
        ryaml.dump(invalid_config, file)

    return invalid_dataset_metadata


def test_validate_is_not_succesful(
    invalid_dataset_metadata: Metadata,
    invalid_table_metadata: Metadata,
):
    with pytest.raises(BaseDosDadosException):
        invalid_table_metadata.validate()

    # TODO: Change fields modified by this tool
    # or else there is no way that this can be tested
    # with pytest.raises(BaseDosDadosException):
    #     invalid_dataset_metadata.validate()


# TODO: Mock ckan server to activate this test
@pytest.mark.skip(reason="This test requires a mocked CKAN server.")
def test_publish_is_successful(
    valid_metadata_dataset: Metadata,
    valid_metadata_table: Metadata,
):
    assert isinstance(valid_metadata_dataset.publish(), dict)
    assert isinstance(valid_metadata_table.publish(), dict)


def test_publish_is_not_successful(invalid_dataset_metadata, invalid_table_metadata):
    with pytest.raises(AssertionError, match="Could not publish"):
        invalid_dataset_metadata.publish()

    with pytest.raises(BaseDosDadosException, match="Could not publish"):
        invalid_table_metadata.publish()
