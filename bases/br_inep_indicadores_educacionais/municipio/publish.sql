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

CREATE VIEW basedosdados.br_inep_indicadores_educacionais.municipio AS
SELECT 
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(situacao AS STRING) situacao,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(atu_educacao_infantil AS FLOAT64) atu_educacao_infantil,
SAFE_CAST(atu_educacao_infantil_creche AS FLOAT64) atu_educacao_infantil_creche,
SAFE_CAST(atu_educacao_infantil_pre_escola AS FLOAT64) atu_educacao_infantil_pre_escola,
SAFE_CAST(atu_ensino_fund AS FLOAT64) atu_ensino_fund,
SAFE_CAST(atu_ensino_fund_anos_iniciais AS FLOAT64) atu_ensino_fund_anos_iniciais,
SAFE_CAST(atu_ensino_fund_anos_finais AS FLOAT64) atu_ensino_fund_anos_finais,
SAFE_CAST(atu_ensino_fund_1_ano AS FLOAT64) atu_ensino_fund_1_ano,
SAFE_CAST(atu_ensino_fund_2_ano AS FLOAT64) atu_ensino_fund_2_ano,
SAFE_CAST(atu_ensino_fund_3_ano AS FLOAT64) atu_ensino_fund_3_ano,
SAFE_CAST(atu_ensino_fund_4_ano AS FLOAT64) atu_ensino_fund_4_ano,
SAFE_CAST(atu_ensino_fund_5_ano AS FLOAT64) atu_ensino_fund_5_ano,
SAFE_CAST(atu_ensino_fund_6_ano AS FLOAT64) atu_ensino_fund_6_ano,
SAFE_CAST(atu_ensino_fund_7_ano AS FLOAT64) atu_ensino_fund_7_ano,
SAFE_CAST(atu_ensino_fund_8_ano AS FLOAT64) atu_ensino_fund_8_ano,
SAFE_CAST(atu_ensino_fund_9_ano AS FLOAT64) atu_ensino_fund_9_ano,
SAFE_CAST(atu_ensino_fund_turmas_unif AS FLOAT64) atu_ensino_fund_turmas_unif,
SAFE_CAST(atu_ensino_medio AS FLOAT64) atu_ensino_medio,
SAFE_CAST(atu_ensino_medio_1_ano AS FLOAT64) atu_ensino_medio_1_ano,
SAFE_CAST(atu_ensino_medio_2_ano AS FLOAT64) atu_ensino_medio_2_ano,
SAFE_CAST(atu_ensino_medio_3_ano AS FLOAT64) atu_ensino_medio_3_ano,
SAFE_CAST(atu_ensino_medio_4_ano AS FLOAT64) atu_ensino_medio_4_ano,
SAFE_CAST(atu_ensino_medio_nao_seriado AS FLOAT64) atu_ensino_medio_nao_seriado
from basedosdados-staging.br_inep_indicadores_educacionais_staging.municipio as t