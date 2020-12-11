from google.cloud import bigquery, storage
import pydata_google_auth

from functools import lru_cache


def google_client(service, project_id=None):
    return _clients(project_id)[service]


@lru_cache(256)
def _clients(project_id=None):

    return dict(
        bigquery=bigquery.Client(project=project_id, credentials=credentials()),
        storage=storage.Client(project=project_id, credentials=credentials()),
    )


def credentials():

    SCOPES = [
        "https://www.googleapis.com/auth/cloud-platform",
    ]

    return pydata_google_auth.get_user_credentials(
        SCOPES,
        # Use the NOOP cache to avoid writing credentials to disk.
        # credentials_cache=pydata_google_auth.cache.NOOP,
    )