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

CREATE VIEW basedosdados-dev.mundo_coinmarketcap_criptmoeda.bitcoin AS
SELECT 
SAFE_CAST(data AS DATE) data,
SAFE_CAST(hora_maior_preco AS TIME) hora_maior_preco,
SAFE_CAST(hora_menor_preco AS TIME) hora_menor_preco,
SAFE_CAST(preco_abertura AS FLOAT64) preco_abertura,
SAFE_CAST(maior_preco AS FLOAT64) maior_preco,
SAFE_CAST(menor_preco AS FLOAT64) menor_preco,
SAFE_CAST(preco_encerramento AS FLOAT64) preco_encerramento,
SAFE_CAST(volume AS FLOAT64) volume,
SAFE_CAST(capitalizacao_mercado AS FLOAT64) capitalizacao_mercado
FROM basedosdados-dev.mundo_coinmarketcap_criptmoeda_staging.bitcoin AS t