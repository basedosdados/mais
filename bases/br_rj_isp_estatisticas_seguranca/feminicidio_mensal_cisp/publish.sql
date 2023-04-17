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
    - Para modificar tipos de colunas, basta substituir INT64 por outro tipo válido.
    - Exemplo: `SAFE_CAST(column_name AS NUMERIC) column_name`
    - Mais detalhes: https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types

*/

CREATE VIEW basedosdados-dev.br_isp_estatisticas_seguranca.feminicidio_mensal_cisp AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(cisp AS STRING) cisp,
SAFE_CAST(feminicidio AS INT64) feminicidio,
SAFE_CAST(feminicidio_tentativa AS INT64) feminicidio_tentativa,
SAFE_CAST(fase AS INT64) fase
from basedosdados-dev.br_isp_estatisticas_seguranca_staging.feminicidio_mensal_cisp as t