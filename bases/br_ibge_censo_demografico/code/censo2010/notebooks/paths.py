import os
import sys

import sys

sys.path.insert(0, "../")
# from google.cloud import bigquery
# import pandas as pd


# def list_tables(dataset_id, project_id='basedosdados', pattern=None):
#     """
#     List tables inside a dataset_id
#     Parameters
#     ----------
#     dataset_id : str
#         Dataset id available in basedosdados. It should always come with table_id.
#     project_id: str, optional
#         In case you want to use to query another project, by default 'basedosdados'
#     pattern: str, optional
#         Regular expression to look within `dataset_id`.
#     Returns
#     -------
#     pd.DataFrame
#         List of `table_id` within the `dataset_id`
#     """
#     client = bigquery.Client(project=project_id)

#     tables_list = client.list_tables(dataset_id)

#     result = pd.DataFrame(dict(
#         table_id=[table.table_id for table in tables_list]
#     ))
#     # filter tables using Regex
#     if pattern:
#         result = result.loc[result['table_id'].str.contains(pattern)]

#     return result

# def list_datasets(project_id='basedosdados', pattern=None):
#     """
#     List `dataset_id`'s inside a `project_id`
#     Parameters
#     ----------
#     pattern: str, optional
#         Regular expression to look within `dataset_id`.
#     Returns
#     -------
#     pd.DataFrame
#         List of `table_id` within the `dataset_id`
#     """

#     client = bigquery.Client(project=project_id)
#     datasets_list = client.list_datasets()

#     result = pd.DataFrame(dict(
#         dataset_id=[table.dataset_id for table in datasets_list]
#     ))

#     # filter tables using Regex
#     if pattern:
#         result = result.loc[result['dataset_id'].str.contains(pattern)]

#     return result

# def metadata(dataset_id, table_id, project_id='basedosdados'):
#     """
#     Display column types and descriptions from `table_id`

#     Parameters
#     ----------
#     dataset_id : str
#         Dataset id available in basedosdados. It should always come with table_id.
#     table_id : str
#         Table id available in basedosdados.dataset_id.
#         It should always come with dataset_id.
#     project_id: str, optional
#         In case you want to use to query another project, by default 'basedosdados'
#     Returns
#     -------
#     pd.DataFrame
#         Column types and descriptions
#     """
#     client = bigquery.Client(project=project_id)
#     table_name = f'{project_id}.{dataset_id}.{table_id}'

#     table = client.get_table(table_name)
#     description = [
#         (col.name, col.field_type, col.description) for col in table.schema
#             ]

#     return pd.DataFrame(description, columns=['columns', 'type','description'])


# def info(dataset_id, table_id, project_id='basedosdados', pretty=True):
#     """
#     Display metadata about the specified `table_id`
#     Parameters
#     ----------
#     dataset_id : str
#         Dataset id available in basedosdados. It should always come with table_id.
#     table_id : str
#         Table id available in basedosdados.dataset_id.
#         It should always come with dataset_id.
#     project_id: str, optional
#         In case you want to use to query another project, by default 'basedosdados'
#     pretty: bool, optional
#         Whether to return values as raw data (for calculation purposes) or
#         pretty formatted.
#     Returns
#     -------
#     pd.DataFrame
#         Metadata information about the table
#     """
#     client = bigquery.Client()
#     table_name = f'{project_id}.{dataset_id}.{table_id}'

#     table = client.get_table(table_name)

#     # as tables are views, using table.num_rows returns 0
#     # nrows = table.num_rows
#     # nbytes = table.num_bytes

#     job = client.query(
#         f'SELECT COUNT(*) FROM {table_name}',
#         location='US'
#     )
#     nrows = job.to_dataframe().loc[0, 'f0_']
#     nbytes = job.total_bytes_processed

#     name = table.table_id
#     dataset = table.dataset_id
#     fullname = table.full_table_id
#     location = table.location
#     anomes_created = table.created.date()
#     time_created = table.created.time()

#     if pretty:
#         nrows = f'{nrows:,}'
#         nbytes = _pretty_format(nbytes, 'bytes')
#         anomes_created = str(table.created.year) + \
#                 '/' + str(table.created.month).zfill(2) + \
#                 '/' + str(table.created.day).zfill(2)
#         time_created = str(table.created.hour) + \
#             ':' + str(table.created.minute).zfill(2)

#     data = pd.DataFrame({'nrows': [nrows],
#                          'size': [nbytes],
#                          'table_name':[name],
#                          'dataset_name':[dataset],
#                          'date_created':[anomes_created],
#                          'time_created':[time_created],
#                          'full_table_name':[fullname],
#                          'table_location':[location]}, index=['value']).T
#     return data

# def _pretty_format(value, category='value'):
#     """
#     Converts unfriendly formats to human readable.
#     Parameters
#     ----------
#     value : int, float
#         The value to be formatted.
#     category : str, optional
#         The type of value.
#         Currently allowed categories are:
#         - 'value' for numbers to be written as 80K, 80M, 80B
#         - 'bytes' for numbers to be written as 1MB, 1kB, 1GB
#     Returns
#     -------
#     str
#         formatted value
#     """
#     if category == 'value':
#         units = ['','K','M','B']
#         decimal_places = {'' : 0,
#                           'K':1,
#                           'M':1,
#                           'B':1
#                         }
#         cutoff = 1000
#     elif category == 'bytes':
#         units = ['B','kB','MB','GB','TB']
#         decimal_places = {'B' : 3,
#                           'kB':2,
#                           'MB':1,
#                           'GB':1,
#                           'TB':1
#                             }
#         cutoff = 1024
#     else:

#         raise NotImplementedError()

#     def _human_readable_size(size,
#                             units=units,
#                             decimal_places=decimal_places):
#         for unit in units:
#             if size < cutoff:
#                 break
#             size /= cutoff

#         return f"{size:.{decimal_places[unit]}f}{unit}"

#     return _human_readable_size(value)

# def _retrieve_information_schema(dataset_id, project_id='basedosdados'):
#     client = bigquery.Client()
#     job = client.query(
#         f'SELECT * FROM `{project_id}.{dataset_id}.INFORMATION_SCHEMA.VIEWS`'
#     )
#     return job.to_dataframe()
