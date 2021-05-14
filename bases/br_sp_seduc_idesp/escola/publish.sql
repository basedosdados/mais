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

CREATE VIEW basedosdados-dev.br_sp_seduc_idesp.escola AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(id_escola AS INT64) id_escola,
SAFE_CAST(id_escola_sp AS INT64) id_escola_sp,
SAFE_CAST(nota_idesp_ef_iniciais AS FLOAT64) nota_idesp_ef_iniciais,
SAFE_CAST(nota_idesp_ef_finais AS FLOAT64) nota_idesp_ef_finais,
SAFE_CAST(nota_idesp_em AS FLOAT64) nota_idesp_em
from basedosdados-dev.br_sp_seduc_idesp_staging.escola as t