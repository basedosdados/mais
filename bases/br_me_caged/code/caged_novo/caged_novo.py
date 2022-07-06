"""
Extract and transform data from caged_novo
"""
# pylint: disable=invalid-name,fixme,too-many-locals,redefined-outer-name
import os
import re
from datetime import datetime
import shutil
from ftplib import FTP

import unidecode
import py7zr
import numpy as np
import pandas as pd
import basedosdados as bd

today = datetime.strftime(datetime.today(), "%Y-%m-%d")


RAW_PATH = "../data/caged_novo/raw/"
CLEAN_PATH = "../data/caged_novo/clean/"


month_number_dict = {
    "04": "Abril",
    "08": "Agosto",
    "12": "Dezembro",
    "02": "Fevereiro",
    "01": "Janeiro",
    "07": "Julho",
    "06": "Junho",
    "05": "Maio",
    "03": "Março",
    "11": "Novembro",
    "10": "Outubro",
    "09": "Setembro",
}

month_name_dict = {
    "Abril": "04",
    "Agosto": "08",
    "Dezembro": "12",
    "Fevereiro": "02",
    "Janeiro": "01",
    "Julho": "07",
    "Junho": "06",
    "Maio": "05",
    "Março": "03",
    "Novembro": "11",
    "Outubro": "10",
    "Setembro": "09",
}


def get_ftp(url_path):
    """
    Get the ftp connection
    """
    # source = ("1.33.213.199", 0)
    # discover how to use a proxy to acess the ftp --> source_address
    ftp = FTP("ftp.mtps.gov.br")
    ftp.login()
    ftp.encoding = "latin1"
    path = "/pdet/microdados/NOVO CAGED/" + url_path
    ftp.cwd(path)
    return ftp


################################################################
# GET THE DOWNLOAD LINKS
################################################################


def get_download_links():
    """
    Get the links to download
    """
    tipos = [tipo for tipo in get_ftp("").nlst() if ".pdf" not in tipo]
    download_dict = {}

    for tipo in tipos:
        tipo_lower = unidecode.unidecode(tipo).lower()
        print(tipo_lower)
        year_url = tipo
        years = get_ftp(year_url).nlst()
        ## adiciona 2020 hard coded caso n exista. problema no ftp dos microdados
        years = years + ["2020"] if "2020" not in years else years
        years = [int(year) for year in years if re.findall(r"\b\d\d\d\d\b", year)]

        last_year = max(years)
        first_year = min(years)
        ##cria url com o maior ano
        months_url = year_url + f"/{last_year}/"
        months_last_year = get_ftp(months_url).nlst()

        ##descobre o maior mes do maior ano
        last_month = max(int(month_name_dict[month]) for month in months_last_year)
        last_month_number = f"0{last_month}" if last_month <= 9 else str(last_month)
        last_month_name = month_number_dict[last_month_number]

        ## cria url com maior ano/mes
        file_names_url = months_url + f"{last_month_name}/"
        last_year_file_names = get_ftp(file_names_url).nlst()

        last_year_files_urls = [
            file_names_url + file_name for file_name in last_year_file_names
        ]

        last_year_files_urls_path = []
        for download_url in last_year_files_urls:
            file_name = download_url.split("/")[-1]
            year = file_name.split(".")[0][-6:-2]
            month = file_name.split(".")[0][-2:]
            last_year_files_urls_path.append(f"{int(year)}/" + f"{int(month)}/")

        download_dict[tipo_lower] = {
            "must_download": dict(zip(last_year_files_urls_path, last_year_files_urls)),
            "check_download": {},
        }
        ## lista dos ultimos 12 arquivos atualizados
        last_year_month_dt = [month[-9:-3] for month in last_year_file_names]

        ## define ultimo mes para criar uma lista de datas, adiciona mais 1 para incluir o mes vigente
        last_month_dt = int(last_month_number) + 1
        last_month_dt = (
            f"0{last_month_dt}" if last_month_dt <= 9 else str(last_month_dt)
        )

        dates = [
            str(date)[:7].replace("-", "")
            for date in pd.date_range(
                f"{first_year}-01-01", f"{last_year}-{last_month_dt}-01", freq="m"
            )
        ]

        ## meses a serem baixados separadamente
        left_over_dates = [date for date in dates if date not in last_year_month_dt]
        left_over_files = []
        for left_date in left_over_dates:
            ano_plus = str(int(left_date[:4]) + 1)
            mes_number = left_date[4:]
            mes_name = month_number_dict[mes_number]

            ## cria url para baixar o arquivo mais atualizado
            left_files_url = year_url + f"/{ano_plus}/{mes_name}/"

            ## encontra o nome do arquivo mais atualizado
            last_year_files = get_ftp(left_files_url).nlst()
            file_name = [
                last_month for last_month in last_year_files if left_date in last_month
            ][0]

            ##adiciona a lista de arquivos que sobraram
            file_url = left_files_url + file_name
            left_over_files.append(file_url)

            left_date_year = left_date[:4]
            left_date_month = left_date[4:]
            left_path = f"{int(left_date_year)}/" + f"{int(left_date_month)}/"
            download_dict[tipo_lower]["check_download"][left_path] = file_url

    return download_dict


## get the blobs from basedosdados storage and filter what needs to be downloaded
def get_filtered_download_dict(tipo, download_dict, bucket_name="basedosdados"):
    """
    Get the blobs from basedosdados storage and filter what needs to be downloaded
    """

    def get_year_month(b):
        ano = b.split("ano=")[1].split("/")[0]
        mes = b.split("mes=")[1].split("/")[0]
        return f"{ano}/{mes}/"

    tb = bd.Table(dataset_id="br_me_caged", table_id=f"microdados_{tipo}")
    blobs = list(
        tb.client["storage_staging"]
        .bucket(bucket_name)
        .list_blobs(prefix=f"staging/{tb.dataset_id}/{tb.table_id}/")
    )

    blobs = list({get_year_month(b.name) for b in blobs})

    must_download_pop = [
        d for d in download_dict[tipo]["must_download"] if d not in blobs
    ]
    if must_download_pop != []:
        pass
    else:
        download_dict[tipo]["must_download"] = {}

    return download_dict


## logic to trigger the downloads
def get_trigger_and_download_opt(download_opt, tipo):
    """
    Get the trigger and download opts to trigger the downloads
    """
    # TODO: etapa de filtragem do que n deve ser baixado
    if (
        download_opt[tipo]["check_download"] == {}
        and download_opt[tipo]["must_download"] == {}
    ):
        print("nothing to download")
        download_links = {}
        trigger = False
    elif (
        download_opt[tipo]["check_download"] == {}
        and download_opt[tipo]["must_download"] != {}
    ):
        print("Downloading last 12 months")
        trigger = True
        download_links = download_opt[tipo]["must_download"]
    elif (
        download_opt[tipo]["check_download"] != {}
        and download_opt[tipo]["must_download"] == {}
    ):
        print("Downloading missing file")
        trigger = True
        download_links = download_opt[tipo]["check_download"]
    else:
        print("Downloading files")
        trigger = True
        download_links = download_opt[tipo]["check_download"]
        download_links.update(download_opt[tipo]["must_download"])

    return trigger, download_links


################################################################
# DOWNLOAD FILES
################################################################


def download_data(save_path, download_url):
    """
    Download the file
    """
    ## download do arquivo
    path_url = "/".join(download_url.split("/")[:-1])
    ftp = get_ftp(path_url)

    file_name = download_url.split("/")[-1]
    creat_path_tree(save_path)
    if not os.path.isfile(save_path + file_name):
        with open(save_path + file_name, "wb") as f:
            ftp.retrbinary("RETR " + file_name, f.write)


################################################################
# FILES AND FOLDES MANIPULATION
################################################################
def creat_path_tree(path):
    """
    Create the path tree if it doesn't exist
    """
    current_path = ""
    for folder in path.split("/"):
        current_path += f"{folder}/"
        if folder != ".." and not os.path.isdir(current_path):
            os.mkdir(current_path)


def extract_file(file_path, file_name, save_rows=10):
    """
    Extract the file
    """
    if not os.path.exists(f"{file_path}{file_name}.csv"):
        py7zr.SevenZipFile(f"{file_path}{file_name}.7z", mode="r").extractall(
            path=file_path
        )
        filename_txt = [
            file for file in os.listdir(file_path) if ".txt" in file.lower()
        ][0]

        #         print(filename_txt)

        df = pd.read_csv(
            f"{file_path}{filename_txt}",
            sep=";",
            encoding="latin-1",
            nrows=save_rows,
            dtype="str",
        )

        #         df.columns = manipulation.normalize_cols(df.columns)

        df.to_csv(f"{file_path}{file_name}.csv", index=False, encoding="latin-1")

        os.remove(f"{file_path}{filename_txt}")


def creat_partition(df, save_clean_path, year_month_path):
    """
    Create the partition
    """
    valid_ufs = [uf for uf in df["sigla_uf"].unique() if uf is not np.nan]
    for uf in valid_ufs:
        ano = year_month_path.split("/")[0]
        mes = year_month_path.split("/")[1]
        save_path = (
            save_clean_path
            + f"ano={int(ano)}/"
            + f"mes={int(mes)}/"
            + f"sigla_uf={uf}/"
        )

        creat_path_tree(save_path)

        mask = df["sigla_uf"] == uf
        dd = df[mask].drop(columns=["sigla_uf"])
        dd.to_csv(save_path + "data.csv", index=False)


def clean_csvs(file_path, file_name):
    """
    Clean the csv
    """
    try:
        os.remove(f"{file_path}{file_name}.csv")
    except Exception:
        pass


################################################################
# TABLE MANIPULATION
################################################################


def rename_add_orginaze_columns(file_path, file_name, tipo, municipios):
    """
    Rename and add columns
    """

    df = pd.read_csv(f"{file_path}{file_name}.csv", dtype="str")

    colunas_estabelecimento = {
        "sigla_uf": "sigla_uf",
        "id_municipio": "id_municipio",
        "município": "id_municipio_6",
        "cnae_2": "cnae_2",
        "subclasse": "cnae_2_subclasse",
        "seção": "cnae_2_secao",
        "admitidos": "admitidos",
        "desligados": "desligados",
        "fonte_desl": "fonte_desligamento",
        "saldomovimentação": "saldo_movimentacao",
        "tipoempregador": "tipo_empregador",
        "tipoestabelecimento": "tipo_estabelecimento",
        "tamestabjan": "tamanho_estabelecimento_janeiro",
        "competência": "",
        "região": "",
        "uf": "",
    }

    colunas_movimentacoes = {
        "sigla_uf": "sigla_uf",
        "id_municipo": "id_municipio",
        "município": "id_municipio_6",
        "cnae_2": "cnae_2",
        "subclasse": "cnae_2_subclasse",
        "seção": "cnae_2_secao",
        "cbo2002ocupação": "cbo_2002",
        "saldomovimentação": "saldo_movimentacao",
        "categoria": "categoria",
        "graudeinstrução": "grau_instrucao",
        "idade": "idade",
        "horascontratuais": "horas_contratuais",
        "raçacor": "raca_cor",
        "sexo": "sexo",
        "tipoempregador": "tipo_empregador",
        "tipoestabelecimento": "tipo_estabelecimento",
        "tipomovimentação": "tipo_movimentacao",
        "tipodedeficiência": "tipo_deficiencia",
        "indtrabintermitente": "indicador_trabalho_intermitente",
        "indtrabparcial": "indicador_trabalho_parcial",
        "salário": "salario_mensal",
        "tamestabjan": "tamanho_estabelecimento_janeiro",
        "indicadoraprendiz": "indicador_aprendiz",
        "fonte": "fonte",
        "competência": "",
        "região": "",
        "uf": "",
    }
    if tipo == "estabelecimentos":
        col_dict = colunas_estabelecimento
    else:
        col_dict = colunas_movimentacoes
        df["cbo2002ocupação"] = df["cbo2002ocupação"].apply(
            lambda x: (6 - len(x)) * "0" + x
        )

    df["subclasse"] = df["subclasse"].apply(lambda x: (7 - len(x)) * "0" + x)
    df["cnae_2"] = df["subclasse"].str[:5]

    remove_cols = [col for col in col_dict if col_dict.get(col) == ""]

    df = df.drop(columns=remove_cols)
    df = df.rename(columns=col_dict)
    df = df.merge(municipios, on="id_municipio_6", how="left")

    col_order = [value for col, value in col_dict.items() if col not in remove_cols]
    df = df[col_order]

    return df


################################################################
# UPLOAD TO BD
################################################################


def upload_to_raw(tipo, save_raw_path):
    """
    Upload to raw
    """
    if tipo == "estabelecimentos":
        st = bd.Storage(
            table_id="microdados_estabelecimentos", dataset_id="br_me_caged"
        )
    else:
        st = bd.Storage(table_id="microdados_movimentacoes", dataset_id="br_me_caged")

    st.upload(path=save_raw_path, mode="raw", if_exists="replace")


def upload_to_bd(tipo, filepath):
    """
    Upload to bd
    """
    if tipo == "estabelecimentos":
        tb = bd.Table(table_id="microdados_estabelecimentos", dataset_id="br_me_caged")
    else:
        tb = bd.Table(table_id="microdados_movimentacoes", dataset_id="br_me_caged")

    tb.append(filepath, if_exists="replace")


if __name__ == "__main__":
    # GET MUNICIPIOS FROM BD
    print("====== ", today, " ======")
    query = """
    SELECT 
        sigla_uf,
        id_municipio,
        id_municipio_6
    FROM `basedosdados.br_bd_diretorios_brasil.municipio` 
    """

    municipios = bd.read_sql(query, billing_project_id="basedosdados-dev")
    print("\n")

    # deleta pasta
    if os.path.isdir(CLEAN_PATH):
        shutil.rmtree(CLEAN_PATH)
    if os.path.isdir(RAW_PATH):
        shutil.rmtree(RAW_PATH)

    print("Get download links")
    download_dict = get_download_links()
    print("\n")

    for tipo in list(download_dict.keys()):

        download_opt = get_filtered_download_dict(
            tipo=tipo, download_dict=download_dict, bucket_name="basedosdados-dev"
        )

        print(f"Filter download links {tipo}")

        trigger, download_opt = get_trigger_and_download_opt(download_opt, tipo)

        if trigger:
            for year_month_path in list(download_opt.keys()):
                print(tipo, ": ", year_month_path)
                ## download data
                save_path = RAW_PATH + f"{tipo}/" + year_month_path
                download_data(save_path, download_opt[year_month_path])

                # create some vars
                file_name = download_opt[year_month_path].split("/")[-1].split(".")[0]
                file_path = RAW_PATH + f"{tipo}/" + year_month_path

                # upload raw data to storage
                upload_to_raw(tipo=tipo, save_raw_path=f"{save_path}{file_name}.7z")

                # extrai arquivo
                extract_file(file_path, file_name, save_rows=None)

                # load e organiza os dados
                df = rename_add_orginaze_columns(file_path, file_name, tipo, municipios)

                # salva no formato de particao
                save_clean_path = CLEAN_PATH + f"{tipo}/"
                creat_partition(df, save_clean_path, year_month_path)

                # upload basedosdados
                upload_to_bd(tipo, save_clean_path)

                # deleta pasta
                shutil.rmtree(CLEAN_PATH + f"{tipo}/")
                shutil.rmtree(RAW_PATH + f"{tipo}/")

        print("\n")
