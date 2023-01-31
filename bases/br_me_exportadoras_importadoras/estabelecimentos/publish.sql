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

CREATE VIEW basedosdados-dev.br_me_exportadoras_importadoras.estabelecimentos AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(cnpj AS STRING) cnpj,
SAFE_CAST(razao_social AS STRING) razao_social,
SAFE_CAST(id_exportacao_importacao AS STRING) id_exportacao_importacao,
SAFE_CAST(cnae_2_primaria AS STRING) cnae_2_primaria,
SAFE_CAST(id_natureza_juridica AS STRING) id_natureza_juridica,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(cep AS STRING) cep,
SAFE_CAST(bairro AS STRING) bairro,
SAFE_CAST(endereco AS STRING) endereco,
SAFE_CAST(numero AS INT64) numero
FROM basedosdados-dev.br_me_exportadoras_importadoras_staging.estabelecimentos AS t