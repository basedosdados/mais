import shutil
from pathlib import Path

import pytest
import ruamel.yaml as ryaml

from basedosdados import Metadata
from basedosdados.exceptions import BaseDosDadosException

###########################################################
# Fixtures
###########################################################


@pytest.fixture
def metadatadir():
    directory = Path(__file__).parent / "tmp_data"
    directory.mkdir(exist_ok=True)
    return directory


@pytest.fixture
def toy_dataset(metadatadir: Path):
    return Metadata(dataset_id="pytest", metadata_path=metadatadir)


@pytest.fixture
def toy_table(metadatadir: Path):
    return Metadata(dataset_id="pytest", table_id="pytest", metadata_path=metadatadir)


@pytest.fixture
def real_table(metadatadir: Path):
    return Metadata(
        dataset_id="br_me_rais",
        table_id="microdados_vinculos",
        metadata_path=metadatadir,
    )


@pytest.fixture
def valid_dataset(metadatadir: Path):
    dataset = Metadata(
        dataset_id="br_ibge_pib",
        metadata_path=metadatadir,
    )
    dataset.create(if_exists="replace")
    return dataset


@pytest.fixture
def valid_table(metadatadir: Path):
    table = Metadata(
        dataset_id="br_ibge_pib",
        table_id="municipio",
        metadata_path=metadatadir,
    )
    table.create(if_exists="replace")
    return table


@pytest.fixture
def invalid_dataset(metadatadir: Path):
    dataset = Metadata(
        dataset_id="br_ibge_pib",
        metadata_path=metadatadir,
    )
    dataset.create(if_exists="replace")

    config = dataset.local_metadata
    config["metadata_modified"] = "not_a_valid_date"

    with open(dataset.dataset_path, "w", encoding="utf-8") as file:
        yaml = ryaml.YAML(typ="unsafe", pure=True)
        yaml.dump(config, file)

    return dataset


@pytest.fixture
def invalid_table(metadatadir):
    table = Metadata(
        dataset_id="br_ibge_pib",
        table_id="municipio",
        metadata_path=metadatadir,
    )
    table.create(if_exists="replace")

    config = table.local_metadata
    config["metadata_modified"] = "not_a_valid_date"

    with open(table.table_path, "w", encoding="utf-8") as file:
        yaml = ryaml.YAML(typ="unsafe", pure=True)
        yaml.dump(config, file)

    return table


###########################################################
# Hooks
###########################################################


@pytest.fixture(autouse=True)
def clean_tmp_data(metadatadir: Path):
    shutil.rmtree(metadatadir, ignore_errors=True)
    yield


###########################################################
# Tests
###########################################################


def test_create_from_dataset_id(toy_dataset: Metadata):
    toy_dataset.create()
    assert toy_dataset.dataset_path.exists()


def test_create_from_dataset_and_table_id(toy_table: Metadata):
    toy_table.create()
    assert toy_table.table_path.exists()
    assert toy_table.dataset_path.exists()


def test_create_raise_if_dataset_exists(toy_dataset: Metadata):
    toy_dataset.create()
    with pytest.raises(FileExistsError):
        toy_dataset.create(if_exists="raise")


def test_create_raise_if_table_exists(toy_table: Metadata):
    toy_table.create()
    with pytest.raises(FileExistsError):
        toy_table.create(if_exists="raise")


def test_replace_dataset_if_exists(toy_dataset: Metadata):
    toy_dataset.create()
    toy_dataset.create(if_exists="replace")
    assert toy_dataset.dataset_path.exists()


def test_replace_table_is_exists(toy_table: Metadata):
    toy_table.create()
    toy_table.create(if_exists="replace")
    assert toy_table.table_path.exists()
    assert toy_table.dataset_path.exists()


def test_create_pass_dataset_if_exists(toy_dataset: Metadata):
    # make sure new file is created
    toy_dataset.create(if_exists="replace")
    assert toy_dataset.dataset_path.exists()

    # make sure no Exception is raised on `if_exists="pass"`
    toy_dataset.create(if_exists="pass")


def test_create_pass_table_if_exists(toy_table: Metadata):
    # make sure a new file is created
    toy_table.create(if_exists="replace")
    assert toy_table.table_path.exists()

    # make sure that no exception is raised
    toy_table.create(if_exists="pass")


def test_create_columns(toy_table: Metadata):
    toy_table.create(columns=["column1", "column2"])
    assert toy_table.table_path.exists()


def test_create_partition_columns_from_existent_table(real_table: Metadata):
    real_table.create()
    assert real_table.table_path.exists()
    assert real_table.dataset_path.exists()

    table_ = real_table.local_metadata["resources"][0]
    assert table_.get("partitions") == "ano, sigla_uf"


def test_create_partition_columns_from_user_input(real_table: Metadata):
    real_table.create(partition_columns=["id_municipio"])
    assert real_table.table_path.exists()

    table_ = real_table.local_metadata["resources"][0]
    assert table_.get("partitions") == "id_municipio"


def test_create_force_columns_is_true(real_table: Metadata):
    real_table.create(columns=["column1", "column2"], force_columns=True)
    assert real_table.table_path.exists()

    table_ = real_table.local_metadata["resources"][0]
    assert table_["columns"][0]["name"] == "column1"
    assert table_["columns"][1]["name"] == "column2"


def test_create_force_columns_is_false(real_table: Metadata):
    real_table.create(columns=["column1", "column2"], force_columns=False)
    assert real_table.table_path.exists()

    table_ = real_table.local_metadata["resources"][0]
    assert table_["columns"][0]["name"] != "column1"
    assert table_["columns"][1]["name"] != "column2"


def test_validate_is_succesful(
    valid_dataset: Metadata,
    valid_table: Metadata,
):
    # assert valid_dataset.validate()
    from pprint import pprint

    pprint(valid_table.updated_metadata)
    assert valid_table.validate()


def test_validate_is_not_succesful(
    invalid_dataset: Metadata,
    invalid_table: Metadata,
):
    with pytest.raises(BaseDosDadosException):
        invalid_table.validate()

    # TODO: Change fields modified by this tool
    # or else there is no way that this can be tested
    # with pytest.raises(BaseDosDadosException):
    #     invalid_dataset.validate()


@pytest.mark.skip(reason="This test requires a mocked CKAN server.")
def test_publish_is_successful(valid_dataset: Metadata, valid_table: Metadata):
    assert isinstance(valid_dataset.publish(), dict)
    assert isinstance(valid_table.publish(), dict)


@pytest.mark.skip(reason="This test requires a mocked CKAN server.")
def test_publish_is_not_successful(invalid_dataset: Metadata, invalid_table: Metadata):
    with pytest.raises(AssertionError, match="Could not publish"):
        invalid_dataset.publish()

    with pytest.raises(BaseDosDadosException, match="Could not publish"):
        invalid_table.publish()
