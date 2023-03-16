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

CREATE VIEW basedosdados-dev.br_ibge_pof.caracteristicas_dieta_2017 AS
SELECT 
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(situacao AS STRING) situacao,
SAFE_CAST(id_estrato AS STRING) id_estrato,
SAFE_CAST(id_unidade_primaria_amostragem AS STRING) id_unidade_primaria_amostragem,
SAFE_CAST(id_domicilio AS STRING) id_domicilio,
SAFE_CAST(id_unidade_consumo AS STRING) id_unidade_consumo,
SAFE_CAST(id_informante AS STRING) id_informante,
SAFE_CAST(V7101 AS STRING) V7101,
SAFE_CAST(V7102 AS STRING) V7102,
SAFE_CAST(V71031 AS STRING) V71031,
SAFE_CAST(V71032 AS STRING) V71032,
SAFE_CAST(V71033 AS STRING) V71033,
SAFE_CAST(V71034 AS STRING) V71034,
SAFE_CAST(V71035 AS STRING) V71035,
SAFE_CAST(V71036 AS STRING) V71036,
SAFE_CAST(V71037 AS STRING) V71037,
SAFE_CAST(V71038 AS STRING) V71038,
SAFE_CAST(V7104 AS STRING) V7104,
SAFE_CAST(V71051 AS STRING) V71051,
SAFE_CAST(V71052 AS STRING) V71052,
SAFE_CAST(V71053 AS STRING) V71053,
SAFE_CAST(V71054 AS STRING) V71054,
SAFE_CAST(V71055 AS STRING) V71055,
SAFE_CAST(V71056 AS STRING) V71056,
SAFE_CAST(V71A01 AS STRING) V71A01,
SAFE_CAST(V71A02 AS STRING) V71A02,
SAFE_CAST(V72C01 AS INT64) V72C01,
SAFE_CAST(V72C02 AS INT64) V72C02,
SAFE_CAST(peso AS FLOAT64) peso,
SAFE_CAST(peso_final AS FLOAT64) peso_final
FROM basedosdados-dev.br_ibge_pof_staging.caracteristicas_dieta_2017 AS t