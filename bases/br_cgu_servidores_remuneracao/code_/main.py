"""
Main module of the project.
"""

from time import sleep

import requests
import typer

from functions import file_exists, save_file, unzip_salary_file
from processing_functions import get_career_df
from settings import CGU_FILES, URL_CGU_DOWNLOADS

app = typer.Typer()


@app.command()
def transform_files(
    career: str = typer.Option(..., help="Career of the employee"),
):
    """
    Transform the files to the final format.
    :param career: the career of the employee (milirares or civis)
    :param kind: the situation of the employee (ativos or inativos)
    :param division: the division of the civilians (BACEN or SIAPE)
    """
    if career == "militar":
        for kind in ["ativo", "reservista"]:
            get_career_df(career, kind)
    else:
        """Script for civilians"""
        pass


@app.command()
def download_file(year: str, month: str, career: str, kind: str = "ativo") -> str:
    """
    Download the files and save zip file to tmp directory
    :param year: year to download
    :param month: month to download
    :param career: the career of the employee (militar or civil)
    :param kind: the situation of the employee (ativo or reservista)
    :return: the name of the file downloaded
    """

    career = career.lower()
    downloaded_files = []
    existing_files = []
    res = ""
    for file_ in CGU_FILES[career][kind]:
        url = f"{URL_CGU_DOWNLOADS}/{year}{month}_{file_}"
        try:
            division = file_.split("_")[-1].lower() if career == "civil" else None
            if not file_exists(year, month, career, kind, division):
                print(f"Downloading {url}")
                sleep(10)
                req = requests.get(url, stream=True, timeout=30)
                req.raise_for_status()
                filename = (
                    req.headers.get("Content-Disposition")
                    .split("=")[-1]
                    .replace('"', "")
                )
                saved = save_file(filename, req.content)
                unzipped_file = unzip_salary_file(
                    saved, year, month, career, kind, division
                )
                downloaded_files.append(unzipped_file)
            else:
                print(f"Arquivo {url} já existe")
                existing_files.append(file_)
            res = f"Arquivos baixados: {', '.join(downloaded_files)} \nArquivos existentes: {', '.join(existing_files)}"  # pylint: disable=line-too-long  # noqa
        except requests.exceptions.ConnectionError as err:
            res = f"Erro de conexão: {err}"
            # pylint: disable=line-too-long
            # Erro de conexÃ£o: HTTPConnectionPool(host='www.portaltransparencia.gov.br', port=80): Max retries exceeded with url: /download-de-dados/servidores/202202_Reserva_Reformas_Militares (Caused by NewConnectionError('<urllib3.connection.HTTPConnection object at 0x7f9cd019cd90>: Failed to establish a new connection: [Errno -3] Temporary failure in name resolution')  # pylint: disable=line-too-long  # noqa
        except requests.exceptions.HTTPError as err:
            res = f"Arquivo inexistente: {url.split('/')[-1]}.zip - {err}"
            # pylint: disable=line-too-long
            # Erro no download: 404 Client Error: Not Found for url: https://www.portaltransparencia.gov.br/download-de-dados/servidores/202202_Reserva_Reformas_Militares  # pylint: disable=line-too-long  # noqa

    print(res)
    return res


@app.command()
def download_career(career: str = "militar") -> None:
    """
    Download all files for a career
    :param career:
    :return: None
    """
    years = [str(y) for y in range(2013, 2023)]
    months = [str(m).zfill(2) for m in range(1, 13)]
    kinds = ["ativo", "reservista"]
    for year in years:
        for month in months:
            for kind in kinds:
                download_file(year, month, career, kind)


if __name__ == "__main__":
    app()
