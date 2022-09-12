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

CREATE VIEW basedosdados-dev.br_fgv_igp.igp_m_ano AS
SELECT 
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(indice_medio AS STRING) indice_medio,
SAFE_CAST(indice AS STRING) indice,
SAFE_CAST(var_anual AS STRING) var_anual,
SAFE_CAST(indice_fechamento_anual AS STRING) indice_fechamento_anual
FROM basedosdados-dev.br_fgv_igp_staging.igp_m_ano AS t