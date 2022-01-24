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

CREATE VIEW basedosdados-dev.br_ibge_pib.municipio AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(PIB AS INT64) pib,
SAFE_CAST(impostos_liquidos AS INT64) impostos_liquidos,
SAFE_CAST(VA AS INT64) va,
SAFE_CAST(VA_agropecuaria AS INT64) va_agropecuaria,
SAFE_CAST(VA_industria AS INT64) va_industria,
SAFE_CAST(VA_servicos AS INT64) va_servicos,
SAFE_CAST(VA_ADESPSS AS INT64) va_adespss
FROM basedosdados-dev.br_ibge_pib_staging.municipio AS t