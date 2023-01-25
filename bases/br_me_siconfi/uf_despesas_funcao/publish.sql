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

CREATE VIEW basedosdados-dev.br_me_siconfi.uf_despesas_funcao AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_uf AS STRING) id_uf,
SAFE_CAST(estagio AS STRING) estagio,
SAFE_CAST(portaria AS STRING) portaria,
SAFE_CAST(conta AS STRING) conta,
SAFE_CAST(estagio_bd AS STRING) estagio_bd,
SAFE_CAST(id_conta_bd AS STRING) id_conta_bd,
SAFE_CAST(conta_bd AS STRING) conta_bd,
SAFE_CAST(valor AS STRING) valor
FROM basedosdados-dev.br_me_siconfi_staging.uf_despesas_funcao AS t