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

CREATE VIEW basedosdados-dev.br_anp_precos_combustiveis.microdados AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(bairro_revenda AS STRING) bairro_revenda,
SAFE_CAST(cep_revenda AS STRING) cep_revenda,
SAFE_CAST(endereco_revenda AS STRING) endereco_revenda,
SAFE_CAST(cnpj_revenda AS STRING) cnpj_revenda,
SAFE_CAST(nome_estabelecimento AS STRING) nome_estabelecimento,
SAFE_CAST(bandeira_revenda AS STRING) bandeira_revenda,
SAFE_CAST(data_coleta AS DATE) data_coleta,
SAFE_CAST(produto AS STRING) produto,
SAFE_CAST(unidade_medida AS STRING) unidade_medida,
SAFE_CAST(preco_compra AS FLOAT64) preco_compra,
SAFE_CAST(preco_venda AS FLOAT64) preco_venda
FROM basedosdados-dev.br_anp_precos_combustiveis_staging.microdados AS t