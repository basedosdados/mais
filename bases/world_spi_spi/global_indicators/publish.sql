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

CREATE VIEW basedosdados-dev.world_spi_spi.global_indicators AS
SELECT 
SAFE_CAST(year AS INT64) year,
SAFE_CAST(country AS STRING) country,
SAFE_CAST(country_id_iso_3 AS STRING) country_id_iso_3,
SAFE_CAST(rank AS INT64) rank,
SAFE_CAST(status AS STRING) status,
SAFE_CAST(social_progress_index AS FLOAT64) social_progress_index,
SAFE_CAST(basic_human_needs AS FLOAT64) basic_human_needs,
SAFE_CAST(wellbeing AS FLOAT64) wellbeing,
SAFE_CAST(opportunity AS FLOAT64) opportunity,
SAFE_CAST(nutrition_basic_medical_care AS FLOAT64) nutrition_basic_medical_care,
SAFE_CAST(water_sanitation AS FLOAT64) water_sanitation,
SAFE_CAST(shelter AS FLOAT64) shelter,
SAFE_CAST(personal_safety AS FLOAT64) personal_safety,
SAFE_CAST(access_basic_knowledge AS FLOAT64) access_basic_knowledge,
SAFE_CAST(access_infomation_communication AS FLOAT64) access_infomation_communication,
SAFE_CAST(health_wellness AS FLOAT64) health_wellness,
SAFE_CAST(environmental_quality AS FLOAT64) environmental_quality,
SAFE_CAST(personal_rights AS FLOAT64) personal_rights,
SAFE_CAST(personal_freedom_choice AS FLOAT64) personal_freedom_choice,
SAFE_CAST(inclusiveness AS FLOAT64) inclusiveness,
SAFE_CAST(access_advanced_education AS FLOAT64) access_advanced_education,
SAFE_CAST(child_stunting AS FLOAT64) child_stunting,
SAFE_CAST(infectious_diseases AS FLOAT64) infectious_diseases,
SAFE_CAST(maternal_mortality_rate AS FLOAT64) maternal_mortality_rate,
SAFE_CAST(child_mortality_rate AS FLOAT64) child_mortality_rate,
SAFE_CAST(undernourishment AS FLOAT64) undernourishment,
SAFE_CAST(diet_low_fruit_vegetable AS FLOAT64) diet_low_fruit_vegetable,
SAFE_CAST(unsafe_water_sanitation_hygiene AS FLOAT64) unsafe_water_sanitation_hygiene,
SAFE_CAST(access_improved_sanitation AS FLOAT64) access_improved_sanitation,
SAFE_CAST(access_improved_water_source AS FLOAT64) access_improved_water_source,
SAFE_CAST(satisfaction_water_quality AS FLOAT64) satisfaction_water_quality,
SAFE_CAST(household_air_pollution AS FLOAT64) household_air_pollution,
SAFE_CAST(dissatisfaction_housing_affordability AS FLOAT64) dissatisfaction_housing_affordability,
SAFE_CAST(access_electricity AS FLOAT64) access_electricity,
SAFE_CAST(usage_clean_fuels_technology_cooking AS FLOAT64) usage_clean_fuels_technology_cooking,
SAFE_CAST(political_killings_torture AS FLOAT64) political_killings_torture,
SAFE_CAST(interpesoal_violence AS FLOAT64) interpesoal_violence,
SAFE_CAST(transportation_related_injuries AS FLOAT64) transportation_related_injuries,
SAFE_CAST(intimate_partner_violence AS FLOAT64) intimate_partner_violence,
SAFE_CAST(money_stolen AS FLOAT64) money_stolen,
SAFE_CAST(equal_access_quality_education AS FLOAT64) equal_access_quality_education,
SAFE_CAST(population_no_schooling AS FLOAT64) population_no_schooling,
SAFE_CAST(secondary_school_attainment AS FLOAT64) secondary_school_attainment,
SAFE_CAST(primary_school_enrollment AS FLOAT64) primary_school_enrollment,
SAFE_CAST(gender_parity_secondary_attainment AS FLOAT64) gender_parity_secondary_attainment,
SAFE_CAST(alternative_source_information_index AS FLOAT64) alternative_source_information_index,
SAFE_CAST(mobile_telephone_subscription AS FLOAT64) mobile_telephone_subscription,
SAFE_CAST(internet_user AS FLOAT64) internet_user,
SAFE_CAST(access_online_governance AS FLOAT64) access_online_governance,
SAFE_CAST(equal_access_quality_healthcare AS FLOAT64) equal_access_quality_healthcare,
SAFE_CAST(life_expectancy_60 AS FLOAT64) life_expectancy_60,
SAFE_CAST(premature_death_non_communicable_disease AS FLOAT64) premature_death_non_communicable_disease,
SAFE_CAST(access_essential_health_service AS FLOAT64) access_essential_health_service,
SAFE_CAST(satisfaction_availability_quality_healthcare AS FLOAT64) satisfaction_availability_quality_healthcare,
SAFE_CAST(outdoor_air_pollution AS FLOAT64) outdoor_air_pollution,
SAFE_CAST(lead_exposure AS FLOAT64) lead_exposure,
SAFE_CAST(particulate_matter_pollution AS FLOAT64) particulate_matter_pollution,
SAFE_CAST(specie_protection AS FLOAT64) specie_protection,
SAFE_CAST(freedom_religion AS FLOAT64) freedom_religion,
SAFE_CAST(property_rights_women AS FLOAT64) property_rights_women,
SAFE_CAST(freedom_peaceful_assembly AS FLOAT64) freedom_peaceful_assembly,
SAFE_CAST(access_justice AS FLOAT64) access_justice,
SAFE_CAST(freedom_discussion AS FLOAT64) freedom_discussion,
SAFE_CAST(political_right AS FLOAT64) political_right,
SAFE_CAST(freedom_domestic_movement AS FLOAT64) freedom_domestic_movement,
SAFE_CAST(early_marriage AS FLOAT64) early_marriage,
SAFE_CAST(satisfied_demand_contraception AS FLOAT64) satisfied_demand_contraception,
SAFE_CAST(young_not_education_employment_training AS FLOAT64) young_not_education_employment_training,
SAFE_CAST(vulnerable_employment AS FLOAT64) vulnerable_employment,
SAFE_CAST(perception_corruption AS FLOAT64) perception_corruption,
SAFE_CAST(equal_protection_index AS FLOAT64) equal_protection_index,
SAFE_CAST(equal_access_index AS FLOAT64) equal_access_index,
SAFE_CAST(power_distributed_sexual_orientation AS FLOAT64) power_distributed_sexual_orientation,
SAFE_CAST(access_public_service_social_group AS FLOAT64) access_public_service_social_group,
SAFE_CAST(acceptance_gay_lesbian AS FLOAT64) acceptance_gay_lesbian,
SAFE_CAST(discrimination_violence_against_minority AS FLOAT64) discrimination_violence_against_minority,
SAFE_CAST(academic_freedom AS FLOAT64) academic_freedom,
SAFE_CAST(women_advanced_education AS FLOAT64) women_advanced_education,
SAFE_CAST(expected_year_tertiary_schooling AS FLOAT64) expected_year_tertiary_schooling,
SAFE_CAST(citable_document AS FLOAT64) citable_document,
SAFE_CAST(quality_weighted_university AS FLOAT64) quality_weighted_university
FROM basedosdados-dev.world_spi_spi_staging.global_indicators AS t