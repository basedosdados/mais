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

CREATE VIEW basedosdados-dev.br_ponte_indicadores.saude AS
SELECT 
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(tx_hosp_sens AS FLOAT64) tx_hosp_sens,
SAFE_CAST(x_acs AS FLOAT64) x_acs,
SAFE_CAST(cov_esf AS FLOAT64) cov_esf,
SAFE_CAST(medicos AS FLOAT64) medicos,
SAFE_CAST(medicos_div_pop AS FLOAT64) medicos_div_pop,
SAFE_CAST(medicos_mil_pop AS FLOAT64) medicos_mil_pop
from basedosdados-dev.br_ponte_indicadores_staging.saude as t