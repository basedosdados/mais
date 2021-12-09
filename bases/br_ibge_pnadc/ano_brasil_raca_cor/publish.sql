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

CREATE VIEW basedosdados-dev.br_ibge_pnadc.ano_brasil_raca_cor AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(cor_raca AS STRING) cor_raca,
SAFE_CAST(populacao AS INT64) populacao
FROM basedosdados-dev.br_ibge_pnadc_staging.ano_brasil_raca_cor AS t