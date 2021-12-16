from google.cloud import bigquery, storage
import pydata_google_auth
from functools import lru_cache

from basedosdados.upload.base import Base


def credentials(from_file=False, reauth=False):

    if from_file:
        return Base()._load_credentials(mode="prod")

    SCOPES = [
        "https://www.googleapis.com/auth/cloud-platform",
    ]

    if reauth:
        return pydata_google_auth.get_user_credentials(
            SCOPES, credentials_cache=pydata_google_auth.cache.REAUTH
        )
    else:
        return pydata_google_auth.get_user_credentials(
            SCOPES,
        )


def client(query_project_id, billing_project_id, from_file, reauth):

    return dict(
        bigquery=bigquery.Client(
            credentials=credentials(from_file=from_file, reauth=reauth),
            project=query_project_id,
        ),
        storage=storage.Client(
            credentials=credentials(from_file=from_file, reauth=reauth),
            project=billing_project_id,
        ),
    )
