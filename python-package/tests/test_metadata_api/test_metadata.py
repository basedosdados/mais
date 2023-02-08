"""
Tests for the Metadata class with new API
"""
# pylint: disable=fixme, unused-import
from pathlib import Path
import random
import shutil
import string
from pprint import pprint

import pytest
import requests
import ruamel.yaml as ryaml

from basedosdados import Metadata
from basedosdados.upload.metadata import convert_snake_and_camel_case

from basedosdados.exceptions import BaseDosDadosException
from loguru import logger

METADATA_FILES = {"dataset": "dataset_config.yaml", "table": "table_config.yaml"}


def test_dataset_table_schema(api_table_metadata):
    """
    Test table schema.
    """

    metadata = api_table_metadata.api_data_dict

    assert metadata.get("id") == api_table_metadata.dataset_uuid
    assert metadata.get("tables")[0].get("id") == api_table_metadata.table_uuid


def test_dataset_schema(api_dataset_metadata):
    """
    Test dataset schema.
    """

    metadata = api_dataset_metadata.api_data_dict

    assert metadata.get("id") == api_dataset_metadata.dataset_uuid
    assert "themes" in metadata


def test_dataset_does_not_exists_in_api(api_new_dataset_metadata):
    """
    Test if dataset exists in API.
    """
    assert api_new_dataset_metadata.exists_in_api() is False


def test_dataset_exists_in_api(api_dataset_metadata):
    """
    Test if dataset does not exists in API.
    """
    assert api_dataset_metadata.exists_in_api() is True


def test_dataset_table_does_not_exists_in_api(api_new_dataset_metadata):
    """
    Test if table does not exists in API.
    """
    assert api_new_dataset_metadata.exists_in_api() is False


def test_dataset_table_exists_in_api(api_table_metadata):
    """
    Test if table exists in API.
    """
    assert api_table_metadata.exists_in_api() is True


def test_dataset_is_not_updated(api_dataset_metadata):
    """
    Test if dataset is updated.
    TODO: Create a deterministic test to return True.
    """

    assert api_dataset_metadata.is_updated() is False


def test_columns_schema(api_table_metadata):
    """
    Test columns schema.
    """
    columns_schema = api_table_metadata.columns_schema
    assert "directory_column" in columns_schema.get("properties")


def test_table_metadata_schema(api_table_metadata):
    """
    Test metadata schema.
    """
    metadata_schema = api_table_metadata.metadata_schema
    resource_type = metadata_schema.get("properties").get("resource_type").get("enum")[0]
    assert resource_type == "bdm_table"


def test_dataset_metadata_schema(api_dataset_metadata):
    """
    Test metadata schema.
    """
    metadata_schema = api_dataset_metadata.metadata_schema
    resource_type = metadata_schema.get("properties").get("type").get("enum")[0]
    assert resource_type == "dataset"


def test_create_new_table(api_new_table_metadata):
    """
    Test if table is created. To be reproducible,
    the test first deletes the table if it exists.
    """
    if api_new_table_metadata.filepath.exists():
        api_new_table_metadata.filepath.unlink()

    res = api_new_table_metadata.create()

    assert api_new_table_metadata.filepath.exists() is True
    assert isinstance(res, Metadata)


def test_update_table(api_table_metadata):
    """
    Test if table is updated.
    """
    res = api_table_metadata.create(if_exists="replace")
    assert isinstance(res, Metadata)


def test_convert_case_keys_in_indexes(api_table_metadata):
    """
    Test if case is converted in indexes.
    """
    query = '''
                query ($id: ID!) {
                  allDataset(id: $id) {
                    edges{
                      node{
                        _id
                        slug
                        name
                        description
                        createdAt
                        updatedAt  
                      }
                    }
                  }
                }
            '''
    variables = {"id": api_table_metadata.dataset_uuid}
    res = api_table_metadata._get_graphql(query, variables)
    old_dataset = res.get("data").get("allDataset").get("edges")[0].get("node")

    snake_dataset = dict((convert_snake_and_camel_case(k, to="snake"), v) for k, v in old_dataset.items())
    camel_dataset = dict((convert_snake_and_camel_case(k, to="camel"), v) for k, v in snake_dataset.items())

    assert "created_at" in snake_dataset
    assert "createdAt" in camel_dataset
