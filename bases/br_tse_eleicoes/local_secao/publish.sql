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
CREATE VIEW basedosdados.br_tse_eleicoes.local_secao AS
select 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(estado_abrev AS STRING) estado_abrev,
SAFE_CAST(codigo_ibge AS NUMERIC) id_municipio,
SAFE_CAST(zona AS NUMERIC) zona,
SAFE_CAST(secao AS NUMERIC) secao,
ST_GEOGPOINT(
  SAFE_CAST(COALESCE(google_lon, tse_lon, comp_tse_lon, inep_lon, local_lon, ad_lon, pl_lon, google_approx_lon, ibge_approx_lon) AS NUMERIC),
  SAFE_CAST(COALESCE(google_lat, tse_lat, comp_tse_lat, inep_lat, local_lat, ad_lat, pl_lat, google_approx_lat, ibge_approx_lat) AS NUMERIC)
) melhor_urbano,
ST_GEOGPOINT(
  SAFE_CAST(COALESCE(ad_lon, pl_lon,  comp_tse_lon, tse_lon, inep_lon, local_lon, google_lon, google_approx_lon, ibge_approx_lon) AS NUMERIC),
  SAFE_CAST(COALESCE( ad_lat, pl_lat, comp_tse_lat, tse_lat, inep_lat, local_lat,  google_lat, google_approx_lat, ibge_approx_lat) AS NUMERIC)
) melhor_rural,
ST_GEOGPOINT(SAFE_CAST(tse_lon AS NUMERIC), SAFE_CAST(tse_lat AS NUMERIC)) tse_recente,
ST_GEOGPOINT(SAFE_CAST(comp_tse_lon AS NUMERIC), SAFE_CAST(comp_tse_lat AS NUMERIC)) tse_distribuido,
ST_GEOGPOINT(SAFE_CAST(inep_lon AS NUMERIC), SAFE_CAST(inep_lat AS NUMERIC)) escolas_inep,
ST_GEOGPOINT(SAFE_CAST(local_lon AS NUMERIC), SAFE_CAST(local_lat AS NUMERIC)) escolas_municipais,
ST_GEOGPOINT(SAFE_CAST(ad_lon AS NUMERIC), SAFE_CAST(ad_lat AS NUMERIC)) ibge_cnefe_endereco,
ST_GEOGPOINT(SAFE_CAST(pl_lon AS NUMERIC), SAFE_CAST(pl_lat AS NUMERIC)) ibge_cnefe_local,
ST_GEOGPOINT(SAFE_CAST(google_lon AS NUMERIC), SAFE_CAST(google_lat AS NUMERIC)) google,
ST_GEOGPOINT(SAFE_CAST(places_lon AS NUMERIC), SAFE_CAST(places_lat AS NUMERIC)) google_relaxado,
ST_GEOGPOINT(SAFE_CAST(google_approx_lon AS NUMERIC), SAFE_CAST(google_approx_lat AS NUMERIC)) google_centro_geometrico,
ST_GEOGPOINT(SAFE_CAST(ibge_approx_lon AS NUMERIC), SAFE_CAST(ibge_approx_lat AS NUMERIC)) ibge_povoados
from basedosdados-staging.br_tse_eleicoes_staging.local_secao as t