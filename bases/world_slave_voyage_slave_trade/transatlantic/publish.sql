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

CREATE VIEW basedosdados-dev.world_slave_voyage_slave_trade.transatlantic AS
SELECT 
SAFE_CAST(id_voyage AS STRING) id_voyage,
SAFE_CAST(date_vessel_departed_captives AS DATE) date_vessel_departed_captives,
SAFE_CAST(date_vessel_departed_homeport AS DATE) date_vessel_departed_homeport,
SAFE_CAST(date_vessel_arrived_captives AS DATE) date_vessel_arrived_captives,
SAFE_CAST(total_embarked AS INT64) total_embarked,
SAFE_CAST(total_disembarked AS INT64) total_disembarked,
SAFE_CAST(crew_death_during_voyage AS INT64) crew_death_during_voyage,
SAFE_CAST(crew_first_landing_captives AS INT64) crew_first_landing_captives,
SAFE_CAST(crew_voyage_outset AS INT64) crew_voyage_outset,
SAFE_CAST(captain_name AS STRING) captain_name,
SAFE_CAST(first_place_captives_landed AS STRING) first_place_captives_landed,
SAFE_CAST(first_place_captives_purchased AS STRING) first_place_captives_purchased,
SAFE_CAST(gun_mounted AS INT64) gun_mounted,
SAFE_CAST(year_arrival_port_disembarkation AS INT64) year_arrival_port_disembarkation,
SAFE_CAST(voyage_duration AS INT64) voyage_duration,
SAFE_CAST(place_vessel_voyage_began AS STRING) place_vessel_voyage_began,
SAFE_CAST(principal_place_captives_purchased AS STRING) principal_place_captives_purchased,
SAFE_CAST(principal_place_captives_landed AS STRING) principal_place_captives_landed,
SAFE_CAST(captive_death_during_crossing AS INT64) captive_death_during_crossing,
SAFE_CAST(percentage_captives_died_during_crossing AS FLOAT64) percentage_captives_died_during_crossing,
SAFE_CAST(flag_vessel AS STRING) flag_vessel,
SAFE_CAST(percent_boys AS FLOAT64) percent_boys,
SAFE_CAST(percent_children AS FLOAT64) percent_children,
SAFE_CAST(percent_girls AS FLOAT64) percent_girls,
SAFE_CAST(percent_males AS FLOAT64) percent_males,
SAFE_CAST(percent_men AS FLOAT64) percent_men,
SAFE_CAST(percent_women AS FLOAT64) percent_women,
SAFE_CAST(sterling_cash_price_jamaica AS FLOAT64) sterling_cash_price_jamaica,
SAFE_CAST(duration_captives_crossing AS INT64) duration_captives_crossing,
SAFE_CAST(captives_carried_first_port AS INT64) captives_carried_first_port,
SAFE_CAST(captives_carried_second_port AS INT64) captives_carried_second_port,
SAFE_CAST(captives_carried_third_port AS INT64) captives_carried_third_port,
SAFE_CAST(captives_landed_first_port AS INT64) captives_landed_first_port,
SAFE_CAST(captives_landed_second_port AS INT64) captives_landed_second_port,
SAFE_CAST(captives_landed_third_port AS INT64) captives_landed_third_port,
SAFE_CAST(captives_intended_purchased_first_place AS INT64) captives_intended_purchased_first_place,
SAFE_CAST(outcome_voyage_owner AS STRING) outcome_voyage_owner,
SAFE_CAST(outcome_voyage_ship_captured AS STRING) outcome_voyage_ship_captured,
SAFE_CAST(outcome_voyage_captives AS STRING) outcome_voyage_captives,
SAFE_CAST(particular_outcome_voyage AS STRING) particular_outcome_voyage,
SAFE_CAST(vessel_owner AS STRING) vessel_owner,
SAFE_CAST(place_registered AS STRING) place_registered,
SAFE_CAST(year_registered AS INT64) year_registered,
SAFE_CAST(resistance AS STRING) resistance,
SAFE_CAST(rig_type_vessel AS STRING) rig_type_vessel,
SAFE_CAST(vessel_name AS STRING) vessel_name,
SAFE_CAST(date_captive_embarkation_began AS DATE) date_captive_embarkation_began,
SAFE_CAST(place_constructed AS INT64) place_constructed,
SAFE_CAST(date_vessel_voyage_began AS DATE) date_vessel_voyage_began,
SAFE_CAST(date_vessel_arrived_homeport AS DATE) date_vessel_arrived_homeport,
SAFE_CAST(year_constructed AS STRING) year_constructed,
SAFE_CAST(voyage_itinerary_imputed_port_began AS STRING) voyage_itinerary_imputed_port_began,
SAFE_CAST(voyage_itinerary_imputed_slave_purchase AS STRING) voyage_itinerary_imputed_slave_purchase,
SAFE_CAST(voyage_itinerary_imputed_slave_disembarkation_place AS STRING) voyage_itinerary_imputed_slave_disembarkation_place,
SAFE_CAST(data_source AS STRING) data_source
FROM basedosdados-dev.world_slave_voyage_slave_trade_staging.transatlantic AS t