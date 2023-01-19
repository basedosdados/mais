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

CREATE VIEW basedosdados-dev.world_wb_wwbi.country_finance AS
SELECT 
SAFE_CAST(country_name AS STRING) country_name,
SAFE_CAST(country_code AS STRING) country_code,
SAFE_CAST(currency_unit AS STRING) currency_unit,
SAFE_CAST(special_note AS STRING) special_note,
SAFE_CAST(region AS STRING) region,
SAFE_CAST(income_group AS STRING) income_group,
SAFE_CAST(national_accounts_base_year AS STRING) national_accounts_base_year,
SAFE_CAST(national_accounts_reference_year AS INT64) national_accounts_reference_year,
SAFE_CAST(lending_category AS STRING) lending_category,
SAFE_CAST(other_groups AS STRING) other_groups,
SAFE_CAST(sna_price_valuation AS STRING) sna_price_valuation,
SAFE_CAST(sna_methodology AS STRING) sna_methodology,
SAFE_CAST(imf_dissemination_standard AS STRING) imf_dissemination_standard,
SAFE_CAST(trade_system AS STRING) trade_system,
SAFE_CAST(balance_payments_manual AS STRING) balance_payments_manual,
SAFE_CAST(external_debt_reporting AS STRING) external_debt_reporting,
SAFE_CAST(government_accounting AS STRING) government_accounting,
SAFE_CAST(population_census AS STRING) population_census,
SAFE_CAST(agricultural_census AS STRING) agricultural_census,
SAFE_CAST(household_survey AS STRING) household_survey,
SAFE_CAST(industrial_date AS INT64) industrial_date,
SAFE_CAST(source_income_expenditure AS STRING) source_income_expenditure,
SAFE_CAST(vital_registration_complete AS INT64) vital_registration_complete
FROM basedosdados-dev.world_wb_wwbi_staging.country_finance AS t