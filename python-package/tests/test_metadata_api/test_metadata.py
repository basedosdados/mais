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
import ruamel.yaml as ryaml

from basedosdados import Metadata
from basedosdados.exceptions import BaseDosDadosException

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
