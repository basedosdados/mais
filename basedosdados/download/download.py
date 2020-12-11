from functools import lru_cache
from google.cloud import bigquery, storage
import os
from pathlib import Path
import pandas_gbq

import re
import time

from basedosdados.download.base import google_client, credentials


def read_sql(query, project_id="basedosdados"):
    """Load data from BigQuery using a query. Just a wrapper around pandas.read_gbq

    Args:
        query (str): Valid SQL Standard Query.

    Returns:
        pd.DataFrame: The query result.

    Examples:
        >>> my_query = '''
        SELECT partido,
               COUNT(*) AS qtd_deputados
        FROM `basedosdados.br_sp_alesp.deputados`
        GROUP BY partido
        '''
        >>> bd.read_sql(query=my_query)

        |    | partido      |   qtd_deputados |
        |---:|:-------------|------:|
        |  0 | PSL          |    13 |
        |  1 | PROS         |     1 |
        |  2 | PSD          |     2 |
        |  3 | SD           |     1 |
        |  4 | REPUBLICANOS |     6 |
        |  ... | ...         |     ... |
    """

    try:
        return pandas_gbq.read_gbq(
            query, credentials=credentials(), project_id=project_id
        )
    except OSError:
        raise OSError(
            "The project could not be determined.\n"
            "Set the project with `gcloud config set project <project_id>`.\n"
            "Where <project_id> is your Google Cloud Project ID that can be found "
            "here https://console.cloud.google.com/projectselector2/home/dashboard \n"
        )


def read_table(dataset_id, table_id, project_id="basedosdados", limit=None):
    """Load data from BigQuery using dataset_id and table_id.

    Args:
        dataset_id (str): Dataset id available in project_id.
        table_id (str): Table id available in project_id.dataset_id.
        project_id (str, optional): In case you want to use to query another
            project, defaults to 'basedosdados'
        limit (int, optional): Number of rows.

    Returns:
        pd.DataFrame: The query result
    """

    if (dataset_id is not None) and (table_id is not None):
        query = f"""
        SELECT * 
        FROM `{project_id}.{dataset_id}.{table_id}`"""

        if limit is not None:

            query += f" LIMIT {limit}"
    else:
        raise Exception("Both table_id and dataset_id should be filled.")

    return read_sql(query, project_id=project_id)
