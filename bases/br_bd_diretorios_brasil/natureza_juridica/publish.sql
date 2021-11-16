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

CREATE VIEW basedosdados-dev.br_bd_diretorios_brasil.natureza_juridica AS
SELECT 
SAFE_CAST(id_natureza_juridica AS STRING) id_natureza_juridica,
SAFE_CAST(descricao AS STRING) descricao,
SAFE_CAST(escopo AS STRING) escopo
from basedosdados-dev.br_bd_diretorios_brasil_staging.natureza_juridica as t