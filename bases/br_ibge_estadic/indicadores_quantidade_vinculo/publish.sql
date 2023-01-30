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

CREATE VIEW basedosdados-dev.br_ibge_estadic.indicadores_quantidade_vinculo AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(tipo_administracao AS STRING) tipo_administracao,
SAFE_CAST(adm_indireta AS INT64) adm_indireta,
SAFE_CAST(tipo_vinculo AS STRING) tipo_vinculo,
SAFE_CAST(escolaridade AS STRING) escolaridade,
SAFE_CAST(quantidade_vinculo AS INT64) quantidade_vinculo
FROM basedosdados-dev.br_ibge_estadic_staging.indicadores_quantidade_vinculo AS t