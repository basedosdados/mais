from google.cloud import bigquery
import pandas as pd

from basedosdados.download.base import credentials


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
