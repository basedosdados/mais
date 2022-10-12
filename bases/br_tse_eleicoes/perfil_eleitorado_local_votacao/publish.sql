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

CREATE VIEW basedosdados-dev.br_tse_eleicoes.perfil_eleitorado_local_votacao AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(turno AS INT64) turno,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_municipio_tse AS STRING) id_municipio_tse,
SAFE_CAST(zona AS INT64) zona,
SAFE_CAST(secao AS INT64) secao,
SAFE_CAST(tipo_secao_agregada AS STRING) tipo_secao_agregada,
SAFE_CAST(numero AS STRING) numero,
SAFE_CAST(nome AS STRING) nome,
SAFE_CAST(tipo AS STRING) tipo,
SAFE_CAST(endereco AS STRING) endereco,
SAFE_CAST(bairro AS STRING) bairro,
SAFE_CAST(cep AS STRING) cep,
SAFE_CAST(telefone AS STRING) telefone,
SAFE_CAST(latitude AS FLOAT64) latitude,
SAFE_CAST(longitude AS FLOAT64) longitude,
SAFE_CAST(situacao AS STRING) situacao,
SAFE_CAST(situacao_zona AS STRING) situacao_zona,
SAFE_CAST(situacao_secao AS STRING) situacao_secao,
SAFE_CAST(situacao_localidade AS STRING) situacao_localidade,
SAFE_CAST(situacao_secao_acessibilidade AS STRING) situacao_secao_acessibilidade,
SAFE_CAST(quantidade_eleitores AS INT64) quantidade_eleitores,
SAFE_CAST(quantidade_eleitores_eleicao AS INT64) quantidade_eleitores_eleicao
FROM basedosdados-dev.br_tse_eleicoes_staging.perfil_eleitorado_local_votacao AS t