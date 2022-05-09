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

CREATE VIEW basedosdados-dev.br_ibge_ipp.mes_categoria_economica AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(categoria_economica AS STRING) categoria_economica,
SAFE_CAST(categoria_economica_descricao AS STRING) categoria_economica_descricao,
SAFE_CAST(numero_indice AS FLOAT64) numero_indice,
SAFE_CAST(variacao_mensal AS FLOAT64) variacao_mensal,
SAFE_CAST(variacao_anual AS FLOAT64) variacao_anual,
SAFE_CAST(variacao_doze_meses AS FLOAT64) variacao_doze_meses
FROM basedosdados-dev.br_ibge_ipp_staging.mes_categoria_economica AS t