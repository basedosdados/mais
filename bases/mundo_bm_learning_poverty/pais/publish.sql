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

CREATE VIEW basedosdados-dev.mundo_bm_learning_poverty.pais AS
SELECT 
SAFE_CAST(year AS INT64) year,
SAFE_CAST(country_code AS STRING) country_code,
SAFE_CAST(region_name AS STRING) region_name,
SAFE_CAST(children_reading_proficiency AS FLOAT64) children_reading_proficiency,
SAFE_CAST(female_children_reading_proficiency AS FLOAT64) female_children_reading_proficiency,
SAFE_CAST(male_children_reading_proficiency AS FLOAT64) male_children_reading_proficiency,
SAFE_CAST(children_out_of_school AS FLOAT64) children_out_of_school,
SAFE_CAST(female_children_out_of_school AS FLOAT64) female_children_out_of_school,
SAFE_CAST(male_children_out_of_school AS FLOAT64) male_children_out_of_school,
SAFE_CAST(pupil_reading_proficiency_gaml AS FLOAT64) pupil_reading_proficiency_gaml,
SAFE_CAST(female_pupil_reading_proficiency_gaml AS FLOAT64) female_pupil_reading_proficiency_gaml,
SAFE_CAST(male_pupil_reading_proficiency_gaml AS FLOAT64) male_pupil_reading_proficiency_gaml
FROM basedosdados-dev.mundo_bm_learning_poverty_staging.pais AS t