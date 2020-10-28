from google.cloud import bigquery, storage

from functools import lru_cache


def google_client(service, project_id=None):
    return _clients[service]


@lru_cache(256)
def _clients(project_id=None):

    return dict(
        bigquery=bigquery.Client(project=project_id),
        storage=storage.Client(project=project_id),
    )