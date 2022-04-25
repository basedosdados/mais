from ast import Raise
from genericpath import exists
from logging import raiseExceptions
import os
import re
from tracemalloc import stop
from webbrowser import get
import unidecode
from ftplib import FTP
from datetime import datetime

import py7zr
import shutil
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
###############################################################

def get_download_links():
    years = [2020,2021,2022]
    download_dict = {}

    for year in years:
        year_str = str(year)
        month_url = get_ftp(year_str).nlst()
        
        for month in month_url:

            path = year_str + "/" + month + "/"
            file_name = f"CAGEDMOV" + month + ".7z"
            file_url = path + file_name
            year_month = f'{month}'
            download_dict[year_month] = file_url

    return download_dict

    ## get the blobs from basedosdados storage and filter what needs to be downloaded
def get_filtered_download_dict(tipo, download_dict, bucket_name="basedosdados"):
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


    blobs = list(set([get_year_month(b.name) for b in blobs]))

    check_download_pop = [
        d for d in download_dict[tipo]["check_download"] if d in blobs
    ]

    [
        download_dict[tipo]["check_download"].pop(year_month, None)
        for year_month in check_download_pop
    ]

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
    ## download do arquivo
    #path_url = "/".join(download_url.split("/")[:-1])
    
    
    file_name=download_url.split('/')[-1]
    ftp = get_ftp(download_url.replace(file_name,''))
    creat_path_tree(save_path)
    if not os.path.isfile(save_path + file_name):
        with open(save_path + file_name, "wb") as f:
            ftp.retrbinary("RETR " + file_name, f.write)
    
        

################################################################
# FILES AND FOLDES MANIPULATION
################################################################
def creat_path_tree(path):
    current_path = ""
    for folder in path.split("/"):
        current_path += f"{folder}/"
        if folder != ".." and not os.path.isdir(current_path):
            os.mkdir(current_path)


def extract_file(file_path, file_name, save_rows=10):
    if not os.path.exists(f"{file_path}{file_name}.csv"):
        archive = py7zr.SevenZipFile(f"{file_path}{file_name}.7z", mode="r").extractall(
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
    try:
        os.remove(f"{file_path}{file_name}.csv")
    except:
        pass


################################################################
# TABLE MANIPULATION
################################################################


def rename_add_orginaze_columns(file_path, file_name, municipios):

    df = pd.read_csv(f"{file_path}{file_name}.csv", dtype="str")

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

    col_order = [col_dict[col] for col in col_dict if col not in remove_cols]
    df = df[col_order]

    return df


################################################################
# UPLOAD TO BD
################################################################


def upload_to_raw(tipo, save_raw_path):
    if tipo == "estabelecimentos":
        st = bd.Storage(
            table_id="microdados_estabelecimentos", dataset_id="br_me_caged"
        )
    else:
        st = bd.Storage(table_id="microdados_movimentacoes", dataset_id="br_me_caged")

    st.upload(path=save_raw_path, mode="raw", if_exists="replace")


def upload_to_bd(tipo, filepath):
    if tipo == "estabelecimentos":
        tb = bd.Table(table_id="microdados_estabelecimentos", dataset_id="br_me_caged")
    else:
        tb = bd.Table(table_id="microdados_movimentacoes", dataset_id="br_me_caged")

    tb.append(filepath, if_exists="replace")
