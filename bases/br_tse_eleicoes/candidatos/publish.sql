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
SAFE_CAST(tipo_eleicao AS STRING) tipo_eleicao,
SAFE_CAST(id_candidato_BD AS STRING) id_candidato_BD,
SAFE_CAST(CPF AS STRING) CPF,
SAFE_CAST(titulo_eleitoral AS STRING) titulo_eleitoral,
SAFE_CAST(sequencial_candidato AS STRING) sequencial_candidato,
SAFE_CAST(numero_candidato AS STRING) numero_candidato,
SAFE_CAST(nome_candidato AS STRING) nome_candidato,
SAFE_CAST(nome_urna_candidato AS STRING) nome_urna_candidato,
SAFE_CAST(numero_partido AS STRING) numero_partido,
SAFE_CAST(partido AS STRING) partido,
SAFE_CAST(cargo AS STRING) cargo,
SAFE_CAST(id_municipio_TSE AS STRING) id_municipio_TSE,
SAFE_CAST(situacao AS STRING) situacao,
SAFE_CAST(ocupacao AS STRING) ocupacao,
SAFE_CAST(data_nasc AS STRING) data_nasc,
SAFE_CAST(idade AS STRING) idade,
SAFE_CAST(genero AS STRING) genero,
SAFE_CAST(instrucao AS STRING) instrucao,
SAFE_CAST(estado_civil AS STRING) estado_civil,
SAFE_CAST(nacionalidade AS STRING) nacionalidade,
SAFE_CAST(estado_abrev_nasc AS STRING) estado_abrev_nasc,
SAFE_CAST(municipio_nasc AS STRING) municipio_nasc,
SAFE_CAST(email AS STRING) email,
SAFE_CAST(raca AS STRING) raca,
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(estado_abrev AS STRING) estado_abrev
from basedosdados-staging.br_tse_eleicoes_staging.candidatos as t