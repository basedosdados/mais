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

CREATE VIEW projetos-bd.br_inmet_bdmep.estacoes AS
SELECT 
SAFE_CAST(id_estacao AS STRING) id_estacao,
SAFE_CAST(estacao AS STRING) estacao,
SAFE_CAST(latitude AS FLOAT64) latitude,
SAFE_CAST(longitude AS FLOAT64) longitude,
SAFE_CAST(altitude AS FLOAT64) altitude,
SAFE_CAST(data_fundacao AS DATE) data_fundacao,
SAFE_CAST(id_municipio AS STRING) id_municipio
from projetos-bd.br_inmet_bdmep_staging.estacoes as t