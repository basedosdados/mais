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

CREATE VIEW basedosdados-dev.world_fifa_worldcup.award_winners AS
SELECT 
SAFE_CAST(tournament_id AS STRING) tournament_id,
SAFE_CAST(award_id AS STRING) award_id,
SAFE_CAST(award_name AS STRING) award_name,
SAFE_CAST(shared AS STRING) shared,
SAFE_CAST(player_id AS STRING) player_id
FROM basedosdados-dev.world_fifa_worldcup_staging.award_winners AS t