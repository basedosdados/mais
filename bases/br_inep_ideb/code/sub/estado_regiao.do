
//---------------------------------//
// estados - anos iniciais
//---------------------------------//

import excel "input/divulgacao_regioes_ufs_ideb_2019/divulgacao_regioes_ufs_ideb_2019.xls", clear sheet("UF e Regiões (AI)") allstring cellrange(A10) firstrow

ren A lugar
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

clean_string rede
split rede, p(" ") l(1)
order rede1, a(rede)
drop rede
ren rede1 rede
drop if rede == ""

reshape long	taxa_aprovacao_1_ao_5_ano_ ///
				taxa_aprovacao_1_ano_ taxa_aprovacao_2_ano_ taxa_aprovacao_3_ano_ taxa_aprovacao_4_ano_ taxa_aprovacao_5_ano_ indicador_rendimento_ ///
				nota_SAEB_matematica_ nota_SAEB_lingua_portuguesa_ nota_SAEB_media_padronizada_ IDEB_ projecao_, ///
	i(lugar rede) j(ano)

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

sort lugar rede ano

preserve
	
	keep if inlist(lugar, "Norte", "Nordeste", "Centro-Oeste", "Sudeste", "Sul")
	
	ren lugar regiao

	compress
	
	export delimited "tmp/regiao_anos_iniciais.csv", replace
	
restore
preserve
	
	keep if !inlist(lugar, "Norte", "Nordeste", "Centro-Oeste", "Sudeste", "Sul")
	
	gen estado_abrev = ""
	replace estado_abrev = "AC" if lugar == "Acre"
	replace estado_abrev = "AL" if lugar == "Alagoas"
	replace estado_abrev = "AP" if lugar == "Amapá"
	replace estado_abrev = "AM" if lugar == "Amazonas"
	replace estado_abrev = "BA" if lugar == "Bahia"
	replace estado_abrev = "CE" if lugar == "Ceará"
	replace estado_abrev = "DF" if lugar == "Distrito Federal"
	replace estado_abrev = "ES" if lugar == "Espírito Santo"
	replace estado_abrev = "GO" if lugar == "Goiás"
	replace estado_abrev = "MS" if lugar == "M. G. do Sul"
	replace estado_abrev = "MA" if lugar == "Maranhão"
	replace estado_abrev = "MT" if lugar == "Mato Grosso"
	replace estado_abrev = "MG" if lugar == "Minas Gerais"
	replace estado_abrev = "PR" if lugar == "Paraná"
	replace estado_abrev = "PB" if lugar == "Paraíba"
	replace estado_abrev = "PA" if lugar == "Pará"
	replace estado_abrev = "PE" if lugar == "Pernambuco"
	replace estado_abrev = "PI" if lugar == "Piauí"
	replace estado_abrev = "RN" if lugar == "R. G. do Norte"
	replace estado_abrev = "RS" if lugar == "R. G. do Sul"
	replace estado_abrev = "RJ" if lugar == "Rio de Janeiro"
	replace estado_abrev = "RO" if lugar == "Rondônia"
	replace estado_abrev = "RR" if lugar == "Roraima"
	replace estado_abrev = "SC" if lugar == "Santa Catarina"
	replace estado_abrev = "SE" if lugar == "Sergipe"
	replace estado_abrev = "SP" if lugar == "São Paulo"
	replace estado_abrev = "TO" if lugar == "Tocantins"
	
	drop lugar
	order estado_abrev
	
	compress
	
	export delimited "tmp/estado_anos_iniciais.csv", replace
	
restore


//---------------------------------//
// estado - anos finais
//---------------------------------//

import excel "input/divulgacao_regioes_ufs_ideb_2019/divulgacao_regioes_ufs_ideb_2019.xls", clear sheet("UF e Regiões (AF)") allstring cellrange(A10) firstrow

ren A lugar
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
split rede, p(" ") l(1)
order rede1, a(rede)
drop rede
ren rede1 rede
drop if rede == ""

reshape long	taxa_aprovacao_6_ao_9_ano_ ///
				taxa_aprovacao_6_ano_ taxa_aprovacao_7_ano_ taxa_aprovacao_8_ano_ taxa_aprovacao_9_ano_ indicador_rendimento_ ///
				nota_SAEB_matematica_ nota_SAEB_lingua_portuguesa_ nota_SAEB_media_padronizada_ IDEB_ projecao_, ///
	i(lugar rede) j(ano)

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

sort lugar rede ano

preserve
	
	keep if inlist(lugar, "Norte", "Nordeste", "Centro-Oeste", "Sudeste", "Sul")
	
	ren lugar regiao

	compress
	
	export delimited "tmp/regiao_anos_finais.csv", replace
	
restore
preserve
	
	keep if !inlist(lugar, "Norte", "Nordeste", "Centro-Oeste", "Sudeste", "Sul")
	
	gen estado_abrev = ""
	replace estado_abrev = "AC" if lugar == "Acre"
	replace estado_abrev = "AL" if lugar == "Alagoas"
	replace estado_abrev = "AP" if lugar == "Amapá"
	replace estado_abrev = "AM" if lugar == "Amazonas"
	replace estado_abrev = "BA" if lugar == "Bahia"
	replace estado_abrev = "CE" if lugar == "Ceará"
	replace estado_abrev = "DF" if lugar == "Distrito Federal"
	replace estado_abrev = "ES" if lugar == "Espírito Santo"
	replace estado_abrev = "GO" if lugar == "Goiás"
	replace estado_abrev = "MS" if lugar == "M. G. do Sul"
	replace estado_abrev = "MA" if lugar == "Maranhão"
	replace estado_abrev = "MT" if lugar == "Mato Grosso"
	replace estado_abrev = "MG" if lugar == "Minas Gerais"
	replace estado_abrev = "PR" if lugar == "Paraná"
	replace estado_abrev = "PB" if lugar == "Paraíba"
	replace estado_abrev = "PA" if lugar == "Pará"
	replace estado_abrev = "PE" if lugar == "Pernambuco"
	replace estado_abrev = "PI" if lugar == "Piauí"
	replace estado_abrev = "RN" if lugar == "R. G. do Norte"
	replace estado_abrev = "RS" if lugar == "R. G. do Sul"
	replace estado_abrev = "RJ" if lugar == "Rio de Janeiro"
	replace estado_abrev = "RO" if lugar == "Rondônia"
	replace estado_abrev = "RR" if lugar == "Roraima"
	replace estado_abrev = "SC" if lugar == "Santa Catarina"
	replace estado_abrev = "SE" if lugar == "Sergipe"
	replace estado_abrev = "SP" if lugar == "São Paulo"
	replace estado_abrev = "TO" if lugar == "Tocantins"
	
	drop lugar
	order estado_abrev
	
	compress
	
	export delimited "tmp/estado_anos_finais.csv", replace
	
restore

//---------------------------------//
// estado - ensino medio
//---------------------------------//

import excel "input/divulgacao_regioes_ufs_ideb_2019/divulgacao_regioes_ufs_ideb_2019.xls", clear sheet("UF e Regiões (EM)") allstring cellrange(A10) firstrow

ren A lugar
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
split rede, p(" ") l(1)
order rede1, a(rede)
drop rede
ren rede1 rede
drop if rede == ""

reshape long	taxa_aprovacao_total_ ///
				taxa_aprovacao_1_serie_ taxa_aprovacao_2_serie_ taxa_aprovacao_3_serie_ taxa_aprovacao_4_serie_ indicador_rendimento_ ///
				nota_SAEB_matematica_ nota_SAEB_lingua_portuguesa_ nota_SAEB_media_padronizada_ IDEB_ projecao_, ///
	i(lugar rede) j(ano)

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

sort lugar rede ano

preserve
	
	keep if inlist(lugar, "Norte", "Nordeste", "Centro-Oeste", "Sudeste", "Sul")
	
	ren lugar regiao

	compress
	
	export delimited "tmp/regiao_ensino_medio.csv", replace
	
restore
preserve
	
	keep if !inlist(lugar, "Norte", "Nordeste", "Centro-Oeste", "Sudeste", "Sul")
	
	gen estado_abrev = ""
	replace estado_abrev = "AC" if lugar == "Acre"
	replace estado_abrev = "AL" if lugar == "Alagoas"
	replace estado_abrev = "AP" if lugar == "Amapá"
	replace estado_abrev = "AM" if lugar == "Amazonas"
	replace estado_abrev = "BA" if lugar == "Bahia"
	replace estado_abrev = "CE" if lugar == "Ceará"
	replace estado_abrev = "DF" if lugar == "Distrito Federal"
	replace estado_abrev = "ES" if lugar == "Espírito Santo"
	replace estado_abrev = "GO" if lugar == "Goiás"
	replace estado_abrev = "MS" if lugar == "M. G. do Sul"
	replace estado_abrev = "MA" if lugar == "Maranhão"
	replace estado_abrev = "MT" if lugar == "Mato Grosso"
	replace estado_abrev = "MG" if lugar == "Minas Gerais"
	replace estado_abrev = "PR" if lugar == "Paraná"
	replace estado_abrev = "PB" if lugar == "Paraíba"
	replace estado_abrev = "PA" if lugar == "Pará"
	replace estado_abrev = "PE" if lugar == "Pernambuco"
	replace estado_abrev = "PI" if lugar == "Piauí"
	replace estado_abrev = "RN" if lugar == "R. G. do Norte"
	replace estado_abrev = "RS" if lugar == "R. G. do Sul"
	replace estado_abrev = "RJ" if lugar == "Rio de Janeiro"
	replace estado_abrev = "RO" if lugar == "Rondônia"
	replace estado_abrev = "RR" if lugar == "Roraima"
	replace estado_abrev = "SC" if lugar == "Santa Catarina"
	replace estado_abrev = "SE" if lugar == "Sergipe"
	replace estado_abrev = "SP" if lugar == "São Paulo"
	replace estado_abrev = "TO" if lugar == "Tocantins"
	
	drop lugar
	order estado_abrev
	
	compress
	
	export delimited "tmp/estado_ensino_medio.csv", replace
	
restore
