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
CREATE VIEW basedosdados-dev.br_me_comex_stat.ncm_exportacao AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(id_ncm AS INT64) id_ncm,
SAFE_CAST(id_unidade AS INT64) id_unidade,
SAFE_CAST(id_pais AS INT64) id_pais,
SAFE_CAST(sigla_uf_ncm AS STRING) sigla_uf_ncm,
SAFE_CAST(id_via AS INT64) id_via,
SAFE_CAST(id_urf AS INT64) id_urf,
SAFE_CAST(quantidade_estatistica AS INT64) quantidade_estatistica,
SAFE_CAST(peso_liquido_kg AS INT64) peso_liquido_kg,
SAFE_CAST(valor_fob_dolar AS INT64) valor_fob_dolar
from basedosdados-dev.br_me_comex_stat_staging.ncm_exportacao as t