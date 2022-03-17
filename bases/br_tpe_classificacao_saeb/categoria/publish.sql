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

CREATE VIEW basedosdados-dev.br_tpe_classificacao_saeb.categoria AS
SELECT 
SAFE_CAST(ano_escolar AS INT64) ano_escolar,
SAFE_CAST(disciplina AS STRING) disciplina,
SAFE_CAST(categoria AS STRING) categoria,
SAFE_CAST(limite_inferior AS FLOAT64) limite_inferior,
SAFE_CAST(limite_superior AS FLOAT64) limite_superior
FROM basedosdados-dev.br_tpe_classificacao_saeb_staging.categoria AS t