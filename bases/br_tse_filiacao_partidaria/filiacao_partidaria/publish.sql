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

CREATE VIEW basedosdados.br_tse_filiacao_partidaria.filiacao_partidaria AS
SELECT 
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio_tse AS INT64) id_municipio_tse,
SAFE_CAST(sigla_partido AS STRING) sigla_partido,
SAFE_CAST(zona AS INT64) zona,
SAFE_CAST(secao AS INT64) secao,
SAFE_CAST(titulo_eleitoral AS STRING) titulo_eleitoral,
SAFE_CAST(nome_filiado AS STRING) nome_filiado,
SAFE_CAST(data_filiacao AS DATE) data_filiacao,
SAFE_CAST(situacao_registro AS STRING) situacao_registro,
SAFE_CAST(tipo_registro AS STRING) tipo_registro,
SAFE_CAST(data_processamento AS DATE) data_processamento,
SAFE_CAST(data_desfiliacao AS DATE) data_desfiliacao,
SAFE_CAST(data_cancelamento AS DATE) data_cancelamento,
SAFE_CAST(data_regularizacao AS DATE) data_regularizacao,
SAFE_CAST(motivo_cancelamento AS STRING) motivo_cancelamento
from basedosdados-staging.br_tse_filiacao_partidaria_staging.filiacao_partidaria as t