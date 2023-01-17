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

CREATE VIEW basedosdados-dev.mundo_bm_wdi.indicators AS
SELECT 
SAFE_CAST(indicator_id AS STRING) indicator_id,
SAFE_CAST(topic AS STRING) topic,
SAFE_CAST(short_definition AS STRING) short_definition,
SAFE_CAST(long_definition AS STRING) long_definition,
SAFE_CAST(measurement_unit AS STRING) measurement_unit,
SAFE_CAST(periodicity AS STRING) periodicity,
SAFE_CAST(base_period AS STRING) base_period,
SAFE_CAST(other_notes AS STRING) other_notes,
SAFE_CAST(aggregation_method AS STRING) aggregation_method,
SAFE_CAST(limitations_exceptions AS STRING) limitations_exceptions,
SAFE_CAST(notes_from_original_source AS STRING) notes_from_original_source,
SAFE_CAST(general_comments AS STRING) general_comments,
SAFE_CAST(source AS STRING) source,
SAFE_CAST(statistical_concept_methodology AS STRING) statistical_concept_methodology,
SAFE_CAST(development_relevance AS STRING) development_relevance,
SAFE_CAST(related_source_links AS STRING) related_source_links,
SAFE_CAST(other_web_links AS STRING) other_web_links,
SAFE_CAST(related_indicators AS STRING) related_indicators,
SAFE_CAST(license_type AS STRING) license_type
FROM basedosdados-dev.mundo_bm_wdi_staging.indicators AS t