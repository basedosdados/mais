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
{% set project = project_id_prod %}
CREATE VIEW {{ project }}.{{ dataset_id }}.{{ table_id }} AS
SELECT 
{% for column in columns|list + partition_columns|list -%}
{%- if not loop.last -%}
    SAFE_CAST({{ column }} AS STRING) {{ column }},
{% else -%}
    SAFE_CAST({{ column }} AS STRING) {{ column }}
{% endif -%}{% endfor -%}
from {{ project_id }}.{{ dataset_id }}_staging.{{ table_id }} as t
