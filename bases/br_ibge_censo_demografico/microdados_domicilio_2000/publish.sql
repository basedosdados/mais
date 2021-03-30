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
SAFE_CAST(id_regiao AS INT64) id_regiao,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_mesorregiao AS INT64) id_mesorregiao,
SAFE_CAST(id_microrregiao AS INT64) id_microrregiao,
SAFE_CAST(id_regiao_metropolitana AS INT64) id_regiao_metropolitana,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(id_distrito AS INT64) id_distrito,
SAFE_CAST(id_subdistrito AS INT64) id_subdistrito,
SAFE_CAST(controle AS INT64) controle,
SAFE_CAST(situacao_setor AS INT64) situacao_setor,
SAFE_CAST(situacao_domicilio AS INT64) situacao_domicilio,
SAFE_CAST(tipo_setor AS INT64) tipo_setor,
SAFE_CAST(peso_amostral AS FLOAT64) peso_amostral,
SAFE_CAST(area_ponderacao AS INT64) area_ponderacao,
SAFE_CAST(v0110 AS INT64) v0110,
SAFE_CAST(v0111 AS INT64) v0111,
SAFE_CAST(v0201 AS INT64) v0201,
SAFE_CAST(v0202 AS INT64) v0202,
SAFE_CAST(v0203 AS INT64) v0203,
SAFE_CAST(v0204 AS INT64) v0204,
SAFE_CAST(v0205 AS INT64) v0205,
SAFE_CAST(v0206 AS INT64) v0206,
SAFE_CAST(v0207 AS INT64) v0207,
SAFE_CAST(v0208 AS INT64) v0208,
SAFE_CAST(v0209 AS INT64) v0209,
SAFE_CAST(v0210 AS INT64) v0210,
SAFE_CAST(v0211 AS INT64) v0211,
SAFE_CAST(v0212 AS INT64) v0212,
SAFE_CAST(v0213 AS INT64) v0213,
SAFE_CAST(v0214 AS INT64) v0214,
SAFE_CAST(v0215 AS INT64) v0215,
SAFE_CAST(v0216 AS INT64) v0216,
SAFE_CAST(v0217 AS INT64) v0217,
SAFE_CAST(v0218 AS INT64) v0218,
SAFE_CAST(v0219 AS INT64) v0219,
SAFE_CAST(v0220 AS INT64) v0220,
SAFE_CAST(v0221 AS INT64) v0221,
SAFE_CAST(v0222 AS INT64) v0222,
SAFE_CAST(v0223 AS INT64) v0223,
SAFE_CAST(v7100 AS INT64) v7100,
SAFE_CAST(v7203 AS FLOAT64) v7203,
SAFE_CAST(v7204 AS FLOAT64) v7204,
SAFE_CAST(v7401 AS INT64) v7401,
SAFE_CAST(v7402 AS INT64) v7402,
SAFE_CAST(v7403 AS INT64) v7403,
SAFE_CAST(v7404 AS INT64) v7404,
SAFE_CAST(v7405 AS INT64) v7405,
SAFE_CAST(v7406 AS INT64) v7406,
SAFE_CAST(v7407 AS INT64) v7407,
SAFE_CAST(v7408 AS INT64) v7408,
SAFE_CAST(v7409 AS INT64) v7409,
SAFE_CAST(v7616 AS INT64) v7616,
SAFE_CAST(v7617 AS INT64) v7617,
SAFE_CAST(v1111 AS INT64) v1111,
SAFE_CAST(v1112 AS INT64) v1112,
SAFE_CAST(v1113 AS INT64) v1113
from basedosdados-dev.br_ibge_censo_demografico_staging.microdados_domicilio_2000 as t