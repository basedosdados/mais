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

CREATE VIEW basedosdados.br_bd_diretorios_brasil.setor_censitario AS
SELECT 
SAFE_CAST(id_setor_censitario AS INT64) id_setor_censitario,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(id_rm AS INT64) id_rm,
SAFE_CAST(nome_rm AS STRING) nome_rm,
SAFE_CAST(id_distrito AS INT64) id_distrito,
SAFE_CAST(nome_distrito AS STRING) nome_distrito,
SAFE_CAST(id_subdistrito AS INT64) id_subdistrito,
SAFE_CAST(nome_subdistrito AS STRING) nome_subdistrito,
SAFE_CAST(id_bairro AS INT64) id_bairro,
SAFE_CAST(nome_bairro AS STRING) nome_bairro,
SAFE_CAST(situacao_setor AS INT64) situacao_setor,
SAFE_CAST(tipo_setor AS INT64) tipo_setor
from basedosdados-staging.br_bd_diretorios_brasil_staging.setor_censitario as t