"""
 ETL caged
"""

# pylint: disable=C0303
# pylint: disable=W0621
# pylint: disable=C0103

from glob import glob

import re

from tqdm import tqdm

from unidecode import unidecode

import pandas as pd

import basedosdados as bd



query = """
    SELECT 
        id_municipio,
        SAFE_CAST(id_municipio_6 AS int64) id_municipio_6
    FROM `basedosdados.br_bd_diretorios_brasil.municipio` 
    """
df_municipio = bd.read_sql(query, billing_project_id = "basedosdados-dev")


list_rename = { 'regiao'                : 'id_regiao',
                'municipio'             : 'id_municipio_6',
                'secao'                 : 'cnae_2_secao',
                'subclasse'             : 'cnae_2_subclasse',
                'saldomovimentacao'     : 'saldo_movimentacao',
                'cbo2002ocupacao'       : 'cbo_2002'	,
                'categoria'             : 'categoria'	,
                'graudeinstrucao'       : 'grau_instrucao',
                'idade'                 : 'idade',
                'horascontratuais'      : 'horas_contratuais',
                'racacor'               : 'raca_cor',
                'sexo'                  : 'sexo',
                'tipoempregador'        : 'tipo_empregador'	,
                'tipoestabelecimento'   : 'tipo_estabelecimento',
                'tipomovimentacao'      : 'tipo_movimentacao',
                'tipodedeficiencia'     : 'tipo_deficiencia',
                'indtrabintermitente'   : 'indicador_trabalho_intermitente',
                'indtrabparcial'        : 'indicador_trabalho_parcial',
                'salario'               : 'salario_mensal',
                'tamestabjan'           : 'tamanho_estabelecimento_janeiro',
                'indicadoraprendiz'     : 'indicador_aprendiz',
                'origemdainformacao'    : 'origem_informacao',
                'competenciadec'        : 'competencia',
                'indicadordeforadoprazo': 'indicador_fora_prazo',
                'ano'                   : 'ano',
                'mes'                   : 'mes',
                'sigla_uf'              : 'sigla_uf'}  
# pylint: disable=C0303
list_ordem = [  
    'competenciamov',
    'uf',
    'id_regiao',
    'id_municipio',
    'id_municipio_6',
    'cnae_2_secao',
    'cnae_2_subclasse',
    'cbo_2002'	,
    'saldo_movimentacao',
    'categoria'	,
    'grau_instrucao',
    'idade',
    'horas_contratuais',
    'raca_cor',
    'sexo',
    'salario_mensal',
    'tipo_empregador'	,
    'tipo_estabelecimento',
    'tipo_movimentacao',
    'tipo_deficiencia',
    'indicador_trabalho_intermitente',
    'indicador_trabalho_parcial',
    'tamanho_estabelecimento_janeiro',
    'indicador_aprendiz',
    'origem_informacao',
    'competencia',
    'indicador_fora_prazo']

def build_partitions(group: str, list_rename, list_ordem) -> str:
    """
    build partitions from gtup files
    group: cagedmov | cagedfor | cagedexc
    """
    input_files = glob(f"/tmp/novo_caged/{group}/input/*txt")
    for filename in tqdm(input_files):
        dataframe = pd.read_csv(filename, sep=";", dtype={"uf": str})
        date = re.search(r"\d+", filename).group()
        print(date)
        ano = date[:4]
        mes = int(date[-2:])

        dataframe.columns = [unidecode(col) for col in dataframe.columns]

        dict_uf = {
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

        dataframe["uf"] = dataframe["uf"].map(dict_uf)

        dataframe = dataframe.rename(columns = list_rename)  

        dataframe = dataframe.merge(df_municipio, on = "id_municipio_6", how = "left")

        dataframe = dataframe[list_ordem]      
        

        for state in dict_uf.values():
            data = dataframe[dataframe["uf"] == state]
            data.drop(["competenciamov", "uf", "id_regiao", "competencia"], axis=1, inplace=True)
            data.to_csv(
                f"/tmp/novo_caged/{group}/ano={ano}/mes={mes}/sigla_uf={state}/data.csv",
                index=False,
            )
            del data
        del dataframe

    return "/tmp/novo_caged/{group}/"


build_partitions('cagedexc', list_rename, list_ordem)
