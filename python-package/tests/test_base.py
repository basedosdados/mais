"""
Tests for Base class
"""
# pylint: disable=unused-variable

import re
from pathlib import Path

from google.cloud import storage, bigquery


def test_bucket_name(base, config_file_exists, capsys):
    """
    Test the bucket_name function
    """
    if config_file_exists:
        assert isinstance(base.bucket_name, str)
    else:
        out, err = capsys.readouterr()
        assert "Apparently, that is the first time that you are using" in out


def test_client(base, config_file_exists, capsys):
    """
    Test the client function
    """
    if config_file_exists:
        client_dict = base.client
        assert isinstance(client_dict, dict)
        assert isinstance(client_dict["bigquery_prod"], bigquery.Client)
        assert isinstance(client_dict["bigquery_staging"], bigquery.Client)
        assert isinstance(client_dict["storage_staging"], storage.Client)
    else:
        out, err = capsys.readouterr()
        assert "Apparently, that is the first time that you are using" in out


def test_config(base, config_file_exists, capsys):
    """
    Test the config function
    """
    if config_file_exists:
        config_keys = base.config.keys()
        assert "metadata_path" in config_keys
        assert "bucket_name" in config_keys
        assert "templates_path" in config_keys
        assert "gcloud-projects" in config_keys
        assert "user" in config_keys
        assert "ckan" in config_keys
    else:
        out, err = capsys.readouterr()
        assert "Apparently, that is the first time that you are using" in out


def test_config_path(base, config_file_exists, capsys):
    """
    Test the config_path function
    """
    if config_file_exists:
        assert isinstance(base.config_path, Path)
    else:
        out, err = capsys.readouterr()
        assert "Apparently, that is the first time that you are using" in out


def test_main_vars(base, config_file_exists, capsys):
    """
    Test the main_vars function
    """
    if config_file_exists:
        main_vars_keys = base.main_vars.keys()
        assert "bucket_name" in main_vars_keys
        assert "metadata_path" in main_vars_keys
        assert "templates" in main_vars_keys
    else:
        out, err = capsys.readouterr()
        assert "Apparently, that is the first time that you are using" in out

def test_metadata_path(base, config_file_exists, capsys):
    """
    Test the metadata_path function
    """
    if config_file_exists:
        assert isinstance(base.metadata_path, Path)
    else:
        out, err = capsys.readouterr()
        assert "Apparently, that is the first time that you are using" in out


def test_templates(base, config_file_exists, capsys):
    """
    Test the templates_path function
    """
    if config_file_exists:
        assert isinstance(base.templates, Path)
    else:
        out, err = capsys.readouterr()
        assert "Apparently, that is the first time that you are using" in out


def test_uri(base, config_file_exists, capsys):
    """
    Test the uri function
    """
    if config_file_exists:
        assert bool(re.match(r"gs://.*", base.uri))
    else:
        out, err = capsys.readouterr()
        assert "Apparently, that is the first time that you are using" in out
