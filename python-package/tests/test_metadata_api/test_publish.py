"""
Test for publishing with new API.
"""
import os
# pylint: disable=fixme, unused-import, protected-access
from pathlib import Path
import random
import shutil
import string
from pprint import pprint
from io import StringIO

import pytest
import requests
import ruamel.yaml as ryaml

from basedosdados import Metadata

from basedosdados.exceptions import BaseDosDadosException
from loguru import logger

METADATA_FILES = {"dataset": "dataset_config.yaml", "table": "table_config.yaml"}


@pytest.mark.skip(reason="This test needs to mock an invalid token.")
def test_user_not_authorized(api_new_dataset_metadata):
    """
    Test if user is not authorized.
    """

    with pytest.raises(BaseDosDadosException):
        api_new_dataset_metadata.publish()


@pytest.mark.skip(reason="This test is not working.")
def test_login(api_new_dataset_metadata):
    """
    Test login.
    TODO: This test needs to be refactored, as it just makes the login and saves the token.
    """
    password = os.getenv("API_PASSWORD")
    new_token = api_new_dataset_metadata.get_token("mauricio", password)
    api_new_dataset_metadata.save_token(new_token)


def test_publish_existent_metadata_raise(api_dataset_metadata):
    """
    Test if publishing an existent metadata raises an error.
    """
    with pytest.raises(Exception):
        api_dataset_metadata.publish(if_exists="raise")


def test_publish_existent_metadata_pass(api_dataset_metadata):
    """
    Test if publishing an existent metadata passes.
    """
    res = api_dataset_metadata.publish(if_exists="pass")
    assert isinstance(res, dict)
    assert len(res) == 0


def test_api_new_data_dict(api_new_dataset_metadata):
    """
    Test if api_data_dict is a dict.
    """
    dataset_dict = api_new_dataset_metadata.api_data_dict
    pprint(dataset_dict)
    assert isinstance(dataset_dict, dict)


def test_api_data_dict(api_dataset_metadata):
    """
    Test if api_data_dict is a dict.
    """
    dataset_dict = api_dataset_metadata.api_data_dict
    pprint(dataset_dict)
    assert isinstance(dataset_dict, dict)
