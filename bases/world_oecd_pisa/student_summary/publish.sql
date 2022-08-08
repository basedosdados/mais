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

CREATE VIEW basedosdados-dev.world_oecd_pisa.student_summary AS
SELECT 
SAFE_CAST(year AS INT64) year,
SAFE_CAST(id_country_iso_3 AS STRING) id_country_iso_3,
SAFE_CAST(id_school AS STRING) id_school,
SAFE_CAST(id_student AS STRING) id_student,
SAFE_CAST(mother_education AS STRING) mother_education,
SAFE_CAST(father_education AS STRING) father_education,
SAFE_CAST(gender AS STRING) gender,
SAFE_CAST(computer AS STRING) computer,
SAFE_CAST(internet AS STRING) internet,
SAFE_CAST(score_mathematics AS FLOAT64) score_mathematics,
SAFE_CAST(score_reading AS FLOAT64) score_reading,
SAFE_CAST(score_science AS FLOAT64) score_science,
SAFE_CAST(student_weight AS FLOAT64) student_weight,
SAFE_CAST(desk AS STRING) desk,
SAFE_CAST(room AS STRING) room,
SAFE_CAST(dishwasher AS STRING) dishwasher,
SAFE_CAST(television AS STRING) television,
SAFE_CAST(computer_number AS STRING) computer_number,
SAFE_CAST(car AS STRING) car,
SAFE_CAST(book AS STRING) book,
SAFE_CAST(wealth AS FLOAT64) wealth,
SAFE_CAST(economic_social_cultural_status AS FLOAT64) economic_social_cultural_status
FROM basedosdados-dev.world_oecd_pisa_staging.student_summary AS t