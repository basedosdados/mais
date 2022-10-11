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

CREATE VIEW basedosdados-dev.br_tse_eleicoes.despesas_candidato AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(turno AS INT64) turno,
SAFE_CAST(tipo_eleicao AS STRING) tipo_eleicao,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_municipio_tse AS STRING) id_municipio_tse,
SAFE_CAST(sequencial_candidato AS STRING) sequencial_candidato,
SAFE_CAST(numero_candidato AS STRING) numero_candidato,
SAFE_CAST(cpf_candidato AS STRING) cpf_candidato,
SAFE_CAST(id_candidato_bd AS STRING) id_candidato_bd,
SAFE_CAST(nome_candidato AS STRING) nome_candidato,
SAFE_CAST(cpf_vice_suplente AS STRING) cpf_vice_suplente,
SAFE_CAST(numero_partido AS STRING) numero_partido,
SAFE_CAST(sigla_partido AS STRING) sigla_partido,
SAFE_CAST(nome_partido AS STRING) nome_partido,
SAFE_CAST(cargo AS STRING) cargo,
SAFE_CAST(sequencial_despesa AS STRING) sequencial_despesa,
SAFE_CAST(data_despesa AS DATE) data_despesa,
SAFE_CAST(tipo_despesa AS STRING) tipo_despesa,
SAFE_CAST(descricao_despesa AS STRING) descricao_despesa,
SAFE_CAST(origem_despesa AS STRING) origem_despesa,
SAFE_CAST(valor_despesa AS FLOAT64) valor_despesa,
SAFE_CAST(tipo_prestacao_contas AS STRING) tipo_prestacao_contas,
SAFE_CAST(data_prestacao_contas AS DATE) data_prestacao_contas,
SAFE_CAST(sequencial_prestador_contas AS STRING) sequencial_prestador_contas,
SAFE_CAST(cnpj_prestador_contas AS STRING) cnpj_prestador_contas,
SAFE_CAST(cnpj_candidato AS STRING) cnpj_candidato,
SAFE_CAST(tipo_documento AS STRING) tipo_documento,
SAFE_CAST(numero_documento AS STRING) numero_documento,
SAFE_CAST(especie_recurso AS STRING) especie_recurso,
SAFE_CAST(fonte_recurso AS STRING) fonte_recurso,
SAFE_CAST(cpf_cnpj_fornecedor AS STRING) cpf_cnpj_fornecedor,
SAFE_CAST(nome_fornecedor AS STRING) nome_fornecedor,
SAFE_CAST(nome_fornecedor_rf AS STRING) nome_fornecedor_rf,
SAFE_CAST(cnae_2_fornecedor AS STRING) cnae_2_fornecedor,
SAFE_CAST(descricao_cnae_2_fornecedor AS STRING) descricao_cnae_2_fornecedor,
SAFE_CAST(tipo_fornecedor AS STRING) tipo_fornecedor,
SAFE_CAST(esfera_partidaria_fornecedor AS STRING) esfera_partidaria_fornecedor,
SAFE_CAST(sigla_uf_fornecedor AS STRING) sigla_uf_fornecedor,
SAFE_CAST(id_municipio_tse_fornecedor AS STRING) id_municipio_tse_fornecedor,
SAFE_CAST(sequencial_candidato_fornecedor AS STRING) sequencial_candidato_fornecedor,
SAFE_CAST(numero_candidato_fornecedor AS STRING) numero_candidato_fornecedor,
SAFE_CAST(numero_partido_fornecedor AS STRING) numero_partido_fornecedor,
SAFE_CAST(sigla_partido_fornecedor AS STRING) sigla_partido_fornecedor,
SAFE_CAST(nome_partido_fornecedor AS STRING) nome_partido_fornecedor,
SAFE_CAST(cargo_fornecedor AS STRING) cargo_fornecedor
FROM basedosdados-dev.br_tse_eleicoes_staging.despesas_candidato AS t