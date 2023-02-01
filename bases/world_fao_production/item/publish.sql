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

CREATE VIEW basedosdados-dev.world_fao_production.item AS
SELECT 
SAFE_CAST(item_id AS STRING) item_id,
SAFE_CAST(item AS STRING) item,
SAFE_CAST(item_description AS STRING) item_description,
SAFE_CAST(hs07_id AS STRING) hs07_id,
SAFE_CAST(hs12_id AS STRING) hs12_id,
SAFE_CAST(cpc_id AS STRING) cpc_id
FROM basedosdados-dev.world_fao_production_staging.item AS t