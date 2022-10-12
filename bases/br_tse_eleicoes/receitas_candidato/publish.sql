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

CREATE VIEW basedosdados-dev.br_tse_eleicoes.receitas_candidato AS
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
SAFE_CAST(cnpj_candidato AS STRING) cnpj_candidato,
SAFE_CAST(titulo_eleitor_candidato AS STRING) titulo_eleitor_candidato,
SAFE_CAST(id_candidato_bd AS STRING) id_candidato_bd,
SAFE_CAST(nome_candidato AS STRING) nome_candidato,
SAFE_CAST(cpf_vice_suplente AS STRING) cpf_vice_suplente,
SAFE_CAST(numero_partido AS STRING) numero_partido,
SAFE_CAST(nome_partido AS STRING) nome_partido,
SAFE_CAST(sigla_partido AS STRING) sigla_partido,
SAFE_CAST(cargo AS STRING) cargo,
SAFE_CAST(sequencial_receita AS STRING) sequencial_receita,
SAFE_CAST(data_receita AS DATE) data_receita,
SAFE_CAST(fonte_receita AS STRING) fonte_receita,
SAFE_CAST(origem_receita AS STRING) origem_receita,
SAFE_CAST(natureza_receita AS STRING) natureza_receita,
SAFE_CAST(especie_receita AS STRING) especie_receita,
SAFE_CAST(situacao_receita AS STRING) situacao_receita,
SAFE_CAST(descricao_receita AS STRING) descricao_receita,
SAFE_CAST(valor_receita AS FLOAT64) valor_receita,
SAFE_CAST(sequencial_candidato_doador AS STRING) sequencial_candidato_doador,
SAFE_CAST(cpf_cnpj_doador AS STRING) cpf_cnpj_doador,
SAFE_CAST(sigla_uf_doador AS STRING) sigla_uf_doador,
SAFE_CAST(id_municipio_tse_doador AS STRING) id_municipio_tse_doador,
SAFE_CAST(nome_doador AS STRING) nome_doador,
SAFE_CAST(nome_doador_rf AS STRING) nome_doador_rf,
SAFE_CAST(cargo_candidato_doador AS STRING) cargo_candidato_doador,
SAFE_CAST(numero_partido_doador AS STRING) numero_partido_doador,
SAFE_CAST(sigla_partido_doador AS STRING) sigla_partido_doador,
SAFE_CAST(nome_partido_doador AS STRING) nome_partido_doador,
SAFE_CAST(esfera_partidaria_doador AS STRING) esfera_partidaria_doador,
SAFE_CAST(numero_candidato_doador AS STRING) numero_candidato_doador,
SAFE_CAST(cnae_2_doador AS STRING) cnae_2_doador,
SAFE_CAST(descricao_cnae_2_doador AS STRING) descricao_cnae_2_doador,
SAFE_CAST(cpf_cnpj_doador_orig AS STRING) cpf_cnpj_doador_orig,
SAFE_CAST(nome_doador_orig AS STRING) nome_doador_orig,
SAFE_CAST(nome_doador_orig_rf AS STRING) nome_doador_orig_rf,
SAFE_CAST(tipo_doador_orig AS STRING) tipo_doador_orig,
SAFE_CAST(descricao_cnae_2_doador_orig AS STRING) descricao_cnae_2_doador_orig,
SAFE_CAST(nome_administrador AS STRING) nome_administrador,
SAFE_CAST(cpf_administrador AS STRING) cpf_administrador,
SAFE_CAST(numero_recibo_eleitoral AS STRING) numero_recibo_eleitoral,
SAFE_CAST(numero_documento AS STRING) numero_documento,
SAFE_CAST(numero_recibo_doacao AS STRING) numero_recibo_doacao,
SAFE_CAST(numero_documento_doacao AS STRING) numero_documento_doacao,
SAFE_CAST(tipo_prestacao_contas AS STRING) tipo_prestacao_contas,
SAFE_CAST(data_prestacao_contas AS DATE) data_prestacao_contas,
SAFE_CAST(sequencial_prestador_contas AS STRING) sequencial_prestador_contas,
SAFE_CAST(cnpj_prestador_contas AS STRING) cnpj_prestador_contas,
SAFE_CAST(entrega_conjunto AS STRING) entrega_conjunto
FROM basedosdados-dev.br_tse_eleicoes_staging.receitas_candidato AS t