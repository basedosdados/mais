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

CREATE VIEW basedosdados-dev.br_inep_saeb.brasil AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(localizacao AS STRING) localizacao,
SAFE_CAST(disciplina AS STRING) disciplina,
SAFE_CAST(serie AS INT64) serie,
SAFE_CAST(media AS FLOAT64) media,
SAFE_CAST(nivel_0 AS FLOAT64) nivel_0,
SAFE_CAST(nivel_1 AS FLOAT64) nivel_1,
SAFE_CAST(nivel_2 AS FLOAT64) nivel_2,
SAFE_CAST(nivel_3 AS FLOAT64) nivel_3,
SAFE_CAST(nivel_4 AS FLOAT64) nivel_4,
SAFE_CAST(nivel_5 AS FLOAT64) nivel_5,
SAFE_CAST(nivel_6 AS FLOAT64) nivel_6,
SAFE_CAST(nivel_7 AS FLOAT64) nivel_7,
SAFE_CAST(nivel_8 AS FLOAT64) nivel_8,
SAFE_CAST(nivel_9 AS FLOAT64) nivel_9,
SAFE_CAST(nivel_10 AS FLOAT64) nivel_10
FROM basedosdados-dev.br_inep_saeb_staging.brasil AS t