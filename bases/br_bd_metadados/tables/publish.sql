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

CREATE VIEW basedosdados-dev.br_bd_metadados.tables AS
SELECT 
SAFE_CAST(dataset_id AS STRING) dataset_id,
SAFE_CAST(dataset_name AS STRING) dataset_name,
SAFE_CAST(id AS STRING) id,
SAFE_CAST(name AS STRING) name,
SAFE_CAST(date_created AS DATE) date_created,
SAFE_CAST(date_last_modified AS DATE) date_last_modified,
SAFE_CAST(spatial_coverage AS STRING) spatial_coverage,
SAFE_CAST(temporal_coverage AS STRING) temporal_coverage,
SAFE_CAST(update_frequency AS STRING) update_frequency,
SAFE_CAST(observation_level AS STRING) observation_level,
SAFE_CAST(number_rows AS INT64) number_rows,
SAFE_CAST(number_columns AS INT64) number_columns,
SAFE_CAST(outdated AS INT64) outdated,
SAFE_CAST(metadata AS DATE) metadata,
SAFE_CAST(data AS DATE) data,
SAFE_CAST(release AS DATE) release,
SAFE_CAST(published_by AS STRING) published_by,
SAFE_CAST(cleaned_by AS STRING) cleaned_by,
SAFE_CAST(missing_metadata AS STRING) missing_metadata
FROM basedosdados-dev.br_bd_metadados_staging.tables AS t