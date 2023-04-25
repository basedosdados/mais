import requests
from lxml import html
import pandas as pd
import numpy as np
from pathlib import Path
from typing import List
from io import StringIO
import datetime as dt
import os


#---- functions to download data
def extract_download_links(url, xpath):
    """this function extract all download links from bcb agencias website
    Args:
        url (_type_): _description_
        xpath (_type_): _description_
    Returns:
        _type_: _description_
    """    

    """extract all download links from bcb agencias website
    Args:
        url (str): bcb url https://www.bcb.gov.br/fis/info/agencias.asp?frame=1
        xpath (str): xpath which contais donwload links
    Returns:
        list: a list of file links
    """
    # Send a GET request to the URL
    response = requests.get(url)

    # Parse the HTML content of the response using lxml
    tree = html.fromstring(response.content)

    # Extract all the values from the given XPath
    values = tree.xpath(xpath + '/option/@value')

    return values


#the other steps are a matter of trasnlating and modularizing R code into python


#---- dictionaries do rename variables
def rename_variables(
    df : pd.DataFrame
)-> pd.DataFrame:
    
    """rename variables from a dataframe of br_bcb_sicor datasets
    Args:
        df (dataframe): dataframe to be renamed from br_bcb_sicor datasets
    Returns:
        dataframe: dataframe with renamed variables from br_bcb_sicor datasets
    """

    dict_rename = {
    #operacao e operacao_recursos_publicos
    '#REF_BACEN': 'id_referencia_bacen',
    'NU_ORDEM': 'numero_ordem',
    'CD_ESTADO': 'sigla_uf',
    'CD_CATEG_EMITENTE': 'id_categoria_emitente',
    'CD_EMPREENDIMENTO': 'id_empreendimento',
    'CD_FASE_CICLO_PRODUCAO': 'id_fase_ciclo_producao',
    'CD_FONTE_RECURSO': 'id_fonte_recurso',
    'CD_INST_CREDITO': 'id_instrumento_credito',
    'CD_PROGRAMA': 'id_programa',
    'CD_REF_BACEN_INVESTIMENTO': 'id_referencia_bacen_investimento',
    'CD_SUBPROGRAMA': 'id_subprograma',
    'CD_TIPO_AGRICULTURA': 'id_tipo_agricultura',
    'CD_TIPO_CULTIVO': 'id_tipo_cultivo',
    'CD_TIPO_ENCARG_FINANC': 'id_tipo_encargo_financeiro',
    'CD_TIPO_GRAO_SEMENTE': 'id_tipo_grao_semente',
    'CD_TIPO_INTGR_CONSOR': 'id_tipo_integracao_consorcio',
    'CD_TIPO_IRRIGACAO': 'id_tipo_irrigacao',
    'CD_TIPO_SEGURO': 'id_tipo_seguro',
    'CNPJ_AGENTE_INVEST': 'cnpj_agente_investimento',
    'CNPJ_IF': 'cnpj_basico_instituicao_financeira',
    'DT_EMISSAO': 'data_emissao',
    'DT_VENCIMENTO': 'data_vencimento',
    'DT_FIM_COLHEITA': 'data_fim_colheita',
    'DT_FIM_PLANTIO': 'data_fim_plantio',
    'DT_INIC_COLHEITA': 'data_inicio_colheita',
    'DT_INIC_PLANTIO': 'data_inicio_plantio',
    'VL_AREA_FINANC': 'area_financiada',
    'VL_ALIQ_PROAGRO': 'valor_aliquota_proagro',
    'VL_PARC_CREDITO': 'valor_parcela_credito',
    'VL_PRESTACAO_INVESTIMENTO': 'valor_prestacao_investimento',
    'VL_REC_PROPRIO': 'valor_recurso_proprio',
    'VL_RECEITA_BRUTA_ESPERADA': 'valor_receita_bruta_esperada',
    'VL_REC_PROPRIO_SRV': 'valor_recurso_proprio_srv',
    'VL_QUANTIDADE': 'valor_quantidade_itens_financiados',
    'VL_PRODUTIV_OBTIDA': 'valor_produtividade_obtida',
    'VL_PREV_PROD': 'valor_previsao_producao',
    'VL_JUROS': 'taxa_juro',
    'VL_JUROS_ENC_FINAN_POSFIX': 'taxa_juro_encargo_financeiro_posfixado',
    'VL_PERC_RISCO_STN': 'valor_percentual_risco_stn',
    'VL_PERC_CUSTO_EFET_TOTAL': 'valor_percentual_custo_efetivo_total',
    'VL_PERC_RISCO_FUNDO_CONST': 'valor_percentual_risco_fundo_constitucional',
    'CD_CONTRATO_STN' : 'id_contrato_sistema_tesouro_nacional',
    'CD_CNPJ_CADASTRANTE' : 'cnpj_cadastrante',
    
    #liberacao
    "#LIR_DT_LIBERACAO": "data_liberacao",
    "LIR_VL_LIBERADO": "valor_liberado",
    "REF_BACEN": "id_referencia_bacen",
    "NU_ORDEM": "numero_ordem",

    #saldos
    '#REF_BACEN' : 'id_referencia_bacen',
    'NU_ORDEM' : 'numero_ordem', 
    'CD_SITUACAO_OPERACAO' : 'id_situacao_operacao',
    'ANO_BASE' : 'ano', 
    'MES_BASE' : 'mes' ,
    'VL_MEDIO_DIARIO' : 'valor_medio_diario' ,
    'VL_MEDIO_DIARIO_VINCENDO' : 'valor_medio_diario_vincendo',
    'VL_ULTIMO_DIA' : 'valor_ultimo_dia',

    #recurso_publico_gleba
    'REF_BACEN' : 'id_referencia_bacen',
    'NU_ORDEM' : 'numero_ordem',
    'NU_IDENTIFICADOR' : 'numero_identificador_gleba',
    'NU_INDICE_GLEBA' : 'indice_indice_gleba',
    'NU_INDICE_PONTO' : 'indice_indice_ponto',
    'VL_LATITUDE' : 'latitude',
    'VL_LONGITUDE' : 'longitude',
    'CGL_VL_ALTITUDE' : 'altitude',

    #recurso_publico_cooperado
    
    'CPF_CNPJ' :   'tipo_cpf_cnpj',
    'TIPO_PESSOA' : 'tipo_pessoa',
    'VL_PARCELA' : 'valor_parcela',

    #recurso_publico_complemento
    'REF_BACEN_EFETIVO' : 'id_referencia_bacen_efetivo',
    # ! pode ser uma parte do cnjp da instituição financeira
    'AGENCIA_IF' : 'id_agencia',
    'CD_IBGE_MUNICIPIO' : 'id_municipio',

    #recurso_publico_propriedade
    'CD_CNPJ_CPF' : 'tipo_cpf_cnpj',
    'CD_SNCR' :  'id_sncr',
    'CD_NIRF' : 'id_nirf',
    'CD_CAR' : 'id_car',

    #recurso_publico_mutuario

    '#CD_SEXO' : 'indicador_sexo' ,
    'CD_CPF_CNPJ' : 'tipo_cpf_cnpj',
    'CD_TIPO_BENEFICIARIO' : 'tipo_beneficiario',
    'CD_DAP' : 'id_dap',

    #empreendimento

    '#CODIGO': 'id_empreendimento',
    'DATA_INICIO': 'data_inicio',
    'DATA_FIM':  'data_fim',
    'FINALIDADE': 'finalidade',
    'ATIVIDADE': 'atividade',
    'MODALIDADE': 'modalidade',
    'PRODUTO': 'produto',
    'VARIEDADE': 'variedade',
    'CESTA': 'cesta',
    'ZONEAMENTO': 'zoneamento',
    'UNIDADE_MEDIDA': 'unidade_medida',
    'UNIDADE_MEDIDA_PREVISAO': 'unidade_medida_previsao_producao',
    'CONSORCIO': 'consorcio',
    'CEDULA_MAE': 'cedula_mae',
    'CD_TIPO_CULTURA' : 'id_tipo_cultura'

    }
    
    
    df = df.rename(
        columns=dict_rename
    )

    return df



#---- fucntions to set data types

def microdados_operacao_dtypes()-> dict:
    """this function have no inputs, but returns 
    a dictionary with the data types for the microdados_operacao table

    Returns:
        dict: with the data types for the microdados_operacao table
    """    
    dict_type = {

    'DATA_EMISSAO': str,
    'DT_VENCIMENTO': str,
    'CD_ESTADO': str,
    '#REFBACEN': str,
    'NU_ORDEM': str,
    'CD_CATEG_EMITENTE': str,
    'CD_EMPREENDIMENTO': str,
    'CD_FASE_CICLO_PRODUCAO': str,
    'CD_FONTE_RECURSO': str,
    'CD_INST_CREDITO': str,
    'CD_PROGRAMA': str,
    'CD_REF_BACEN_INVESTIMENTO': str,
    'CD_SUBPROGRAMA': str,
    'CD_TIPO_AGRICULTURA': str,
    'CD_TIPO_CULTIVO': str,
    'CD_TIPO_ENCARG_FINANC': str,
    'CD_TIPO_GRAO_SEMENTE': str,
    'CD_TIPO_INTGR_CONSOR': str,
    'CD_TIPO_IRRIGACAO': str,
    'CD_TIPO_SEGURO': str,
    'CNPJ_AGENTE_INVEST': str,
    'CNPJ_IF': str,
    'CD_CONTRATO_STN': str,
    'CD_CNPJ_CADASTRANTE': str,
    'DT_FIM_COLHEITA': str,
    'DT_FIM_PLANTIO': str,
    'DT_INIC_COLHEITA': str,
    'DT_INIC_PLANTIO': str,
    'VL_AREA_FINANC': float,
    'VL_ALIQ_PROAGRO': float,
    'VL_PARC_CREDITO': float,
    'VL_PRESTACAO_INVESTIMENTO': float,
    'VL_REC_PROPRIO': float,
    'VL_RECEITA_BRUTA_ESPERADA': float,
    'VL_REC_PROPRIO_SRV': float,
    'VL_QUANTIDADE': float,
    'VL_PRODUTIV_OBTIDA': float,
    'VL_PREV_PROD': float,
    'VL_JUROS': float,
    'VL_JUROS_ENC_FINAN_POSFIX': float,
    'VL_PERC_CUSTO_EFET_TOTAL': float,
    'VL_PERC_RISCO_FUNDO_CONST': float,
    'VL_PERC_RISCO_STN': float
    }

    return dict_type

def microdados_liberacao_dtypes()-> dict:
    """this function have no inputs, but returns 
    a dictionary with the data types for the microdados_liberacao table

    Returns:
        dict: with the data types for the microdados_liberacao table
    """ 
    dtypes_dict = {
    '#REFBACEN': str,
    "#LIR_DT_LIBERACAO": str,
    "LIR_VL_LIBERADO": float,
    "NU_ORDEM": str
    }

    return dtypes_dict

def microdados_saldo_dtypes() -> dict:
    """this function have no inputs, but returns 
    a dictionary with the data types for the microdados_saldo table

    Returns:
        dict: with the data types for the microdados_saldo table
    """ 
    dtypes_dict = {

    '#REF_BACEN' : str,
    'NU_ORDEM' : str, 
    'CD_SITUACAO_OPERACAO' : str,
    'ANO_BASE' : str, 
    'MES_BASE' : str ,
    'VL_MEDIO_DIARIO' : float ,
    'VL_MEDIO_DIARIO_VINCENDO' : float,
    'VL_ULTIMO_DIA' : float,
    }

    return dtypes_dict

def empreendimentos_dtypes() -> dict:
    """this function have no inputs, but returns 
    a dictionary with the data types for the microdados_saldo table

    Returns:
        dict: with the data types for the microdados_saldo table
    """ 
    
    dtypes_dict = {

    '#CODIGO': str,
    'DATA_INICIO': str,
    'DATA_FIM':  str,
    'FINALIDADE': str,
    'ATIVIDADE': str,
    'MODALIDADE': str,
    'PRODUTO': str,
    'VARIEDADE': str,
    'CESTA': str,
    'ZONEAMENTO': str,
    'UNIDADE_MEDIDA': str,
    'UNIDADE_MEDIDA_PREVISAO': str,
    'CONSORCIO': str,
    'CEDULA_MAE': str,
    'CD_TIPO_CULTURA' : str
    }

    return dtypes_dict


def microdados_recurso_publico_gleba_dtype() -> dict:
    """this function have no inputs, but returns 
    a dictionary with the data types for the recurso_publico_gleba table

    Returns:
        dict: with the data types for the recurso_publico_gleba table
    """ 

    dtypes_dict = {
    '#REF_BACEN' : str,
    'NU_ORDEM' : str,
    'NU_IDENTIFICADOR' : str,
    'NU_INDICE_GLEBA' : str,
    'NU_INDICE_PONTO' : str,
    'VL_LATITUDE' : float,
    'VL_LONGITUDE' : float,
    'CGL_VL_ALTITUDE' : float,
    }

    return dtypes_dict

def microdados_recurso_publico_cooperado_dtype() -> dict:
    """this function have no inputs, but returns
    a dictionary with the data types for the recurso_publico_cooperado table

    Returns:
        dict: with the data types for the recurso_publico_gleba table
    """   

    dtypes_dict = {
        '#REF_BACEN' : str,
        'NU_ORDEM' : str,
        'CPF_CNPJ' :   str,
        'TIPO_PESSOA' : str,
        'VL_PARCELA' : float
    }

    return dtypes_dict


def microdados_recurso_publico_complemento() -> dict:

    dtypes_dict = {
        '#REF_BACEN' : str,
        'NU_ORDEM' : str,
        'REF_BACEN_EFETIVO' : str,
        'AGENCIA_IF' : str,
        'CD_IBGE_MUNICIPIO' : str
    }

    return dtypes_dict

def  microdados_recurso_publico_propriedade_dtype() -> dict:
    """this function have no inputs, but returns 
    a dictionary with the data types for the recurso_publico_gleba table

    Returns:
        dict: with the data types for the recurso_publico_gleba table
    """ 

    dtypes_dict = {
        '#REF_BACEN' : str,
        'NU_ORDEM' : str,
        'CD_CNPJ_CPF' : str,
        'CD_SNCR' :  str,
        'CD_NIRF' : str,
        'CD_CAR' : str
    }

    return dtypes_dict

def microdados_recurso_publico_mutuario_dtype() -> dict:
    """this function have no inputs, but returns 
    a dictionary with the data types for the recurso_publico_mutuario table

    Returns:
        dict: with the data types for the recurso_publico_mutuario table
    """ 

    dtypes_dict = {
        '#CD_SEXO' : str ,
        'CD_CPF_CNPJ' : str,
        'CD_TIPO_BENEFICIARIO' : str,
        'CD_DAP' : str
    }

    return dtypes_dict
# todo: zfill com 3 casas a eqsuerda em tipo_beneficiario
# todo: adicionar no dicionario   

#---- functions to create ano safra

def create_plano_safra_emissao(df: pd.DataFrame, mes_col: str, ano_col: str) -> pd.DataFrame:
    """Takes a dataframe, a month column, and a year column, and returns the dataframe with a new column for the safra emissao

    Args:
        df (pd.DataFrame): a dataframe
        mes_col (str): the name of the column containing the month values
        ano_col (str): the name of the column containing the year values

    Returns:
        pd.DataFrame: the input dataframe with a new column for the safra emissao
    """
    def safra_emissao(mes, ano):
        if mes in [1, 2, 3, 4, 5, 6]:
            return f"{ano-1}/{ano}"
        else:
            return f"{ano}/{ano+1}"

    # create the vectorized function
    v_safra_emissao = np.vectorize(safra_emissao)

    # apply the vectorized function to the dataframe
    df['plano_safra_emissao'] = v_safra_emissao(df[mes_col], df[ano_col])

    return df

def create_plano_safra_vencimento(
    df: pd.DataFrame, 
    mes_col: str, 
    ano_col: str
) -> pd.DataFrame:
    """Takes a dataframe, a month column, and a year column, and returns the dataframe with a new column for the safra vencimento

    Args:
        df (pd.DataFrame): a dataframe
        mes_col (str): the name of the column containing the month values
        ano_col (str): the name of the column containing the year values

    Returns:
        pd.DataFrame: the input dataframe with a new column for the safra vencimento
    """
    def safra_vencimento(mes, ano):
        if mes in [1, 2, 3, 4, 5, 6]:
            return f"{ano-1}/{ano}"
        else:
            return f"{ano}/{ano+1}"

    # create the vectorized function
    v_safra_vencimento = np.vectorize(safra_vencimento)

    # apply the vectorized function to the dataframe
    df['plano_safra_vencimento'] = v_safra_vencimento(df[mes_col], df[ano_col])

    return df

#---- function to create dates variables

def format_dates(df: pd.DataFrame, columns: list) -> pd.DataFrame:
    """Format dates from a dataframe of br_bcb_sicor datasets

    Args:
        df (pd.DataFrame): dataframe to be formatted from br_bcb_sicor datasets
        columns (list): list of columns to format

    Returns:
        pd.DataFrame: dataframe with formatted dates
    """
    errors = []
    for col in columns:
        try:
            # Try parsing date with time format
            df[col] = pd.to_datetime(df[col], format='%m/%d/%Y %H:%M:%S').dt.strftime('%Y-%m-%d')
        except ValueError:
            try:
                # Try parsing date without time format
                df[col] = pd.to_datetime(df[col], format='%m/%d/%Y').dt.strftime('%Y-%m-%d')
            except ValueError as e:
                errors.append(f"{col}: {str(e)}")

    if errors:
        print("The following errors occurred while formatting date columns:")
        for error in errors:
            print(error)

    return df


def find_data_columns(
    df: pd.DataFrame
):
    """
    This function takes a Pandas DataFrame as input and returns the column names
    that contain the string 'data' in their column names.
    """
    return [col for col in df.columns if 'data' in col.lower()]

#---- function to create month year variable
#! gotta change and apply after the dates are formatted
# todo: modificar para rodar microdados_liberacao
def extract_create_year_month(
    df: pd.DataFrame, 
    data_emissao : str,
    data_vencimento : str
) -> pd.DataFrame:
    """Takes a dataframe and a data column and returns a dataframe with ano and mes columns

    Args:
        df (pd.DataFrame): a dataframe
        data_emissao (str): the name of the column containing the date values
        data_vencimento (str): the name of the column containing the date values
    Returns:
        pd.DataFrame: a dataframe with date column
    """    
    
    # ! if theres a NA or NULL date the code will break
    # todo: e se eu quiser criar somente ano e mes? 

    #inserie ano e mes vencimento na arquitetura )
    #df['ano_vencimento'] = df[data_vencimento].str[:4].astype(int)
    #df['mes_vencimento'] = df[data_vencimento].str[5:7].astype(int)

    try:
        df['ano'] =  df[data_emissao].str[:4].astype(int)
        df['mes'] =  df[data_emissao].str[5:7].astype(int)
        df['ano_vencimento'] = df[data_vencimento].str[:4].astype(int)
        df['mes_vencimento'] = df[data_vencimento].str[5:7].astype(int)

    except ValueError as e:
        
        print(f"Error: {e}.")

    return df
   
    
#---- function to partitionate data extrated from pipelines utils bd repo
def to_partitions(data: pd.DataFrame, partition_columns: List[str], savepath: str):
    """Save data in to hive patitions schema, given a dataframe and a list of partition columns.
    Args:
        data (pandas.core.frame.DataFrame): Dataframe to be partitioned.
        partition_columns (list): List of columns to be used as partitions.
        savepath (str, pathlib.PosixPath): folder path to save the partitions
    Exemple:
        data = {
            "ano": [2020, 2021, 2020, 2021, 2020, 2021, 2021,2025],
            "mes": [1, 2, 3, 4, 5, 6, 6,9],
            "sigla_uf": ["SP", "SP", "RJ", "RJ", "PR", "PR", "PR","PR"],
            "dado": ["a", "b", "c", "d", "e", "f", "g",'h'],
        }
        to_partitions(
            data=pd.DataFrame(data),
            partition_columns=['ano','mes','sigla_uf'],
            savepath='partitions/'
        )
    """

    if isinstance(data, (pd.core.frame.DataFrame)):

        savepath = Path(savepath)

        # create unique combinations between partition columns
        unique_combinations = (
            data[partition_columns]
            .drop_duplicates(subset=partition_columns)
            .to_dict(orient="records")
        )

        for filter_combination in unique_combinations:
            patitions_values = [
                f"{partition}={value}"
                for partition, value in filter_combination.items()
            ]

            # get filtered data
            df_filter = data.loc[
                data[filter_combination.keys()]
                .isin(filter_combination.values())
                .all(axis=1),
                :,
            ]
            df_filter = df_filter.drop(columns=partition_columns)

            # create folder tree
            filter_save_path = Path(savepath / "/".join(patitions_values))
            filter_save_path.mkdir(parents=True, exist_ok=True)
            file_filter_save_path = Path(filter_save_path) / "data.csv"

            # append data to csv
            df_filter.to_csv(
                file_filter_save_path,
                index=False,
                mode="a",
                header=not file_filter_save_path.exists(),
            )
    else:
        raise BaseException("Data need to be a pandas DataFrame")


#---- function to order columns

def create_column_order(
    url_architecture: str
)-> List:
    """URL contendo a tabela de arquitetura no formato da base dos dados

    Args:
        url_architecture (str): url de tabela de arquitera no padrão da base dos dados

    Returns:
        List: uma lista com a ordem final das colunas da tabela
    """    
    # Converte a URL de edição para um link de exportação em formato csv
    url = url_architecture.replace("edit#gid=", "export?format=csv&gid=")
    
    # Coloca a arquitetura em um dataframe
    df_architecture = pd.read_csv(StringIO(requests.get(url, timeout=10).content.decode("utf-8")))
    
    # Cria um dicionário de nomes de colunas e tipos de dados a partir do dataframe df_architecture
    lista_ordem = list(df_architecture['name'])
    
    # Altera o tipo de dado das colunas em df_table com base no dicionário datatype_dict
    # Retorna o dataframe com os tipos de dados alterados
    return lista_ordem

#--- function to drop rows by value
def drop_rows_by_value(
    df: pd.DataFrame, 
    column: str, 
    values: list
) -> pd.DataFrame:
    """
    Drop rows from a DataFrame where a given column matches one of the given values.

    Args:
        df (pd.DataFrame): the DataFrame to modify
        column (str): the name of the column to check for matching values
        values (list): a list of strings to check for in the given column

    Returns:
        pd.DataFrame: the modified DataFrame with rows dropped
    """
    print(f'nrows = {len(df.index)}')
    for value in values:
        print(f'Removing value {value}')
        df = df[df[column] != value]
        
    print(f'nrows = {len(df.index)}')
    return df
