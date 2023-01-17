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

CREATE VIEW basedosdados-dev.br_bd_indicadores.receitas_planejadas AS
SELECT 
SAFE_CAST(ano_competencia AS INT64) ano_competencia,
SAFE_CAST(mes_competencia AS INT64) mes_competencia,
SAFE_CAST(ano_caixa AS INT64) ano_caixa,
SAFE_CAST(mes_caixa AS INT64) mes_caixa,
SAFE_CAST(categoria AS STRING) categoria,
SAFE_CAST(tipo AS STRING) tipo,
SAFE_CAST(frequencia AS STRING) frequencia,
SAFE_CAST(valor AS FLOAT64) valor
FROM basedosdados-dev.br_bd_indicadores_staging.receitas_planejadas AS t