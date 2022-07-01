"""
Tests for the CLI module.
"""

from pathlib import Path
import shutil
import os

from click.core import Context

from basedosdados.cli.cli import cli_table
from importlib_metadata import metadata
from more_itertools import bucket

import pytest
import click.testing
from basedosdados import Storage, Dataset, Table
import basedosdados as bd
from basedosdados.exceptions import BaseDosDadosException
from google.api_core.exceptions import NotFound
import subprocess


DATASET_ID = "pytest"
TABLE_ID = "pytest"

TABLE_FILES = ["publish.sql", "table_config.yaml"]

cli_dir = Path(__file__).parent / ".." / "basedosdados" / "cli"

def _run_command(command, output="err"):
    """
    Run a command and return the output
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


def table_exists(table, mode):
    """
    Test if table exists in BigQuery
    """

    try:
        table.client[f"bigquery_{mode}"].get_table(table.table_full_name[mode])
        return True
    except NotFound:
        return False

def test_cli_dataset_create():
    """
    Test create dataset command
    """

    out = _run_command(f"python3 -m cli dataset create {DATASET_ID} --if_exists=replace", output="out")

    assert b"Datasets `pytest` and `pytest_staging` were created in BigQuery" in out

def test_cli_dataset_publicize():
    """
    Test publicize dataset command
    """

    out = _run_command(f"python3 -m cli dataset publicize {DATASET_ID}", output="out")

    assert b"Dataset `pytest` became public!" in out

def test_cli_dataset_delete():
    """
    Test delete dataset command
    """

    out = _run_command(f"yes | python3 -m cli dataset delete {DATASET_ID}", output="out")

    assert b"Datasets `pytest` and `pytest_staging` were deleted in BigQuery" in out

def test_cli_dataset_init():
    """
    Test init dataset command
    """

    out = _run_command(f"python3 -m cli dataset init {DATASET_ID} --replace", output="out")

    assert b"Dataset `pytest` folder and metadata were created at" in out

@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_dataset_update():
    """
    Test update dataset command
    """

    out = _run_command(f"python3 -m cli dataset update {DATASET_ID}", output="out")

    assert b"Dataset `pytest` was updated in BigQuery" in out

def test_cli_download(testdir):
    """
    Test download command
    """

    _ = _run_command(f'''python3 -m cli download {testdir /  "data.csv"}  --query="select * from basedosdados.br_ibge_pib.municipio limit 10" --billing_project_id=basedosdados-dev''', output="out")

    assert os.path.isfile(testdir / "data.csv")


@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_get_data_description(testdir):
    """
    Teste if error is raised when no path is provided
    """

    err = _run_command(f"python3 -m cli get_data_description br_me_rais", output="err")

    assert b"Description" in err

@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_get_table_columns(testdir):
    """
    Teste if error is raised when no path is provided
    """

    err = _run_command(f"python3 -m cli get_table_columns br_me_rais microdados", output="err")

    assert b"Columns" in err


@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_get_table_description(testdir):
    """
    Teste if error is raised when no path is provided
    """

    err = _run_command(f"python3 -m cli get_table_description br_me_rais microdados", output="err")

    assert b"Description" in err

@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_list_dataset_tables():
    """
    Teste if error is raised when no path is provided
    """

    err = _run_command(f"python3 -m cli list_dataset_tables br_me_rais", output="err")

    assert b"Tables" in err

@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_list_datasets():
    """
    Teste if error is raised when no path is provided
    """

    err = _run_command(f"python3 -m cli list_datasets", output="err")

    assert b"Datasets" in err

def test_cli_metadata_create():
    """
    Teste if error is raised when no path is provided
    """

    _ = _run_command(f"python3 -m cli metadata create --if_exists=replace {DATASET_ID} {TABLE_ID}", output="out")

    assert os.path.isfile(testdir / "data.csv")



def test_cli_create_no_path_error(testdir):
    """
    Teste if error is raised when no path is provided
    """

    err = _run_command(f"python3 -m cli --metadata_path={testdir} table create --if_table_exists=pass {DATASET_ID} {TABLE_ID}", output="err")

    assert b"You must provide a path to correctly create config files" in err

