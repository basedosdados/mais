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

CREATE VIEW basedosdados-dev.br_fipe_ipc.mes_categoria_brasil AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(categoria AS STRING) categoria,
SAFE_CAST(variacao_mensal AS FLOAT64) variacao_mensal,
SAFE_CAST(variacao_primeira_quadrissemana AS FLOAT64) variacao_primeira_quadrissemana,
SAFE_CAST(variacao_segunda_quadrissemana AS FLOAT64) variacao_segunda_quadrissemana,
SAFE_CAST(variacao_terceira_quadrissemana AS FLOAT64) variacao_terceira_quadrissemana
from basedosdados-dev.br_fipe_ipc_staging.mes_categoria_brasil as t