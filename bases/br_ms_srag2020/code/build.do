
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
cap log close
set more off

cd "path/to/SRAG"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) stringcols(_all) encoding("utf-8")
keep id_municipio id_municipio_6
tempfile dir_munic
save `dir_munic'

import delimited "input/INFLUD-28-12-2020.csv", clear varn(1) delim(";") encoding("utf-8") stringcols(_all)

ren dt_notific	data_notificacao
ren sem_not		semana_notificacao
ren dt_sin_pri	data_primeiros_sintomas
ren sem_pri		semana_primeiros_sintomas
ren sg_uf_not	sigla_uf_notificacao
ren id_regiona	regiao_saude_notificacao
ren co_regiona	id_regiao_saude_notificacao
ren id_municip	municipio_notificacao
ren co_mun_not	id_municipio_6_notificacao
ren id_unidade	unidade_notificacao
ren co_uni_not	id_unidade_notificacao
ren cs_sexo		sexo
ren dt_nasc		data_nascimento
ren nu_idade_n	idade
ren tp_idade	tipo_idade
ren cod_idade	id_idade
ren cs_gestant	id_gestante
ren cs_raca		id_raca
ren cs_etinia	id_etnia
ren cs_escol_n	id_escolaridade
ren id_pais		pais
ren co_pais		id_pais
ren sg_uf		sigla_uf_residencia
ren id_rg_resi	regiao_saude_residencia
ren co_rg_resi	id_regiao_saude_residencia
ren id_mn_resi	municipio_residencia
ren co_mun_res	id_municipio_6_residencia
ren cs_zona		zona_residencia
ren surto_sg	surto_sg
ren nosocomial	nosocomial
ren ave_suino	ave_suino
ren febre		febre
ren tosse		tosse
ren garganta	garganta
ren dispneia	dispneia
ren desc_resp	desconforto_respiratorio
ren saturacao	saturacao
ren diarreia	diarreia
ren vomito		vomito
ren outro_sin	outros_sintomas
ren outro_des	descricao_outros_sintomas
ren puerpera	puerpera
ren fator_risc	fator_risco
ren cardiopati	cardiopatica
ren hematologi	hematologica
ren sind_down	sindrome_down
ren hepatica	hepatica
ren asma		asma
ren diabetes	diabetes
ren neurologic	neurologica
ren pneumopati	pneumopatia
ren imunodepre	imunodepressiva
ren renal		renal
ren obesidade	obesidade
ren obes_imc	valor_imc
ren out_morbi	outras_morbidades
ren morb_desc	descricao_outras_morbidades
ren vacina		vacina
ren dt_ut_dose	data_ultima_dose
ren mae_vac		mae_vacinada
ren dt_vac_mae	data_mae_vacinada
ren m_amamenta	mae_amamenta
ren dt_doseuni	data_dose_unica
ren dt_1_dose	data_primeira_dose
ren dt_2_dose	data_segunda_dose
ren antiviral	antiviral
ren tp_antivir	tipo_antiviral
ren out_antiv	outro_antiviral
ren dt_antivir	data_antiviral
ren hospital	internacao
ren dt_interna	data_internacao
ren sg_uf_inte	sigla_uf_internacao
ren id_rg_inte	regiao_saude_internacao
ren co_rg_inte	id_regiao_saude_internacao
ren id_mn_inte	municipio_internacao
ren co_mu_inte	id_municipio_6_internacao
ren uti			uti
ren dt_entuti	data_entrada_uti
ren dt_saiduti	data_saida_uti
ren suport_ven	suporte_ventilatorio
ren raiox_res	resultado_raio_x
ren raiox_out	resultado_raio_x_outro
ren dt_raiox	data_raio_x
ren amostra		amostra_coletada
ren dt_coleta	data_amostra_coletada
ren tp_amostra	tipo_amostra_coletada
ren out_amost	tipo_amostra_outra
ren pcr_resul	resultado_pcr
ren dt_pcr		data_pcr
ren pos_pcrflu	pcr_positivo_influenza
ren tp_flu_pcr	pcr_tipo_influenza
ren pcr_fluasu	pcr_influenza_a_subtipo
ren fluasu_out	pcr_influenza_a_subtipo_outro
ren pcr_flubli	pcr_influenza_b_linhagem
ren flubli_out	pcr_influenza_b_linhagem_outro
ren pos_pcrout	pcr_positivo_outros_virus
ren pcr_vsr		pcr_vsr
ren pcr_para1	pcr_para_1
ren pcr_para2	pcr_para_2
ren pcr_para3	pcr_para_3
ren pcr_para4	pcr_para_4
ren pcr_adeno	pcr_adeno
ren pcr_metap	pcr_metap
ren pcr_boca	pcr_boca
ren pcr_rino	pcr_rino
ren pcr_outro	pcr_outro
ren ds_pcr_out	descricao_pcr_outro
ren classi_fin	classificacao_final
ren classi_out	classificacao_final_outro
ren criterio	criterio
ren evolucao	evolucao
ren dt_evoluca	data_evolucao
ren dt_encerra	data_encerramento
ren dt_digita	data_digitacao
ren histo_vgm	historico_viagem
ren pais_vgm	pais_viagem
ren co_ps_vgm	id_pais_viagem
ren lo_ps_vgm	local_pais_viagem
ren dt_vgm		data_viagem
ren dt_rt_vgm	data_retorno_viagem
ren pcr_sars2	pcr_sars2
ren pac_cocbo	cbo_2002_paciente
ren pac_dscbo	cbo_2002_mae
ren out_anim	contato_outro_animal
ren dor_abd		dor_abdominal
ren fadiga		fadiga
ren perd_olft	perda_olfato
ren perd_pala	perda_paladar
ren tomo_res	resultado_tomografia
ren tomo_out	resultado_tomografia_outro
ren dt_tomo		data_tomografia
ren tp_tes_an	tipo_teste_an
ren dt_res_an	data_teste_an
ren res_an		resultado_teste_an
ren pos_an_flu	teste_an_positivo_influenza
ren tp_flu_an	teste_an_tipo_influenza
ren pos_an_out	teste_an_positivo_outro
ren an_sars2	resultado_teste_an_sars2
ren an_vsr		resultado_teste_an_vsr
ren an_para1	resultado_teste_an_para_1
ren an_para2	resultado_teste_an_para_2
ren an_para3	resultado_teste_an_para_3
ren an_adeno	resultado_teste_an_adeno
ren an_outro	resultado_teste_an_outro
ren ds_an_out	descricao_teste_an_outro
ren tp_am_sor	tipo_amostra_sorologica
ren sor_out		tipo_amostra_sorologica_outro
ren dt_co_sor	data_coleta_amostra_sorologica
ren tp_sor		tipo_teste_sorologico
ren out_sor		tipo_teste_sorologico_outro
ren dt_res		data_resultado_teste_sorologico
ren res_igg		resultado_teste_sorologico_igg
ren res_igm		resultado_teste_sorologico_igm
ren res_iga		resultado_teste_sorologico_iga

replace sexo = "masculino"	if sexo == "M"
replace sexo = "feminino"	if sexo == "F"

replace fator_risco = "sim" if fator_risco == "S"
replace fator_risco = "nao" if fator_risco == "N"

foreach k of varlist data_* {
	
	replace `k' = substr(`k', 7, 4) + "-" + substr(`k', 4, 2) + "-" + substr(`k', 1, 2) if length(`k') == 10

}
*

foreach k in notificacao residencia internacao  {
	
	ren id_municipio_6_`k' id_municipio_6
	
	merge m:1 id_municipio_6 using `dir_munic'
	drop if _merge == 2
	drop _merge
	
	order id_municipio, b(id_municipio_6)
	ren id_municipio id_municipio_`k'
	ren id_municipio_6 id_municipio_6_`k'

}
*

compress

tempfile microdados
save `microdados'

//-------------------------//
// particiona
//-------------------------//

! mkdir "output/microdados"

levelsof sigla_uf_notificacao, l(ufs)

foreach uf in `ufs' {
	
	! mkdir "output/microdados/sigla_uf_notificacao=`uf'"
	
	use `microdados', clear
	keep if sigla_uf_notificacao == "`uf'"
	drop sigla_uf_notificacao
	export delimited "output/microdados/sigla_uf_notificacao=`uf'/microdados.csv", replace
	
}
*
