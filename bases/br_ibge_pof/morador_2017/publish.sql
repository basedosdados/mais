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

CREATE VIEW basedosdados-dev.br_ibge_pof.morador_2017 AS
SELECT 
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(situacao AS STRING) situacao,
SAFE_CAST(id_estrato AS STRING) id_estrato,
SAFE_CAST(id_unidade_primaria_amostragem AS STRING) id_unidade_primaria_amostragem,
SAFE_CAST(id_domicilio AS STRING) id_domicilio,
SAFE_CAST(id_unidade_consumo AS STRING) id_unidade_consumo,
SAFE_CAST(id_informante AS STRING) id_informante,
SAFE_CAST(dia_nascimento AS INT64) dia_nascimento,
SAFE_CAST(mes_nascimento AS INT64) mes_nascimento,
SAFE_CAST(ano_nascimento AS INT64) ano_nascimento,
SAFE_CAST(idade AS INT64) idade,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(raca_cor AS STRING) raca_cor,
SAFE_CAST(anos_estudo AS INT64) anos_estudo,
SAFE_CAST(renda_total AS FLOAT64) renda_total,
SAFE_CAST(nivel_instrucao AS STRING) nivel_instrucao,
SAFE_CAST(composicao_familiar AS STRING) composicao_familiar,
SAFE_CAST(V0306 AS STRING) V0306,
SAFE_CAST(V0401 AS STRING) V0401,
SAFE_CAST(V0406 AS STRING) V0406,
SAFE_CAST(V0407 AS STRING) V0407,
SAFE_CAST(V0408 AS STRING) V0408,
SAFE_CAST(V0409 AS INT64) V0409,
SAFE_CAST(V0410 AS INT64) V0410,
SAFE_CAST(V0411 AS INT64) V0411,
SAFE_CAST(V0412 AS STRING) V0412,
SAFE_CAST(V0413 AS INT64) V0413,
SAFE_CAST(V0414 AS STRING) V0414,
SAFE_CAST(V0415 AS STRING) V0415,
SAFE_CAST(V0416 AS INT64) V0416,
SAFE_CAST(V041711 AS STRING) V041711,
SAFE_CAST(V041712 AS STRING) V041712,
SAFE_CAST(V041721 AS STRING) V041721,
SAFE_CAST(V041722 AS STRING) V041722,
SAFE_CAST(V041731 AS STRING) V041731,
SAFE_CAST(V041732 AS STRING) V041732,
SAFE_CAST(V041741 AS STRING) V041741,
SAFE_CAST(V041742 AS STRING) V041742,
SAFE_CAST(V0418 AS STRING) V0418,
SAFE_CAST(V0419 AS STRING) V0419,
SAFE_CAST(V0420 AS STRING) V0420,
SAFE_CAST(V0421 AS STRING) V0421,
SAFE_CAST(V0422 AS STRING) V0422,
SAFE_CAST(V0423 AS STRING) V0423,
SAFE_CAST(V0424 AS STRING) V0424,
SAFE_CAST(V0425 AS STRING) V0425,
SAFE_CAST(V0426 AS STRING) V0426,
SAFE_CAST(V0427 AS STRING) V0427,
SAFE_CAST(V0428 AS STRING) V0428,
SAFE_CAST(V0429 AS STRING) V0429,
SAFE_CAST(V0430 AS STRING) V0430,
SAFE_CAST(peso AS FLOAT64) peso,
SAFE_CAST(peso_final AS FLOAT64) peso_final,
SAFE_CAST(deducao_per_capita AS FLOAT64) deducao_per_capita,
SAFE_CAST(renda_nao_monetaria_per_capita AS FLOAT64) renda_nao_monetaria_per_capita,
SAFE_CAST(renda_monetaria_per_capita AS FLOAT64) renda_monetaria_per_capita,
SAFE_CAST(renda_disponivel_per_capita AS FLOAT64) renda_disponivel_per_capita
FROM basedosdados-dev.br_ibge_pof_staging.morador_2017 AS t