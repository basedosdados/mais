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

CREATE VIEW basedosdados.br_ibge_pam.municipio_lavouras_permanentes AS
SELECT 
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(sigla_uf AS INT64) sigla_uf,
SAFE_CAST(ano AS DATE) ano,
SAFE_CAST(produto AS STRING) produto,
SAFE_CAST(area_ded_colheita AS INT64) area_ded_colheita,
SAFE_CAST(perc_a_dedcolheita AS FLOAT64) perc_a_dedcolheita,
SAFE_CAST(a_colhida AS INT64) a_colhida,
SAFE_CAST(perca_colhida AS FLOAT64) perca_colhida,
SAFE_CAST(qtd_produzida AS INT64) qtd_produzida,
SAFE_CAST(rend_medio AS INT64) rend_medio,
SAFE_CAST(valor_prod AS INT64) valor_prod,
SAFE_CAST(perc_valor_prod AS FLOAT64) perc_valor_prod,
SAFE_CAST(moeda_do_valor_da_prod AS STRING) moeda_do_valor_da_prod
from basedosdados-dev.br_ibge_pam_staging.municipio_lavouras_permanentes as t