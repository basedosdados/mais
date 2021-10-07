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

CREATE VIEW basedosdados-dev.br_inep_indicadores_educacionais.escola_nivel_socioeconomico AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_escola AS STRING) id_escola,
SAFE_CAST(area AS STRING) area,
SAFE_CAST(localizacao AS STRING) localizacao,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(inse_quantidade_alunos AS INT64) inse_quantidade_alunos,
SAFE_CAST(valor_inse AS FLOAT64) valor_inse,
SAFE_CAST(inse_classificacao_2014 AS STRING) inse_classificacao_2014,
SAFE_CAST(inse_classificacao_2015 AS STRING) inse_classificacao_2015
from basedosdados-dev.br_inep_indicadores_educacionais_staging.escola_nivel_socioeconomico as t