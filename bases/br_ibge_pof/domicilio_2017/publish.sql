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

CREATE VIEW basedosdados-dev.br_ibge_pof.domicilio_2017 AS
SELECT 
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(situacao AS STRING) situacao,
SAFE_CAST(id_estrato AS STRING) id_estrato,
SAFE_CAST(id_unidade_primaria_amostragem AS STRING) id_unidade_primaria_amostragem,
SAFE_CAST(id_domicilio AS STRING) id_domicilio,
SAFE_CAST(V0201 AS STRING) V0201,
SAFE_CAST(V0202 AS STRING) V0202,
SAFE_CAST(V0203 AS STRING) V0203,
SAFE_CAST(V0204 AS STRING) V0204,
SAFE_CAST(V0205 AS INT64) V0205,
SAFE_CAST(V0206 AS INT64) V0206,
SAFE_CAST(V0207 AS STRING) V0207,
SAFE_CAST(V0208 AS STRING) V0208,
SAFE_CAST(V0209 AS STRING) V0209,
SAFE_CAST(V02101 AS STRING) V02101,
SAFE_CAST(V02102 AS STRING) V02102,
SAFE_CAST(V02103 AS STRING) V02103,
SAFE_CAST(V02104 AS STRING) V02104,
SAFE_CAST(V02105 AS STRING) V02105,
SAFE_CAST(V02111 AS INT64) V02111,
SAFE_CAST(V02112 AS INT64) V02112,
SAFE_CAST(V02113 AS STRING) V02113,
SAFE_CAST(V0212 AS STRING) V0212,
SAFE_CAST(V0213 AS STRING) V0213,
SAFE_CAST(V02141 AS STRING) V02141,
SAFE_CAST(V02142 AS STRING) V02142,
SAFE_CAST(V0215 AS STRING) V0215,
SAFE_CAST(V02161 AS STRING) V02161,
SAFE_CAST(V02162 AS STRING) V02162,
SAFE_CAST(V02163 AS STRING) V02163,
SAFE_CAST(V02164 AS STRING) V02164,
SAFE_CAST(V0217 AS STRING) V0217,
SAFE_CAST(V0219 AS STRING) V0219,
SAFE_CAST(V0220 AS STRING) V0220,
SAFE_CAST(V0221 AS STRING) V0221,
SAFE_CAST(V6199 AS STRING) V6199,
SAFE_CAST(peso AS FLOAT64) peso,
SAFE_CAST(peso_final AS FLOAT64) peso_final
FROM basedosdados-dev.br_ibge_pof_staging.domicilio_2017 AS t