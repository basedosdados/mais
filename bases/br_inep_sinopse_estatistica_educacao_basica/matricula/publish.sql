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

CREATE VIEW basedosdados-dev.br_inep_sinopse_estatistica_educacao_basica.matricula AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(mat_ei AS FLOAT64) mat_ei,
SAFE_CAST(mat_ei_creche AS FLOAT64) mat_ei_creche,
SAFE_CAST(mat_ei_pre_escola AS FLOAT64) mat_ei_pre_escola,
SAFE_CAST(mat_ef AS FLOAT64) mat_ef,
SAFE_CAST(mat_ef_anos_iniciais AS FLOAT64) mat_ef_anos_iniciais,
SAFE_CAST(mat_ef_anos_finais AS FLOAT64) mat_ef_anos_finais,
SAFE_CAST(mat_em AS FLOAT64) mat_em,
SAFE_CAST(mat_em_propedeutico AS FLOAT64) mat_em_propedeutico,
SAFE_CAST(mat_em_normal AS FLOAT64) mat_em_normal,
SAFE_CAST(mat_em_integrado AS FLOAT64) mat_em_integrado,
SAFE_CAST(mat_ep AS FLOAT64) mat_ep,
SAFE_CAST(mat_ep_tem AS FLOAT64) mat_ep_tem,
SAFE_CAST(mat_ep_tem_aem AS FLOAT64) mat_ep_tem_aem,
SAFE_CAST(mat_ep_tem_ctc AS FLOAT64) mat_ep_tem_ctc,
SAFE_CAST(mat_ep_tem_cts AS FLOAT64) mat_ep_tem_cts,
SAFE_CAST(mat_ep_fic AS FLOAT64) mat_ep_fic,
SAFE_CAST(mat_ep_fic_cfc AS FLOAT64) mat_ep_fic_cfc,
SAFE_CAST(mat_ep_fic_eja AS FLOAT64) mat_ep_fic_eja,
SAFE_CAST(mat_eja AS FLOAT64) mat_eja,
SAFE_CAST(mat_eja_ef AS FLOAT64) mat_eja_ef,
SAFE_CAST(mat_eja_em AS FLOAT64) mat_eja_em,
SAFE_CAST(mat_ee AS FLOAT64) mat_ee,
SAFE_CAST(mat_ee_cc AS FLOAT64) mat_ee_cc,
SAFE_CAST(mat_ee_ce AS FLOAT64) mat_ee_ce
from basedosdados-dev.br_inep_sinopse_estatistica_educacao_basica_staging.matricula as t