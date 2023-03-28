# -*- coding: utf-8 -*-
"""br_cnpq_bolsas.microdados

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1GdYB5hsd-aXfc-cLT0FOuhQuB2bql9Gz
"""

from google.colab import drive
drive.mount('/content/drive')

!pip install unidecode

import pandas as pd
import numpy as np
import os
import glob
import unidecode
from datetime import datetime

pd.set_option('display.max_columns', None)
pd.set_option('display.max_row', None)

ordem = ['ano',
        'processo',
        'data_inicio_processo',
        'data_fim_processo',
        'beneficiario',
        'titulo_projeto',
        'palavra_chave',
        'linha_fomento',
        'modalidade',
        'categoria_nivel',
        'chamada',
        'programa_cnpq',
        'grande_area_conhecimento',
        'area_conhecimento',
        'subarea_conhecimento',
        'pais_origem',
        'sigla_uf_origem',
        'instituicao_origem',
        'pais_destino',
        'sigla_uf_destino',
        'municipio_destino',
        'sigla_instituicao_destino',
        'sigla_instituicao_macro',
        'instituicao_destino',
        'plano_interno',
        'unidade_orcamentaria',
        'fonte_recurso',
        'natureza_despesa',
        'programa_ppa',
        'acao_ppa',
        'valor']

add_df = pd.DataFrame(columns=ordem)

rename = {'Ano Referência':'ano',
'Processo':'processo',
'Data Início Processo':'data_inicio_processo',
'Data Término Processo':'data_fim_processo',
'Beneficiário':'beneficiario',
'Título do Projeto':'titulo_projeto',
'Palavra Chave':'palavra_chave',
'Linha de Fomento':'linha_fomento',
'Modalidade':'modalidade',
'Categoria/Nível':'categoria_nivel',
'Nome Chamada':'chamada',
'Programa CNPq':'programa_cnpq',
'Grande Área':'grande_area_conhecimento',
'Área':'area_conhecimento',
'Subárea':'subarea_conhecimento',
'País Origem':'pais_origem',
'Sigla UF Origem':'sigla_uf_origem',
'Instituição Origem':'instituicao_origem',
'País Destino':'pais_destino',
'Sigla UF Destino':'sigla_uf_destino',
'Cidade Destino':'municipio_destino',
'Sigla Instituição Destino':'sigla_instituicao_destino',
'Sigla Instituição Macro':'sigla_instituicao_macro',
'Instituição Destino':'instituicao_destino',
'Plano Interno':'plano_interno',
'UO':'unidade_orcamentaria',
'Fonte Recurso':'fonte_recurso',
'Natureza de Despesa':'natureza_despesa',
'Valor Pago':'valor',}

file = []
for filepath in glob.iglob(r'/content/drive/Shareddrives/Base dos Dados - Geral/Dados/Conjuntos/br_cnpq_bolsas/input/*.csv'):
    file.append(filepath)

#cria dicionário de ano atrelado ao arquivo
ano=[]
for i in range(len(file)) : ano.append(int(file[i][-8:-4]))

dict_ano = dict(zip(ano, file))
dict_ano

df = pd.DataFrame()

for a in range(2002, 2023):
  if a < 2019:
    df1 = pd.read_csv(dict_ano[a], dtype=str, sep=',', encoding='latin-1')
    df1.rename(columns=rename, inplace=True)
    df2 = pd.concat([df1, add_df])
    df = df.append(df2, ignore_index=True)
  
  if a >= 2019:
    df1 = pd.read_csv(dict_ano[a], dtype=str, sep=',')
    df1.rename(columns=rename, inplace=True)
    df2 = pd.concat([df1, add_df])
    df = df.append(df2, ignore_index=True)

df = df.apply(lambda x: x.str.upper())

# Excluindo os dados duplicados.
df.drop_duplicates(subset=['ano', 'processo', 'beneficiario', 'linha_fomento', 'modalidade',
       'categoria_nivel', 'chamada', 'programa_cnpq',
       'grande_area_conhecimento', 'area_conhecimento', 'subarea_conhecimento',
       'instituicao_origem', 'sigla_uf_origem', 'pais_origem',
       'instituicao_destino', 'sigla_instituicao_destino',
       'sigla_instituicao_macro', 'municipio_destino', 'sigla_uf_destino',
       'pais_destino', 'valor', 'data_inicio_processo', 'data_fim_processo',
       'titulo_projeto', 'palavra_chave', 'plano_interno',
       'unidade_orcamentaria', 'fonte_recurso', 'natureza_despesa',
       'programa_ppa', 'acao_ppa'], inplace=True) # Excluindo os dados duplicados.

df.shape
df = df[['ano',
'processo',
'data_inicio_processo',
'data_fim_processo',
'beneficiario',
'titulo_projeto',
'palavra_chave',
'linha_fomento',
'modalidade',
'categoria_nivel',
'chamada',
'programa_cnpq',
'grande_area_conhecimento',
'area_conhecimento',
'subarea_conhecimento',
'pais_origem',
'sigla_uf_origem',
'instituicao_origem',
'pais_destino',
'sigla_uf_destino',
'municipio_destino',
'sigla_instituicao_destino',
'sigla_instituicao_macro',
'instituicao_destino',
'plano_interno',
'unidade_orcamentaria',
'fonte_recurso',
'natureza_despesa',
'programa_ppa',
'acao_ppa',
'valor']]

# Corrigindo a data.
df = df.replace(np.nan, '')
df['ano'] = df['ano'].replace('0206', '2006')
df['valor'] = df['valor'].apply(lambda x: x.replace(',', '.'))
df['data_fim_processo'] = df['data_fim_processo'].apply(lambda x: x.replace('/', '-'))
df['data_inicio_processo'] = df['data_inicio_processo'].apply(lambda x: x.replace('/', '-'))
df['data_inicio_processo'] = df['data_inicio_processo'].str[6:10] + '-' + df['data_inicio_processo'].str[3:5] + '-' + df['data_inicio_processo'].str[0:2]
df['data_fim_processo'] = df['data_fim_processo'].str[6:10] + '-' + df['data_fim_processo'].str[3:5] + '-' + df['data_fim_processo'].str[0:2]
df['data_fim_processo'] = df['data_fim_processo'].replace('--', '')
df['data_inicio_processo'] = df['data_inicio_processo'].replace('--', '')
df['ano'] =  df['ano'].replace('', '2021')
df['pais_origem'] = df['pais_origem'].replace(' - ', '')
df['pais_destino'] = df['pais_destino'].replace(' - ', '')


df['linha_fomento'] = df['linha_fomento'].replace('Apoio a Participação/Realização de Eventos','1')
df['linha_fomento'] = df['linha_fomento'].replace('Apoio a Periódicos Científicos','2')
df['linha_fomento'] = df['linha_fomento'].replace('Apoio a Pesquisador Visitante','3')
df['linha_fomento'] = df['linha_fomento'].replace('Apoio a Projetos de Pesquisas ','4')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsa de Cota (Curta Dur.)','5')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsas de Apoio Técnico','6')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsas de Desenvolvimento Científico e Regional','7')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsas de Desenvolvimento Tecnológico e Industrial','8')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsas de Doutorado','9')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsas de Extensão em Pesquisa','10')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsas de Fixação de Doutores','11')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsas de Graduação','12')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsas de Iniciação Científica','13')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsas de Iniciação Científica Júnior','14')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsas de Iniciação Tecnológica e Industrial','15')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsas de Mestrado','16')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsas de Pesquisa Especial','17')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsas de Pesquisador/Especialista Visitante','18')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsas de Pós-doutorado','19')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsas de Produtividade em Pesquisa e Tecnologia','20')
df['linha_fomento'] = df['linha_fomento'].replace('Bolsas no Exterior','21')
df['linha_fomento'] = df['linha_fomento'].replace('Estágio','22')
df['linha_fomento'] = df['linha_fomento'].replace('Indefinido','23')

# Alterando a string.
df['pais_destino'] = df['pais_destino'].apply(str).str[0:3]
df['pais_origem'] = df['pais_origem'].apply(str).str[0:3]
df['modalidade'] = df['modalidade'].apply(str).str[0:3]

for ano in range(2002, 2023):
    particao = f'/content/drive/Shareddrives/Base dos Dados - Geral/Dados/Conjuntos/br_cnpq_bolsas/output/ano={ano}' # Criando o caminho
    if not os.path.exists(particao): # replace
      os.makedirs(particao) # Criando pasta "particao"


for ano in range(2002, 2023):
    print(f'particionando{ano}')
    microdados = df[df['ano'].astype(int) == ano]
    microdados.drop(['ano'], axis=1, inplace=True) # É preciso excluir as colunas utilizadas para partição 
    particao = f'/content/drive/Shareddrives/Base dos Dados - Geral/Dados/Conjuntos/br_cnpq_bolsas/output/ano={ano}/microdados.csv'
    microdados.to_csv(particao, index=False, encoding='utf-8', na_rep='')