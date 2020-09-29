/*
Query to publish table.

This is the place to fix types, merge with other tables or create new
support columns.

Any column defined here must exists at `table_config.yaml`.
*/
SELECT 
id_municipio,
id_municipio_6,
id_municipio_TSE,
id_municipio_RF,
id_municipio_BCB,
municipio,
capital_estado,
id_comarca,
id_regiao_saude,
regiao_saude,
id_regiao_imediata,
regiao_imediata,
id_regiao_intermediaria,
regiao_intermediaria,
id_microrregiao,
microrregiao,
id_mesorregiao,
mesorregiao,
id_estado,
estado_abrev,
estado,
regiao,
existia_1991,
existia_2000,
existia_2010
from basedosdados-staging.br_suporte_staging.diretorio_municipios