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

CREATE VIEW basedosdados-dev.br_cvm_administradores_carteira.pessoa_fisica AS
SELECT 
SAFE_CAST(nome AS STRING) nome,
SAFE_CAST(data_registro AS DATE) data_registro,
SAFE_CAST(data_cancelamento AS DATE) data_cancelamento,
SAFE_CAST(motivo_cancelamento AS STRING) motivo_cancelamento,
SAFE_CAST(situacao AS STRING) situacao,
SAFE_CAST(data_inicio_situacao AS DATE) data_inicio_situacao,
SAFE_CAST(categoria_registro AS STRING) categoria_registro
FROM basedosdados-dev.br_cvm_administradores_carteira_staging.pessoa_fisica AS t