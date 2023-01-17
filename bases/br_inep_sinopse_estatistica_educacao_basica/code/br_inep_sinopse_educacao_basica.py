# pylint: disable=C0114
# pylint: disable=C0103
# pylint: disable=C0200

import os
import pandas as pd

path = os.path.abspath(os.path.join('..', 'input'))
path_uf = os.path.join(path, 'uf.csv')
uf_diretorio = pd.read_csv(path_uf)

#### Tabela 1: municipio_matricula_localizacao_rede ###

years = [2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021]
path_option = {}
for j in years:
    var = 'input/' + str(j)
    data = 'Sinopse_Estatistica_da_Educação_Basica_' + str(j) + '.xlsx'
    path = os.path.abspath(os.path.join('..', var))
    path_option[j] = os.path.join(path, data)

### lstas e dicionários necessários ###
sheets = ['Creche 1.6', 'Pré-Escola 1.10', '1.16',
          '1.21', '1.26', '1.31', '1.35', '1.40', '1.46']
dict_df_rename = {'Unnamed: 0': 'regiao_geografica', 'Unnamed: 1': 'uf',
                  'Unnamed: 2': 'municipio', 'Unnamed: 3': 'id_municipio',
                  'Total': 'urbana_total', 'Federal': 'urbana_federal',
                  'Estadual': 'urbana_estadual', 'Municipal': 'urbana_municipal',
                  'Privada': 'urbana_privada',
                  'Total.1': 'rural_total', 'Federal.1': 'rural_federal',
                  'Estadual.1': 'rural_estadual',
                  'Municipal.1': 'rural_municipal', 'Privada.1': 'rural_privada'}
etapa_ensino = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
order = ['ano', 'sigla_uf', 'id_municipio', 'localizacao',
         'rede', 'etapa_ensino', 'quantidade_matricula']
value_vars = ['urbana_total', 'urbana_federal', 'urbana_estadual', 'urbana_municipal',
             'urbana_privada', 'rural_total', 'rural_federal',
             'rural_estadual', 'rural_municipal', 'rural_privada']

### lista dos dicionários de dataframes, para cada ano e sheet ###
list_df = []
for j in years:
    dict_df = {}
    for i in range(len(sheets)):
        dict_df[i] = pd.read_excel(
            path_option[j], sheet_name=sheets[i], skiprows=8, dtype='string')
        dict_df[i].drop(0, axis=0, inplace=True)
        dict_df[i].drop(dict_df[i].tail(5).index, axis=0, inplace=True)
        if i in range(0, 7):
            dict_df[i].drop(dict_df[i].tail(1).index, axis=0, inplace=True)
        dict_df[i] = dict_df[i].iloc[:, : 15]
        dict_df[i].rename(columns=dict_df_rename, inplace=True)
        dict_df[i].uf = dict_df[i].uf.str.strip()
        dict_df[i] = dict_df[i][~dict_df[i].id_municipio.isin(
            [' '])].reset_index(drop=True)
        dict_df[i].id_municipio = dict_df[i].id_municipio.str.strip()
        dict_df[i] = pd.merge(dict_df[i], uf_diretorio[['sigla', 'nome']],
                    how='inner', left_on=['uf'], right_on=['nome']).\
                    reset_index(drop=True)
        dict_df[i].drop(['regiao_geografica', 'Unnamed: 4', 'uf',
                        'municipio', 'nome'], axis=1, inplace=True)
        dict_df[i].rename(columns={'sigla': 'sigla_uf'}, inplace=True)
        dict_df[i]['etapa_ensino'] = etapa_ensino[i]
        dict_df[i]['ano'] = j
        dict_df[i] = pd.melt(dict_df[i],
                    id_vars=['sigla_uf', 'id_municipio', 'etapa_ensino', 'ano'],
                    value_vars=value_vars, var_name='localizacao_rede',
                    value_name='quantidade_matricula')
        dict_df[i]['localizacao'] = dict_df[i].localizacao_rede.str.split(
            '_').str[0]
        dict_df[i]['rede'] = dict_df[i].localizacao_rede.str.split('_').str[-1]
        dict_df[i].drop('localizacao_rede', axis=1, inplace=True)
        dict_df[i] = dict_df[i][order]
        dict_df[i] = dict_df[i][dict_df[i]['rede']
                                != 'total'].reset_index(drop=True)
    list_df.append(dict_df)

### lista de dfs, por ano ###
new_df = []
for j in range(len(years)):
    new_list = list(list_df[j].values())
    new_aux = pd.concat(new_list).reset_index(drop=True)
    new_df.append(new_aux)

### função que retorna o path relativo do output ###
def path_out ():
    partic = 'output\municipio_matricula_localizacao_rede'
    partic_aux = "\\ano={}\\sigla_uf={}"
    partic = os.path.abspath(os.path.join('..', partic))
    if not os.path.isdir(partic):
        os.mkdir(partic)
    path= os.path.join(partic + partic_aux)
    return path

### particionar as tabelas, por uf e por ano ###
ufs = list(new_df[0]['sigla_uf'].unique())
for i in range(len(years)):
    mg_a= new_df[i]
    for uf in ufs:
        path_i = path_out().format(years[i], uf)
        if not os.path.isdir(path_i):
            os.makedirs(path_i)
        mg_auf = mg_a[mg_a['sigla_uf'] == uf]
        mg_auf.drop(['ano','sigla_uf'], axis=1, inplace=True)
        mg_auf.to_csv(path_i + '\municipio_matricula_localizacao_rede.csv', index = False)
        del path_i
        