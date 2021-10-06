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
CREATE VIEW basedosdados-dev.br_cgu_licitacoes.empenho_relacionado AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(id_licitacao AS STRING) id_licitacao,
SAFE_CAST(id_ug AS STRING) id_ug,
SAFE_CAST(nome_ug AS STRING) nome_ug,
SAFE_CAST(modalidade_compra AS STRING) modalidade_compra,
SAFE_CAST(numero_processo AS STRING) numero_processo,
SAFE_CAST(id_empenho AS STRING) id_empenho,
SAFE_CAST(data_emissao AS DATE) data_emissao,
SAFE_CAST(observacao AS STRING) observacao,
SAFE_CAST(valor AS FLOAT64) valor
FROM basedosdados-dev.br_cgu_licitacoes_staging.empenho_relacionado AS t