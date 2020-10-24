from google.cloud import bigquery
import pandas as pd


def list_tables(dataset_id, project_id='basedosdados', pattern=None):
    """
    List tables inside a dataset_id

    Args:
        dataset_id (:obj:`str`): Dataset id available in project_id. 
        project_id (:obj:`str`, optional): In case you want to use to 
            query another project, by default 'basedosdados'
        pattern (:obj:`str`, optional): Regular expression to look 
            within `dataset_id`.

    Returns: 
        pd.DataFrame: List of `table_id` within the `dataset_id`
    """
    client = bigquery.Client(project=project_id)
    
    tables_list = client.list_tables(dataset_id)

    result = pd.DataFrame(dict(
        table_id=[table.table_id for table in tables_list]
    ))
    # filter tables using Regex
    if pattern: 
        result = result.loc[result['table_id'].str.contains(pattern)]
    
    return result

def list_datasets(project_id='basedosdados', pattern=None):
    """
    List `dataset_id`'s inside a `project_id`

    Args:
        pattern (:obj:`str`, optional): Regular expression to look 
            within `dataset_id`.

    Returns: 
        pd.DataFrame: List of `table_id` within the `dataset_id`
    """

    client = bigquery.Client(project=project_id)
    datasets_list = client.list_datasets()

    result = pd.DataFrame(dict(
        dataset_id=[table.dataset_id for table in datasets_list]
    ))

    # filter tables using Regex
    if pattern: 
        result = result.loc[result['dataset_id'].str.contains(pattern)]
    
    return result

def metadata(dataset_id, table_id, project_id='basedosdados'):
    """
    Display column types and descriptions from `table_id`
    
    Args:
        dataset_id (:obj:`str`): Dataset id available in project_id.
        table_id (:obj:`str`): Table id available in project_id.dataset_id.
        project_id (:obj:`str`, optional): In case you want to use to 
            query another project, by default 'basedosdados'

    Returns: 
        pd.DataFrame: Column types and descriptions
    """
    client = bigquery.Client(project=project_id)
    table_name = f'{project_id}.{dataset_id}.{table_id}'

    table = client.get_table(table_name)
    description = [
        (col.name, col.field_type, col.description) for col in table.schema
            ]
    # TODO: full table description
    # check df.metadata

    return pd.DataFrame(description, columns=['columns', 'type','description'])

def cost(query, price=0.02):
    """
    Estimate the cost of a query in BigQuery considering each Gb costs.
    Up to now, it only works with real tables (not on Views or External)

    Args:
        query (:obj:`str`): Valid SQL Standard Query.
        price (:obj:`float`, optional): Price in US dollars per GB consumed. 

    Returns:
        float: Cost of query in US dollars
    """
    client = bigquery.Client()

    job_config = bigquery.QueryJobConfig()
    job_config.dry_run = True
    job_config.use_query_cache = False
    
    job = client.query(query, location='US', job_config=job_config)
    mb = _pretty_format(job.total_bytes_processed, 'bytes')

    # US$ for each GB processed.
    dollar = (job.total_bytes_processed / 1024/1024/1024) * price

    print(f'Processing {mb} MB, which costs US$ {dollar:,.2f}')
        
    return dollar

def info(
    dataset_id, 
    table_id, 
    project_id='basedosdados', 
    pretty=True, 
    extract_from_view=False):
    """
    Display metadata about the specified `table_id` 

    Args:
        dataset_id (:obj:`str`): Dataset id available in project_id.
        table_id (:obj:`str`): Table id available in project_id.dataset_id.
        project_id (:obj:`str`, optional): In case you want to use to query 
            another project, by default 'basedosdados'
        pretty (:obj:`bool`, optional): Whether to return values as 
            raw data (for calculation purposes) or pretty formatted.
        extract_from_view: Run a query to count number of rows and bytes used
            in a view. Be aware that this will incurr additional cost.
    Returns: 
        pd.DataFrame: Metadata information about the table

    """

    client = bigquery.Client()

    table_name = f'{project_id}.{dataset_id}.{table_id}'

    table = client.get_table(table_name)
    
    nrows = table.num_rows
    nbytes = table.num_bytes
    
    # when tables are views, using table.num_rows returns 0
    if extract_from_view:
        job = client.query(
            f'SELECT COUNT(*) FROM {table_name}', 
            location='US'
        )
        nrows = job.to_dataframe().loc[0, 'f0_']
        nbytes = job.total_bytes_processed 

    # For bytes, though, if you are working with public data from bq
    # the job will not account for any byte, so I'll get the maximum 
    # between that and the table.num_bytes
    
    name = table.table_id
    dataset = table.dataset_id
    fullname = table.full_table_id
    location = table.location
    anomes_created = table.created.date()
    time_created = table.created.time()
    description = table.description

    if pretty:
        nrows = f'{nrows:,}'
        nbytes = _pretty_format(nbytes, 'bytes')
        anomes_created = str(table.created.year) + \
                '/' + str(table.created.month).zfill(2) + \
                '/' + str(table.created.day).zfill(2)
        time_created = str(table.created.hour) + \
            ':' + str(table.created.minute).zfill(2)
        
    data = pd.DataFrame({'nrows': [nrows], 
                         'size': [nbytes],
                         'table_name':[name],
                         'dataset_name':[dataset],
                         'date_created':[anomes_created],
                         'time_created':[time_created],
                         'full_table_name':[fullname],
                         'table_location':[location],
                         'description':[description]}, index=['value']).T

    return data

def _pretty_format(value, category='value'):
    """
    Converts unfriendly formats to human readable.

    Args:
        value (:obj:`int`, float): The value to be formatted.
        category (:obj:`str`, optional): The type of value.
            Currently allowed categories are: 
            - `value` for numbers to be written as 80K, 80M, 80B
            - `bytes` for numbers to be written as 1MB, 1kB, 1GB

    Returns: 
        str: formatted value
    """
    if category == 'value':
        units = ['','K','M','B']
        decimal_places = {'' : 0, 
                          'K':1,
                          'M':1,
                          'B':1
                        }
        cutoff = 1000
    elif category == 'bytes':
        units = ['B','kB','MB','GB','TB']
        decimal_places = {'B' : 3, 
                          'kB':2,
                          'MB':1,
                          'GB':1,
                          'TB':1
                            }
        cutoff = 1024
    else:

        raise NotImplementedError()

    def _human_readable_size(size, 
                            units=units, 
                            decimal_places=decimal_places):
        for unit in units:
            if size < cutoff:
                break
            size /= cutoff

        return f"{size:.{decimal_places[unit]}f}{unit}"

    return _human_readable_size(value)

def _retrieve_information_schema(dataset_id, project_id='basedosdados'):
    client = bigquery.Client()
    job = client.query(
        f'SELECT * FROM `{project_id}.{dataset_id}.INFORMATION_SCHEMA.VIEWS`'
    )
    return job.to_dataframe()


