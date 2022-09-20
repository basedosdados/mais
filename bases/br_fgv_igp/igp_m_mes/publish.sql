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

CREATE VIEW basedosdados-dev.br_fgv_igp.igp_m_mes AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(indice AS FLOAT64) indice,
SAFE_CAST(variacao_mensal AS FLOAT64) variacao_mensal,
SAFE_CAST(variacao_12_meses AS FLOAT64) variacao_12_meses,
SAFE_CAST(variacao_primeiro_decendio AS FLOAT64) variacao_primeiro_decendio,
SAFE_CAST(variacao_segundo_decendio AS FLOAT64) variacao_segundo_decendio,
SAFE_CAST(variacao_acumulada_ano AS FLOAT64) variacao_acumulada_ano,
SAFE_CAST(indice_fechamento_mensal AS FLOAT64) indice_fechamento_mensal
FROM basedosdados-dev.br_fgv_igp_staging.igp_m_mes AS t