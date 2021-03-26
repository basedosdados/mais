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
CREATE VIEW basedosdados-dev.br_ibge_censo_demografico.microdados_domicilio_2010 AS
SELECT 
SAFE_CAST(id_regiao AS INT64) id_regiao,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_mesorregiao AS INT64) id_mesorregiao,
SAFE_CAST(id_microrregiao AS INT64) id_microrregiao,
SAFE_CAST(id_regiao_metropolitana AS INT64) id_regiao_metropolitana,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(situacao_setor AS INT64) situacao_setor,
SAFE_CAST(situacao_domicilio AS INT64) situacao_domicilio,
SAFE_CAST(controle AS INT64) controle,
SAFE_CAST(peso_amostral AS FLOAT64) peso_amostral,
SAFE_CAST(area_ponderacao AS INT64) area_ponderacao,
SAFE_CAST(v4001 AS INT64) v4001,
SAFE_CAST(v4002 AS INT64) v4002,
SAFE_CAST(v0201 AS INT64) v0201,
SAFE_CAST(v2011 AS INT64) v2011,
SAFE_CAST(v2012 AS FLOAT64) v2012,
SAFE_CAST(v0202 AS INT64) v0202,
SAFE_CAST(v0203 AS INT64) v0203,
SAFE_CAST(v6203 AS FLOAT64) v6203,
SAFE_CAST(v0204 AS INT64) v0204,
SAFE_CAST(v6204 AS FLOAT64) v6204,
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
SAFE_CAST(v0301 AS INT64) v0301,
SAFE_CAST(v0401 AS INT64) v0401,
SAFE_CAST(v0402 AS INT64) v0402,
SAFE_CAST(v0701 AS INT64) v0701,
SAFE_CAST(v6529 AS INT64) v6529,
SAFE_CAST(v6530 AS FLOAT64) v6530,
SAFE_CAST(v6531 AS INT64) v6531,
SAFE_CAST(v6532 AS FLOAT64) v6532,
SAFE_CAST(v6600 AS INT64) v6600,
SAFE_CAST(v6210 AS INT64) v6210,
SAFE_CAST(m0201 AS STRING) m0201,
SAFE_CAST(m02011 AS STRING) m02011,
SAFE_CAST(m0202 AS STRING) m0202,
SAFE_CAST(m0203 AS STRING) m0203,
SAFE_CAST(m0204 AS STRING) m0204,
SAFE_CAST(m0205 AS STRING) m0205,
SAFE_CAST(m0206 AS STRING) m0206,
SAFE_CAST(m0207 AS STRING) m0207,
SAFE_CAST(m0208 AS STRING) m0208,
SAFE_CAST(m0209 AS STRING) m0209,
SAFE_CAST(m0210 AS STRING) m0210,
SAFE_CAST(m0211 AS STRING) m0211,
SAFE_CAST(m0212 AS STRING) m0212,
SAFE_CAST(m0213 AS STRING) m0213,
SAFE_CAST(m0214 AS STRING) m0214,
SAFE_CAST(m0215 AS STRING) m0215,
SAFE_CAST(m0216 AS STRING) m0216,
SAFE_CAST(m0217 AS STRING) m0217,
SAFE_CAST(m0218 AS STRING) m0218,
SAFE_CAST(m0219 AS STRING) m0219,
SAFE_CAST(m0220 AS STRING) m0220,
SAFE_CAST(m0221 AS STRING) m0221,
SAFE_CAST(m0222 AS STRING) m0222,
SAFE_CAST(m0301 AS STRING) m0301,
SAFE_CAST(m0401 AS STRING) m0401,
SAFE_CAST(m0402 AS STRING) m0402,
SAFE_CAST(m0701 AS STRING) m0701
from basedosdados-dev.br_ibge_censo_demografico_staging.microdados_domicilio_2010 as t