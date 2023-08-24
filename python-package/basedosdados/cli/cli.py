"""
CLI package for the application.
"""

# pylint: disable=locally-disabled, multiple-statements, fixme, line-too-long, too-many-arguments, invalid-name, too-many-lines, protected-access, unused-argument, no-value-for-parameter, redefined-builtin

try:
    import click

    _cli_dependencies = True
except ImportError:
    _cli_dependencies = False

import basedosdados as bd
from basedosdados.exceptions import BaseDosDadosMissingDependencyException
from basedosdados.upload.base import Base

if not _cli_dependencies:
    raise BaseDosDadosMissingDependencyException(
        "Optional dependencies for the CLI are not installed. "
        'Please install basedosdados with the "cli" extra, such as:'
        "\n\npip install basedosdados[cli]"
    )


@click.group()
@click.option("--bucket_name", default=None, help="Project bucket name")
@click.version_option(package_name="basedosdados")
@click.pass_context
def cli(ctx, bucket_name):
    """
    Function to define the CLI.
    """

    ctx.obj = dict(
        bucket_name=bucket_name,
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


# Allow anomalous backslash in string: '\ ' (it's used in gcloud sdk)
# pylint: disable=W1401
@click.command(
    name="download",
    help=(
        "Downloads data do SAVEPATH. SAVEPATH must point to a .csv file.\n\n"
        "Example: \n\n"
        'basedosdados download data.csv  --query="select * from basedosdados.br_ibge_pib.municipio limit 10" --billing_project_id=basedosdados-dev'
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


cli.add_command(cli_config)
cli.add_command(cli_download)
cli.add_command(cli_reauth)
cli.add_command(cli_list)
cli.add_command(cli_get)


if __name__ == "__main__":
    cli()
