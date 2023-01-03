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

CREATE VIEW basedosdados-dev.br_me_cnpj.empresas AS
SELECT 
SAFE_CAST(data AS DATE) data,
SAFE_CAST(cnpj_basico AS STRING) cnpj_basico,
SAFE_CAST(razao_social AS STRING) razao_social,
SAFE_CAST(natureza_juridica AS STRING) natureza_juridica,
SAFE_CAST(qualificacao_responsavel AS STRING) qualificacao_responsavel,
SAFE_CAST(capital_social AS FLOAT64) capital_social,
SAFE_CAST(porte AS STRING) porte,
SAFE_CAST(ente_federativo AS STRING) ente_federativo
FROM basedosdados-dev.br_me_cnpj_staging.empresas AS t