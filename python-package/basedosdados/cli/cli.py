"""
CLI package for the application.
"""

# pylint: disable=locally-disabled, multiple-statements, fixme, line-too-long, too-many-arguments, invalid-name, too-many-lines, protected-access, unused-argument, no-value-for-parameter, redefined-builtin

import click
from basedosdados.upload.base import Base
from basedosdados.upload.dataset import Dataset
from basedosdados.upload.table import Table
from basedosdados.upload.storage import Storage
from basedosdados.upload.metadata import Metadata

import basedosdados as bd
from basedosdados.exceptions import BaseDosDadosException
from ckanapi import CKANAPIError


@click.group()
@click.option("--templates", default=None, help="Templates path")
@click.option("--bucket_name", default=None, help="Project bucket name")
@click.option("--metadata_path", default=None, help="Folder to store metadata")
@click.version_option(package_name="basedosdados")
@click.pass_context
def cli(ctx, templates, bucket_name, metadata_path):
    """
    Function to define the CLI.
    """

    ctx.obj = dict(
        templates=templates,
        bucket_name=bucket_name,
        metadata_path=metadata_path,
    )


@click.group(name="dataset")
@click.pass_context
def cli_dataset(ctx):
    """
    Command to manage datasets.
    """


@cli_dataset.command(name="init", help="Initialize metadata files of dataset")
@click.argument("dataset_id")
@click.option(
    "--replace",
    is_flag=True,
    help="Whether to replace current metadata files",
)
@click.pass_context
def init_dataset(ctx, dataset_id, replace):
    """
    Initialize metadata files of dataset.
    """

    d = Dataset(dataset_id=dataset_id, **ctx.obj).init(replace=replace)

    click.echo(
        click.style(
            f"Dataset `{dataset_id}` folder and metadata were created at {d.metadata_path}",
            fg="green",
        )
    )


def mode_text(mode, verb, obj_id):
    """
    Returns a specific text for each mode.
    """

    if mode == "all":
        text = f"Datasets `{obj_id}` and `{obj_id}_staging` were {verb} in BigQuery"
    elif mode == "staging":
        text = f"Dataset `{obj_id}_stating` was {verb} in BigQuery"
    elif mode == "prod":
        text = f"Dataset `{obj_id}` was {verb} in BigQuery"

    return text


@cli_dataset.command(name="create", help="Create dataset on BigQuery")
@click.argument("dataset_id")
@click.option(
    "--mode", "-m", default="all", help="What datasets to create [prod|staging|all]"
)
@click.option(
    "--if_exists",
    default="raise",
    help="[raise|update|replace|pass] if dataset alread exists",
)
@click.option(
    "--dataset_is_public",
    default=True,
    help="Control if prod dataset is public or not. By default staging datasets like `dataset_id_staging` are not public.",
)
@click.option(
    "--location",
    default=None,
    help="Location of dataset data. List of possible region names locations: https://cloud.google.com/bigquery/docs/locations",
)
@click.pass_context
def create_dataset(ctx, dataset_id, mode, if_exists, dataset_is_public, location):
    """
    Create dataset on BigQuery.
    """

    Dataset(dataset_id=dataset_id, **ctx.obj).create(
        mode=mode,
        if_exists=if_exists,
        dataset_is_public=dataset_is_public,
        location=location,
    )

    click.echo(
        click.style(
            mode_text(mode, "created", dataset_id),
            fg="green",
        )
    )


@cli_dataset.command(name="update", help="Update dataset on BigQuery")
@click.argument("dataset_id")
@click.option(
    "--mode", "-m", default="all", help="What datasets to create [prod|staging|all]"
)
@click.pass_context
def update_dataset(ctx, dataset_id, mode, location):
    """
    Update dataset on BigQuery.
    """

    Dataset(dataset_id=dataset_id, **ctx.obj).update(mode=mode, location=location)

    click.echo(
        click.style(
            mode_text(mode, "updated", dataset_id),
            fg="green",
        )
    )


@cli_dataset.command(name="publicize", help="Make a dataset public")
@click.argument("dataset_id")
@click.option(
    "--dataset_is_public",
    default=True,
    help="Control if prod dataset is public or not. By default staging datasets like `dataset_id_staging` are not public.",
)
@click.pass_context
def publicize_dataset(ctx, dataset_id, dataset_is_public):
    """
    Publicize dataset.
    """

    Dataset(dataset_id=dataset_id, **ctx.obj).publicize(
        dataset_is_public=dataset_is_public
    )

    click.echo(
        click.style(
            f"Dataset `{dataset_id}` became public!",
            fg="green",
        )
    )


@cli_dataset.command(name="delete", help="Delete dataset")
@click.argument("dataset_id")
@click.option(
    "--mode", "-m", default="all", help="What datasets to create [prod|staging|all]"
)
@click.pass_context
def delete_dataset(ctx, dataset_id, mode):
    """
    Delete dataset.
    """

    if click.confirm(f"Are you sure you want to delete `{dataset_id}`?"):

        Dataset(dataset_id=dataset_id, **ctx.obj).delete(mode=mode)

    click.echo(
        click.style(
            mode_text(mode, "deleted", dataset_id),
            fg="green",
        )
    )


@click.group(name="table")
def cli_table():
    """
    Command to manage tables.
    """


@cli_table.command(name="init", help="Create metadata files")
@click.argument("dataset_id")
@click.argument("table_id")
@click.option(
    "--data_sample_path",
    default=None,
    help="Sample data used to pre-fill metadata",
    type=click.Path(exists=True),
)
@click.option(
    "--if_folder_exists",
    default="raise",
    help="[raise|replace|pass] actions if table folder exists",
)
@click.option(
    "--if_table_config_exists",
    default="raise",
    help="[raise|replace|pass] actions if table config files already exist",
)
@click.option(
    "--source_format",
    default="csv",
    help="Data source format. Only 'csv' is supported. Defaults to 'csv'.",
)
@click.option(
    "--force_columns",
    default=False,
    help="Overwrite columns with local columns.",
)
@click.option(
    "--columns_config_url_or_path",
    default=None,
    help="google sheets URL. Must be in the format https://docs.google.com/spreadsheets/d/<table_key>/edit#gid=<table_gid>. The sheet must contain the column name: 'coluna' and column description: 'descricao'.",
)
@click.pass_context
def init_table(
    ctx,
    dataset_id,
    table_id,
    data_sample_path,
    if_folder_exists,
    if_table_config_exists,
    source_format,
    force_columns,
    columns_config_url_or_path,
):
    """
    Initialize table metadata.
    """

    t = Table(table_id=table_id, dataset_id=dataset_id, **ctx.obj).init(
        data_sample_path=data_sample_path,
        if_folder_exists=if_folder_exists,
        if_table_config_exists=if_table_config_exists,
        source_format=source_format,
        force_columns=force_columns,
        columns_config_url_or_path=columns_config_url_or_path,
    )

    click.echo(
        click.style(
            f"Table `{table_id}` folder and metadata were created at {t.metadata_path}{dataset_id}",
            fg="green",
        )
    )


@cli_table.command(name="create", help="Create stagging table in BigQuery")
@click.argument("dataset_id")
@click.argument("table_id")
@click.option(
    "--path",
    "-p",
    type=click.Path(exists=True),
    default=None,
    help="Path of data folder or file.",
)
@click.option(
    "--if_table_exists",
    default="raise",
    help="[raise|replace|pass] actions if table exists",
)
@click.option(
    "--force_dataset",
    default=True,
    help="Whether to automatically create the dataset folders and in BigQuery",
)
@click.option(
    "--if_storage_data_exists",
    default="raise",
    help="[raise|replace|pass] actions if table data already exists at Storage",
)
@click.option(
    "--if_table_config_exists",
    default="raise",
    help="[raise|replace|pass] actions if table config files already exist",
)
@click.option(
    "--source_format",
    default="csv",
    help="Data source format. Only 'csv' is supported. Defaults to 'csv'.",
)
@click.option(
    "--force_columns",
    default=False,
    help="Overwrite columns with local columns.",
)
@click.option(
    "--columns_config_url_or_path",
    default=None,
    help="Path to the local architeture file or a public google sheets URL. Path only suports csv, xls, xlsx, xlsm, xlsb, odf, ods, odt formats. Google sheets URL must be in the format https://docs.google.com/spreadsheets/d/<table_key>/edit#gid=<table_gid>.",
)
@click.option(
    "--dataset_is_public",
    default=True,
    help="Control if prod dataset is public or not. By default staging datasets like `dataset_id_staging` are not public.",
)
@click.option(
    "--location",
    default=None,
    help="Location of dataset data. List of possible region names locations: https://cloud.google.com/bigquery/docs/locations",
)
@click.option(
    "--chunk_size",
    default=None,
    help="The size of a chunk of data whenever iterating (in bytes). This must be a multiple of 256 KB per the API specification.",
)
@click.pass_context
def create_table(
    ctx,
    dataset_id,
    table_id,
    path,
    if_table_exists,
    force_dataset,
    if_storage_data_exists,
    if_table_config_exists,
    source_format,
    force_columns,
    columns_config_url_or_path,
    dataset_is_public,
    location,
    chunk_size,
):

    """
    Create staging table in BigQuery.
    """

    Table(table_id=table_id, dataset_id=dataset_id, **ctx.obj).create(
        path=path,
        if_table_exists=if_table_exists,
        force_dataset=force_dataset,
        if_storage_data_exists=if_storage_data_exists,
        if_table_config_exists=if_table_config_exists,
        source_format=source_format,
        force_columns=force_columns,
        columns_config_url_or_path=columns_config_url_or_path,
        dataset_is_public=dataset_is_public,
        location=location,
        chunk_size=chunk_size,
    )

    click.echo(
        click.style(
            f"Table `{dataset_id}_staging.{table_id}` was created in BigQuery",
            fg="green",
        )
    )


@cli_table.command(name="update", help="Update tables in BigQuery")
@click.argument("dataset_id")
@click.argument("table_id")
@click.option(
    "--mode",
    default="all",
    help="Choose a table from a dataset to update [prod|staging|all]",
)
@click.pass_context
def update_table(ctx, dataset_id, table_id, mode):
    """
    Update tables in BigQuery.
    """

    Table(table_id=table_id, dataset_id=dataset_id, **ctx.obj).update(
        mode=mode,
    )

    click.echo(
        click.style(
            f"All tables `{dataset_id}*.{table_id}` were updated in BigQuery",
            fg="green",
        )
    )


@cli_table.command(
    name="update_columns", help="Update columns fields in tables_config.yaml "
)
@click.argument("dataset_id")
@click.argument("table_id")
@click.option(
    "--columns_config_url_or_path",
    default=None,
    help="""\nFills columns in table_config.yaml automatically using a public google sheets URL or a local file. Also regenerate
        \npublish.sql and autofill type using bigquery_type.\n

    \nThe sheet must contain the columns:\n
        - name: column name\n
        - description: column description\n
        - bigquery_type: column bigquery type\n
        - measurement_unit: column mesurement unit\n
        - covered_by_dictionary: column related dictionary\n
        - directory_column: column related directory in the format <dataset_id>.<table_id>:<column_name>\n
        - temporal_coverage: column temporal coverage\n
        - has_sensitive_data: the column has sensitive data\n
        - observations: column observations\n
    \nArgs:\n
    \ncolumns_config_url_or_path (str): Path to the local architeture file or a public google sheets URL.\n
        Path only suports csv, xls, xlsx, xlsm, xlsb, odf, ods, odt formats.\n
        Google sheets URL must be in the format https://docs.google.com/spreadsheets/d/<table_key>/edit#gid=<table_gid>.\n
""",
)
@click.pass_context
def update_columns(ctx, dataset_id, table_id, columns_config_url_or_path):
    """
    Update columns fields in tables_config.yaml
    """

    Table(table_id=table_id, dataset_id=dataset_id, **ctx.obj).update_columns(
        columns_config_url_or_path=columns_config_url_or_path,
    )

    click.echo(
        click.style(
            f"Columns from `{dataset_id}.{table_id}` were updated in table_config.yaml",
            fg="green",
        )
    )


@cli_table.command(name="publish", help="Publish staging table to prod")
@click.argument("dataset_id")
@click.argument("table_id")
@click.option(
    "--if_exists",
    default="raise",
    help="[raise|replace] actions if table exists",
)
@click.pass_context
def publish_table(ctx, dataset_id, table_id, if_exists):
    """
    Publish staging table to prod.
    """

    Table(table_id=table_id, dataset_id=dataset_id, **ctx.obj).publish(
        if_exists=if_exists,
    )

    click.echo(
        click.style(
            f"Table `{dataset_id}.{table_id}` was published in BigQuery",
            fg="green",
        )
    )


@cli_table.command(name="delete", help="Delete BigQuery table")
@click.argument("dataset_id")
@click.argument("table_id")
@click.option("--mode", help="Which table to delete [prod|staging]", required=True)
@click.pass_context
def delete_table(ctx, dataset_id, table_id, mode):
    """
    Delete BigQuery table.
    """

    Table(table_id=table_id, dataset_id=dataset_id, **ctx.obj).delete(
        mode=mode,
    )


@cli_table.command(name="append", help="Append new data to existing table")
@click.argument("dataset_id")
@click.argument("table_id")
@click.argument("filepath", type=click.Path(exists=True))
@click.option("--partitions", help="Data partition as `value=key/value2=key2`")
@click.option(
    "--if_exists",
    default="raise",
    help="[raise|replace|pass] if file alread exists",
)
@click.option(
    "--chunk_size",
    default=None,
    help="The size of a chunk of data whenever iterating (in bytes). This must be a multiple of 256 KB per the API specification.",
)
@click.pass_context
def upload_table(
    ctx, dataset_id, table_id, filepath, partitions, if_exists, chunk_size
):

    """
    Upload data to BigQuery table.
    """
    Table(table_id=table_id, dataset_id=dataset_id, **ctx.obj).append(
        filepath=filepath,
        partitions=partitions,
        if_exists=if_exists,
        chunk_size=chunk_size,
    )

    click.echo(
        click.style(
            f"Data was added to `{dataset_id}.{table_id}`",
            fg="green",
        )
    )


@click.group(name="storage")
def cli_storage():
    """
    Commands for Google Cloud Storage.
    """


@cli_storage.command(name="init", help="Create bucket and initial folders")
@click.option("--bucket_name", default="basedosdados", help="Bucket name")
@click.option(
    "--replace",
    is_flag=True,
    help="Whether to replace current bucket files",
)
@click.option(
    "--very-sure/--not-sure",
    default=False,
    help="Are you sure that you want to replace current bucket files?",
)
@click.pass_context
def init_storage(ctx, bucket_name, replace, very_sure):
    """
    Initialize bucket and folders.
    """

    # TODO: Create config file to store bucket_name, etc...
    ctx.obj.pop("bucket_name")
    Storage(bucket_name=bucket_name, **ctx.obj).init(
        replace=replace, very_sure=very_sure
    )

    click.echo(
        click.style(
            f"Bucket `{bucket_name}` was created",
            fg="green",
        )
    )


@cli_storage.command(name="upload", help="Upload file to bucket")
@click.argument("dataset_id")
@click.argument("table_id")
@click.argument("filepath", type=click.Path(exists=True))
@click.option(
    "--mode",
    "-m",
    required=True,
    help="Where to save the file [raw|staging|header|auxiliary_files|architecture|all]",
)
@click.option("--partitions", help="Data partition as `value=key/value2=key2`")
@click.option(
    "--if_exists",
    default="raise",
    help="[raise|replace|pass] if file alread exists",
)
@click.option(
    "--chunk_size",
    default=None,
    help="The size of a chunk of data whenever iterating (in bytes). This must be a multiple of 256 KB per the API specification.",
)
@click.pass_context
def upload_storage(
    ctx, dataset_id, table_id, filepath, mode, partitions, if_exists, chunk_size
):

    '''
    Upload file to bucket.
    '''

    ctx.obj.pop("bucket_name")
    Storage(dataset_id, table_id, **ctx.obj).upload(
        filepath=filepath,
        mode=mode,
        partitions=partitions,
        if_exists=if_exists,
        chunk_size=chunk_size,
    )

    click.echo(
        click.style(
            "Data was added",
            fg="green",
        )
    )


@cli_storage.command(name="download", help="Download file from bucket")
@click.argument("dataset_id")
@click.argument("table_id")
@click.argument("savepath", type=click.Path(exists=True))
@click.option(
    "--filename",
    "-f",
    default="*",
    help="filename to download single file. If * downloads all files from bucket folder",
)
@click.option(
    "--mode",
    "-m",
    default="raw",
    help="Where to download data from [raw|staging|header|auxiliary_files|architecture]",
)
@click.option("--partitions", help="Data partition as `value=key/value2=key2`")
@click.option(
    "--if_not_exists",
    default="raise",
    help="[raise|pass] if file file not found at bucket folder",
)
@click.pass_context
def download_storage(
    ctx, dataset_id, table_id, filename, savepath, partitions, mode, if_not_exists
):
    """
    Download file from bucket.
    """
    Storage(dataset_id, table_id, **ctx.obj).download(
        filename, savepath, partitions, mode, if_not_exists
    )

    click.echo(
        click.style(
            f"Data was downloaded to `{savepath}`",
            fg="green",
        )
    )


@cli_storage.command(name="delete_table", help="Delete table from bucket")
@click.argument("dataset_id")
@click.argument("table_id")
@click.option(
    "--mode",
    "-m",
    required=True,
    default="staging",
    help="Where to delete the file from [raw|staging|header|auxiliary_files|architecture]",
)
@click.option(
    "--bucket_name",
    default=None,
    help="Bucket from which to delete data, you can change it to delete from a bucket other than yours",
)
@click.option("--not_found_ok", default=False, help="what to do if table not found")
@click.pass_context
def storage_delete_table(ctx, dataset_id, table_id, mode, not_found_ok, bucket_name):
    """
    Delete table from bucket.
    """
    Storage(dataset_id, table_id, **ctx.obj).delete_table(
        mode=mode, not_found_ok=not_found_ok, bucket_name=bucket_name
    )
    click.echo(
        click.style(
            f"Data was deleted from bucket `{bucket_name}`",
            fg="green",
        )
    )


@cli_storage.command(name="copy_table", help="Copy table to your bucket")
@click.argument("dataset_id")
@click.argument("table_id")
@click.option("--source_bucket_name", required=True, default="basedosdados")
@click.option(
    "--dst_bucket_name",
    default=None,
    help="Bucket where data will be copied to, defaults to your bucket",
)
@click.option(
    "--mode",
    "-m",
    default="staging",
    help="which bucket folder to get the table [raw|staging|header|auxiliary_files|architecture]",
)
@click.pass_context
def storage_copy_table(
    ctx, dataset_id, table_id, source_bucket_name, dst_bucket_name, mode
):
    """
    Copy table from another bucket.
    """
    Storage(dataset_id, table_id, **ctx.obj).copy_table(
        source_bucket_name=source_bucket_name,
        destination_bucket_name=dst_bucket_name,
        mode=mode,
    )


@click.group(name="list")
def cli_list():
    """
    CLI list commands.
    """


@cli_list.command(name="datasets", help="List datasets available at given project_id")
@click.option(
    "--project_id",
    default="basedosdados",
    help="The project which will be queried. You should have list/read permissions",
)
@click.option(
    "--filter_by",
    default=None,
    help="Filter your search, must be a string",
)
@click.option(
    "--with_description",
    default=False,
    help="[bool]Fetch short description for each dataset",
)
@click.pass_context
def cli_list_datasets(ctx, project_id, filter_by, with_description):
    """
    List datasets available at given project_id
    """
    bd.list_datasets(
        query_project_id=project_id,
        filter_by=filter_by,
        with_description=with_description,
    )


@cli_list.command(name="dataset_tables", help="List tables available at given dataset")
@click.argument("dataset_id")
@click.option(
    "--project_id",
    default="basedosdados",
    help="The project which will be queried. You should have list/read permissions",
)
@click.option(
    "--filter_by",
    default=None,
    help="Filter your search, must be a string",
)
@click.option(
    "--with_description",
    default=False,
    help="[bool]Fetch short description for each table",
)
@click.pass_context
def cli_list_dataset_tables(ctx, dataset_id, project_id, filter_by, with_description):
    """
    List tables available at given dataset.
    """
    bd.list_dataset_tables(
        dataset_id=dataset_id,
        query_project_id=project_id,
        filter_by=filter_by,
        with_description=with_description,
    )


@click.group(name="get")
def cli_get():
    """
    Get commands.
    """


@cli_get.command(
    name="dataset_description", help="Get the full description for given dataset"
)
@click.argument("dataset_id")
@click.option(
    "--project_id",
    default="basedosdados",
    help="The project which will be queried. You should have list/read permissions",
)
@click.pass_context
def cli_get_dataset_description(ctx, dataset_id, project_id):
    """
    Get the full description for given dataset
    """
    bd.get_dataset_description(
        dataset_id=dataset_id,
        query_project_id=project_id,
    )


@cli_get.command(
    name="table_description", help="Get the full description for given table"
)
@click.argument("dataset_id")
@click.argument("table_id")
@click.option(
    "--project_id",
    default="basedosdados",
    help="The project which will be queried. You should have list/read permissions",
)
@click.pass_context
def cli_get_table_description(ctx, dataset_id, table_id, project_id):
    """
    Get the full description for given table
    """
    bd.get_table_description(
        dataset_id=dataset_id,
        table_id=table_id,
        query_project_id=project_id,
    )


@cli_get.command(
    name="table_columns",
    help="Get fields names,types and description for columns at given table",
)
@click.argument("dataset_id")
@click.argument("table_id")
@click.option(
    "--project_id",
    default="basedosdados",
    help="The project which will be queried. You should have list/read permissions",
)
@click.pass_context
def cli_get_table_columns(
    ctx,
    dataset_id,
    table_id,
    project_id,
):
    """
    Get fields names,types and description for columns at given table
    """
    bd.get_table_columns(
        dataset_id=dataset_id,
        table_id=table_id,
        query_project_id=project_id,
    )


@click.group(name="metadata")
def cli_metadata():
    """
    CLI metadata commands.
    """


@cli_metadata.command(name="create", help="Creates new metadata config file")
@click.argument("dataset_id")
@click.argument("table_id", required=False)
@click.option(
    "--if_exists",
    default="raise",
    help="[raise|replace|pass] if metadata config file alread exists",
)
@click.option(
    "--columns",
    default=[],
    help="Data columns. Example: --columns=col1,col2",
    callback=lambda _, __, x: x.split(",") if x else [],
)
@click.option(
    "--partition_columns",
    default=[],
    help="Columns that partition the data. Example: --partition_columns=col1,col2",
    callback=lambda _, __, x: x.split(",") if x else [],
)
@click.option(
    "--force_columns",
    default=False,
    help="Overwrite columns with local columns.",
)
@click.option(
    "--table_only",
    default=True,
    help=(
        "Force the creation of `table_config.yaml` file only if `dataset_conf"
        "ig.yaml` doesn't exist."
    ),
)
@click.pass_context
def cli_create_metadata(
    ctx,
    dataset_id,
    table_id,
    if_exists,
    columns,
    partition_columns,
    force_columns,
    table_only,
):
    """
    Creates new metadata config file.
    """

    m = Metadata(dataset_id, table_id, **ctx.obj).create(
        if_exists=if_exists,
        columns=columns,
        partition_columns=partition_columns,
        force_columns=force_columns,
        table_only=table_only,
    )

    click.echo(
        click.style(
            f"Metadata file was created at `{m.filepath}`",
            fg="green",
        )
    )


@cli_metadata.command(
    name="is_updated", help="Check if user's local metadata is updated"
)
@click.argument("dataset_id")
@click.argument("table_id", required=False)
@click.pass_context
def cli_is_updated_metadata(ctx, dataset_id, table_id):
    """
    Check if user's local metadata is updated.
    """
    m = Metadata(dataset_id, table_id, **ctx.obj)

    if m.is_updated():
        msg, color = "Local metadata is updated.", "green"
    else:
        msg = (
            "Local metadata is out of date. Please run `basedosdados metadata"
            " create` with the flag `if_exists=replace` to get the updated da"
            "ta."
        )
        color = "red"

    click.echo(click.style(msg, fg=color))


@cli_metadata.command(name="validate", help="Validate user's local metadata")
@click.argument("dataset_id")
@click.argument("table_id", required=False)
@click.pass_context
def cli_validate_metadata(ctx, dataset_id, table_id):
    """
    Validate user's local metadata.
    """
    m = Metadata(dataset_id, table_id, **ctx.obj)

    try:
        m.validate()
        msg, color = "Local metadata is valid.", "green"
    except BaseDosDadosException as e:
        msg = (
            f"Local metadata is invalid. Please check the traceback below for"
            f" more information on how to fix it:\n\n{repr(e)}"
        )
        color = "red"

    click.echo(click.style(msg, fg=color))


@cli_metadata.command(name="publish", help="Publish user's local metadata")
@click.argument("dataset_id")
@click.argument("table_id", required=False)
@click.option(
    "--all",
    default=False,
    help=(
        "Force the publishment of metadata specified in both `dataset_config."
        "yaml` and `table_config.yaml` at once."
    ),
)
@click.option(
    "--if_exists",
    default="raise",
    help=("Define what to do in case metadata already exists in CKAN."),
)
@click.option(
    "--update_locally",
    default=False,
    help=("Update local metadata with the new CKAN metadata on publish."),
)
@click.pass_context
def cli_publish_metadata(
    ctx,
    dataset_id,
    table_id,
    all,
    if_exists,
    update_locally,
):
    """
    Publish user's local metadata.
    """
    m = Metadata(dataset_id, table_id, **ctx.obj)

    try:
        m.publish(all=all, if_exists=if_exists, update_locally=update_locally)
        msg, color = "Local metadata has been published.", "green"
    except (CKANAPIError, BaseDosDadosException, AssertionError) as e:
        msg = (
            f"Local metadata couldn't be published due to an error. Pleas"
            f"e check the traceback below for more information on how to "
            f"fix it:\n\n{repr(e)}"
        )
        color = "red"

    click.echo(click.style(msg, fg=color))


@click.group(name="config")
def cli_config():
    """
    CLI config commands.
    """


@cli_config.command(name="init", help="Initialize configuration")
@click.option(
    "--overwrite",
    default=False,
    help="Wheteher to overwrite current config",
)
@click.pass_context
def init(ctx, overwrite):
    """
    Initialize configuration.
    """

    Base(overwrite_cli_config=overwrite, **ctx.obj)


@cli_config.command(name="refresh_template", help="Overwrite current templates")
@click.pass_context
def init_refresh_templates(ctx):
    """
    Initialize configuration.
    """

    Base(**ctx.obj)._refresh_templates()


# Allow anomalous backslash in string: '\ ' (it's used in gcloud sdk)
# pylint: disable=W1401
@click.command(
    name="download",
    help=(
        "Downloads data do SAVEPATH. SAVEPATH must point to a .csv file.\n\n"
        "Example: \n\n"
        'basedosdados download data.csv  --query="select * from basedosdados.br_ibge_pib.municipio limit 10" \ --billing_project_id=basedosdados-dev'
    ),
)
@click.argument(
    "savepath",
    type=click.Path(exists=False),
)
@click.option(
    "--query",
    default=None,
    help="A SQL Standard query to download data from BigQuery",
)
@click.option(
    "--dataset_id",
    default=None,
    help="Dataset_id, enter with table_id to download table",
)
@click.option(
    "--table_id",
    default=None,
    help="Table_id, enter with dataset_id to download table ",
)
@click.option(
    "--query_project_id",
    default=None,
    help="Which project the table lives. You can change this you want to query different projects.",
)
@click.option(
    "--billing_project_id",
    default=None,
    help="Project that will be billed. Find your Project ID here https://console.cloud.google.com/projectselector2/home/dashboard",
)
@click.option(
    "--limit",
    default=None,
    help="Number of rows returned",
)
@click.pass_context
def cli_download(
    ctx,
    savepath,
    query,
    dataset_id,
    table_id,
    query_project_id,
    billing_project_id,
    limit,
):
    """
    Download data from BigQuery.
    """

    bd.download(
        savepath=savepath,
        dataset_id=dataset_id,
        table_id=table_id,
        query=query,
        query_project_id=query_project_id,
        billing_project_id=billing_project_id,
        limit=limit,
    )

    click.echo(
        click.style(
            f"Table was downloaded to `{savepath}`",
            fg="green",
        )
    )


@click.command(
    name="reauth",
    help="Reauthorize credentials.",
)
def cli_reauth():
    """
    Reauthorize credentials.
    """

    bd.reauth()


cli.add_command(cli_dataset)
cli.add_command(cli_table)
cli.add_command(cli_storage)
cli.add_command(cli_config)
cli.add_command(cli_download)
cli.add_command(cli_reauth)
cli.add_command(cli_list)
cli.add_command(cli_get)
cli.add_command(cli_metadata)


if __name__ == "__main__":

    cli()
