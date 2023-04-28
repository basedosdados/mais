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

CREATE VIEW basedosdados-dev.br_inep_indicador_nivel_socioeconomico.brasil AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(area AS STRING) area,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(tipo_localizacao AS STRING) tipo_localizacao,
SAFE_CAST(quantidade_alunos_inse AS INT64) quantidade_alunos_inse,
SAFE_CAST(inse AS FLOAT64) inse,
SAFE_CAST(percentual_nivel_1 AS FLOAT64) percentual_nivel_1,
SAFE_CAST(percentual_nivel_2 AS FLOAT64) percentual_nivel_2,
SAFE_CAST(percentual_nivel_3 AS FLOAT64) percentual_nivel_3,
SAFE_CAST(percentual_nivel_4 AS FLOAT64) percentual_nivel_4,
SAFE_CAST(percentual_nivel_5 AS FLOAT64) percentual_nivel_5,
SAFE_CAST(percentual_nivel_6 AS FLOAT64) percentual_nivel_6,
SAFE_CAST(percentual_nivel_7 AS FLOAT64) percentual_nivel_7,
SAFE_CAST(percentual_nivel_8 AS FLOAT64) percentual_nivel_8
FROM basedosdados-dev.br_inep_indicador_nivel_socioeconomico_staging.brasil AS t