import pandas_gbq
from pathlib import Path
from pydata_google_auth.exceptions import PyDataCredentialsError
from google.cloud import bigquery_storage_v1
from functools import partialmethod
import re

from basedosdados.download.base import client, credentials
from basedosdados.exceptions import (
    BaseDosDadosException,
    BaseDosDadosAccessDeniedException,
    BaseDosDadosAuthorizationException,
    BaseDosDadosInvalidProjectIDException,
    BaseDosDadosNoBillingProjectIDException,
)
from pandas_gbq.gbq import GenericGBQException


def download(
    savepath,
    query=None,
    dataset_id=None,
    table_id=None,
    query_project_id="basedosdados",
    billing_project_id=None,
    limit=None,
    from_file=False,
    reauth=False,
    use_bqstorage_api=False,
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
        query_project_id (str): Optional.
            Which project the table lives. You can change this you want to query different projects.
        billing_project_id (str): Optional.
            Project that will be billed. Find your Project ID here https://console.cloud.google.com/projectselector2/home/dashboard
        limit (int): Optional
            Number of rows.
        from_file (boolean): Optional.
            Uses the credentials from file, located in `~/.basedosdados/credentials/
        reauth (boolean): Optional.
            Re-authorize Google Cloud Project in case you need to change user or reset configurations.
        use_bqstorage_api (boolean): Optional.
            Use the BigQuery Storage API to download query results quickly, but at an increased cost(https://cloud.google.com/bigquery/docs/reference/storage/).
            To use this API, first enable it in the Cloud Console(https://console.cloud.google.com/apis/library/bigquerystorage.googleapis.com).
            You must also have the bigquery.readsessions.create permission on the project you are billing queries to.
        pandas_kwargs ():
            Extra arguments accepted by [pandas.to_csv](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_csv.html)

    Raises:
        Exception: If either table_id or dataset_id were are empty.
    """

    savepath = Path(savepath)

    # make sure that path exists
    if savepath.is_dir():
        savepath.mkdir(parents=True, exist_ok=True)
    else:
        savepath.parent.mkdir(parents=True, exist_ok=True)

    if (dataset_id is not None) and (table_id is not None):
        table = read_table(
            dataset_id,
            table_id,
            query_project_id=query_project_id,
            billing_project_id=billing_project_id,
            limit=limit,
            reauth=reauth,
            from_file=from_file,
            use_bqstorage_api=use_bqstorage_api,
        )

    elif query is not None:

        query += f" limit {limit}" if limit is not None else ""

        table = read_sql(
            query,
            billing_project_id=billing_project_id,
            from_file=from_file,
            reauth=reauth,
            use_bqstorage_api=use_bqstorage_api,
        )

    else:
        raise BaseDosDadosException(
            "Either table_id, dataset_id or query should be filled."
        )

    if savepath.is_dir():
        if table_id is not None:
            savepath = savepath / (table_id + ".csv")
        else:
            savepath = savepath / ("query_result.csv")

    pandas_kwargs["index"] = pandas_kwargs.get("index", False)

    table.to_csv(savepath, **pandas_kwargs)


def read_sql(
    query,
    billing_project_id=None,
    from_file=False,
    reauth=False,
    use_bqstorage_api=False,
):
    """Load data from BigQuery using a query. Just a wrapper around pandas.read_gbq

    Args:
        query (sql):
            Valid SQL Standard Query to basedosdados
        billing_project_id (str): Optional.
            Project that will be billed. Find your Project ID here https://console.cloud.google.com/projectselector2/home/dashboard
        from_file (boolean): Optional.
            Uses the credentials from file, located in `~/.basedosdados/credentials/
        reauth (boolean): Optional.
            Re-authorize Google Cloud Project in case you need to change user or reset configurations.
        use_bqstorage_api (boolean): Optional.
            Use the BigQuery Storage API to download query results quickly, but at an increased cost(https://cloud.google.com/bigquery/docs/reference/storage/).
            To use this API, first enable it in the Cloud Console(https://console.cloud.google.com/apis/library/bigquerystorage.googleapis.com).
            You must also have the bigquery.readsessions.create permission on the project you are billing queries to.

    Returns:
        pd.DataFrame:
            Query result
    """

    try:
        # Set a two hours timeout
        bigquery_storage_v1.client.BigQueryReadClient.read_rows = partialmethod(
            bigquery_storage_v1.client.BigQueryReadClient.read_rows,
            timeout=3600 * 2,
        )

        return pandas_gbq.read_gbq(
            query,
            credentials=credentials(from_file=from_file, reauth=reauth),
            project_id=billing_project_id,
            use_bqstorage_api=use_bqstorage_api,
        )

    except GenericGBQException as e:
        if "Reason: 403" in str(e):
            raise BaseDosDadosAccessDeniedException

        elif re.match("Reason: 400 POST .* [Pp]roject[ ]*I[Dd]", str(e)):
            raise BaseDosDadosInvalidProjectIDException

        raise

    except PyDataCredentialsError as e:
        raise BaseDosDadosAuthorizationException

    except (OSError, ValueError) as e:
        no_billing_id = "Could not determine project ID" in str(e)
        no_billing_id |= "reading from stdin while output is captured" in str(e)
        if no_billing_id:
            raise BaseDosDadosNoBillingProjectIDException
        raise


def read_table(
    dataset_id,
    table_id,
    query_project_id="basedosdados",
    billing_project_id=None,
    limit=None,
    from_file=False,
    reauth=False,
    use_bqstorage_api=False,
):
    """Load data from BigQuery using dataset_id and table_id.

    Args:
        dataset_id (str): Optional.
            Dataset id available in basedosdados. It should always come with table_id.
        table_id (str): Optional.
            Table id available in basedosdados.dataset_id.
            It should always come with dataset_id.
        query_project_id (str): Optional.
            Which project the table lives. You can change this you want to query different projects.
        billing_project_id (str): Optional.
            Project that will be billed. Find your Project ID here https://console.cloud.google.com/projectselector2/home/dashboard
        limit (int): Optional.
            Number of rows to read from table.
        from_file (boolean): Optional.
            Uses the credentials from file, located in `~/.basedosdados/credentials/
        reauth (boolean): Optional.
            Re-authorize Google Cloud Project in case you need to change user or reset configurations.
        use_bqstorage_api (boolean): Optional.
            Use the BigQuery Storage API to download query results quickly, but at an increased cost(https://cloud.google.com/bigquery/docs/reference/storage/).
            To use this API, first enable it in the Cloud Console(https://console.cloud.google.com/apis/library/bigquerystorage.googleapis.com).
            You must also have the bigquery.readsessions.create permission on the project you are billing queries to.


    Returns:
        pd.DataFrame:
            Query result
    """

    if (dataset_id is not None) and (table_id is not None):
        query = f"""
        SELECT * 
        FROM `{query_project_id}.{dataset_id}.{table_id}`"""

        if limit is not None:

            query += f" LIMIT {limit}"
    else:
        raise BaseDosDadosException("Both table_id and dataset_id should be filled.")

    return read_sql(
        query,
        billing_project_id=billing_project_id,
        from_file=from_file,
        reauth=reauth,
        use_bqstorage_api=use_bqstorage_api,
    )
