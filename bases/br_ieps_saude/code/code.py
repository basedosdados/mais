# -*- coding: utf-8 -*-
"""ieps.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1xuNCdj1WYneSRi0_s0D5g92QWm-jGE0b
"""

# ETL para os dados do IEPS. 
#Brasil
import pandas as pd

x = pd.read_csv('brasil.csv')

x.to_csv('brasil.csv', sep=',', index=False, header=True)

#uf
x = pd.read_csv('uf.csv')

x = x.rename(columns={"estado_abrev": "sigla_uf"}) \
       .loc[:,['ano', 'sigla_uf', 'cob_ab', 'cob_acs', 'cob_esf', 'cob_vac_bcg', 
                    'cob_vac_rota', 'cob_vac_menin', 'cob_vac_pneumo', 'cob_vac_polio', 
                    'cob_vac_tvd1', 'cob_vac_penta', 'cob_vac_hepb', 'cob_vac_hepa', 
                    'pct_prenatal_adeq', 'pct_prenatal_zero', 'pct_prenatal_1a6', 
                    'pct_prenatal_7m', 'tx_mort_inf_ibge', 'n_obitos', 'n_obitos_csap', 
                    'n_obitos_evit', 'n_obitos_maldef', 'tx_mort', 'tx_mort_csap', 
                    'tx_mort_evit', 'pct_mort_maldef', 'tx_mort_aj_oms', 
                    'tx_mort_csap_aj_oms', 'tx_mort_evit_aj_oms', 'tx_mort_aj_cens', 
                    'tx_mort_csap_aj_cens', 'tx_mort_evit_aj_cens', 'n_hosp', 'n_hosp_csap', 
                    'tx_hosp', 'tx_hosp_csap', 'n_leitouti_sus', 'n_leito_sus', 
                    'tx_leito_sus', 'tx_leitouti_sus', 'n_enf', 'n_med', 'n_enf_ch', 
                    'n_med_ch', 'tx_med', 'tx_enf', 'tx_med_ch', 'tx_enf_ch', 'n_leito_nsus', 
                    'n_leitouti_nsus', 'tx_leito_nsus', 'tx_leitouti_nsus', 'cob_priv', 
                    'pct_desp_recp_saude_mun', 'desp_tot_saude_pc_mun', 'desp_recp_saude_pc_mun', 
                    'pct_desp_recp_saude_uf', 'desp_tot_saude_pc_uf', 'desp_recp_saude_pc_uf', 
                     'num_familias_bf','gasto_pbf_pc_def']]

x.to_csv('uf.csv', sep=',', index=False, header=True)

#Macrorregião Saúde
x = pd.read_csv('macrorregiao_saude.csv')

x = x.rename(columns={'estado_abrev': 'sigla_uf',
                      'macrorregiao': 'id_macrorregiao',
                      'no_macro': 'nome_macrorregiao'}) \
                      .loc[:,['ano',
           'sigla_uf',
           'id_macrorregiao',
           'nome_macrorregiao',
           'cob_ab',
           'cob_acs',
           'cob_esf',
           'cob_vac_bcg',
           'cob_vac_rota',
           'cob_vac_menin',
           'cob_vac_pneumo',
           'cob_vac_polio',
           'cob_vac_tvd1',
           'cob_vac_penta',
           'cob_vac_hepb',
           'cob_vac_hepa',
           'pct_prenatal_adeq',
           'pct_prenatal_zero',
           'pct_prenatal_1a6',
           'pct_prenatal_7m',
           'tx_mort_inf_ibge',
           'n_obitos',
           'n_obitos_csap',
           'n_obitos_evit',
           'n_obitos_maldef',
           'tx_mort',
           'tx_mort_csap',
           'tx_mort_evit',
           'pct_mort_maldef',
           'tx_mort_aj_oms',
           'tx_mort_csap_aj_oms',
           'tx_mort_evit_aj_oms',
           'tx_mort_aj_cens',
           'tx_mort_csap_aj_cens',
           'tx_mort_evit_aj_cens',
           'n_hosp',
           'n_hosp_csap',
           'tx_hosp',
           'tx_hosp_csap',
           'n_leitouti_sus',
           'n_leito_sus',
           'tx_leito_sus',
           'tx_leitouti_sus',
           'n_enf',
           'n_med',
           'n_enf_ch',
           'n_med_ch',
           'tx_med',
           'tx_enf',
           'tx_med_ch',
           'tx_enf_ch',
           'n_leito_nsus',
           'n_leitouti_nsus',
           'tx_leito_nsus',
           'tx_leitouti_nsus',
           'cob_priv',
           'pct_desp_recp_saude_mun',
           'desp_tot_saude_pc_mun',
           'desp_recp_saude_pc_mun',
           'pct_desp_recp_saude_uf',
           'desp_tot_saude_pc_uf',
           'desp_recp_saude_pc_uf',
           'desp_tot_saude_pc_mun_def',
           'desp_recp_saude_pc_mun_def',
           'desp_tot_saude_pc_uf_def',
           'desp_recp_saude_pc_uf_def',
           'num_familias_bf','gasto_pbf_pc_def']]

x.to_csv('macrorregiao.csv', sep=',', index=False, header=True)

# Região de Saúde
x = pd.read_csv('regiao_saude.csv')

x = x.rename(columns={
    'estado_abrev': 'sigla_uf',
    'regiao': 'id_regiao_saude',
    'no_regiao': 'nome_regiao_saude'
}) \
.loc[:,['ano',
        'sigla_uf',
        'id_regiao_saude',
        'nome_regiao_saude',
        'cob_ab',
           'cob_acs',
           'cob_esf',
           'cob_vac_bcg',
           'cob_vac_rota',
           'cob_vac_menin',
           'cob_vac_pneumo',
           'cob_vac_polio',
           'cob_vac_tvd1',
           'cob_vac_penta',
           'cob_vac_hepb',
           'cob_vac_hepa',
           'pct_prenatal_adeq',
           'pct_prenatal_zero',
           'pct_prenatal_1a6',
           'pct_prenatal_7m',
           'tx_mort_inf_ibge',
           'n_obitos',
           'n_obitos_csap',
           'n_obitos_evit',
           'n_obitos_maldef',
           'tx_mort',
           'tx_mort_csap',
           'tx_mort_evit',
           'pct_mort_maldef',
           'tx_mort_aj_oms',
           'tx_mort_csap_aj_oms',
           'tx_mort_evit_aj_oms',
           'tx_mort_aj_cens',
           'tx_mort_csap_aj_cens',
           'tx_mort_evit_aj_cens',
           'n_hosp',
           'n_hosp_csap',
           'tx_hosp',
           'tx_hosp_csap',
           'n_leitouti_sus',
           'n_leito_sus',
           'tx_leito_sus',
           'tx_leitouti_sus',
           'n_enf',
           'n_med',
           'n_enf_ch',
           'n_med_ch',
           'tx_med',
           'tx_enf',
           'tx_med_ch',
           'tx_enf_ch',
           'n_leito_nsus',
           'n_leitouti_nsus',
           'tx_leito_nsus',
           'tx_leitouti_nsus',
           'cob_priv',
           'pct_desp_recp_saude_mun',
           'desp_tot_saude_pc_mun',
           'desp_recp_saude_pc_mun',
           'pct_desp_recp_saude_uf',
           'desp_tot_saude_pc_uf',
           'desp_recp_saude_pc_uf',
           'desp_tot_saude_pc_mun_def',
           'desp_recp_saude_pc_mun_def',
           'desp_tot_saude_pc_uf_def',
           'desp_recp_saude_pc_uf_def',
           'num_familias_bf','gasto_pbf_pc_def']]

x.to_csv('regiao_saude.csv', sep=',', index=False, header=True)

#Municipio
x = pd.read_csv('municipio.csv')

x = x.rename(columns={
    'id_munic_7': 'id_municipio',
    'nomemun': 'nome',
    'estado_abrev': 'sigla_uf'
}) \
.loc[:,['ano',
        'id_municipio',
        'sigla_uf',
        'nome',
        'cob_ab',
           'cob_acs',
           'cob_esf',
           'cob_vac_bcg',
           'cob_vac_rota',
           'cob_vac_menin',
           'cob_vac_pneumo',
           'cob_vac_polio',
           'cob_vac_tvd1',
           'cob_vac_penta',
           'cob_vac_hepb',
           'cob_vac_hepa',
           'pct_prenatal_adeq',
           'pct_prenatal_zero',
           'pct_prenatal_1a6',
           'pct_prenatal_7m',
           'tx_mort_inf_ibge',
           'n_obitos',
           'n_obitos_csap',
           'n_obitos_evit',
           'n_obitos_maldef',
           'tx_mort',
           'tx_mort_csap',
           'tx_mort_evit',
           'pct_mort_maldef',
           'tx_mort_aj_oms',
           'tx_mort_csap_aj_oms',
           'tx_mort_evit_aj_oms',
           'tx_mort_aj_cens',
           'tx_mort_csap_aj_cens',
           'tx_mort_evit_aj_cens',
           'n_hosp',
           'n_hosp_csap',
           'tx_hosp',
           'tx_hosp_csap',
           'n_leitouti_sus',
           'n_leito_sus',
           'tx_leito_sus',
           'tx_leitouti_sus',
           'n_enf',
           'n_med',
           'n_enf_ch',
           'n_med_ch',
           'tx_med',
           'tx_enf',
           'tx_med_ch',
           'tx_enf_ch',
           'n_leito_nsus',
           'n_leitouti_nsus',
           'tx_leito_nsus',
           'tx_leitouti_nsus',
           'cob_priv',
           'pct_desp_recp_saude_mun',
           'desp_tot_saude_pc_mun',
           'desp_recp_saude_pc_mun',
           'pct_desp_recp_saude_uf',
           'desp_tot_saude_pc_uf',
           'desp_recp_saude_pc_uf',
           'desp_tot_saude_pc_mun_def',
           'desp_recp_saude_pc_mun_def',
           'desp_tot_saude_pc_uf_def',
           'desp_recp_saude_pc_uf_def',
           'num_familias_bf','gasto_pbf_pc_def']]

x.to_csv('municipio.csv', sep=',', index=False, header=True)