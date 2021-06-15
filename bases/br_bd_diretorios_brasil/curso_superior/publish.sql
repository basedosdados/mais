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

CREATE VIEW basedosdados-dev.br_bd_diretorios_brasil.curso_superior AS
SELECT 
SAFE_CAST(id_curso AS STRING) id_curso,
SAFE_CAST(nome_curso AS STRING) nome_curso,
SAFE_CAST(id_area AS STRING) id_area,
SAFE_CAST(nome_area AS STRING) nome_area,
SAFE_CAST(grau_academico AS STRING) grau_academico
from basedosdados-dev.br_bd_diretorios_brasil_staging.curso_superior as t