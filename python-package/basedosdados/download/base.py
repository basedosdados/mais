'''
Functions for manage auth and credentials
'''
# pylint: disable=redefined-outer-name, protected-access, no-name-in-module, import-error,line-too-long
from functools import lru_cache

import sys

from google.cloud import bigquery, storage

import pydata_google_auth


from basedosdados.upload.base import Base

SCOPES = [
    "https://www.googleapis.com/auth/cloud-platform",
]


def reauth():
    '''
    Reauth user credentials
    '''

    pydata_google_auth.get_user_credentials(
        SCOPES, credentials_cache=pydata_google_auth.cache.REAUTH
    )


def credentials(from_file=False, reauth=False):
    '''
    Get user credentials
    '''

    #check if is running in colab
    if "google.colab" in sys.modules:
        from google.colab import auth  # pylint: disable=import-outside-toplevel

        auth.authenticate_user()
        return None

    if from_file:
        return Base()._load_credentials(mode="prod")

    if reauth:
        return pydata_google_auth.get_user_credentials(
            SCOPES, credentials_cache=pydata_google_auth.cache.REAUTH
        )

    return pydata_google_auth.get_user_credentials(
            SCOPES,
    )



@lru_cache(256)
def google_client(billing_project_id, from_file, reauth):
    '''
    Get Google Cloud client for bigquery and storage
    '''

    return dict(
        bigquery=bigquery.Client(
            credentials=credentials(from_file=from_file, reauth=reauth),
            project=billing_project_id,
        ),
        storage=storage.Client(
            credentials=credentials(from_file=from_file, reauth=reauth),
            project=billing_project_id,
        ),
    )
