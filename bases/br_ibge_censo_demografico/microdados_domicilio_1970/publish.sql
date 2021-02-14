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

CREATE VIEW basedosdados-dev.br_ibge_censo_demografico.microdados_domicilio_1970 AS
SELECT 
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_domicilio AS STRING) id_domicilio,
SAFE_CAST(numero_familia AS STRING) numero_familia,
SAFE_CAST(v001 AS STRING) v001,
SAFE_CAST(v002 AS STRING) v002,
SAFE_CAST(v003 AS STRING) v003,
SAFE_CAST(v004 AS STRING) v004,
SAFE_CAST(v005 AS STRING) v005,
SAFE_CAST(v006 AS STRING) v006,
SAFE_CAST(v007 AS STRING) v007,
SAFE_CAST(v008 AS STRING) v008,
SAFE_CAST(v009 AS STRING) v009,
SAFE_CAST(v010 AS STRING) v010,
SAFE_CAST(v011 AS STRING) v011,
SAFE_CAST(v012 AS STRING) v012,
SAFE_CAST(v013 AS STRING) v013,
SAFE_CAST(v014 AS STRING) v014,
SAFE_CAST(v015 AS STRING) v015,
SAFE_CAST(v016 AS STRING) v016,
SAFE_CAST(v017 AS STRING) v017,
SAFE_CAST(v018 AS STRING) v018,
SAFE_CAST(v019 AS STRING) v019,
SAFE_CAST(v020 AS STRING) v020,
SAFE_CAST(v021 AS STRING) v021,
SAFE_CAST(v054 AS STRING) v054,
SAFE_CAST(sigla_uf AS STRING) sigla_uf
from basedosdados-dev.br_ibge_censo_demografico_staging.microdados_domicilio_1970 as t