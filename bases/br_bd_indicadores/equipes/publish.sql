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

CREATE VIEW basedosdados-dev.br_bd_indicadores.equipes AS
SELECT 
SAFE_CAST(id_pessoa AS STRING) id_pessoa,
SAFE_CAST(data_inicio AS DATE) data_inicio,
SAFE_CAST(data_fim AS DATE) data_fim,
SAFE_CAST(equipe AS STRING) equipe,
SAFE_CAST(nivel AS STRING) nivel,
SAFE_CAST(cargo AS STRING) cargo
FROM basedosdados-dev.br_bd_indicadores_staging.equipes AS t