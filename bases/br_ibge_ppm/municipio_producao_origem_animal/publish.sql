
CREATE VIEW basedosdados.br_ibge_ppm.municipio_producao_origem_animal AS
SELECT 
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(tipo_de_produto_origem_animal AS STRING) tipo_de_produto_origem_animal,
SAFE_CAST(producao AS STRING) producao,
SAFE_CAST(valor_producao AS STRING) valor_producao,
SAFE_CAST(valor_producao_percentual_total_geral AS STRING) valor_producao_percentual_total_geral,
SAFE_CAST(moeda AS STRING) moeda
from basedosdados-dev.br_ibge_ppm_staging.municipio_producao_origem_animal as t