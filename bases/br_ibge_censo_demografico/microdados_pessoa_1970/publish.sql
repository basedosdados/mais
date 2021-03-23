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
CREATE VIEW basedosdados-dev.br_ibge_censo_demografico.microdados_pessoa_1970 AS
SELECT 
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(id_domicilio AS INT64) id_domicilio,
SAFE_CAST(numero_familia AS INT64) numero_familia,
SAFE_CAST(ordem AS INT64) ordem,
SAFE_CAST(v001 AS STRING) v001,
SAFE_CAST(v002 AS STRING) v002,
SAFE_CAST(v003 AS STRING) v003,
SAFE_CAST(v022 AS INT64) v022,
SAFE_CAST(v023 AS INT64) v023,
SAFE_CAST(v024 AS INT64) v024,
SAFE_CAST(v025 AS INT64) v025,
SAFE_CAST(v026 AS INT64) v026,
SAFE_CAST(v027 AS INT64) v027,
SAFE_CAST(v028 AS INT64) v028,
SAFE_CAST(v029 AS INT64) v029,
SAFE_CAST(v030 AS INT64) v030,
SAFE_CAST(v031 AS INT64) v031,
SAFE_CAST(v032 AS INT64) v032,
SAFE_CAST(v033 AS INT64) v033,
SAFE_CAST(v034 AS INT64) v034,
SAFE_CAST(v035 AS INT64) v035,
SAFE_CAST(v036 AS INT64) v036,
SAFE_CAST(v037 AS INT64) v037,
SAFE_CAST(v038 AS INT64) v038,
SAFE_CAST(v039 AS INT64) v039,
SAFE_CAST(v040 AS INT64) v040,
SAFE_CAST(v041 AS INT64) v041,
SAFE_CAST(v042 AS INT64) v042,
SAFE_CAST(v043 AS INT64) v043,
SAFE_CAST(v044 AS INT64) v044,
SAFE_CAST(v045 AS INT64) v045,
SAFE_CAST(v046 AS INT64) v046,
SAFE_CAST(v047 AS INT64) v047,
SAFE_CAST(v048 AS INT64) v048,
SAFE_CAST(v049 AS INT64) v049,
SAFE_CAST(v050 AS INT64) v050,
SAFE_CAST(v051 AS INT64) v051,
SAFE_CAST(v052 AS INT64) v052,
SAFE_CAST(v053 AS INT64) v053,
SAFE_CAST(v054 AS INT64) v054
from basedosdados-dev.br_ibge_censo_demografico_staging.microdados_pessoa_1970 as t