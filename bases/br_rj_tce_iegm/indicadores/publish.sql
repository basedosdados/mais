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

CREATE VIEW basedosdados-dev.br_rj_tce_iegm.indicadores AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(categoria AS STRING) categoria,
SAFE_CAST(meio_ambiente AS FLOAT64) meio_ambiente,
SAFE_CAST(protecao_cidade AS FLOAT64) protecao_cidade,
SAFE_CAST(educacao AS FLOAT64) educacao,
SAFE_CAST(gestao_fiscal AS FLOAT64) gestao_fiscal,
SAFE_CAST(governanca_ti AS FLOAT64) governanca_ti,
SAFE_CAST(planejamento AS FLOAT64) planejamento,
SAFE_CAST(saude AS FLOAT64) saude,
SAFE_CAST(nota_final AS FLOAT64) nota_final
FROM basedosdados-dev.br_rj_tce_iegm_staging.indicadores AS t