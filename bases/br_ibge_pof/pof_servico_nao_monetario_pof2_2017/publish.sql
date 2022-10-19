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

CREATE VIEW basedosdados-dev.br_ibge_pof.pof_servico_nao_monetario_pof2_2017 AS
SELECT 
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(situacao AS STRING) situacao,
SAFE_CAST(id_estrato AS STRING) id_estrato,
SAFE_CAST(id_unidade_primaria_amostragem AS STRING) id_unidade_primaria_amostragem,
SAFE_CAST(id_domicilio AS STRING) id_domicilio,
SAFE_CAST(id_unidade_consumo AS STRING) id_unidade_consumo,
SAFE_CAST(id_quadro AS STRING) id_quadro,
SAFE_CAST(id_codigo_5_bd AS STRING) id_codigo_5_bd,
SAFE_CAST(V9001 AS STRING) V9001,
SAFE_CAST(V9002 AS STRING) V9002,
SAFE_CAST(V9010 AS STRING) V9010,
SAFE_CAST(V9011 AS INT64) V9011,
SAFE_CAST(V1905 AS STRING) V1905,
SAFE_CAST(V9004 AS INT64) V9004,
SAFE_CAST(indicador_imputacao_valor AS INT64) indicador_imputacao_valor,
SAFE_CAST(fator_anualizacao AS INT64) fator_anualizacao,
SAFE_CAST(deflator AS INT64) deflator,
SAFE_CAST(V8000 AS FLOAT64) V8000,
SAFE_CAST(V8000_deflacionado AS FLOAT64) V8000_deflacionado,
SAFE_CAST(V1904 AS FLOAT64) V1904,
SAFE_CAST(V1904_deflacionado AS FLOAT64) V1904_deflacionado,
SAFE_CAST(renda_total AS FLOAT64) renda_total,
SAFE_CAST(peso AS FLOAT64) peso,
SAFE_CAST(peso_final AS FLOAT64) peso_final
FROM basedosdados-dev.br_ibge_pof_staging.pof_servico_nao_monetario_pof2_2017 AS t