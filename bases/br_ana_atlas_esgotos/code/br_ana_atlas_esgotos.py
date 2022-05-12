################################################################
# Pacotes + paths
################################################################

import pandas as pd

path        = "/content/drive/MyDrive/br_ana_atlas_esgotos/"
path_input  = path + "input/"
path_output = path + "output/"

################################################################
# Tratamento + output
################################################################

list_rename = {
    "Código IBGE": "id_municipio",
    "UF": "sigla_uf",
    "População Urbana (2013)": "populacao_urbana_2013",
    "População Urbana (2035)": "populacao_urbana_2035",
    "Prestador de Serviço de Esgotamento Sanitário": "prestador_servico_esgotamento_sanitario",
    "Sigla do Prestador": "sigla_prestador",
    "Índice sem atendimento - sem Coleta e sem Tratamento (2013)": "indice_sem_atendimento_sem_coleta_sem_tratamento",
    "Índice de Atendimento por Solução Individual (2013)": "indice_atendimento_solucao_individual",
    "Índice de Atendimento com Coleta e sem Tratamento (2013)": "indice_atendimento_com_coleta_sem_tratamento",
    "Índice de Atendimento com Coleta e com Tratamento (2013)": "indice_atendimento_com_coleta_com_tratamento",
    "Vazão - sem Coleta e sem Tratamento (L/s) (2013)": "vazao_sem_coleta_sem_tratamento",
    "Vazão - Solução Individual (L/s) (2013)": "vazao_solucao_individual",
    "Vazão - com Coleta e sem Tratamento (L/s) (2013)": "vazao_com_coleta_sem_tratamento",
    "Vazão - com Coleta e com Tratamento (L/s) (2013)": "vazao_com_coleta_com_tratamento",
    "Vazão Total em 2013 (L/s)": "vazao_total",
    "Parcela da Carga Gerada em 2013 sem Coleta e sem Tratamento (Kg DBO/dia)": "carga_gerada_sem_coleta_sem_tratamento",
    "Parcela da Carga Gerada em 2013 Encaminhada para Solução Individual (Kg DBO/dia)": "carga_gerada_encaminhada_solucao_individual",
    "Parcela da Carga Gerada em 2013 com Coleta e sem Tratamento (Kg DBO/dia)": "carga_gerada_com_coleta_sem_tratamento",
    "Parcela da Carga Gerada em 2013 com Coleta e com Tratamento (Kg DBO/dia)": "carga_gerada_com_coleta_com_tratamento",
    "Carga Gerada Total em 2013 (Kg DBO/dia)": "carga_gerada_total",
    "Parcela da Carga Lançada em 2013 sem Coleta e sem Tratamento (Kg DBO/dia)": "carga_lancada_sem_coleta_sem_tratamento",
    "Parcela da Carga Lançada em 2013 proveniente de Solução Individual (Kg DBO/dia)": "carga_lancada_proveniente_solucao_individual",
    "Parcela da Carga Lançada em 2013 com Coleta e sem Tratamento (Kg DBO/dia)": "carga_lancada_com_coleta_sem_tratamento",
    "Parcela da Carga Lançada em 2013 com Coleta e com Tratamento (Kg DBO/dia)": "carga_lancada_com_coleta_com_tratamento",
    "Carga Lançada Total em 2013 (Kg DBO/dia)": "carga_lancada_total",
    "Índice de Atendimento com ETEs Avaliado (2035)": "indice_atendimento_etes_2035",
    "Índice de Atendimento Solução Individual Avaliado (2035)": "indice_atendimento_solucao_individual_2035",
    "Carga Gerada Total em 2035 (Kg DBO/dia)": "carga_gerada_total_2035",
    "Carga Afluente ETE em 2035 (KgDBOd 2035": "carga_afluente_ete_2035",
    "Carga Efluente ETE em 2035 (KgDBOd 2035": "carga_efluente_ete_2035",
    "Carga Afluente Solução Individual em 2035 (KgDBOd 2035": "carga_afluente_solucao_individual_2035",
    "Carga Efluente Solução Individual em 2035 (KgDBOd 2035": "carga_efluente_solucao_individual_2035",
    "População Atendida Estimada em 2035": "populacao_atendida_2035",
    "Investimentos em Coleta (R$)": "investimento_coleta",
    "Investimentos em Tratamento (R$)": "investimento_tratamento",
    "Investimentos em Coleta e Tratamento (R$)": "investimento_coleta_tratatamento",
    "Necessidade de Remoção de DBO": "necessidade_remocao_dbo",
    "Tipologia de Solução": "tipologia_solucao",
    "Atenção ao Fósforo": "atencao_fosforo",
    "Atenção ao Nitrogênio": "atencao_nitrogenio",
}

df = pd.read_excel(path_input + "municipio_original.xlsx")
df = df.drop(["Município"], axis=1)
df = df.rename(columns=list_rename)
df.head()

df.to_csv(path_output + "municipio.csv", index=False, encoding="utf-8", na_rep="")
