
CREATE VIEW basedosdados.br_ibge_ppm.municipio_producao_origem_animal AS
SELECT 
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(tipo_de_produto_origem_animal AS STRING) tipo_de_produto_origem_animal,
SAFE_CAST(producao AS INT64) producao,
SAFE_CAST(valor_producao AS INT64) valor_producao,
SAFE_CAST(valor_producao_percentual_total_geral AS FLOAT64.) valor_producao_percentual_total_geral,
SAFE_CAST(moeda AS STRING) moeda
from basedosdados-dev.br_ibge_ppm_staging.municipio_producao_origem_animal as t