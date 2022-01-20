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

CREATE VIEW basedosdados-dev.br_ms_cnes.equipamento AS
SELECT
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(sigla_uf AS STRING) sigla_uf, 
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_municipio_6 AS STRING) id_municipio_6,
SAFE_CAST(id_estabelecimento_cnes AS STRING) id_estabelecimento_cnes,
SAFE_CAST(tipo_equipamento AS STRING) tipo_equipamento,
SAFE_CAST(equipamento AS STRING) equipamento,
SAFE_CAST(quantidade_existente_equipamento AS INT64) quantidade_existente_equipamento,
SAFE_CAST(quantidade_uso_equipamento AS INT64) quantidade_uso_equipamento,
SAFE_CAST(disponibilidade_sus  AS STRING) disponibilidade_sus ,
SAFE_CAST(equipamento_nao_disponivel_sus AS STRING) equipamento_nao_disponivel_sus
FROM basedosdados-dev.br_ms_cnes_staging.equipamento AS t