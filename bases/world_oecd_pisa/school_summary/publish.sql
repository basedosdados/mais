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

CREATE VIEW basedosdados-dev.world_oecd_pisa.school_summary AS
SELECT 
SAFE_CAST(year AS INT64) year,
SAFE_CAST(country_id_iso_3 AS STRING) country_id_iso_3,
SAFE_CAST(school_id AS STRING) school_id,
SAFE_CAST(public_private AS STRING) public_private,
SAFE_CAST(funding_government AS FLOAT64) funding_government,
SAFE_CAST(funding_fees AS FLOAT64) funding_fees,
SAFE_CAST(funding_donation AS FLOAT64) funding_donation,
SAFE_CAST(number_boys AS INT64) number_boys,
SAFE_CAST(number_girls AS INT64) number_girls,
SAFE_CAST(number_students AS INT64) number_students,
SAFE_CAST(student_teacher_ratio AS FLOAT64) student_teacher_ratio,
SAFE_CAST(staff_shortage AS FLOAT64) staff_shortage,
SAFE_CAST(school_weight AS FLOAT64) school_weight
FROM basedosdados-dev.world_oecd_pisa_staging.school_summary AS t