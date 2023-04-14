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

CREATE VIEW basedosdados-dev.world_oecd_pisa.dictionary AS
SELECT 
SAFE_CAST(table_id AS STRING) table_id,
SAFE_CAST(column_name AS STRING) column_name,
SAFE_CAST(key AS STRING) key,
SAFE_CAST(temporal_coverage AS STRING) temporal_coverage,
SAFE_CAST(value AS STRING) value
FROM basedosdados-dev.world_oecd_pisa_staging.dictionary AS t