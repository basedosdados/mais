
//---------------------------------//
// brasil - anos iniciais
//---------------------------------//

import excel "input/divulgacao_brasil_ideb_2019/divulgacao_brasil_ideb_2019.xls", clear sheet("Brasil (Anos Iniciais)") allstring firstrow cellrange(A10)

cap drop A
cap drop CU
cap drop CV

ren B rede

foreach ano of numlist 2005(2)2019 {
	
	local prox = `ano' + 2
	
	ren VL_APROVACAO_`ano'_SI_4		taxa_aprovacao_1_ao_5_ano_`ano'
	ren VL_APROVACAO_`ano'_SI		taxa_aprovacao_1_ano_`ano'
	ren VL_APROVACAO_`ano'_1		taxa_aprovacao_2_ano_`ano'
	ren VL_APROVACAO_`ano'_2		taxa_aprovacao_3_ano_`ano'
	ren VL_APROVACAO_`ano'_3 		taxa_aprovacao_4_ano_`ano'
	ren VL_APROVACAO_`ano'_4		taxa_aprovacao_5_ano_`ano'
	ren VL_INDICADOR_REND_`ano'		indicador_rendimento_`ano'
	
	ren VL_NOTA_MATEMATICA_`ano'	nota_SAEB_matematica_`ano'
	ren VL_NOTA_PORTUGUES_`ano'		nota_SAEB_lingua_portuguesa_`ano'
	ren VL_NOTA_MEDIA_`ano'			nota_SAEB_media_padronizada_`ano'
	
	ren VL_OBSERVADO_`ano'			IDEB_`ano'
	
	ren VL_PROJECAO_`prox'			projecao_`prox'
	
}
*

destring taxa_* indicador_* nota_* IDEB_* projecao_*, replace force

drop if rede == ""

clean_string rede
replace rede = "privada" if rede == "privada (1)"

reshape long	taxa_aprovacao_1_ao_5_ano_ ///
				taxa_aprovacao_1_ano_ taxa_aprovacao_2_ano_ taxa_aprovacao_3_ano_ taxa_aprovacao_4_ano_ taxa_aprovacao_5_ano_ indicador_rendimento_ ///
				nota_SAEB_matematica_ nota_SAEB_lingua_portuguesa_ nota_SAEB_media_padronizada_ IDEB_ projecao_, ///
	i(rede) j(ano)

ren taxa_aprovacao_1_ao_5_ano_		taxa_aprovacao_1_ao_5_ano
ren taxa_aprovacao_1_ano_			taxa_aprovacao_1_ano
ren taxa_aprovacao_2_ano_			taxa_aprovacao_2_ano
ren taxa_aprovacao_3_ano_			taxa_aprovacao_3_ano
ren taxa_aprovacao_4_ano_			taxa_aprovacao_4_ano
ren taxa_aprovacao_5_ano_			taxa_aprovacao_5_ano
ren indicador_rendimento_			indicador_rendimento
ren nota_SAEB_matematica_			nota_SAEB_matematica
ren nota_SAEB_lingua_portuguesa_	nota_SAEB_lingua_portuguesa
ren nota_SAEB_media_padronizada_	nota_SAEB_media_padronizada
ren IDEB_							IDEB
ren projecao_						projecao

tostring *, replace force

foreach k of varlist taxa_* indicador_rendimento nota_* IDEB projecao {
	
	replace `k' = "" if `k' == "."
	
}
*

order	taxa_aprovacao_1_ao_5_ano ///
		taxa_aprovacao_1_ano taxa_aprovacao_2_ano taxa_aprovacao_3_ano taxa_aprovacao_4_ano taxa_aprovacao_5_ano ///
		indicador_rendimento ///
		nota_SAEB_matematica nota_SAEB_lingua_portuguesa nota_SAEB_media_padronizada ///
		IDEB projecao, a(ano)

sort rede ano

compress

export delimited "tmp/brasil_anos_iniciais.csv", replace

//---------------------------------//
// brasil - anos finais
//---------------------------------//

import excel "input/divulgacao_brasil_ideb_2019/divulgacao_brasil_ideb_2019.xls", clear sheet("Brasil (Anos Finais)") allstring firstrow cellrange(A10)

cap drop A
cap drop CM

ren B rede

foreach ano of numlist 2005(2)2019 {
	
	local prox = `ano' + 2
	
	ren VL_APROVACAO_`ano'_SI_4		taxa_aprovacao_6_ao_9_ano_`ano'
	ren VL_APROVACAO_`ano'_1		taxa_aprovacao_6_ano_`ano'
	ren VL_APROVACAO_`ano'_2		taxa_aprovacao_7_ano_`ano'
	ren VL_APROVACAO_`ano'_3 		taxa_aprovacao_8_ano_`ano'
	ren VL_APROVACAO_`ano'_4		taxa_aprovacao_9_ano_`ano'
	ren VL_INDICADOR_REND_`ano'		indicador_rendimento_`ano'
	
	ren VL_NOTA_MATEMATICA_`ano'	nota_SAEB_matematica_`ano'
	ren VL_NOTA_PORTUGUES_`ano'		nota_SAEB_lingua_portuguesa_`ano'
	ren VL_NOTA_MEDIA_`ano'			nota_SAEB_media_padronizada_`ano'
	
	ren VL_OBSERVADO_`ano'			IDEB_`ano'
	
	ren VL_PROJECAO_`prox'			projecao_`prox'
	
}
*

destring taxa_* indicador_* nota_* IDEB_* projecao_*, replace force

clean_string rede
replace rede = "privada" if rede == "privada (1)"
drop if rede == ""

reshape long	taxa_aprovacao_6_ao_9_ano_ ///
				taxa_aprovacao_6_ano_ taxa_aprovacao_7_ano_ taxa_aprovacao_8_ano_ taxa_aprovacao_9_ano_ indicador_rendimento_ ///
				nota_SAEB_matematica_ nota_SAEB_lingua_portuguesa_ nota_SAEB_media_padronizada_ IDEB_ projecao_, ///
	i(rede) j(ano)

ren taxa_aprovacao_6_ao_9_ano_		taxa_aprovacao_6_ao_9_ano
ren taxa_aprovacao_6_ano_			taxa_aprovacao_6_ano
ren taxa_aprovacao_7_ano_			taxa_aprovacao_7_ano
ren taxa_aprovacao_8_ano_			taxa_aprovacao_8_ano
ren taxa_aprovacao_9_ano_			taxa_aprovacao_9_ano
ren indicador_rendimento_			indicador_rendimento
ren nota_SAEB_matematica_			nota_SAEB_matematica
ren nota_SAEB_lingua_portuguesa_	nota_SAEB_lingua_portuguesa
ren nota_SAEB_media_padronizada_	nota_SAEB_media_padronizada
ren IDEB_							IDEB
ren projecao_						projecao

tostring *, replace force

foreach k of varlist taxa_* indicador_rendimento nota_* IDEB projecao {
	
	replace `k' = "" if `k' == "."
	
}
*

order	taxa_aprovacao_6_ao_9_ano ///
		taxa_aprovacao_6_ano taxa_aprovacao_7_ano taxa_aprovacao_8_ano taxa_aprovacao_9_ano ///
		indicador_rendimento ///
		nota_SAEB_matematica nota_SAEB_lingua_portuguesa nota_SAEB_media_padronizada ///
		IDEB projecao, a(ano)

sort rede ano

compress

export delimited "tmp/brasil_anos_finais.csv", replace


//---------------------------------//
// brasil - ensino medio
//---------------------------------//

import excel "input/divulgacao_brasil_ideb_2019/divulgacao_brasil_ideb_2019.xls", clear sheet("Brasil (EM)") allstring firstrow cellrange(A10)

cap drop A
cap drop CM
cap drop CN

ren B rede

foreach ano of numlist 2005(2)2019 {
	
	local prox = `ano' + 2
	
	ren VL_APROVACAO_`ano'_SI_4		taxa_aprovacao_total_`ano'
	ren VL_APROVACAO_`ano'_1		taxa_aprovacao_1_serie_`ano'
	ren VL_APROVACAO_`ano'_2		taxa_aprovacao_2_serie_`ano'
	ren VL_APROVACAO_`ano'_3 		taxa_aprovacao_3_serie_`ano'
	ren VL_APROVACAO_`ano'_4		taxa_aprovacao_4_serie_`ano'
	ren VL_INDICADOR_REND_`ano'		indicador_rendimento_`ano'
	
	ren VL_NOTA_MATEMATICA_`ano'	nota_SAEB_matematica_`ano'
	ren VL_NOTA_PORTUGUES_`ano'		nota_SAEB_lingua_portuguesa_`ano'
	ren VL_NOTA_MEDIA_`ano'			nota_SAEB_media_padronizada_`ano'
	
	ren VL_OBSERVADO_`ano'			IDEB_`ano'
	
	ren VL_PROJECAO_`prox'			projecao_`prox'
	
}
*

destring taxa_* indicador_* nota_* IDEB_* projecao_*, replace force

clean_string rede
replace rede = "privada" if rede == "privada (1)"
drop if rede == ""

reshape long	taxa_aprovacao_total_ ///
				taxa_aprovacao_1_serie_ taxa_aprovacao_2_serie_ taxa_aprovacao_3_serie_ taxa_aprovacao_4_serie_ indicador_rendimento_ ///
				nota_SAEB_matematica_ nota_SAEB_lingua_portuguesa_ nota_SAEB_media_padronizada_ IDEB_ projecao_, ///
	i(rede) j(ano)

ren taxa_aprovacao_total_			taxa_aprovacao_total
ren taxa_aprovacao_1_serie_			taxa_aprovacao_1_serie
ren taxa_aprovacao_2_serie_			taxa_aprovacao_2_serie
ren taxa_aprovacao_3_serie_			taxa_aprovacao_3_serie
ren taxa_aprovacao_4_serie_			taxa_aprovacao_4_serie
ren indicador_rendimento_			indicador_rendimento
ren nota_SAEB_matematica_			nota_SAEB_matematica
ren nota_SAEB_lingua_portuguesa_	nota_SAEB_lingua_portuguesa
ren nota_SAEB_media_padronizada_	nota_SAEB_media_padronizada
ren IDEB_							IDEB
ren projecao_						projecao

tostring *, replace force

foreach k of varlist taxa_* indicador_rendimento nota_* IDEB projecao {
	
	replace `k' = "" if `k' == "."
	
}
*

order	taxa_aprovacao_total ///
		taxa_aprovacao_1_serie taxa_aprovacao_2_serie taxa_aprovacao_3_serie taxa_aprovacao_4_serie ///
		indicador_rendimento ///
		nota_SAEB_matematica nota_SAEB_lingua_portuguesa nota_SAEB_media_padronizada ///
		IDEB projecao, a(ano)

sort rede ano

compress

export delimited "tmp/brasil_ensino_medio.csv", replace
