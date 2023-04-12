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

CREATE VIEW basedosdados-dev.br_bd_diretorios_brasil.cep AS
SELECT 
SAFE_CAST(cep AS STRING) cep,
SAFE_CAST(logradouro AS STRING) logradouro,
SAFE_CAST(bairro AS STRING) bairro,
SAFE_CAST(cidade AS STRING) cidade,
SAFE_CAST(complemento AS STRING) complemento,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(latitude AS FLOAT64) latitude,
SAFE_CAST(longitude AS FLOAT64) longitude,
ST_GEOGPOINT(SAFE_CAST(latitude AS FLOAT64), SAFE_CAST(longitude AS FLOAT64)) centroide
FROM basedosdados-dev.br_bd_diretorios_brasil_staging.cep AS t