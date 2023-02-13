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

CREATE VIEW basedosdados-dev.br_bcb_estban.municipio AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(cnpj_basico AS STRING) cnpj_basico,
SAFE_CAST(instituicao AS STRING) instituicao,
SAFE_CAST(agencias_esperadas AS INT64) agencias_esperadas,
SAFE_CAST(agencias_processadas AS INT64) agencias_processadas,
SAFE_CAST(id_verbete AS STRING) id_verbete,
SAFE_CAST(valor AS FLOAT64) valor
FROM basedosdados-dev.br_bcb_estban_staging.municipio AS t