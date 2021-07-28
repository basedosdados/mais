
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
	
	ren VL_NOTA_MATEMATICA_`ano'	nota_saeb_matematica_`ano'
	ren VL_NOTA_PORTUGUES_`ano'		nota_saeb_lingua_portuguesa_`ano'
	ren VL_NOTA_MEDIA_`ano'			nota_saeb_media_padronizada_`ano'
	
	ren VL_OBSERVADO_`ano'			ideb_`ano'
	
	ren VL_PROJECAO_`prox'			projecao_`prox'
	
}
*

destring taxa_* indicador_* nota_* ideb_* projecao_*, replace force

clean_string rede
split rede, p(" ") l(1)
order rede1, a(rede)
drop rede
ren rede1 rede
drop if rede == ""

reshape long	taxa_aprovacao_1_ao_5_ano_ ///
				taxa_aprovacao_1_ano_ taxa_aprovacao_2_ano_ taxa_aprovacao_3_ano_ taxa_aprovacao_4_ano_ taxa_aprovacao_5_ano_ indicador_rendimento_ ///
				nota_saeb_matematica_ nota_saeb_lingua_portuguesa_ nota_saeb_media_padronizada_ ideb_ projecao_, ///
	i(lugar rede) j(ano)

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

order	ano lugar rede ///
		taxa_aprovacao_1_ao_5_ano ///
		taxa_aprovacao_1_ano taxa_aprovacao_2_ano taxa_aprovacao_3_ano taxa_aprovacao_4_ano taxa_aprovacao_5_ano ///
		indicador_rendimento ///
		nota_saeb_matematica nota_saeb_lingua_portuguesa nota_saeb_media_padronizada ///
		ideb projecao

sort lugar rede ano

preserve
	
	keep if inlist(lugar, "Norte", "Nordeste", "Centro-Oeste", "Sudeste", "Sul")
	
	ren lugar regiao

	compress
	
	export delimited "tmp/regiao_anos_iniciais.csv", replace
	
restore
preserve
	
	keep if !inlist(lugar, "Norte", "Nordeste", "Centro-Oeste", "Sudeste", "Sul")
	
	gen sigla_uf = ""
	replace sigla_uf = "AC" if lugar == "Acre"
	replace sigla_uf = "AL" if lugar == "Alagoas"
	replace sigla_uf = "AP" if lugar == "Amapá"
	replace sigla_uf = "AM" if lugar == "Amazonas"
	replace sigla_uf = "BA" if lugar == "Bahia"
	replace sigla_uf = "CE" if lugar == "Ceará"
	replace sigla_uf = "DF" if lugar == "Distrito Federal"
	replace sigla_uf = "ES" if lugar == "Espírito Santo"
	replace sigla_uf = "GO" if lugar == "Goiás"
	replace sigla_uf = "MS" if lugar == "M. G. do Sul"
	replace sigla_uf = "MA" if lugar == "Maranhão"
	replace sigla_uf = "MT" if lugar == "Mato Grosso"
	replace sigla_uf = "MG" if lugar == "Minas Gerais"
	replace sigla_uf = "PR" if lugar == "Paraná"
	replace sigla_uf = "PB" if lugar == "Paraíba"
	replace sigla_uf = "PA" if lugar == "Pará"
	replace sigla_uf = "PE" if lugar == "Pernambuco"
	replace sigla_uf = "PI" if lugar == "Piauí"
	replace sigla_uf = "RN" if lugar == "R. G. do Norte"
	replace sigla_uf = "RS" if lugar == "R. G. do Sul"
	replace sigla_uf = "RJ" if lugar == "Rio de Janeiro"
	replace sigla_uf = "RO" if lugar == "Rondônia"
	replace sigla_uf = "RR" if lugar == "Roraima"
	replace sigla_uf = "SC" if lugar == "Santa Catarina"
	replace sigla_uf = "SE" if lugar == "Sergipe"
	replace sigla_uf = "SP" if lugar == "São Paulo"
	replace sigla_uf = "TO" if lugar == "Tocantins"
	
	drop lugar
	order sigla_uf
	
	compress
	
	export delimited "tmp/uf_anos_iniciais.csv", replace
	
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
	
	ren VL_NOTA_MATEMATICA_`ano'	nota_saeb_matematica_`ano'
	ren VL_NOTA_PORTUGUES_`ano'		nota_saeb_lingua_portuguesa_`ano'
	ren VL_NOTA_MEDIA_`ano'			nota_saeb_media_padronizada_`ano'
	
	ren VL_OBSERVADO_`ano'			ideb_`ano'
	
	ren VL_PROJECAO_`prox'			projecao_`prox'
	
}
*

destring taxa_* indicador_* nota_* ideb_* projecao_*, replace force

clean_string rede
split rede, p(" ") l(1)
order rede1, a(rede)
drop rede
ren rede1 rede
drop if rede == ""

reshape long	taxa_aprovacao_6_ao_9_ano_ ///
				taxa_aprovacao_6_ano_ taxa_aprovacao_7_ano_ taxa_aprovacao_8_ano_ taxa_aprovacao_9_ano_ indicador_rendimento_ ///
				nota_saeb_matematica_ nota_saeb_lingua_portuguesa_ nota_saeb_media_padronizada_ ideb_ projecao_, ///
	i(lugar rede) j(ano)

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

order	taxa_aprovacao_6_ao_9_ano ///
		taxa_aprovacao_6_ano taxa_aprovacao_7_ano taxa_aprovacao_8_ano taxa_aprovacao_9_ano ///
		indicador_rendimento ///
		nota_saeb_matematica nota_saeb_lingua_portuguesa nota_saeb_media_padronizada ///
		ideb projecao, a(ano)

sort lugar rede ano

preserve
	
	keep if inlist(lugar, "Norte", "Nordeste", "Centro-Oeste", "Sudeste", "Sul")
	
	ren lugar regiao

	compress
	
	export delimited "tmp/regiao_anos_finais.csv", replace
	
restore
preserve
	
	keep if !inlist(lugar, "Norte", "Nordeste", "Centro-Oeste", "Sudeste", "Sul")
	
	gen sigla_uf = ""
	replace sigla_uf = "AC" if lugar == "Acre"
	replace sigla_uf = "AL" if lugar == "Alagoas"
	replace sigla_uf = "AP" if lugar == "Amapá"
	replace sigla_uf = "AM" if lugar == "Amazonas"
	replace sigla_uf = "BA" if lugar == "Bahia"
	replace sigla_uf = "CE" if lugar == "Ceará"
	replace sigla_uf = "DF" if lugar == "Distrito Federal"
	replace sigla_uf = "ES" if lugar == "Espírito Santo"
	replace sigla_uf = "GO" if lugar == "Goiás"
	replace sigla_uf = "MS" if lugar == "M. G. do Sul"
	replace sigla_uf = "MA" if lugar == "Maranhão"
	replace sigla_uf = "MT" if lugar == "Mato Grosso"
	replace sigla_uf = "MG" if lugar == "Minas Gerais"
	replace sigla_uf = "PR" if lugar == "Paraná"
	replace sigla_uf = "PB" if lugar == "Paraíba"
	replace sigla_uf = "PA" if lugar == "Pará"
	replace sigla_uf = "PE" if lugar == "Pernambuco"
	replace sigla_uf = "PI" if lugar == "Piauí"
	replace sigla_uf = "RN" if lugar == "R. G. do Norte"
	replace sigla_uf = "RS" if lugar == "R. G. do Sul"
	replace sigla_uf = "RJ" if lugar == "Rio de Janeiro"
	replace sigla_uf = "RO" if lugar == "Rondônia"
	replace sigla_uf = "RR" if lugar == "Roraima"
	replace sigla_uf = "SC" if lugar == "Santa Catarina"
	replace sigla_uf = "SE" if lugar == "Sergipe"
	replace sigla_uf = "SP" if lugar == "São Paulo"
	replace sigla_uf = "TO" if lugar == "Tocantins"
	
	drop lugar
	order sigla_uf
	
	compress
	
	export delimited "tmp/uf_anos_finais.csv", replace
	
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
	
	ren VL_NOTA_MATEMATICA_`ano'	nota_saeb_matematica_`ano'
	ren VL_NOTA_PORTUGUES_`ano'		nota_saeb_lingua_portuguesa_`ano'
	ren VL_NOTA_MEDIA_`ano'			nota_saeb_media_padronizada_`ano'
	
	ren VL_OBSERVADO_`ano'			ideb_`ano'
	
	ren VL_PROJECAO_`prox'			projecao_`prox'
	
}
*

destring taxa_* indicador_* nota_* ideb_* projecao_*, replace force

clean_string rede
split rede, p(" ") l(1)
order rede1, a(rede)
drop rede
ren rede1 rede
drop if rede == ""

reshape long	taxa_aprovacao_total_ ///
				taxa_aprovacao_1_serie_ taxa_aprovacao_2_serie_ taxa_aprovacao_3_serie_ taxa_aprovacao_4_serie_ indicador_rendimento_ ///
				nota_saeb_matematica_ nota_saeb_lingua_portuguesa_ nota_saeb_media_padronizada_ ideb_ projecao_, ///
	i(lugar rede) j(ano)

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

order	ano lugar rede ///
		taxa_aprovacao_total ///
		taxa_aprovacao_1_serie taxa_aprovacao_2_serie taxa_aprovacao_3_serie taxa_aprovacao_4_serie ///
		indicador_rendimento ///
		nota_saeb_matematica nota_saeb_lingua_portuguesa nota_saeb_media_padronizada ///
		ideb projecao

sort lugar rede ano

preserve
	
	keep if inlist(lugar, "Norte", "Nordeste", "Centro-Oeste", "Sudeste", "Sul")
	
	ren lugar regiao

	compress
	
	export delimited "tmp/regiao_ensino_medio.csv", replace
	
restore
preserve
	
	keep if !inlist(lugar, "Norte", "Nordeste", "Centro-Oeste", "Sudeste", "Sul")
	
	gen sigla_uf = ""
	replace sigla_uf = "AC" if lugar == "Acre"
	replace sigla_uf = "AL" if lugar == "Alagoas"
	replace sigla_uf = "AP" if lugar == "Amapá"
	replace sigla_uf = "AM" if lugar == "Amazonas"
	replace sigla_uf = "BA" if lugar == "Bahia"
	replace sigla_uf = "CE" if lugar == "Ceará"
	replace sigla_uf = "DF" if lugar == "Distrito Federal"
	replace sigla_uf = "ES" if lugar == "Espírito Santo"
	replace sigla_uf = "GO" if lugar == "Goiás"
	replace sigla_uf = "MS" if lugar == "M. G. do Sul"
	replace sigla_uf = "MA" if lugar == "Maranhão"
	replace sigla_uf = "MT" if lugar == "Mato Grosso"
	replace sigla_uf = "MG" if lugar == "Minas Gerais"
	replace sigla_uf = "PR" if lugar == "Paraná"
	replace sigla_uf = "PB" if lugar == "Paraíba"
	replace sigla_uf = "PA" if lugar == "Pará"
	replace sigla_uf = "PE" if lugar == "Pernambuco"
	replace sigla_uf = "PI" if lugar == "Piauí"
	replace sigla_uf = "RN" if lugar == "R. G. do Norte"
	replace sigla_uf = "RS" if lugar == "R. G. do Sul"
	replace sigla_uf = "RJ" if lugar == "Rio de Janeiro"
	replace sigla_uf = "RO" if lugar == "Rondônia"
	replace sigla_uf = "RR" if lugar == "Roraima"
	replace sigla_uf = "SC" if lugar == "Santa Catarina"
	replace sigla_uf = "SE" if lugar == "Sergipe"
	replace sigla_uf = "SP" if lugar == "São Paulo"
	replace sigla_uf = "TO" if lugar == "Tocantins"
	
	drop lugar
	order sigla_uf
	
	compress
	
	export delimited "tmp/uf_ensino_medio.csv", replace
	
restore
