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

CREATE VIEW basedosdados-dev.world_fifa_worldcup.tournaments AS
SELECT 
SAFE_CAST(tournament_id AS STRING) tournament_id,
SAFE_CAST(tournament_name AS STRING) tournament_name,
SAFE_CAST(year AS INT64) year,
SAFE_CAST(start_date AS DATE) start_date,
SAFE_CAST(end_date AS DATE) end_date,
SAFE_CAST(country_name AS STRING) country_name,
SAFE_CAST(winner AS STRING) winner,
SAFE_CAST(host_won AS INT64) host_won,
SAFE_CAST(count_teams AS INT64) count_teams,
SAFE_CAST(group_stage AS INT64) group_stage,
SAFE_CAST(second_group_stage AS INT64) second_group_stage,
SAFE_CAST(final_round AS INT64) final_round,
SAFE_CAST(round_of_16 AS INT64) round_of_16,
SAFE_CAST(quarter_finals AS INT64) quarter_finals,
SAFE_CAST(semi_finals AS INT64) semi_finals,
SAFE_CAST(third_place_match AS INT64) third_place_match,
SAFE_CAST(final AS INT64) final
FROM basedosdados-dev.world_fifa_worldcup_staging.tournaments AS t