import pandas as pd
from io import StringIO
import requests
import unicodedata
from typing import Dict


#---- mudar nome das colunas ----#

def change_column_name(
    url_architecture: str
)-> Dict[str, str]:
    
    """Essa função recebe como input uma string com link para uma tabela de arquitetura
    e retorna um dicionário com os nomes das colunas originais e os nomes das colunas 
    padronizados
    Returns:
        dict: com chaves sendo os nomes originais e valores sendo os nomes padronizados
    """
    # Converte a URL de edição para um link de exportação em formato csv
    url = url_architecture.replace(
        "edit#gid=",
        "export?format=csv&gid="
    )
    
    # Coloca a arquitetura em um dataframe
    df_architecture = pd.read_csv(
        StringIO(requests.get(url, timeout=10).content.decode("utf-8"))
    )
    
    # Cria um dicionário de nomes de colunas e tipos de dados a partir do dataframe df_architecture
    column_name_dict = dict(
        zip(df_architecture['original_name'],df_architecture['name'])
    )
    
    # Retorna o dicionário 

    return column_name_dict

#---- mudar tipos de dados ----#

def change_dtypes(
    url_architecture: str
)-> Dict[str, str]:
    
    """Essa função recebe como input uma string com link para uma tabela de arquitetura
    e retorna um dicionário com os nomes das colunas originais e os nomes das colunas 
    padronizados
    Returns:
        dict: com chaves sendo os nomes originais e valores sendo os nomes padronizados
    """
    # Converte a URL de edição para um link de exportação em formato csv
    url = url_architecture.replace(
        "edit#gid=",
        "export?format=csv&gid="
    )
    
    # Coloca a arquitetura em um dataframe
    df_architecture = pd.read_csv(
        StringIO(requests.get(url, timeout=10).content.decode("utf-8"))
    )
    
    # Cria um dicionário de nomes de colunas e tipos de dados a partir do dataframe df_architecture
    column_name_dict = dict(
        zip(df_architecture['original_name'],df_architecture['bigquery_type'])
    )

    #O pandas não consegue ler ints que tenham NAs
    #Para contornar isso e não adicionar 0. ao final de cada número,
    #optei por converter  todos os inteiros para string
    
    #loop para padronizar os tipos de dados e converter in para string
    for key, value in column_name_dict.items():
        if value == 'string':
            column_name_dict[key] = str
        elif value == 'int64':
            column_name_dict[key] = str
        elif value == 'float64':
            column_name_dict[key] = float

    return column_name_dict


#---- remover acentos e caracteres especiais ----#
def remove_accents(
    input_str: pd.Series[str]
)-> pd.Series[str]:
    """Essa função é aplicada com método apply em uma coluna de um dataframe para remover
    acentos e caracteres especiais de uma string. Exemplo de uso

    df[x].apply(remove_accents)

    Args:
        input_str (pd.Series): Uma coluna com strings

    Returns:
        pd.Series : coluna com strings sema acentos e caracteres especiais
    """    
    nfkd_form = unicodedata.normalize('NFKD', input_str)
    
    return u"".join([c for c in nfkd_form if not unicodedata.combining(c)])
