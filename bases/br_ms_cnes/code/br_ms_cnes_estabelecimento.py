# -*- coding: utf-8 -*-
"""
Created on Mon Sep  6 09:19:44 2021
@author: Gustavo

@author: Gabriel P. Folhes
Changed rename dict and order list according to the new
architecture on Mon March  13 09:19:44 2023
"""
# pylint: disable=anomalous-backslash-in-string
import glob
import os

import pandas as pd

# importa tabela com id_municipio IBGE (disponível em br_bd_diretorios_brasil no BigQuery)
id_mun = pd.read_csv("./extra/id_municipio.csv", dtype="string")

# Lista os caminhos dos arquivos raw na pasta de input
file = []
for filepath in glob.iglob(".\input\estabelecimento\*.csv"):
    file.append(filepath)

# Define listas com uf,mes e ano
uf = []
for i, _ in enumerate(file):
    uf.append(file[i][-10:-8])

mes = []
for i, _ in enumerate(file):
    mes.append(int(file[i][-6:-4]))

ano = []
for  i, _ in enumerate(file):
    ano.append(int(file[i][-8:-6]))


ufs = [
    "AC",
    "AL",
    "AP",
    "AM",
    "BA",
    "CE",
    "DF",
    "ES",
    "GO",
    "MA",
    "MT",
    "MS",
    "MG",
    "PA",
    "PB",
    "PR",
    "PE",
    "PI",
    "RJ",
    "RN",
    "RS",
    "RO",
    "RR",
    "SC",
    "SP",
    "SE",
    "TO",
]

# Cria as pastas
for u, _ in enumerate(ufs):
    for a in range(5, 22):
        if a == 5:
            for m in range(8, 13):
                try:
                    os.makedirs(
                        "./output/ano={}/mes={}/sigla_uf={}".format(
                            str(a), str(m), ufs[u]
                        )
                    )
                except Exception:
                    pass
        elif a == 21:
            for m in range(1, 7):
                try:
                    os.makedirs(
                        "./output/ano={}/mes={}/sigla_uf={}".format(
                            str(a), str(m), ufs[u]
                        )
                    )
                except Exception:
                    pass
        else:
            for m in range(1, 13):
                try:
                    os.makedirs(
                        "./output/ano={}/mes={}/sigla_uf={}".format(
                            str(a), str(m), ufs[u]
                        )
                    )
                except Exception:
                    pass

# Lista para renomar colunas
rename = { 
        'CODUFMUN': 'id_municipio_6',
        'REGSAUDE': 'id_regiao_saude',
        'MICR_REG': 'id_microrregiao_saude',
        'DISTRSAN': 'id_distrito_sanitario',
        'DISTRADM': 'id_distrito_administrativo',
        'COD_CEP' : 'cep',
        'CNES'    : 'id_estabelecimento_cnes',
        'PF_PJ'   : 'tipo_pessoa',
        'CPF_CNPJ': 'cpf_cnpj',
        'NIV_DEP' : 'tipo_grau_dependencia',
        'CNPJ_MAN': 'cnpj_mantenedora',
        'COD_IR'  : 'tipo_retencao_tributos_mantenedora',
        'VINC_SUS': 'indicador_vinculo_sus',
        'TPGESTAO': 'tipo_gestao',
        'ESFERA_A': 'tipo_esfera_administrativa',
        'RETENCAO': 'tipo_retencao_tributos',
        'ATIVIDAD': 'tipo_atividade_ensino_pesquisa',
        'NATUREZA': 'tipo_natureza_administrativa',
        'NAT_JUR' : 'id_natureza_juridica',
        'CLIENTEL': 'tipo_fluxo_atendimento',
        'TP_UNID' : 'tipo_unidade',
        'TURNO_AT': 'tipo_turno',
        'NIV_HIER': 'tipo_nivel_hierarquia',
        'TP_PREST': 'tipo_prestador',
        
        'CO_BANCO': 'banco',
        'CO_AGENC': 'agencia',
        'C_CORREN': 'conta_corrente',
        'CONTRATM': 'id_contrato_municipio_sus',
        'DT_PUBLM': 'data_publicacao_contrato_municipal',
        'CONTRATE': 'id_contrato_estado_sus',
        'DT_PUBLE': 'data_publicacao_contrato_estadual',
        'ALVARA':   'numero_alvara',
        'DT_EXPED': 'data_expedicao_alvara',
        'ORGEXPED': 'tipo_orgao_expedidor',
        
        # caso do indicador_avaliacao_acreditacao_hospitalar mas ids sao 1 e 2
        'AV_ACRED': 'tipo_avaliacao_acreditacao_hospitalar',
        'CLASAVAL': 'tipo_classificacao_acreditacao_hospitalar',
        # ! essas variáveis são criadas em baixo 
        #'DT_ACRED': 'mes_acreditacao',
        #'DT_ACRED': 'ano_acreditacao',
        'AV_PNASS': 'tipo_avaliacao_pnass',
        #'DT_PNASS': 'ano_avaliacao_pnass',
        #'DT_PNASS': 'mes_avaliacao_pnass',
        'NIVATE_A': 'indicador_atencao_ambulatorial',
        'GESPRG1E': 'indicador_gestao_basica_ambulatorial_estadual',
        'GESPRG1M': 'indicador_gestao_basica_ambulatorial_municipal',
        'GESPRG2E': 'indicador_gestao_media_ambulatorial_estadual',
        'GESPRG2M': 'indicador_gestao_media_ambulatorial_municipal',
        'GESPRG4E': 'indicador_gestao_alta_ambulatorial_estadual',
        'GESPRG4M': 'indicador_gestao_alta_ambulatorial_municipal',
        'NIVATE_H': 'indicador_atencao_hospitalar',
        'GESPRG5E': 'indicador_gestao_media_hospitalar_estadual',
        'GESPRG5M': 'indicador_gestao_media_hospitalar_municipal',
        'GESPRG6E': 'indicador_gestao_alta_hospitalar_estadual',
        'GESPRG6M': 'indicador_gestao_alta_hospitalar_municipal',
        'GESPRG3E': 'indicador_gestao_hospitalar_estadual',
        'GESPRG3M': 'indicador_gestao_hospitalar_municipal',
        'LEITHOSP': 'indicador_leito_hospitalar',
        'QTLEITP1': 'quantidade_leito_cirurgico',
        'QTLEITP2': 'quantidade_leito_clinico',
        'QTLEITP3': 'quantidade_leito_complementar',
        'URGEMERG': 'indicador_instalacao_urgencia',
        'QTINST01': 'quantidade_consultorio_pediatrico_urgencia',
        'QTINST02': 'quantidade_consultorio_feminino_urgencia',
        'QTINST03': 'quantidade_consultorio_masculino_urgencia',
        'QTINST04': 'quantidade_consultorio_indiferenciado_urgencia',
        'QTINST05': 'quantidade_sala_repouso_pediatrico_urgencia',
        'QTLEIT05': 'quantidade_leito_repouso_pediatrico_urgencia',
        'QTINST06': 'quantidade_sala_repouso_feminino_urgencia',
        'QTLEIT06': 'quantidade_leito_repouso_feminino_urgencia',
        'QTINST07': 'quantidade_sala_repouso_masculino_urgencia',
        'QTLEIT07': 'quantidade_leito_repouso_masculino_urgencia',
        'QTINST08': 'quantidade_sala_repouso_indiferenciado_urgencia',
        'QTLEIT08': 'quantidade_leito_repouso_indiferenciado_urgencia',
        'QTINST09': 'quantidade_consultorio_odontologia_urgencia',
        'QTLEIT09': 'quantidade_equipos_odontologia_urgencia',
        'QTINST10': 'quantidade_sala_higienizacao_urgencia',
        'QTINST11': 'quantidade_sala_gesso_urgencia',
        'QTINST12': 'quantidade_sala_curativo_urgencia',
        'QTINST13': 'quantidade_sala_pequena_cirurgia_urgencia',
        'QTINST14': 'quantidade_consultorio_medico_urgencia',
        'ATENDAMB': 'indicador_instalacao_ambulatorial',
        'QTINST15': 'quantidade_consultorio_clinica_basica_ambulatorial',
        'QTINST16': 'quantidade_consultorio_clinica_especializada_ambulatorial',
        'QTINST17': 'quantidade_consultorio_clinica_indiferenciada_ambulatorial',
        'QTINST18': 'quantidade_consultorio_nao_medico_ambulatorial',
        'QTINST19': 'quantidade_sala_repouso_feminino_ambulatorial',
        'QTLEIT19': 'quantidade_leito_repouso_feminino_ambulatorial',
        'QTINST20': 'quantidade_sala_repouso_masculino_ambulatorial',
        'QTLEIT20': 'quantidade_leito_repouso_masculino_ambulatorial',
        'QTINST21': 'quantidade_sala_repouso_pediatrico_ambulatorial',
        'QTLEIT21': 'quantidade_leito_repouso_pediatrico_ambulatorial',
        'QTINST22': 'quantidade_sala_repouso_indiferenciado_ambulatorial',
        'QTLEIT22': 'quantidade_leito_repouso_indiferenciado_ambulatorial',
        'QTINST23': 'quantidade_consultorio_odontologia_ambulatorial',
        'QTLEIT23': 'quantidade_equipos_odontologia_ambulatorial',
        'QTINST24': 'quantidade_sala_pequena_cirurgia_ambulatorial',
        'QTINST25': 'quantidade_sala_enfermagem_ambulatorial',
        'QTINST26': 'quantidade_sala_imunizacao_ambulatorial',
        'QTINST27': 'quantidade_sala_nebulizacao_ambulatorial',
        'QTINST28': 'quantidade_sala_gesso_ambulatorial',
        'QTINST29': 'quantidade_sala_curativo_ambulatorial',
        'QTINST30': 'quantidade_sala_cirurgia_ambulatorial',
        'ATENDHOS': 'indicador_instalacao_hospitalar',
        'CENTRCIR': 'indicador_instalacao_hospitalar_centro_cirurgico',
        'QTINST31': 'quantidade_sala_cirurgia_centro_cirurgico',
        'QTINST32': 'quantidade_sala_recuperacao_centro_cirurgico',
        'QTLEIT32': 'quantidade_leito_recuperacao_centro_cirurgico',
        'QTINST33': 'quantidade_sala_cirurgia_ambulatorial_centro_cirurgico',
        'CENTROBS': 'indicador_instalacao_hospitalar_centro_obstetrico',
        'QTINST34': 'quantidade_sala_pre_parto_centro_obstetrico',
        'QTLEIT34': 'quantidade_leito_pre_parto_centro_obstetrico',
        'QTINST35': 'quantidade_sala_parto_normal_centro_obstetrico',
        'QTINST36': 'quantidade_sala_curetagem_centro_obstetrico',
        'QTINST37': 'quantidade_sala_cirurgia_centro_obstetrico',
        'CENTRNEO': 'indicador_instalacao_hospitalar_neonatal',
        'QTLEIT38': 'quantidade_leito_recem_nascido_normal_neonatal',
        'QTLEIT39': 'quantidade_leito_recem_nascido_patologico_neonatal',
        'QTLEIT40': 'quantidade_leito_conjunto_neonatal',
        'SERAPOIO': 'indicador_servico_apoio',
        'SERAP01P': 'indicador_servico_same_spp_proprio',
        'SERAP01T': 'indicador_servico_same_spp_terceirizado',
        'SERAP02P': 'indicador_servico_social_proprio',
        'SERAP02T': 'indicador_servico_social_terceirizado',
        'SERAP03P': 'indicador_servico_farmacia_proprio',
        'SERAP03T': 'indicador_servico_farmacia_terceirizado',
        'SERAP04P': 'indicador_servico_esterilizacao_proprio',
        'SERAP04T': 'indicador_servico_esterilizacao_terceirizado',
        'SERAP05P': 'indicador_servico_nutricao_proprio',
        'SERAP05T': 'indicador_servico_nutricao_terceirizado',
        'SERAP06P': 'indicador_servico_lactario_proprio',
        'SERAP06T': 'indicador_servico_lactario_terceirizado',
        'SERAP07P': 'indicador_servico_banco_leite_proprio',
        'SERAP07T': 'indicador_servico_banco_leite_terceirizado',
        'SERAP08P': 'indicador_servico_lavanderia_proprio',
        'SERAP08T': 'indicador_servico_lavanderia_terceirizado',
        'SERAP09P': 'indicador_servico_manutencao_proprio',
        'SERAP09T': 'indicador_servico_manutencao_terceirizado',
        'SERAP10P': 'indicador_servico_ambulancia_proprio',
        'SERAP10T': 'indicador_servico_ambulancia_terceirizado',
        'SERAP11P': 'indicador_servico_necroterio_proprio',
        'SERAP11T': 'indicador_servico_necroterio_terceirizado',
        'COLETRES': 'indicador_coleta_residuo',
        'RES_BIOL': 'indicador_coleta_residuo_biologico',
        'RES_QUIM': 'indicador_coleta_residuo_quimico',
        'RES_RADI': 'indicador_coleta_rejeito_radioativo',
        'RES_COMU': 'indicador_coleta_rejeito_comum',
        'COMISSAO': 'indicador_comissao',
        'COMISS01': 'indicador_comissao_etica_medica',
        'COMISS02': 'indicador_comissao_etica_enfermagem',
        'COMISS03': 'indicador_comissao_farmacia_terapeutica',
        'COMISS04': 'indicador_comissao_controle_infeccao',
        'COMISS05': 'indicador_comissao_apropriacao_custos',
        'COMISS06': 'indicador_comissao_cipa',
        'COMISS07': 'indicador_comissao_revisao_prontuario',
        'COMISS08': 'indicador_comissao_revisao_documentacao',
        'COMISS09': 'indicador_comissao_analise_obito_biopisias',
        'COMISS10': 'indicador_comissao_investigacao_epidemiologica',
        'COMISS11': 'indicador_comissao_notificacao_doencas',
        'COMISS12': 'indicador_comissao_zoonose_vetores',
        'ATEND_PR': 'indicador_atendimento_prestado',
        'AP01CV01': 'indicador_atendimento_internacao_sus',
        'AP01CV02': 'indicador_atendimento_internacao_particular',
        'AP01CV03': 'indicador_atendimento_internacao_plano_seguro_proprio',
        'AP01CV04': 'indicador_atendimento_internacao_plano_seguro_terceiro',
        'AP01CV05': 'indicador_atendimento_internacao_plano_saude_publico',
        'AP01CV06': 'indicador_atendimento_internacao_plano_saude_privado',
        'AP02CV01': 'indicador_atendimento_ambulatorial_sus',
        'AP02CV02': 'indicador_atendimento_ambulatorial_particular',
        'AP02CV03': 'indicador_atendimento_ambulatorial_plano_seguro_proprio',
        'AP02CV04': 'indicador_atendimento_ambulatorial_plano_seguro_terceiro',
        'AP02CV05': 'indicador_atendimento_ambulatorial_plano_saude_publico',
        'AP02CV06': 'indicador_atendimento_ambulatorial_plano_saude_privado',
        'AP03CV01': 'indicador_atendimento_sadt_sus',
        'AP03CV02': 'indicador_atendimento_sadt_privado',
        'AP03CV03': 'indicador_atendimento_sadt_plano_seguro_proprio',
        'AP03CV04': 'indicador_atendimento_sadt_plano_seguro_terceiro',
        'AP03CV05': 'indicador_atendimento_sadt_plano_saude_publico',
        'AP03CV06': 'indicador_atendimento_sadt_plano_saude_privado',
        'AP04CV01': 'indicador_atendimento_urgencia_sus',
        'AP04CV02': 'indicador_atendimento_urgencia_privado',
        'AP04CV03': 'indicador_atendimento_urgencia_plano_seguro_proprio',
        'AP04CV04': 'indicador_atendimento_urgencia_plano_seguro_terceiro',
        'AP04CV05': 'indicador_atendimento_urgencia_plano_saude_publico',
        'AP04CV06': 'indicador_atendimento_urgencia_plano_saude_privado',
        'AP05CV01': 'indicador_atendimento_outros_sus',
        'AP05CV02': 'indicador_atendimento_outros_privado',
        'AP05CV03': 'indicador_atendimento_outros_plano_seguro_proprio',
        'AP05CV04': 'indicador_atendimento_outros_plano_seguro_terceiro',
        'AP05CV05': 'indicador_atendimento_outros_plano_saude_publico',
        'AP05CV06': 'indicador_atendimento_outros_plano_saude_privado',
        'AP06CV01': 'indicador_atendimento_vigilancia_sus',
        'AP06CV02': 'indicador_atendimento_vigilancia_privado',
        'AP06CV03': 'indicador_atendimento_vigilancia_plano_seguro_proprio',
        'AP06CV04': 'indicador_atendimento_vigilancia_plano_seguro_terceiro',
        'AP06CV05': 'indicador_atendimento_vigilancia_plano_saude_publico',
        'AP06CV06': 'indicador_atendimento_vigilancia_plano_saude_privado',
        'AP07CV01': 'indicador_atendimento_regulacao_sus',
        'AP07CV02': 'indicador_atendimento_regulacao_privado',
        'AP07CV03': 'indicador_atendimento_regulacao_plano_seguro_proprio',
        'AP07CV04': 'indicador_atendimento_regulacao_plano_seguro_terceiro',
        'AP07CV05': 'indicador_atendimento_regulacao_plano_saude_publico',
        'AP07CV06': 'indicador_atendimento_regulacao_plano_saude_privado',
        'DT_ATUAL': 'data_atualizacao',
        'COMPETEN': 'data_competencia'
  }

# Lista com a ordem das colunas
ordem_colunas = [
        
        'ano_atualizacao',
        'mes_atualizacao',
        
        'ano_competencia',
        'mes_competencia',
        'id_municipio',
        'id_municipio_6',
        'id_regiao_saude',
        'id_microrregiao_saude',
        'id_distrito_sanitario',
        'id_distrito_administrativo',
        'cep',
        'id_estabelecimento_cnes',
        'tipo_pessoa',
        'cpf_cnpj',
        'tipo_grau_dependencia',
        'cnpj_mantenedora',
        'tipo_retencao_tributos_mantenedora',
        'indicador_vinculo_sus',
        'tipo_gestao',
        'tipo_esfera_administrativa',
        'tipo_retencao_tributos',
        'tipo_atividade_ensino_pesquisa',
        'tipo_natureza_administrativa',
        'id_natureza_juridica',
        'tipo_fluxo_atendimento',
        'tipo_unidade',
        'tipo_turno',
        'tipo_nivel_hierarquia',
        'tipo_prestador',
        'banco',
        'agencia',
        'conta_corrente',
        'id_contrato_municipio_sus',
        'data_publicacao_contrato_municipal',
        'id_contrato_estado_sus',
        'data_publicacao_contrato_estadual',
        'numero_alvara',
        'data_expedicao_alvara',
        'tipo_orgao_expedidor',
        'tipo_avaliacao_acreditacao_hospitalar',
        'tipo_classificacao_acreditacao_hospitalar',
        'mes_acreditacao',
        'ano_acreditacao',
        'tipo_avaliacao_pnass',
        'ano_avaliacao_pnass',
        'mes_avaliacao_pnass',
        'indicador_atencao_ambulatorial',
        'indicador_gestao_basica_ambulatorial_estadual',
        'indicador_gestao_basica_ambulatorial_municipal',
        'indicador_gestao_media_ambulatorial_estadual',
        'indicador_gestao_media_ambulatorial_municipal',
        'indicador_gestao_alta_ambulatorial_estadual',
        'indicador_gestao_alta_ambulatorial_municipal',
        'indicador_atencao_hospitalar',
        'indicador_gestao_media_hospitalar_estadual',
        'indicador_gestao_media_hospitalar_municipal',
        'indicador_gestao_alta_hospitalar_estadual',
        'indicador_gestao_alta_hospitalar_municipal',
        'indicador_gestao_hospitalar_estadual',
        'indicador_gestao_hospitalar_municipal',
        'indicador_leito_hospitalar',
        'quantidade_leito_cirurgico',
        'quantidade_leito_clinico',
        'quantidade_leito_complementar',
        'quantidade_leito_repouso_pediatrico_urgencia',
        'quantidade_leito_repouso_feminino_urgencia',
        'quantidade_leito_repouso_masculino_urgencia',
        'quantidade_leito_repouso_indiferenciado_urgencia',
        'indicador_instalacao_urgencia',
        'quantidade_consultorio_pediatrico_urgencia',
        'quantidade_consultorio_feminino_urgencia',
        'quantidade_consultorio_masculino_urgencia',
        'quantidade_consultorio_indiferenciado_urgencia',
        'quantidade_consultorio_odontologia_urgencia',
        'quantidade_sala_repouso_pediatrico_urgencia',
        'quantidade_sala_repouso_feminino_urgencia',
        'quantidade_sala_repouso_masculino_urgencia',
        'quantidade_sala_repouso_indiferenciado_urgencia',
        'quantidade_equipos_odontologia_urgencia',
        'quantidade_sala_higienizacao_urgencia',
        'quantidade_sala_gesso_urgencia',
        'quantidade_sala_curativo_urgencia',
        'quantidade_sala_pequena_cirurgia_urgencia',
        'quantidade_consultorio_medico_urgencia',
        'indicador_instalacao_ambulatorial',
        'quantidade_consultorio_clinica_basica_ambulatorial',
        'quantidade_consultorio_clinica_especializada_ambulatorial',
        'quantidade_consultorio_clinica_indiferenciada_ambulatorial',
        'quantidade_consultorio_nao_medico_ambulatorial',
        'quantidade_sala_repouso_feminino_ambulatorial',
        'quantidade_leito_repouso_feminino_ambulatorial',
        'quantidade_sala_repouso_masculino_ambulatorial',
        'quantidade_leito_repouso_masculino_ambulatorial',
        'quantidade_sala_repouso_pediatrico_ambulatorial',
        'quantidade_leito_repouso_pediatrico_ambulatorial',
        'quantidade_sala_repouso_indiferenciado_ambulatorial',
        'quantidade_leito_repouso_indiferenciado_ambulatorial',
        'quantidade_consultorio_odontologia_ambulatorial',
        'quantidade_equipos_odontologia_ambulatorial',
        'quantidade_sala_pequena_cirurgia_ambulatorial',
        'quantidade_sala_enfermagem_ambulatorial',
        'quantidade_sala_imunizacao_ambulatorial',
        'quantidade_sala_nebulizacao_ambulatorial',
        'quantidade_sala_gesso_ambulatorial',
        'quantidade_sala_curativo_ambulatorial',
        'quantidade_sala_cirurgia_ambulatorial',
        'indicador_instalacao_hospitalar',
        'indicador_instalacao_hospitalar_centro_cirurgico',
        'quantidade_sala_cirurgia_centro_cirurgico',
        'quantidade_sala_recuperacao_centro_cirurgico',
        'quantidade_leito_recuperacao_centro_cirurgico',
        'quantidade_sala_cirurgia_ambulatorial_centro_cirurgico',
        'indicador_instalacao_hospitalar_centro_obstetrico',
        'quantidade_sala_pre_parto_centro_obstetrico',
        'quantidade_leito_pre_parto_centro_obstetrico',
        'quantidade_sala_parto_normal_centro_obstetrico',
        'quantidade_sala_curetagem_centro_obstetrico',
        'quantidade_sala_cirurgia_centro_obstetrico',
        'indicador_instalacao_hospitalar_neonatal',
        'quantidade_leito_recem_nascido_normal_neonatal',
        'quantidade_leito_recem_nascido_patologico_neonatal',
        'quantidade_leito_conjunto_neonatal',
        'indicador_servico_apoio',
        'indicador_servico_same_spp_proprio',
        'indicador_servico_same_spp_terceirizado',
        'indicador_servico_social_proprio',
        'indicador_servico_social_terceirizado',
        'indicador_servico_farmacia_proprio',
        'indicador_servico_farmacia_terceirizado',
        'indicador_servico_esterilizacao_proprio',
        'indicador_servico_esterilizacao_terceirizado',
        'indicador_servico_nutricao_proprio',
        'indicador_servico_nutricao_terceirizado',
        'indicador_servico_lactario_proprio',
        'indicador_servico_lactario_terceirizado',
        'indicador_servico_banco_leite_proprio',
        'indicador_servico_banco_leite_terceirizado',
        'indicador_servico_lavanderia_proprio',
        'indicador_servico_lavanderia_terceirizado',
        'indicador_servico_manutencao_proprio',
        'indicador_servico_manutencao_terceirizado',
        'indicador_servico_ambulancia_proprio',
        'indicador_servico_ambulancia_terceirizado',
        'indicador_servico_necroterio_proprio',
        'indicador_servico_necroterio_terceirizado',
        'indicador_coleta_residuo',
        'indicador_coleta_residuo_biologico',
        'indicador_coleta_residuo_quimico',
        'indicador_coleta_rejeito_radioativo',
        'indicador_coleta_rejeito_comum',
        'indicador_comissao',
        'indicador_comissao_etica_medica',
        'indicador_comissao_etica_enfermagem',
        'indicador_comissao_farmacia_terapeutica',
        'indicador_comissao_controle_infeccao',
        'indicador_comissao_apropriacao_custos',
        'indicador_comissao_cipa',
        'indicador_comissao_revisao_prontuario',
        'indicador_comissao_revisao_documentacao',
        'indicador_comissao_analise_obito_biopisias',
        'indicador_comissao_investigacao_epidemiologica',
        'indicador_comissao_notificacao_doencas',
        'indicador_comissao_zoonose_vetores',
        'indicador_atendimento_prestado',
        'indicador_atendimento_internacao_sus',
        'indicador_atendimento_internacao_particular',
        'indicador_atendimento_internacao_plano_seguro_proprio',
        'indicador_atendimento_internacao_plano_seguro_terceiro',
        'indicador_atendimento_internacao_plano_saude_publico',
        'indicador_atendimento_internacao_plano_saude_privado',
        'indicador_atendimento_ambulatorial_sus',
        'indicador_atendimento_ambulatorial_particular',
        'indicador_atendimento_ambulatorial_plano_seguro_proprio',
        'indicador_atendimento_ambulatorial_plano_seguro_terceiro',
        'indicador_atendimento_ambulatorial_plano_saude_publico',
        'indicador_atendimento_ambulatorial_plano_saude_privado',
        'indicador_atendimento_sadt_sus',
        'indicador_atendimento_sadt_privado',
        'indicador_atendimento_sadt_plano_seguro_proprio',
        'indicador_atendimento_sadt_plano_seguro_terceiro',
        'indicador_atendimento_sadt_plano_saude_publico',
        'indicador_atendimento_sadt_plano_saude_privado',
        'indicador_atendimento_urgencia_sus',
        'indicador_atendimento_urgencia_privado',
        'indicador_atendimento_urgencia_plano_seguro_proprio',
        'indicador_atendimento_urgencia_plano_seguro_terceiro',
        'indicador_atendimento_urgencia_plano_saude_publico',
        'indicador_atendimento_urgencia_plano_saude_privado',
        'indicador_atendimento_outros_sus',
        'indicador_atendimento_outros_privado',
        'indicador_atendimento_outros_plano_seguro_proprio',
        'indicador_atendimento_outros_plano_seguro_terceiro',
        'indicador_atendimento_outros_plano_saude_publico',
        'indicador_atendimento_outros_plano_saude_privado',
        'indicador_atendimento_vigilancia_sus',
        'indicador_atendimento_vigilancia_privado',
        'indicador_atendimento_vigilancia_plano_seguro_proprio',
        'indicador_atendimento_vigilancia_plano_seguro_terceiro',
        'indicador_atendimento_vigilancia_plano_saude_publico',
        'indicador_atendimento_vigilancia_plano_saude_privado',
        'indicador_atendimento_regulacao_sus',
        'indicador_atendimento_regulacao_privado',
        'indicador_atendimento_regulacao_plano_seguro_proprio',
        'indicador_atendimento_regulacao_plano_seguro_terceiro',
        'indicador_atendimento_regulacao_plano_saude_publico',
        'indicador_atendimento_regulacao_plano_saude_privado']


# Laço para o ETL de cada arquivo e salvamento em cada pasta correspondente
for i, _ in enumerate(file):
    try:
        print("Fazendo ano{}-mes{}-uf{}".format(ano[i], mes[i], uf[i]))
        df = pd.read_csv(
            file[i],
            dtype="string",
            encoding="latin",
        )
        df.dropna(how="any", subset={"CNES"}, inplace=True)
        df.drop("Unnamed: 0", axis="columns", inplace=True)
        df = df.drop_duplicates()
        df["CPF_CNPJ"] = df["CPF_CNPJ"].replace("00000000000000", "")
        df = pd.merge(
            df,
            id_mun,
            how="left",
            left_on="CODUFMUN",
            right_on="id_municipio_6",
            validate="many_to_one",
        )
        df.drop(columns=["CODUFMUN"], inplace=True)
        df["DT_EXPED"] = df["DT_EXPED"].str.lstrip("00")
        df["DT_EXPED"] = pd.to_datetime(df["DT_EXPED"], errors="coerce").dt.date
        df["DT_PUBLM"] = pd.to_datetime(
            df["DT_PUBLM"], format="%Y%m%d", errors="coerce"
        ).dt.date
        df["DT_PUBLE"] = pd.to_datetime(
            df["DT_PUBLE"], format="%Y%m%d", errors="coerce"
        ).dt.date
        df["data_acreditacao_ano"] = pd.to_datetime(
            df["DT_ACRED"], format="%Y%m", errors="coerce"
        ).dt.year.astype("str")
        df["data_acreditacao_mes"] = pd.to_datetime(
            df["DT_ACRED"], format="%Y%m", errors="coerce"
        ).dt.month.astype("str")
        df["data_avaliacao_pnass_ano"] = pd.to_datetime(
            df["DT_PNASS"], format="%Y%m", errors="coerce"
        ).dt.year.astype("str")
        df["data_avaliacao_pnass_mes"] = pd.to_datetime(
            df["DT_PNASS"], format="%Y%m", errors="coerce"
        ).dt.month.astype("str")
        df["data_atualizacao_ano"] = pd.to_datetime(
            df["DT_ATUAL"], format="%Y%m", errors="coerce"
        ).dt.year.astype("str")
        df["data_atualizacao_mes"] = pd.to_datetime(
            df["DT_ATUAL"], format="%Y%m", errors="coerce"
        ).dt.month.astype("str")
        df["data_competencia_ano"] = pd.to_datetime(
            df["COMPETEN"], format="%Y%m", errors="coerce"
        ).dt.year.astype("str")
        df["data_competencia_mes"] = pd.to_datetime(
            df["COMPETEN"], format="%Y%m", errors="coerce"
        ).dt.month.astype("str")
        strip = [
            "REGSAUDE",
            "MICR_REG",
            "DISTRSAN",
            "DISTRADM",
            "PF_PJ",
            "NIV_DEP",
            "COD_IR",
            "ESFERA_A",
            "ATIVIDAD",
            "TP_UNID",
            "TURNO_AT",
            "NIV_HIER",
            "TP_PREST",
            "ORGEXPED",
            "AV_ACRED",
            "AV_PNASS",
        ]
        for x in strip:
            df[x] = df[x].str.replace(",", "")
            df[x] = df[x].str.replace("¿", "")
            df[x] = df[x].str.rstrip("ª")
            df[x] = df[x].str.rstrip("º")
            df[x] = df[x].str.lstrip("0")
        
        def check_and_create_column(df: pd.DataFrame, col_name:str)-> pd.DataFrame:
                    """
                    Check if a column exists in a Pandas DataFrame. If it doesn't, create a new column with the given name
                    and fill it with NaN values. If it does exist, do nothing.
                    
                    Parameters:
                    df (Pandas DataFrame): The DataFrame to check.
                    col_name (str): The name of the column to check for or create.
                    
                    Returns:
                    Pandas DataFrame: The modified DataFrame.
                    """
                    if col_name not in df.columns:
                        df[col_name] = ''
                    return df
        
        #renomeia as colunas
        df.rename(columns = rename, inplace=True)
        print('renomeia')
        df = df[ordem_colunas]
        df = df.drop_duplicates()
        if 5 <= ano[i] <= 9:
            df.to_csv(
                "./output/ano=200{}/mes={}/sigla_uf={}/estabelecimento.csv".format(
                    ano[i], mes[i], uf[i]
                ),
                index=False,
            )
        else:
            df.to_csv(
                "./output/ano=20{}/mes={}/sigla_uf={}/estabelecimento.csv".format(
                    ano[i], mes[i], uf[i]
                ),
                index=False,
            )
    except Exception:
        print("Erro em ano{}-mes{}-uf{} em linha {}".format(ano[i], mes[i], uf[i], i))
