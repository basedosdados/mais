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

CREATE VIEW basedosdados-dev.br_ms_cnes.profissional AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_estabelecimento_cnes AS STRING) id_estabelecimento_cnes,
SAFE_CAST(id_municipio_residencia AS STRING) id_municipio_residencia,
SAFE_CAST(nome AS STRING) nome,
SAFE_CAST(cns AS STRING) cns,
SAFE_CAST(cbo_2002 AS STRING) cbo_2002,
SAFE_CAST(codigo_registro_conselho AS STRING) codigo_registro_conselho,
SAFE_CAST(codigo_conselho AS STRING) codigo_conselho,
SAFE_CAST(estabelecimento_terceiro AS STRING) estabelecimento_terceiro,
SAFE_CAST(codigo_vinculo AS STRING) codigo_vinculo,
SAFE_CAST(vinculo_contratado_sus AS STRING) vinculo_contratado_sus,
SAFE_CAST(vinculo_autonomo_sus AS STRING) vinculo_autonomo_sus,
SAFE_CAST(vinculo_outros AS STRING) vinculo_outros,
SAFE_CAST(atende_sus AS STRING) atende_sus,
SAFE_CAST(atende_nao_sus AS STRING) atende_nao_sus,
SAFE_CAST(carga_horaria_outros AS INT64) carga_horaria_outros,
SAFE_CAST(carga_horaria_hospitalar AS INT64) carga_horaria_hospitalar,
SAFE_CAST(carga_horaria_ambulatorial AS INT64) carga_horaria_ambulatorial
FROM basedosdados-dev.br_ms_cnes_staging.profissional AS t