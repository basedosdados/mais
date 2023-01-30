/*
Query para publicar a tabela.

Esse é o lugar para:
    - modificar nomes, ordem e tipos de colunas
    - dar join com outras tabelas
    - criar colunas extras (e.g. logs, proporções, etc.)

Qualquer coluna definida aqui deve também existir em `table_config.yaml`.

# Além disso, sinta-se à vontade para alterar alguns nomes obscuros
# para algo um pouco mais explícito.

TIPOS:
    - Para modificar tipos de colunas, basta substituir STRING por outro tipo válido.
    - Exemplo: `SAFE_CAST(column_name AS NUMERIC) column_name`
    - Mais detalhes: https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types
*/

CREATE VIEW basedosdados-dev.br_ipea_avs.municipio AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(raca_cor AS STRING) raca_cor,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(localizacao AS STRING) localizacao,
SAFE_CAST(ivs AS FLOAT64) ivs,
SAFE_CAST(ivs_infraestrutura_urbana AS FLOAT64) ivs_infraestrutura_urbana,
SAFE_CAST(ivs_capital_humano AS FLOAT64) ivs_capital_humano,
SAFE_CAST(ivs_renda_trabalho AS FLOAT64) ivs_renda_trabalho,
SAFE_CAST(idhm AS FLOAT64) idhm,
SAFE_CAST(idhm_l AS FLOAT64) idhm_l,
SAFE_CAST(idhm_e AS FLOAT64) idhm_e,
SAFE_CAST(idhm_r AS FLOAT64) idhm_r,
SAFE_CAST(idhm_subescolaridade AS FLOAT64) idhm_subescolaridade,
SAFE_CAST(idhm_subfrequencia AS FLOAT64) idhm_subfrequencia,
SAFE_CAST(prosperidade_social AS STRING) prosperidade_social,
SAFE_CAST(proporcao_vulnerabilidade_socioeconomica AS FLOAT64) proporcao_vulnerabilidade_socioeconomica,
SAFE_CAST(propocao_energia_eletrica AS FLOAT64) propocao_energia_eletrica,
SAFE_CAST(proporcao_domicilio_densidade AS FLOAT64) proporcao_domicilio_densidade,
SAFE_CAST(proporcao_sem_agua_esgoto AS FLOAT64) proporcao_sem_agua_esgoto,
SAFE_CAST(proporcao_sem_coleta AS FLOAT64) proporcao_sem_coleta,
SAFE_CAST(renda_per_capita AS FLOAT64) renda_per_capita,
SAFE_CAST(renda_media_18_mais AS FLOAT64) renda_media_18_mais,
SAFE_CAST(proporcao_sem_renda_18_mais AS FLOAT64) proporcao_sem_renda_18_mais,
SAFE_CAST(renda_trabalho AS FLOAT64) renda_trabalho,
SAFE_CAST(renda_per_capita_vulneravel AS FLOAT64) renda_per_capita_vulneravel,
SAFE_CAST(proporcao_vulneravel AS FLOAT64) proporcao_vulneravel,
SAFE_CAST(vulneravel_15_24 AS STRING) vulneravel_15_24,
SAFE_CAST(proporcao_vulneravel_dependente_idoso AS FLOAT64) proporcao_vulneravel_dependente_idoso,
SAFE_CAST(populacao_vulneravel_e_idoso AS INT64) populacao_vulneravel_e_idoso,
SAFE_CAST(razao_dependencia AS FLOAT64) razao_dependencia,
SAFE_CAST(fecundidade_total AS FLOAT64) fecundidade_total,
SAFE_CAST(taxa_envelhecimento AS FLOAT64) taxa_envelhecimento,
SAFE_CAST(mortalidade_1_menos AS FLOAT64) mortalidade_1_menos,
SAFE_CAST(proporcao_mortalidade_5_menos AS FLOAT64) proporcao_mortalidade_5_menos,
SAFE_CAST(proporcao_crianca_fora_escola_0_5 AS FLOAT64) proporcao_crianca_fora_escola_0_5,
SAFE_CAST(proporcao_escola_5_6 AS FLOAT64) proporcao_escola_5_6,
SAFE_CAST(proporcao_crianca_fora_escola_6_14 AS FLOAT64) proporcao_crianca_fora_escola_6_14,
SAFE_CAST(proporcao_maternidade_10_17 AS FLOAT64) proporcao_maternidade_10_17,
SAFE_CAST(maternidade_crianca_15_menos AS INT64) maternidade_crianca_15_menos,
SAFE_CAST(proporcao_maternidade_fundamental_incompleto_crianca_15_menos AS FLOAT64) proporcao_maternidade_fundamental_incompleto_crianca_15_menos,
SAFE_CAST(proporcao_analfabetismo_15_mais AS FLOAT64) proporcao_analfabetismo_15_mais,
SAFE_CAST(proporcao_analfabetismo_18_mais AS FLOAT64) proporcao_analfabetismo_18_mais,
SAFE_CAST(proporcao_analfabetismo_25_mais AS FLOAT64) proporcao_analfabetismo_25_mais,
SAFE_CAST(proporcao_responsavel_fundamental_incompleto AS FLOAT64) proporcao_responsavel_fundamental_incompleto,
SAFE_CAST(proporcao_anos_finais_11_13 AS FLOAT64) proporcao_anos_finais_11_13,
SAFE_CAST(proporcao_fundamental_completo_15_17 AS FLOAT64) proporcao_fundamental_completo_15_17,
SAFE_CAST(proporcao_fundamental_completo_18_mais AS FLOAT64) proporcao_fundamental_completo_18_mais,
SAFE_CAST(proporcao_medio_completo_18_20 AS FLOAT64) proporcao_medio_completo_18_20,
SAFE_CAST(populacao_ocupada_trabalho AS INT64) populacao_ocupada_trabalho,
SAFE_CAST(proporcao_ocupado_fundamental_18_mais AS FLOAT64) proporcao_ocupado_fundamental_18_mais,
SAFE_CAST(proporcao_ocupado_medio_18_mais AS FLOAT64) proporcao_ocupado_medio_18_mais,
SAFE_CAST(proporcao_ocupado_superior_18_mais AS FLOAT64) proporcao_ocupado_superior_18_mais,
SAFE_CAST(proporcao_desocupado_15_24 AS FLOAT64) proporcao_desocupado_15_24,
SAFE_CAST(proporcao_desocupado_18_mais AS FLOAT64) proporcao_desocupado_18_mais,
SAFE_CAST(proporcao_ocupados_informal_18_mais AS FLOAT64) proporcao_ocupados_informal_18_mais,
SAFE_CAST(proporcao_carteira_18_mais AS FLOAT64) proporcao_carteira_18_mais,
SAFE_CAST(proporcao_sem_carteira_18_mais AS FLOAT64) proporcao_sem_carteira_18_mais,
SAFE_CAST(proporcao_setor_publico_18_mais AS FLOAT64) proporcao_setor_publico_18_mais,
SAFE_CAST(proporcao_empreendedor_18_mais AS FLOAT64) proporcao_empreendedor_18_mais,
SAFE_CAST(proporcao_empregador_18_mais AS FLOAT64) proporcao_empregador_18_mais,
SAFE_CAST(proporcao_mercado_formal_18_mais AS FLOAT64) proporcao_mercado_formal_18_mais,
SAFE_CAST(proporcao_atividade_10_14 AS FLOAT64) proporcao_atividade_10_14,
SAFE_CAST(pea_10_mais AS INT64) pea_10_mais,
SAFE_CAST(pea_10_14 AS INT64) pea_10_14,
SAFE_CAST(pea_15_17 AS INT64) pea_15_17,
SAFE_CAST(pea_18_mais AS INT64) pea_18_mais,
SAFE_CAST(expectativa_vida AS FLOAT64) expectativa_vida,
SAFE_CAST(indice_gini AS FLOAT64) indice_gini,
SAFE_CAST(populacao_0_1 AS INT64) populacao_0_1,
SAFE_CAST(populacao_1_3 AS INT64) populacao_1_3,
SAFE_CAST(populacao_4 AS INT64) populacao_4,
SAFE_CAST(populacao_5 AS INT64) populacao_5,
SAFE_CAST(populacao_6 AS INT64) populacao_6,
SAFE_CAST(populacao_6_10 AS INT64) populacao_6_10,
SAFE_CAST(populacao_6_17 AS INT64) populacao_6_17,
SAFE_CAST(populacao_11_13 AS INT64) populacao_11_13,
SAFE_CAST(populacao_11_14 AS INT64) populacao_11_14,
SAFE_CAST(populacao_12_14 AS INT64) populacao_12_14,
SAFE_CAST(populacao_15_mais AS INT64) populacao_15_mais,
SAFE_CAST(populacao_15_17 AS INT64) populacao_15_17,
SAFE_CAST(populacao_15_24 AS INT64) populacao_15_24,
SAFE_CAST(populacao_16_18 AS INT64) populacao_16_18,
SAFE_CAST(populacao_18_mais AS INT64) populacao_18_mais,
SAFE_CAST(populacao_18_20 AS INT64) populacao_18_20,
SAFE_CAST(populacao_18_24 AS INT64) populacao_18_24,
SAFE_CAST(populacao_19_21 AS INT64) populacao_19_21,
SAFE_CAST(populacao_25_mais AS INT64) populacao_25_mais,
SAFE_CAST(populacao_65_mais AS INT64) populacao_65_mais
FROM basedosdados-dev.br_ipea_avs_staging.municipio AS t