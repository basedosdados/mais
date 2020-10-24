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
SAFE_CAST(CNPJ_holding AS STRING) CNPJ_holding,
SAFE_CAST(razao_social_holding AS STRING) razao_social_holding,
SAFE_CAST(CNPJ AS STRING) CNPJ,
SAFE_CAST(razao_social AS STRING) razao_social,
SAFE_CAST(codigo_qualificacao_socia AS STRING) codigo_qualificacao_socia,
SAFE_CAST(qualificacao_socia AS STRING) qualificacao_socia
from basedosdados-staging.br_me_socios_staging.holding as t