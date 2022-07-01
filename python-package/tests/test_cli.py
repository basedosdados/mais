'''
Tests for the CLI module.
'''

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


DATASET_ID = "pytest"
TABLE_ID = "pytest"

TABLE_FILES = ["publish.sql", "table_config.yaml"]

templates=Path(__file__).parent / "templates"
bucket_name = "basedosdados-dev"
metadata_path = Path(__file__).parent / "tmp_bases"
ctx = Context(command=cli_table.commands['create'], obj=dict(templates=templates,bucket_name=bucket_name,metadata_path=metadata_path))

def test_create_no_path_error(testdir):
    """
    Teste if error is raised when no path is provided
    """

    shutil.rmtree(testdir / DATASET_ID / TABLE_ID, ignore_errors=True)

    runner = click.testing.CliRunner()
    result = runner.invoke(cli=cli_table.get_command(ctx=ctx, cmd_name='create'),  args=f'''--if_table_exists=replace {DATASET_ID} {TABLE_ID}''')

    assert isinstance(result.exception, BaseDosDadosException)
