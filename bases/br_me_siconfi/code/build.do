
cd "~/Downloads/siconfi"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

//----------------------------------------------//
// finbra_MUN_BalancoPatrimonialDCA(AnexoI-AB)
//----------------------------------------------//

import excel "tmp/compatibilizacao_balanco_patrimonial.xlsx", clear firstrow
tempfile compatibilizacao
save `compatibilizacao'

foreach ano of numlist 2013(1)2021 {
	
	import delimited "input/finbra_MUN_BalancoPatrimonialDCA(AnexoI-AB)/`ano'.csv", clear stringcols(_all) encoding("latin1") delim(";") bindquotes(strict)
	
	drop in 1/4
	
	drop if substr(v7, -1, 1) != "0"	// atenção: dropando duplicadas
	
	drop v1 v4 v5 v7
	
	//ren v1 instituto
	ren v2 id_municipio
	ren v3 sigla_uf
	//ren v6 conta
	ren v8 valor
	
	gen ano = `ano'
	
	drop if inlist(v6, ///
		"Ativo Financeiro", ///
		"Ativo Permanente", ///
		"Passivo Financeiro", ///
		"Passivo Permanente", ///
		"Saldo Patrimonial")
	
	replace v6 = subinstr(v6, "¿", "-", 1)
	split v6, p(" - ") l(2)
	
	preserve
		
		ren v61 portaria
		ren v62 conta
		
		keep ano portaria conta
		duplicates drop
		
		replace conta = subinstr(conta, "(-)", "", .)
		replace conta = strtrim(conta)
		
		save "tmp/contas_`ano'.dta", replace
		
	restore
	
	ren v61 portaria
	ren v62 conta
	drop v6
	
	destring valor, replace dpcomma
	
	order ano sigla_uf id_municipio portaria conta
	
	tempfile f`ano'
	save `f`ano''
	
}

use `f2013'
foreach ano of numlist 2014(1)2021 {
	append using `f`ano''
}

merge m:1 ano portaria conta using `compatibilizacao'
drop if _merge == 2
drop _merge

order ano sigla_uf id_municipio portaria conta id_conta_bd conta_bd valor
sort id_municipio id_conta_bd ano

compress

save "output/municipio_balanco_patrimonial.dta", replace



//----------------------------------------------------------------------------//
// normalizacao & particao
//----------------------------------------------------------------------------//

use "output/municipio_balanco_patrimonial.dta", clear

levelsof ano, l(anos)
foreach ano in `anos' {
	
	!mkdir -p "output/municipio_balanco_patrimonial/ano=`ano'"
	preserve
		
		keep if ano == `ano'
		drop ano
		export delimited "output/municipio_balanco_patrimonial/ano=`ano'/municipio_balanco_patrimonial.csv", replace
	
	restore
	
}













/*
//----------------------------------------------//
// finbra_MUN_VariacoesPatrimoniaisDCA(AnexoI-HI)
//----------------------------------------------//

import excel "tmp/compatibilizacao_balanco_patrimonial.xlsx", clear firstrow
tempfile compatibilizacao
save `compatibilizacao'

foreach ano of numlist 2013(1)2021 {
	
	local ano 2013
	
	import delimited "input/finbra_MUN_VariacoesPatrimoniaisDCA(AnexoI-HI)/`ano'.csv", clear stringcols(_all) encoding("latin1") delim(";") bindquotes(strict)
	






