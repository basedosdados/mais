
//----------------------------------------------------------------------------//
// preface
//----------------------------------------------------------------------------//

clear all

cd "/Users/rdahis/Dropbox/Academic/Data/Brazil/SICONFI"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

//----------------------------------------------//
// finbra_MUN_BalancoPatrimonialDCA(AnexoI-AB)
//----------------------------------------------//

import delimited "input/br_bd_diretorios_br.municipio.csv", clear varn(1) encoding("utf-8") stringcols(_all)
keep id_municipio id_municipio_6 sigla_uf
tempfile municipio
save `municipio'

import excel "input/compatibilizacao_balanco_patrimonial.xlsx", clear firstrow
drop categoria n
drop if ano == .
duplicates drop ano portaria conta, force	// linhas onde ativos e passivos estão duplicados. mas não tem problema porque já não possível imputar um id_conta_bd de qualquer jeito
tempfile compatibilizacao
save `compatibilizacao'

//----------------------//
// 1998-2012
//----------------------//

//local ano 2002
//local k Ativo
foreach ano of numlist 1998(1)2012 {
	
	foreach k in Ativo Passivo {
		
		import excel "input/1989-2012/`ano'/`k'.xlsx", clear
		
		preserve
			keep in 1
			local i = 0
			foreach v of varlist _all {
				local name_`i' `v'
				local i = `i' + 1
				ren `v' v`i'
			}
			ren v1 id_uf
			ren v2 id_municipio_rf
			reshape long v, i(id_uf id_municipio_rf) j(n) string
			ren v conta
			drop id_uf id_municipio_rf
			tempfile contas
			save `contas'
		restore
		
		drop in 1
		
		local i = 0
		foreach v of varlist _all {
			local name_`i' `v'
			local i = `i' + 1
			ren `v' v`i'
		}
		
		if `ano' >= 2001 & `ano' <= 2002 {
			replace v2 = "1454" if v1 == "43" & v2 == "1453"
		}
		
		gen id_municipio_6 = ""
		replace id_municipio_6 = v1 + "000" + v2 if length(v2) == 1
		replace id_municipio_6 = v1 + "00"  + v2 if length(v2) == 2
		replace id_municipio_6 = v1 + "0"   + v2 if length(v2) == 3
		replace id_municipio_6 = v1         + v2 if length(v2) == 4
		drop v1 v2
		
		merge m:1 id_municipio_6 using `municipio'
		drop if _merge == 2
		drop _merge id_municipio_6
		
		reshape long v, i(id_municipio) j(n) string
		
		merge m:1 n using `contas'
		drop if _merge == 2
		drop _merge n
		
		gen ano = `ano'
		gen portaria = ""
		
		merge m:1 ano portaria conta using `compatibilizacao'
		drop if _merge == 2
		drop _merge

		ren v valor
		destring valor, replace
		
		order ano sigla_uf id_municipio conta valor
		
		tempfile `k'
		save ``k''
		
	}
	
	use `Ativo'
	append using `Passivo'
	
	tempfile f`ano'
	save `f`ano''
	
}

use `f1998', clear
foreach ano of numlist 1999(1)2012 {
	append using `f`ano''
}

tempfile finbra
save `finbra'

//----------------------//
// 2013-2021
//----------------------//

foreach ano of numlist 2013(1)2021 {
	
	import delimited "input/finbra_MUN_BalancoPatrimonialDCA(AnexoI-AB)/`ano'.csv", clear stringcols(_all) encoding("latin1") delim(";") bindquotes(strict)
	
	drop in 1/4
	
	drop if substr(v7, -1, 1) != "0"	// atenção: dropando duplicadas
	
	drop v1 v4 v5 v7
	
	ren v2 id_municipio
	ren v3 sigla_uf
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

tempfile siconfi
save `siconfi'

//----------------------//
// append
//----------------------//

use `finbra', clear
append using `siconfi'

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
