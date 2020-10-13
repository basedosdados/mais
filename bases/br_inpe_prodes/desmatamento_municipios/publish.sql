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
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(area AS NUMERIC) area,
SAFE_CAST(desmatado AS NUMERIC) desmatado,
SAFE_CAST(incremento AS NUMERIC) incremento,
SAFE_CAST(floresta AS NUMERIC) floresta,
SAFE_CAST(nuvem AS NUMERIC) nuvem,
SAFE_CAST(nao_observado AS NUMERIC) nao_observado,
SAFE_CAST(nao_floresta AS NUMERIC) nao_floresta,
SAFE_CAST(hidrografia AS NUMERIC) hidrografia
from basedosdados-staging.br_inpe_prodes_staging.desmatamento_municipios as t