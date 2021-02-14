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
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_questionario AS STRING) id_questionario,
SAFE_CAST(peso_amostral AS STRING) peso_amostral,
SAFE_CAST(v0109 AS STRING) v0109,
SAFE_CAST(v1061 AS STRING) v1061,
SAFE_CAST(v7003 AS STRING) v7003,
SAFE_CAST(v0111 AS STRING) v0111,
SAFE_CAST(v0112 AS STRING) v0112,
SAFE_CAST(v0201 AS STRING) v0201,
SAFE_CAST(v2012 AS STRING) v2012,
SAFE_CAST(v2013 AS STRING) v2013,
SAFE_CAST(v2014 AS STRING) v2014,
SAFE_CAST(v0202 AS STRING) v0202,
SAFE_CAST(v0203 AS STRING) v0203,
SAFE_CAST(v0204 AS STRING) v0204,
SAFE_CAST(v0205 AS STRING) v0205,
SAFE_CAST(v0206 AS STRING) v0206,
SAFE_CAST(v0207 AS STRING) v0207,
SAFE_CAST(v0208 AS STRING) v0208,
SAFE_CAST(v0209 AS STRING) v0209,
SAFE_CAST(v2094 AS STRING) v2094,
SAFE_CAST(v0210 AS STRING) v0210,
SAFE_CAST(v0211 AS STRING) v0211,
SAFE_CAST(v2111 AS STRING) v2111,
SAFE_CAST(v2112 AS STRING) v2112,
SAFE_CAST(v0212 AS STRING) v0212,
SAFE_CAST(v2121 AS STRING) v2121,
SAFE_CAST(v2122 AS STRING) v2122,
SAFE_CAST(v0213 AS STRING) v0213,
SAFE_CAST(v0214 AS STRING) v0214,
SAFE_CAST(v0216 AS STRING) v0216,
SAFE_CAST(v0217 AS STRING) v0217,
SAFE_CAST(v0218 AS STRING) v0218,
SAFE_CAST(v0219 AS STRING) v0219,
SAFE_CAST(v0220 AS STRING) v0220,
SAFE_CAST(v0221 AS STRING) v0221,
SAFE_CAST(v0222 AS STRING) v0222,
SAFE_CAST(v0223 AS STRING) v0223,
SAFE_CAST(v0224 AS STRING) v0224,
SAFE_CAST(v0225 AS STRING) v0225,
SAFE_CAST(v0226 AS STRING) v0226,
SAFE_CAST(v0227 AS STRING) v0227,
SAFE_CAST(sigla_uf AS STRING) sigla_uf
from basedosdados-dev.br_ibge_censo_demografico_staging.microdados_domicilio_1991 as t