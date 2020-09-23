/*
Query to publish table.

This is the place to fix types, merge with other tables or create new
support columns.

Any column defined here must exists at `table_config.yaml`.
*/
SELECT 
{% for column in columns -%}
{%- if not loop.last -%}
    {{ column }},
{% else -%}
    {{ column }}
{% endif -%}{% endfor -%}
from {{ project_id }}.{{ dataset_id }}_staging.{{ table_id }}