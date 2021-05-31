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
CREATE VIEW basedosdados-dev.br_bd_diretorios_brasil.cnae_1 AS
SELECT 
SAFE_CAST(cnae_1 AS STRING) cnae_1,
SAFE_CAST(descricao AS STRING) descricao,
SAFE_CAST(grupo AS STRING) grupo,
SAFE_CAST(descricao_grupo AS STRING) descricao_grupo,
SAFE_CAST(divisao AS STRING) divisao,
SAFE_CAST(descricao_divisao AS STRING) descricao_divisao,
SAFE_CAST(secao AS STRING) secao,
SAFE_CAST(descricao_secao AS STRING) descricao_secao
FROM basedosdados-dev.br_bd_diretorios_brasil_staging.cnae_1 AS t