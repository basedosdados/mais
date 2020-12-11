from google.cloud import bigquery

from basedosdados.download.base import google_client


def freq(
    dataset_id,
    table_id,
    col_name,
    project_id="basedosdados",
    order_by_freq=False,
    ascending=True,
):
    """
    Return a dataframe containing the frequency table of the `col_name`
    (which can be a list of columns) specified.


    Args:
        dataset_id (:obj:`str`): Dataset id available in project_id.
        table_id (:obj:`str`): Table id available in project_id.dataset_id.
        col_name (:obj:`str`, list): Column available in project_id.dataset_id.table_id.
        project_id (:obj:`str`, optional):n case you want to use to
            query another project. Defaults to "basedosdados".
        order_by_freq (bool, optional): Order results by frequency.
            Defaults to False.
        ascending (bool, optional): Whether results should ascend. Defaults to True.

    Returns:
        [type]: [description]
    """

    client = google_client("bigquery", project_id=project_id)
    if not (isinstance(col_name, list) or isinstance(col_name, tuple)):
        col_name = [col_name]

    # generate the query for the frequency table
    table_name = f"{project_id}.{dataset_id}.{table_id}"
    query_str = _freq_query(table_name, col_name)

    freq_cols = ["perc_" + col.lower() for col in col_name]
    cols_str = " and ".join(col_name)

    if order_by_freq:
        job = client.query(query_str)
        result = job.to_dataframe().sort_values(by="frequency", ascending=ascending)
    else:
        job = client.query(query_str)
        result = job.to_dataframe().sort_values(by=col_name, ascending=ascending)

    return result


def _freq_query(table_name, col_name):
    keys = ", \n\t\t".join(col_name)

    # each calculated column of the frequency table
    counts = [
        "COUNT(*) AS frequency",
        "COUNT(*)/(SUM(COUNT(*)) OVER()) AS percentage",
        "SUM(COUNT(*)) OVER window_freq AS cumulative_freq",
        "(SUM(COUNT(*)) OVER window_freq)/(SUM(COUNT(*)) OVER ()) AS cumulative_percentage",
    ]

    aggregations = ",\n\t".join(counts)

    query_str = f"""
        SELECT {keys},
            {aggregations}
        FROM {table_name}
        GROUP BY {keys}
    WINDOW window_freq AS (ORDER BY COUNT(*) RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
    """

    return query_str