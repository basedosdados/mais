import click

from basedosdados.base import Base
from basedosdados.dataset import Dataset
from basedosdados.table import Table
from basedosdados.storage import Storage

from basedosdados import download


@click.group()
@click.option("--templates", default=None, help="Templates path")
@click.option("--bucket_name", default=None, help="Project bucket_name name")
@click.option("--metadata_path", default=None, help="Folder to store metadata")
@click.pass_context
def cli(ctx, templates, bucket_name, metadata_path):

    ctx.obj = dict(
        templates=templates,
        bucket_name=bucket_name,
        metadata_path=metadata_path,
    )


@click.group(name="dataset")
@click.pass_context
def cli_dataset(ctx):

    pass


@cli_dataset.command(name="init", help="Initialize metadata files of dataset")
@click.argument("dataset_id")
@click.option(
    "--replace",
    is_flag=True,
    help="Whether to replace current metadata files",
)
@click.pass_context
def init_dataset(ctx, dataset_id, replace):

    d = Dataset(dataset_id=dataset_id, **ctx.obj).init(replace=replace)

    click.echo(
        click.style(
            f"Dataset `{dataset_id}` folder and metadata were created at {d.metadata_path}",
            fg="green",
        )
    )


def mode_text(mode, verb, obj_id):

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
    "--mode", "-m", default="all", help="What datasets to create [all|staging|prod]"
)
@click.option(
    "--if_exists",
    default="raise",
    help="[raise|update|replace|pass] if dataset alread exists",
)
@click.pass_context
def create_dataset(ctx, dataset_id, mode, if_exists):

    Dataset(dataset_id=dataset_id, **ctx.obj).create(mode=mode, if_exists=if_exists)

    click.echo(
        click.style(
            mode_text(mode, "created", dataset_id),
            fg="green",
        )
    )


@cli_dataset.command(name="update", help="Update dataset on BigQuery")
@click.argument("dataset_id")
@click.option(
    "--mode", "-m", default="all", help="What datasets to create [all|staging|prod]"
)
@click.pass_context
def update_dataset(ctx, dataset_id, mode):

    Dataset(dataset_id=dataset_id, **ctx.obj).update(mode=mode)

    click.echo(
        click.style(
            mode_text(mode, "updated", dataset_id),
            fg="green",
        )
    )


@cli_dataset.command(name="publicize", help="Make a dataset public")
@click.argument("dataset_id")
@click.pass_context
def publicize_dataset(ctx, dataset_id):

    Dataset(dataset_id=dataset_id, **ctx.obj).publicize()

    click.echo(
        click.style(
            f"Dataset `{dataset_id}` became public!",
            fg="green",
        )
    )


@cli_dataset.command(name="delete", help="Delete dataset")
@click.argument("dataset_id")
@click.option(
    "--mode", "-m", default="all", help="What datasets to create [all|staging|prod]"
)
@click.pass_context
def delete_dataset(ctx, dataset_id, mode):

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
    pass


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
    "--if_exists",
    default="raise",
    help="[raise|replace|pass] actions if table folder exists",
)
@click.pass_context
def init_table(ctx, dataset_id, table_id, data_sample_path, if_exists):

    t = Table(table_id=table_id, dataset_id=dataset_id, **ctx.obj).init(
        data_sample_path=data_sample_path, if_exists=if_exists
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
    "--job_config_params", default=None, help="File to advanced load config params "
)
@click.option(
    "--partitioned",
    is_flag=True,
    help="[True|False] whether folder has partitions",
)
@click.option(
    "--if_exists",
    default="raise",
    help="[raise|replace|pass] actions if table exists",
)
@click.option(
    "--force_dataset",
    default=True,
    help="Whether to automatically create the dataset folders and in BigQuery",
)
@click.pass_context
def create_table(
    ctx,
    dataset_id,
    table_id,
    path,
    job_config_params,
    partitioned,
    if_exists,
    force_dataset,
):

    Table(table_id=table_id, dataset_id=dataset_id, **ctx.obj).create(
        path=path,
        job_config_params=job_config_params,
        partitioned=partitioned,
        if_exists=if_exists,
        force_dataset=force_dataset,
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
    help="Choose a table from a dataset to update [all|staging|prod]",
)
@click.pass_context
def update_table(ctx, dataset_id, table_id, mode):

    Table(table_id=table_id, dataset_id=dataset_id, **ctx.obj).update(
        mode=mode,
    )

    click.echo(
        click.style(
            f"All tables `{dataset_id}*.{table_id}` were updated in BigQuery",
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
@click.option("--mode", help="Which table to delete [all|prod|staging]", required=True)
@click.pass_context
def delete_table(ctx, dataset_id, table_id, mode):

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
@click.pass_context
def upload_table(ctx, dataset_id, table_id, filepath, partitions, if_exists):

    blob_name = Table(dataset_id, table_id, **ctx.obj).append(
        filepath=filepath, partitions=partitions, if_exists=if_exists
    )

    click.echo(
        click.style(
            f"Data was added to `{dataset_id}.{table_id}`",
            fg="green",
        )
    )


@click.group(name="storage")
def cli_storage():
    pass


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
    "--mode", "-m", required=True, help="[raw|staging] where to save the file"
)
@click.option("--partitions", help="Data partition as `value=key/value2=key2`")
@click.option(
    "--if_exists",
    default="raise",
    help="[raise|replace|pass] if file alread exists",
)
@click.pass_context
def upload_storage(ctx, dataset_id, table_id, filepath, mode, partitions, if_exists):

    ctx.obj.pop("bucket_name")
    blob_name = Storage(dataset_id, table_id, **ctx.obj).upload(
        filepath=filepath, mode=mode, partitions=partitions, if_exists=if_exists
    )

    click.echo(
        click.style(
            f"Data was added to `{blob_name}`",
            fg="green",
        )
    )


@click.group(name="config")
def cli_config():
    pass


@cli_config.command(name="overwrite_cli_config", help="Overwrite current configuration")
@click.pass_context
def init_overwrite_cli_config(ctx):

    Base(overwrite_cli_config=True, **ctx.obj)


@cli_config.command(name="refresh_template", help="Overwrite current templates")
@click.pass_context
def init_refresh_templates(ctx):

    Base(**ctx.obj)._refresh_templates()


@click.command(
    name="download",
    help="Download data. "
    "You can add extra arguments accepted by pandas.to_csv. "
    "Examples: --delimiter='|', --index=False",
    context_settings=dict(
        ignore_unknown_options=True,
        allow_extra_args=True,
    ),
)
@click.argument("savepath", type=click.Path(exists=False))
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
    "--query",
    default=None,
    help="A SQL Standard query to download data from BigQuery",
)
@click.option(
    "--limit",
    default=None,
    help="Number of rows returned",
)
@click.pass_context
def cli_download(ctx, dataset_id, table_id, savepath, query, limit):

    pandas_kwargs = dict()
    for item in ctx.args:
        pandas_kwargs.update([item.replace("--", "").split("=")])

    download(
        savepath=savepath,
        dataset_id=dataset_id,
        table_id=table_id,
        query=query,
        limit=limit,
        **pandas_kwargs,
    )

    click.echo(
        click.style(
            f"Table was downloaded to `{savepath}`",
            fg="green",
        )
    )


cli.add_command(cli_dataset)
cli.add_command(cli_table)
cli.add_command(cli_storage)
cli.add_command(cli_config)
cli.add_command(cli_download)

if __name__ == "__main__":

    cli()