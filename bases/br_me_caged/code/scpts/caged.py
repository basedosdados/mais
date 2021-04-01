import sys

sys.path.insert(0, "../")

import time
import os

import pandas as pd
import numpy as np

import shutil
import urllib.request as request
from contextlib import closing

import py7zr

from scpts import manipulation


def create_folder_structure():
    ### cria pasta data caso n exista
    if not os.path.exists("../data"):
        os.mkdir("../data")
    if not os.path.exists("../data/caged/"):
        os.mkdir("../data/caged/")

    if not os.path.exists("../data/caged/raw"):
        os.mkdir("../data/caged/raw")
    if not os.path.exists("../data/caged/raw/caged_antigo"):
        os.mkdir("../data/caged/raw/caged_antigo")
    if not os.path.exists("../data/caged/raw/caged_novo"):
        os.mkdir("../data/caged/raw/caged_novo")
    if not os.path.exists("../data/caged/raw/caged_antigo_ajustes"):
        os.mkdir("../data/caged/raw/caged_antigo_ajustes")

    if not os.path.exists("../data/caged/clean/"):
        os.mkdir("../data/caged/clean")
    if not os.path.exists("../data/caged/clean/caged_antigo"):
        os.mkdir("../data/caged/clean/caged_antigo")
    if not os.path.exists("../data/caged/clean/caged_novo"):
        os.mkdir("../data/caged/clean/caged_novo")
    if not os.path.exists("../data/caged/clean/caged_antigo_ajustes"):
        os.mkdir("../data/caged/clean/caged_antigo_ajustes")


def download_data(download_link, download_path, filename):
    ## download do arquivo
    with closing(request.urlopen(download_link)) as r:
        with open(os.path.join(download_path, filename), "wb") as f:
            shutil.copyfileobj(r, f)


#####======================= ANTIGO CAGED DOWNLOAD =======================#####


def download_caged_normal(download_link, download_path_year, ano, mes):
    """
    download dos arquivos do caged para os anos 2007 a 2019. Tambem vale para arquivos de ajustes entre 2010 e 2019
    """
    download_path_month = download_path_year + f"/{int(mes)}/"
    ## cria pastas
    if os.path.exists(download_path_year):
        if not os.path.exists(download_path_month):
            os.mkdir(download_path_month)
    else:
        os.mkdir(download_path_year)
        if not os.path.exists(download_path_month):
            os.mkdir(download_path_month)

    if "AJUSTE" not in download_link:
        filename = f"CAGEDEST_{mes}{ano}.7z"
    else:
        filename = f"CAGEDEST_AJUSTES_{mes}{ano}.7z"

    ## verifica se arquivo ja existe
    if os.path.exists(os.path.join(download_path_month, filename)):
        print(f"{mes}/{ano} | já existe")
    else:

        try:
            ti = time.time()
            download_data(download_link, download_path_month, filename)
            t = time.strftime("%M:%S", time.gmtime((time.time() - ti)))
            print(f"{mes}/{ano} | criado em {t}")
        except:
            print(f"{mes}/{ano} | não conseguiu baixar")


def download_caged_ajustes_2002a2009(download_link, download_path_year, ano):
    """
    download dos arquivos de ajustes do caged para os anos 2002 a 2009
    """

    if not os.path.exists(download_path_year):
        os.mkdir(download_path_year)
        os.mkdir(download_path_year + "/1")

    download_path_year = download_path_year + "/1"
    ## verifica se arquivo ja existe
    filename = filename = f"CAGEDEST_AJUSTES_{ano}.7z"
    if os.path.exists(os.path.join(download_path_year, filename)):
        print(f"{ano} | já existe")
    else:
        try:
            ti = time.time()
            download_data(download_link, download_path_year, filename)
            t = time.strftime("%M:%S", time.gmtime((time.time() - ti)))
            print(f"{ano} | criado em {t}")
        except:
            print(f"{ano} | não conseguiu baixar")


def download_caged_file(download_link, ano=None, mes=None, raw_path=None):
    # cria estrutura de pastas
    create_folder_structure()

    ## cria link e path das pastas
    download_path_year = raw_path + f"/{ano}"

    if isinstance(ano, int):
        download_caged_normal(download_link, download_path_year, ano, mes)
    else:
        download_caged_ajustes_2002a2009(download_link, download_path_year, ano)


def caged_antigo_download():
    raw_path = "../data/caged/raw/caged_antigo"
    clean_path = "../data/caged/clean/caged_antigo"

    anos = [i for i in range(2007, 2020)]
    meses = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]

    print("#===== CAGED ANTIGO =====#\n")
    for ano in anos:
        for mes in meses:
            download_link = f"ftp://ftp.mtps.gov.br/pdet/microdados/CAGED/{ano}/CAGEDEST_{mes}{ano}.7z"
            download_caged_file(download_link, ano, mes, raw_path)
    print("\n")


def caged_antigo_ajustes_download():
    raw_path = "../data/caged/raw/caged_antigo_ajustes"
    clean_path = "../data/caged/clean/caged_antigo_ajustes"

    anos = [i for i in range(2010, 2020)]
    meses = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]

    print("#=====  CAGED ANTIGO AJUSTES =====#\n")
    for ano in anos:
        for mes in meses:
            download_link = f"ftp://ftp.mtps.gov.br/pdet/microdados/CAGED_AJUSTES/{ano}/CAGEDEST_AJUSTES_{mes}{ano}.7z"
            download_caged_file(download_link, ano, mes, raw_path)
    print("\n")


def caged_antigo_ajustes_2002a2009_download():
    raw_path = "../data/caged/raw/caged_antigo_ajustes"
    clean_path = "../data/caged/clean/caged_antigo_ajustes"

    anos = [str(i) for i in range(2007, 2010)]

    print("#===== CAGED ANTIGO AJUSTES 2002a2009 =====#\n")
    for ano in anos:
        download_link = f"ftp://ftp.mtps.gov.br/pdet/microdados/CAGED_AJUSTES/2002a2009/CAGEDEST_AJUSTES_{ano}.7z"
        download_caged_file(download_link, ano, mes=None, raw_path=raw_path)
    print("\n")


def caged_antigo_ajustes_2002a2009_extract_organize(folders, force_remove_csv=False):
    folders = [
        folder
        for folder in folders
        for ano in ["2007", "2008", "2009"]
        if ano in folder
    ]
    # all_cols = pd.DataFrame()
    for folder in folders:
        ano = folder.split("/")[-2]
        filename_7z = get_file_names_and_clean_residues(folder, force_remove_csv)
        extract_file(folder, filename_7z, save_rows=None)
        print(f"{ano} | extraido")

        filename = [file for file in os.listdir(folder) if ".csv" in file][0][:-4]
        df = pd.read_csv(f"{folder}{filename}.csv")

        df["ano"] = df["competencia_declarada"].apply(lambda x: str(x)[:4])
        df["mes"] = df["competencia_declarada"].apply(lambda x: str(x)[4:])

        for mes in df["mes"].unique():
            if not os.path.exists(f"{folder}{str(int(mes))}"):
                os.mkdir(f"{folder}{str(int(mes))}")

            mask = df["mes"] == mes
            dd = df[mask]

            dd = dd.drop(["ano", "mes"], 1)
            dd.to_csv(
                f"{folder}{str(int(mes))}/{filename_7z[:-5]}_{mes}{ano}.csv",
                index=False,
                encoding="utf-8",
            )


#####======================= NOVO CAGED DWONLOAD =======================#####


def download_caged_novo(ano, mes, raw_path):
    print("kkk")


#####======================= MANIPULA ARQUIVOS =======================#####


def extract_file(path_month, filename, save_rows=10):
    if not os.path.exists(f"{path_month}{filename}.csv"):
        archive = py7zr.SevenZipFile(f"{path_month}{filename}.7z", mode="r").extractall(
            path=path_month
        )

        filename_txt = [
            file for file in os.listdir(path_month) if ".txt" in file.lower()
        ][0]
        try:

            df = pd.read_csv(
                f"{path_month}{filename_txt}",
                sep=";",
                encoding="latin-1",
                nrows=save_rows,
            )
        except:
            ## caso de erro de bad lines por conter um ; extra no arquivo txt
            with open(
                f"{path_month}{filename_txt}",
                encoding="latin-1",
            ) as f:
                newText = f.read().replace(";99;", ";99")

            with open(f"{path_month}{filename_txt}", "w") as f:
                f.write(newText)

            df = pd.read_csv(
                f"{path_month}{filename_txt}",
                sep=";",
                encoding="latin-1",
                nrows=save_rows,
            )

        df.columns = manipulation.normalize_cols(df.columns)

        df.to_csv(f"{path_month}{filename}.csv", index=False, encoding="utf-8")

        os.remove(f"{path_month}{filename_txt}")


def get_file_names_and_clean_residues(path_month, force_remove_csv=True):
    filename_txt = [file for file in os.listdir(path_month) if ".txt" in file.lower()]
    filename_csv = [file for file in os.listdir(path_month) if ".csv" in file]
    try:
        filename_7z = [file for file in os.listdir(path_month) if ".7z" in file][0][:-3]
    except:
        filename_7z = filename_csv[0][:-4]

    if filename_txt != []:
        os.remove(f"{path_month}{filename_txt[0]}")
    if filename_csv != [] and force_remove_csv == True:
        os.remove(f"{path_month}{filename_csv[0][:-4]}.csv")

    return filename_7z


def make_dirs(path, folder, var):
    if not os.path.exists(f"{path}{var}={folder}/"):
        os.mkdir(f"{path}{var}={folder}/")


def make_folder_tree(clean_path, ano, mes, uf="SP"):
    make_dirs(clean_path, ano, var="ano")
    path_ano = f"{clean_path}/ano={ano}/"
    make_dirs(path_ano, mes, var="mes")
    path_mes = f"{clean_path}/ano={ano}/mes={mes}/"
    make_dirs(path_mes, uf, var="sigla_uf")
    return f"{clean_path}/ano={ano}/mes={mes}/sigla_uf={uf}/"


def save_partitioned_file(df, clean_save_path, ano, mes, file_name):
    for uf in df.sigla_uf.unique():
        ## filtra apenas o estado de interesse
        df_uf = df[df["sigla_uf"] == uf]
        ## exclui colunas particionadas
        df_uf = df_uf.drop(["sigla_uf"], 1)
        ## cria estrutura de pastas
        path_uf = make_folder_tree(clean_save_path, ano, mes, uf)

        df_uf.to_csv(f"{path_uf}{file_name}.csv", index=False)


def caged_antigo_padronize_and_partitioned(
    folders, clean_save_path, municipios, force_remove_csv=True
):
    # all_cols = pd.DataFrame()
    for folder in folders:
        ano = folder.split("/")[-3]
        mes = folder.split("/")[-2]

        filename_7z = get_file_names_and_clean_residues(folder, force_remove_csv)

        ## verifica se o arquivo ja foi tratado
        if (
            os.path.exists(f"{clean_save_path}/ano={ano}/mes={mes}")
            and len(os.listdir(f"{clean_save_path}/ano={ano}/mes={mes}")) == 27
        ):
            print(f"{ano}-{mes} | já tratado\n")
        else:
            ## extrai o arquivo zipado, cria um novo arquivo .csv e deleta o arquivo extraido (.txt)
            if "ajustes" not in clean_save_path and int(ano) >= 2010:
                extract_file(folder, filename_7z, save_rows=None)

            print(f"{ano}-{mes} | extraido")

            ## le o arquivo
            filename = [file for file in os.listdir(folder) if ".csv" in file][0][:-4]
            df = pd.read_csv(f"{folder}{filename}.csv")

            ### padronizacao dos dados
            if "ajustes" in clean_save_path:
                df = padroniza_caged_antigo_ajustes(df, municipios)
                mode = "ajustes"
                save_name = "caged_antigo_ajustes"
            else:
                df = padroniza_caged_antigo(df, municipios)
                mode = "padrao"
                save_name = "caged_antigo"

            print(
                f"{ano}-{mes} | padronizado",
                "|",
                mode,
            )

            save_partitioned_file(df, clean_save_path, ano, mes, file_name=save_name)

            ##remove arquivo csv do raw files
            if force_remove_csv:
                os.remove(f"{folder}{filename}.csv")

            print(f"{ano}-{mes} | finalizado\n")

            # # checa nome de todas as colunas
            # dd = pd.DataFrame(df.columns.tolist(), columns=["cols"])
            # dd = dd.transpose().reset_index(drop=True)
            # cols = dd.columns.tolist()
            # dd["ano"] = ano
            # dd["mes"] = mes

            # dd = dd[["ano", "mes"] + cols]

            # all_cols = pd.concat([all_cols, dd])


#####======================= PADRONIZA CAGED FUNCOES =======================#####


def clean_caged(df, municipios):
    ## cria coluna ano e mes apartir da competencia declarada
    df["competencia_declarada"] = df["competencia_declarada"].apply(
        lambda x: str(x)[:4] + "-" + str(x)[4:]
    )
    if "competencia_movimentacao" in df.columns.tolist():
        df["competencia_movimentacao"] = df["competencia_movimentacao"].apply(
            lambda x: str(x)[:4] + "-" + str(x)[4:]
        )

    # renomeia municipio para padrao do diretorio de municipios
    rename_cols = {
        "municipio": "id_municipio_6",
    }
    df = df.rename(columns=rename_cols)

    # adiciona id_municio do diretorio de municipios
    df = df.merge(municipios, on="id_municipio_6", how="left")

    # remove strings do tipo {ñ e converte salario e tempo de emprego para float
    objct_cols = df.select_dtypes(include=["object"]).columns.tolist()

    for col in objct_cols:
        if col in ["salario_mensal", "tempo_emprego"]:
            df[col] = pd.to_numeric(
                df[col].str.replace(",", "."), downcast="float", errors="coerce"
            )
        else:
            df[col] = np.where(df[col].str.contains("{ñ"), np.nan, df[col])
    df = df.drop(["mesorregiao", "microrregiao", "uf", "competencia_declarada"], 1)
    df = df[df["sigla_uf"].notnull()]

    return df


#####======================= PADRONIZA DADOS CAGED AJUSTES =======================#####
def padroniza_caged_antigo_ajustes(df, municipios):
    ## cria colunas que nao existem em outros arquivos
    check_cols = ["ind_trab_parcial", "ind_trab_intermitente"]
    create_cols = [col for col in check_cols if col not in df.columns.tolist()]
    for col in create_cols:
        df[col] = np.nan

    hard_coded_cols = [
        "admitidos_desligados",
        "competencia_movimentacao",
        "municipio",
        "ano_movimentacao",
        "cbo_94_ocupacao",
        "cbo_2002_ocupacao",
        "cnae_10_classe",
        "faixa_empr_inicio_jan",
        "grau_instrucao",
        "qtd_hora_contrat",
        "ibge_subsetor",
        "idade",
        "ind_aprendiz",
        "salario_mensal",
        "saldo_mov",
        "sexo",
        "tempo_emprego",
        "tipo_estab",
        "tipo_mov_desagregado",
        "uf",
        "competencia_declarada",
        "bairros_sp",
        "bairros_fortaleza",
        "bairros_rj",
        "distritos_sp",
        "regioes_adm_df",
        "mesorregiao",
        "microrregiao",
        "regiao_adm_rj",
        "regiao_adm_sp",
        "regiao_corede",
        "regiao_corede_04",
        "regiao_gov_sp",
        "regiao_senac_pr",
        "regiao_senai_pr",
        "regiao_senai_sp",
        "subregiao_senai_pr",
        "regiao_metro_mte",
        "cnae_20_subclas",
        "raca_cor",
        "ind_portador_defic",
        "tipo_defic",
        "ind_trab_parcial",
        "ind_trab_intermitente",
    ]

    df.columns = hard_coded_cols

    df = clean_caged(df, municipios)
    df = df.drop(["ano_movimentacao"], 1)

    columns_rename = {
        "cbo_2002_ocupacao": "cbo_2002",
        "cbo_94_ocupacao": "cbo_94",
        "cnae_10_classe": "cnae_10",
        "cnae_20_subclas": "cnae_20_subclasse",
        "faixa_empr_inicio_jan": "faixa_emprego_inicio_janeiro",
        "qtd_hora_contrat": "quantidade_horas_contratadas",
        "ibge_subsetor": "subsetor_ibge",
        "ind_aprendiz": "indicador_aprendiz",
        "ind_portador_defic": "indicador_portador_deficiencia",
        "saldo_mov": "saldo_movimentacao",
        "tipo_estab": "tipo_estabelecimento",
        "tipo_defic": "tipo_deficiencia",
        "tipo_mov_desagregado": "tipo_movimentacao_desagregado",
        "regioes_adm_df": "regiao_administrativas_df",
        "regiao_adm_rj": "regiao_administrativas_rj",
        "regiao_adm_sp": "regiao_administrativas_sp",
        "ind_trab_parcial": "indicador_trabalho_parcial",
        "ind_trab_intermitente": "indicador_trabalho_intermitente",
        "raca_cor": "raca",
        "regiao_metro_mte": "regiao_metropolitana_mte",
    }

    df = df.rename(columns=columns_rename)

    organize_cols = [
        "competencia_movimentacao",
        "sigla_uf",
        "id_municipio",
        "id_municipio_6",
        "admitidos_desligados",
        "tipo_estabelecimento",
        "tipo_movimentacao_desagregado",
        "faixa_emprego_inicio_janeiro",
        "tempo_emprego",
        "quantidade_horas_contratadas",
        "salario_mensal",
        "saldo_movimentacao",
        "indicador_aprendiz",
        "indicador_trabalho_intermitente",
        "indicador_trabalho_parcial",
        "indicador_portador_deficiencia",
        "tipo_deficiencia",
        "cbo_94",
        "cnae_10",
        "cbo_2002",
        "cnae_20_subclasse",
        "grau_instrucao",
        "idade",
        "sexo",
        "raca",
        "subsetor_ibge",
        "bairros_sp",
        "bairros_fortaleza",
        "bairros_rj",
        "distritos_sp",
        "regiao_administrativas_df",
        "regiao_administrativas_rj",
        "regiao_administrativas_sp",
        "regiao_corede",
        "regiao_corede_04",
        "regiao_gov_sp",
        "regiao_senac_pr",
        "regiao_senai_pr",
        "regiao_senai_sp",
        "subregiao_senai_pr",
        "regiao_metropolitana_mte",
    ]

    df = df[organize_cols]
    return df


#####======================= PADRONIZA DADOS CAGED ANTIGO =======================#####
def padroniza_caged_antigo(df, municipios):
    ## cria colunas que nao existem em outros arquivos
    check_cols = ["ind_trab_parcial", "ind_trab_intermitente"]
    create_cols = [col for col in check_cols if col not in df.columns.tolist()]
    for col in create_cols:
        df[col] = np.nan

    hard_coded_cols = [
        "admitidos_desligados",
        "competencia_declarada",
        "municipio",
        "ano_declarado",
        "cbo_2002_ocupacao",
        "cnae_10_classe",
        "cnae_20_classe",
        "cnae_20_subclas",
        "faixa_empr_inicio_jan",
        "grau_instrucao",
        "qtd_hora_contrat",
        "ibge_subsetor",
        "idade",
        "ind_aprendiz",
        "ind_portador_defic",
        "raca_cor",
        "salario_mensal",
        "saldo_mov",
        "sexo",
        "tempo_emprego",
        "tipo_estab",
        "tipo_defic",
        "tipo_mov_desagregado",
        "uf",
        "bairros_sp",
        "bairros_fortaleza",
        "bairros_rj",
        "distritos_sp",
        "regioes_adm_df",
        "mesorregiao",
        "microrregiao",
        "regiao_adm_rj",
        "regiao_adm_sp",
        "regiao_corede",
        "regiao_corede_04",
        "regiao_gov_sp",
        "regiao_senac_pr",
        "regiao_senai_pr",
        "regiao_senai_sp",
        "subregiao_senai_pr",
        "ind_trab_parcial",
        "ind_trab_intermitente",
    ]

    df.columns = hard_coded_cols

    df = clean_caged(df, municipios)
    df = df.drop(["ano_declarado"], 1)

    columns_rename = {
        "cbo_2002_ocupacao": "cbo_2002",
        "cnae_10_classe": "cnae_10",
        "cnae_20_classe": "cnae_20",
        "cnae_20_subclas": "cnae_20_subclasse",
        "faixa_empr_inicio_jan": "faixa_emprego_inicio_janeiro",
        "qtd_hora_contrat": "quantidade_horas_contratadas",
        "ibge_subsetor": "subsetor_ibge",
        "ind_aprendiz": "indicador_aprendiz",
        "ind_portador_defic": "indicador_portador_deficiencia",
        "saldo_mov": "saldo_movimentacao",
        "tipo_estab": "tipo_estabelecimento",
        "tipo_defic": "tipo_deficiencia",
        "tipo_mov_desagregado": "tipo_movimentacao_desagregado",
        "regioes_adm_df": "regiao_administrativas_df",
        "regiao_adm_rj": "regiao_administrativas_rj",
        "regiao_adm_sp": "regiao_administrativas_sp",
        "ind_trab_parcial": "indicador_trabalho_parcial",
        "ind_trab_intermitente": "indicador_trabalho_intermitente",
        "raca_cor": "raca",
    }

    df = df.rename(columns=columns_rename)

    organize_cols = [
        "sigla_uf",
        "id_municipio",
        "id_municipio_6",
        "admitidos_desligados",
        "tipo_estabelecimento",
        "tipo_movimentacao_desagregado",
        "faixa_emprego_inicio_janeiro",
        "tempo_emprego",
        "quantidade_horas_contratadas",
        "salario_mensal",
        "saldo_movimentacao",
        "indicador_aprendiz",
        "indicador_trabalho_intermitente",
        "indicador_trabalho_parcial",
        "indicador_portador_deficiencia",
        "tipo_deficiencia",
        "cnae_10",
        "cbo_2002",
        "cnae_20",
        "cnae_20_subclasse",
        "grau_instrucao",
        "idade",
        "sexo",
        "raca",
        "subsetor_ibge",
        "bairros_sp",
        "bairros_fortaleza",
        "bairros_rj",
        "distritos_sp",
        "regiao_administrativas_df",
        "regiao_administrativas_rj",
        "regiao_administrativas_sp",
        "regiao_corede",
        "regiao_corede_04",
        "regiao_gov_sp",
        "regiao_senac_pr",
        "regiao_senai_pr",
        "regiao_senai_sp",
        "subregiao_senai_pr",
    ]

    df = df[organize_cols]

    return df


#####======================= PADRONIZA DADOS NOVO CAGED =======================#####


def padroniza_caged_novo(df, municipios):
    ## cria coluna ano e mes apartir da competencia declarada
    df["ano"] = df["competencia_declarada"].apply(lambda x: int(str(x)[:4]))
    df["mes"] = df["competencia_declarada"].apply(lambda x: int(str(x)[4:]))

    ## cria colunas que nao existem em outros arquivos
    df = df.drop(
        ["competencia_declarada", "uf", "regiao"],
        1,
    )

    df = clean_caged(df, municipios)

    return df


def rename_caged_novo(df, option):
    rename_cols_estabelecimentos = {
        "competaancia": "competencia_declarada",
        "regiao": "regiao",
        "uf": "uf",
        "municapio": "municipio",
        "seaao": "cnae_20_classe",
        "subclasse": "cnae_20_subclas",
        "admitidos": "admitidos",
        "desligados": "desligados",
        "fonte_desl": "fonte_desligamento",
        "saldomovimentaaao": "saldo_movimentacao",
        "tipoempregador": "tipo_empregador",
        "tipoestabelecimento": "tipo_estab",
        "tamestabjan": "faixa_empr_inicio_jan",
    }

    rename_cols_movimentacao = {
        "competaancia": "competencia_declarada",
        "regiao": "regiao",
        "uf": "uf",
        "municapio": "municipio",
        "seaao": "cnae_20_classe",
        "subclasse": "cnae_20_subclas",
        "saldomovimentaaao": "saldo_mov",
        "cbo2002ocupaaao": "cbo_2002_ocupacao",
        "categoria": "categoria_trabalhador",
        "graudeinstruaao": "grau_instrucao",
        "idade": "idade",
        "horascontratuais": "qtd_hora_contrat",
        "raaacor": "raca_cor",
        "sexo": "sexo",
        "tipoempregador": "tipo_empregador",
        "tipoestabelecimento": "tipo_estab",
        "tipomovimentaaao": "tipo_movimentacao",
        "tipodedeficiaancia": "tipo_defic",
        "indtrabintermitente": "ind_trab_intermitente",
        "indtrabparcial": "ind_trab_parcial",
        "salario": "salario_mensal",
        "tamestabjan": "faixa_empr_inicio_jan",
        "indicadoraprendiz": "ind_aprendiz",
        "fonte": "fonte_movimentacao",
    }

    if option == "movimentacao":
        df = df.rename(columns=rename_cols_movimentacao)
    else:
        df = df.rename(columns=rename_cols_estabelecimentos)

    return df
