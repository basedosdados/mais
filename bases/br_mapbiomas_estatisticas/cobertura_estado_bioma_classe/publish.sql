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
CREATE VIEW basedosdados-dev.br_mapbiomas_estatisticas.cobertura_estado_bioma_classe AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(estado_abrev AS STRING) sigla_uf,
SAFE_CAST(bioma AS STRING) bioma,
SAFE_CAST(id_classe AS STRING) id_classe,
SAFE_CAST(tipo_dado AS STRING) tipo_dado,
SAFE_CAST(nivel_0 AS STRING) nivel_0,
SAFE_CAST(nivel_1 AS STRING) nivel_1,
SAFE_CAST(nivel_2 AS STRING) nivel_2,
SAFE_CAST(nivel_3 AS STRING) nivel_3,
SAFE_CAST(nivel_4 AS STRING) nivel_4,
SAFE_CAST(area AS NUMERIC) area
from basedosdados-dev.br_mapbiomas_estatisticas_staging.cobertura_estado_bioma_classe as t