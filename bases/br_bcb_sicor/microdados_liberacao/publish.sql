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

CREATE VIEW basedosdados-dev.br_bcb_sicor.microdados_liberacao AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS STRING) mes,
SAFE_CAST(data_liberacao AS STRING) data_liberacao,
SAFE_CAST(valor_liberado AS STRING) valor_liberado,
SAFE_CAST(id_referencia_bacen AS STRING) id_referencia_bacen,
SAFE_CAST(numero_ordem AS STRING) numero_ordem
FROM basedosdados-dev.br_bcb_sicor_staging.microdados_liberacao AS t