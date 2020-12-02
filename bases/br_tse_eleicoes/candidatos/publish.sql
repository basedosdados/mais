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
CREATE VIEW basedosdados.br_tse_eleicoes.candidatos AS
SELECT
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(tipo_eleicao AS STRING) tipo_eleicao,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio_tse AS INT64) id_municipio_tse,
SAFE_CAST(id_candidato_bd AS INT64) id_candidato_bd,
SAFE_CAST(cpf AS STRING) cpf,
SAFE_CAST(titulo_eleitoral AS STRING) titulo_eleitoral,
SAFE_CAST(sequencial_candidato AS INT64) sequencial_candidato,
SAFE_CAST(numero_candidato AS INT64) numero_candidato,
SAFE_CAST(nome_candidato AS STRING) nome_candidato,
SAFE_CAST(nome_urna_candidato AS STRING) nome_urna_candidato,
SAFE_CAST(numero_partido AS INT64) numero_partido,
SAFE_CAST(sigla_partido AS STRING) sigla_partido,
SAFE_CAST(cargo AS STRING) cargo,
SAFE_CAST(situacao AS STRING) situacao,
SAFE_CAST(ocupacao AS STRING) ocupacao,
SAFE_CAST(data_nasc AS DATE) data_nasc,
SAFE_CAST(idade AS INT64) idade,
SAFE_CAST(genero AS STRING) genero,
SAFE_CAST(instrucao AS STRING) instrucao,
SAFE_CAST(estado_civil AS STRING) estado_civil,
SAFE_CAST(nacionalidade AS STRING) nacionalidade,
SAFE_CAST(sigla_uf_nasc AS STRING) sigla_uf_nasc,
SAFE_CAST(municipio_nasc AS STRING) municipio_nasc,
SAFE_CAST(email AS STRING) email,
SAFE_CAST(raca AS STRING) raca
from basedosdados-staging.br_tse_eleicoes_staging.candidatos as t