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

from basedosdados import Metadata # TODO: deprecate
from basedosdados.exceptions import BaseDosDadosException

METADATA_FILES = {"dataset": "dataset_config.yaml", "table": "table_config.yaml"}


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
