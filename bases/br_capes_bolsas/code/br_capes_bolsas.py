################################################################################
# Paths + packages
################################################################################

# pylint: disable=C0114
# pylint: disable=C0103
# pylint: disable=C0301

from glob import glob
import os
import pandas as pd
import basedosdados as bd

path = "/home/crislane/Desktop/br_capes_bolsas/"
path_input = "/home/crislane/Desktop/br_capes_bolsas/input/"
path_output = "/home/crislane/Desktop/br_capes_bolsas/output/"

for ano_inicial in [*range(2005, 2020)]:
    for mes_inicial in [*range(1, 13)]:
        directory = (
            path_output
            + f"mobilidade_internacional/ano_inicial={ano_inicial}/mes_inicial={mes_inicial}"
        )
        if not os.path.exists(directory):
            os.makedirs(directory)

# lists + treatment

list_rename = {
    "AN_INICIO": "ano_inicial",
    "ME_INICIO": "mes_inicial",
    "AN_FIM": "ano_final",
    "ME_FIM": "mes_final",
    "ID_PROCESSO": "id_processo_concessao",
    "NR_DOCUMENTO": "cpf",
    "NM_BENEFICIARIO": "beneficiario",
    "NM_PROGRAMA": "programa_capes",
    "NM_PAIS_IES_ESTUDO": "pais_destino",
    "CD_MOEDA": "sigla_moeda",
    "NM_AREA_AVALIACAO": "area_avaliacao",
    "NM_AREA_CONHECIMENTO": "area_conhecimento",
    "NM_GRANDE_AREA": "grande_area_conhecimento",
    "NM_NIVEL": "nivel_ensino",
    "NM_UF_IES_ORIGEM": "uf_instituicao_origem",
    "NM_IES_ORIGEM_PRINCIPAL_DA": "instituicao_ensino_origem",
    "NM_IES_ESTUDO_PRINCIPAL": "instituicao_ensino_principal",
    "NM_IES_ESTUDO_PRINCIPAL_DA": "instituicao_ensino",
    "VL_REDUCAO_QUADRO_PERMANENTE": "deducao_mensalidade_programa_atracao_jovens",
    "VL_ADICIONAL_DEPENDENTE": "valor_adicional_pagos_doutorado_pleno_dependentes",
    "VL_AUX_DESLOCAMENTO": "valor_auxilio_deslocamento",
    "VL_AUX_DESLOCAMENTO_DEMANDA": "valor_auxilio_deslocamento_demanda",
    "VL_AUX_DESLOCAMENTO_PESQUISA": "valor_auxilio_deslocamento_pesquisa",
    "VL_AUX_DESLOCAMENTO_RETORNO_D": "valor_auxilio_deslocamento_retorno",
    "VL_DIF_AUX_INSTALACAO": "valor_auxilio_despesas_instalacao",
    "VL_AUX_INSTALACAO_DEPENDENTE": "valor_auxilio_instalacao_dependente",
    "VL_AUX_INSTALACAO": "valor_auxilio_instalacao",
    "VL_AUX_SEGURO_SAUDE_ANUAL": "valor_auxilio_seguro_saude_anual",
    "VL_AUX_SEGURO_SAUDE_CAPES_SET": "valor_auxilio_seguro_saude_capes_setec",
    "VL_AUX_SEGURO_SAUDE_DEMANDA": "valor_auxilio_seguro_saude_demanda",
    "VL_AUX_SEGURO_SAUDE_DEPENDENTE": "valor_auxilio_seguro_saude_dependente",
    "VL_AUX_SEGURO_SAUDE": "valor_auxilio_seguro_saude",
    "VL_AUX_MORADIA": "valor_auxilio_moradia",
    "VL_AUX_MATERIAL_DIDATICO": "valor_auxilio_material_didatico",
    "VL_BOLSA": "valor_recebido_bolsa",
    "VL_ADICIONAL_LOCALIDADE": "valor_recebido_adicional_localidade",
    "VL_AJUDA_CUSTO_CAPES_SETEC": "valor_recebido_ajuda_custo",
    "VL_AJUDA_CUSTO_MTUR": "valor_recebido_ajuda_custo_capes_mtur",
    "VL_AJUDA_CUSTO": "valor_recebido_ajuda_custo_capes_setec",
    "VL_TAXA_ESCOLAR_VALOR_P": "valor_recebido_custeio_taxas_escolares_menores",
    "VL_REEMBOLSO_TAXA_ESCOLAR": "valor_recebido_reembolso_taxas_escolares",
    "VL_TAXA_ESCOLAR": "valor_recebido_custeio_taxas_escolares",
    "VL_DIF_DEPENDENTES": "valor_recebido_despesas_adicional_dependente",
    "VL_DIF_AUX_DESLOCAMENTO": "valor_recebido_despesas_auxilio_deslocamento",
    "VL_OUTROS_CREDITOS": "valor_recebido_despesas_extraordinarias",
    "VL_DIF_MENSALIDADE": "valor_recebido_despesas_mensalidade",
    "VL_DIF_SEGURO_SAUDE": "valor_recebido_despesas_seguro_saude",
    "VL_SEGURO_SAUDE": "valor_recebido_seguro_saude",
    "VL_DIARIAS": "valor_recebido_diarias",
    "VL_ESCOLA_ALTOS_ESTUDOS": "valor_recebido_escola_altos_estudos",
    "VL_MENSALIDADE_LIC_MATERNIDADE": "valor_recebido_licenca_maternidade",
    "VL_MENSALIDADE": "valor_recebido_mensalidade",
    "VL_MENSALIDADES_AGENDADAS": "valor_recebido_mensalidade_agendadas",
    "VL_MENSALIDADE_DEMANDA": "valor_recebido_mensalidade_demanda",
    "VL_OUTROS_DEBITOS": "valor_recebido_outros_debitos",
    "VL_REEMBOLSO_PASSAGEM_AEREA": "valor_recebido_passagem_aerea",
    "VL_CAPITAL": "valor_recebido_capital",
    "VL_TOTAL_RECEBIDO_MOEDA": "valor_recebido_total",
}

list_ordem = [
    "ano_inicial",
    "mes_inicial",
    "ano_final",
    "mes_final",
    "id_processo_concessao",
    "cpf",
    "beneficiario",
    "programa_capes",
    "pais_destino",
    "sigla_moeda",
    "area_avaliacao",
    "area_conhecimento",
    "grande_area_conhecimento",
    "nivel_ensino",
    "uf_instituicao_origem",
    "instituicao_ensino_origem",
    "instituicao_ensino_principal",
    "instituicao_ensino",
    "deducao_mensalidade_programa_atracao_jovens",
    "valor_adicional_pagos_doutorado_pleno_dependentes",
    "valor_auxilio_deslocamento",
    "valor_auxilio_deslocamento_demanda",
    "valor_auxilio_deslocamento_pesquisa",
    "valor_auxilio_deslocamento_retorno",
    "valor_auxilio_despesas_instalacao",
    "valor_auxilio_instalacao_dependente",
    "valor_auxilio_instalacao",
    "valor_auxilio_seguro_saude_anual",
    "valor_auxilio_seguro_saude_capes_setec",
    "valor_auxilio_seguro_saude_demanda",
    "valor_auxilio_seguro_saude_dependente",
    "valor_auxilio_seguro_saude",
    "valor_auxilio_moradia",
    "valor_auxilio_material_didatico",
    "valor_recebido_bolsa",
    "valor_recebido_adicional_localidade",
    "valor_recebido_ajuda_custo",
    "valor_recebido_ajuda_custo_capes_mtur",
    "valor_recebido_ajuda_custo_capes_setec",
    "valor_recebido_custeio_taxas_escolares_menores",
    "valor_recebido_reembolso_taxas_escolares",
    "valor_recebido_custeio_taxas_escolares",
    "valor_recebido_despesas_adicional_dependente",
    "valor_recebido_despesas_auxilio_deslocamento",
    "valor_recebido_despesas_extraordinarias",
    "valor_recebido_despesas_mensalidade",
    "valor_recebido_despesas_seguro_saude",
    "valor_recebido_seguro_saude",
    "valor_recebido_diarias",
    "valor_recebido_escola_altos_estudos",
    "valor_recebido_licenca_maternidade",
    "valor_recebido_mensalidade",
    "valor_recebido_mensalidade_agendadas",
    "valor_recebido_mensalidade_demanda",
    "valor_recebido_outros_debitos",
    "valor_recebido_passagem_aerea",
    "valor_recebido_capital",
    "valor_recebido_total",
]

files = sorted(glob(path_input + "mi*.csv"))
df = pd.concat((pd.read_csv(x) for x in files), ignore_index=True).rename(
    columns=list_rename
)[list_ordem]

for ano_inicial in [*range(2005, 2020)]:
    for mes_inicial in [*range(1, 13)]:
        print(f"Particionando {ano_inicial}-{mes_inicial}")
        df_partition = df[df["ano_inicial"] == ano_inicial].copy()
        df_partition = df_partition[df_partition["mes_inicial"] == mes_inicial]
        df_partition.drop(["ano_inicial", "mes_inicial"], axis=1, inplace=True)
        partition_path = (
            path_output
            + f"mobilidade_internacional/ano_inicial={ano_inicial}/mes_inicial={mes_inicial}/mobile_internacional.csv"
        )
        df_partition.to_csv(partition_path, index=False, encoding="utf-8", na_rep="")


tb = bd.Table(dataset_id="br_capes_bolsas", table_id="mobilidade_internacional")

tb.create(
    path=path_output,
    columns_config_url_or_path="https://docs.google.com/spreadsheets/d/1QBhpilU2ZrSutPfhFtI_rePmzKDhKSuoNSRUULufDYc/edit#gid=1111684170",
    if_storage_data_exists="replace",
    if_table_config_exists="replace",
    if_table_exists="replace",
)
