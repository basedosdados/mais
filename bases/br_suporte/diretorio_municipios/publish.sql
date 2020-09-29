/*
Query to publish table.

This is the place to fix types, merge with other tables or create new
support columns.

Any column defined here must exists at `table_config.yaml`.

TYPES:

To change types, just replace STRING to a valid type.
Ex:

`SAFE_CAST(column_name AS NUMERIC) column_name`

Available types: https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types

*/
SELECT 
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(id_municipio_6 AS INT64) id_municipio_6,
SAFE_CAST(id_municipio_TSE AS INT64) id_municipio_TSE,
SAFE_CAST(id_municipio_RF AS INT64) id_municipio_RF,
SAFE_CAST(id_municipio_BCB AS INT64) id_municipio_BCB,
SAFE_CAST(municipio AS STRING) municipio,
SAFE_CAST(capital_estado AS INT64) capital_estado,
SAFE_CAST(id_comarca AS INT64) id_comarca,
SAFE_CAST(id_regiao_saude AS INT64) id_regiao_saude,
SAFE_CAST(regiao_saude AS STRING) regiao_saude,
SAFE_CAST(id_regiao_imediata AS INT64) id_regiao_imediata,
SAFE_CAST(regiao_imediata AS STRING) regiao_imediata,
SAFE_CAST(id_regiao_intermediaria AS INT64) id_regiao_intermediaria,
SAFE_CAST(regiao_intermediaria AS STRING) regiao_intermediaria,
SAFE_CAST(id_microrregiao AS INT64) id_microrregiao,
SAFE_CAST(microrregiao AS STRING) microrregiao,
SAFE_CAST(id_mesorregiao AS INT64) id_mesorregiao,
SAFE_CAST(mesorregiao AS STRING) mesorregiao,
SAFE_CAST(id_estado AS INT64) id_estado,
SAFE_CAST(estado_abrev AS STRING) estado_abrev,
SAFE_CAST(estado AS STRING) estado,
SAFE_CAST(regiao AS STRING) regiao,
SAFE_CAST(existia_1991 AS INT64) existia_1991,
SAFE_CAST(existia_2000 AS INT64) existia_2000,
SAFE_CAST(existia_2010 AS INT64) existia_2010
from basedosdados-staging.br_suporte_staging.diretorio_municipios