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

CREATE VIEW basedosdados-dev.br_mobilidados_indicadores.comprometimento_renda_tarifa_transp_publico AS
SELECT 
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(tarifas AS FLOAT64) tarifas,
SAFE_CAST(comprometimento_salario_minimo AS FLOAT64) comprometimento_salario_minimo,
SAFE_CAST(comprometimento_renda_domesticas_negras AS FLOAT64) comprometimento_renda_domesticas_negras
FROM basedosdados-dev.br_mobilidados_indicadores_staging.comprometimento_renda_tarifa_transp_publico AS t