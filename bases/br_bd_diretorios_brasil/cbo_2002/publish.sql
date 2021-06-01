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
CREATE VIEW basedosdados-dev.br_bd_diretorios_brasil.cbo_2002 AS
SELECT 
SAFE_CAST(cbo_2002 AS STRING) cbo_2002,
SAFE_CAST(descricao AS STRING) descricao,
SAFE_CAST(familia AS STRING) familia,
SAFE_CAST(descricao_familia AS STRING) descricao_familia,
SAFE_CAST(subgrupo AS STRING) subgrupo,
SAFE_CAST(descricao_subgrupo AS STRING) descricao_subgrupo,
SAFE_CAST(subgrupo_principal AS STRING) subgrupo_principal,
SAFE_CAST(descricao_subgrupo_principal AS STRING) descricao_subgrupo_principal,
SAFE_CAST(grande_grupo AS STRING) grande_grupo,
SAFE_CAST(descricao_grande_grupo AS STRING) descricao_grande_grupo
FROM basedosdados-dev.br_bd_diretorios_brasil_staging.cbo_2002 AS t