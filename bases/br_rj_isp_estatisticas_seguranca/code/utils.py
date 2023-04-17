import pandas as pd
from io import StringIO
import requests
import requests
from bs4 import BeautifulSoup as soup


#---- build rename dicts
def change_column_name(url_architecture):
    # Converte a URL de edição para um link de exportação em formato csv
    url = url_architecture.replace("edit#gid=", "export?format=csv&gid=")
    
    # Coloca a arquitetura em um dataframe
    df_architecture = pd.read_csv(StringIO(requests.get(url, timeout=10).content.decode("utf-8")))
    
    # Cria um dicionário de nomes de colunas e tipos de dados a partir do dataframe df_architecture
    column_name_dict = dict(zip(df_architecture['original_name'],df_architecture['name']))
    
    # Retorna o dataframe com os tipos de dados alterados
    return column_name_dict

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