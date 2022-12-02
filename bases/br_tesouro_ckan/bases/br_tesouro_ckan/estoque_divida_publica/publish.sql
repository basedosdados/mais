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

CREATE VIEW basedosdados-dev.br_tesouro_estoque_divida_publica.br_tesouro_estoque_divida_publica AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(id_divida AS STRING) id_divida,
SAFE_CAST(vencimento_divida AS DATE) vencimento_divida,
SAFE_CAST(tipo_divida AS STRING) tipo_divida,
SAFE_CAST(classe_carteira AS STRING) classe_carteira,
SAFE_CAST(valor_estoque AS FLOAT64) valor_estoque,
SAFE_CAST(quantidade_estoque AS INT64) quantidade_estoque
FROM basedosdados-dev.br_tesouro_estoque_divida_publica_staging.br_tesouro_estoque_divida_publica AS t