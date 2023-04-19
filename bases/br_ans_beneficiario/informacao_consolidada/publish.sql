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

CREATE VIEW basedosdados.br_ans_beneficiario.informacao_consolidada AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(codigo_operadora AS STRING) codigo_operadora,
SAFE_CAST(razao_social AS STRING) razao_social,
SAFE_CAST(cnpj AS STRING) cnpj,
SAFE_CAST(modalidade_operadora AS STRING) modalidade_operadora,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio_6 AS STRING) id_municipio_6,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(faixa_etaria AS STRING) faixa_etaria,
SAFE_CAST(faixa_etaria_reajuste AS STRING) faixa_etaria_reajuste,
SAFE_CAST(codigo_plano AS STRING) codigo_plano,
SAFE_CAST(tipo_vigencia_plano AS STRING) tipo_vigencia_plano,
SAFE_CAST(contratacao_beneficiario AS STRING) contratacao_beneficiario,
SAFE_CAST(segmentacao_beneficiario AS STRING) segmentacao_beneficiario,
SAFE_CAST(abrangencia_beneficiario AS STRING) abrangencia_beneficiario,
SAFE_CAST(cobertura_assistencia_beneficiario AS STRING) cobertura_assistencia_beneficiario,
SAFE_CAST(tipo_vinculo AS STRING) tipo_vinculo,
SAFE_CAST(quantidade_beneficiario_ativo AS INT64) quantidade_beneficiario_ativo,
SAFE_CAST(quantidade_beneficiario_aderido AS INT64) quantidade_beneficiario_aderido,
SAFE_CAST(quantidade_beneficiario_cancelado AS INT64) quantidade_beneficiario_cancelado
FROM basedosdados-dev.br_ans_beneficiario_staging.informacao_consolidada AS t
