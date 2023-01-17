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

CREATE VIEW basedosdados-dev.world_fifa_worldcup.teams AS
SELECT 
SAFE_CAST(team_id AS STRING) team_id,
SAFE_CAST(team_name AS STRING) team_name,
SAFE_CAST(team_code AS STRING) team_code,
SAFE_CAST(federation_name AS STRING) federation_name,
SAFE_CAST(region_name AS STRING) region_name,
SAFE_CAST(confederation_id AS STRING) confederation_id,
SAFE_CAST(confederation_name AS STRING) confederation_name,
SAFE_CAST(confederation_code AS STRING) confederation_code
FROM basedosdados-dev.world_fifa_worldcup_staging.teams AS t