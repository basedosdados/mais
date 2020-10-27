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
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(estado_abrev AS STRING) estado_abrev,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(causa_basica AS STRING) causa_basica,
SAFE_CAST(idade AS NUMERIC) idade,
SAFE_CAST(numero_obitos AS INT64) numero_obitos
from basedosdados-staging.br_ms_sim_staging.municipio_causa_idade as t