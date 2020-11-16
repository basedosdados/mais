
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
set more off

cd "path/to/Atlas Desenvolvimento Humano Brasil"

cap program drop limpa_variaveis
program limpa_variaveis
	
	ren ano						ano
	ren espvida					expectativa_vida
	ren fectot					fecundidade_total
	ren mort1					mortalidade_1
	ren mort5					mortalidade_5
	ren razdep					razao_dependencia
	ren sobre40					prob_sobrevivencia_40
	ren sobre60					prob_sobrevivencia_60
	ren t_env					taxa_envelhecimento
	ren e_anosestudo			expectativa_anos_estudo
	ren t_analf11a14			taxa_analfabetismo_11_a_14
	ren t_analf15a17			taxa_analfabetismo_15_a_17
	ren t_analf15m				taxa_analfabetismo_15_mais
	ren t_analf18a24			taxa_analfabetismo_18_a_24
	ren t_analf18m				taxa_analfabetismo_18_mais
	ren t_analf25a29			taxa_analfabetismo_25_a_29
	ren t_analf25m				taxa_analfabetismo_25_mais
	ren t_atraso_0_basico		taxa_atraso_0_basico
	ren t_atraso_0_fund			taxa_atraso_0_fundamental
	ren t_atraso_0_med			taxa_atraso_0_medio
	ren t_atraso_1_basico		taxa_atraso_1_basico
	ren t_atraso_1_fund			taxa_atraso_1_fundamental
	ren t_atraso_1_med			taxa_atraso_1_medio
	ren t_atraso_2_basico		taxa_atraso_2_basico
	ren t_atraso_2_fund			taxa_atraso_2_fundamental
	ren t_atraso_2_med			taxa_atraso_2_medio
	ren t_fbbas					taxa_freq_bruta_basico
	ren t_fbfund 				taxa_freq_bruta_fundamental
	ren t_fbmed					taxa_freq_bruta_medio
	ren t_fbpre					taxa_freq_bruta_pre
	ren t_fbsuper				taxa_freq_bruta_superior
	ren t_flbas					taxa_freq_liquida_basico
	ren t_flfund				taxa_freq_liquida_fundamental
	ren t_flmed					taxa_freq_liquida_medio
	ren t_flpre					taxa_freq_liquida_pre
	ren t_flsuper				taxa_freq_liquida_superior
	ren t_freq0a3				taxa_freq_0_3
	ren t_freq11a14				taxa_freq_11_14
	ren t_freq15a17				taxa_freq_15_17
	ren t_freq18a24				taxa_freq_18_24
	ren t_freq25a29				taxa_freq_25_29
	ren t_freq4a5				taxa_freq_4_5
	ren t_freq4a6				taxa_freq_4_6
	ren t_freq5a6				taxa_freq_5_6
	ren t_freq6					taxa_freq_6
	ren t_freq6a14				taxa_freq_6_14
	ren t_freq6a17				taxa_freq_6_17
	ren t_freqfund1517			taxa_freq_fundamental_15_17
	ren t_freqfund1824			taxa_freq_fundamental_18_24
	ren t_freqfund45			taxa_freq_fundamental_4_5
	ren t_freqmed1824			taxa_freq_medio_18_24
	ren t_freqmed614			taxa_freq_medio_6_14
	ren t_freqsuper1517			taxa_freq_superior_15_17
	ren t_fund11a13				taxa_fundamental_11_13
	ren t_fund12a14				taxa_fundamental_12_14
	ren t_fund15a17				taxa_fundamental_15_17
	ren t_fund16a18				taxa_fundamental_16_18
	ren t_fund18a24				taxa_fundamental_18_24
	ren t_fund18m				taxa_fundamental_18_mais
	ren t_fund25m				taxa_fundamental_25_mais
	ren t_med18a20				taxa_medio_18_20
	ren t_med18a24				taxa_medio_18_24
	ren t_med18m				taxa_medio_18_mais
	ren t_med19a21				taxa_medio_19_21
	ren t_med25m				taxa_medio_25_mais
	ren t_super25m				taxa_superior_25_mais
	ren corte1					renda_pc_max_quintil_1
	ren corte2					renda_pc_max_quintil_2
	ren corte3 					renda_pc_max_quintil_3
	ren corte4					renda_pc_max_quintil_4
	ren corte9					renda_pc_max_decil_9
	ren gini					indice_gini
	ren pind					prop_pobreza_extrema
	ren pindcri					prop_pobreza_extrema_criancas
	ren pmpob					prop_pobreza
	ren pmpobcri				prop_pobreza_criancas
	ren ppob					prop_vulner_pobreza
	ren ppobcri					prop_vulner_pobreza_criancas
	ren pren10ricos				prop_renda_10_ricos
	ren pren20					prop_renda_20_pobres
	ren pren20ricos				prop_renda_20_ricos
	ren pren40					prop_renda_40_pobres
	ren pren60					prop_renda_60_pobres
	ren pren80					prop_renda_80_pobres
	ren prentrab				prop_renda_trabalho
	ren r1040					razao_10_ricos_40_pobres
	ren r2040					razao_20_ricos_40_pobres
	ren rdpc					renda_pc
	ren rdpc1					renda_pc_quintil_1
	ren rdpc10					renda_pc_decil_10
	ren rdpc2					renda_pc_quintil_2
	ren rdpc3					renda_pc_quintil_3
	ren rdpc4					renda_pc_quintil_4
	ren rdpc5					renda_pc_quintil_5
	ren rdpct					renda_pc_exc_renda_nula
	ren rind					renda_pc_pobreza_extrema
	ren rmpob					renda_pc_pobreza
	ren rpob					renda_pc_vulner_pobreza
	ren theil					indice_theil
	ren cpr						prop_trabalhadores_conta_proria
	ren emp						prop_empregadores
	ren p_agro					prop_ocupados_agropecuaria
	ren p_com					prop_ocupados_comercio
	ren p_constr				prop_ocupados_construcao
	ren p_extr					prop_ocupados_extracao
	ren p_formal				prop_ocupados_formalizacao
	ren p_fund					prop_ocupados_fundamental
	ren p_med					prop_ocupados_medio
	ren p_serv					prop_ocupados_servicos
	ren p_siup					prop_ocupados_siup
	ren p_super					prop_ocupados_superior
	ren p_transf				prop_ocupados_transformacao
	ren ren0					prop_ocupados_renda_0
	ren ren1					prop_ocupados_renda_1_sm
	ren ren2					prop_ocupados_renda_2_sm
	ren ren3					prop_ocupados_renda_3_sm
	ren ren5					prop_ocupados_renda_5_sm
	ren renocup					renda_media_ocupados
	ren t_ativ					taxa_atividade
	ren t_ativ1014				taxa_atividade_10_14
	ren t_ativ1517				taxa_atividade_15_17
	ren t_ativ1824				taxa_atividade_18_24
	ren t_ativ18m				taxa_atividade_18_mais
	ren t_ativ2529				taxa_atividade_25_29
	ren t_des					taxa_desocupacao
	ren t_des1014				taxa_desocupacao_10_14
	ren t_des1517				taxa_desocupacao_15_17
	ren t_des1824				taxa_desocupacao_18_24
	ren t_des18m				taxa_desocupacao_18_mais
	ren t_des2529				taxa_desocupacao_25_29
	ren theiltrab				indice_treil_trabalho
	ren trabcc					taxa_ocupados_carteira
	ren trabpub					taxa_ocupados_setor_publico
	ren trabsc					taxa_ocupados_sem_carteira
	ren t_agua					taxa_agua_encanada
	ren t_banagua				taxa_banheiro_agua_encanada
	ren t_dens					taxa_densidade_2_mais
	ren t_lixo					taxa_coleta_lixo
	ren t_luz					taxa_energia_eletrica
	ren agua_esgoto				taxa_agua_esgoto_inadequados
	ren parede					taxa_paredes_inadequados
	ren t_crifundin_todos		taxa_criancas_dom_sem_fund
	ren t_fora4a5				taxa_criancas_fora_escola_4_5
	ren t_fora6a14				taxa_criancas_fora_escola_6_14
	ren t_fundin_todos			taxa_dom_sem_fund
	ren t_fundin_todos_mmeio	taxa_dom_vulner_sem_fund
	ren t_fundin18minf			taxa_sem_fund_informal
	ren t_m10a14cf				taxa_mulheres_com_filho_10_14
	ren t_m15a17cf				taxa_mulheres_com_filho_15_17
	ren t_mulchefefif014		taxa_mulheres_chefe_filho_15m
	ren t_nestuda_ntrab_mmeio	taxa_nest_ntrab_vulner_15_24
	ren t_ocupdesloc_1			taxa_vulner_desloc_1_hora
	ren t_rmaxidoso				taxa_dom_vulner_dep_idoso
	ren t_sluz					taxa_sem_energia_eletrica
	ren homem0a4 				populacao_homens_0_4
	ren homem10a14				populacao_homens_10_14
	ren homem15a19				populacao_homens_15_19
	ren homem20a24				populacao_homens_20_24
	ren homem25a29				populacao_homens_25_29
	ren homem30a34				populacao_homens_30_34
	ren homem35a39				populacao_homens_35_39
	ren homem40a44				populacao_homens_40_44
	ren homem45a49				populacao_homens_45_49
	ren homem50a54				populacao_homens_50_54
	ren homem55a59				populacao_homens_55_59
	ren homem5a9				populacao_homens_5_9
	ren homem60a64				populacao_homens_60_64
	ren homem65a69				populacao_homens_65_69
	ren homem70a74				populacao_homens_70_74
	ren homem75a79				populacao_homens_75_79
	ren homemtot				populacao_homens
	ren homens80				populacao_homens_80_mais
	ren mulh0a4					populacao_mulheres_0_4
	ren mulh10a14				populacao_mulheres_10_14
	ren mulh15a19				populacao_mulheres_15_19
	ren mulh20a24				populacao_mulheres_20_24
	ren mulh25a29				populacao_mulheres_25_29
	ren mulh30a34				populacao_mulheres_30_34
	ren mulh35a39				populacao_mulheres_35_39
	ren mulh40a44				populacao_mulheres_40_44
	ren mulh45a49				populacao_mulheres_45_49
	ren mulh50a54				populacao_mulheres_50_54
	ren mulh55a59				populacao_mulheres_55_59
	ren mulh5a9					populacao_mulheres_5_9
	ren mulh60a64				populacao_mulheres_60_64
	ren mulh65a69				populacao_mulheres_65_69
	ren mulh70a74				populacao_mulheres_70_74
	ren mulh75a79				populacao_mulheres_75_79
	ren mulher80				populacao_mulheres_80_mais
	ren mulhertot				populacao_mulheres
	ren pea						pea
	ren pea1014					pea_10_14
	ren pea1517					pea_15_17
	ren pea18m					pea_18_mais
	ren peso1					populacao_1_menos
	ren peso1114				populacao_11_14
	ren peso1113				populacao_11_13
	ren peso1214				populacao_12_14
	ren peso13					populacao_1_3
	ren peso15					populacao_15_mais
	ren peso1517				populacao_15_17
	ren peso1524				populacao_15_24
	ren peso1618				populacao_16_18
	ren peso18					populacao_18_mais
	ren peso1820				populacao_18_20
	ren peso1824				populacao_18_24
	ren peso1921				populacao_19_21
	ren peso25					populacao_25_mais
	ren peso4					populacao_4
	ren peso5					populacao_5
	ren peso6					populacao_6
	ren peso610					populacao_6_10
	ren peso617					populacao_6_17
	ren peso65					populacao_65_mais
	ren pesorur					populacao_rural
	ren pesotot					populacao
	ren pesourb					populacao_urbana
	ren pia						pia
	ren pia1014					pia_10_14
	ren pia1517					pia_15_17
	ren pia18m					pia_18_mais
	ren pop						populacao_dom_pp
	ren popt					populacao_dom_pp_exc_renda_nula
	ren i_escolaridade			indice_escolaridade
	ren i_freq_prop				indice_frequencia_escolar
	ren idhm					idhm
	ren idhm_e					idhm_e
	ren idhm_l					idhm_l
	ren idhm_r					idhm_r
	
	order pea*, b(pia)
	order populacao_rural, a(populacao_urbana)
	order populacao_dom_pp populacao_dom_pp_exc_renda_nula, a(populacao_rural)
	
end

//----------------------------------------------------------------------------//
// build: brasil
//----------------------------------------------------------------------------//

import excel using "input/Atlas 2013_municipal, estadual e Brasil.xls", sheet("BR 91-00-10") firstrow clear case(low) locale("utf-8")

drop a
drop pesom1014 pesom1517 pesom15m pesom25m

limpa_variaveis
tostring *, replace
foreach k of varlist _all {
	replace `k' = "" if `k' == "."
}
*

export delimited "output/brasil.csv", replace datafmt

//----------------------------------------------------------------------------//
// build: estados
//----------------------------------------------------------------------------//

import excel using "input/Atlas 2013_municipal, estadual e Brasil.xls", sheet("UF 91-00-10") firstrow clear case(low) locale("utf-8")

ren uf		id_uf
ren ufn		uf

drop pesom1014 pesom1517 pesom15m pesom25m

limpa_variaveis
tostring *, replace
foreach k of varlist _all {
	replace `k' = "" if `k' == "."
}
*

order id_uf uf ano
sort  id_uf uf ano

export delimited "output/estados.csv", replace


//----------------------------------------------------------------------------//
// build: municipios
//----------------------------------------------------------------------------//

import excel using "input/Atlas 2013_municipal, estadual e Brasil.xls", sheet("MUN 91-00-10") firstrow clear case(low) locale("utf-8")

drop uf codmun6 município

ren codmun7	id_municipio

drop pesom1014 pesom1517 pesom15m pesom25m

limpa_variaveis
tostring *, replace
foreach k of varlist _all {
	replace `k' = "" if `k' == "."
}
*

order id_municipio ano
sort  id_municipio ano

export delimited "output/municipios.csv", replace
