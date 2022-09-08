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

CREATE VIEW basedosdados-dev.br_mec_prouni.microdados AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(cpf AS STRING) cpf,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(raca_cor AS STRING) raca_cor,
SAFE_CAST(data_nascimento AS DATE) data_nascimento,
SAFE_CAST(beneficiario_deficiente AS INT64) beneficiario_deficiente,
SAFE_CAST(id_ies AS STRING) id_ies,
SAFE_CAST(campus AS STRING) campus,
SAFE_CAST(nome_municipio_ies AS STRING) nome_municipio_ies,
SAFE_CAST(curso AS STRING) curso,
SAFE_CAST(turno_curso AS STRING) turno_curso,
SAFE_CAST(tipo_bolsa AS STRING) tipo_bolsa,
SAFE_CAST(modalidade_ensino AS STRING) modalidade_ensino
FROM basedosdados-dev.br_mec_prouni_staging.microdados AS t