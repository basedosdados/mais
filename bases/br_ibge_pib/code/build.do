
//----------------------------------------------------------------------------//
// preface
//----------------------------------------------------------------------------//

clear all
set more off

cd "/Users/rdahis/Dropbox/Academic/Data/Brazil/Municipios/pib"


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

export delimited "output/brasil_antigo.csv", replace

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

export delimited "output/regiao_antigo.csv", replace

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

export delimited "output/uf_antigo.csv", replace

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

export delimited "output/municipio_antigo.csv", replace


//----------------------------------------------------------------------------//
// build: tabela 5938
//----------------------------------------------------------------------------//

import delimited "input/tabela5938.csv", clear encoding("utf-8") stripquotes(yes) bindquote(strict) delim(",")

drop in 1/3
drop in 105831/105842

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
	replace `k' = "" if `k' == "..."
	destring `k', replace
	replace `k' = 1000 * `k'
}
*

sort id_municipio ano
compress

export delimited "output/municipio.csv", replace
