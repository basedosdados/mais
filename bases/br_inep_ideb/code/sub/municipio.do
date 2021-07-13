
//---------------------------------//
// municipio - anos iniciais
//---------------------------------//

import excel "input/divulgacao_anos_iniciais_municipios_2019/divulgacao_anos_iniciais_municipios_2019.xls", ///
	clear sheet("IDEB_AI_MUNICÍPIOS") allstring cellrange(A10) firstrow

cap drop CW
drop NO_MUNICIPIO

ren SG_UF			sigla_uf
ren CO_MUNICIPIO	id_municipio
ren REDE			rede

foreach ano of numlist 2005(2)2019 {
	
	local prox = `ano' + 2
	
	ren VL_APROVACAO_`ano'_SI_4		taxa_aprovacao_1_ao_5_ano_`ano'
	ren VL_APROVACAO_`ano'_SI		taxa_aprovacao_1_ano_`ano'
	ren VL_APROVACAO_`ano'_1		taxa_aprovacao_2_ano_`ano'
	ren VL_APROVACAO_`ano'_2		taxa_aprovacao_3_ano_`ano'
	ren VL_APROVACAO_`ano'_3 		taxa_aprovacao_4_ano_`ano'
	ren VL_APROVACAO_`ano'_4		taxa_aprovacao_5_ano_`ano'
	ren VL_INDICADOR_REND_`ano'		indicador_rendimento_`ano'
	
	ren VL_NOTA_MATEMATICA_`ano'	nota_saeb_matematica_`ano'
	ren VL_NOTA_PORTUGUES_`ano'		nota_saeb_lingua_portuguesa_`ano'
	ren VL_NOTA_MEDIA_`ano'			nota_saeb_media_padronizada_`ano'
	
	ren VL_OBSERVADO_`ano'			ideb_`ano'
	
	ren VL_PROJECAO_`prox'			projecao_`prox'
	
}
*

destring id_municipio taxa_* indicador_* nota_* ideb_* projecao_*, replace force

drop if id_municipio == .

clean_string rede

reshape long	taxa_aprovacao_1_ao_5_ano_ ///
				taxa_aprovacao_1_ano_ taxa_aprovacao_2_ano_ taxa_aprovacao_3_ano_ taxa_aprovacao_4_ano_ taxa_aprovacao_5_ano_ indicador_rendimento_ ///
				nota_saeb_matematica_ nota_saeb_lingua_portuguesa_ nota_saeb_media_padronizada_ ideb_ projecao_, ///
	i(sigla_uf id_municipio rede) j(ano)

ren taxa_aprovacao_1_ao_5_ano_		taxa_aprovacao_1_ao_5_ano
ren taxa_aprovacao_1_ano_			taxa_aprovacao_1_ano
ren taxa_aprovacao_2_ano_			taxa_aprovacao_2_ano
ren taxa_aprovacao_3_ano_			taxa_aprovacao_3_ano
ren taxa_aprovacao_4_ano_			taxa_aprovacao_4_ano
ren taxa_aprovacao_5_ano_			taxa_aprovacao_5_ano
ren indicador_rendimento_			indicador_rendimento
ren nota_saeb_matematica_			nota_saeb_matematica
ren nota_saeb_lingua_portuguesa_	nota_saeb_lingua_portuguesa
ren nota_saeb_media_padronizada_	nota_saeb_media_padronizada
ren ideb_							ideb
ren projecao_						projecao

tostring *, replace force

foreach k of varlist taxa_* indicador_rendimento nota_* ideb projecao {
	
	replace `k' = "" if `k' == "."
	
}
*

order	ano sigla_uf id_municipio rede ///
		taxa_aprovacao_1_ao_5_ano ///
		taxa_aprovacao_1_ano taxa_aprovacao_2_ano taxa_aprovacao_3_ano taxa_aprovacao_4_ano taxa_aprovacao_5_ano ///
		indicador_rendimento ///
		nota_saeb_matematica nota_saeb_lingua_portuguesa nota_saeb_media_padronizada ///
		ideb projecao

sort ano id_municipio rede

compress

export delimited "tmp/municipio_anos_iniciais.csv", replace


//---------------------------------//
// municipio - anos finais
//---------------------------------//

import excel "input/divulgacao_anos_finais_municipios_2019/divulgacao_anos_finais_municipios_2019.xls", ///
	clear sheet("IDEB_AF_MUNICÍPIOS") allstring cellrange(A10) firstrow

drop NO_MUNICIPIO

ren SG_UF			sigla_uf
ren CO_MUNICIPIO	id_municipio
ren REDE			rede

foreach ano of numlist 2005(2)2019 {
	
	local prox = `ano' + 2
	
	ren VL_APROVACAO_`ano'_SI_4		taxa_aprovacao_6_ao_9_ano_`ano'
	ren VL_APROVACAO_`ano'_1		taxa_aprovacao_6_ano_`ano'
	ren VL_APROVACAO_`ano'_2		taxa_aprovacao_7_ano_`ano'
	ren VL_APROVACAO_`ano'_3 		taxa_aprovacao_8_ano_`ano'
	ren VL_APROVACAO_`ano'_4		taxa_aprovacao_9_ano_`ano'
	ren VL_INDICADOR_REND_`ano'		indicador_rendimento_`ano'
	
	ren VL_NOTA_MATEMATICA_`ano'	nota_saeb_matematica_`ano'
	ren VL_NOTA_PORTUGUES_`ano'		nota_saeb_lingua_portuguesa_`ano'
	ren VL_NOTA_MEDIA_`ano'			nota_saeb_media_padronizada_`ano'
	
	ren VL_OBSERVADO_`ano'			ideb_`ano'
	
	ren VL_PROJECAO_`prox'			projecao_`prox'
	
}
*

destring id_municipio taxa_* indicador_* nota_* ideb_* projecao_*, replace force

drop if id_municipio == .

clean_string rede

reshape long	taxa_aprovacao_6_ao_9_ano_ ///
				taxa_aprovacao_6_ano_ taxa_aprovacao_7_ano_ taxa_aprovacao_8_ano_ taxa_aprovacao_9_ano_ indicador_rendimento_ ///
				nota_saeb_matematica_ nota_saeb_lingua_portuguesa_ nota_saeb_media_padronizada_ ideb_ projecao_, ///
	i(sigla_uf id_municipio rede) j(ano)

ren taxa_aprovacao_6_ao_9_ano_		taxa_aprovacao_6_ao_9_ano
ren taxa_aprovacao_6_ano_			taxa_aprovacao_6_ano
ren taxa_aprovacao_7_ano_			taxa_aprovacao_7_ano
ren taxa_aprovacao_8_ano_			taxa_aprovacao_8_ano
ren taxa_aprovacao_9_ano_			taxa_aprovacao_9_ano
ren indicador_rendimento_			indicador_rendimento
ren nota_saeb_matematica_			nota_saeb_matematica
ren nota_saeb_lingua_portuguesa_	nota_saeb_lingua_portuguesa
ren nota_saeb_media_padronizada_	nota_saeb_media_padronizada
ren ideb_							ideb
ren projecao_						projecao

tostring *, replace force

foreach k of varlist taxa_* indicador_rendimento nota_* ideb projecao {
	
	replace `k' = "" if `k' == "."
	
}
*

order	ano sigla_uf id_municipio rede ///
		taxa_aprovacao_6_ao_9_ano ///
		taxa_aprovacao_6_ano taxa_aprovacao_7_ano taxa_aprovacao_8_ano taxa_aprovacao_9_ano ///
		indicador_rendimento ///
		nota_saeb_matematica nota_saeb_lingua_portuguesa nota_saeb_media_padronizada ///
		ideb projecao

sort ano id_municipio rede

compress

export delimited "tmp/municipio_anos_finais.csv", replace

//---------------------------------//
// municipio - ensino medio
//---------------------------------//

import excel "input/divulgacao_ensino_medio_municipios_2019/divulgacao_ensino_medio_municipios_2019.xls", ///
	clear sheet("IDEB_Municípios (ENSINO MÉDIO)") allstring cellrange(A10) firstrow

drop NO_MUNICIPIO

ren SG_UF			sigla_uf
ren CO_MUNICIPIO	id_municipio
ren REDE			rede

foreach ano of numlist 2017(2)2019 {
	
	local prox = `ano' + 2
	
	ren VL_APROVACAO_`ano'_SI_4		taxa_aprovacao_total_`ano'
	ren VL_APROVACAO_`ano'_1		taxa_aprovacao_1_serie_`ano'
	ren VL_APROVACAO_`ano'_2		taxa_aprovacao_2_serie_`ano'
	ren VL_APROVACAO_`ano'_3 		taxa_aprovacao_3_serie_`ano'
	ren VL_APROVACAO_`ano'_4		taxa_aprovacao_4_serie_`ano'
	ren VL_INDICADOR_REND_`ano'		indicador_rendimento_`ano'
	
	ren VL_NOTA_MATEMATICA_`ano'	nota_saeb_matematica_`ano'
	ren VL_NOTA_PORTUGUES_`ano'		nota_saeb_lingua_portuguesa_`ano'
	ren VL_NOTA_MEDIA_`ano'			nota_saeb_media_padronizada_`ano'
	
	ren VL_OBSERVADO_`ano'			ideb_`ano'
	
	ren VL_PROJECAO_`prox'			projecao_`prox'
	
}
*

destring id_municipio taxa_* indicador_* nota_* ideb_* projecao_*, replace force

drop if id_municipio == .

clean_string rede

reshape long	taxa_aprovacao_total_ ///
				taxa_aprovacao_1_serie_ taxa_aprovacao_2_serie_ taxa_aprovacao_3_serie_ taxa_aprovacao_4_serie_ indicador_rendimento_ ///
				nota_saeb_matematica_ nota_saeb_lingua_portuguesa_ nota_saeb_media_padronizada_ ideb_ projecao_, ///
	i(sigla_uf id_municipio rede) j(ano)

ren taxa_aprovacao_total_			taxa_aprovacao_total
ren taxa_aprovacao_1_serie_			taxa_aprovacao_1_serie
ren taxa_aprovacao_2_serie_			taxa_aprovacao_2_serie
ren taxa_aprovacao_3_serie_			taxa_aprovacao_3_serie
ren taxa_aprovacao_4_serie_			taxa_aprovacao_4_serie
ren indicador_rendimento_			indicador_rendimento
ren nota_saeb_matematica_			nota_saeb_matematica
ren nota_saeb_lingua_portuguesa_	nota_saeb_lingua_portuguesa
ren nota_saeb_media_padronizada_	nota_saeb_media_padronizada
ren ideb_							ideb
ren projecao_						projecao

tostring *, replace force

foreach k of varlist taxa_* indicador_rendimento nota_* ideb projecao {
	
	replace `k' = "" if `k' == "."
	
}
*

order	ano sigla_uf id_municipio rede ///
		taxa_aprovacao_total ///
		taxa_aprovacao_1_serie taxa_aprovacao_2_serie taxa_aprovacao_3_serie taxa_aprovacao_4_serie ///
		indicador_rendimento ///
		nota_saeb_matematica nota_saeb_lingua_portuguesa nota_saeb_media_padronizada ///
		ideb projecao

sort ano id_municipio rede

compress

export delimited "tmp/municipio_ensino_medio.csv", replace
