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

CREATE VIEW basedosdados-dev.br_inep_indicadores_educacionais.brasil_taxas_transicao AS
SELECT 
SAFE_CAST(ano_de AS INT64) ano_de,
SAFE_CAST(ano_para AS INT64) ano_para,
SAFE_CAST(localizacao AS STRING) localizacao,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(taxa_promocao_ef AS FLOAT64) taxa_promocao_ef,
SAFE_CAST(taxa_promocao_ef_anos_iniciais AS FLOAT64) taxa_promocao_ef_anos_iniciais,
SAFE_CAST(taxa_promocao_ef_anos_finais AS FLOAT64) taxa_promocao_ef_anos_finais,
SAFE_CAST(taxa_promocao_ef_1_ano AS FLOAT64) taxa_promocao_ef_1_ano,
SAFE_CAST(taxa_promocao_ef_2_ano AS FLOAT64) taxa_promocao_ef_2_ano,
SAFE_CAST(taxa_promocao_ef_3_ano AS FLOAT64) taxa_promocao_ef_3_ano,
SAFE_CAST(taxa_promocao_ef_4_ano AS FLOAT64) taxa_promocao_ef_4_ano,
SAFE_CAST(taxa_promocao_ef_5_ano AS FLOAT64) taxa_promocao_ef_5_ano,
SAFE_CAST(taxa_promocao_ef_6_ano AS FLOAT64) taxa_promocao_ef_6_ano,
SAFE_CAST(taxa_promocao_ef_7_ano AS FLOAT64) taxa_promocao_ef_7_ano,
SAFE_CAST(taxa_promocao_ef_8_ano AS FLOAT64) taxa_promocao_ef_8_ano,
SAFE_CAST(taxa_promocao_ef_9_ano AS FLOAT64) taxa_promocao_ef_9_ano,
SAFE_CAST(taxa_promocao_em AS FLOAT64) taxa_promocao_em,
SAFE_CAST(taxa_promocao_em_1_ano AS FLOAT64) taxa_promocao_em_1_ano,
SAFE_CAST(taxa_promocao_em_2_ano AS FLOAT64) taxa_promocao_em_2_ano,
SAFE_CAST(taxa_promocao_em_3_ano AS FLOAT64) taxa_promocao_em_3_ano,
SAFE_CAST(taxa_repetencia_ef AS FLOAT64) taxa_repetencia_ef,
SAFE_CAST(taxa_repetencia_ef_anos_iniciais AS FLOAT64) taxa_repetencia_ef_anos_iniciais,
SAFE_CAST(taxa_repetencia_ef_anos_finais AS FLOAT64) taxa_repetencia_ef_anos_finais,
SAFE_CAST(taxa_repetencia_ef_1_ano AS FLOAT64) taxa_repetencia_ef_1_ano,
SAFE_CAST(taxa_repetencia_ef_2_ano AS FLOAT64) taxa_repetencia_ef_2_ano,
SAFE_CAST(taxa_repetencia_ef_3_ano AS FLOAT64) taxa_repetencia_ef_3_ano,
SAFE_CAST(taxa_repetencia_ef_4_ano AS FLOAT64) taxa_repetencia_ef_4_ano,
SAFE_CAST(taxa_repetencia_ef_5_ano AS FLOAT64) taxa_repetencia_ef_5_ano,
SAFE_CAST(taxa_repetencia_ef_6_ano AS FLOAT64) taxa_repetencia_ef_6_ano,
SAFE_CAST(taxa_repetencia_ef_7_ano AS FLOAT64) taxa_repetencia_ef_7_ano,
SAFE_CAST(taxa_repetencia_ef_8_ano AS FLOAT64) taxa_repetencia_ef_8_ano,
SAFE_CAST(taxa_repetencia_ef_9_ano AS FLOAT64) taxa_repetencia_ef_9_ano,
SAFE_CAST(taxa_repetencia_em AS FLOAT64) taxa_repetencia_em,
SAFE_CAST(taxa_repetencia_em_1_ano AS FLOAT64) taxa_repetencia_em_1_ano,
SAFE_CAST(taxa_repetencia_em_2_ano AS FLOAT64) taxa_repetencia_em_2_ano,
SAFE_CAST(taxa_repetencia_em_3_ano AS FLOAT64) taxa_repetencia_em_3_ano,
SAFE_CAST(taxa_evasao_ef AS FLOAT64) taxa_evasao_ef,
SAFE_CAST(taxa_evasao_ef_anos_iniciais AS FLOAT64) taxa_evasao_ef_anos_iniciais,
SAFE_CAST(taxa_evasao_ef_anos_finais AS FLOAT64) taxa_evasao_ef_anos_finais,
SAFE_CAST(taxa_evasao_ef_1_ano AS FLOAT64) taxa_evasao_ef_1_ano,
SAFE_CAST(taxa_evasao_ef_2_ano AS FLOAT64) taxa_evasao_ef_2_ano,
SAFE_CAST(taxa_evasao_ef_3_ano AS FLOAT64) taxa_evasao_ef_3_ano,
SAFE_CAST(taxa_evasao_ef_4_ano AS FLOAT64) taxa_evasao_ef_4_ano,
SAFE_CAST(taxa_evasao_ef_5_ano AS FLOAT64) taxa_evasao_ef_5_ano,
SAFE_CAST(taxa_evasao_ef_6_ano AS FLOAT64) taxa_evasao_ef_6_ano,
SAFE_CAST(taxa_evasao_ef_7_ano AS FLOAT64) taxa_evasao_ef_7_ano,
SAFE_CAST(taxa_evasao_ef_8_ano AS FLOAT64) taxa_evasao_ef_8_ano,
SAFE_CAST(taxa_evasao_ef_9_ano AS FLOAT64) taxa_evasao_ef_9_ano,
SAFE_CAST(taxa_evasao_em AS FLOAT64) taxa_evasao_em,
SAFE_CAST(taxa_evasao_em_1_ano AS FLOAT64) taxa_evasao_em_1_ano,
SAFE_CAST(taxa_evasao_em_2_ano AS FLOAT64) taxa_evasao_em_2_ano,
SAFE_CAST(taxa_evasao_em_3_ano AS FLOAT64) taxa_evasao_em_3_ano,
SAFE_CAST(taxa_migracao_eja_ef AS FLOAT64) taxa_migracao_eja_ef,
SAFE_CAST(taxa_migracao_eja_ef_anos_iniciais AS FLOAT64) taxa_migracao_eja_ef_anos_iniciais,
SAFE_CAST(taxa_migracao_eja_ef_anos_finais AS FLOAT64) taxa_migracao_eja_ef_anos_finais,
SAFE_CAST(taxa_migracao_eja_ef_1_ano AS FLOAT64) taxa_migracao_eja_ef_1_ano,
SAFE_CAST(taxa_migracao_eja_ef_2_ano AS FLOAT64) taxa_migracao_eja_ef_2_ano,
SAFE_CAST(taxa_migracao_eja_ef_3_ano AS FLOAT64) taxa_migracao_eja_ef_3_ano,
SAFE_CAST(taxa_migracao_eja_ef_4_ano AS FLOAT64) taxa_migracao_eja_ef_4_ano,
SAFE_CAST(taxa_migracao_eja_ef_5_ano AS FLOAT64) taxa_migracao_eja_ef_5_ano,
SAFE_CAST(taxa_migracao_eja_ef_6_ano AS FLOAT64) taxa_migracao_eja_ef_6_ano,
SAFE_CAST(taxa_migracao_eja_ef_7_ano AS FLOAT64) taxa_migracao_eja_ef_7_ano,
SAFE_CAST(taxa_migracao_eja_ef_8_ano AS FLOAT64) taxa_migracao_eja_ef_8_ano,
SAFE_CAST(taxa_migracao_eja_ef_9_ano AS FLOAT64) taxa_migracao_eja_ef_9_ano,
SAFE_CAST(taxa_migracao_eja_em AS FLOAT64) taxa_migracao_eja_em,
SAFE_CAST(taxa_migracao_eja_em_1_ano AS FLOAT64) taxa_migracao_eja_em_1_ano,
SAFE_CAST(taxa_migracao_eja_em_2_ano AS FLOAT64) taxa_migracao_eja_em_2_ano,
SAFE_CAST(taxa_migracao_eja_em_3_ano AS FLOAT64) taxa_migracao_eja_em_3_ano
FROM basedosdados-dev.br_inep_indicadores_educacionais_staging.brasil_taxas_transicao AS t