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

CREATE VIEW basedosdados-dev.world_fao_production.production_indices AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(fao_area_id AS STRING) fao_area_id,
SAFE_CAST(fao_area AS STRING) fao_area,
SAFE_CAST(item_id AS STRING) item_id,
SAFE_CAST(item AS STRING) item,
SAFE_CAST(element_id AS STRING) element_id,
SAFE_CAST(element AS STRING) element,
SAFE_CAST(unit_id AS STRING) unit_id,
SAFE_CAST(value AS FLOAT64) value,
SAFE_CAST(flag_id AS STRING) flag_id
FROM basedosdados-dev.world_fao_production_staging.production_indices AS t