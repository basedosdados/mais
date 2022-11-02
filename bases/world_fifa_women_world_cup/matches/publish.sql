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

CREATE VIEW basedosdados-dev.world_fifa_women_world_cup.matches AS
SELECT 
SAFE_CAST(year AS INT64) year,
SAFE_CAST(tournament_id AS STRING) tournament_id,
SAFE_CAST(match_id AS STRING) match_id,
SAFE_CAST(stage_name AS STRING) stage_name,
SAFE_CAST(group_name AS STRING) group_name,
SAFE_CAST(match_date AS DATE) match_date,
SAFE_CAST(match_time AS TIME) match_time,
SAFE_CAST(stadium_name AS STRING) stadium_name,
SAFE_CAST(country_name AS STRING) country_name,
SAFE_CAST(country_id_iso_3 AS STRING) country_id_iso_3,
SAFE_CAST(knockout_stage AS INT64) knockout_stage,
SAFE_CAST(team_a_id_iso_3 AS STRING) team_a_id_iso_3,
SAFE_CAST(team_a_name AS STRING) team_a_name,
SAFE_CAST(team_a_code AS STRING) team_a_code,
SAFE_CAST(team_b_id_iso_3 AS STRING) team_b_id_iso_3,
SAFE_CAST(team_b_name AS STRING) team_b_name,
SAFE_CAST(team_b_code AS STRING) team_b_code,
SAFE_CAST(score AS STRING) score,
SAFE_CAST(team_a_score AS INT64) team_a_score,
SAFE_CAST(team_b_score AS INT64) team_b_score,
SAFE_CAST(team_a_score_margin AS INT64) team_a_score_margin,
SAFE_CAST(team_b_score_margin AS INT64) team_b_score_margin,
SAFE_CAST(extra_time AS INT64) extra_time,
SAFE_CAST(penalty_shootout AS INT64) penalty_shootout,
SAFE_CAST(score_penalties AS STRING) score_penalties,
SAFE_CAST(team_a_score_penalties AS INT64) team_a_score_penalties,
SAFE_CAST(team_b_score_penalties AS INT64) team_b_score_penalties,
SAFE_CAST(team_a_win AS INT64) team_a_win,
SAFE_CAST(team_b_win AS INT64) team_b_win,
SAFE_CAST(draw AS INT64) draw
FROM basedosdados-dev.world_fifa_women_world_cup_staging.matches AS t