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

CREATE VIEW basedosdados-dev.br_ibge_pam.municipio_lavouras_permanentes AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(produto AS STRING) produto,
SAFE_CAST(area_plantada AS INT64) area_plantada,
SAFE_CAST(area_colhida AS INT64) area_colhida,
SAFE_CAST(quantidade_produzida AS INT64) quantidade_produzida,
SAFE_CAST(rendimento_medio AS INT64) rendimento_medio,
SAFE_CAST(valor_producao AS INT64) valor_producao,
SAFE_CAST(prop_area_plantada AS FLOAT64) prop_area_plantada,
SAFE_CAST(prop_area_colhida AS FLOAT64) prop_area_colhida,
SAFE_CAST(prop_valor_producao AS FLOAT64) prop_valor_producao
from basedosdados-dev.br_ibge_pam_staging.municipio_lavouras_permanentes as t