'''
Code to download and process the Brazilian IBGE PNAD data.
'''
# pylint: disable=invalid-name
# --------------------#
# setup
# --------------------#


import os

import pandas as pd
import numpy as np

path = "/content/gdrive/Base dos Dados/Dados/"
path_dados = path + "Bases/br_ibge_pnad/"

# --------------------#
# Tratamento e Output
# --------------------#

# cria pastas ano e UF

list_anos = [
    1981,
    1982,
    1983,
    1984,
    1985,
    1986,
    1987,
    1988,
    1989,
    1990,
    1992,
    1993,
    1995,
    1996,
    1997,
    1998,
    1999,
    2001,
    2002,
    2003,
    2004,
    2005,
    2006,
    2007,
    2008,
    2009,
    2011,
    2012,
    2013,
    2014,
    2015,
]

# list_anos = [1981, 1982] # teste

ufs = [
    "AC",
    "AL",
    "AM",
    "AP",
    "BA",
    "CE",
    "DF",
    "ES",
    "GO",
    "MA",
    "MG",
    "MS",
    "MT",
    "PA",
    "PB",
    "PE",
    "PI",
    "PR",
    "RJ",
    "RN",
    "RO",
    "RR",
    "SC",
    "SE",
    "RS",
    "SP",
    "TO",
]

id_uf = {
    "11": "RO",
    "12": "AC",
    "13": "AM",
    "14": "RR",
    "15": "PA",
    "16": "AP",
    "17": "TO",
    "21": "MA",
    "22": "PI",
    "23": "CE",
    "24": "RN",
    "25": "PB",
    "26": "PE",
    "27": "AL",
    "28": "SE",
    "29": "BA",
    "31": "MG",
    "32": "ES",
    "33": "RJ",
    "35": "SP",
    "41": "PR",
    "42": "SC",
    "43": "RS",
    "50": "MS",
    "51": "MT",
    "52": "GO",
    "53": "DF",
}

list_rename = {
    "ano": "ano",
    "sigla_uf": "sigla_uf",
    "uf": "id_uf",
    "regiao": "id_regiao",
    "metropol": "regiao_metropolitana",
    "id_dom": "id_domicilio",
    "urbana": "zona_urbana",
    "area_censit": "tipo_zona_domicilio",
    "tot_pess": "total_pessoas",
    "tot_pess_10_mais": "total_pessoas_10_mais",
    "especie_dom": "especie_domicilio",
    "tipo_dom": "tipo_domicilio",
    "parede": "tipo_parede",
    "cobertura": "tipo_cobertura",
    "agua_rede": "possui_agua_rede",
    "esgoto": "tipo_esgoto",
    "sanit_excl": "possui_sanitario_exclusivo",
    "lixo": "lixo_coletado",
    "ilum_eletr": "possui_iluminacao_eletrica",
    "comodos": "quantidade_comodos",
    "dormit": "quantidade_dormitorios",
    "sanit": "possui_sanitario",
    "posse_dom": "posse_domicilio",
    "filtro": "possui_filtro",
    "fogao": "possui_fogao",
    "geladeira": "possui_geladeira",
    "radio": "possui_radio",
    "tv": "possui_tv",
    "renda_dom": "renda_mensal_domiciliar",
    "renda_domB": "renda_mensal_domiciliar_compativel_1992",
    "peso": "peso_amostral",
    "aluguel": "aluguel",
    "prestacao": "prestacao",
    "deflator": "deflator",
    "conversor": "conversor_moeda",
    "renda_dom_def": "renda_domicilio_deflacionado",
    "renda_domB_def": "renda_mensal_domiciliar_compativel_1992_deflacionado",
    "aluguel_def": "aluguel_deflacionado",
    "prestacao_def": "prestacao_deflacionado",
    "num_fam": "numero_familia",
    "sexo": "sexo",
    "cond_dom": "condicao_domicilio",
    "cond_fam": "condicao_familia",
    "dia_nasc": "dia_nascimento",
    "mes_nasc": "mes_nascimento",
    "ano_nasc": "ano_nascimento",
    "idade": "idade",
    "ler_escrever": "sabe_ler_escrever",
    "serie_freq": "serie_frequentada",
    "grau_freq": "grau_frequentado",
    "serie_nao_freq": "ultima_serie_frequentada",
    "grau_nao_freq": "ultimo_grau_frequentado",
    "tinha_outro_trab": "tinha_outro_trabalho",
    "ocup_sem": "ocupacao_semana",
    "ramo_negocio_sem": "atividade_ramo_negocio_semana",
    "tem_carteira_assinada": "possui_carteira_assinada",
    "renda_mensal_din": "renda_mensal_dinheiro",
    "renda_mensal_prod": "renda_mensal_produto_mercadoria",
    "horas_trab_sem": "horas_trabalhadas_semana",
    "renda_mensal_din_outra": "renda_mensal_dinheiro_outra",
    "renda_mensal_prod_outra": "renda_mensal_produto_outra",
    "horas_trab_sem_outro": "horas_trabalhadas_outros_trabalhos",
    "contr_inst_prev": "contribui_previdencia",
    "qual_inst_prev": "tipo_instituto_previdencia",
    "tomou_prov_semana": "tomou_providencia_conseguir_trabalho_semana",
    "tomou_prov_2meses": "tomou_providencia_ultimos_2_meses",
    "que_prov_tomou": "qual_providencia_tomou",
    "tinha_cart_assin_ant_ano": "tinha_carteira_assinada_ultimo_emprego",
    "renda_aposentadoria": "renda_aposentadoria",
    "renda_pensao": "renda_pensao",
    "renda_abono": "renda_abono_permanente",
    "renda_aluguel": "renda_aluguel",
    "renda_outras": "renda_outras",
    "renda_mensal_ocup_prin": "renda_mensal_ocupacao_principal",
    "renda_mensal_todos_trab": "renda_mensal_todos_trabalhos",
    "renda_mensal_todas_fontes": "renda_mensal_todas_fontes",
    "ramo_negocio_agreg": "atividade_ramo_negocio_agregado",
    "horas_trab_todos_trab": "horas_trabalhadas_todos_trabalhos",
    "pos_ocup_sem": "posicao_ocupacao",
    "grupos_ocup_sem": "grupos_ocupacao",
    "num_pes_fam": "numero_membros_familia",
    "renda_mensal_fam": "renda_mensal_familia",
    "ordem": "ordem",
    "cor": "raca_cor",
    "educa": "anos_estudo",
    "freq_escola": "frequenta_escola",
    "trabalhou_semana": "trabalhou_semana",
    "tinha_trab_sem": "tinha_trabalhado_semana",
    "ocup_ant_ano": "ocupacao_ano_anterior",
    "ramo_negocio_ant_ano": "atividade_ramo_negocio_anterior",
    "renda_din_def": "renda_mensal_dinheiro_deflacionado",
    "renda_prod_def": "renda_mensal_produto_mercadoria_deflacionado",
    "renda_din_outra_def": "renda_mensal_dinheiro_outra_deflacionado",
    "renda_prod_outra_def": "renda_mensal_produto_mercadoria_outra_deflacionado",
    "renda_ocup_prin_def": "renda_mensal_ocupacao_principal_deflacionado",
    "renda_todos_trab_def": "renda_mensal_todos_trabalhos_deflacionado",
    "renda_todas_fontes_def": "renda_mensal_todas_fontes_deflacionado",
    "renda_fam_def": "renda_mensal_familia_deflacionado",
    "renda_aposentadoria_def": "renda_aposentadoria_deflacionado",
    "renda_pensao_def": "renda_pensao_deflacionado",
    "renda_abono_def": "renda_abono_deflacionado",
    "renda_aluguel_def": "renda_aluguel_deflacionado",
    "renda_outras_def": "renda_outras_deflacionado",
}

list_ordem = [
    "ano",
    "sigla_uf",
    "id_uf",
    "id_regiao",
    "regiao_metropolitana",
    "id_domicilio",
    "zona_urbana",
    "tipo_zona_domicilio",
    "total_pessoas",
    "total_pessoas_10_mais",
    "especie_domicilio",
    "tipo_domicilio",
    "tipo_parede",
    "tipo_cobertura",
    "possui_agua_rede",
    "tipo_esgoto",
    "possui_sanitario_exclusivo",
    "lixo_coletado",
    "possui_iluminacao_eletrica",
    "quantidade_comodos",
    "quantidade_dormitorios",
    "possui_sanitario",
    "posse_domicilio",
    "possui_filtro",
    "possui_fogao",
    "possui_geladeira",
    "possui_radio",
    "possui_tv",
    "renda_mensal_domiciliar",
    "renda_mensal_domiciliar_compativel_1992",
    "peso_amostral",
    "aluguel",
    "prestacao",
    "deflator",
    "conversor_moeda",
    "renda_domicilio_deflacionado",
    "renda_mensal_domiciliar_compativel_1992_deflacionado",
    "aluguel_deflacionado",
    "prestacao_deflacionado",
    "numero_familia",
    "sexo",
    "condicao_domicilio",
    "condicao_familia",
    "dia_nascimento",
    "mes_nascimento",
    "ano_nascimento",
    "idade",
    "sabe_ler_escrever",
    "serie_frequentada",
    "grau_frequentado",
    "ultima_seria_frequentada",
    "ultimo_grau_frequentado",
    "tinha_outro_trabalho",
    "ocupacao_semana",
    "atividade_ramo_negocio_semana",
    "possui_carteira_assinada",
    "renda_mensal_dinheiro",
    "renda_mensal_produto_mercadoria",
    "horas_trabalhadas_semana",
    "renda_mensal_dinheiro_outra",
    "renda_mensal_produto_outra",
    "horas_trabalhadas_outros_trabalhos",
    "contribui_previdencia",
    "tipo_instituto_previdencia",
    "tomou_providencia_conseguir_trabalho_semana",
    "tomou_providencia_ultimos_2_meses",
    "qual_providencia_tomou",
    "tinha_carteira_assinada_ultimo_emprego",
    "renda_aposentadoria",
    "renda_pensao",
    "renda_abono_permanente",
    "renda_aluguel",
    "renda_outras",
    "renda_mensal_ocupacao_principal",
    "renda_mensal_todos_trabalhos",
    "renda_mensal_todas_fontes",
    "atividade_ramo_negocio_agregado",
    "horas_trabalhadas_todos_trabalhos",
    "posicao_ocupacao",
    "grupos_ocupacao",
    "numero_membros_familia",
    "renda_mensal_familia",
    "ordem",
    "raca_cor",
    "anos_estudo",
    "frequenta_escola",
    "trabalhou_semana",
    "tinha_trabalhado_semana",
    "ocupacao_ano_anterior",
    "atividade_ramo_negocio_anterior",
    "renda_mensal_dinheiro_deflacionado",
    "renda_mensal_produto_mercadoria_deflacionado",
    "renda_mensal_dinheiro_outra_deflacionado",
    "renda_mensal_produto_mercadoria_outra_deflacionado",
    "renda_mensal_ocupacao_principal_deflacionado",
    "renda_mensal_todos_trabalhos_deflacionado",
    "renda_mensal_todas_fontes_deflacionado",
    "renda_mensal_familia_deflacionado",
    "renda_aposentadoria_deflacionado",
    "renda_pensao_deflacionado",
    "renda_abono_deflacionado",
    "renda_aluguel_deflacionado",
    "renda_outras_deflacionado",
]

list_domicilio = [
    "ano",
    "sigla_uf",
    "id_uf",
    "id_regiao",
    "regiao_metropolitana",
    "id_domicilio",
    "zona_urbana",
    "tipo_zona_domicilio",
    "total_pessoas",
    "total_pessoas_10_mais",
    "especie_domicilio",
    "tipo_domicilio",
    "tipo_parede",
    "tipo_cobertura",
    "possui_agua_rede",
    "tipo_esgoto",
    "possui_sanitario_exclusivo",
    "lixo_coletado",
    "possui_iluminacao_eletrica",
    "quantidade_comodos",
    "quantidade_dormitorios",
    "possui_sanitario",
    "posse_domicilio",
    "possui_filtro",
    "possui_fogao",
    "possui_geladeira",
    "possui_radio",
    "possui_tv",
    "renda_mensal_domiciliar",
    "renda_mensal_domiciliar_compativel_1992",
    "aluguel",
    "prestacao",
    "deflator",
    "conversor_moeda",
    "renda_domicilio_deflacionado",
    "renda_mensal_domiciliar_compativel_1992_deflacionado",
    "aluguel_deflacionado",
    "prestacao_deflacionado",
    "peso_amostral",
]

list_pessoa = [
    "ano",
    "sigla_uf",
    "id_uf",
    "id_regiao",
    "regiao_metropolitana",
    "id_domicilio",
    "numero_familia",
    "condicao_domicilio",
    "condicao_familia",
    "numero_membros_familia",
    "ordem",
    "sexo",
    "dia_nascimento",
    "mes_nascimento",
    "ano_nascimento",
    "idade",
    "raca_cor",
    "sabe_ler_escrever",
    "frequenta_escola",
    "serie_frequentada",
    "grau_frequentado",
    "ultima_serie_frequentada",
    "ultimo_grau_frequentado",
    "anos_estudo",
    "tinha_outro_trabalho",
    "ocupacao_semana",
    "atividade_ramo_negocio_semana",
    "possui_carteira_assinada",
    "renda_mensal_dinheiro",
    "renda_mensal_produto_mercadoria",
    "horas_trabalhadas_semana",
    "renda_mensal_dinheiro_outra",
    "renda_mensal_produto_outra",
    "horas_trabalhadas_outros_trabalhos",
    "contribui_previdencia",
    "tipo_instituto_previdencia",
    "tomou_providencia_conseguir_trabalho_semana",
    "tomou_providencia_ultimos_2_meses",
    "qual_providencia_tomou",
    "tinha_carteira_assinada_ultimo_emprego",
    "renda_aposentadoria",
    "renda_pensao",
    "renda_abono_permanente",
    "renda_aluguel",
    "renda_outras",
    "renda_mensal_ocupacao_principal",
    "renda_mensal_todos_trabalhos",
    "renda_mensal_todas_fontes",
    "atividade_ramo_negocio_agregado",
    "horas_trabalhadas_todos_trabalhos",
    "posicao_ocupacao",
    "grupos_ocupacao",
    "renda_mensal_familia",
    "trabalhou_semana",
    "tinha_trabalhado_semana",
    "ocupacao_ano_anterior",
    "atividade_ramo_negocio_anterior",
    "renda_mensal_dinheiro_deflacionado",
    "renda_mensal_produto_mercadoria_deflacionado",
    "renda_mensal_dinheiro_outra_deflacionado",
    "renda_mensal_produto_mercadoria_outra_deflacionado",
    "renda_mensal_ocupacao_principal_deflacionado",
    "renda_mensal_todos_trabalhos_deflacionado",
    "renda_mensal_todas_fontes_deflacionado",
    "renda_mensal_familia_deflacionado",
    "renda_aposentadoria_deflacionado",
    "renda_pensao_deflacionado",
    "renda_abono_deflacionado",
    "renda_aluguel_deflacionado",
    "renda_outras_deflacionado",
]

# --------------------#
# Particao e Output
# --------------------#


for i in list_anos:
    for uf in ufs:

        directory = (
            path_dados
            + "output/microdados_compatibilizados_domicilio/ano={}/sigla_uf={}".format(
                i, uf
            )
        )
        if not os.path.exists(directory):
            os.makedirs(directory)

        directory = (
            path_dados
            + "output/microdados_compatibilizados_pessoa/ano={}/sigla_uf={}".format(
                i, uf
            )
        )
        if not os.path.exists(directory):
            os.makedirs(directory)

for ano in list_anos:

    df = pd.read_stata(path_dados + "input/" + f"{ano}_merge.dta")
    df["sigla_uf"] = df["uf"].map(id_uf)
    df = df.rename(columns=list_rename)
    for column in list_ordem:
        if column not in df:
            df[column] = np.nan

    df_domicilio = df[list_domicilio].drop_duplicates()
    df_pessoa = df[list_pessoa]

    for uf in ufs:
        print("Particionando {}-{}".format(ano, uf))

        df_partition = df_domicilio[df_domicilio["sigla_uf"] == uf]
        df_partition.drop(["sigla_uf", "ano"], axis=1, inplace=True)
        partition_path = (
            path_dados
            + "output/microdados_compatibilizados_domicilio/ano={}/sigla_uf={}/microdados_compatibilizados_domicilio.csv".format(
                ano, uf
            )
        )
        df_partition.to_csv(
            partition_path,
            index=False,
            encoding="utf-8",
            na_rep="",
            float_format="%.0f",
        )

        df_partition = df_pessoa[df_pessoa["sigla_uf"] == uf]
        df_partition.drop(["sigla_uf", "ano"], axis=1, inplace=True)
        partition_path = (
            path_dados
            + "output/microdados_compatibilizados_pessoa/ano={}/sigla_uf={}/microdados_compatibilizados_pessoa.csv".format(
                ano, uf
            )
        )
        df_partition.to_csv(
            partition_path,
            index=False,
            encoding="utf-8",
            na_rep="",
            float_format="%.0f",
        )
