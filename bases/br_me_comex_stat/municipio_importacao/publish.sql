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

CREATE VIEW basedosdados-dev.br_me_comex_stat.municipio_importacao AS
SELECT 
SAFE_CAST(id_sh4 AS STRING) id_sh4,
SAFE_CAST(id_pais AS STRING) id_pais,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(peso_liquido_kg AS STRING) peso_liquido_kg,
SAFE_CAST(valor_fob_dolar AS STRING) valor_fob_dolar,
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(mes AS STRING) mes
from basedosdados-dev.br_me_comex_stat_staging.municipio_importacao as t