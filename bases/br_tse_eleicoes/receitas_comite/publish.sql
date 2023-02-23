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

CREATE VIEW basedosdados-dev.br_tse_eleicoes.receitas_comite AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(tipo_eleicao AS STRING) tipo_eleicao,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_municipio_tse AS STRING) id_municipio_tse,
SAFE_CAST(tipo_comite AS STRING) tipo_comite,
SAFE_CAST(sequencial_comite AS STRING) sequencial_comite,
SAFE_CAST(numero_partido AS STRING) numero_partido,
SAFE_CAST(sigla_partido AS STRING) sigla_partido,
SAFE_CAST(data_receita AS DATE) data_receita,
SAFE_CAST(valor_receita AS FLOAT64) valor_receita,
SAFE_CAST(origem_receita AS STRING) origem_receita,
SAFE_CAST(fonte_receita AS STRING) fonte_receita,
SAFE_CAST(natureza_receita AS STRING) natureza_receita,
SAFE_CAST(situacao_receita AS STRING) situacao_receita,
SAFE_CAST(descricao_receita AS STRING) descricao_receita,
SAFE_CAST(tipo_documento AS STRING) tipo_documento,
SAFE_CAST(numero_documento AS STRING) numero_documento,
SAFE_CAST(nome_membro AS STRING) nome_membro,
SAFE_CAST(cpf_membro AS STRING) cpf_membro,
SAFE_CAST(cnpj_prestador_contas AS STRING) cnpj_prestador_contas,
SAFE_CAST(cpf_cnpj_doador AS STRING) cpf_cnpj_doador,
SAFE_CAST(sigla_uf_doador AS STRING) sigla_uf_doador,
SAFE_CAST(nome_doador AS STRING) nome_doador,
SAFE_CAST(nome_doador_rf AS STRING) nome_doador_rf,
SAFE_CAST(descricao_cnae_2_doador AS STRING) descricao_cnae_2_doador,
SAFE_CAST(numero_partido_doador AS STRING) numero_partido_doador,
SAFE_CAST(numero_candidato_doador AS STRING) numero_candidato_doador,
SAFE_CAST(cnae_2_doador AS STRING) cnae_2_doador,
SAFE_CAST(cpf_cnpj_doador_orig AS STRING) cpf_cnpj_doador_orig,
SAFE_CAST(nome_doador_orig AS STRING) nome_doador_orig,
SAFE_CAST(tipo_doador_orig AS STRING) tipo_doador_orig,
SAFE_CAST(descricao_cnae_2_doador_orig AS STRING) descricao_cnae_2_doador_orig,
SAFE_CAST(nome_doador_orig_rf AS STRING) nome_doador_orig_rf
FROM basedosdados-dev.br_tse_eleicoes_staging.receitas_comite AS t