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

CREATE VIEW basedosdados-dev.eu_fra_lgbt.discriminacao AS
SELECT 
SAFE_CAST(pais_ingles AS STRING) pais_ingles,
SAFE_CAST(grupo AS STRING) grupo,
SAFE_CAST(id_pergunta AS STRING) id_pergunta,
SAFE_CAST(pergunta AS STRING) pergunta,
SAFE_CAST(resposta AS STRING) resposta,
SAFE_CAST(porcentagem AS STRING) porcentagem
FROM basedosdados-dev.eu_fra_lgbt_staging.discriminacao AS t