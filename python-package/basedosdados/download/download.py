import pandas_gbq
from pathlib import Path
import pydata_google_auth
from google.cloud import bigquery
from google.cloud import bigquery_storage_v1
from functools import partialmethod
import pandas as pd
from basedosdados.upload.base import Base
from functools import partialmethod
from basedosdados.validation.exceptions import BaseDosDadosException
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
    except (OSError, ValueError) as e:
        msg = (
            "\nWe are not sure which Google Cloud project should be billed.\n"
            "First, you should make sure that you have a Google Cloud project.\n"
            "If you don't have one, set one up following these steps: \n"
            "\t1. Go to this link https://console.cloud.google.com/projectselector2/home/dashboard\n"
            "\t2. Agree with Terms of Service if asked\n"
            "\t3. Click in Create Project\n"
            "\t4. Put a cool name in your project\n"
            "\t5. Hit create\n"
            "\n"
            "Copy the Project ID, (notice that it is not the Project Name)\n"
            "Now, you have two options:\n"
            "1. Add an argument to your function poiting to the billing project id.\n"
            "   Like `bd.read_table('br_ibge_pib', 'municipios', billing_project_id=<YOUR_PROJECT_ID>)`\n"
            "2. You can set a project_id in the environment by running the following command in your terminal: `gcloud config set project <YOUR_PROJECT_ID>`.\n"
            "   Bear in mind that you need `gcloud` installed."
        )
        raise BaseDosDadosException(msg) from e
    except GenericGBQException as e:
        if "Reason: 403" in str(e):
            raise BaseDosDadosException(
                "\nYou still don't have a Google Cloud Project.\n"
                "Set one up following these steps: \n"
                "1. Go to this link https://console.cloud.google.com/projectselector2/home/dashboard\n"
                "2. Agree with Terms of Service if asked\n"
                "3. Click in Create Project\n"
                "4. Put a cool name in your project\n"
                "5. Hit create\n"
                "6. Rerun this command with the flag `reauth=True`. \n"
                "   Like `read_table('br_ibge_pib', 'municipios', reauth=True)`"
            )
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


def list_datasets(
    query_project_id="basedosdados",
    filter_by=None,
    with_description=False,
    from_file=False,
):
    """Fetch the dataset_id of datasets available at query_project_id. Prints information on
    screen.

    Args:
        query_project_id (str): Optional.
            Which project the table lives. You can change this you want to query different projects.
        filter_by (str): Optional
            String to be matched in dataset_id.
        with_description (bool): Optional
            If True, fetch short dataset description for each dataset.

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

    _print_output(datasets)

    return None


def list_dataset_tables(
    dataset_id,
    query_project_id="basedosdados",
    from_file=False,
    filter_by=None,
    with_description=False,
):
    """Fetch table_id for tables available at the specified dataset_id. Prints the information
    on screen.

    Args:
        dataset_id (str): Optional.
            Dataset id available in basedosdados.
        query_project_id (str): Optional.
            Which project the table lives. You can change this you want to query different projects.
        filter_by (str): Optional
            String to be matched in the table_id.
        with_description (bool): Optional
             If True, fetch short table descriptions for each table that match the search criteria.

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

    _print_output(tables)

    return None


def get_dataset_description(
    dataset_id=None, query_project_id="basedosdados", from_file=False
):
    """Prints the full dataset description.

    Args:
        dataset_id (str): Optional.
            Dataset id available in basedosdados.
        query_project_id (str): Optional.
            Which project the table lives. You can change this you want to query different projects.
    """

    client = bigquery.Client(
        credentials=credentials(from_file=from_file), project=query_project_id
    )

    dataset = client.get_dataset(dataset_id)

    print(dataset.description)

    return None


def get_table_description(
    dataset_id=None,
    table_id=None,
    query_project_id="basedosdados",
    from_file=False,
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
    """

    client = bigquery.Client(
        credentials=credentials(from_file=from_file), project=query_project_id
    )

    table = client.get_table(f"{dataset_id}.{table_id}")

    print(table.description)

    return None


def get_table_columns(
    dataset_id=None,
    table_id=None,
    query_project_id="basedosdados",
    from_file=False,
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

    _print_output(description)

    return None


def get_table_size(
    dataset_id,
    table_id,
    billing_project_id,
    query_project_id="basedosdados",
    from_file=False,
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

    _print_output(table_data)

    return None
