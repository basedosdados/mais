from functools import lru_cache
from google.cloud import bigquery
from google.cloud import bigquery, storage
from pathlib import Path
from pathlib import Path
import pandas_gbq
import pydata_google_auth
import re
import time


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
    compression='NONE',
    extract=False
):
    """Download table or query result from basedosdados BigQuery.

    Download using a query:

        `download('select * from `basedosdados.br_suporte.diretorio_municipios` limit 10')`

    Download using dataset_id and table_id:

        `download(dataset_id='br_suporte', table_id='diretorio_municipios')

    Args:
        savepath (str, pathlib.PosixPath): If savepath is a folder, 
            it saves a file as `savepath / table_id.csv` or
            `savepath / query_result.csv` if table_id not available.
            If savepath is a file, saves data to file.
        query (:obj:`str`, optional): Valid SQL Standard Query. 
            If query is available, dataset_id and table_id are not required.
        dataset_id (:obj:`str`, optional): Dataset id available in the 
            project_id. It should always come with table_id.
        table_id (:obj:`str`, optional): Table id available in 
            project_id.dataset_id.
        project_id (:obj:str, optional): In case you want to use 
            to query another project. Defaults to 'basedosdados'
        limit (:obj:`int`, optional): Number of rows.
        compression (:obj:`str`, optional): Compression type to use for exported 
            files. Can be one of ["NONE"|"GZIP"]
        extract (:obj:`bool`, optional): Whether to extract the gzip file.

    Raises: 
        Exception: If either table_id or dataset_id were are empty.

    Note: 
        Download will create a temporary bucket in the cloud storage, create 
        a job to extract the current table_id to the bucket as a (possibly compressed)
        blob and download it from the bucket. Then it will delete the temporary 
        bucket. If a query is used, the current table_id is obtained from the 
        anonymous table created using the job configuration.
        If a table is a view or external, the extraction job doesn't work and, 
        therefore, the workaround consists in treating it as a SELECT query.
    """
    if (query is None) and ((table_id is None) or (dataset_id is None)):
        raise Exception("Either table_id, dataset_id or query should be filled.")

    savepath = Path(savepath)

    if savepath.is_dir():
        if table_id is not None:
            savepath = savepath / (table_id + ".csv")
        else:
            savepath = savepath / ("query_result.csv")
    
    # if query is not defined (so it won't be overwritten) and if 
    # table is a view or external or if limit is specified, 
    # convert it to a query.
    if not query and (not _is_table(dataset_id, table_id, project_id) or limit):
        query = f'''
        SELECT * 
          FROM {project_id}.{dataset_id}.{table_id}
        '''

        if limit is not None:
            query += f" limit {limit}"
    
    if query:
        # sql queries produces anonymous tables, whose names 
        # can be found within `job._properties`
        client = bigquery.Client()
        
        job = client.query(query)
        
        # views may take longer: wait for job to finish.
        _wait_for(job)
        
        dest_table = job._properties['configuration']['query']['destinationTable']

        project_id = dest_table['projectId']
        dataset_id = dest_table['datasetId']
        table_id = dest_table['tableId']
        
    _direct_download(dataset_id, table_id, savepath, project_id, compression)

    return

def read_sql(query, project_id="basedosdados"):
    """Load data from BigQuery using a query. Just a wrapper around pandas.read_gbq

    Args:
        query (:obj:`str`): Valid SQL Standard Query.

    Returns:
        pd.DataFrame: The query result.
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
        dataset_id (:obj:`str`): Dataset id available in project_id.
        table_id (:obj:`str`): Table id available in project_id.dataset_id.
        project_id (:obj:`str`, optional): In case you want to use to query another 
            project, defaults to 'basedosdados'
        limit (:obj:`int`, optional): Number of rows.

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

def _direct_download(
    dataset_id, 
    table_id, 
    savepath, 
    project_id='basedosdados',
    compression='GZIP',
    extract=True):
    """
    Download file to disk without the requirement of loading it in memory.

    Creates a temporary file based on the `table_id` and the time of 
    execution. Also create a temporary bucket using the `dataset_id` 
    and the time of execution. Move the table to the temporary file and 
    download it to disk. In the end, remove the temporary bucket.
    
    Args:
        dataset_id (:obj:`str`): Dataset id available in project_id. 
        table_id (:obj:`str`): Table id available in project_id.dataset_id.
        savepath (:obj:`str`, :obj:`pathlib.PosixPath`): Local path in which file should be stored in disk.
        project_id (:obj:`str`, optional): In case you want to use to query another project, by default 'basedosdados'
        compression (:obj:`str`, optional): Compression type to use for exported 
            files. Can be one of ["NONE"|"GZIP"]. Defaults to GZIP.
        extract (:obj:`bool`, optional): Whether to extract the gzip file.
            
    """

    time_hash = str(hash(time.time()))
    
    # Bucket names must start and end with a number or letter.
    tmp_file_name = table_id
    tmp_bucket_name = _clean_name(dataset_id + '_' + time_hash)
        
    blob_path = f'gs://{tmp_bucket_name}/{tmp_file_name}'

    try: 
        # create temporary bucket
        _create_bucket(tmp_bucket_name)
        
        # move table to temporary file inside temporary bucket
        _move_table_to_bucket(dataset_id, table_id, blob_path, project_id, compression)

        # download file from bucket directly to disk
        _download_blob_from_bucket(tmp_bucket_name, tmp_file_name, savepath)
        
        if compression == 'GZIP' and extract:
            _gzip_extrac(savepath)
            
    except Exception as err:
        # TODO handle exceptions for 404 (not found), 403 (forbidden)
        raise Exception(err)
    finally: 
        # delete temporary bucket (even in the case of crashing)
        _delete_bucket(tmp_bucket_name)

def _download_blob_from_bucket(
    bucket_name, 
    blob_name, 
    savepath):
    """
    Download a blob from a bucket to the path specified.

    Args:
        bucket_name (:obj:`str`): Name of the bucket for the file to be stored.
        blob_name (:obj:`str`): Name of the file to be downloaded from bucket. 
        savepath (:obj:`str`): Local path in which file should be stored in disk.
    """
    savepath = Path(savepath)
    storage_client = storage.Client()

    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(blob_name)
    
    blob.download_to_filename(savepath)
    
def _create_bucket(bucket_name):
    """
    Create a new buket in a specific location with standard storage class

    Args:
        bucket_name (:obj:`str`): Name of the bucket to be created.
    
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

    Args:
        bucket_name (:obj:`str`): Name of the bucket to be deleted.
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
    project_id='basedosdados',
    compression='GZIP'):
    """
    Move table from BigQuery to bucket

    Args:
    dataset_id : (:obj:`str`): Dataset id available in project_id.
    table_id : (:obj:`str`): Table id available in project_id.dataset_id.
    blob_path : (:obj:`str`): Path in bucket where the table will be stored. 
        Called ``destination_uri`` in the documentation in the form of 
        ``gs://<bucket_name>/<file_name.csv>``
    project_id: (:obj:`str`, optional): In case you want to use to query another 
        project, defaults to 'basedosdados'
    compression (:obj:`str`, optional): Compression type to use for exported 
            files. Can be one of ["NONE"|"GZIP"]

    """
    client = bigquery.Client()
    dataset_ref = bigquery.DatasetReference(project_id, dataset_id)
    table_ref = dataset_ref.table(table_id)

    job_config = bigquery.job.ExtractJobConfig(compression=compression)

    # perform transfer from bq to bucket
    extract_job = client.extract_table(
        table_ref,
        blob_path,
        location='US',
        job_config=job_config,
    
    )
    # wait for API results
    extract_job.result()

def _gzip_extrac(savepath):
    """ Extracts and replace gzip file 
    """
    import gzip
    import shutil

    try:
        with gzip.open(savepath, 'rb') as f_in:
            with open(savepath.with_suffix(''), 'wb') as f_out:
                shutil.copyfileobj(f_in, f_out)
            
        os.remove(savepath)
        os.rename(savepath.with_suffix(''), savepath)
    except:
        raise Exception('GZIP file could not be extracted.')
    
def _is_table(dataset_id, table_id, project_id):
    """Check whether a `table_id` is a view or not."""
    
    if (dataset_id is None) or (table_id is None):
        return False
    
    client = bigquery.Client(project=project_id)
    
    dataset_ref = bigquery.DatasetReference(project_id, dataset_id)
    table_ref = dataset_ref.table(table_id)

    table = client.get_table(table_ref)
    
    return table.table_type == 'TABLE'
    
def _clean_name(string):
    """Remove anything not a number or letter"""
    
    pattern = r'[^a-zA-Z0-9]+'
    replace = ''
    return re.sub(pattern, replace, string)

def _wait_for(job):
    """Wait for bigquery job to finish.
    
    Args:
        job (:obj:`bigquery.job`): bigquery job object from a 
        ``bigquery.Client().query()`` call.
    """
    while not job.done():
        time.sleep(1)

        
