# -*- coding: utf-8 -*-
"""
Created on Mon Sep  6 09:19:44 2021

@author: Gustavo
"""

import pandas as pd
import glob 
import numpy as np
import os
#importa tabela com id_municipio IBGE (disponível em br_bd_diretorios_brasil no BigQuery)
id_mun = pd.read_csv('./extra/id_municipio.csv',dtype='string')

# Lista os caminhos dos arquivos raw na pasta de input
file = []
for filepath in glob.iglob('.\input\estabelecimento\*.csv'):
    file.append(filepath)

# Define listas com uf,mes e ano 
uf=[]
for i in range(len(file)) : uf.append(file[i][-10:-8])

mes=[]
for i in range(len(file)) : mes.append(int(file[i][-6:-4]))

ano=[]
for i in range(len(file)) : ano.append(int(file[i][-8:-6]))


ufs =['AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT',
          'MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO',
          'RR','SC', 'SP','SE','TO']

#Cria as pastas
for u in range(len(ufs)):
    for a in range(5,22):
        if a == 5:
            for m in range(8,13):
                try:
                    os.makedirs('./output/ano={}/mes={}/sigla_uf={}'.format(str(a), str(m),ufs[u]))
                except:pass
        elif a == 21:
             for m in range(1,7):
                 try:
                     os.makedirs('./output/ano={}/mes={}/sigla_uf={}'.format(str(a), str(m),ufs[u]))
                 except:pass
        else:
             for m in range(1,13):
                try:
                    os.makedirs('./output/ano={}/mes={}/sigla_uf={}'.format(str(a), str(m),ufs[u]))
                except:pass

# Lista para renomar colunas
rename = {'CODUFMUN':'id_municipio_6','CNES':'id_cnes','REGSAUDE':'regiao_saude',
          'MICR_REG':'microrregiao_saude','DISTRSAN':'distrito_sanitario',
          'DISTRADM':'distrito_administrativo','COD_CEP':'cep','CPF_CNPJ':'cpf_cnpj',
          'PF_PJ':'indicador_pessoa','NIV_DEP':'grau_dependencia','CNPJ_MAN':'cnpj_mantenedora',
          'COD_IR':'codigo_ir','VINC_SUS':'vinculo_sus','TPGESTAO':'tipo_gestao',
          'ESFERA_A':'esfera_administrativa','RETENCAO':'retencao_tributos',
          'ATIVIDAD':'atividade_ensino_pesquisa','NATUREZA':'natureza_administrativa',
          'CLIENTEL':'fluxo_atendimento','TP_UNID':'tipo_unidade','TURNO_AT':'turno',
          'NIV_HIER':'nivel_hierarquia','TP_PREST':'tipo_prestador','CO_BANCO':'codigo_banco',
          'CO_AGENC':'codigo_agencia','C_CORREN':'conta_corrente','CONTRATM':'contrato_municipio_sus',
          'DT_PUBLM':'data_publicacao_contrato_municipal','CONTRATE':'contrato_estado_sus',
          'DT_PUBLE':'data_publicacao_contrato_estadual','ALVARA':'numero_alvara',
          'DT_EXPED':'data_expedicao_alvara','ORGEXPED':'orgao_expedidor',
          'AV_ACRED':'avaliacao_acreditacao_hospitalar',
          'CLASAVAL':'classificacao_acreditacao_hospitalar','DT_ACRED':'data_acreditacao',
          'AV_PNASS':'avaliacao_pnass','DT_PNASS':'data_avaliacao_pnass',
          'GESPRG1E':'gestao_basica_amb_estadual','GESPRG1M':'gestao_basica_amb_municipal',
          'GESPRG2E':'gestao_media_amb_estadual','GESPRG2M':'gestao_media_amb_municipal',
          'GESPRG4E':'gestao_alta_amb_estadual','GESPRG4M':'gestao_alta_amb_municipal',
          'NIVATE_A':'atencao_amb','GESPRG3E':'gestao_estadual','GESPRG3M':'gestao_municipal',
          'GESPRG5E':'gestao_media_hosp_estadual','GESPRG5M':'gestao_media_hosp_municipal',
          'GESPRG6E':'gestao_alta_hosp_estadual','GESPRG6M':'gestao_alta_hosp_municipal',
          'NIVATE_H':'atencao_hosp','QTLEITP1':'quantidade_leitos_cirurgico',
          'QTLEITP2':'quantidade_leitos_clinico','QTLEITP3':'quantidade_leitos_complementar',
          'LEITHOSP':'indicador_leitos_hosp','QTINST01':'quantidade_consultorio_pediatrico',
          'QTINST02':'quantidade_consultorio_feminino','QTINST03':'quantidade_consultorio_masculino',
          'QTINST04':'quantidade_consultorio_indiferenciado',
          'QTINST05':'quantidade_sala_repouso_pediatrico_urgencia',
          'QTINST06':'quantidade_sala_repouso_feminino_urgencia',
          'QTINST07':'quantidade_sala_repouso_masculino_urgencia',
          'QTINST08':'quantidade_sala_repouso_indiferenciado_urgencia',
          'QTINST09':'quantidade_consultorio_odontologia_urgencia',
          'QTINST10':'quantidade_sala_higienizacao_urgencia','QTINST11':'quantidade_sala_gesso_urgencia',
          'QTINST12':'quantidade_sala_curativo_urgencia',
          'QTINST13':'quantidade_sala_pequena_cirurgia_urgencia',
          'QTINST14':'quantidade_consultorio_medico_urgencia',
          'URGEMERG':'indicador_instalacao_urgencia','QTINST15':'quantidade_consultorio_clinica_basica',
          'QTINST16':'quantidade_consultorio_clinica_especializada',
          'QTINST17':'quantidade_consultorio_clinica_indiferenciada',
          'QTINST18':'quantidade_consultorio_nao_medico','QTINST19':'quantidade_sala_repouso_feminino_amb',
          'QTINST20':'quantidade_sala_repouso_masculino_amb',
          'QTINST21':'quantidade_sala_repouso_pediatrico_amb',
          'QTINST22':'quantidade_sala_repouso_indiferenciado_amb',
          'QTINST23':'quantidade_consultorio_odontologia_amb',
          'QTINST24':'quantidade_sala_pequena_cirurgia_amb',
          'QTINST25':'quantidade_sala_enfermagem_amb',
          'QTINST26':'quantidade_sala_imunizacao_amb','QTINST27':'quantidade_sala_nebulizacao_amb',
          'QTINST28':'quantidade_sala_gesso_amb','QTINST29':'quantidade_sala_curativo_amb',
          'QTINST30':'quantidade_sala_cirurgia_amb','ATENDAMB':'indicador_instalcao_ambulatorial',
          'QTINST31':'quantidade_sala_cirurgia','QTINST32':'quantidade_sala_recuperacao',
          'QTINST33':'quantidade_sala_cirurgia_amb_centro_cirurgico',
          'CENTRCIR':'indicador_instalacao_centro_cirurgico',
          'QTINST34':'quantidade_sala_pre_parto','QTINST35':'quantidade_sala_parto_normal',
          'QTINST36':'quantidade_sala_curetagem','QTINST37':'quantidade_sala_cirurgia_centro_obstetrico',
          'CENTROBS':'indicador_instalacao_centro_obstetrico',
          'QTLEIT05':'quantidade_leito_repouso_pediatrico_urgencia',
          'QTLEIT06':'quantidade_leito_repouso_feminino_urgencia',
          'QTLEIT07':'quantidade_leito_repouso_masculino_urgencia',
          'QTLEIT08':'quantidade_leito_repouso_indiferenciado_urgencia',
          'QTLEIT09':'quantidade_equipos_odontologia_urgencia',
          'QTLEIT19':'quantidade_leito_repouso_feminino_amb',
          'QTLEIT20':'quantidade_leito_repouso_masculino_amb',
          'QTLEIT21':'quantidade_leito_repouso_pediatrico_amb',
          'QTLEIT22':'quantidade_leito_repouso_indiferenciado_amb',
          'QTLEIT23':'quantidade_equipos_odontologia_amb',
          'QTLEIT32':'quantidade_leito_recuperacao_centro_cirurgico',
          'QTLEIT34':'quantidade_leito_pre_parto','QTLEIT38':'quantidade_leito_recem_nascido_normal',
          'QTLEIT39':'quantidade_leito_recem_nascido_patologico',
          'QTLEIT40':'quantidade_leito_conjunto_neonatal','CENTRNEO':'indicador_instalacao_neonatal',
          'ATENDHOS':'indicador_instalaco_hospitalar','SERAP01P':'servico_apoio_proprio',
          'SERAP01T':'servico_apoio_terceirizado','SERAP02P':'servico_social_proprio',
          'SERAP02T':'servico_social_terceirizado','SERAP03P':'servico_farmacia_proprio',
          'SERAP03T':'servico_farmacia_terceirizado','SERAP04P':'servico_esterilizacao_proprio',
          'SERAP04T':'servico_esterilizacao_terceirizado','SERAP05P':'servico_nutricao_proprio',
          'SERAP05T':'servico_nutricao_terceirizado','SERAP06P':'servico_lactario_proprio',
          'SERAP06T':'servico_lactario_terceirizado','SERAP07P':'servico_banco_leite_proprio',
          'SERAP07T':'servico_banco_leite_terceirizado','SERAP08P':'servico_lavanderia_proprio',
          'SERAP08T':'servico_lavanderia_terceirizado','SERAP09P':'servico_manutencao_proprio',
          'SERAP09T':'servico_manutencao_terceirizado','SERAP10P':'servico_ambulancia_proprio',
          'SERAP10T':'servico_ambulancia_terceirizado','SERAP11P':'servico_necroterio_proprio',
          'SERAP11T':'servico_necroterio_terceirizado','SERAPOIO':'indicador_servico_apoio',
          'RES_BIOL':'coleta_residuo_biologico','RES_QUIM':'coleta_residuo_quimico',
          'RES_RADI':'coleta_rejeito_radioativo','RES_COMU':'coleta_rejeito_comum',
          'COLETRES':'indicador_coleta_residuo','COMISS01':'comissao_etica_medica',
          'COMISS02':'comissao_etica_enfermagem','COMISS03':'comissao_farmacia_terapeutica',
          'COMISS04':'comissao_controle_infeccao','COMISS05':'comissao_apropriacao_custos',
          'COMISS06':'comissao_cipa','COMISS07':'comissao_revisao_prontuario',
          'COMISS08':'comissao_revisao_documentacao','COMISS09':'comissao_analise_obito_biopisias',
          'COMISS10':'comissao_investigacao_epidemiologica','COMISS11':'comissao_notificacao_doencas',
          'COMISS12':'comissao_zoonose_vetores','COMISSAO':'indicador_comissao',
          'AP01CV01':'atendimento_internacao_sus','AP01CV02':'atendimento_internacao_particular',
          'AP01CV03':'atendimento_internacao_plano_seguro_proprio',
          'AP01CV04':'atendimento_internacao_plano_seguro_terceiro',
          'AP01CV05':'atendimento_internacao_plano_saude_publico',
          'AP01CV06':'atendimento_internacao_plano_saude_privado',
          'AP02CV01':'atendimento_amb_sus','AP02CV02':'atendimento_amb_particular',
          'AP02CV03':'atendimento_amb_plano_seguro_proprio',
          'AP02CV04':'atendimento_amb_plano_seguro_terceiro',
          'AP02CV05':'atendimento_amb_plano_saude_publico',
          'AP02CV06':'atendimento_amb_plano_saude_privado',
          'AP03CV01':'atendimento_sadt_sus','AP03CV02':'atendimento_sadt_privado',
          'AP03CV03':'atendimento_sadt_plano_seguro_proprio',
          'AP03CV04':'atendimento_sadt_plano_seguro_terceiro',
          'AP03CV05':'atendimento_sadt_plano_saude_publico',
          'AP03CV06':'atendimento_sadt_plano_saude_privado','AP04CV01':'atendimento_urgencia_sus',
          'AP04CV02':'atendimento_urgencia_privado','AP04CV03':'atendimento_urgencia_plano_seguro_proprio',
          'AP04CV04':'atendimento_urgencia_plano_seguro_terceiro',
          'AP04CV05':'atendimento_urgencia_plano_saude_publico',
          'AP04CV06':'atendimento_urgencia_plano_saude_privado',
          'AP05CV01':'atendimento_outros_sus','AP05CV02':'atendimento_outros_privado',
          'AP05CV03':'atendimento_outros_plano_seguro_proprio',
          'AP05CV04':'atendimento_outros_plano_seguro_terceiro',
          'AP05CV05':'atendimento_outros_plano_saude_publico',
          'AP05CV06':'atendimento_outros_plano_saude_privado','AP06CV01':'atendimento_vigilancia_sus',
          'AP06CV02':'atendimento_vigilancia_privado',
          'AP06CV03':'atendimento_vigilancia_plano_seguro_proprio',
          'AP06CV04':'atendimento_vigilancia_plano_seguro_terceiro',
          'AP06CV05':'atendimento_vigilancia_plano_saude_publico',
          'AP06CV06':'atendimento_vigilancia_plano_saude_privado',
          'AP07CV01':'atendimento_regulacao_sus','AP07CV02':'atendimento_regulacao_privado',
          'AP07CV03':'atendimento_regulacao_plano_seguro_proprio',
          'AP07CV04':'atendimento_regulacao_plano_seguro_terceiro',
          'AP07CV05':'atendimento_regulacao_plano_saude_publico',
          'AP07CV06':'atendimento_regulacao_plano_saude_privado',
          'ATEND_PR':'indicador_atendimento_prestado','DT_ATUAL':'data_atualizacao',
          'COMPETEN':'data_competencia','NAT_JUR':'natureza_juridica'
}

# Lista com a ordem das colunas
ordem = [
    'id_municipio','id_municipio_6','id_cnes','regiao_saude','microrregiao_saude',
    'distrito_sanitario','distrito_administrativo','cep','cpf_cnpj','indicador_pessoa',
    'grau_dependencia','cnpj_mantenedora','codigo_ir','vinculo_sus','tipo_gestao','esfera_administrativa',
    'retencao_tributos','atividade_ensino_pesquisa','natureza_administrativa','fluxo_atendimento',
    'tipo_unidade','turno','nivel_hierarquia','tipo_prestador','codigo_banco','codigo_agencia',
    'conta_corrente','contrato_municipio_sus','data_publicacao_contrato_municipal','contrato_estado_sus',
    'data_publicacao_contrato_estadual','numero_alvara','data_expedicao_alvara','orgao_expedidor',
    'avaliacao_acreditacao_hospitalar','classificacao_acreditacao_hospitalar','data_acreditacao_mes','data_acreditacao_ano',
    'avaliacao_pnass','data_avaliacao_pnass_ano','data_avaliacao_pnass_mes','gestao_basica_amb_estadual','gestao_basica_amb_municipal',
    'gestao_media_amb_estadual','gestao_media_amb_municipal','gestao_alta_amb_estadual',
    'gestao_alta_amb_municipal','atencao_amb','gestao_estadual','gestao_municipal',
    'gestao_media_hosp_estadual','gestao_media_hosp_municipal','gestao_alta_hosp_estadual',
    'gestao_alta_hosp_municipal','atencao_hosp','quantidade_leitos_cirurgico',
    'quantidade_leitos_clinico','quantidade_leitos_complementar','indicador_leitos_hosp',
    'quantidade_consultorio_pediatrico','quantidade_consultorio_feminino',
    'quantidade_consultorio_masculino','quantidade_consultorio_indiferenciado',
    'quantidade_sala_repouso_pediatrico_urgencia','quantidade_sala_repouso_feminino_urgencia',
    'quantidade_sala_repouso_masculino_urgencia','quantidade_sala_repouso_indiferenciado_urgencia',
    'quantidade_consultorio_odontologia_urgencia','quantidade_sala_higienizacao_urgencia',
    'quantidade_sala_gesso_urgencia','quantidade_sala_curativo_urgencia',
    'quantidade_sala_pequena_cirurgia_urgencia','quantidade_consultorio_medico_urgencia',
    'indicador_instalacao_urgencia','quantidade_consultorio_clinica_basica',
    'quantidade_consultorio_clinica_especializada','quantidade_consultorio_clinica_indiferenciada',
    'quantidade_consultorio_nao_medico','quantidade_sala_repouso_feminino_amb',
    'quantidade_sala_repouso_masculino_amb','quantidade_sala_repouso_pediatrico_amb',
    'quantidade_sala_repouso_indiferenciado_amb','quantidade_consultorio_odontologia_amb',
    'quantidade_sala_pequena_cirurgia_amb','quantidade_sala_enfermagem_amb',
    'quantidade_sala_imunizacao_amb','quantidade_sala_nebulizacao_amb','quantidade_sala_gesso_amb',
    'quantidade_sala_curativo_amb','quantidade_sala_cirurgia_amb','indicador_instalcao_ambulatorial',
    'quantidade_sala_cirurgia','quantidade_sala_recuperacao','quantidade_sala_cirurgia_amb_centro_cirurgico',
    'indicador_instalacao_centro_cirurgico','quantidade_sala_pre_parto','quantidade_sala_parto_normal',
    'quantidade_sala_curetagem','quantidade_sala_cirurgia_centro_obstetrico',
    'indicador_instalacao_centro_obstetrico','quantidade_leito_repouso_pediatrico_urgencia',
    'quantidade_leito_repouso_feminino_urgencia','quantidade_leito_repouso_masculino_urgencia',
    'quantidade_leito_repouso_indiferenciado_urgencia','quantidade_equipos_odontologia_urgencia',
    'quantidade_leito_repouso_feminino_amb','quantidade_leito_repouso_masculino_amb',
    'quantidade_leito_repouso_pediatrico_amb','quantidade_leito_repouso_indiferenciado_amb',
    'quantidade_equipos_odontologia_amb','quantidade_leito_recuperacao_centro_cirurgico',
    'quantidade_leito_pre_parto','quantidade_leito_recem_nascido_normal',
    'quantidade_leito_recem_nascido_patologico','quantidade_leito_conjunto_neonatal',
    'indicador_instalacao_neonatal','indicador_instalaco_hospitalar','servico_apoio_proprio',
    'servico_apoio_terceirizado','servico_social_proprio','servico_social_terceirizado',
    'servico_farmacia_proprio','servico_farmacia_terceirizado','servico_esterilizacao_proprio',
    'servico_esterilizacao_terceirizado','servico_nutricao_proprio','servico_nutricao_terceirizado',
    'servico_lactario_proprio','servico_lactario_terceirizado','servico_banco_leite_proprio',
    'servico_banco_leite_terceirizado','servico_lavanderia_proprio','servico_lavanderia_terceirizado',
    'servico_manutencao_proprio','servico_manutencao_terceirizado','servico_ambulancia_proprio',
    'servico_ambulancia_terceirizado','servico_necroterio_proprio','servico_necroterio_terceirizado',
    'indicador_servico_apoio','coleta_residuo_biologico','coleta_residuo_quimico','coleta_rejeito_radioativo',
    'coleta_rejeito_comum','indicador_coleta_residuo','comissao_etica_medica','comissao_etica_enfermagem',
    'comissao_farmacia_terapeutica','comissao_controle_infeccao','comissao_apropriacao_custos',
    'comissao_cipa','comissao_revisao_prontuario','comissao_revisao_documentacao',
    'comissao_analise_obito_biopisias','comissao_investigacao_epidemiologica',
    'comissao_notificacao_doencas','comissao_zoonose_vetores','indicador_comissao',
    'atendimento_internacao_sus','atendimento_internacao_particular',
    'atendimento_internacao_plano_seguro_proprio','atendimento_internacao_plano_seguro_terceiro',
    'atendimento_internacao_plano_saude_publico','atendimento_internacao_plano_saude_privado',
    'atendimento_amb_sus','atendimento_amb_particular','atendimento_amb_plano_seguro_proprio',
    'atendimento_amb_plano_seguro_terceiro','atendimento_amb_plano_saude_publico',
    'atendimento_amb_plano_saude_privado','atendimento_sadt_sus','atendimento_sadt_privado',
    'atendimento_sadt_plano_seguro_proprio','atendimento_sadt_plano_seguro_terceiro',
    'atendimento_sadt_plano_saude_publico','atendimento_sadt_plano_saude_privado',
    'atendimento_urgencia_sus','atendimento_urgencia_privado','atendimento_urgencia_plano_seguro_proprio',
    'atendimento_urgencia_plano_seguro_terceiro','atendimento_urgencia_plano_saude_publico',
    'atendimento_urgencia_plano_saude_privado','atendimento_outros_sus','atendimento_outros_privado',
    'atendimento_outros_plano_seguro_proprio','atendimento_outros_plano_seguro_terceiro',
    'atendimento_outros_plano_saude_publico','atendimento_outros_plano_saude_privado',
    'atendimento_vigilancia_sus','atendimento_vigilancia_privado',
    'atendimento_vigilancia_plano_seguro_proprio','atendimento_vigilancia_plano_seguro_terceiro',
    'atendimento_vigilancia_plano_saude_publico','atendimento_vigilancia_plano_saude_privado',
    'atendimento_regulacao_sus','atendimento_regulacao_privado','atendimento_regulacao_plano_seguro_proprio',
    'atendimento_regulacao_plano_seguro_terceiro','atendimento_regulacao_plano_saude_publico',
    'atendimento_regulacao_plano_saude_privado','indicador_atendimento_prestado','data_atualizacao_ano',
    'data_atualizacao_mes','data_competencia_ano','data_competencia_mes','natureza_juridica'
]


# Laço para o ETL de cada arquivo e salvamento em cada pasta correspondente 
for i in range(len(file)):
    try:
        print("Fazendo ano{}-mes{}-uf{}".format(ano[i],mes[i],uf[i]))
        df = pd.read_csv(file[i],dtype='string',encoding='latin',)
        df.dropna(how='any',subset={'CNES'}, inplace=True)
        df.drop('Unnamed: 0',axis='columns', inplace=True)
        df = df.drop_duplicates()
        df['CPF_CNPJ'] = df['CPF_CNPJ'].replace('00000000000000','')
        df = pd.merge(df, id_mun, how='left', left_on='CODUFMUN', right_on= 'id_municipio_6', validate='many_to_one')
        df.drop(columns=['CODUFMUN'], inplace=True)
        df['DT_EXPED'] = df['DT_EXPED'].str.lstrip('00')
        df['DT_EXPED'] = pd.to_datetime(df['DT_EXPED'], errors='coerce').dt.date
        df['DT_PUBLM'] = pd.to_datetime(df['DT_PUBLM'], format='%Y%m%d' ,errors='coerce').dt.date
        df['DT_PUBLE'] = pd.to_datetime(df['DT_PUBLE'], format='%Y%m%d' ,errors='coerce').dt.date
        df['data_acreditacao_ano'] = pd.to_datetime(df['DT_ACRED'], format='%Y%m' ,errors='coerce').dt.year.astype('str')
        df['data_acreditacao_mes'] = pd.to_datetime(df['DT_ACRED'], format='%Y%m' ,errors='coerce').dt.month.astype('str')
        df['data_avaliacao_pnass_ano'] = pd.to_datetime(df['DT_PNASS'], format='%Y%m' ,errors='coerce').dt.year.astype('str')
        df['data_avaliacao_pnass_mes'] = pd.to_datetime(df['DT_PNASS'], format='%Y%m' ,errors='coerce').dt.month.astype('str')
        df['data_atualizacao_ano'] = pd.to_datetime(df['DT_ATUAL'], format='%Y%m' ,errors='coerce').dt.year.astype('str')
        df['data_atualizacao_mes'] = pd.to_datetime(df['DT_ATUAL'], format='%Y%m' ,errors='coerce').dt.month.astype('str')
        df['data_competencia_ano'] = pd.to_datetime(df['COMPETEN'], format='%Y%m' ,errors='coerce').dt.year.astype('str')
        df['data_competencia_mes'] = pd.to_datetime(df['COMPETEN'], format='%Y%m' ,errors='coerce').dt.month.astype('str')
        strip = ['REGSAUDE','MICR_REG','DISTRSAN','DISTRADM','PF_PJ','NIV_DEP','COD_IR',
                 'ESFERA_A','ATIVIDAD','TP_UNID','TURNO_AT','NIV_HIER','TP_PREST','ORGEXPED',
                 'AV_ACRED','AV_PNASS']
        for x in strip:
            df[x] = df[x].str.replace(',','')
            df[x] = df[x].str.replace('¿','')
            df[x] = df[x].str.rstrip('ª')
            df[x] = df[x].str.rstrip('º')
            df[x] = df[x].str.lstrip('0')
        if 5<= ano[i] <=11:
            add_05_12 = pd.DataFrame(columns=['natureza_juridica'])
            df = pd.concat([df,add_05_12])
        elif ano[i] ==12 and mes[i]<=5:
            add_05_12 = pd.DataFrame(columns=['natureza_juridica'])
            df = pd.concat([df,add_05_12])
        df.rename(columns=rename, inplace=True)
        df = df[ordem]
        df = df.drop_duplicates()
        if 5<= ano[i] <=9:
            df.to_csv("./output/ano=200{}/mes={}/sigla_uf={}/estabelecimento.csv".format(ano[i],mes[i],uf[i]),index=False)
        else:
            df.to_csv("./output/ano=20{}/mes={}/sigla_uf={}/estabelecimento.csv".format(ano[i],mes[i],uf[i]),index=False)
    except:
        print("Erro em ano{}-mes{}-uf{} em linha {}".format(ano[i],mes[i],uf[i], i))
