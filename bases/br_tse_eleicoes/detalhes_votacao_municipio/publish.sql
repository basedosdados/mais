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
SELECT 
SAFE_CAST(turno AS STRING) turno,
SAFE_CAST(tipo_eleicao AS STRING) tipo_eleicao,
SAFE_CAST(id_municipio_TSE AS STRING) id_municipio_TSE,
SAFE_CAST(cargo AS STRING) cargo,
SAFE_CAST(aptos AS STRING) aptos,
SAFE_CAST(secoes AS STRING) secoes,
SAFE_CAST(secoes_agregadas AS STRING) secoes_agregadas,
SAFE_CAST(aptos_tot AS STRING) aptos_tot,
SAFE_CAST(secoes_tot AS STRING) secoes_tot,
SAFE_CAST(comparecimento AS STRING) comparecimento,
SAFE_CAST(abstencoes AS STRING) abstencoes,
SAFE_CAST(votos_validos AS STRING) votos_validos,
SAFE_CAST(votos_brancos AS STRING) votos_brancos,
SAFE_CAST(votos_nulos AS STRING) votos_nulos,
SAFE_CAST(votos_legenda AS STRING) votos_legenda,
SAFE_CAST(prop_comparecimento AS STRING) prop_comparecimento,
SAFE_CAST(prop_votos_validos AS STRING) prop_votos_validos,
SAFE_CAST(prop_votos_brancos AS STRING) prop_votos_brancos,
SAFE_CAST(prop_votos_nulos AS STRING) prop_votos_nulos,
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(estado_abrev AS STRING) estado_abrev
from basedosdados-staging.br_tse_eleicoes_staging.detalhes_votacao_municipio as t