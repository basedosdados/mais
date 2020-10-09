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
SAFE_CAST(PIB AS INT64) PIB,
SAFE_CAST(impostos_liquidos AS INT64) impostos_liquidos,
SAFE_CAST(VA AS INT64) VA,
SAFE_CAST(VA_agropecuaria AS INT64) VA_agropecuaria,
SAFE_CAST(VA_industria AS INT64) VA_industria,
SAFE_CAST(VA_servicos AS INT64) VA_servicos,
SAFE_CAST(VA_ADESPSS AS INT64) VA_ADESPSS
from basedosdados-staging.br_economia_IBGE_staging.municipio_PIB