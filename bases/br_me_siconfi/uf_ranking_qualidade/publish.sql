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

CREATE VIEW basedosdados-dev.br_me_siconfi.uf_ranking_qualidade AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_uf AS STRING) id_uf,
SAFE_CAST(indicador_qualidade_informacao_contabil_fiscal AS STRING) indicador_qualidade_informacao_contabil_fiscal,
SAFE_CAST(posicao_ranking AS INT64) posicao_ranking,
SAFE_CAST(quantidade_acertos_total AS FLOAT64) quantidade_acertos_total,
SAFE_CAST(proporcao_acertos AS FLOAT64) proporcao_acertos,
SAFE_CAST(dimensao_I AS FLOAT64) dimensao_I,
SAFE_CAST(dimensao_II AS INT64) dimensao_II,
SAFE_CAST(dimensao_III AS INT64) dimensao_III,
SAFE_CAST(dimensao_IV AS INT64) dimensao_IV
FROM basedosdados-dev.br_me_siconfi_staging.uf_ranking_qualidade AS t