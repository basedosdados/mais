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

CREATE VIEW basedosdados-dev.br_ana_reservatorios.sin AS
SELECT 
SAFE_CAST(data AS DATE) data,
SAFE_CAST(id_reservatorio AS STRING) id_reservatorio,
SAFE_CAST(nome_reservatorio AS STRING) nome_reservatorio,
SAFE_CAST(cota AS FLOAT64) cota,
SAFE_CAST(afluencia AS FLOAT64) afluencia,
SAFE_CAST(defluencia AS FLOAT64) defluencia,
SAFE_CAST(vazao_vertida AS FLOAT64) vazao_vertida,
SAFE_CAST(vazao_turbinada AS FLOAT64) vazao_turbinada,
SAFE_CAST(vazao_natural AS FLOAT64) vazao_natural,
SAFE_CAST(proporcao_volume_util AS FLOAT64) proporcao_volume_util,
SAFE_CAST(vazao_incremental AS FLOAT64) vazao_incremental
FROM basedosdados-dev.br_ana_reservatorios_staging.sin AS t