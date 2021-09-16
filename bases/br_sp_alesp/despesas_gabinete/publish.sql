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

CREATE VIEW basedosdados-dev.br_sp_alesp.despesas_gabinete AS
SELECT
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(matricula AS STRING) matricula,
SAFE_CAST(nome_deputado AS STRING) nome_deputado,
SAFE_CAST(cpf_cnpj AS STRING) cpf_cnpj,
SAFE_CAST(fornecedor AS STRING) fornecedor,
SAFE_CAST(tipo AS STRING) tipo,
SAFE_CAST(valor AS FLOAT64) valor
from basedosdados-dev.br_sp_alesp_staging.despesas_gabinete as t