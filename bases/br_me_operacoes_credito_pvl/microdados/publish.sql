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

CREATE VIEW basedosdados-dev.br_me_operacoes_credito_pvl.microdados AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(data AS DATE) data,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_estado AS STRING) id_estado,
SAFE_CAST(id_pvl AS STRING) id_pvl,
SAFE_CAST(status AS STRING) status,
SAFE_CAST(instituicao_responsavel AS STRING) instituicao_responsavel,
SAFE_CAST(tipo_interessado AS STRING) tipo_interessado,
SAFE_CAST(interessado AS STRING) interessado,
SAFE_CAST(tipo_operacao AS STRING) tipo_operacao,
SAFE_CAST(tipo_credor AS STRING) tipo_credor,
SAFE_CAST(credor AS STRING) credor,
SAFE_CAST(moeda AS STRING) moeda,
SAFE_CAST(valor_operacao AS FLOAT64) valor_operacao
FROM basedosdados-dev.br_me_operacoes_credito_pvl_staging.microdados AS t