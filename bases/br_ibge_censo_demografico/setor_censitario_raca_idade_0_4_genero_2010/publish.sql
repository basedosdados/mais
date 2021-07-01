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

CREATE VIEW basedosdados-dev.br_ibge_censo_demografico.setor_censitario_raca_idade_0_4_genero_2010 AS
SELECT 
SAFE_CAST(id_setor_censitario AS STRING) id_setor_censitario,
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
SAFE_CAST(v010 AS INT64) v010
from basedosdados-dev.br_ibge_censo_demografico_staging.setor_censitario_raca_idade_0_4_genero_2010 as t
