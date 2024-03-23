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

TABLE_FILES = ["publish.sql"]


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
