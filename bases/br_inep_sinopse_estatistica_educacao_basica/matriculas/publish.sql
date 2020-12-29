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

CREATE VIEW basedosdados.br_inep_sinopse_estatistica_educacao_basica.matriculas AS
SELECT 
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(mat_educacao_infantil AS STRING) mat_educacao_infantil,
SAFE_CAST(mat_educacao_infantil_creche AS STRING) mat_educacao_infantil_creche,
SAFE_CAST(mat_educacao_infantil_pre_escola AS STRING) mat_educacao_infantil_pre_escola,
SAFE_CAST(mat_ensino_fund AS STRING) mat_ensino_fund,
SAFE_CAST(mat_ensino_fund_anos_iniciais AS STRING) mat_ensino_fund_anos_iniciais,
SAFE_CAST(mat_ensino_fund_anos_finais AS STRING) mat_ensino_fund_anos_finais,
SAFE_CAST(mat_ensino_medio AS STRING) mat_ensino_medio,
SAFE_CAST(mat_ensino_medio_propedeutico AS STRING) mat_ensino_medio_propedeutico,
SAFE_CAST(mat_ensino_medio_normal AS STRING) mat_ensino_medio_normal,
SAFE_CAST(mat_ensino_medio_integrado AS STRING) mat_ensino_medio_integrado,
SAFE_CAST(mat_educacao_prof AS STRING) mat_educacao_prof,
SAFE_CAST(mat_educacao_prof_tem AS STRING) mat_educacao_prof_tem,
SAFE_CAST(mat_educacao_prof_tem_aem AS STRING) mat_educacao_prof_tem_aem,
SAFE_CAST(mat_educacao_prof_tem_ctc AS STRING) mat_educacao_prof_tem_ctc,
SAFE_CAST(mat_educacao_prof_tem_cts AS STRING) mat_educacao_prof_tem_cts,
SAFE_CAST(mat_educacao_prof_fic AS STRING) mat_educacao_prof_fic,
SAFE_CAST(mat_educacao_prof_fic_cfc AS STRING) mat_educacao_prof_fic_cfc,
SAFE_CAST(mat_educacao_prof_fic_eja AS STRING) mat_educacao_prof_fic_eja,
SAFE_CAST(mat_eja AS STRING) mat_eja,
SAFE_CAST(mat_eja_ensino_fund AS STRING) mat_eja_ensino_fund,
SAFE_CAST(mat_eja_ensino_medio AS STRING) mat_eja_ensino_medio,
SAFE_CAST(mat_educacao_especial AS STRING) mat_educacao_especial,
SAFE_CAST(mat_educacao_especial_cc AS STRING) mat_educacao_especial_cc,
SAFE_CAST(mat_educacao_especial_ce AS STRING) mat_educacao_especial_ce
from basedosdados-staging.br_inep_sinopse_estatistica_educacao_basica_staging.matriculas as t