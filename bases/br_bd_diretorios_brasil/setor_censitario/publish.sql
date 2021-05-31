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
CREATE VIEW basedosdados-dev.br_bd_diretorios_brasil.setor_censitario AS
SELECT
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(id_setor_censitario AS STRING) id_setor_censitario,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_rm AS STRING) id_rm,
SAFE_CAST(nome_rm AS STRING) nome_rm,
SAFE_CAST(id_distrito AS STRING) id_distrito,
SAFE_CAST(nome_distrito AS STRING) nome_distrito,
SAFE_CAST(id_subdistrito AS STRING) id_subdistrito,
SAFE_CAST(nome_subdistrito AS STRING) nome_subdistrito,
SAFE_CAST(id_bairro AS STRING) id_bairro,
SAFE_CAST(nome_bairro AS STRING) nome_bairro,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(situacao_setor AS STRING) situacao_setor,
SAFE_CAST(tipo_setor AS STRING) tipo_setor
FROM basedosdados-dev.br_bd_diretorios_brasil_staging.setor_censitario AS t
