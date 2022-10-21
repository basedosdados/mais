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

CREATE VIEW basedosdados-dev.br_bd_indicadores.website_user AS
SELECT 
SAFE_CAST(reference_date AS DATE) reference_date,
SAFE_CAST(users_1_day AS INT64) users_1_day,
SAFE_CAST(users_7_days AS INT64) users_7_days,
SAFE_CAST(users_14_days AS INT64) users_14_days,
SAFE_CAST(users_28_days AS INT64) users_28_days,
SAFE_CAST(users_30_days AS INT64) users_30_days,
SAFE_CAST(new_users AS INT64) new_users,
SAFE_CAST(active_users AS INT64) active_users
FROM basedosdados-dev.br_bd_indicadores_staging.website_user AS t