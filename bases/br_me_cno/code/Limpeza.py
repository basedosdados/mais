import pandas as pd
import numpy as np

#importar tabela
cno = pd.read_csv('./input/cno.csv',encoding='latin', 
                  skipinitialspace=True,na_values='',index_col=None,
                  dtype={'CEP':str,
                         'Código do Pais':str,
                         'Código do municipio':str})

cnae = pd.read_csv('./input/cno_cnaes.csv',encoding='latin', 
                   skipinitialspace=True,
                   na_values='',index_col=None)

vinc = pd.read_csv('./input/cno_vinculos.csv',encoding='latin', 
                   skipinitialspace=True,
                   na_values='',index_col=None).convert_dtypes()

#formatar variáveis

cno = cno.astype({'Código do Pais':'string',
           'Estado':'string',
           'Código do municipio':'string',
           'CEP':'string',
           'Data de início':'datetime64',
           'Data de inicio da responsabilidade':'datetime64',
           'Data de registro':'datetime64',
           'Data da situação':'datetime64',
           'CNO':'string' ,
           'CNO vinculado':'string', 
           'Situação':'string',
           'Tipo de logradouro':'string', 
           'Logradouro':'string',
           'Número do logradouro':'string', 
           'Bairro':'string', 
           'Caixa Postal':'string',
           'Complemento':'string', 
           'NI do responsável':'string',
           'Qualificação do responsavel':'string', 
           'Nome':'string', 
           'Nome empresarial':'string',    
           'Unidade de medida':'string', 
           'Área total':'float64'})

cno['Data de início'] = cno['Data de início'].dt.date
cno['Data de inicio da responsabilidade'] = cno['Data de inicio da responsabilidade'].dt.date
cno['Data de registro'] = cno['Data de registro'].dt.date
cno['Data da situação'] = cno['Data da situação'].dt.date
#----
cnae = cnae.astype({'CNO':'string',
                  'CNAE':'string'})

cnae['Data de registro'] = pd.to_datetime(cnae['Data de registro'],
                                        format="%Y/%m/%d").dt.date

#----
vinc = vinc.astype({'CNO':'string',
                  'Qualificação do contribuinte':'string',
                  'NI do responsável':'string'})

vinc['Data de início'] = pd.to_datetime(vinc['Data de início'],
                                        format="%Y/%m/%d").dt.date
vinc['Data de registro'] = pd.to_datetime(vinc['Data de registro'],
                                          format="%Y/%m/%d").dt.date 

#vinc['Data de fim'] = pd.to_datetime(vinc['Data de fim'], format="%Y/%m/%d")    

#Renomear colunas
cno.rename(columns={'Código do Pais':'id_pais',
           'Estado':'sigla_uf',
           'Código do municipio':'id_municipio_rf',
           'CEP':'cep',
           'CNO':'id_cno' ,
           'CNO vinculado':'id_cno_vinculado', 
           'Data de registro':'data_registro',
           'Data de início':'data_inicio',
           'Data de inicio da responsabilidade':'data_inicio_responsabilidade', 
           'Situação':'situacao',
           'Data da situação':'data_situacao',
           'Tipo de logradouro':'tipo_logradouro', 
           'Logradouro':'logradouro',
           'Número do logradouro':'numero_logradouro', 
           'Bairro':'bairro', 
           'Caixa Postal':'caixa_postal',
           'Complemento':'complemento', 
           'NI do responsável':'ni_responsavel',
           'Qualificação do responsavel':'qualificacao_responsavel', 
           'Nome':'nome_responsavel', 
           'Nome empresarial':'nome_empresarial',    
           'Unidade de medida':'unidade_medida', 
           'Área total':'area'}, inplace=True)

                  
cnae.rename(columns={'CNO':'id_cno',
                  'CNAE':'cnae_2',
                  'Data de registro':'data_registro'}, inplace=True)
                

vinc.rename(columns={'CNO':'id_cno',
                  'Data de início':'data_inicio',
                  'Data de fim':'data_fim',
                  'Data de registro':'data_registro',
                  'Qualificação do contribuinte':'qualificacao_responsavel',
                  'NI do responsável':'ni_responsavel'}, inplace=True)


#Add coluna id_mun IBGE
id_rf = pd.read_csv('./tmp/id_mun_rf.csv').astype({
    'id_municipio':'string',
    'id_tom':'string',
    'mun':'string'})

cno['id_municipio_rf'] = cno['id_municipio_rf'].str.lstrip('0')

cno = cno.join(id_rf[['id_municipio','id_tom']].set_index('id_tom'), on='id_municipio_rf')

#Organizar colunas
cno = cno[['id_pais',
           'sigla_uf',
           'id_municipio',
           'id_municipio_rf',
           'cep',
           'id_cno',
           'id_cno_vinculado', 
           'data_registro',
           'data_inicio',
           'data_inicio_responsabilidade', 
           'situacao',
           'data_situacao',
           'tipo_logradouro', 
           'logradouro',
           'numero_logradouro', 
           'bairro', 
           'caixa_postal',
           'complemento', 
           'ni_responsavel',
           'qualificacao_responsavel', 
           'nome_responsavel', 
           'nome_empresarial',    
           'unidade_medida', 
           'area']]

#Salvar tabelas
cno.to_csv('./output/microdados.csv',index=False, encoding='utf-8', na_rep='')
cnae.to_csv('./output/microdados_cnae.csv',index=False, encoding='utf-8', na_rep='')
vinc.to_csv('./output/microdados_vinculo.csv',index=False, encoding='utf-8', na_rep='')



