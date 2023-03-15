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

CREATE VIEW basedosdados-dev.br_bd_metadados.columns AS
SELECT 
SAFE_CAST(table_id AS STRING) table_id,
SAFE_CAST(name AS STRING) name,
SAFE_CAST(bigquery_type AS STRING) bigquery_type,
SAFE_CAST(description AS STRING) description,
SAFE_CAST(temporal_coverage AS STRING) temporal_coverage,
SAFE_CAST(covered_by_dictionary AS STRING) covered_by_dictionary,
SAFE_CAST(directory_column AS STRING) directory_column,
SAFE_CAST(measurement_unit AS STRING) measurement_unit,
SAFE_CAST(has_sensitive_data AS STRING) has_sensitive_data,
SAFE_CAST(observations AS STRING) observations,
SAFE_CAST(is_in_staging AS STRING) is_in_staging,
SAFE_CAST(is_partition AS STRING) is_partition
FROM basedosdados-dev.br_bd_metadados_staging.columns AS t