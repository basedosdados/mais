################################################################################
# Pacotes + paths
################################################################################

pip install wget

import os
import glob
import wget
import ftplib

import pandas as pd
import numpy  as np

path        = '/content/drive/MyDrive/'
path_input  = '/content/gdrive/MyDrive/br_bd_diretorios_brasil/input/'
path_output = '/content/gdrive/MyDrive/br_bd_diretorios_brasil/output/'

################################################################################
# Download + Tratamento
################################################################################

with ftplib.FTP('geoftp.ibge.gov.br') as ftp:
    ftp.login()
    ftp.dir('organizacao_do_territorio/estrutura_territorial/municipios_por_regioes_metropolitanas/Situacao_2020a2029/Composicao_RMs_RIDEs_AglomUrbanas_2020_12_31.xlsx')

df = wget.download('https://geoftp.ibge.gov.br/organizacao_do_territorio/estrutura_territorial/municipios_por_regioes_metropolitanas/Situacao_2020a2029/Composicao_RMs_RIDEs_AglomUrbanas_2020_12_31.xlsx',
                out = path_input + "regiao_metropolitana.xlsx")

print("Baixado RM")


list_rename = {
    "COD"       : "id_regiao_metropolitana" ,
    "NOME"      : "nome"                    ,
    "TIPO"      : "tipo"                    ,   
    "SIGLA_UF"  : "sigla_uf"                , 
    "GRANDE_REG": "nome_regiao"             
          }

list_ordem = [
         "sigla_uf"                , 
         "id_regiao_metropolitana" ,
         "tipo"                    ,
         "nome"                    ,
         "nome_regiao"
        ]

df = pd.read_excel(path_input + 'regiao_metropolitana.xlsx', dtype = "str")
df.rename(columns = list_rename, inplace = True)

df = df.drop_duplicates(subset=['id_regiao_metropolitana'])
df = df[list_ordem]

df.to_csv(path_output + 'regiao_metropolitana.csv', index = False)