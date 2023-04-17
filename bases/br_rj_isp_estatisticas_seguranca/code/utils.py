import pandas as pd
from io import StringIO
import os
import requests
import requests
from bs4 import BeautifulSoup as soup
from typing import List
from typing import Dict

#build a dict that maps a table name to a architectura and
#another dict that maps an original table name to a
#trated table name

def dict_original():

    dict_original = {
    'BaseDPEvolucaoMensalCisp.csv' : 'evolucao_mensal_cisp.csv',
    'DOMensalEstadoDesde1991.csv' : 'evolucao_mensal_uf.csv',
    'BaseEstadoTaxaMes.csv' : 'taxa_evolucao_mensal_uf.csv',
    'BaseEstadoTaxaAno.csv' : 'taxa_evolucao_anual_uf.csv',
    'BaseMunicipioMensal.csv' : 'evolucao_mensal_municipio.csv',
    'BaseMunicipioTaxaMes.csv' :  'taxa_evolucao_mensal_municipio.csv',
    'BaseMunicipioTaxaAno.csv' : 'taxa_evolucao_anual_municipio.csv',
    'UppEvolucaoMensalDeTitulos.csv' : 'evolucao_mensal_upp.csv',#no 
    'ArmasApreendidasEvolucaoCisp.xlsx' : 'armas_fogo_apreendidas_mensal.csv', #no 
    'ArmasDP2003_2006.csv' : 'armas_apreendidas_mensal.csv', 
    'PoliciaisMortos.csv' : 'evolucao_policial_morto_servico_mensal.csv', #no
    'BaseFeminicidioEvolucaoMensalCisp.csv' : 'feminicidio_mensal_uf.csv', 
    'SeriesHistoricas.csv' : 'taxa_letalidade.csv' #no
    }

    return dict_original

def dict_arquitetura():

    dict_arquitetura = {
    'evolucao_mensal_cisp.csv' : 'https://docs.google.com/spreadsheets/d/1jibGPOYF6Tack3n9MmiQKdBagbeK-oLr/edit#gid=55379267',
    'evolucao_mensal_uf.csv' : 'https://docs.google.com/spreadsheets/d/1seN6LQ9WQnobVNpFw6KX5BMhYr0yyZa2/edit#gid=1349095453',
    'taxa_evolucao_mensal_uf.csv' : 'https://docs.google.com/spreadsheets/d/1fQ7MnfHm8vrlfdUhAYlU7F-CJouORKkc/edit#gid=1414191356',
    'taxa_evolucao_anual_uf.csv' : 'https://docs.google.com/spreadsheets/d/117EyqVw5a6_0PFPISjLZuZLIsRqyZiOo/edit#gid=588874333',
    'evolucao_mensal_municipio.csv' : 'https://docs.google.com/spreadsheets/d/1cHPcIBfmFwSxgMTsvGX-Ha-Efz7ZIDpn/edit#gid=347509921',
    'taxa_evolucao_mensal_municipio.csv' : 'https://docs.google.com/spreadsheets/d/1VKorutzmHUl71a2J--auChJm8tC-652i/edit#gid=199121203',
    'taxa_evolucao_anual_municipio.csv' : 'https://docs.google.com/spreadsheets/d/1LeH92JhPkr59NoUwepOgHKlsJIS6k-2W/edit#gid=786684819',
    'evolucao_mensal_upp.csv' : 'https://docs.google.com/spreadsheets/d/1TGG8T5xzmO_tzo9RScnIOt2NKjyIHu2O/edit#gid=1336604684', 
    'armas_apreendidas_mensal.csv' : 'https://docs.google.com/spreadsheets/d/19gynYMOxzfgjd7HsPjH4LbOkgV9844WSoVBiqAgp340/edit#gid=0', 
    'armas_fogo_apreendidas_mensal.csv' : 'https://docs.google.com/spreadsheets/d/14wV3BkjG_9GDWKDUAbOVe2KOh0Bi6FAA/edit#gid=1673208544',
    'evolucao_policial_morto_servico_mensal.csv' : 'https://docs.google.com/spreadsheets/d/1wuRr-I73jje0nkSeF_9LEJSpRmuwIftX/edit#gid=1573015202',
    'feminicidio_mensal_uf.csv' : 'https://docs.google.com/spreadsheets/d/1DLb9GQAZR-TRbJp0YYc1w71OsEwXPYa8/edit#gid=1573015202', 
    'taxa_letalidade.csv': 'https://docs.google.com/spreadsheets/d/1wMbutt7Gs17ZlGEZ_-SBT4bwtF_QSWd5KLR-m8KaBMo/edit#gid=0'
    }

    return dict_arquitetura




#---- build rename dicts
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


#---- function to order columns

def create_column_order(
    url_architecture: str
)-> List[str]:
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
    
    # Cria uma lista com a ordem das colunas
    lista_ordem = list(df_architecture['name'])
    
    # Altera o tipo de dado das colunas em df_table com base no dicionário datatype_dict
    # Retorna o dataframe com os tipos de dados alterados
    return lista_ordem

#---- pegar ordem das colunas da tabela de arquitetura

# extract all href inside a tags inside a div found in this xpath //*[@id="conteudo_mostrar"]/div
#  in this url http://www.ispdados.rj.gov.br/estatistica.html


def get_links():
    url = "http://www.ispdados.rj.gov.br/estatistica.html"
    response = requests.get(url)
    page_soup = soup(response.content, "html.parser")
    div = page_soup.find("div", {"id": "conteudo_mostrar"})
    links = []
    for a in div.find_all("a", href=True):
        if a["href"].endswith(".csv") or a["href"].endswith(".xlsx"):
            links.append(a["href"])
    return links

def download_files():
    links = get_links()
    path = r'C:\Users\gabri\OneDrive\vida_profissional\Projetos\base_dos_dados\br_rj_isp_seguranca_publica'
    for link in links:
        file_name = link.split("/")[-1]
        if not os.path.exists(file_name):
            print("Downloading file: ", file_name)
            r = requests.get(link, allow_redirects=True)
            open(file_name, "wb").write(r.content)
            print("File downloaded: ", file_name)
        else:
            print("File already exists: ", file_name)