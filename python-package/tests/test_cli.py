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

    current_dir = os.getcwd()

    os.chdir(cli_dir)
    proc = subprocess.Popen(
        [
            f"python3 -m cli dataset create {DATASET_ID} --if_exists=replace"
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
    )

    out, _ = proc.communicate()

    os.chdir(current_dir)

    assert b"Datasets `pytest` and `pytest_staging` were created in BigQuery" in out

def test_cli_dataset_delete():
    """
    Test delete dataset command
    """

    current_dir = os.getcwd()

    os.chdir(cli_dir)
    proc = subprocess.Popen(
        [
            f" yes | python3 -m cli dataset delete {DATASET_ID}"
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
    )

    out, _ = proc.communicate()

    os.chdir(current_dir)

    assert b"Datasets `pytest` and `pytest_staging` were deleted in BigQuery" in out

def test_cli_dataset_init(testdir):
    """
    Test init dataset command
    """

    current_dir = os.getcwd()

    shutil.rmtree(testdir / DATASET_ID / TABLE_ID, ignore_errors=True)
    os.chdir(cli_dir)
    proc = subprocess.Popen(
        [
            f"python3 -m cli dataset init {DATASET_ID} --replace"
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
    )

    out, _ = proc.communicate()

    os.chdir(current_dir)

    assert b"Dataset `pytest` folder and metadata were created at" in out

def test_cli_dataset_publicize(testdir):
    """
    Test publicize dataset command
    """

    current_dir = os.getcwd()

    shutil.rmtree(testdir / DATASET_ID / TABLE_ID, ignore_errors=True)
    os.chdir(cli_dir)
    os.system(f"python3 -m cli dataset create {DATASET_ID} --replace")
    proc = subprocess.Popen(
        [
            f"python3 -m cli dataset publicize {DATASET_ID}"
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
    )

    out, _ = proc.communicate()

    os.chdir(current_dir)

    assert b"Dataset `pytest` became public!" in out


@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_dataset_update():
    """
    Test update dataset command
    """

    current_dir = os.getcwd()

    os.chdir(cli_dir)
    proc = subprocess.Popen(
        [
            f"python3 -m cli dataset update {DATASET_ID}"
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
    )

    out, _ = proc.communicate()

    os.chdir(current_dir)

    assert b"Dataset `pytest` was updated in BigQuery" in out

def test_cli_download(testdir):
    """
    Test download command
    """

    current_dir = os.getcwd()

    os.chdir(cli_dir)
    proc = subprocess.Popen(
        [
            f'''python3 -m cli download {testdir /  "data.csv"}  --query="select * from basedosdados.br_ibge_pib.municipio limit 10" --billing_project_id=basedosdados-dev'''
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
    )

    _, err = proc.communicate()

    os.chdir(current_dir)

    assert os.path.isfile(testdir / "data.csv")


@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_get_data_description(testdir):
    """
    Teste if error is raised when no path is provided
    """

    current_dir = os.getcwd()

    os.chdir(cli_dir)
    proc = subprocess.Popen(
        [
            f"python3 -m cli get dataset_description br_me_rais"
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
    )

    _, err = proc.communicate()

    os.chdir(current_dir)

    assert b"Description" in err

@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_get_table_columns(testdir):
    """
    Teste if error is raised when no path is provided
    """

    current_dir = os.getcwd()

    os.chdir(cli_dir)
    proc = subprocess.Popen(
        [
            f"python3 -m cli get table_columns br_me_rais microdados"
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
    )

    _, err = proc.communicate()

    os.chdir(current_dir)

    assert b"Columns" in err


@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_get_table_description(testdir):
    """
    Teste if error is raised when no path is provided
    """

    current_dir = os.getcwd()

    os.chdir(cli_dir)
    proc = subprocess.Popen(
        [
            f"python3 -m cli get table_description br_me_rais microdados"
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
    )

    _, err = proc.communicate()

    os.chdir(current_dir)

    assert b"Description" in err

@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_list_dataset_tables():
    """
    Teste if error is raised when no path is provided
    """

    current_dir = os.getcwd()

    os.chdir(cli_dir)
    proc = subprocess.Popen(
        [
            f"python3 -m cli list dataset_tables br_me_rais"
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
    )

    _, err = proc.communicate()

    os.chdir(current_dir)

    assert b"Tables" in err

@pytest.mark.skip(reason="require positional argument not explicited by help")
def test_cli_list_datasets():
    """
    Teste if error is raised when no path is provided
    """

    current_dir = os.getcwd()

    os.chdir(cli_dir)
    proc = subprocess.Popen(
        [
            f"python3 -m cli list datasets"
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
    )

    _, err = proc.communicate()

    os.chdir(current_dir)

    assert b"Datasets" in err


def test_cli_create_no_path_error(testdir):
    """
    Teste if error is raised when no path is provided
    """

    current_dir = os.getcwd()

    shutil.rmtree(testdir / DATASET_ID / TABLE_ID, ignore_errors=True)
    os.chdir(cli_dir)
    proc = subprocess.Popen(
        [
            f"python3 -m cli --metadata_path={testdir} table create --if_table_exists=pass {DATASET_ID} {TABLE_ID}"
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
    )

    _, err = proc.communicate()

    os.chdir(current_dir)

    assert b"You must provide a path to correctly create config files" in err

