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
CREATE VIEW `basedosdados.br_me_socios.empresa` AS
SELECT
SAFE_CAST(CNPJ AS STRING) cnpj,
SAFE_CAST(identificador_matriz_filial AS INT64) identificador_matriz_filial,
SAFE_CAST(razao_social AS STRING) razao_social,
SAFE_CAST(nome_fantasia AS STRING) nome_fantasia,
SAFE_CAST(situacao_cadastral AS INT64) situacao_cadastral,
SAFE_CAST(data_situacao_cadastral AS DATE) data_situacao_cadastral,
SAFE_CAST(motivo_situacao_cadastral AS INT64) motivo_situacao_cadastral,
SAFE_CAST(nome_cidade_exterior AS STRING) nome_cidade_exterior,
SAFE_CAST(codigo_natureza_juridica AS INT64) codigo_natureza_juridica,
SAFE_CAST(data_inicio_atividade AS DATE) data_inicio_atividade,
SAFE_CAST(CNAE_fiscal AS STRING) cnae_fiscal,
SAFE_CAST(descricao_tipo_logradouro AS STRING) descricao_tipo_logradouro,
SAFE_CAST(logradouro AS STRING) logradouro,
SAFE_CAST(numero AS STRING) numero,
SAFE_CAST(complemento AS STRING) complemento,
SAFE_CAST(bairro AS STRING) bairro,
SAFE_CAST(CEP AS STRING) cep,
SAFE_CAST(id_municipio_RF AS INT64) id_municipio_rf,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(estado_abrev AS STRING) sigla_uf,
SAFE_CAST(DDD_telefone_1 AS STRING) ddd_telefone_1,
SAFE_CAST(DDD_telefone_2 AS STRING) ddd_telefone_2,
SAFE_CAST(DDD_fax AS STRING) ddd_fax,
SAFE_CAST(qualificacao_do_responsavel AS INT64) qualificacao_do_responsavel,
SAFE_CAST(capital_social AS FLOAT64) capital_social,
SAFE_CAST(porte AS INT64) porte,
SAFE_CAST(opcao_pelo_simples AS INT64) opcao_pelo_simples,
SAFE_CAST(data_opcao_pelo_simples AS DATE) data_opcao_pelo_simples,
SAFE_CAST(data_exclusao_do_simples AS DATE) data_exclusao_do_simples,
SAFE_CAST(opcao_pelo_MEI AS INT64) opcao_pelo_mei,
SAFE_CAST(situacao_especial AS STRING) situacao_especial,
SAFE_CAST(data_situacao_especial AS DATE) data_situacao_especial
from basedosdados-staging.br_me_socios_staging.empresa as t