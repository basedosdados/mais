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
    - Para modificar tipos de colunas, basta substituir INT64 por outro tipo válido.
    - Exemplo: `SAFE_CAST(column_name AS NUMERIC) column_name`
    - Mais detalhes: https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types

*/

CREATE VIEW basedosdados.br_ibge_censo2010.domicilio_renda_setor_censitario AS
SELECT 
SAFE_CAST(id_setor_censitario AS INT64) id_setor_censitario,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(v001 AS INT64) v001,
SAFE_CAST(v002 AS INT64) v002,
SAFE_CAST(v003 AS INT64) v003,
SAFE_CAST(v004 AS INT64) v004,
SAFE_CAST(v005 AS INT64) v005,
SAFE_CAST(v006 AS INT64) v006,
SAFE_CAST(v007 AS INT64) v007,
SAFE_CAST(v008 AS INT64) v008,
SAFE_CAST(v009 AS INT64) v009,
SAFE_CAST(v010 AS INT64) v010,
SAFE_CAST(v011 AS INT64) v011,
SAFE_CAST(v012 AS INT64) v012,
SAFE_CAST(v013 AS INT64) v013,
SAFE_CAST(v014 AS INT64) v014
from basedosdados-staging.br_ibge_censo2010_staging.domicilio_renda_setor_censitario as t