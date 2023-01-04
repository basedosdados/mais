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

CREATE VIEW basedosdados-dev.br_caixa_sorteios.megasena AS
SELECT 
SAFE_CAST(concurso AS INT64) concurso,
SAFE_CAST(data AS DATE) data,
SAFE_CAST(ordem AS INT64) ordem,
SAFE_CAST(bola AS INT64) bola
FROM basedosdados-dev.br_caixa_sorteios_staging.megasena AS t