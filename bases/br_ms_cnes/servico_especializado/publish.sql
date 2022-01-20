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

CREATE VIEW basedosdados-dev.br_ms_cnes.servico_especializado AS
SELECT
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_municipio_6 AS STRING) id_municipio_6,
SAFE_CAST(id_estabelecimento_cnes AS STRING) id_estabelecimento_cnes,
SAFE_CAST(servico_especializado AS STRING) servico_especializado,
SAFE_CAST(classificacao AS STRING) classificacao,
SAFE_CAST(servico_especializado_unico AS STRING) servico_especializado_unico,
SAFE_CAST(caracterizacao AS STRING) caracterizacao,
SAFE_CAST(ambulatorial_sus AS STRING) ambulatorial_sus,
SAFE_CAST(ambulatorial_nao_sus AS STRING) ambulatorial_nao_sus,
SAFE_CAST(hospitalar_nao_sus AS STRING) hospitalar_nao_sus,
SAFE_CAST(hospitalar_sus AS STRING) hospitalar_sus,
SAFE_CAST(indicador_servico_especializado_unico AS STRING) indicador_servico_especializado_unico,
SAFE_CAST(quantidade_nacional_estabelecimento_saude_terceiro  AS INT64) quantidade_nacional_estabelecimento_saude_terceiro 
FROM basedosdados-dev.br_ms_cnes_staging.servico_especializado AS t