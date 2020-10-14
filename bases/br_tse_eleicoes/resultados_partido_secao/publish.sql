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
SAFE_CAST(tipo_eleicao AS STRING) tipo_eleicao,
SAFE_CAST(estado_abrev AS STRING) estado_abrev,
SAFE_CAST(id_municipio_TSE AS INT64) id_municipio_TSE,
SAFE_CAST(zona AS INT64) zona,
SAFE_CAST(secao AS INT64) secao,
SAFE_CAST(turno AS INT64) turno,
SAFE_CAST(cargo AS STRING) cargo,
SAFE_CAST(partido AS STRING) partido,
SAFE_CAST(votos_nominais AS INT64) votos_nominais,
SAFE_CAST(votos_nao_nominais AS INT64) votos_nao_nominais
from basedosdados-staging.br_tse_eleicoes_staging.resultados_partido_secao as t