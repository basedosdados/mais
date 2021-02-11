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

CREATE VIEW dados-abertos-de-feira.br_ba_feiradesantana.leis AS
SELECT 
SAFE_CAST(titulo AS STRING) titulo,
SAFE_CAST(categoria AS STRING) categoria,
SAFE_CAST(resumo AS STRING) resumo,
SAFE_CAST(texto AS STRING) texto
from dados-abertos-de-feira.br_ba_feiradesantana_staging.leis as t