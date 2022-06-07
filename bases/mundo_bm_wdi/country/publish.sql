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

CREATE VIEW basedosdados-dev.mundo_bm_wdi.country AS
SELECT 
SAFE_CAST(region AS STRING) region,
SAFE_CAST(country_id AS STRING) country_id,
SAFE_CAST(country_long_name AS STRING) country_long_name,
SAFE_CAST(country_id_iso_2 AS STRING) country_id_iso_2,
SAFE_CAST(currency_unit AS STRING) currency_unit,
SAFE_CAST(special_notes AS STRING) special_notes,
SAFE_CAST(income_group AS STRING) income_group,
SAFE_CAST(national_accounts_base_year AS STRING) national_accounts_base_year,
SAFE_CAST(national_accounts_reference_year AS INT64) national_accounts_reference_year,
SAFE_CAST(sna_price_valuation AS STRING) sna_price_valuation,
SAFE_CAST(lending_category AS STRING) lending_category,
SAFE_CAST(other_groups AS STRING) other_groups,
SAFE_CAST(system_of_national_accounts AS STRING) system_of_national_accounts,
SAFE_CAST(alternative_conversion_factor AS STRING) alternative_conversion_factor,
SAFE_CAST(ppp_survey_year AS INT64) ppp_survey_year,
SAFE_CAST(balance_of_payments_manual_in_use AS STRING) balance_of_payments_manual_in_use,
SAFE_CAST(external_debt_reporting_status AS STRING) external_debt_reporting_status,
SAFE_CAST(system_of_trade AS STRING) system_of_trade,
SAFE_CAST(government_accounting_concept AS STRING) government_accounting_concept,
SAFE_CAST(imf_data_dissemination_standard AS STRING) imf_data_dissemination_standard,
SAFE_CAST(latest_population_census AS STRING) latest_population_census,
SAFE_CAST(latest_household_survey AS STRING) latest_household_survey,
SAFE_CAST(most_recent_income_and_expenditure_data AS STRING) most_recent_income_and_expenditure_data,
SAFE_CAST(vital_registration_complete AS STRING) vital_registration_complete,
SAFE_CAST(latest_agricultural_census AS STRING) latest_agricultural_census,
SAFE_CAST(latest_industrial_data AS INT64) latest_industrial_data,
SAFE_CAST(latest_trade_data AS INT64) latest_trade_data
FROM basedosdados-dev.mundo_bm_wdi_staging.country AS t