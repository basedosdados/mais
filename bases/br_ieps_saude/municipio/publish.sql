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

CREATE VIEW basedosdados-dev.br_ieps_saude.municipio AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(nome AS STRING) nome,
SAFE_CAST(cob_ab AS FLOAT64) cob_ab,
SAFE_CAST(cob_acs AS FLOAT64) cob_acs,
SAFE_CAST(cob_esf AS FLOAT64) cob_esf,
SAFE_CAST(cob_vac_bcg AS FLOAT64) cob_vac_bcg,
SAFE_CAST(cob_vac_rota AS FLOAT64) cob_vac_rota,
SAFE_CAST(cob_vac_menin AS FLOAT64) cob_vac_menin,
SAFE_CAST(cob_vac_pneumo AS FLOAT64) cob_vac_pneumo,
SAFE_CAST(cob_vac_polio AS FLOAT64) cob_vac_polio,
SAFE_CAST(cob_vac_tvd1 AS FLOAT64) cob_vac_tvd1,
SAFE_CAST(cob_vac_penta AS FLOAT64) cob_vac_penta,
SAFE_CAST(cob_vac_hepb AS FLOAT64) cob_vac_hepb,
SAFE_CAST(cob_vac_hepa AS FLOAT64) cob_vac_hepa,
SAFE_CAST(pct_prenatal_adeq AS FLOAT64) pct_prenatal_adeq,
SAFE_CAST(pct_prenatal_zero AS FLOAT64) pct_prenatal_zero,
SAFE_CAST(pct_prenatal_1a6 AS FLOAT64) pct_prenatal_1a6,
SAFE_CAST(pct_prenatal_7m AS FLOAT64) pct_prenatal_7m,
SAFE_CAST(tx_mort_inf_ibge AS FLOAT64) tx_mort_inf_ibge,
SAFE_CAST(n_obitos AS INT64) n_obitos,
SAFE_CAST(n_obitos_csap AS INT64) n_obitos_csap,
SAFE_CAST(n_obitos_evit AS INT64) n_obitos_evit,
SAFE_CAST(n_obitos_maldef AS INT64) n_obitos_maldef,
SAFE_CAST(tx_mort AS FLOAT64) tx_mort,
SAFE_CAST(tx_mort_csap AS FLOAT64) tx_mort_csap,
SAFE_CAST(tx_mort_evit AS FLOAT64) tx_mort_evit,
SAFE_CAST(pct_mort_maldef AS FLOAT64) pct_mort_maldef,
SAFE_CAST(tx_mort_aj_oms AS FLOAT64) tx_mort_aj_oms,
SAFE_CAST(tx_mort_csap_aj_oms AS FLOAT64) tx_mort_csap_aj_oms,
SAFE_CAST(tx_mort_evit_aj_oms AS FLOAT64) tx_mort_evit_aj_oms,
SAFE_CAST(tx_mort_aj_cens AS FLOAT64) tx_mort_aj_cens,
SAFE_CAST(tx_mort_csap_aj_cens AS FLOAT64) tx_mort_csap_aj_cens,
SAFE_CAST(tx_mort_evit_aj_cens AS FLOAT64) tx_mort_evit_aj_cens,
SAFE_CAST(n_hosp AS INT64) n_hosp,
SAFE_CAST(n_hosp_csap AS INT64) n_hosp_csap,
SAFE_CAST(tx_hosp AS FLOAT64) tx_hosp,
SAFE_CAST(tx_hosp_csap AS FLOAT64) tx_hosp_csap,
SAFE_CAST(n_leitouti_sus AS INT64) n_leitouti_sus,
SAFE_CAST(n_leito_sus AS INT64) n_leito_sus,
SAFE_CAST(tx_leito_sus AS FLOAT64) tx_leito_sus,
SAFE_CAST(tx_leitouti_sus AS FLOAT64) tx_leitouti_sus,
SAFE_CAST(n_enf AS INT64) n_enf,
SAFE_CAST(n_med AS INT64) n_med,
SAFE_CAST(n_enf_ch AS INT64) n_enf_ch,
SAFE_CAST(n_med_ch AS INT64) n_med_ch,
SAFE_CAST(tx_med AS FLOAT64) tx_med,
SAFE_CAST(tx_enf AS FLOAT64) tx_enf,
SAFE_CAST(tx_med_ch AS FLOAT64) tx_med_ch,
SAFE_CAST(tx_enf_ch AS FLOAT64) tx_enf_ch,
SAFE_CAST(n_leito_nsus AS INT64) n_leito_nsus,
SAFE_CAST(n_leitouti_nsus AS INT64) n_leitouti_nsus,
SAFE_CAST(tx_leito_nsus AS FLOAT64) tx_leito_nsus,
SAFE_CAST(tx_leitouti_nsus AS FLOAT64) tx_leitouti_nsus,
SAFE_CAST(cob_priv AS FLOAT64) cob_priv,
SAFE_CAST(pct_desp_recp_saude_mun AS FLOAT64) pct_desp_recp_saude_mun,
SAFE_CAST(desp_tot_saude_pc_mun AS FLOAT64) desp_tot_saude_pc_mun,
SAFE_CAST(desp_recp_saude_pc_mun AS FLOAT64) desp_recp_saude_pc_mun,
SAFE_CAST(pct_desp_recp_saude_uf AS FLOAT64) pct_desp_recp_saude_uf,
SAFE_CAST(desp_tot_saude_pc_uf AS FLOAT64) desp_tot_saude_pc_uf,
SAFE_CAST(desp_recp_saude_pc_uf AS FLOAT64) desp_recp_saude_pc_uf,
SAFE_CAST(desp_tot_saude_pc_mun_def AS FLOAT64) desp_tot_saude_pc_mun_def,
SAFE_CAST(desp_recp_saude_pc_mun_def AS FLOAT64) desp_recp_saude_pc_mun_def,
SAFE_CAST(desp_tot_saude_pc_uf_def AS FLOAT64) desp_tot_saude_pc_uf_def,
SAFE_CAST(desp_recp_saude_pc_uf_def AS FLOAT64) desp_recp_saude_pc_uf_def,
SAFE_CAST(num_familias_bf AS INT64) num_familias_bf,
SAFE_CAST(gasto_pbf_pc_def AS FLOAT64) gasto_pbf_pc_def
FROM basedosdados-dev.br_ieps_saude_staging.municipio AS t