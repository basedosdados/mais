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
CREATE VIEW basedosdados.br_ibge_nomes_brasil.quantidade_municipio_nome_2010 AS
SELECT 
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(nome AS STRING) nome,
SAFE_CAST(qtde_nascimentos_ate_2010 AS INT64) qtde_nascimentos_ate_2010
from basedosdados-staging.br_ibge_nomes_brasil_staging.quantidade_municipio_nome_2010 as t