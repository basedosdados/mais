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

CREATE VIEW basedosdados-dev.br_mc_indicadores.transferencias_municipio AS
SELECT 
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(familias_beneficiarias_pbf AS INT64) familias_beneficiarias_pbf,
SAFE_CAST(pessoas_beneficiarias_pbf AS INT64) pessoas_beneficiarias_pbf,
SAFE_CAST(valor_pago_pbf AS FLOAT64) valor_pago_pbf,
SAFE_CAST(familias_cadastradas_cu AS INT64) familias_cadastradas_cu,
SAFE_CAST(pessoas_cadastradas_cu AS INT64) pessoas_cadastradas_cu
from basedosdados-dev.br_mc_indicadores_staging.transferencias_municipio as t