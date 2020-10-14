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
SELECT 
SAFE_CAST(code_tract AS NUMERIC) id_setor_censitario,
SAFE_CAST(zone AS STRING) zona,
SAFE_CAST(id_estado AS NUMERIC) id_estado,
SAFE_CAST(estado_abrev AS STRING) estado_abrev,
SAFE_CAST(code_muni AS NUMERIC) id_municipio,
SAFE_CAST(name_muni AS STRING) nome_municipio,
SAFE_CAST(code_district AS NUMERIC) id_distrito,
SAFE_CAST(name_district AS STRING) nome_distrito,
SAFE_CAST(code_subdistrict AS NUMERIC) id_subdistrito,
SAFE_CAST(name_subdistrict AS STRING) nome_subdistrito,
SAFE_CAST(code_neighborhood AS NUMERIC) id_vizinhanca,
SAFE_CAST(name_neighborhood AS STRING) nome_vizinhanca,
ST_GEOGFROMTEXT(geometry) geometria
from basedosdados-staging.br_geobr_mapas_staging.setor_censitario_2010 as t