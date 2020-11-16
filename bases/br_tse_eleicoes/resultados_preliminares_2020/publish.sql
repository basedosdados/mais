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
CREATE VIEW `basedosdados.br_tse_eleicoes.resultados_preliminares_2020` AS
SELECT 
SAFE_CAST(id_eleicao AS INT64) id_eleicao,
SAFE_CAST(data AS STRING) data,
SAFE_CAST(hora AS STRING) hora,
SAFE_CAST(compilado AS STRING) compilado,
SAFE_CAST(regiao AS STRING) regiao,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(id_municipio_tse AS INT64) id_municipio_tse,
SAFE_CAST(turno AS INT64) turno,
SAFE_CAST(cargo AS STRING) cargo,
SAFE_CAST(apuracao AS FLOAT64) apuracao,
SAFE_CAST(numero_candidato AS INT64) numero_candidato,
SAFE_CAST(nome_urna_candidato AS STRING) nome_urna_candidato,
SAFE_CAST(sigla_partido AS STRING) sigla_partido,
SAFE_CAST(coligacao AS STRING) coligacao,
SAFE_CAST(votos AS INT64) votos,
SAFE_CAST(prop_votos AS FLOAT64) prop_votos,
SAFE_CAST(resultado AS STRING) resultado
from basedosdados-staging.br_tse_eleicoes_staging.resultados_preliminares_2020 as t