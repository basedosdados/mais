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

CREATE VIEW basedosdados-dev.br_ibge_censo_demografico.microdados_domicilio_2000 AS
SELECT 
SAFE_CAST(id_regiao AS STRING) id_regiao,
SAFE_CAST(id_mesorregiao AS STRING) id_mesorregiao,
SAFE_CAST(id_microrregiao AS STRING) id_microrregiao,
SAFE_CAST(id_regiao_metropolitana AS STRING) id_regiao_metropolitana,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_distrito AS STRING) id_distrito,
SAFE_CAST(id_subdistrito AS STRING) id_subdistrito,
SAFE_CAST(controle AS STRING) controle,
SAFE_CAST(situacao_setor AS STRING) situacao_setor,
SAFE_CAST(situacao_domicilio AS STRING) situacao_domicilio,
SAFE_CAST(tipo_setor AS STRING) tipo_setor,
SAFE_CAST(peso_amostral AS STRING) peso_amostral,
SAFE_CAST(area_ponderacao AS STRING) area_ponderacao,
SAFE_CAST(v0110 AS STRING) v0110,
SAFE_CAST(v0111 AS STRING) v0111,
SAFE_CAST(v0201 AS STRING) v0201,
SAFE_CAST(v0202 AS STRING) v0202,
SAFE_CAST(v0203 AS STRING) v0203,
SAFE_CAST(v0204 AS STRING) v0204,
SAFE_CAST(v0205 AS STRING) v0205,
SAFE_CAST(v0206 AS STRING) v0206,
SAFE_CAST(v0207 AS STRING) v0207,
SAFE_CAST(v0208 AS STRING) v0208,
SAFE_CAST(v0209 AS STRING) v0209,
SAFE_CAST(v0210 AS STRING) v0210,
SAFE_CAST(v0211 AS STRING) v0211,
SAFE_CAST(v0212 AS STRING) v0212,
SAFE_CAST(v0213 AS STRING) v0213,
SAFE_CAST(v0214 AS STRING) v0214,
SAFE_CAST(v0215 AS STRING) v0215,
SAFE_CAST(v0216 AS STRING) v0216,
SAFE_CAST(v0217 AS STRING) v0217,
SAFE_CAST(v0218 AS STRING) v0218,
SAFE_CAST(v0219 AS STRING) v0219,
SAFE_CAST(v0220 AS STRING) v0220,
SAFE_CAST(v0221 AS STRING) v0221,
SAFE_CAST(v0222 AS STRING) v0222,
SAFE_CAST(v0223 AS STRING) v0223,
SAFE_CAST(v7100 AS STRING) v7100,
SAFE_CAST(v7203 AS STRING) v7203,
SAFE_CAST(v7204 AS STRING) v7204,
SAFE_CAST(v7401 AS STRING) v7401,
SAFE_CAST(v7402 AS STRING) v7402,
SAFE_CAST(v7403 AS STRING) v7403,
SAFE_CAST(v7404 AS STRING) v7404,
SAFE_CAST(v7405 AS STRING) v7405,
SAFE_CAST(v7406 AS STRING) v7406,
SAFE_CAST(v7407 AS STRING) v7407,
SAFE_CAST(v7408 AS STRING) v7408,
SAFE_CAST(v7409 AS STRING) v7409,
SAFE_CAST(v7616 AS STRING) v7616,
SAFE_CAST(v7617 AS STRING) v7617,
SAFE_CAST(v1111 AS STRING) v1111,
SAFE_CAST(v1112 AS STRING) v1112,
SAFE_CAST(v1113 AS STRING) v1113,
SAFE_CAST(sigla_uf AS STRING) sigla_uf
from basedosdados-dev.br_ibge_censo_demografico_staging.microdados_domicilio_2000 as t