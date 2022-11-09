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

CREATE VIEW basedosdados-dev.br_siorg_cargos.remuneracao AS
SELECT 
SAFE_CAST(sigla_cargo_funcao AS STRING) sigla_cargo_funcao,
SAFE_CAST(nome_cargo_funcao AS STRING) nome_cargo_funcao,
SAFE_CAST(nivel_cargo_funcao AS STRING) nivel_cargo_funcao,
SAFE_CAST(remuneracao AS FLOAT64) remuneracao,
SAFE_CAST(cce_unitario AS FLOAT64) cce_unitario
FROM basedosdados-dev.br_siorg_cargos_staging.remuneracao AS t