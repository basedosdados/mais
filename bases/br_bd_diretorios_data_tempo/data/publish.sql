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
CREATE VIEW basedosdados-dev.br_bd_diretorios_data_tempo.data AS
SELECT 
SAFE_CAST(data AS DATE) data,
SAFE_CAST(dia AS INT64) dia,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(bimestre AS INT64) bimestre,
SAFE_CAST(trimestre AS INT64) trimestre,
SAFE_CAST(semestre AS INT64) semestre,
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(dia_semana AS INT64) dia_semana
FROM basedosdados-dev.br_bd_diretorios_data_tempo_staging.data AS t