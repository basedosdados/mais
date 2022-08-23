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

CREATE VIEW basedosdados-dev.br_bd_diretorios_brasil.area_conhecimento AS
SELECT 
SAFE_CAST(especialidade AS STRING) especialidade,
SAFE_CAST(descricao_especialidade AS STRING) descricao_especialidade,
SAFE_CAST(subarea AS STRING) subarea,
SAFE_CAST(descricao_subarea AS STRING) descricao_subarea,
SAFE_CAST(area AS STRING) area,
SAFE_CAST(descricao_area AS STRING) descricao_area,
SAFE_CAST(grande_area AS STRING) grande_area,
SAFE_CAST(descricao_grande_area AS STRING) descricao_grande_area
FROM basedosdados-dev.br_bd_diretorios_brasil_staging.area_conhecimento AS t