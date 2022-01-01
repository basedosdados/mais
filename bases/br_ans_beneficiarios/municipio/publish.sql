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

CREATE VIEW basedosdados-dev.br_ans_beneficiarios.municipio AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(tipo_contrato AS STRING) tipo_contrato,
SAFE_CAST(vigencia AS STRING) vigencia,
SAFE_CAST(segmento AS STRING) segmento,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(faixa_etaria AS STRING) faixa_etaria,
SAFE_CAST(beneficiarios_assistencia_medica AS INT64) beneficiarios_assistencia_medica,
SAFE_CAST(beneficiarios_odontologico AS INT64) beneficiarios_odontologico,
SAFE_CAST(beneficiarios_total AS INT64) beneficiarios_total
FROM basedosdados-dev.br_ans_beneficiarios_staging.municipio AS t