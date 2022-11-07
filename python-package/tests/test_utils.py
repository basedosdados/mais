"""
Tests for the upload utilities.
"""
# pylint: disable=invalid-name
from pathlib import Path
import shutil
import os

import pytest
import pandas as pd

import basedosdados as bd
from basedosdados.upload.utils import update_columns, to_partitions


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


def test_to_partitions(sample_data, testdir):
    """
    Test the to_partitions utility.
    """
    os.makedirs(testdir / "municipio_partitioned", exist_ok=True)

    df = pd.read_csv(sample_data / "municipio.csv")
    to_partitions(df, ['ano'], testdir / "municipio_partitioned")

    # asserti if the files were created from 2002 to 2011
    for i in range(2002, 2012):
        assert os.path.exists(testdir / "municipio_partitioned" / f"ano={i}" / "data.csv")

    