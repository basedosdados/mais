
//----------------------------------------------------------------------------//
// preface
//----------------------------------------------------------------------------//

clear all
set more off

cd "/Users/ricardodahis/Dropbox/Academic/Data/Brazil/Municipios/pib"


//----------------------------------------------------------------------------//
// build: tabela 21
//----------------------------------------------------------------------------//

//---------------//
// brasil
//---------------//

import delimited "input/tabela21_brasil.csv", clear encoding("utf-8") varn(nonames) rowr(4:17) stripquotes(yes) delim(",")

drop v1 v2

destring, replace force

ren v3 ano
ren v4 pib
ren v5 impostos_liquidos
ren v6 va
ren v7 va_agropecuaria
ren v8 va_industria
ren v9 va_servicos
ren v10 va_adespss

foreach k of varlist pib impostos_liquidos va* {	
	replace `k' = 1000 * `k'
}
*

export delimited "output/brasil_antigo.csv", replace datafmt

//---------------//
// regiao
//---------------//

import delimited "input/tabela21_regiao.csv", clear encoding("utf-8") varn(nonames) rowr(4:73) stripquotes(yes) delim(",")

drop v2

destring, replace force

ren v1 id_regiao
ren v3 ano
ren v4 pib
ren v5 impostos_liquidos
ren v6 va
ren v7 va_agropecuaria
ren v8 va_industria
ren v9 va_servicos
ren v10 va_adespss

foreach k of varlist pib impostos_liquidos va* {	
	replace `k' = 1000 * `k'
}
*

export delimited "output/regiao_antigo.csv", replace datafmt

//---------------//
// uf
//---------------//

import delimited "input/tabela21_uf.csv", clear encoding("utf-8") varn(nonames) rowr(4:381) stripquotes(yes) delim(",")

drop v2

destring, replace force

ren v1 id_uf
ren v3 ano
ren v4 pib
ren v5 impostos_liquidos
ren v6 va
ren v7 va_agropecuaria
ren v8 va_industria
ren v9 va_servicos
ren v10 va_adespss

foreach k of varlist pib impostos_liquidos va* {	
	replace `k' = 1000 * `k'
}
*

export delimited "output/uf_antigo.csv", replace datafmt

//---------------//
// municipio
//---------------//

import delimited "input/tabela21_municipio.csv", clear encoding("utf-8") rowr(4:77913) stripquotes(yes) delim(",")

destring, replace force

ren v1 id_municipio
ren v2 ano
ren v3 pib
ren v4 impostos_liquidos
ren v5 va
ren v6 va_agropecuaria
ren v7 va_industria
ren v8 va_servicos
ren v9 va_adespss

foreach k of varlist pib impostos_liquidos va* {	
	replace `k' = 1000 * `k'
}
*

export delimited "output/municipio_antigo.csv", replace datafmt


//----------------------------------------------------------------------------//
// build: tabela 5938
//----------------------------------------------------------------------------//

import excel "input/PIB dos Municipios - base de dados 2002-2009.xls", clear

drop in 1

ren G	id_municipio
ren A	ano
ren AM	pib
ren AL	impostos_liquidos
ren AK	va
ren AG	va_agropecuaria
ren AH	va_industria
ren AI 	va_servicos
ren AJ	va_adespss

keep id_municipio ano pib va* impostos*

tempfile f2002_2009
save `f2002_2009'

import excel "input/PIB dos Municipios - base de dados 2010-2019.xls", clear

drop in 1

ren G	id_municipio
ren A	ano
ren AM	pib
ren AL	impostos_liquidos
ren AK	va
ren AG	va_agropecuaria
ren AH	va_industria
ren AI 	va_servicos
ren AJ	va_adespss

keep id_municipio ano pib impostos* va*

tempfile f2010_
save `f2010_'

use `f2002_2009', clear
append using `f2010_'

destring, replace

foreach k of varlist pib impostos_liquidos va* {	
	replace `k' = 1000 * `k'
}
*

order id_municipio ano pib impostos_liquidos va va_agropecuaria va_industria va_servicos va_adespss
sort  id_municipio ano

//format pib impostos_liquidos va* %20.0f

export delimited "output/municipio.csv", replace datafmt

