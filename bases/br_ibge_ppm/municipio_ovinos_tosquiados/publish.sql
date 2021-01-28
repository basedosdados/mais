
CREATE VIEW basedosdados.br_ibge_ppm.municipio_ovinos_tosquiados AS
SELECT 
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(ovinos_tosquiados AS INT64) ovinos_tosquiados
from basedosdados-dev.br_ibge_ppm_staging.municipio_ovinos_tosquiados as t