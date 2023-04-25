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

CREATE VIEW basedosdados-dev.br_bcb_sicor.recurso_publico_mutuario AS
SELECT 
SAFE_CAST(id_referencia_bacen AS STRING) id_referencia_bacen,
SAFE_CAST(indicador_sexo AS INT64) indicador_sexo,
SAFE_CAST(tipo_cpf_cnpj AS STRING) tipo_cpf_cnpj,
SAFE_CAST(tipo_beneficiario AS STRING) tipo_beneficiario,
SAFE_CAST(id_dap AS STRING) id_dap
FROM basedosdados-dev.br_bcb_sicor_staging.recurso_publico_mutuario AS t