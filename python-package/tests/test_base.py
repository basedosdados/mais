'''
Tests for Base class
'''

import pytest
from google.cloud import storage, bigquery

from basedosdados.upload.base import Base
from pathlib import Path


def test_bucket_name():
    """
    Test the bucket_name function
    """
    base = Base()
    assert isinstance(base.bucket_name, str)

def test_client():
    """
    Test the client function
    """
    base = Base()
    client_dict = base.client
    assert isinstance(client_dict, dict)
    assert isinstance(client_dict["bigquery_prod"], bigquery.Client)
    assert isinstance(client_dict["bigquery_staging"], bigquery.Client)
    assert isinstance(client_dict["storage_staging"], storage.Client)

def test_config():
    """
    Test the config function
    """
    base = Base()
    config_keys = base.config.keys()
    assert "metadata_path" in config_keys
    assert "bucket_name" in config_keys
    assert "templates_path" in config_keys
    assert "gcloud-projects" in config_keys
    assert "user" in config_keys
    assert "ckan" in config_keys

def test_config_path():
    """
    Test the config_path function
    """
    base = Base()
    assert isinstance(base.config_path, Path)