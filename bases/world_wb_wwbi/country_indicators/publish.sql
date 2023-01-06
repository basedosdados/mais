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

CREATE VIEW basedosdados-dev.world_wb_wwbi.country_indicators AS
SELECT 
SAFE_CAST(year AS INT64) year,
SAFE_CAST(country_name AS STRING) country_name,
SAFE_CAST(country_code AS STRING) country_code,
SAFE_CAST(indicator AS STRING) indicator,
SAFE_CAST(score AS FLOAT64) score
FROM basedosdados-dev.world_wb_wwbi_staging.country_indicators AS t