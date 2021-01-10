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

CREATE VIEW basedosdados.br_ponte_indicadores.censo2010_populacao_idade AS
SELECT 
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(ordem AS INT64) ordem,
SAFE_CAST(grupo_idade AS STRING) grupo_idade,
SAFE_CAST(populacao_homens AS INT64) populacao_homens,
SAFE_CAST(populacao_mulheres AS INT64) populacao_mulheres
from basedosdados-staging.br_ponte_indicadores_staging.censo2010_populacao_idade as t