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
SELECT 
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(PIB AS INT64) PIB,
SAFE_CAST(impostos_liquidos AS INT64) impostos_liquidos,
SAFE_CAST(VA AS INT64) VA,
SAFE_CAST(VA_agropecuaria AS INT64) VA_agropecuaria,
SAFE_CAST(VA_industria AS INT64) VA_industria,
SAFE_CAST(VA_servicos AS INT64) VA_servicos,
SAFE_CAST(VA_ADESPSS AS INT64) VA_ADESPSS
from basedosdados-staging.br_ibge_pib_staging.municipios as t