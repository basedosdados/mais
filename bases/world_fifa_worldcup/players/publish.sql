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

CREATE VIEW basedosdados-dev.world_fifa_worldcup.players AS
SELECT 
SAFE_CAST(player_id AS STRING) player_id,
SAFE_CAST(family_name AS STRING) family_name,
SAFE_CAST(given_name AS STRING) given_name,
SAFE_CAST(birth_date AS DATE) birth_date,
SAFE_CAST(goal_keeper AS INT64) goal_keeper,
SAFE_CAST(defender AS INT64) defender,
SAFE_CAST(midfielder AS INT64) midfielder,
SAFE_CAST(forward AS INT64) forward,
SAFE_CAST(count_tournaments AS INT64) count_tournaments,
SAFE_CAST(list_tournaments AS STRING) list_tournaments
FROM basedosdados-dev.world_fifa_worldcup_staging.players AS t