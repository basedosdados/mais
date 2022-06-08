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

CREATE VIEW basedosdados-dev.nl_ug_pwt.microdados AS
SELECT 
SAFE_CAST(year AS INT64) year,
SAFE_CAST(country_id_iso_3 AS STRING) country_id_iso_3,
SAFE_CAST(country AS STRING) country,
SAFE_CAST(currency_unit AS STRING) currency_unit,
SAFE_CAST(population AS FLOAT64) population,
SAFE_CAST(employees AS FLOAT64) employees,
SAFE_CAST(real_gdp_expenditures AS FLOAT64) real_gdp_expenditures,
SAFE_CAST(real_gdp_output AS FLOAT64) real_gdp_output,
SAFE_CAST(current_consumption AS FLOAT64) current_consumption,
SAFE_CAST(current_absorption AS FLOAT64) current_absorption,
SAFE_CAST(current_gdp_expenditures AS FLOAT64) current_gdp_expenditures,
SAFE_CAST(current_gdp_output AS FLOAT64) current_gdp_output,
SAFE_CAST(current_capital_stock AS FLOAT64) current_capital_stock,
SAFE_CAST(real_gdp_na AS FLOAT64) real_gdp_na,
SAFE_CAST(real_consumption_na AS FLOAT64) real_consumption_na,
SAFE_CAST(real_absorption_na AS FLOAT64) real_absorption_na,
SAFE_CAST(real_capital_stock_na AS FLOAT64) real_capital_stock_na,
SAFE_CAST(average_hours_worked AS FLOAT64) average_hours_worked,
SAFE_CAST(average_depreciation AS FLOAT64) average_depreciation,
SAFE_CAST(current_capital_level AS FLOAT64) current_capital_level,
SAFE_CAST(current_tfp_level AS FLOAT64) current_tfp_level,
SAFE_CAST(current_wtfp_level AS FLOAT64) current_wtfp_level,
SAFE_CAST(real_capital_level_na AS FLOAT64) real_capital_level_na,
SAFE_CAST(real_tfp_level_na AS FLOAT64) real_tfp_level_na,
SAFE_CAST(real_wtfp_level_na AS FLOAT64) real_wtfp_level_na,
SAFE_CAST(price_level_ccon AS FLOAT64) price_level_ccon,
SAFE_CAST(price_level_cda AS FLOAT64) price_level_cda,
SAFE_CAST(price_level_cgdpo AS FLOAT64) price_level_cgdpo,
SAFE_CAST(price_level_household AS FLOAT64) price_level_household,
SAFE_CAST(price_level_cf AS FLOAT64) price_level_cf,
SAFE_CAST(price_level_gov AS FLOAT64) price_level_gov,
SAFE_CAST(price_level_x AS FLOAT64) price_level_x,
SAFE_CAST(price_level_m AS FLOAT64) price_level_m,
SAFE_CAST(price_level_capital_stock AS FLOAT64) price_level_capital_stock,
SAFE_CAST(price_level_capital AS FLOAT64) price_level_capital,
SAFE_CAST(real_rate_return AS FLOAT64) real_rate_return,
SAFE_CAST(exchange_rate AS FLOAT64) exchange_rate,
SAFE_CAST(human_capital_index AS FLOAT64) human_capital_index,
SAFE_CAST(indicator_cig AS STRING) indicator_cig,
SAFE_CAST(indicator_xm AS STRING) indicator_xm,
SAFE_CAST(indicator_exchange_rate AS STRING) indicator_exchange_rate,
SAFE_CAST(indicator_outlier AS STRING) indicator_outlier,
SAFE_CAST(indicator_real_rate_return AS STRING) indicator_real_rate_return,
SAFE_CAST(indicator_stat_capacity AS FLOAT64) indicator_stat_capacity,
SAFE_CAST(corr_exp_share AS FLOAT64) corr_exp_share,
SAFE_CAST(current_share_household AS FLOAT64) current_share_household,
SAFE_CAST(current_share_gcf AS FLOAT64) current_share_gcf,
SAFE_CAST(current_share_gov AS FLOAT64) current_share_gov,
SAFE_CAST(current_share_x AS FLOAT64) current_share_x,
SAFE_CAST(current_share_m AS FLOAT64) current_share_m,
SAFE_CAST(current_share_residual_trade AS FLOAT64) current_share_residual_trade,
SAFE_CAST(current_share_labour_gdp_na AS FLOAT64) current_share_labour_gdp_na
FROM basedosdados-dev.nl_ug_pwt_staging.microdados AS t