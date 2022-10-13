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

CREATE VIEW basedosdados-dev.br_tse_eleicoes.detalhes_votacao_municipio AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(turno AS INT64) turno,
SAFE_CAST(tipo_eleicao AS STRING) tipo_eleicao,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_municipio_tse AS STRING) id_municipio_tse,
SAFE_CAST(cargo AS STRING) cargo,
SAFE_CAST(aptos AS INT64) aptos,
SAFE_CAST(secoes AS INT64) secoes,
SAFE_CAST(secoes_agregadas AS INT64) secoes_agregadas,
SAFE_CAST(aptos_totalizadas AS INT64) aptos_totalizadas,
SAFE_CAST(secoes_totalizadas AS INT64) secoes_totalizadas,
SAFE_CAST(comparecimento AS INT64) comparecimento,
SAFE_CAST(abstencoes AS INT64) abstencoes,
SAFE_CAST(votos_validos AS INT64) votos_validos,
SAFE_CAST(votos_brancos AS INT64) votos_brancos,
SAFE_CAST(votos_nulos AS INT64) votos_nulos,
SAFE_CAST(votos_legenda AS INT64) votos_legenda,
SAFE_CAST(proporcao_comparecimento AS FLOAT64) proporcao_comparecimento,
SAFE_CAST(proporcao_votos_validos AS FLOAT64) proporcao_votos_validos,
SAFE_CAST(proporcao_votos_brancos AS FLOAT64) proporcao_votos_brancos,
SAFE_CAST(proporcao_votos_nulos AS FLOAT64) proporcao_votos_nulos
FROM basedosdados-dev.br_tse_eleicoes_staging.detalhes_votacao_municipio AS t