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

CREATE VIEW basedosdados-dev.br_bd_indicadores.pessoas AS
SELECT 
SAFE_CAST(id AS STRING) id,
SAFE_CAST(nome AS STRING) nome,
SAFE_CAST(descricao AS STRING) descricao,
SAFE_CAST(email AS STRING) email,
SAFE_CAST(twitter AS STRING) twitter,
SAFE_CAST(github AS STRING) github,
SAFE_CAST(website AS STRING) website,
SAFE_CAST(linkedin AS STRING) linkedin,
SAFE_CAST(url_foto AS STRING) url_foto
FROM basedosdados-dev.br_bd_indicadores_staging.pessoas AS t