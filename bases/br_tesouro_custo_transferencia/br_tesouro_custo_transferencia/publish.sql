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

CREATE VIEW basedosdados-dev.br_tesouro_custo_transferencia.br_tesouro_custo_transferencia AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(id_unidade_organizacional_nivel_0 AS STRING) id_unidade_organizacional_nivel_0,
SAFE_CAST(id_unidade_organizacional_nivel_1 AS STRING) id_unidade_organizacional_nivel_1,
SAFE_CAST(id_unidade_organizacional_nivel_2 AS STRING) id_unidade_organizacional_nivel_2,
SAFE_CAST(id_unidade_organizacional_nivel_3 AS STRING) id_unidade_organizacional_nivel_3,
SAFE_CAST(id_natureza_juridica AS STRING) id_natureza_juridica,
SAFE_CAST(id_esfera_orcamentaria AS STRING) id_esfera_orcamentaria,
SAFE_CAST(id_resultado_primario AS STRING) id_resultado_primario,
SAFE_CAST(valor_custo_transferencia AS FLOAT64) valor_custo_transferencia
FROM basedosdados-dev.br_tesouro_custo_transferencia_staging.br_tesouro_custo_transferencia AS t