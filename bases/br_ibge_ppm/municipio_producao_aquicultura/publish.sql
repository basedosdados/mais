
CREATE VIEW basedosdados.br_ibge_ppm.municipio_producao_aquicultura AS
SELECT 
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(tipo_de_produto AS STRING) tipo_de_produto,
SAFE_CAST(producao_aquicultura_quilogramas AS STRING) producao_aquicultura_quilogramas,
SAFE_CAST(valor_producao_mil_reais AS STRING) valor_producao_mil_reais,
SAFE_CAST(valor_producao_percentual_total_geral AS STRING) valor_producao_percentual_total_geral
from basedosdados-dev.br_ibge_ppm_staging.municipio_producao_aquicultura as t