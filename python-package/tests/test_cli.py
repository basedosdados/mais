"""
Tests for the CLI module.
"""
import os
import subprocess

# pylint: disable=consider-using-with
from pathlib import Path

import pytest
from google.api_core.exceptions import NotFound

import basedosdados as bd

DATASET_ID = "pytest"
TABLE_ID = "pytest"

TABLE_FILES = ["publish.sql", "table_config.yaml"]

METADATA_FILES = {"dataset": "dataset_config.yaml", "table": "table_config.yaml"}

cli_dir = Path(__file__).parent / ".." / "basedosdados" / "cli"


def _run_command(command, output="err"):
    """
    Run a command and return the output | error
    """

    current_dir = os.getcwd()

    os.chdir(cli_dir)
    proc = subprocess.Popen(
        [command],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
    )

    out, err = proc.communicate()

    os.chdir(current_dir)

    if output == "err":
        return err
    if output == "out":
        return out

    raise ValueError("output must be either err or out")


def _table_exists(table: bd.Table, mode: str):
    """
    Check if table exists in BigQuery
    """

    try:
        table.client[f"bigquery_{mode}"].get_table(table.table_full_name[mode])
        return True
    except NotFound:
        return False


def test_cli_dataset_create(python_path):
    """
    Test create dataset command
    """
    out = _run_command(
        f"{python_path} -m cli dataset create {DATASET_ID} --if_exists=replace",
        output="out",
    )

    assert b"Datasets `pytest` and `pytest_staging` were created in BigQuery" in out


def test_cli_dataset_publicize(python_path):
    """
    Test publicize dataset command
    """

    out = _run_command(
        f"{python_path} -m cli dataset publicize {DATASET_ID}", output="out"
    )

    assert b"Dataset `pytest` became public!" in out


def test_cli_dataset_delete(python_path):
    """
    Test delete dataset command
    """

    out = _run_command(
        f"yes | {python_path} -m cli dataset delete {DATASET_ID}", output="out"
    )

    assert b"Datasets `pytest` and `pytest_staging` were deleted in BigQuery" in out


def test_cli_dataset_init(python_path):
    """
    Test init dataset command
    """

    out = _run_command(
        f"{python_path} -m cli dataset init {DATASET_ID} --replace", output="out"
    )

    assert b"Dataset `pytest` folder and metadata were created at" in out


@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_dataset_update(python_path):
    """
    Test update dataset command
    """

    out = _run_command(
        f"{python_path} -m cli dataset update {DATASET_ID}", output="out"
    )

    assert b"Dataset `pytest` was updated in BigQuery" in out


def test_cli_download(testdir, python_path):
    """
    Test download command
    """

    _ = _run_command(
        f"""{python_path} -m cli download {testdir /  "data.csv"}  --query="select * from basedosdados.br_ibge_pib.municipio limit 10" --billing_project_id=basedosdados-dev""",
        output="out",
    )

    assert os.path.isfile(testdir / "data.csv")


@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_get_data_description(python_path):
    """
    Teste get data description command
    """

    err = _run_command(
        f"{python_path} -m cli get_data_description br_me_rais", output="err"
    )

    assert b"Description" in err


@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_get_table_columns(python_path):
    """
    Teste get table columns command
    """

    err = _run_command(
        f"{python_path} -m cli get_table_columns br_me_rais microdados", output="err"
    )

    assert b"Columns" in err


@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_get_table_description(python_path):
    """
    Teste get table description command
    """

    err = _run_command(
        f"{python_path} -m cli get_table_description br_me_rais microdados",
        output="err",
    )

    assert b"Description" in err


@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_list_dataset_tables(python_path):
    """
    Teste list dataset tables command
    """

    err = _run_command(
        f"{python_path} -m cli list_dataset_tables br_me_rais", output="err"
    )

    assert b"Tables" in err


@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_list_datasets(python_path):
    """
    Teste list datasets command
    """

    err = _run_command(f"{python_path} -m cli list_datasets", output="err")

    assert b"Datasets" in err


def test_cli_metadata_create(default_metadata_path, python_path):
    """
    Teste metadata create command
    """

    _ = _run_command(
        f"{python_path} -m cli metadata create --if_exists=replace {DATASET_ID} {TABLE_ID}",
        output="out",
    )

    assert (default_metadata_path / DATASET_ID / METADATA_FILES["dataset"]).exists()
    assert (
        default_metadata_path / DATASET_ID / TABLE_ID / METADATA_FILES["table"]
    ).exists()


def test_cli_metadata_isupdated(python_path):
    """
    Teste metadata isupdated command
    """

    out = _run_command(
        f"{python_path} -m cli metadata is_updated {DATASET_ID}", output="out"
    )

    assert b"Local metadata is updated." in out


@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_storage_upload(testdir, python_path):
    """
    Teste storage upload command
    """

    _ = _run_command(
        f"{python_path} -m cli storage upload {testdir / 'data.csv'} {DATASET_ID}.{TABLE_ID}",
        output="out",
    )

    assert os.path.isfile(testdir / "data.csv")


@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_storage_download(testdir, python_path):
    """
    Teste storage download command
    """

    _ = _run_command(
        f"{python_path} -m cli storage download {testdir / 'data.csv'} {DATASET_ID}.{TABLE_ID}",
        output="out",
    )

    assert os.path.isfile(testdir / "data.csv")


def test_cli_table_create(python_path, data_csv_path):
    """
    Teste table create command
    """

    _ = _run_command(
        f"""{python_path} -m cli table create --if_table_exists=replace \
         --if_table_config_exists=replace --if_storage_data_exists=replace \
            --path={data_csv_path}  pytest pytest
            """,
        output="out",
    )

    table = bd.Table(DATASET_ID, TABLE_ID)

    assert _table_exists(table, mode="staging")


def test_cli_table_delete(python_path):
    """
    Teste table delete command
    """

    _ = _run_command(
        f"{python_path} -m cli table delete --mode=staging {DATASET_ID} {TABLE_ID}",
        output="out",
    )

    table = bd.Table(DATASET_ID, TABLE_ID)

    assert not _table_exists(table, mode="staging")


def test_cli_create_no_path_error(testdir, python_path):
    """
    Teste if error is raised when no path is provided
    """

    err = _run_command(
        f"{python_path} -m cli --metadata_path={testdir} table create --if_table_exists=pass {DATASET_ID} {TABLE_ID}",
        output="err",
    )

    assert b"You must provide a path to correctly create config files" in err
