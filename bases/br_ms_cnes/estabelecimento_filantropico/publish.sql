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

CREATE VIEW basedosdados-dev.br_ms_cnes.estabelecimento_filantropico AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_municipio_6 AS STRING) id_municipio_6,
SAFE_CAST(id_estabelecimento_cnes AS STRING) id_estabelecimento_cnes,
SAFE_CAST(ano_competencia_inicial AS INT64) ano_competencia_inicial,
SAFE_CAST(mes_competencia_inicial AS INT64) mes_competencia_inicial,
SAFE_CAST(ano_competencia_final AS INT64) ano_competencia_final,
SAFE_CAST(mes_competencia_final AS INT64) mes_competencia_final,
SAFE_CAST(habilitacao AS STRING) habilitacao,
SAFE_CAST(data_portaria AS DATE) data_portaria,
SAFE_CAST(ano_campo_data_portaria AS INT64) ano_campo_data_portaria,
SAFE_CAST(mes_campo_data_portaria AS INT64) mes_campo_data_portaria
FROM basedosdados-dev.br_ms_cnes_staging.estabelecimento_filantropico AS t