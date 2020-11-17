
//----------------------------------------------------------------------------//
// ano escolar
//----------------------------------------------------------------------------//

foreach k in escola municipio estado regiao brasil {

	if "`k'" == "escola"	local vars id_escola escola id_municipio municipio estado_abrev
	if "`k'" == "municipio"	local vars id_municipio municipio estado_abrev
	if "`k'" == "estado"	local vars estado_abrev
	if "`k'" == "regiao"	local vars regiao
	if "`k'" == "brasil"	local vars 
	
	import delimited "tmp/`k'_anos_iniciais.csv", clear varn(1) case(preserve) encoding("utf-8")
	
	preserve
		
		keep `vars' rede ano ///
			 taxa_aprovacao_1_ano taxa_aprovacao_2_ano taxa_aprovacao_3_ano taxa_aprovacao_4_ano taxa_aprovacao_5_ano
		
		ren taxa_aprovacao_1_ano taxa_aprovacao_1
		ren taxa_aprovacao_2_ano taxa_aprovacao_2
		ren taxa_aprovacao_3_ano taxa_aprovacao_3
		ren taxa_aprovacao_4_ano taxa_aprovacao_4
		ren taxa_aprovacao_5_ano taxa_aprovacao_5
		
		reshape long taxa_aprovacao_, i(`vars' rede ano) j(ano_escolar)
		ren taxa_aprovacao_ taxa_aprovacao
		
		gen ensino = "fundamental"
		
		tempfile iniciais
		save `iniciais'
		
	restore
		
	import delimited "tmp/`k'_anos_finais.csv", clear varn(1) case(preserve) encoding("utf-8")
	
	preserve
		
		keep `vars' rede ano ///
			 taxa_aprovacao_6_ano taxa_aprovacao_7_ano taxa_aprovacao_8_ano taxa_aprovacao_9_ano
		
		ren taxa_aprovacao_6_ano taxa_aprovacao_6
		ren taxa_aprovacao_7_ano taxa_aprovacao_7
		ren taxa_aprovacao_8_ano taxa_aprovacao_8
		ren taxa_aprovacao_9_ano taxa_aprovacao_9
		
		reshape long taxa_aprovacao_, i(`vars' rede ano) j(ano_escolar)
		ren taxa_aprovacao_ taxa_aprovacao
		
		gen ensino = "fundamental"
		
		tempfile finais
		save `finais'
		
	restore
	
	import delimited "tmp/`k'_ensino_medio.csv", clear varn(1) case(preserve) encoding("utf-8")
	
	preserve
		
		keep `vars' rede ano ///
			 taxa_aprovacao_1_serie taxa_aprovacao_2_serie taxa_aprovacao_3_serie taxa_aprovacao_4_serie
		
		ren taxa_aprovacao_1_serie taxa_aprovacao_1
		ren taxa_aprovacao_2_serie taxa_aprovacao_2
		ren taxa_aprovacao_3_serie taxa_aprovacao_3
		ren taxa_aprovacao_4_serie taxa_aprovacao_4
		
		reshape long taxa_aprovacao_, i(`vars' rede ano) j(ano_escolar)
		ren taxa_aprovacao_ taxa_aprovacao
		
		gen ensino = "medio"
		
		tempfile EM
		save `EM'
		
	restore
	
	use `iniciais', clear
	append using `finais'
	append using `EM'
	
	tostring taxa_aprovacao, replace force
	replace taxa_aprovacao = substr(taxa_aprovacao, 1, 5)
	destring taxa_aprovacao, replace
	replace taxa_aprovacao = round(taxa_aprovacao, 0.1)
	tostring taxa_aprovacao, replace force
	replace taxa_aprovacao = "" if taxa_aprovacao == "."
	
	drop if ano == 2021	// dropa observacoes que estavam so para projecao
	
	order `vars' rede ensino ano_escolar ano
	sort  `vars' rede ensino ano_escolar ano
	
	compress
	
	export delimited "output/`k'_ano_escolar.csv", replace
	
}
*

//----------------------------------------------------------------------------//
// medias
//----------------------------------------------------------------------------//

foreach k in escola municipio estado regiao brasil {
	
	if "`k'" == "escola"	local vars id_escola escola id_municipio municipio estado_abrev
	if "`k'" == "municipio"	local vars id_municipio municipio estado_abrev
	if "`k'" == "estado"	local vars estado_abrev
	if "`k'" == "regiao"	local vars regiao
	if "`k'" == "brasil"	local vars 
	
	import delimited "tmp/`k'_anos_iniciais.csv", clear varn(1) case(preserve) encoding("utf-8")
	
	preserve
		
		drop taxa_aprovacao_1_ano taxa_aprovacao_2_ano taxa_aprovacao_3_ano taxa_aprovacao_4_ano taxa_aprovacao_5_ano
		
		ren taxa_aprovacao_1_ao_5_ano taxa_aprovacao
		
		gen ensino = "fundamental"
		gen anos_escolares = "iniciais (1-5)"
		
		tempfile iniciais
		save `iniciais'
		
	restore
		
	import delimited "tmp/`k'_anos_finais.csv", clear varn(1) case(preserve) encoding("utf-8")
	
	preserve
		
		drop taxa_aprovacao_6_ano taxa_aprovacao_7_ano taxa_aprovacao_8_ano taxa_aprovacao_9_ano	 
		
		ren taxa_aprovacao_6_ao_9_ano taxa_aprovacao
		
		gen ensino = "fundamental"
		gen anos_escolares = "finais (6-9)"
		
		tempfile finais
		save `finais'
		
	restore
	
	import delimited "tmp/`k'_ensino_medio.csv", clear varn(1) case(preserve) encoding("utf-8")
	
	preserve
		
		drop taxa_aprovacao_1_serie taxa_aprovacao_2_serie taxa_aprovacao_3_serie taxa_aprovacao_4_serie
		
		ren taxa_aprovacao_total taxa_aprovacao
		
		gen ensino = "medio"
		gen anos_escolares = "todos (1-4)"
		
		tempfile EM
		save `EM'
		
	restore
	
	use `iniciais', clear
	append using `finais'
	append using `EM'
	
	foreach v of varlist taxa_aprovacao IDEB projecao {
		
		tostring `v', replace force
		replace `v' = substr(`v', 1, 5)
		destring `v', replace
		replace `v' = round(`v', 0.1)
		tostring `v', replace force
		replace `v' = "" if `v' == "."
	
	}
	*
	
	foreach v of varlist nota_SAEB_matematica nota_SAEB_lingua_portuguesa {
		
		tostring `v', replace force
		replace `v' = substr(`v', 1, 6)
		destring `v', replace
		replace `v' = round(`v', 0.01)
		tostring `v', replace force
		replace `v' = "" if `v' == "."
	
	}
	*
	
	order `vars' rede ensino ensino anos_escolares ano
	sort  `vars' rede ensino ensino anos_escolares ano
	
	compress
	
	export delimited "output/`k'.csv", replace
	
}
*
