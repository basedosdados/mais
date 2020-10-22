from google.cloud import bigquery
import pandas_gbq
from pathlib import Path
import pydata_google_auth
from functools import lru_cache


@lru_cache(256)
def credentials():

    SCOPES = [
        "https://www.googleapis.com/auth/cloud-platform",
    ]

    return pydata_google_auth.get_user_credentials(
        SCOPES,
        # Use the NOOP cache to avoid writing credentials to disk.
        # credentials_cache=pydata_google_auth.cache.NOOP,
    )


def download(
    savepath,
    query=None,
    dataset_id=None,
    table_id=None,
    project_id="basedosdados",
    limit=None,
    **pandas_kwargs,
):
    """Download table or query result from basedosdados BigQuery (or other).

    * Using a **query**:

        `download('select * from `basedosdados.br_suporte.diretorio_municipios` limit 10')`

    * Using **dataset_id & table_id**:

        `download(dataset_id='br_suporte', table_id='diretorio_municipios')`

    You can also add arguments to modify save parameters:

    `download(dataset_id='br_suporte', table_id='diretorio_municipios', index=False, sep='|')`


    Args:
        savepath (str, pathlib.PosixPath):
            If savepath is a folder, it saves a file as `savepath / table_id.csv` or
            `savepath / query_result.csv` if table_id not available.
            If savepath is a file, saves data to file.
        query (str): Optional.
            Valid SQL Standard Query to basedosdados. If query is available,
            dataset_id and table_id are not required.
        dataset_id (str): Optional.
            Dataset id available in basedosdados. It should always come with table_id.
        table_id (str): Optional.
            Table id available in basedosdados.dataset_id.
            It should always come with dataset_id.
        project_id (str): Optional.
            In case you want to use to query another project.
        limit (int): Optional
            Number of rows.
        pandas_kwargs ():
            Extra arguments accepted by [pandas.to_csv](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_csv.html)

    Raises:
        Exception: If either table_id or dataset_id were are empty.
    """

    savepath = Path(savepath)

    if (dataset_id is not None) and (table_id is not None):
        table = read_table(dataset_id, table_id, limit=limit)
    elif query is not None:
        if limit is not None:
            query += f" limit {limit}"
        table = read_sql(query, project_id=project_id)
    elif query is None:
        raise Exception("Either table_id, dataset_id or query should be filled.")

    if savepath.is_dir():
        if table_id is not None:
            savepath = savepath / (table_id + ".csv")
        else:
            savepath = savepath / ("query_result.csv")

    table.to_csv(savepath, **pandas_kwargs)


def read_sql(query, project_id="basedosdados"):
    """Load data from BigQuery using a query. Just a wrapper around pandas.read_gbq

    Args:
        query (sql):
            Valid SQL Standard Query to basedosdados

    Returns:
        pd.DataFrame:
            Query result
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
        dataset_id (str): Optional.
            Dataset id available in basedosdados. It should always come with table_id.
        table_id (str): Optional.
            Table id available in basedosdados.dataset_id.
            It should always come with dataset_id.
        project_id (str): Optional.
            In case you want to use to query another project.
        limit (int): Optional.
            Number of rows to read from table.

    Returns:
        pd.DataFrame:
            Query result
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
