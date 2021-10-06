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
CREATE VIEW basedosdados-dev.br_cgu_licitacoes.licitacao AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(id_licitacao AS STRING) id_licitacao,
SAFE_CAST(id_ug AS STRING) id_ug,
SAFE_CAST(nome_ug AS STRING) nome_ug,
SAFE_CAST(modalidade_compra AS STRING) modalidade_compra,
SAFE_CAST(numero_processo AS STRING) numero_processo,
SAFE_CAST(objeto AS STRING) objeto,
SAFE_CAST(situacao AS STRING) situacao,
SAFE_CAST(id_orgao_superior AS STRING) id_orgao_superior,
SAFE_CAST(nome_orgao_superior AS STRING) nome_orgao_superior,
SAFE_CAST(id_orgao AS STRING) id_orgao,
SAFE_CAST(nome_orgao AS STRING) nome_orgao,
SAFE_CAST(municipio AS STRING) municipio,
SAFE_CAST(data_resultado_compra AS DATE) data_resultado_compra,
SAFE_CAST(data_abertura AS DATE) data_abertura,
SAFE_CAST(valor AS FLOAT64) valor
FROM basedosdados-dev.br_cgu_licitacoes_staging.licitacao AS t