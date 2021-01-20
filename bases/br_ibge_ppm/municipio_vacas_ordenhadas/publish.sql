CREATE VIEW basedosdados.br_ibge_ppm.municipio_vacas_ordenhadas AS
SELECT 
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(vacas_ordenhadas AS STRING) vacas_ordenhadas
from basedosdados-dev.br_ibge_ppm_staging.municipio_vacas_ordenhadas as t