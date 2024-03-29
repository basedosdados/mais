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

CREATE VIEW basedosdados-dev.br_ipea_acesso_oportunidades.indicadores_2019 AS
SELECT 
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_grid_h3 AS STRING) id_grid_h3,
ST_GEOGFROMTEXT(geometria) geometria,
SAFE_CAST(modo_transporte AS STRING) modo_transporte,
SAFE_CAST(horario_pico AS INT64) horario_pico,
SAFE_CAST(CMATT15 AS FLOAT64) * 100 CMATT15,
SAFE_CAST(CMATQ15 AS FLOAT64) * 100 CMATQ15,
SAFE_CAST(CMATD15 AS FLOAT64) * 100 CMATD15,
SAFE_CAST(CMAST15 AS FLOAT64) * 100 CMAST15,
SAFE_CAST(CMASB15 AS FLOAT64) * 100 CMASB15,
SAFE_CAST(CMASM15 AS FLOAT64) * 100 CMASM15,
SAFE_CAST(CMASA15 AS FLOAT64) * 100 CMASA15,
SAFE_CAST(CMAET15 AS FLOAT64) * 100 CMAET15,
SAFE_CAST(CMAEI15 AS FLOAT64) * 100 CMAEI15,
SAFE_CAST(CMAEF15 AS FLOAT64) * 100 CMAEF15,
SAFE_CAST(CMAEM15 AS FLOAT64) * 100 CMAEM15,
SAFE_CAST(CMATT30 AS FLOAT64) * 100 CMATT30,
SAFE_CAST(CMATQ30 AS FLOAT64) * 100 CMATQ30,
SAFE_CAST(CMATD30 AS FLOAT64) * 100 CMATD30,
SAFE_CAST(CMAST30 AS FLOAT64) * 100 CMAST30,
SAFE_CAST(CMASB30 AS FLOAT64) * 100 CMASB30,
SAFE_CAST(CMASM30 AS FLOAT64) * 100 CMASM30,
SAFE_CAST(CMASA30 AS FLOAT64) * 100 CMASA30,
SAFE_CAST(CMAET30 AS FLOAT64) * 100 CMAET30,
SAFE_CAST(CMAEI30 AS FLOAT64) * 100 CMAEI30,
SAFE_CAST(CMAEF30 AS FLOAT64) * 100 CMAEF30,
SAFE_CAST(CMAEM30 AS FLOAT64) * 100 CMAEM30,
SAFE_CAST(CMATT45 AS FLOAT64) * 100 CMATT45,
SAFE_CAST(CMATQ45 AS FLOAT64) * 100 CMATQ45,
SAFE_CAST(CMATD45 AS FLOAT64) * 100 CMATD45,
SAFE_CAST(CMAST45 AS FLOAT64) * 100 CMAST45,
SAFE_CAST(CMASB45 AS FLOAT64) * 100 CMASB45,
SAFE_CAST(CMASM45 AS FLOAT64) * 100 CMASM45,
SAFE_CAST(CMASA45 AS FLOAT64) * 100 CMASA45,
SAFE_CAST(CMAET45 AS FLOAT64) * 100 CMAET45,
SAFE_CAST(CMAEI45 AS FLOAT64) * 100 CMAEI45,
SAFE_CAST(CMAEF45 AS FLOAT64) * 100 CMAEF45,
SAFE_CAST(CMAEM45 AS FLOAT64) * 100 CMAEM45,
SAFE_CAST(CMATT60 AS FLOAT64) * 100 CMATT60,
SAFE_CAST(CMATQ60 AS FLOAT64) * 100 CMATQ60,
SAFE_CAST(CMATD60 AS FLOAT64) * 100 CMATD60,
SAFE_CAST(CMAST60 AS FLOAT64) * 100 CMAST60,
SAFE_CAST(CMASB60 AS FLOAT64) * 100 CMASB60,
SAFE_CAST(CMASM60 AS FLOAT64) * 100 CMASM60,
SAFE_CAST(CMASA60 AS FLOAT64) * 100 CMASA60,
SAFE_CAST(CMAET60 AS FLOAT64) * 100 CMAET60,
SAFE_CAST(CMAEI60 AS FLOAT64) * 100 CMAEI60,
SAFE_CAST(CMAEF60 AS FLOAT64) * 100 CMAEF60,
SAFE_CAST(CMAEM60 AS FLOAT64) * 100 CMAEM60,
SAFE_CAST(CMATT90 AS FLOAT64) * 100 CMATT90,
SAFE_CAST(CMATQ90 AS FLOAT64) * 100 CMATQ90,
SAFE_CAST(CMATD90 AS FLOAT64) * 100 CMATD90,
SAFE_CAST(CMAST90 AS FLOAT64) * 100 CMAST90,
SAFE_CAST(CMASB90 AS FLOAT64) * 100 CMASB90,
SAFE_CAST(CMASM90 AS FLOAT64) * 100 CMASM90,
SAFE_CAST(CMASA90 AS FLOAT64) * 100 CMASA90,
SAFE_CAST(CMAET90 AS FLOAT64) * 100 CMAET90,
SAFE_CAST(CMAEI90 AS FLOAT64) * 100 CMAEI90,
SAFE_CAST(CMAEF90 AS FLOAT64) * 100 CMAEF90,
SAFE_CAST(CMAEM90 AS FLOAT64) * 100 CMAEM90,
SAFE_CAST(CMATT120 AS FLOAT64) * 100 CMATT120,
SAFE_CAST(CMATQ120 AS FLOAT64) * 100 CMATQ120,
SAFE_CAST(CMATD120 AS FLOAT64) * 100 CMATD120,
SAFE_CAST(CMAST120 AS FLOAT64) * 100 CMAST120,
SAFE_CAST(CMASB120 AS FLOAT64) * 100 CMASB120,
SAFE_CAST(CMASM120 AS FLOAT64) * 100 CMASM120,
SAFE_CAST(CMASA120 AS FLOAT64) * 100 CMASA120,
SAFE_CAST(CMAET120 AS FLOAT64) * 100 CMAET120,
SAFE_CAST(CMAEI120 AS FLOAT64) * 100 CMAEI120,
SAFE_CAST(CMAEF120 AS FLOAT64) * 100 CMAEF120,
SAFE_CAST(CMAEM120 AS FLOAT64) * 100 CMAEM120,
SAFE_CAST(TMIST AS FLOAT64) * 100 TMIST,
SAFE_CAST(TMISB AS FLOAT64) * 100 TMISB,
SAFE_CAST(TMISM AS FLOAT64) * 100 TMISM,
SAFE_CAST(TMISA AS FLOAT64) * 100 TMISA,
SAFE_CAST(TMIET AS FLOAT64) * 100 TMIET,
SAFE_CAST(TMIEI AS FLOAT64) * 100 TMIEI,
SAFE_CAST(TMIEF AS FLOAT64) * 100 TMIEF,
SAFE_CAST(TMIEM AS FLOAT64) * 100 TMIEM
from basedosdados-dev.br_ipea_acesso_oportunidades_staging.indicadores_2019 as t
