
CREATE VIEW basedosdados.br_ibge_ppm.municipio_ovinos_tosquiados AS
SELECT 
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(ovinos_tosquiados AS STRING) ovinos_tosquiados
from basedosdados-dev.br_ibge_ppm_staging.municipio_ovinos_tosquiados as t