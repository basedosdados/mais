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

CREATE VIEW basedosdados-dev.br_tse_eleicoes.localizacao_secao AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(zona AS INT64) zona,
SAFE_CAST(secao AS INT64) secao,
ST_GEOGPOINT(
  SAFE_CAST(COALESCE(google_lon, tse_lon, comp_tse_lon, inep_lon, local_lon, ad_lon, pl_lon, google_approx_lon, ibge_approx_lon) AS FLOAT64),
  SAFE_CAST(COALESCE(google_lat, tse_lat, comp_tse_lat, inep_lat, local_lat, ad_lat, pl_lat, google_approx_lat, ibge_approx_lat) AS FLOAT64)
) melhor_urbano,
ST_GEOGPOINT(
  SAFE_CAST(COALESCE(ad_lon, pl_lon,  comp_tse_lon, tse_lon, inep_lon, local_lon, google_lon, google_approx_lon, ibge_approx_lon) AS FLOAT64),
  SAFE_CAST(COALESCE( ad_lat, pl_lat, comp_tse_lat, tse_lat, inep_lat, local_lat,  google_lat, google_approx_lat, ibge_approx_lat) AS FLOAT64)
) melhor_rural,
ST_GEOGPOINT(SAFE_CAST(tse_lon AS FLOAT64), SAFE_CAST(tse_lat AS FLOAT64)) tse_recente,
ST_GEOGPOINT(SAFE_CAST(comp_tse_lon AS FLOAT64), SAFE_CAST(comp_tse_lat AS FLOAT64)) tse_distribuido,
ST_GEOGPOINT(SAFE_CAST(inep_lon AS FLOAT64), SAFE_CAST(inep_lat AS FLOAT64)) escolas_inep,
ST_GEOGPOINT(SAFE_CAST(local_lon AS FLOAT64), SAFE_CAST(local_lat AS FLOAT64)) escolas_municipais,
ST_GEOGPOINT(SAFE_CAST(ad_lon AS FLOAT64), SAFE_CAST(ad_lat AS FLOAT64)) ibge_cnefe_endereco,
ST_GEOGPOINT(SAFE_CAST(pl_lon AS FLOAT64), SAFE_CAST(pl_lat AS FLOAT64)) ibge_cnefe_local,
ST_GEOGPOINT(SAFE_CAST(google_lon AS FLOAT64), SAFE_CAST(google_lat AS FLOAT64)) google,
ST_GEOGPOINT(SAFE_CAST(places_lon AS FLOAT64), SAFE_CAST(places_lat AS FLOAT64)) google_relaxado,
ST_GEOGPOINT(SAFE_CAST(google_approx_lon AS FLOAT64), SAFE_CAST(google_approx_lat AS FLOAT64)) google_centro_geometrico,
ST_GEOGPOINT(SAFE_CAST(ibge_approx_lon AS FLOAT64), SAFE_CAST(ibge_approx_lat AS FLOAT64)) ibge_povoados
FROM basedosdados-dev.br_tse_eleicoes_staging.localizacao_secao AS t