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
SAFE_CAST(id_estado AS INT64) id_estado,
SAFE_CAST(estado_abrev AS STRING) estado_abrev,
SAFE_CAST(estado AS STRING) estado,
SAFE_CAST(regiao AS STRING) regiao
from basedosdados-staging.br_suporte_staging.diretorio_estados