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

CREATE VIEW basedosdados-dev.br_ms_vacinacao_covid19.microdados_estabelecimento AS
SELECT 
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_estabelecimento AS STRING) id_estabelecimento,
SAFE_CAST(razao_social AS STRING) razao_social,
SAFE_CAST(nome_fantasia AS STRING) nome_fantasia,
SAFE_CAST(sigla_uf AS STRING) sigla_uf
from basedosdados-dev.br_ms_vacinacao_covid19_staging.microdados_estabelecimento as t