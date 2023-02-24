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

CREATE VIEW basedosdados-dev.br_sgp_informacao.despesas_cartao_corporativo AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(presidente AS STRING) presidente,
SAFE_CAST(indicador_gastos_vice_presidencia AS INT64) indicador_gastos_vice_presidencia,
SAFE_CAST(data_pagamento AS DATE) data_pagamento,
SAFE_CAST(cpf_servidor AS STRING) cpf_servidor,
SAFE_CAST(cpf_cnpj_fornecedor AS STRING) cpf_cnpj_fornecedor,
SAFE_CAST(nome_fornecedor AS STRING) nome_fornecedor,
SAFE_CAST(tipo AS STRING) tipo,
SAFE_CAST(subelemento_despesa AS STRING) subelemento_despesa,
SAFE_CAST(cdic AS STRING) cdic,
SAFE_CAST(valor AS FLOAT64) valor
FROM basedosdados-dev.br_sgp_informacao_staging.despesas_cartao_corporativo AS t