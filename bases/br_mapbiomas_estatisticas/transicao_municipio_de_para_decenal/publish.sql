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
CREATE VIEW basedosdados-dev.br_mapbiomas_estatisticas.transicao_municipio_de_para_decenal AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(estado_abrev AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(de_id_classe AS STRING) de_id_classe,
SAFE_CAST(de_nivel_0 AS STRING) de_nivel_0,
SAFE_CAST(de_nivel_1 AS STRING) de_nivel_1,
SAFE_CAST(de_nivel_2 AS STRING) de_nivel_2,
SAFE_CAST(de_nivel_3 AS STRING) de_nivel_3,
SAFE_CAST(de_nivel_4 AS STRING) de_nivel_4,
SAFE_CAST(para_id_classe AS STRING) para_id_classe,
SAFE_CAST(para_nivel_0 AS STRING) para_nivel_0,
SAFE_CAST(para_nivel_1 AS STRING) para_nivel_1,
SAFE_CAST(para_nivel_2 AS STRING) para_nivel_2,
SAFE_CAST(para_nivel_3 AS STRING) para_nivel_3,
SAFE_CAST(para_nivel_4 AS STRING) para_nivel_4,
SAFE_CAST(area AS FLOAT64) area
from basedosdados-dev.br_mapbiomas_estatisticas_staging.transicao_municipio_de_para_decenal as t