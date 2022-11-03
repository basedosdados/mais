"""
Tests for the upload utilities.
"""
# pylint: disable=invalid-name
from pathlib import Path
import shutil

import basedosdados as bd
from basedosdados.upload.utils import update_columns

import pytest

DATASET_ID = "pytest"
TABLE_ID = "pytest"

TABLE_FILES = ["publish.sql", "table_config.yaml"]


def test_update_columns(sample_data, testdir, table):
    """
    Test the update_columns utility.
    """
    # table = bd.Table(dataset_id=DATASET_ID, table_id=TABLE_ID, metadata_path=testdir)
    table.create(sample_data, if_table_exists='replace', if_table_config_exists='replace', if_storage_data_exists='replace')

    table_config_path = testdir / DATASET_ID / TABLE_ID / "table_config.yaml"
    last_modified = table_config_path.stat().st_mtime

    publish_path = testdir / DATASET_ID / TABLE_ID / "publish.sql"
    last_modified_publish = publish_path.stat().st_mtime

    path_arq = sample_data / "arquitetura_municipio.xlsx"
    # get path as string
    path_arq = str(path_arq)

    update_columns(table_obj=table, columns_config_url_or_path=path_arq)

    assert table_config_path.stat().st_mtime > last_modified
    assert publish_path.stat().st_mtime > last_modified_publish
    