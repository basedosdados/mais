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
CREATE VIEW basedosdados-dev.br_me_pensionistas.microdados AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(nome_servidor AS STRING) nome_servidor,
SAFE_CAST(cpf_servidor AS STRING) cpf_servidor,
SAFE_CAST(data_nascimento_servidor AS DATE) data_nascimento_servidor,
SAFE_CAST(data_falecimento_servidor AS DATE) data_falecimento_servidor,
SAFE_CAST(matricula_servidor AS STRING) matricula_servidor,
SAFE_CAST(nome_orgao AS STRING) nome_orgao,
SAFE_CAST(sigla_orgao AS STRING) sigla_orgao,
SAFE_CAST(codigo_orgao_superior AS STRING) codigo_orgao_superior,
SAFE_CAST(cargo_servidor AS STRING) cargo_servidor,
SAFE_CAST(escolaridade_cargo AS STRING) escolaridade_cargo,
SAFE_CAST(classe_servidor AS STRING) classe_servidor,
SAFE_CAST(padrao_servidor AS STRING) padrao_servidor,
SAFE_CAST(referencia_servidor AS STRING) referencia_servidor,
SAFE_CAST(nivel_servidor AS STRING) nivel_servidor,
SAFE_CAST(ocorrencia_isp_servidor AS STRING) ocorrencia_isp_servidor,
SAFE_CAST(data_ocorrencia_isp_servidor AS DATE) data_ocorrencia_isp_servidor,
SAFE_CAST(nome_beneficiario AS STRING) nome_beneficiario,
SAFE_CAST(cpf_beneficiario AS STRING) cpf_beneficiario,
SAFE_CAST(data_nascimento_beneficiario AS DATE) data_nascimento_beneficiario,
SAFE_CAST(sigla_uf_upag_vinculacao AS STRING) sigla_uf_upag_vinculacao,
SAFE_CAST(tipo_beneficiario AS STRING) tipo_beneficiario,
SAFE_CAST(tipo_pensao AS STRING) tipo_pensao,
SAFE_CAST(natureza_pensao AS STRING) natureza_pensao,
SAFE_CAST(data_inicio_beneficio AS DATE) data_inicio_beneficio,
SAFE_CAST(data_fim_beneficio AS DATE) data_fim_beneficio,
SAFE_CAST(rendimento_bruto AS FLOAT64) rendimento_bruto,
SAFE_CAST(rendimento_liquido AS FLOAT64) rendimento_liquido,
SAFE_CAST(pagamento_suspenso AS STRING) pagamento_suspenso
FROM basedosdados-dev.br_me_pensionistas_staging.microdados AS t