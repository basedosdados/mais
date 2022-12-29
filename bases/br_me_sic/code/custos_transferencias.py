# Importing
import requests
import json
import pandas as pd
import datetime
import os
import numpy as np
import string
import basedosdados as bd

output = "transferencia/output/"
# Download
todays_year = datetime.date.today().year;
year_range = list(range(2015,todays_year+1));
year_range = [str(x)for x in year_range];
first_time_flag = True;
# API retorna no máximo 250 observações, utilizando a segmentação abaixo a maior categoria (ano, mês,
# natureza jurídica) tem 194 observações. É uma margem segura? Se não repensar como fazer
api_response = requests.get('https://apidatalake.tesouro.gov.br/ords/custos/tt/transferencias?ano=2020&mes=10&natureza_juridica=3').text;

transf_dict = json.loads(api_response);
transferencia_esp = pd.json_normalize(transf_dict['items']);
for ano in [str(x)for x in list(range(2015,todays_year+1))]:
    for mes in [str(x)for x in list(range(1,13))]:
        for natur in [str(x)for x in list(range(1,7))]:
            api_response = requests.get('https://apidatalake.tesouro.gov.br/ords/custos/tt/transferencias?ano='+ano+'&mes='+mes+'&natureza_juridica='+natur).text;
    
            transf_dict = json.loads(api_response);
            transferencia_esp = pd.json_normalize(transf_dict['items']);
            
            # Renomear variáveis com nomes inadequados
            transferencia_esp = transferencia_esp.rename(columns={'an_lanc':'ano_lancamento',
                                        'me_lanc':'mes_lancamento',
                                        'ds_organizacao_n0':'nome_unidade_organizacional_nivel_0',
                                        'ds_organizacao_n1':'nome_unidade_organizacional_nivel_1',
                                        'ds_organizacao_n2':'nome_unidade_organizacional_nivel_2',
                                        'ds_organizacao_n3':'nome_unidade_organizacional_nivel_3',
                                        'co_organizacao_n0':'id_unidade_organizacional_nivel_0',
                                        'co_organizacao_n1':'id_unidade_organizacional_nivel_1',
                                        'co_organizacao_n2':'id_unidade_organizacional_nivel_2',
                                        'co_organizacao_n3':'id_unidade_organizacional_nivel_3',
                                        'co_natureza_juridica':'id_natureza_juridica',
                                        'ds_natureza_juridica':'nome_natureza_juridica',
                                        'co_esfera_orcamentaria':'id_esfera_orcamentaria',
                                        'ds_esfera_orcamentaria':'nome_esfera_orcamentaria',
                                        'co_modalidade_aplicacao':'id_modalidade_aplicacao',
                                        'ds_modalidade_aplicacao':'nome_modalidade_aplicacao',
                                        'co_resultado_eof':'id_resultado_primario',
                                        'ds_resultado_eof':'nome_resultado_primario',
                                        'va_custo_transferencias':'valor_custo_transferencia'});
            if len(transferencia_esp) == 250:
                raise Exception('Single request reached 250 observations, the maximum allowed by the Tesouro API. Probably missing data, code fix needed');
            
            if first_time_flag:
                transferencia = transferencia_esp
                first_time_flag = False;
            else:
                transferencia = pd.concat([transferencia, transferencia_esp],axis=0);

# Remover 0s iniciais

id_idx = [col.startswith('id') for col in list(transferencia.columns.values)]

transferencia.loc[:,id_idx] = transferencia.loc[:,id_idx].astype(int).astype(str)

# Criar dicionário

def create_dictionary(df,vars_dict,time_col,id_tabela):
    vars_dict = np.array(vars_dict)
    first_time_flag = True
    for i in range(0,len(vars_dict)):
        dict_part = df[[vars_dict[i,0],vars_dict[i,1]]].drop_duplicates()
        dict_part = dict_part.rename(columns = {
            vars_dict[i,0] :'chave',
            vars_dict[i,1]: 'valor'})
        dict_part['nome_coluna'] = vars_dict[i,0]
        dict_part['cobertura_temporal'] = \
            [(str(min(df.loc[df[row['nome_coluna']] == row['chave']][time_col])) + 
            '(1)' +
            str(max(df.loc[df[row['nome_coluna']] == row['chave']][time_col])))\
                for idx,row in dict_part.iterrows()]
        if first_time_flag:
            dicionario = dict_part
            first_time_flag = False
        else:
            dicionario = pd.concat([dicionario,dict_part])
    dicionario['id_tabela'] = id_tabela
    dicionario = dicionario[['id_tabela','nome_coluna','chave','cobertura_temporal','valor']]
    return dicionario

vars_dict = [['id_unidade_organizacional_nivel_0', 'nome_unidade_organizacional_nivel_0'],
                     ['id_unidade_organizacional_nivel_1', 'nome_unidade_organizacional_nivel_1'],
                     ['id_unidade_organizacional_nivel_2', 'nome_unidade_organizacional_nivel_2'],
                     ['id_unidade_organizacional_nivel_3', 'nome_unidade_organizacional_nivel_3'],
                     ['id_natureza_juridica', 'nome_natureza_juridica'],
                     ['id_esfera_orcamentaria', 'nome_esfera_orcamentaria'],
                     ['id_resultado_primario','nome_resultado_primario']];

dicionario = create_dictionary(transferencia,vars_dict,'ano_lancamento','transferencia')
dicionario_path = output +'dicionario_transferencia'
os.makedirs(dicionario_path)
dicionario.to_csv(dicionario_path+'/dicionario_transferencia.csv',index = False)

# Remove descrições       
transferencia = transferencia[['ano_lancamento','mes_lancamento','id_unidade_organizacional_nivel_0',
                     'id_unidade_organizacional_nivel_1','id_unidade_organizacional_nivel_2',
                     'id_unidade_organizacional_nivel_3','id_natureza_juridica','id_esfera_orcamentaria',
                     'id_resultado_primario','valor_custo_transferencia']]

# Cria as partições e coloca os arquivos respectivos dentro delas

for ano in [*range(2015, todays_year+1)]:
  for mes in [*range(1, 13)]:
    particao = output + f'transferencia/ano={ano}/mes={mes}'
    if not os.path.exists(particao):
      os.makedirs(particao)
for ano in [*range(2015, todays_year+1)]:
  for mes in [*range(1, 13)]:
    df_particao = transferencia[transferencia['ano_lancamento'] == ano].copy() # O .copy não é necessário é apenas uma boa prática
    df_particao = df_particao[df_particao['mes_lancamento'] == mes]
    df_particao.drop(['ano_lancamento', 'mes_lancamento'], axis=1, inplace=True) # É preciso excluir as colunas utilizadas para partição 
    particao = output + f'transferencia/ano={ano}/mes={mes}/transferencia.csv'
    df_particao.to_csv(particao, index=False, encoding='utf-8', na_rep='')

# Publicar a tabela de transferencia
t = bd.Table(dataset_id = 'br_me_sic', table_id = 'transferencia')
t.create(path = 'transferencia/output/transferencia',if_storage_data_exists= 'replace')
t.publish(if_exists = 'replace')

# Publicar o dicionário
t = bd.Table(dataset_id = 'br_me_sic', table_id = 'dicionario_transferencia')
t.create(path = 'transferencia/output/dicionario_transferencia',if_storage_data_exists= 'replace')
t.publish(if_exists = 'replace')






