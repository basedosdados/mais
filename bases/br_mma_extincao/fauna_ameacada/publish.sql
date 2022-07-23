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

CREATE VIEW basedosdados-dev.br_mma_extincao.fauna_ameacada AS
SELECT 
SAFE_CAST(ordem AS STRING) ordem,
SAFE_CAST(familia AS STRING) familia,
SAFE_CAST(especie_ou_subespecie AS STRING) especie_ou_subespecie,
SAFE_CAST(categoria AS STRING) categoria,
SAFE_CAST(lista_2014 AS INT64) lista_2014
FROM basedosdados-dev.br_mma_extincao_staging.fauna_ameacada AS t