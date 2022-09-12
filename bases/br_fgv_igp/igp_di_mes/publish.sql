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

CREATE VIEW basedosdados-dev.br_fgv_igp.igp_di_mes AS
SELECT 
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(mes AS STRING) mes,
SAFE_CAST(indice AS STRING) indice,
SAFE_CAST(var_mensal AS STRING) var_mensal,
SAFE_CAST(var_12_meses AS STRING) var_12_meses,
SAFE_CAST(acum_ano AS STRING) acum_ano,
SAFE_CAST(indice_fechamento_mensal AS STRING) indice_fechamento_mensal
FROM basedosdados-dev.br_fgv_igp_staging.igp_di_mes AS t