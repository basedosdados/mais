'''
Tests for Base class
'''

import pytest
from google.cloud import storage, bigquery

from basedosdados.upload.base import Base


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
    assert isinstance(client_dict["storage"], storage.Client)
    assert isinstance(client_dict["bigquery"], bigquery.Client)
    assert isinstance(client_dict["bigquery_prod"], bigquery.Client)