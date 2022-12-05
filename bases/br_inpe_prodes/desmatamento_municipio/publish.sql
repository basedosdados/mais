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

CREATE VIEW basedosdados-dev.br_inpe_prodes.desmatamento_municipio AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(area AS INT64) area,
SAFE_CAST(desmatado AS FLOAT64) desmatado,
SAFE_CAST(incremento AS FLOAT64) incremento,
SAFE_CAST(floresta AS FLOAT64) floresta,
SAFE_CAST(nuvem AS FLOAT64) nuvem,
SAFE_CAST(nao_observado AS FLOAT64) nao_observado,
SAFE_CAST(nao_floresta AS FLOAT64) nao_floresta,
SAFE_CAST(hidrografia AS FLOAT64) hidrografia
FROM basedosdados-dev.br_inpe_prodes_staging.desmatamento_municipio AS t