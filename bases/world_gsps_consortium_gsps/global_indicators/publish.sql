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

CREATE VIEW basedosdados-dev.world_gsps_consortium_gsps.global_indicators AS
SELECT 
SAFE_CAST(year AS INT64) year,
SAFE_CAST(country AS STRING) country,
SAFE_CAST(institutions_number AS INT64) institutions_number,
SAFE_CAST(respondents AS INT64) respondents,
SAFE_CAST(response_rate AS STRING) response_rate,
SAFE_CAST(section_org AS STRING) section_org,
SAFE_CAST(topic AS STRING) topic,
SAFE_CAST(indicator AS STRING) indicator,
SAFE_CAST(`group` AS STRING) `group`,
SAFE_CAST(category AS STRING) category,
SAFE_CAST(mode AS STRING) mode,
SAFE_CAST(question_text AS STRING) question_text,
SAFE_CAST(harmonize AS STRING) harmonize,
SAFE_CAST(scale AS STRING) scale,
SAFE_CAST(mean AS FLOAT64) mean,
SAFE_CAST(lower_ci AS FLOAT64) lower_ci,
SAFE_CAST(upper_ci AS FLOAT64) upper_ci,
SAFE_CAST(source AS STRING) source
FROM basedosdados-dev.world_gsps_consortium_gsps_staging.global_indicators AS t