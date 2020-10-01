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
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(populacao AS INT64) populacao
from basedosdados-staging.br_populacao_IBGE_staging.populacao_municipios