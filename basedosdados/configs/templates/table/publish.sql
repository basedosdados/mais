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
{% for column in columns|list + partition_columns|list -%}
{%- if not loop.last -%}
    SAFE_CAST({{ column }} AS STRING) {{ column }},
{% else -%}
    SAFE_CAST({{ column }} AS STRING) {{ column }}
{% endif -%}{% endfor -%}
from {{ project_id }}.{{ dataset_id }}_staging.{{ table_id }} as t
