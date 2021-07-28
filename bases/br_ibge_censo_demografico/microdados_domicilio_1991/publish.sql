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

CREATE VIEW basedosdados-dev.br_ibge_censo_demografico.microdados_domicilio_1991 AS
SELECT 
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_questionario AS STRING) id_questionario,
SAFE_CAST(peso_amostral AS FLOAT64) peso_amostral,
SAFE_CAST(v0109 AS INT64) v0109,
SAFE_CAST(v1061 AS INT64) v1061,
SAFE_CAST(v7003 AS INT64) v7003,
SAFE_CAST(v0111 AS INT64) v0111,
SAFE_CAST(v0112 AS INT64) v0112,
SAFE_CAST(v0201 AS INT64) v0201,
SAFE_CAST(v2012 AS INT64) v2012,
SAFE_CAST(v2013 AS INT64) v2013,
SAFE_CAST(v2014 AS INT64) v2014,
SAFE_CAST(v0202 AS INT64) v0202,
SAFE_CAST(v0203 AS INT64) v0203,
SAFE_CAST(v0204 AS INT64) v0204,
SAFE_CAST(v0205 AS INT64) v0205,
SAFE_CAST(v0206 AS INT64) v0206,
SAFE_CAST(v0207 AS INT64) v0207,
SAFE_CAST(v0208 AS INT64) v0208,
SAFE_CAST(v0209 AS INT64) v0209,
SAFE_CAST(v2094 AS INT64) v2094,
SAFE_CAST(v0210 AS INT64) v0210,
SAFE_CAST(v0211 AS INT64) v0211,
SAFE_CAST(v2111 AS INT64) v2111,
SAFE_CAST(v2112 AS INT64) v2112,
SAFE_CAST(v0212 AS INT64) v0212,
SAFE_CAST(v2121 AS INT64) v2121,
SAFE_CAST(v2122 AS INT64) v2122,
SAFE_CAST(v0213 AS INT64) v0213,
SAFE_CAST(v0214 AS INT64) v0214,
SAFE_CAST(v0216 AS INT64) v0216,
SAFE_CAST(v0217 AS INT64) v0217,
SAFE_CAST(v0218 AS INT64) v0218,
SAFE_CAST(v0219 AS INT64) v0219,
SAFE_CAST(v0220 AS INT64) v0220,
SAFE_CAST(v0221 AS INT64) v0221,
SAFE_CAST(v0222 AS INT64) v0222,
SAFE_CAST(v0223 AS INT64) v0223,
SAFE_CAST(v0224 AS INT64) v0224,
SAFE_CAST(v0225 AS INT64) v0225,
SAFE_CAST(v0226 AS INT64) v0226,
SAFE_CAST(v0227 AS INT64) v0227
from basedosdados-dev.br_ibge_censo_demografico_staging.microdados_domicilio_1991 as t