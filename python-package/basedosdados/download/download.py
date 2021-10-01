from google.cloud.bigquery import dataset
import pandas_gbq
from pathlib import Path
import pydata_google_auth
from pydata_google_auth.exceptions import PyDataCredentialsError
from google.cloud import bigquery
from google.cloud import bigquery_storage_v1
from functools import partialmethod
import re
import pandas as pd
from basedosdados.upload.base import Base
from functools import partialmethod
from basedosdados.exceptions import (
    BaseDosDadosException,
    BaseDosDadosAccessDeniedException,
    BaseDosDadosAuthorizationException,
    BaseDosDadosInvalidProjectIDException,
    BaseDosDadosNoBillingProjectIDException,
)
from pandas_gbq.gbq import GenericGBQException


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
        reauth (boolean): Optional.
            Re-authorize Google Cloud Project in case you need to change user or reset configurations.
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
        )

    elif query is not None:

        query += f" limit {limit}" if limit is not None else ""

        table = read_sql(
            query,
            billing_project_id=billing_project_id,
            from_file=from_file,
            reauth=reauth,
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


def read_sql(query, billing_project_id=None, from_file=False, reauth=False):
    """Load data from BigQuery using a query. Just a wrapper around pandas.read_gbq

    Args:
        query (sql):
            Valid SQL Standard Query to basedosdados
        billing_project_id (str): Optional.
            Project that will be billed. Find your Project ID here https://console.cloud.google.com/projectselector2/home/dashboard
        reauth (boolean): Optional.
            Re-authorize Google Cloud Project in case you need to change user or reset configurations.

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
        reauth (boolean): Optional.
            Re-authorize Google Cloud Project in case you need to change user or reset configurations.
        limit (int): Optional.
            Number of rows to read from table.

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
        query, billing_project_id=billing_project_id, from_file=from_file, reauth=reauth
    )


def _get_header(text):
    """Gets first paragraph of a text

    Args:
        text (str or None): Text to be split

    Returns:
        str: First paragraph
    """

    if isinstance(text, str):
        return text.split("\n")[0]
    elif text is None:
        return ""


def _fix_size(s, step=80):

    final = ""

    for l in s.split(" "):
        final += (l + " ") if len(final.split("\n")[-1]) < step else "\n"

    return final


def _print_output(df):
    """Prints dataframe contents as print blocks

    Args:
        df (pd.DataFrame): table to be printed
    """

    columns = df.columns
    step = 80
    print()
    for i, row in df.iterrows():
        for c in columns:
            print(_fix_size(f"{c}: \n\t{row[c]}"))
        print("-" * (step + 15))
    print()

    # func = lambda lista, final, step: (
    # func(lista[1:],
    #     (final + lista[0] + ' ')
    #         if len(final.split('\n')[-1]) <= step
    #         else final + '\n',
    #      step
    #        ) if len(lista) else final)


def _handle_output(verbose, output_type, df, col_name=None):
    """Handles datasets and tables listing outputs based on user's choice.
    Either prints it to the screen or returns it as a `list` object.
    Args:
        verbose (bool): amount of verbosity
        output_type (str): type of output
        df (pd.DataFrame, bigquery.Dataset or bigquery.Table): table containing datasets metadata
        col_name (str): name of column with id's data
    """

    df_is_dataframe = type(df) == pd.DataFrame
    df_is_bq_dataset_or_table = type(df) == bigquery.Table
    df_is_bq_dataset_or_table |= type(df) == bigquery.Dataset

    if verbose == True and df_is_dataframe:
        _print_output(df)

    elif verbose == True and df_is_bq_dataset_or_table:
        print(df.description)

    elif verbose == False:
        if output_type == "list":
            return df[col_name].to_list()
        elif output_type == "str":
            return df.description
        elif output_type == "records":
            return df.to_dict("records")
        else:
            msg = '`output_type` argument must be set to "list", "str" or "records".'
            raise ValueError(msg)

    else:
        raise TypeError("`verbose` argument must be of `bool` type.")

    return None


def list_datasets(
    query_project_id="basedosdados",
    filter_by=None,
    with_description=False,
    from_file=False,
    verbose=True,
):
    """Fetch the dataset_id of datasets available at query_project_id. Prints information on
    screen or returns it as a list.

    Args:
        query_project_id (str): Optional.
            Which project the table lives. You can change this you want to query different projects.
        filter_by (str): Optional
            String to be matched in dataset_id.
        with_description (bool): Optional
            If True, fetch short dataset description for each dataset.
        verbose (bool): Optional.
            If set to True, information is printed to the screen. If set to False, a list object is returned.


    Example:
        list_datasets(
        filter_by='sp',
        with_description=True,
        )
    """

    client = bigquery.Client(
        credentials=credentials(from_file=from_file), project=query_project_id
    )

    datasets_list = list(client.list_datasets())

    datasets = pd.DataFrame(
        [dataset.dataset_id for dataset in datasets_list], columns=["dataset_id"]
    )

    if filter_by:

        datasets = datasets.loc[datasets["dataset_id"].str.contains(filter_by)]

    if with_description:

        datasets["description"] = [
            _get_header(client.get_dataset(dataset).description)
            for dataset in datasets["dataset_id"]
        ]

    return _handle_output(
        verbose=verbose,
        output_type="list",
        df=datasets,
        col_name="dataset_id",
    )


def list_dataset_tables(
    dataset_id,
    query_project_id="basedosdados",
    from_file=False,
    filter_by=None,
    with_description=False,
    verbose=True,
):
    """Fetch table_id for tables available at the specified dataset_id. Prints the information
    on screen or returns it as a list.

    Args:
        dataset_id (str): Optional.
            Dataset id available in basedosdados.
        query_project_id (str): Optional.
            Which project the table lives. You can change this you want to query different projects.
        filter_by (str): Optional
            String to be matched in the table_id.
        with_description (bool): Optional
             If True, fetch short table descriptions for each table that match the search criteria.
        verbose (bool): Optional.
            If set to True, information is printed to the screen. If set to False, a list object is returned.

    Example:
        list_dataset_tables(
        dataset_id='br_ibge_censo2010'
        filter_by='renda',
        with_description=True,
        )
    """
    client = bigquery.Client(
        credentials=credentials(from_file=from_file), project=query_project_id
    )

    dataset = client.get_dataset(dataset_id)

    tables_list = list(client.list_tables(dataset))

    tables = pd.DataFrame(
        [table.table_id for table in tables_list], columns=["table_id"]
    )

    if filter_by:

        tables = tables.loc[tables["table_id"].str.contains(filter_by)]

    if with_description:

        tables["description"] = [
            _get_header(client.get_table(f"{dataset_id}.{table}").description)
            for table in tables["table_id"]
        ]

    return _handle_output(
        verbose=verbose,
        output_type="list",
        df=tables,
        col_name="table_id",
    )


def get_dataset_description(
    dataset_id=None,
    query_project_id="basedosdados",
    from_file=False,
    verbose=True,
):
    """Prints the full dataset description.

    Args:
        dataset_id (str): Optional.
            Dataset id available in basedosdados.
        query_project_id (str): Optional.
            Which project the table lives. You can change this you want to query different projects.
        verbose (bool): Optional.
            If set to True, information is printed to the screen. If set to False, data is returned as a `str`.
    """

    client = bigquery.Client(
        credentials=credentials(from_file=from_file), project=query_project_id
    )

    dataset = client.get_dataset(dataset_id)

    return _handle_output(verbose=verbose, output_type="str", df=dataset)


def get_table_description(
    dataset_id=None,
    table_id=None,
    query_project_id="basedosdados",
    from_file=False,
    verbose=True,
):
    """Prints the full table description.

    Args:
        dataset_id (str): Optional.
            Dataset id available in basedosdados. It should always come with table_id.
        table_id (str): Optional.
            Table id available in basedosdados.dataset_id.
            It should always come with dataset_id.
        query_project_id (str): Optional.
            Which project the table lives. You can change this you want to query different projects.
        verbose (bool): Optional.
            If set to True, information is printed to the screen. If set to False, data is returned as a `str`.
    """

    client = bigquery.Client(
        credentials=credentials(from_file=from_file), project=query_project_id
    )

    table = client.get_table(f"{dataset_id}.{table_id}")

    return _handle_output(verbose=verbose, output_type="str", df=table)


def get_table_columns(
    dataset_id=None,
    table_id=None,
    query_project_id="basedosdados",
    from_file=False,
    verbose=True,
):

    """Fetch the names, types and descriptions for the columns in the specified table. Prints
    information on screen.

    Args:
        dataset_id (str): Optional.
            Dataset id available in basedosdados. It should always come with table_id.
        table_id (str): Optional.
            Table id available in basedosdados.dataset_id.
            It should always come with dataset_id.
        query_project_id (str): Optional.
            Which project the table lives. You can change this you want to query different projects.
        verbose (bool): Optional.
            If set to True, information is printed to the screen. If set to False, data is returned as a `list` of `dict`s.
    Example:
        get_table_columns(
        dataset_id='br_ibge_censo2010',
        table_id='pessoa_renda_setor_censitario'
        )
    """

    client = bigquery.Client(
        credentials=credentials(from_file=from_file), project=query_project_id
    )

    table_ref = client.get_table(f"{dataset_id}.{table_id}")

    columns = [
        (field.name, field.field_type, field.description) for field in table_ref.schema
    ]

    description = pd.DataFrame(columns, columns=["name", "field_type", "description"])

    return _handle_output(verbose=verbose, output_type="records", df=description)


def get_table_size(
    dataset_id,
    table_id,
    billing_project_id,
    query_project_id="basedosdados",
    from_file=False,
    verbose=True,
):
    """Use a query to get the number of rows and size (in Mb) of a table query
    from BigQuery. Prints information on screen in markdown friendly format.

    WARNING: this query may cost a lot depending on the table.

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
        verbose (bool): Optional.
            If set to True, information is printed to the screen. If set to False, data is returned as a `list` of `dict`s.
    Example:
        get_table_size(
        dataset_id='br_ibge_censo2010',
        table_id='pessoa_renda_setor_censitario',
        billing_project_id='yourprojectid'
        )
    """
    billing_client = bigquery.Client(
        credentials=credentials(from_file=from_file), project=billing_project_id
    )

    query = f"""SELECT COUNT(*) FROM {query_project_id}.{dataset_id}.{table_id}"""

    job = billing_client.query(query, location="US")

    num_rows = job.to_dataframe().loc[0, "f0_"]

    size_mb = round(job.total_bytes_processed / 1024 / 1024, 2)

    table_data = pd.DataFrame(
        [
            {
                "project_id": query_project_id,
                "dataset_id": dataset_id,
                "table_id": table_id,
                "num_rows": num_rows,
                "size_mb": size_mb,
            }
        ]
    )

    return _handle_output(verbose=verbose, output_type="records", df=table_data)
