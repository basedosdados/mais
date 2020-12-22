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
CREATE VIEW basedosdados.br_mc_auxilio_emergencial.microdados AS
SELECT
SAFE_CAST(mes AS STRING) mes,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(nis_beneficiario AS STRING) nis_beneficiario,
SAFE_CAST(cpf_beneficiario AS STRING) cpf_beneficiario,
SAFE_CAST(nome_beneficiario AS STRING) nome_beneficiario,
SAFE_CAST(nis_responsavel AS STRING) nis_responsavel,
SAFE_CAST(cpf_responsavel AS STRING) cpf_responsavel,
SAFE_CAST(nome_responsavel AS STRING) nome_responsavel,
SAFE_CAST(enquadramento AS STRING) enquadramento,
SAFE_CAST(parcela AS STRING) parcela,
SAFE_CAST(observacao AS STRING) observacao,
SAFE_CAST(valor_beneficio AS FLOAT64) valor_beneficio
from basedosdados-staging.br_mc_auxilio_emergencial_staging.microdados as t