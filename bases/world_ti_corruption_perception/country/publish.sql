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

CREATE VIEW basedosdados-dev.world_ti_corruption_perception.country AS
SELECT 
SAFE_CAST(year AS INT64) year,
SAFE_CAST(country_id_iso_3 AS STRING) country_id_iso_3,
SAFE_CAST(country AS STRING) country,
SAFE_CAST(corruption_index_score AS FLOAT64) corruption_index_score,
SAFE_CAST(rank AS INT64) rank,
SAFE_CAST(standard_error AS FLOAT64) standard_error,
SAFE_CAST(number_sources AS INT64) number_sources,
SAFE_CAST(lower_ci AS FLOAT64) lower_ci,
SAFE_CAST(upper_ci AS FLOAT64) upper_ci,
SAFE_CAST(african_development_bank AS INT64) african_development_bank,
SAFE_CAST(bertelsmann_foundation_sustainable_index AS INT64) bertelsmann_foundation_sustainable_index,
SAFE_CAST(bertelsmann_foundation_transformation_index AS INT64) bertelsmann_foundation_transformation_index,
SAFE_CAST(economist_intelligence_ratings AS INT64) economist_intelligence_ratings,
SAFE_CAST(freedom_house_nations_transit AS INT64) freedom_house_nations_transit,
SAFE_CAST(global_insight_country_risk_ratings AS INT64) global_insight_country_risk_ratings,
SAFE_CAST(world_competitiveness_yearbook AS INT64) world_competitiveness_yearbook,
SAFE_CAST(asia_risk_guide_perc AS INT64) asia_risk_guide_perc,
SAFE_CAST(international_contry_risk_guide AS INT64) international_contry_risk_guide,
SAFE_CAST(varieties_democracy_project AS INT64) varieties_democracy_project,
SAFE_CAST(world_bank_country_policy_institutional_assessment AS INT64) world_bank_country_policy_institutional_assessment,
SAFE_CAST(world_economic_forum AS INT64) world_economic_forum,
SAFE_CAST(world_justice_project_rule_law_index AS INT64) world_justice_project_rule_law_index
FROM basedosdados-dev.world_ti_corruption_perception_staging.country AS t