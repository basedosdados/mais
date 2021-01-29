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

CREATE VIEW basedosdados.br_ibge_ppm.producao_origem_animal AS
SELECT 
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(tipo_de_produto_origem_animal AS STRING) tipo_de_produto_origem_animal,
SAFE_CAST(producao AS INT64) producao,
SAFE_CAST(valor_producao AS INT64) valor_producao,
SAFE_CAST(valor_producao_percentual_total_geral AS FLOAT64) valor_producao_percentual_total_geral,
SAFE_CAST(moeda AS STRING) moeda
from basedosdados-dev.br_ibge_ppm_staging.producao_origem_animal as t