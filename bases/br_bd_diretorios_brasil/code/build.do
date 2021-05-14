
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all

cd "path/to/br_bd_diretorios_brasil"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

//------------------------------//
// CNAE 1.0
//------------------------------//

import excel "input/CNAE1.0.xls", clear

drop in 1/2
drop if A == "" & B == "" & C == "" & D == ""
drop if A == "SEÇÃO"

preserve
	
	keep D E
	keep if D != ""
	ren D cnae_1
	ren E descricao
	
	tempfile classe
	save `classe'
	
restore

preserve
	
	keep C E
	keep if C != ""
	ren C grupo
	ren E descricao_grupo
	
	tempfile grupo
	save `grupo'
	
restore

preserve
	
	keep A B E
	
	replace A = A[_n-1] if A == ""
	keep if B != ""
	ren A secao
	ren B divisao
	ren E descricao_divisao
	
	tempfile divisao
	save `divisao'
	
restore

preserve
	
	keep A E
	keep if A != ""
	ren A secao
	ren E descricao_secao
	
	tempfile secao
	save `secao'
	
restore

use `classe', clear

gen grupo   = substr(cnae_1, 1, 4)
gen divisao = substr(cnae_1, 1, 2)

merge m:1 grupo using `grupo'
drop if _merge == 2
drop _merge

merge m:1 divisao using `divisao'
drop if _merge == 2
drop _merge

merge m:1 secao using `secao'
drop if _merge == 2
drop _merge

foreach k of varlist descricao* {
	
	replace `k' = trim(`k')
	replace `k' = subinstr(`k', "  ", " ", .)
	
	gen aux_`k' = upper(substr(`k', 1, 1)) + ulower(substr(`k', 2, .))
	order aux_`k', a(`k')
	drop `k'
	ren aux_`k' `k'
	
}

order	cnae_1 descricao ///
		grupo descricao_grupo ///
		divisao descricao_divisao ///
		secao descricao_secao

export delimited "output/cnae_1.csv", replace datafmt



//------------------------------//
// CNAE 2.0
//------------------------------//

import excel "input/CNAE20_EstruturaDetalhada.xls", clear

drop in 1/3
drop if A == "" & B == "" & C == "" & D == ""
drop if A == "Resoluções Concla: 01/2006 de 04/09/2006; 02/2006 de 15/12/2006 e 01/2007 de 16/05/2007"
drop if A == "2.2 - Estrutura detalhada da CNAE 2.0: Códigos e denominações"
drop if A == "Seção"

preserve
	
	keep D E
	keep if D != ""
	ren D cnae_2
	ren E descricao
	
	tempfile classe
	save `classe'
	
restore

preserve
	
	keep C E
	keep if C != ""
	ren C grupo
	ren E descricao_grupo
	
	tempfile grupo
	save `grupo'
	
restore

preserve
	
	keep A B E
	
	replace A = A[_n-1] if A == ""
	keep if B != ""
	ren A secao
	ren B divisao
	ren E descricao_divisao
	
	tempfile divisao
	save `divisao'
	
restore

preserve
	
	keep A E
	keep if A != ""
	ren A secao
	ren E descricao_secao
	
	tempfile secao
	save `secao'
	
restore

use `classe', clear

gen grupo   = substr(cnae_2, 1, 4)
gen divisao = substr(cnae_2, 1, 2)

merge m:1 grupo using `grupo'
drop if _merge == 2
drop _merge

merge m:1 divisao using `divisao'
drop if _merge == 2
drop _merge

merge m:1 secao using `secao'
drop if _merge == 2
drop _merge

foreach k of varlist descricao* {
	
	replace `k' = trim(`k')
	replace `k' = subinstr(`k', "  ", " ", .)
	
	gen aux_`k' = upper(substr(`k', 1, 1)) + ulower(substr(`k', 2, .))
	order aux_`k', a(`k')
	drop `k'
	ren aux_`k' `k'
	
}

order	cnae_2 descricao ///
		grupo descricao_grupo ///
		divisao descricao_divisao ///
		secao descricao_secao

export delimited "output/cnae_2.csv", replace datafmt


//------------------------------//
// CBO 1994
//------------------------------//

import excel "input/Variables_RAIS_2015.xlsx", clear sheet("ocupacao94")

drop in 1

split A, p(":")
drop A
ren A1 cbo_1994
ren A2 descricao

export delimited "output/cbo_1994.csv", replace datafmt


//------------------------------//
// CBO 2002
//------------------------------//

import delimited "input/ESTRUTURA CBO/CBO2002 - Grande Grupo.csv", clear stringcols(_all)
ren codigo grande_grupo
ren titulo descricao_grande_grupo
tempfile grande_grupo
save `grande_grupo'

import delimited "input/ESTRUTURA CBO/CBO2002 - SubGrupo Principal.csv", clear stringcols(_all)
ren codigo subgrupo_principal
ren titulo descricao_subgrupo_principal
tempfile subgrupo_principal
save `subgrupo_principal'

import delimited "input/ESTRUTURA CBO/CBO2002 - Familia.csv", clear stringcols(_all)
ren codigo familia
ren titulo descricao_familia
tempfile familia
save `familia'

import delimited "input/ESTRUTURA CBO/CBO2002 - SubGrupo.csv", clear stringcols(_all)
ren codigo subgrupo
ren titulo descricao_subgrupo
tempfile subgrupo
save `subgrupo'

import delimited "input/ESTRUTURA CBO/CBO2002 - Ocupacao.csv", clear stringcols(_all)

ren codigo cbo_2002
ren titulo descricao

gen grande_grupo       = substr(cbo_2002, 1, 1)
gen subgrupo_principal = substr(cbo_2002, 1, 2)
gen subgrupo           = substr(cbo_2002, 1, 3)
gen familia            = substr(cbo_2002, 1, 4)

merge m:1 grande_grupo using `grande_grupo'
drop if _merge == 2
drop _merge

merge m:1 subgrupo_principal using `subgrupo_principal'
drop if _merge == 2
drop _merge

merge m:1 subgrupo using `subgrupo'
drop if _merge == 2
drop _merge

merge m:1 familia using `familia'
drop if _merge == 2
drop _merge

foreach k of varlist descricao* {
	
	replace `k' = trim(`k')
	replace `k' = subinstr(`k', "  ", " ", .)
	
	gen aux_`k' = upper(substr(`k', 1, 1)) + ulower(substr(`k', 2, .))
	order aux_`k', a(`k')
	drop `k'
	ren aux_`k' `k'
	
}

order	cbo_2002 descricao ///
		familia descricao_familia ///
		subgrupo descricao_subgrupo ///
		subgrupo_principal descricao_subgrupo_principal ///
		grande_grupo descricao_grande_grupo

sort cbo_2002

export delimited "output/cbo_2002.csv", replace datafmt


//------------------------------//
// CBO 2002 - perfil ocupacional
//------------------------------//

import delimited "input/ESTRUTURA CBO/CBO2002 - PerfilOcupacional.csv", clear stringcols(_all)

ren cod_ocupacao			cbo_2002
ren cod_grande_grupo		grande_grupo
ren cod_subgrupo_principal	subgrupo_principal
ren cod_subgrupo			subgrupo
ren cod_familia				familia
ren sgl_grande_area			grande_area
ren nome_grande_area		descricao_grande_area
ren cod_atividade			atividade
ren nome_atividade			descricao_atividade

keep cbo_2002 grande_area descricao_grande_area atividade descricao_atividade

drop if cbo_2002 == "513505" & grande_area == "G" & atividade == "1" & descricao_atividade == "Verificar estado de conservação do local de trabalho"	// observacao duplicada

foreach k of varlist descricao* {
	
	replace `k' = trim(`k')
	replace `k' = subinstr(`k', "  ", " ", .)
	
	gen aux_`k' = upper(substr(`k', 1, 1)) + ulower(substr(`k', 2, .))
	order aux_`k', a(`k')
	drop `k'
	ren aux_`k' `k'
	
}

sort cbo_2002 grande_area atividade

export delimited "output/perfil_ocupacional.csv", replace datafmt


import delimited "input/ESTRUTURA CBO/CBO2002 - Sinonimo.csv", clear stringcols(_all)

ren codigo cbo_2002
ren titulo sinonimo

export delimited "output/sinonimo.csv", replace datafmt

