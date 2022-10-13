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

CREATE VIEW basedosdados-dev.br_tse_eleicoes.bens_candidato AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(tipo_eleicao AS STRING) tipo_eleicao,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(sequencial_candidato AS STRING) sequencial_candidato,
SAFE_CAST(id_candidato_bd AS STRING) id_candidato_bd,
SAFE_CAST(id_tipo_item AS STRING) id_tipo_item,
SAFE_CAST(tipo_item AS STRING) tipo_item,
SAFE_CAST(descricao_item AS STRING) descricao_item,
SAFE_CAST(valor_item AS FLOAT64) valor_item
FROM basedosdados-dev.br_tse_eleicoes_staging.bens_candidato AS t