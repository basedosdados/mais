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

CREATE VIEW basedosdados-dev.br_ibge_pnadc.ano_regiao_grupo_idade AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(id_regiao AS STRING) id_regiao,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(grupo_idade AS STRING) grupo_idade,
SAFE_CAST(populacao AS INT64) populacao
FROM basedosdados-dev.br_ibge_pnadc_staging.ano_regiao_grupo_idade AS t