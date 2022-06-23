"""
Test for the Metadata class
"""
# pylint: disable=fixme
from pathlib import Path
import random
import shutil
import string

import pytest
import ruamel.yaml as ryaml

from basedosdados import Metadata
from basedosdados.exceptions import BaseDosDadosException


DATASET_ID = "pytest"
TABLE_ID = "pytest"

METADATA_FILES = {"dataset": "dataset_config.yaml", "table": "table_config.yaml"}


@pytest.fixture(name="metadatadir")
def fixture_metadatadir():
    """
    Fixture that returns a temporary directory for the metadata files.
    """
    (Path(__file__).parent / "tmp_bases").mkdir(exist_ok=True)
    return Path(__file__).parent / "tmp_bases"


@pytest.fixture(name="dataset_metadata")
def fixture_dataset_metadata(metadatadir):
    """
    Fixture that returns a `Metadata` object for the dataset.
    """
    return Metadata(dataset_id=DATASET_ID, metadata_path=metadatadir)


@pytest.fixture(name="table_metadata")
def fixture_table_metadata(metadatadir):
    """
    Fixture that returns a `Metadata` object for the table.
    """
    return Metadata(dataset_id=DATASET_ID, table_id=TABLE_ID, metadata_path=metadatadir)


@pytest.fixture(name="dataset_metadata_path")
def fixture_dataset_metadata_path(metadatadir):
    """
    Fixture that returns the path to the dataset metadata file.
    """
    return Path(metadatadir) / DATASET_ID


@pytest.fixture(name="table_metadata_path")
def fixture_table_metadata_path(metadatadir):
    """
    Fixture that returns the path to the table metadata file.
    """
    return Path(metadatadir) / DATASET_ID / TABLE_ID


@pytest.fixture(name="invalid_dataset_metadata")
def fixture_invalid_dataset_metadata(metadatadir):
    """
    Fixture that returns invalid dataset metadata.
    """
    invalid_dataset_metadata = Metadata(
        dataset_id="br_ibge_pib",
        metadata_path=metadatadir,
    )
    invalid_dataset_metadata.create(if_exists="replace")

    invalid_config = invalid_dataset_metadata.local_metadata
    invalid_config["title"] = {"this_title": "is_not_valid"}

    print(invalid_dataset_metadata.filepath)

    with open(invalid_dataset_metadata.filepath, "w", encoding="utf-8") as file:
        ryaml.dump(invalid_config, file)

    return invalid_dataset_metadata


@pytest.fixture(name="invalid_table_metadata")
def fixture_invalid_table_metadata(metadatadir):
    """
    Fixture that returns invalid table metadata.
    """
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


@pytest.fixture(name="valid_metadata_dataset")
def fixture_valid_metadata_dataset(metadatadir):
    """
    Fixture that returns a valid dataset metadata.
    """
    dataset_metadata = Metadata(dataset_id="br_ibge_pib", metadata_path=metadatadir)
    dataset_metadata.create(if_exists="replace")
    dataset_metadata.CKAN_API_KEY = "valid-key"
    return dataset_metadata


@pytest.fixture(name="valid_metadata_table")
def fixture_valid_metadata_table(metadatadir, dataset_metadata):
    """
    Fixture that returns a valid table metadata.
    """
    table_metadata = Metadata(
        dataset_id="br_ibge_pib",
        table_id="municipio",
        metadata_path=metadatadir,
    )
    table_metadata.create(if_exists="replace")
    dataset_metadata.CKAN_API_KEY = "valid-key"
    return table_metadata


@pytest.fixture(name="existent_metadata")
def fixture_existent_metadata(metadatadir):
    """
    Fixture that returns an existent metadata.
    """
    table_metadata_obj = Metadata(
        dataset_id="br_me_rais",
        table_id="microdados_vinculos",
        metadata_path=metadatadir,
    )
    return table_metadata_obj


@pytest.fixture(name="existent_metadata_path")
def fixture_existent_metadata_path(metadatadir):
    """
    Fixture that returns the path to the existent metadata file.
    """
    return Path(metadatadir) / "br_me_rais" / "microdados_vinculos"


@pytest.fixture(name="out_of_date_metadata_obj")
def fixture_out_of_date_metadata_obj(metadatadir):
    """
    Fixture that returns an output of date metadata.
    """
    out_of_date_metadata = Metadata(dataset_id="br_me_caged", metadata_path=metadatadir)
    out_of_date_metadata.create(if_exists="replace")

    out_of_date_config = out_of_date_metadata.local_metadata
    out_of_date_config["metadata_modified"] = "old_date"
    with open(out_of_date_metadata.filepath, "w", encoding="utf-8") as file:
        ryaml.dump(out_of_date_config, file)

    return out_of_date_metadata


@pytest.fixture(name="updated_metadata_obj")
def fixture_updated_metadata_obj(metadatadir):
    """
    Fixture that returns an updated metadata.
    """
    updated_metadata = Metadata(dataset_id="br_me_caged", metadata_path=metadatadir)
    updated_metadata.create(if_exists="replace")

    updated_config = updated_metadata.local_metadata
    updated_config["metadata_modified"] = updated_metadata.ckan_metadata[
        "metadata_modified"
    ]
    with open(updated_metadata.filepath, "w", encoding="utf-8") as file:
        ryaml.dump(updated_config, file)

    return updated_metadata


@pytest.fixture(name="pytest_dataset")
def fixture_pytest_dataset(metadatadir):
    """
    Fixture that returns a test dataset metadata.
    """
    shutil.rmtree(metadatadir, ignore_errors=True)
    pytest_dataset = Metadata(dataset_id="pytest", metadata_path=metadatadir)
    pytest_dataset.create(if_exists="replace")

    # fill dataset metadata for it to be publishable
    pytest_dataset_metadata = pytest_dataset.local_metadata
    pytest_dataset_metadata["organization"] = "acaps"  # set valid organization

    # materialize metadata file
    with open(pytest_dataset.filepath, "w", encoding="utf-8") as file:
        ryaml.dump(pytest_dataset_metadata, file)

    return pytest_dataset


@pytest.fixture(name="pytest_table")
def fixture_pytest_table(metadatadir):
    """
    Fixture that returns a test table metadata.
    """
    shutil.rmtree(metadatadir, ignore_errors=True)
    pytest_table = Metadata(dataset_id="pytest", table_id="pytest")
    pytest_table.create(if_exists="replace")
    return pytest_table


@pytest.fixture(name="invalid_organization_dataset")
def fixture_invalid_organization_dataset(metadatadir):
    """
    Fixture that returns an invalid organization dataset metadata.
    """
    invalid_organization_dataset = Metadata(
        dataset_id="br_ibge_pib",
        metadata_path=metadatadir,
    )
    invalid_organization_dataset.create(if_exists="replace")

    invalid_config = invalid_organization_dataset.local_metadata
    invalid_config["organization"] = "not-a-valid-organization"

    with open(invalid_organization_dataset.filepath, "w", encoding="utf-8") as file:
        ryaml.dump(invalid_config, file)

    return invalid_organization_dataset


def test_create_from_dataset_id(dataset_metadata, dataset_metadata_path):
    """
    Test metadata creation from a dataset id.
    """
    shutil.rmtree(dataset_metadata_path, ignore_errors=True)
    dataset_metadata.create()
    assert (dataset_metadata_path / METADATA_FILES["dataset"]).exists()


def test_create_from_dataset_and_table_id(table_metadata, table_metadata_path):
    """
    Test metadata creation from a dataset and table id.
    """
    shutil.rmtree(table_metadata_path, ignore_errors=True)
    table_metadata.create()
    assert (table_metadata_path / METADATA_FILES["table"]).exists()


def test_create_if_exists_raise(dataset_metadata, table_metadata):
    """
    Test error thrown when creating a metadata with if_exists=raise.
    """

    with pytest.raises(FileExistsError):
        dataset_metadata.create(if_exists="raise")

    with pytest.raises(FileExistsError):
        table_metadata.create(if_exists="raise")


def test_create_if_exists_replace(
    dataset_metadata, dataset_metadata_path, table_metadata, table_metadata_path
):
    """
    Test metadata creation if the metadata already exists.
    """
    dataset_metadata.create(if_exists="replace")
    assert (dataset_metadata_path / METADATA_FILES["dataset"]).exists()

    table_metadata.create(if_exists="replace")
    assert (table_metadata_path / METADATA_FILES["table"]).exists()


def test_create_if_exists_pass(
    dataset_metadata, dataset_metadata_path, table_metadata, table_metadata_path
):
    """
    Test metadata creation if the metadata already exists.
    """
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
    """
    Test if columns are added into metadata when they are created.
    """
    shutil.rmtree(table_metadata_path, ignore_errors=True)
    table_metadata.create(columns=["column1", "column2"])
    assert (table_metadata_path / METADATA_FILES["table"]).exists()


def test_create_partition_columns_from_existent_table(
    existent_metadata: Metadata,
    existent_metadata_path: Path,
):
    """
    Test if partition columns are added into metadata when they are created from an existent table.
    """
    shutil.rmtree(existent_metadata_path, ignore_errors=True)

    existent_metadata.create()
    assert existent_metadata_path.exists()

    metadata_dict = existent_metadata.local_metadata
    assert metadata_dict.get("partitions") == ["ano", "sigla_uf"]


def test_create_partition_columns_from_user_input(
    existent_metadata: Metadata,
    existent_metadata_path: Path,
):
    """
    Test if partition columns are added into metadata when they are created from user input.
    """
    shutil.rmtree(existent_metadata_path, ignore_errors=True)

    existent_metadata.create(partition_columns=["id_municipio"])
    assert existent_metadata_path.exists()

    metadata_dict = existent_metadata.local_metadata
    assert metadata_dict.get("partitions") == ["id_municipio"]


def test_create_force_columns_is_true(
    existent_metadata: Metadata,
    existent_metadata_path: Path,
):
    """
    Test if columns are added into metadata when they are created and force_columns is True.
    """
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
    """
    Test if columns are added into metadata when they are created and force_columns is False.
    """
    shutil.rmtree(existent_metadata_path, ignore_errors=True)
    existent_metadata.create(columns=["column1", "column2"], force_columns=False)
    assert (existent_metadata_path / METADATA_FILES["table"]).exists()

    table_metadata_dict = existent_metadata.local_metadata
    assert table_metadata_dict["columns"][0]["name"] != "column1"
    assert table_metadata_dict["columns"][1]["name"] != "column2"


def test_create_table_only_is_true(
    table_metadata, dataset_metadata_path, table_metadata_path
):
    """
    Test if table metadata is created only when table_only is True.
    """
    shutil.rmtree(dataset_metadata_path, ignore_errors=True)
    shutil.rmtree(table_metadata_path, ignore_errors=True)

    table_metadata.create(table_only=True)
    assert (table_metadata_path / METADATA_FILES["table"]).exists()
    assert not (dataset_metadata_path / METADATA_FILES["dataset"]).exists()


def test_create_table_only_is_false(
    table_metadata, dataset_metadata_path, table_metadata_path
):
    """
    Test if dataset metadata is created only when table_only is False.
    """
    shutil.rmtree(dataset_metadata_path, ignore_errors=True)
    shutil.rmtree(table_metadata_path, ignore_errors=True)

    table_metadata.create(table_only=False)
    assert (table_metadata_path / METADATA_FILES["table"]).exists()
    assert (dataset_metadata_path / METADATA_FILES["dataset"]).exists()


def test_is_updated_is_true(updated_metadata_obj):
    """
    Test if is_updated is True when the metadata is updated.
    """
    assert updated_metadata_obj.is_updated()


def test_is_updated_is_false(out_of_date_metadata_obj):
    """
    Test if is_updated is False when the metadata is not updated.
    """
    assert not out_of_date_metadata_obj.is_updated()


def test_validate_is_succesful(
    valid_metadata_dataset: Metadata, valid_metadata_table: Metadata
):
    """
    Test if validate is successful when the metadata is valid.
    """
    assert valid_metadata_dataset.validate()
    assert valid_metadata_table.validate()


def test_validate_is_not_succesful(
    invalid_dataset_metadata: Metadata,
    invalid_table_metadata: Metadata,
):
    """
    Test if error is thrown when the metadata is invalid.
    """
    with pytest.raises(BaseDosDadosException):
        invalid_table_metadata.validate()

    with pytest.raises(BaseDosDadosException):
        invalid_dataset_metadata.validate()


def test_validate_organization_not_found(invalid_organization_dataset):
    """
    Test if error is thrown when the organization is not found.
    """
    with pytest.raises(BaseDosDadosException, match="Organization not found"):
        invalid_organization_dataset.validate()


# TODO: Mock ckan server to activate publish tests
@pytest.mark.skip(
    reason="This test requires a mocked CKAN server and a test dataset/table."
)
def test_publish_is_successful(
    valid_metadata_dataset: Metadata,
    valid_metadata_table: Metadata,
):
    """
    Test if publish is successful when the metadata is valid.
    """
    assert isinstance(valid_metadata_dataset.publish(), dict)
    assert isinstance(valid_metadata_table.publish(), dict)


@pytest.mark.skip(reason="This test requires a mocked CKAN server.")
def test_publish_is_not_successful(
    invalid_dataset_metadata: Metadata,
    invalid_table_metadata: Metadata,
):
    """
    Test if error 'Could bot publish' is thrown when the metadata is invalid.
    """
    with pytest.raises(AssertionError, match="Could not publish"):
        invalid_dataset_metadata.publish()

    with pytest.raises(BaseDosDadosException, match="Could not publish"):
        invalid_table_metadata.publish()


@pytest.mark.skip(
    reason="This test requires a mocked CKAN server and a delete endpoint."
)
def test_publish_all_is_true(
    pytest_dataset: Metadata,
    pytest_table: Metadata,
):
    """
    Test publish method when all is True.
    """
    res = pytest_table.publish(all=True)
    assert isinstance(res, dict)
    assert res != {}
    assert pytest_dataset.exists_in_ckan()


@pytest.mark.skip(reason="This test requires a mocked CKAN server.")
def test_publish_if_exists_raise(valid_metadata_dataset: Metadata):
    """
    Test if error is thrown when the dataset exists in CKAN.
    """
    with pytest.raises(BaseDosDadosException, match="already exists in CKAN"):
        valid_metadata_dataset.publish(if_exists="raise")


@pytest.mark.skip(reason="This test requires a mocked CKAN server and a test dataset.")
def test_publish_if_exists_replace(valid_metadata_dataset: Metadata):
    """
    Test if dataset is published when the dataset exists in CKAN and if_exists is replace.
    """
    res = valid_metadata_dataset.publish(if_exists="replace")
    assert isinstance(res, dict)
    assert res != {}


@pytest.mark.skip(reason="This test requires a mocked CKAN server.")
def test_publish_if_exists_pass(valid_metadata_dataset: Metadata):
    """
    Test if dataset is published when the dataset exists in CKAN and if_exists is pass.
    """
    assert isinstance(valid_metadata_dataset.publish(if_exists="pass"), dict)
    assert valid_metadata_dataset.publish(if_exists="pass") == {}


@pytest.mark.skip(reason="This test requires a mocked CKAN server.")
def test_publish_update_locally_is_true(pytest_dataset: Metadata):
    """
    Test if dataset is published when update_locally is True.
    """
    date_before = pytest_dataset.local_metadata.get("metadata_modified")

    # update local metadata
    new_metadata = pytest_dataset.local_metadata.copy()

    # generate random strings with 3 characters
    random_string = "".join(random.choice(string.ascii_uppercase) for _ in range(3))

    # update metadata tags with random_string
    new_metadata["tags"] = [random_string]
    with open(new_metadata.filepath, "w", encoding="utf-8") as file:
        ryaml.dump(new_metadata, file)

    # publish changes
    pytest_dataset.publish(update_locally=True)

    # get new tags from local metadata
    new_tags = pytest_dataset.local_metadata.get("tags")

    # get new `metadata_modified` value from local config file
    date_after = pytest_dataset.local_metadata.get("metadata_modified")

    assert new_tags == [random_string], "Tags were not updated locally"
    assert date_after > date_before, "Date after should be greater than date before"
