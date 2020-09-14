import click

from src.core import Base, Dataset, Table


@click.group()
@click.option(
    "--key_path", default="secrets/cli-admin.json", help="Gcloud key json file"
)
@click.option("--templates", default="src/templates", help="Templates path")
@click.option("--bucket", default="basedosdados", help="Project bucket name")
@click.option("--metadata_path", default="bases/", help="Folder to store metadata")
@click.pass_context
def cli(ctx, key_path, templates, bucket, metadata_path):

    cli.add_command(cli_dataset)
    cli.add_command(cli_table)

    ctx.obj = dict(
        key_path="secrets/cli-admin.json",
        templates="src/templates",
        bucket="basedosdados",
        metadata_path="bases/",
    )


@click.group(name="dataset")
@click.pass_context
def cli_dataset(ctx):

    pass


@cli_dataset.command(name="init", help="Initialize metadata files of dataset")
@click.argument("dataset_id")
@click.option(
    "--replace/--no-replace",
    default=False,
    help="Whether to replace current metadata files",
)
@click.pass_context
def init_dataset(ctx, dataset_id, replace):

    Dataset(dataset_id=dataset_id, **ctx.obj).init(replace=replace)

    click.echo(
        click.style(
            f"Dataset `{dataset_id}` folder and metadata were created at {ctx.obj['metadata_path']}",
            fg="green",
        )
    )


@cli_dataset.command(name="create", help="Create dataset on BigQuery")
@click.argument("dataset_id")
@click.option(
    "--create_staging", default=True, help="Whether to create the staging dataset"
)
@click.option(
    "--if_exists", default="raise", help="[raise, update] if dataset alread exists"
)
@click.pass_context
def create_dataset(ctx, dataset_id, create_staging, if_exists):

    Dataset(dataset_id=dataset_id, **ctx.obj).create(
        create_staging=create_staging, if_exists=if_exists
    )

    if create_staging:
        text = f"Datasets `{dataset_id}` and `stagging_{dataset_id}` were created in BigQuery"
    else:
        text = f"Dataset `{dataset_id}`  was created in BigQuery"

    click.echo(
        click.style(
            text,
            fg="green",
        )
    )


@cli_dataset.command(name="update", help="Update dataset on BigQuery")
@click.argument("dataset_id")
@click.option(
    "--update_staging", default=True, help="Whether to update the staging dataset"
)
@click.pass_context
def update_dataset(ctx, dataset_id, update_staging):

    Dataset(dataset_id=dataset_id, **ctx.obj).update(update_staging=update_staging)

    if update_staging:
        text = f"Datasets `{dataset_id}` and `stagging_{dataset_id}` were updated in BigQuery"
    else:
        text = f"Dataset `{dataset_id}`  was updated in BigQuery"

    click.echo(
        click.style(
            text,
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
    "--data_sample_path", default=None, help="Sample data used to pre-fill metadata"
)
@click.option(
    "--replace/--no-replace",
    default=False,
    help="Whether to replace current metadata files",
)
@click.pass_context
def init_table(ctx, dataset_id, table_id, data_sample_path, replace):

    Table(table_id=table_id, dataset_id=dataset_id, **ctx.obj).init(
        data_sample_path=data_sample_path, replace=replace
    )

    click.echo(
        click.style(
            f"Table `{table_id}` folder and metadata were created at {ctx.obj['metadata_path']}{dataset_id}",
            fg="green",
        )
    )


@cli_table.command(name="create", help="Create stagging table in BigQuery")
@click.argument("dataset_id")
@click.argument("table_id")
@click.option(
    "--job_config_params", default=None, help="File to advanced load config params "
)
@click.pass_context
def create_table(ctx, dataset_id, table_id, job_config_params):

    Table(table_id=table_id, dataset_id=dataset_id, **ctx.obj).create(
        job_config_params=job_config_params,
    )

    click.echo(
        click.style(
            f"Table `{dataset_id}.stagging_{table_id}` was created in BigQuery",
            fg="green",
        )
    )


@cli_table.command(name="update", help="Update tables in BigQuery")
@click.argument("dataset_id")
@click.argument("table_id")
@click.option(
    "--mode",
    default=["staging", "prod"],
    help="Choose a table from a dataset to update",
)
@click.pass_context
def update_table(ctx, dataset_id, table_id, mode):

    Table(table_id=table_id, dataset_id=dataset_id, **ctx.obj).update(
        mode=mode,
    )

    click.echo(
        click.style(
            f"Table `{dataset_id}.stagging_{table_id}` was created in BigQuery",
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
@click.argument(
    "mode",
    # help="Which table to delete [prod|staging]",
)
@click.pass_context
def delete_table(ctx, dataset_id, table_id, mode):

    Table(table_id=table_id, dataset_id=dataset_id, **ctx.obj).delete(
        mode=mode,
    )

    if mode == "prod":
        text = f"Table `{dataset_id}.{table_id}` was deleted from BigQuery"
    elif mode == "staging":
        text = f"Table `{dataset_id}.staging_{table_id}` was deleted from BigQuery"

    click.echo(
        click.style(
            text,
            fg="green",
        )
    )


cli.add_command(cli_dataset)
cli.add_command(cli_table)

if __name__ == "__main__":

    cli()