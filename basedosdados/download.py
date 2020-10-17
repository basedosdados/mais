from google.cloud import bigquery, storage
from pathlib import Path
import time


def download(
    savepath,
    query=None,
    dataset_id=None,
    table_id=None,
    project_id="basedosdados",
    limit=None,
    bypass_memory=False,
    **pandas_kwargs,
):
    """Download table or query result from basedosdados BigQuery.

    Download using a query:

        `download('select * from `basedosdados.br_suporte.diretorio_municipios` limit 10')`

    Download using dataset_id and table_id:

        `download(dataset_id='br_suporte', table_id='diretorio_municipios')

    Adding arguments to modify save parameters:

        `dowload(dataset_id='br_suporte', table_id='diretorio_municipios', index=False, sep='|')


    Parameters
    ----------
    savepath : (str, pathlib.PosixPath)
        If savepath is a folder, it saves a file as `savepath / table_id.csv` or
        `savepath / query_result.csv` if table_id not available.
        If savepath is a file, saves data to file.
    query : str, optional
        Valid SQL Standard Query to basedosdados. If query is available,
        dataset_id and table_id are not required.
    dataset_id : str, optional
        Dataset id available in basedosdados. It should always come with table_id.
    table_id : str, optional
        Table id available in basedosdados.dataset_id.
        It should always come with dataset_id.
    project_id: str, optional
        In case you want to use to query another project, by default 'basedosdados'
    limit: int, optional
        Number of rows.
    pandas_kwargs:
        All variables accepted by pandas.to_csv
        https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_csv.html

    Raises
    ------
    Exception
        If either table_id or dataset_id were are empty.
    """
    savepath = Path(savepath)

    if savepath.is_dir():
        if table_id is not None:
            savepath = savepath / (table_id + ".csv")
        else:
            savepath = savepath / ("query_result.csv")

    if (dataset_id is not None) and (table_id is not None):
        if bypass_memory:
            _direct_download(dataset_id, table_id, savepath, project_id)
            return
        else:
            table = read_table(dataset_id, table_id, project_id, limit=limit)
    elif query is not None:
        if limit is not None:
            query += f" limit {limit}"
        table = read_sql(query)
    elif query is None:
        raise Exception("Either table_id, dataset_id or query should be filled.")
    
    # make default value of argument `index` in `to_csv()` as False 
    index_bool = pandas_kwargs.pop('index', False)

    table.to_csv(savepath, index=index_bool, **pandas_kwargs)


def read_sql(query):
    """Load data from BigQuery using a query. Just a wrapper around pandas.read_gbq

    Parameters
    ----------
    query : sql
        Valid SQL Standard Query to basedosdados

    Returns
    -------
    pd.DataFrame
        Query result
    """
    client = bigquery.Client()
    try:
        return client.query(query).to_dataframe()
    except OSError:
        raise OSError (
            'The project could not be determined.\n'
            'Set the project with `gcloud config set project <project_id>`.\n'
            'Where <project_id> is your Google Cloud Project ID that can be found '
            'here https://console.cloud.google.com/projectselector2/home/dashboard \n'
    )


def read_table(dataset_id, table_id, project_id="basedosdados", limit=None):
    """Load data from BigQuery using dataset_id and table_id.

    Parameters
    ----------
    dataset_id : str, optional
        Dataset id available in basedosdados. It should always come with table_id.
    table_id : str, optional
        Table id available in basedosdados.dataset_id.
        It should always come with dataset_id.
    project_id: str, optional
        In case you want to use to query another project, by default 'basedosdados'
    limit: int, optional
        Number of rows.

    Returns
    -------
    pd.DataFrame
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

    return read_sql(query)

def _direct_download(
    dataset_id, 
    table_id, 
    savepath, 
    project_id='basedosdados'):
    """
    Download file to disk without the requirement of loading it in memory.

    Creates a temporary file based on the `table_id` and the time of 
    execution. Also create a temporary bucket using the `dataset_id` 
    and the time of execution. Move the table to the temporary file and 
    download it to disk. In the end, remove the temporary bucket.
    
    Parameters
    ----------
    dataset_id : str
        Dataset id available in basedosdados. 
        It should always come with table_id.
    table_id : str
        Table id available in project_id.dataset_id.
    savepath : str
        Local path in which file should be stored in local disk.
    project_id: str, optional
        In case you want to use to query another project, by default 'basedosdados'
        
    """
    
    time_hash = str(hash(time.time()))
    tmp_file_name = table_id + '_' + time_hash
    tmp_bucket_name = dataset_id + '_' + time_hash

    blob_path = f'gs://{tmp_bucket_name}/{tmp_file_name}'
    
    try: 
        # create temporary bucket
        _create_bucket(tmp_bucket_name)
        
        # move table to temporary file inside temporary bucket
        _move_table_to_bucket(dataset_id, table_id, blob_path, project_id)

        # download file from bucket directly to disk
        _download_blob_from_bucket(tmp_bucket_name, tmp_file_name, savepath)
    except Exception as err:
        # TODO handle exceptions for 404 (not found), 403 (forbidden)
        raise Exception(err)
    finally: 
        # delete temporary bucket (even in the case of crashing)
        _delete_bucket(tmp_bucket_name)

def _download_blob_from_bucket(
    bucket_name : str, 
    blob_name : str, 
    savepath : str):
    """
    Download a blob from a bucket to the path specified.

    Parameters
    ----------
    bucket_name : str
        Name of the bucket for the file to be stored.
    blob_name : str
        Name of the file to be downloaded. 
        A file stored in a bucket is called a blob. It can have several
        formats such as `.csv`, `.avro`
    savepath : str
        Local path in which file should be stored in local disk.
    """
    savepath = Path(savepath)
    storage_client = storage.Client()

    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(blob_name)
    
    blob.download_to_filename(savepath)
    
 
def _create_bucket(bucket_name):
    """
    Create a new buket in a specific location with standard storage class

    Parameters
    ----------
    bucket_name : str
        Name of the bucket to be created.
    
    """
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    
    # standard storage class are adequate for data
    # stored for only brief periods of time
    bucket.storage_class = 'STANDARD'
    
    new_bucket = storage_client.create_bucket(bucket, location='US')

def _delete_bucket(bucket_name):
    """
    Forceably deletes a bucket. 

    This method deletes all blobs from a bucket.

    Parameters
    ----------
    bucket_name : str
        Name of the bucket to be deleted.
    
    """
    MAX_BLOBS = 256

    storage_client = storage.Client()
    bucket = storage_client.get_bucket(bucket_name)

    # NOTE: force=True implementation will not delete 
    # the temporary bucket if n_blobs >= 256
    n_blobs = len(list(storage_client.list_blobs(bucket_name)))
    if n_blobs >= MAX_BLOBS:
        raise Exception(f"""Your temporary bucket contains more than {MAX_BLOBS}. 
    You should manually delete it (force=True will not be able to delete it.).""")

    bucket.delete(force=True)

def _move_table_to_bucket(
    dataset_id, 
    table_id, 
    blob_path, 
    project_id='basedosdados'):
    """
    Move table from BigQuery to bucket

    Parameters
    ----------
    dataset_id : str
        Dataset id available in basedosdados. It should always come with table_id.
    table_id : str
        Table id available in project_id.dataset_id.
    blob_path : str
        Path in bucket where the table will be stored. 
        Called `destination_uri` in the documentation in the form of: 
            `gs://<bucket_name>/<file_name.csv>
    project_id: str, optional
        In case you want to use to query another project, by default 'basedosdados'
        
    """
    client = bigquery.Client()
    dataset_ref = bigquery.DatasetReference(project_id, dataset_id)
    table_ref = dataset_ref.table(table_id)
    
    # perform transfer from bq to bucket
    extract_job = client.extract_table(
        table_ref,
        blob_path,
        location='US'
    )
    # wait for API results
    extract_job.result()

