"""
Code for scraping data from ssp_atividade_policial
"""
# pylint: disable=invalid-name, too-many-arguments, arguments-differ
import os
import datetime
import shutil
from pathlib import Path
import csv

import scrapy
import pandas as pd
import numpy as np

FILE_PAH = str(Path(__file__).parent)


def get_years():
    """
    Get all years from ssp_atividade_policial
    """
    ## years to scrapy

    current_year = datetime.datetime.now().strftime("%Y")
    return [current_year]

    # use the line bellow to scrapy all years
    # return [str(i) for i in range(2002, int(current_year) + 1)]


def normalize_cols(df):
    '''
    Normalize columns names
    '''
    return (
        df.str.normalize("NFKD")
        .str.encode("ascii", errors="ignore")
        .str.decode("utf-8")
        .str.replace("$", "")
        .str.replace("(", "")
        .str.replace(")", "")
        .str.replace("-", "")
        .str.replace(" ", "_")
        .str.lower()
        .str.replace(".", "")
        .str.replace("/", "_")
        .str.replace("__", "_")
    )


def padronize_atividade(df):
    '''
    Padronize columns names for ssp_atividade_policial
    '''
    df = df.rename(
        columns={
            "ocorrencias_de_apreensao_de_entorpecentes1": "ocorrencias_de_apreensao_de_entorpecentes",
            "geocodigo": "id_municipio",
            "regiao": "regiao_ssp",
            "no_de_armas_de_fogo_apreendidas": "numero_de_armas_de_fogo_apreendidas",
            "no_de_flagrantes_lavrados": "numero_de_flagrantes_lavrados",
            "no_de_infratores_apreendidos_em_flagrante": "numero_de_infratores_apreendidos_em_flagrante",
            "no_de_infratores_apreendidos_por_mandado": "numero_de_infratores_apreendidos_por_mandado",
            "no_de_pessoas_presas_em_flagrante": "numero_de_pessoas_presas_em_flagrante",
            "no_de_pessoas_presas_por_mandado": "numero_de_pessoas_presas_por_mandado",
            "no_de_prisoes_efetuadas": "numero_de_prisoes_efetuadas",
            "no_de_veiculos_recuperados": "numero_de_veiculos_recuperados",
            "tot_de_inqueritos_policiais_instaurados": "total_de_inqueritos_policiais_instaurados",
        }
    )
    cols = [
        "id_municipio",
        "mes",
        "regiao_ssp",
        "ocorrencias_de_porte_de_entorpecentes",
        "ocorrencias_de_trafico_de_entorpecentes",
        "ocorrencias_de_apreensao_de_entorpecentes",
        "ocorrencias_de_porte_ilegal_de_arma",
        "numero_de_armas_de_fogo_apreendidas",
        "numero_de_flagrantes_lavrados",
        "numero_de_infratores_apreendidos_em_flagrante",
        "numero_de_infratores_apreendidos_por_mandado",
        "numero_de_pessoas_presas_em_flagrante",
        "numero_de_pessoas_presas_por_mandado",
        "numero_de_prisoes_efetuadas",
        "numero_de_veiculos_recuperados",
        "total_de_inqueritos_policiais_instaurados",
    ]

    df = df[cols]
    for col in df.columns:
        df[col] = df[col].astype(str).str.replace(".", "").str.replace(",", ".")

    return df


def padronize_ocorrencias(df):
    '''
    Padronize columns names for ssp_ocorrencias
    '''
    df = df.rename(
        columns={
            "geocodigo": "id_municipio",
            "regiao": "regiao_ssp",
            "homicidio_doloso_2": "homicidio_doloso",
            "no_de_vitimas_em_homicidio_doloso_3": "numero_de_vitimas_em_homicidio_doloso",
            "total_de_estupro_4": "total_de_estupro",
            "total_de_roubo_outros_1": "total_de_roubo_outros",
            "no_de_vitimas_em_homicidio_doloso": "numero_de_vitimas_em_homicidio_doloso",
            "no_de_vitimas_em_homicidio_doloso_por_acidente_de_transito": "numero_de_vitimas_em_homicidio_doloso_por_acidente_de_transito",
            "no_de_vitimas_em_latrocinio": "numero_de_vitimas_em_latrocinio",
        }
    )
    cols = [
        "id_municipio",
        "mes",
        "regiao_ssp",
        "homicidio_doloso",
        "numero_de_vitimas_em_homicidio_doloso",
        "homicidio_doloso_por_acidente_de_transito",
        "numero_de_vitimas_em_homicidio_doloso_por_acidente_de_transito",
        "homicidio_culposo_por_acidente_de_transito",
        "homicidio_culposo_outros",
        "tentativa_de_homicidio",
        "lesao_corporal_seguida_de_morte",
        "lesao_corporal_dolosa",
        "lesao_corporal_culposa_por_acidente_de_transito",
        "lesao_corporal_culposa_outras",
        "latrocinio",
        "numero_de_vitimas_em_latrocinio",
        "total_de_estupro",
        "estupro",
        "estupro_de_vulneravel",
        "total_de_roubo_outros",
        "roubo_outros",
        "roubo_de_veiculo",
        "roubo_a_banco",
        "roubo_de_carga",
        "furto_outros",
        "furto_de_veiculo",
    ]
    df = df[cols]
    for col in df.columns:
        df[col] = df[col].astype(str).str.replace(".", "").str.replace(",", ".")

    return df


def padronize_data(df, file):
    '''
    Padronize columns names for ssp_data
    '''
    ibge_code = pd.read_csv(FILE_PAH + "/dados/utils/ssp_codigo_ibge.csv")
    mes_dict = {
        "Jan": 1,
        "Fev": 2,
        "Mar": 3,
        "Abr": 4,
        "Mai": 5,
        "Jun": 6,
        "Jul": 7,
        "Ago": 8,
        "Set": 9,
        "Out": 10,
        "Nov": 11,
        "Dez": 12,
    }
    # add ibge_code
    df = df.merge(ibge_code, on="municipio", how="inner")
    ## padronize columns name
    df.columns = normalize_cols(df.columns)
    df["mes"] = df["mes"].map(mes_dict)

    ## renmae columns and sort in correct order
    if file == "ssp_atividade_policial":
        df = padronize_atividade(df)
    else:
        df = padronize_ocorrencias(df)

    return df


def append_to_csv(df, file, ano):
    '''
    Append data to csv file
    '''
    ## define file_name and path
    file_pre = FILE_PAH + "/dados/model_data/" + file + "_MODELO.csv"
    file_pre_final = FILE_PAH + "/dados/model_data/" + file + "_MODELO_FINAL.csv"
    save_file = FILE_PAH + f"/dados/{file}/ano={ano}/{file}.csv"

    if not os.path.exists(FILE_PAH + f"/dados/{file}"):
        os.mkdir(FILE_PAH + f"/dados/{file}")

    ## create file for the first loop
    if not os.path.exists(save_file):
        os.mkdir(FILE_PAH + f"/dados/{file}/ano={ano}")
        df_modelo_final = pd.read_csv(file_pre_final, encoding="utf-8")
        df_modelo_final.to_csv(save_file, index=False, header=True, encoding="utf-8")

    ## get the correct order of original data
    with open(file_pre, encoding="utf-8") as f:
        header = next(csv.reader(f))
    columns = df.columns
    for column in set(header) - set(columns):
        df[column] = ""
    df = df[header]

    ## padronize and clean data
    df = padronize_data(df, file)

    ## append data
    df.to_csv(save_file, index=False, mode="a", header=False, encoding="utf-8")


def parse_page(response, file_name):
    '''
    Parse page and get data
    '''
    cols = response.xpath(
        '//*[@id="conteudo_repAnos_divGrid_0"]//th/font/text()'
    ).extract()

    rows = response.xpath('//*[@id="conteudo_repAnos_divGrid_0"]//tr')
    df = pd.DataFrame(columns=cols)
    ## parse html to dataframe
    for row in rows:
        row_to_add = row.xpath(".//td/text()").extract()
        if row_to_add != []:
            try:
                df.loc[len(df), :] = row_to_add
            except Exception:
                df.loc[len(df), :] = [np.nan for i in range(len(cols))]

    cols_name = ["mes"] + df["Natureza"].tolist()
    df = df.T.reset_index()
    df.columns = cols_name
    mask = (df["mes"] != "Natureza") & (df["mes"] != "Total")
    df = df[mask]

    ## print city name and year
    selected = response.xpath('//*[@selected="selected"]/text()').extract()
    print("\n\n", selected[2], selected[0], "\n\n")

    ## add new columns to original data
    ano = selected[0]
    # df["ano"] = selected[0]
    df["regiao"] = selected[1]
    df["municipio"] = selected[2]
    df["delegacia"] = selected[3]
    df["data_de_captura"] = pd.Timestamp.now()
    # print(df)

    final_cols = ["municipio", "regiao", "delegacia"] + cols_name + ["data_de_captura"]
    df = df[final_cols]

    append_to_csv(df, file_name, ano)


def get_config(response, year, regiao, municipipo, delegacia, page):
    '''
    Get config for the next page
    '''
    EVENTVALIDATION = response.xpath(
        "//*[@id='__EVENTVALIDATION']/@value"
    ).extract_first()
    VIEWSTATE = response.xpath("//*[@id='__VIEWSTATE']/@value").extract_first()
    VIEWSTATEGENERATOR = response.xpath(
        "//*[@id='__VIEWSTATEGENERATOR']/@value"
    ).extract_first()
    # VIEWSTATEGENERATOR = '79344604'
    data = {
        "__EVENTTARGET": page,
        "__VIEWSTATE": VIEWSTATE,
        "__VIEWSTATEGENERATOR": VIEWSTATEGENERATOR,
        "__EVENTVALIDATION": EVENTVALIDATION,
        "ctl00$conteudo$ddlAnos": year,
        "ctl00$conteudo$ddlRegioes": regiao,
        "ctl00$conteudo$ddlMunicipios": municipipo,
        "ctl00$conteudo$ddlDelegacias": delegacia,
    }
    header = {"Content-Type": " application/x-www-form-urlencoded"}

    return EVENTVALIDATION, VIEWSTATE, VIEWSTATEGENERATOR, data, header


def delete_years(file, years):
    '''
    Delete years from csv file
    '''
    ## delete file of respective year
    for ano in years:
        save_file = f"dados/{file}/ano={ano}/"
        if os.path.exists(save_file):
            shutil.rmtree(save_file)


class SSP_AtividadeSpider(scrapy.Spider):
    '''
    SSP_AtividadeSpider
    '''
    name = "atividade"
    site_url = "http://www.ssp.sp.gov.br/Estatistica/Pesquisa.aspx"
    # allowed_domains = ['www.fazenda.sp.gov.br/RepasseConsulta/Consulta/repasse.aspx']
    start_urls = [site_url]
    file_name = "ssp_atividade_policial"

    def parse(self, response):
        ## get the years to scrapy
        years = get_years()
        print("SSP_AtividadeSpider", years)

        ## delete previously years file
        delete_years(self.file_name, years)

        # list of all cities codes
        regiao = "0"
        municipipos = [str(i) for i in range(1, 646)]
        delegacia = "0"
        page = "ctl00$conteudo$btnPolicial"

        # iterate over all cities and years
        for municipipo in municipipos:
            for year in years:
                (
                    _,
                    _,
                    _,
                    data,
                    header,
                ) = get_config(response, year, regiao, municipipo, delegacia, page)

                yield scrapy.FormRequest(
                    self.site_url,
                    headers=header,
                    formdata=data,
                    callback=self.parse_months,
                    dont_filter=False,
                )

    def parse_months(self, response):
        '''
        Parse months
        '''
        parse_page(response, self.file_name)


class SSP_OcorrenciaSpider(scrapy.Spider):
    '''
    SSP_OcorrenciaSpider
    '''
    name = "ocorrencias"
    site_url = "http://www.ssp.sp.gov.br/Estatistica/Pesquisa.aspx"
    # allowed_domains = ['www.fazenda.sp.gov.br/RepasseConsulta/Consulta/repasse.aspx']
    start_urls = [site_url]
    file_name = "ssp_ocorrencias_registradas"

    def parse(self, response):
        '''
        Parse page and get data
        '''
        ## get the years to scrapy
        years = get_years()
        print("SSP_OcorrenciaSpider", years)
        ## delete previously years file
        delete_years(self.file_name, years)

        # list of all cities codes
        regiao = "0"
        municipipos = [str(i) for i in range(1, 646)]
        delegacia = "0"
        page = "ctl00$conteudo$btnMensal"

        # iterate over all cities and years
        for municipipo in municipipos:
            for year in years:
                (
                    _,
                    _,
                    _,
                    data,
                    header,
                ) = get_config(response, year, regiao, municipipo, delegacia, page)

                yield scrapy.FormRequest(
                    self.site_url,
                    headers=header,
                    formdata=data,
                    callback=self.parse_months,
                    dont_filter=False,
                )

    def parse_months(self, response):
        '''
        Parse months
        '''
        parse_page(response, self.file_name)


if __name__ == "__main__":
    from scrapy.crawler import CrawlerProcess

    process = CrawlerProcess()
    process.crawl(SSP_AtividadeSpider)
    process.crawl(SSP_OcorrenciaSpider)
    process.start()
    print("done")
