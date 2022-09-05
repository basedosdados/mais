
import os
import pandas as pd
import glob
import time

# Setting working directory

os.chdir(r'/Users/lucaspb/Documents/Arquivos Profissionais/BD/Bases/br_mec_prouni.bolsas')

# Setting rename os columns and reorder

rename = {'ANO_CONCESSAO_BOLSA':'ano', 
          'ï»¿ANO_CONCESSAO_BOLSA':'ano',
          'UF_BENEFICIARIO':'sigla_uf',
          'SIGLA_UF_BENEFICIARIO_BOLSA':'sigla_uf',
          'MUNICIPIO_BENEFICIARIO':'id_municipio',
          'MUNICIPIO_BENEFICIARIO_BOLSA':'id_municipio',
          'CPF_BENEFICIARIO':'cpf',
          'CPF_BENEFICIARIO_BOLSA':'cpf',
          'SEXO_BENEFICIARIO':'sexo',
          'SEXO_BENEFICIARIO_BOLSA':'sexo',
          'RACA_BENEFICIARIO':'raca_cor',
          'RACA_BENEFICIARIO_BOLSA':'raca_cor',
          'DATA_NASCIMENTO':'data_nascimento',
          'DT_NASCIMENTO_BENEFICIARIO':'data_nascimento',
          'BENEFICIARIO_DEFICIENTE_FISICO':'beneficiario_deficiente',
          'CODIGO_EMEC_IES_BOLSA':'id_ies',
          'CAMPUS':'campus',
          'MUNICIPIO':'id_municipio_ies',
          'NOME_CURSO_BOLSA':'curso',
          'NOME_TURNO_CURSO_BOLSA':'turno_curso',
          'TIPO_BOLSA':'tipo_bolsa',
          'MODALIDADE_ENSINO_BOLSA':'modalidade_ensino' }


ordem = ["ano", "sigla_uf", "id_municipio", "cpf", "sexo", "raca_cor", "data_nascimento", 
         "beneficiario_deficiente", "id_ies", "curso", "turno_curso", "tipo_bolsa", "modalidade_ensino"]


ordem2020 = ['ano', 'sigla_uf', 'id_municipio', 'cpf', 'sexo', 'raca_cor', 'data_nascimento',
         'beneficiario_deficiente', 'id_ies', 'campus', 'id_municipio_ies', 'curso', 'turno_curso', 'tipo_bolsa', 'modalidade_ensino']


# Settings for partition output 

anos = [2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020]

ufs = ['AC', 'AL', 'AM', 'AP', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MG', 'MS', 'MT', 
       'PA', 'PB', 'PE', 'PI', 'PR', 'RJ', 'RN', 'RO', 'RR', 'RS', 'SC', 'SE', 'SP', 'TO']


# Create Output partitioned
## chmod -R 777 output
for ano in anos:
  for uf in ufs:
    directory = 'output/ano={}/sigla_uf={}'.format(ano, uf)
    if not os.path.exists(directory):
      os.makedirs(directory)


# Get CSV files list from a folder
path = 'input/'
csv_files = glob.glob(path + "/*.csv")

# Read into one big dataframe
dfs = [pd.read_csv(file, sep=";", encoding='latin-1') for file in csv_files]
#prounidata = pd.concat(dfs,ignore_index=True)

# Cleaning data
for df in dfs:
    df.rename(columns=rename, inplace=True)
    df.drop(['NOME_IES_BOLSA', 'REGIAO_BENEFICIARIO_BOLSA', 'REGIAO_BENEFICIARIO'], errors='ignore', axis=1, inplace=True)
    df['sexo'] = df['sexo'].str.upper().replace({'FEMININO':'F', 'MASCULINO':'M'})
    df['sexo'] = df['sexo'].replace({'F':'1', 'M':'2'})
    df['raca_cor'] = df['raca_cor'].str.upper().replace({'AMARELA':'1', 'BRANCA':'2', 'INDÍGENA':'3', 'PARDA':'4', 'PRETA':'5', 'NÃO INFORMADA':'6', 'NÆO INFORMADA':'6'})
    df['beneficiario_deficiente'] = df['beneficiario_deficiente'].str.upper().replace({'SIM':'1', 'NÃO':'0'})
    df['beneficiario_deficiente'] = df['beneficiario_deficiente'].str.upper().replace({'S':'1', 'N':'0'})
    df['turno_curso'] = df['turno_curso'].str.upper().replace({'MATUTINO':'1', 'VESPERTINO':'2', 'NOTURNO':'3', 'INTEGRAL':'4', 'CURSO A DISTÂNCIA':'5', 'CURSO A DIST¶NCIA':'5'})
    df['tipo_bolsa'] = df['tipo_bolsa'].str.upper().replace({'BOLSA INTEGRAL':'1', 'BOLSA PARCIAL 50%':'2'})
    df['tipo_bolsa'] = df['tipo_bolsa'].str.upper().replace({'INTEGRAL':'1', 'PARCIAL':'2'})
    df['modalidade_ensino'] = df['modalidade_ensino'].str.upper().replace({'PRESENCIAL':'1', 'EDUCAÇÃO A DISTÂNCIA':'2', 'EAD':'2'})
    df['data_nascimento'] = pd.to_datetime(df['data_nascimento'], errors='coerce')
    df['data_nascimento'] = df['data_nascimento'].dt.strftime('%Y-%m-%d')

# Reordering columns
for i in range(len(dfs)):
    ano = int(dfs[i]['ano'].iat[0])
    if ano != 2020:
        dfs[i] = dfs[i][ordem]
    if ano == 2020:
        dfs[i] = dfs[i][ordem2020]   
        
# Saving
for df in dfs:
    ano = int(df['ano'][0])
    print("Particionando ano {}".format(ano))
    time.sleep(2)
    for uf in ufs:
        print("Particionando {} de {}".format(uf, ano))
        time.sleep(2)
        df_uf = df[df['sigla_uf'] == uf]
        df_uf.drop(['ano', 'sigla_uf'], axis=1, inplace=True)
        exec("df_uf.to_csv('output/ano={}/sigla_uf={}/microdados.csv', index=False, encoding='utf-8', na_rep='')".format(ano, uf))