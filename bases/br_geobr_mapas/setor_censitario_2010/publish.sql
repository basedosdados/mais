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
CREATE VIEW basedosdados-dev.br_geobr_mapas.setor_censitario_2010 AS
SELECT 
SAFE_CAST(id_uf AS STRING) id_uf,
SAFE_CAST(estado_abrev AS STRING) sigla_uf,
SAFE_CAST( SAFE_CAST( SAFE_CAST(id_municipio AS FLOAT64) AS INT64) AS STRING) id_municipio, -- corrige ponto decimal
SAFE_CAST(nome_municipio AS STRING) nome_municipio,
SAFE_CAST(id_distrito AS STRING) id_distrito,
SAFE_CAST(nome_distrito AS STRING) nome_distrito,
SAFE_CAST(id_subdistrito AS STRING) id_subdistrito,
SAFE_CAST(nome_subdistrito AS STRING) nome_subdistrito,
SAFE_CAST(id_vizinhanca AS STRING) nome_vizinhanca, -- invertida com nome_vizinhanca
SAFE_CAST( SAFE_CAST( SAFE_CAST(nome_vizinhanca AS FLOAT64) AS INT64) AS STRING) id_vizinhanca, -- invertida com id_vizinhanca e corrige ponto decimal
SAFE_CAST(id_setor_censitario AS STRING) id_setor_censitario,
SAFE_CAST(zona AS STRING) zona,
SAFE.ST_GEOGFROMTEXT(geometria) geometria
from basedosdados-dev.br_geobr_mapas_staging.setor_censitario_2010 as t