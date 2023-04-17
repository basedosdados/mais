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
    
    """_summary_

    Returns:
        _type_: _description_
    """
    # Converte a URL de edição para um link de exportação em formato csv
    url = url_architecture.replace("edit#gid=", "export?format=csv&gid=")
    
    # Coloca a arquitetura em um dataframe
    df_architecture = pd.read_csv(StringIO(requests.get(url, timeout=10).content.decode("utf-8")))
    
    # Cria um dicionário de nomes de colunas e tipos de dados a partir do dataframe df_architecture
    column_name_dict = dict(zip(df_architecture['original_name'],df_architecture['name']))
    
    # Retorna o dataframe com os tipos de dados alterados
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
    
    # Cria um dicionário de nomes de colunas e tipos de dados a partir do dataframe df_architecture
    lista_ordem = list(df_architecture['name'])
    
    # Altera o tipo de dado das colunas em df_table com base no dicionário datatype_dict
    # Retorna o dataframe com os tipos de dados alterados
    return lista_ordem

#---- rename columns
def rename_columns(
    df: pd.DataFrame, 
    tipo : str
) -> pd.DataFrame:

    if tipo == 'taxa':

        dict_rename = {
            'ano': 'ano',
            'mes': 'mes',
            'CISP': 'id_cisp',
            'AISP': 'id_aisp',
            'RISP': 'id_risp',
            'mcirc': 'id_municipio',
            'Regiao': 'regiao_rj',
            'fmun_cod': 'id_municipio',
            'regiao': 'regiao',
            'hom_doloso': 'taxa_homicidio_doloso',
            'latrocinio': 'taxa_latrocinio',
            'lesao_corp_morte': 'taxa_lesao_corporal_morte',
            'cvli': 'taxa_crimes_violentos_letais_intencionais',
            'hom_por_interv_policial': 'taxa_homicidio_intervencao_policial',
            'letalidade_violenta': 'taxa_letalidade_violenta',
            'tentat_hom': 'taxa_tentativa_homicidio',
            'lesao_corp_dolosa': 'taxa_lesao_corporal_dolosa',
            'estupro': 'taxa_estupro',
            'hom_culposo': 'taxa_homicidio_culposo',
            'lesao_corp_culposa': 'taxa_lesao_corporal_culposa',
            'roubo_transeunte': 'taxa_roubo_transeunte',
            'roubo_celular': 'taxa_roubo_celular',
            'roubo_em_coletivo': 'taxa_roubo_corporal_coletivo',
            'roubo_rua': 'taxa_roubo_rua',
            'roubo_veiculo': 'taxa_roubo_veiculo',
            'roubo_carga': 'taxa_roubo_carga',
            'roubo_comercio': 'taxa_roubo_comercio',
            'roubo_residencia': 'taxa_roubo_residencia',
            'roubo_banco': 'taxa_roubo_banco',
            'roubo_cx_eletronico': 'taxa_roubo_caixa_eletronico',
            'roubo_conducao_saque': 'taxa_roubo_conducao_saque',
            'roubo_apos_saque': 'taxa_roubo_apos_saque',
            'roubo_bicicleta': 'taxa_roubo_bicicleta',
            'outros_roubos': 'taxa_outros_roubos',
            'total_roubos': 'taxa_total_roubos',
            'furto_veiculos': 'taxa_furto_veiculos',
            'furto_transeunte': 'taxa_furto_transeunte',
            'furto_coletivo': 'taxa_furto_coletivo',
            'furto_celular': 'taxa_furto_celular',
            'furto_bicicleta': 'taxa_furto_bicicleta',
            'outros_furtos': 'taxa_outros_furtos',
            'total_furtos': 'taxa_total_furtos',
            'sequestro': 'taxa_sequestro',
            'extorsao': 'taxa_extorsao',
            'sequestro_relampago': 'taxa_sequestro_relampago',
            'estelionato': 'taxa_estelionato',
            'apreensao_drogas': 'taxa_apreensao_drogas',
            'posse_drogas': 'taxa_registro_posse_drogas',
            'trafico_drogas': 'taxa_registro_trafico_drogas',
            'apreensao_drogas_sem_autor': 'taxa_registro_apreensao_drogas_sem_autor',
            'recuperacao_veiculos': 'taxa_registro_veiculo_recuperado',
            'apf': 'taxa_apf',
            'aaapai': 'taxa_aaapai',
            'cmp': 'taxa_cmp',
            'cmba': 'taxa_cmba',
            'ameaca': 'taxa_ameaca',
            'pessoas_desaparecidas': 'taxa_pessoas_desaparecidas',
            'encontro_cadaver': 'taxa_encontro_cadaver',
            'encontro_ossada': 'taxa_encontro_ossada',
            'pol_militares_mortos_serv': 'taxa_policial_militar_morto_servico',
            'pol_civis_mortos_serv': 'taxa_policial_civil_morto_servico',
            'registro_ocorrencias': 'taxa_registro_ocorrencia',
            'fase': 'tipo_fase'
        }
    
        df.rename(
        columns=dict_rename, 
        inplace=True
        )

    if tipo == 'quantidade':

        dict_rename = {
            'ano': 'ano',
            'mes': 'mes',
            'ano': 'ano',
            'mes': 'mes',
            'CISP': 'id_cisp',
            'AISP': 'id_aisp',
            'RISP': 'id_risp',
            'mcirc': 'id_municipio',
            'fmun_cod': 'id_municipio',
            'hom_doloso': 'quantidade_homicidio_doloso',
            'latrocinio': 'quantidade_latrocinio',
            'lesao_corp_morte': 'quantidade_lesao_corporal_morte',
            'cvli': 'quantidade_crimes_violentos_letais_intencionais',
            'hom_por_interv_policial': 'quantidade_homicidio_intervencao_policial',
            'letalidade_violenta': 'quantidade_letalidade_violenta',
            'tentat_hom': 'quantidade_tentativa_homicidio',
            'lesao_corp_dolosa': 'quantidade_lesao_corporal_dolosa',
            'estupro': 'quantidade_estupro',
            'hom_culposo': 'quantidade_homicidio_culposo',
            'lesao_corp_culposa': 'quantidade_lesao_corporal_culposa',
            'roubo_transeunte': 'quantidade_roubo_transeunte',
            'roubo_celular': 'quantidade_roubo_celular',
            'roubo_em_coletivo': 'quantidade_roubo_corporal_coletivo',
            'roubo_rua': 'quantidade_roubo_rua',
            'roubo_veiculo': 'quantidade_roubo_veiculo',
            'roubo_carga': 'quantidade_roubo_carga',
            'roubo_comercio': 'quantidade_roubo_comercio',
            'roubo_residencia': 'quantidade_roubo_residencia',
            'roubo_banco': 'quantidade_roubo_banco',
            'roubo_cx_eletronico': 'quantidade_roubo_caixa_eletronico',
            'roubo_conducao_saque': 'quantidade_roubo_conducao_saque',
            'roubo_apos_saque': 'quantidade_roubo_apos_saque',
            'roubo_bicicleta': 'quantidade_roubo_bicicleta',
            'outros_roubos': 'quantidade_outros_roubos',
            'total_roubos': 'quantidade_total_roubos',
            'furto_veiculos': 'quantidade_furto_veiculos',
            'furto_transeunte': 'quantidade_furto_transeunte',
            'furto_coletivo': 'quantidade_furto_coletivo',
            'furto_celular': 'quantidade_furto_celular',
            'furto_bicicleta': 'quantidade_furto_bicicleta',
            'outros_furtos': 'quantidade_outros_furtos',
            'total_furtos': 'quantidade_total_furtos',
            'sequestro': 'quantidade_sequestro',
            'extorsao': 'quantidade_extorsao',
            'sequestro_relampago': 'quantidade_sequestro_relampago',
            'estelionato': 'quantidade_estelionato',
            'apreensao_drogas': 'quantidade_apreensao_drogas',
            'posse_drogas': 'quantidade_registro_posse_drogas',
            'trafico_drogas': 'quantidade_registro_trafico_drogas',
            'apreensao_drogas_sem_autor': 'quantidade_registro_apreensao_drogas_sem_autor',
            'recuperacao_veiculos': 'quantidade_registro_veiculo_recuperado',
            'apf': 'quantidade_apf',
            'aaapai': 'quantidade_aaapai',
            'cmp': 'quantidade_cmp',
            'cmba': 'quantidade_cmba',
            'ameaca': 'quantidade_ameaca',
            'pessoas_desaparecidas': 'quantidade_pessoas_desaparecidas',
            'encontro_cadaver': 'quantidade_encontro_cadaver',
            'encontro_ossada': 'quantidade_encontro_ossada',
            'pol_militares_mortos_serv': 'quantidade_policial_militar_morto_servico',
            'pol_civis_mortos_serv': 'quantidade_policial_civil_morto_servico',
            'registro_ocorrencias': 'quantidade_registro_ocorrencia',
            'fase': 'tipo_fase',
            'feminicidio': 'quantidade_morte_feminicidio',
            'feminicidio_tentativa': 'quantidade_tentativa_feminicidio',
            'FASE': 'tipo_fase',
            'cisp': 'id_cisp',
            'aisp': 'id_aisp',
            'risp': 'id_risp',
            'arma_fabricacao_caseira': 'quantidade_arma_fabricacao_caseira',
            'carabina': 'quantidade_carabina',
            'espingarda': 'quantidade_espingarda',
            'fuzil': 'quantidade_fuzil',
            'garrucha': 'quantidade_garrucha',
            'garruchao': 'quantidade_garruchao',
            'metralhadora': 'quantidade_metralhadora',
            'outros': 'quantidade_outros',
            'pistola': 'quantidade_pistola',
            'revolver': 'quantidade_revolver',
            'submetralhadora': 'quantidade_submetralhadora',
            'total': 'total'
        }

        df.rename(
        columns=dict_rename, 
        inplace=True
        )

    return df

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