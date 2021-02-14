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
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_domicilio AS STRING) id_domicilio,
SAFE_CAST(numero_familia AS STRING) numero_familia,
SAFE_CAST(ordem AS STRING) ordem,
SAFE_CAST(v001 AS STRING) v001,
SAFE_CAST(v002 AS STRING) v002,
SAFE_CAST(v003 AS STRING) v003,
SAFE_CAST(v022 AS STRING) v022,
SAFE_CAST(v023 AS STRING) v023,
SAFE_CAST(v024 AS STRING) v024,
SAFE_CAST(v025 AS STRING) v025,
SAFE_CAST(v026 AS STRING) v026,
SAFE_CAST(v027 AS STRING) v027,
SAFE_CAST(v028 AS STRING) v028,
SAFE_CAST(v029 AS STRING) v029,
SAFE_CAST(v030 AS STRING) v030,
SAFE_CAST(v031 AS STRING) v031,
SAFE_CAST(v032 AS STRING) v032,
SAFE_CAST(v033 AS STRING) v033,
SAFE_CAST(v034 AS STRING) v034,
SAFE_CAST(v035 AS STRING) v035,
SAFE_CAST(v036 AS STRING) v036,
SAFE_CAST(v037 AS STRING) v037,
SAFE_CAST(v038 AS STRING) v038,
SAFE_CAST(v039 AS STRING) v039,
SAFE_CAST(v040 AS STRING) v040,
SAFE_CAST(v041 AS STRING) v041,
SAFE_CAST(v042 AS STRING) v042,
SAFE_CAST(v043 AS STRING) v043,
SAFE_CAST(v044 AS STRING) v044,
SAFE_CAST(v045 AS STRING) v045,
SAFE_CAST(v046 AS STRING) v046,
SAFE_CAST(v047 AS STRING) v047,
SAFE_CAST(v048 AS STRING) v048,
SAFE_CAST(v049 AS STRING) v049,
SAFE_CAST(v050 AS STRING) v050,
SAFE_CAST(v051 AS STRING) v051,
SAFE_CAST(v052 AS STRING) v052,
SAFE_CAST(v053 AS STRING) v053,
SAFE_CAST(v054 AS STRING) v054,
SAFE_CAST(sigla_uf AS STRING) sigla_uf
from basedosdados-dev.br_ibge_censo_demografico_staging.microdados_pessoa_1970 as t