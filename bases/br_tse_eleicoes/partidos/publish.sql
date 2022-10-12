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

CREATE VIEW basedosdados-dev.br_tse_eleicoes.partidos AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(turno AS INT64) turno,
SAFE_CAST(tipo_eleicao AS STRING) tipo_eleicao,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_municipio_tse AS STRING) id_municipio_tse,
SAFE_CAST(cargo AS STRING) cargo,
SAFE_CAST(numero AS STRING) numero,
SAFE_CAST(sigla AS STRING) sigla,
SAFE_CAST(nome AS STRING) nome,
SAFE_CAST(tipo_agremiacao AS STRING) tipo_agremiacao,
SAFE_CAST(sequencial_coligacao AS STRING) sequencial_coligacao,
SAFE_CAST(nome_coligacao AS STRING) nome_coligacao,
SAFE_CAST(composicao_coligacao AS STRING) composicao_coligacao,
SAFE_CAST(numero_federacao AS STRING) numero_federacao,
SAFE_CAST(nome_federacacao AS STRING) nome_federacacao,
SAFE_CAST(sigla_federacao AS STRING) sigla_federacao,
SAFE_CAST(composicao_federacao AS STRING) composicao_federacao,
SAFE_CAST(situacao_legenda AS STRING) situacao_legenda
FROM basedosdados-dev.br_tse_eleicoes_staging.partidos AS t