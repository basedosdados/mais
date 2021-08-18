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

CREATE VIEW basedosdados-dev.br_ms_sinan.dicionario AS
SELECT 
SAFE_CAST(coluna AS STRING) coluna,
SAFE_CAST(tipo AS STRING) tipo,
SAFE_CAST(descricao AS STRING) descricao,
SAFE_CAST(chaves AS STRING) chaves,
SAFE_CAST(valores AS STRING) valores,
SAFE_CAST(dataset AS STRING) dataset
from basedosdados-dev.br_ms_sinan_staging.dicionario as t