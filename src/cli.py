import click

from src.core import Base, Dataset, Table, Storage


@click.group()
@click.option(
    "--key_path", default="secrets/cli-admin.json", help="Gcloud key json file"
)
@click.option("--templates", default="src/templates", help="Templates path")
@click.option("--bucket_name", default="basedosdados", help="Project bucket_name name")
@click.option("--metadata_path", default="bases/", help="Folder to store metadata")
@click.pass_context
def cli(ctx, key_path, templates, bucket_name, metadata_path):

    cli.add_command(cli_dataset)
    cli.add_command(cli_table)

    ctx.obj = dict(
        key_path="secrets/cli-admin.json",
        templates="src/templates",
        bucket_name="basedosdados",
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
@click.option(
    "--partitioned",
    "-p",
    default=False,
    help="[True|False] whether table is partitioned",
)
@click.option(
    "--if_exists",
    default="raise",
    help="[raise|replace|pass] actions if table exists",
)
@click.pass_context
def create_table(ctx, dataset_id, table_id, job_config_params, partitioned, if_exists):

    Table(table_id=table_id, dataset_id=dataset_id, **ctx.obj).create(
        job_config_params=job_config_params,
        partitioned=partitioned,
        if_exists=if_exists,
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
            f"All tables `{dataset_id}.{table_id}*` were created in BigQuery",
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

    # click.echo(
    #     click.style(
    #         text,
    #         fg="green",
    #     )
    # )


@click.group(name="storage")
def cli_storage():
    pass


@cli_storage.command(name="init", help="Create bucket and initial folders")
@click.option("--bucket_name", default="basedosdados", help="Bucket name")
@click.option(
    "--replace/--no-replace",
    default=False,
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


cli.add_command(cli_dataset)
cli.add_command(cli_table)
cli.add_command(cli_storage)

if __name__ == "__main__":

    cli()