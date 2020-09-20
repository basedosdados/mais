/*
Query to publish table.

This is the place to fix types, merge with other tables or create new
support columns.

Any column defined here must exists at `table_config.yaml`.
*/
SELECT 
id_munic_7,
id_munic_6,
id_TSE,
id_RF,
id_BCB,
municipio,
id_comarca,
id_regiao_saude,
regiao_saude,
id_estado,
estado_abrev,
estado,
existia_1991,
existia_2000,
existia_2010,
key1,
key2
from basedosdados.pytest_staging.pytest_partitioned