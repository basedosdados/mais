"""
Main module of the project.
"""
from pathlib import Path
from time import sleep

import basedosdados as bd
import numpy as np
import pandas as pd
import requests
import typer

from functions import file_exists, save_file, unzip_salary_file  # pylint: disable=import-error
from processing_functions import get_career_df  # pylint: disable=import-error
from settings import CGU_FILES, URL_CGU_DOWNLOADS  # pylint: disable=import-error

app = typer.Typer()


@app.command()
def transform_files(
    career: str = typer.Option(..., help="Career of the employee (civil or militar)"),
    kind: str = typer.Option(
        None, help="Situation of the employee (ativo or reservista/aposentado)"
    ),
):
    """
    Transform the files to the final format

    """
    kind_retired = "reservista" if career == "militar" else "aposentado"
    if kind:
        get_career_df(career, kind)
    else:
        for k in ["ativo", kind_retired]:
            get_career_df(career, k)


def download_file(year: str, month: str, career: str, kind: str = "ativo") -> str:
    """
    Download the files and save zip file to tmp directory

    Returns: the name of the downloaded file
    """

    career = career.lower()
    downloaded_files = []
    existing_files = []
    res = ""
    for file_ in CGU_FILES[career][kind]:
        url = f"{URL_CGU_DOWNLOADS}/{year}{month}_{file_}"
        try:
            division = file_.split("_")[-1] if career == "civil" else None
            if not file_exists(year, month, career, kind, division):
                print(f"Downloading {url}")
                sleep(10)
                req = requests.get(url, stream=True, timeout=90)
                req.raise_for_status()
                filename = (
                    req.headers.get("Content-Disposition")
                    .split("=")[-1]
                    .replace('"', "")
                )
                saved = save_file(filename, req.content)
                unzipped_file = unzip_salary_file(saved, year, month, career, kind)
                downloaded_files.append(unzipped_file)
            else:
                print(f"Arquivo {url} já existe")
                existing_files.append(file_)
            res = f"Arquivos baixados: {', '.join(downloaded_files)} \nArquivos existentes: {', '.join(existing_files)}"
        except requests.exceptions.ConnectionError as err:
            res = f"Erro de conexão: {err}"
            # pylint: disable=line-too-long
            # Erro de conexÃ£o: HTTPConnectionPool(host='www.portaltransparencia.gov.br', port=80): Max retries
            # exceeded with url: /download-de-dados/servidores/202202_Reserva_Reformas_Militares (Caused by
            # NewConnectionError('<urllib3.connection.HTTPConnection object at 0x7f9cd019cd90>: Failed to establish
            # a new connection: [Errno -3] Temporary failure in name resolution')
        except requests.exceptions.HTTPError as err:
            res = f"Arquivo inexistente: {url.split('/')[-1]}.zip - {err}"
            # pylint: disable=line-too-long
            # Erro no download: 404 Client Error: Not Found for url:
            # https://www.portaltransparencia.gov.br/download-de-dados/servidores/202202_Reserva_Reformas_Militares

    print(res)
    return res


@app.command()
def download_career(
    career: str = typer.Option(
        "militar",
        show_default=True,
        show_choices=True,
        help="The career of the employee (civil or militar)",
    ),
    kind_selected: str = typer.Option(
        "all", help="The kind of the employee (ativo, reservista/aposentado or all)"
    ),
) -> None:
    """
    Download all files for a career
    """
    months = [str(m).zfill(2) for m in range(1, 13)]
    if career == "militar":
        kind_retired = "reservista"
        start_year = 2013
    else:
        kind_retired = "aposentado"
        start_year = 2020
    if kind_selected == "all":
        kinds = ["ativo", kind_retired]
    else:
        kinds = [kind_selected]
    for kind in kinds:
        for year in range(start_year, 2023):
            for month in months:
                download_file(str(year), month, career, kind)


@app.command()
def create_table(
    table_id: str = typer.Option(..., help="The id of the table to be created"),
    test: bool = typer.Option(False, help="Whether it is a test or not")
) -> None:
    """
    Create the table in BigQuery. Remember to check if columns config (CSV) has the same name as table_id
    """
    base_path = Path.cwd().parent
    architecture_file = base_path / f"extra/architecture/{table_id}.csv"
    if not architecture_file.exists():
        raise FileNotFoundError(f"Arquivo {architecture_file} não encontrado")

    tbl = bd.Table(dataset_id="br-cgu-servidores-executivo-federal", table_id=table_id)
    output_path = f"output/{table_id}" if not test else f"output/test/{table_id}_test"
    tbl.create(  # pylint: disable=no-value-for-parameter
        path=str(base_path / output_path),
        force_dataset=True,
        if_table_exists="replace",
        if_storage_data_exists="pass",
        if_table_config_exists="replace",
        columns_config_url_or_path=str(
            base_path / f"extra/architecture/{table_id}.csv"
        ),
    )


@app.command()
def replace_data(
    table_id: str = typer.Option(..., help="The id of the table"),
    test: bool = typer.Option(False, help="Whether is a test or not")
) -> None:
    """
    Replace the data in Google Cloud Storage
    """
    base_path = Path.cwd().parent

    tbl = bd.Table(dataset_id="br_cgu_servidores_executivo_federal", table_id=table_id)
    output_path = f"output/{table_id}" if not test else f"output/test/{table_id}_test"
    tbl.create(  # pylint: disable=no-value-for-parameter
        path=str(base_path / output_path),
        if_table_exists="pass",
        if_storage_data_exists="replace",
        if_table_config_exists="pass"
    )


@app.command()
def add_origin_column(
    kind: str = typer.Option(..., help="The kind of the employee (ativo, inativo)"),
) -> None:
    """
    Add the origin column to the military career table
    """
    new_kind = "reservista" if kind == "inativo" else "ativo"
    base_path = Path.cwd().parent
    if kind == "inativo":
        start_year = 2020
    else:
        start_year = 2013
    for year in range(start_year, 2023):
        for month in range(1, 13):
            output_file = f"output/remuneracao_{kind}/carreira=militar/ano={year}/mes={str(month).zfill(2)}/servidor_militar_{new_kind}_remuneracao.csv"
            if not (base_path / output_file).exists():
                continue
            print(f"Adicionando coluna de origem para {output_file}")
            df_original = pd.read_csv(base_path / output_file, sep=",", encoding="utf-8")
            if "origem" not in df_original.columns:
                if "origin" in df_original.columns:
                    df_original.drop(columns=["origin"], inplace=True)
                df_original["origem"] = ""
                df_original.to_csv(base_path / output_file, index=False, encoding="utf-8", sep=",", na_rep=np.nan)


if __name__ == "__main__":
    app()
