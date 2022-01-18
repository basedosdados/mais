
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
set more off

//cd "/path/to/PIB"
cd "~/Dropbox/Academic/Data/Brazil/Municipios/PIB"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

//----------------//
// 2002-2009
//----------------//

import excel "input/PIB dos Municípios - base de dados 2002-2009.xls", clear

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

//----------------//
// 2010-2019
//----------------//

import excel "input/PIB dos Municípios - base de dados 2010-2019.xls", clear

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

tempfile f2010_2019
save `f2010_2019'

//----------------//
// append
//----------------//

use `f2002_2009', clear
append using `f2010_2019'

destring, replace

foreach k of varlist pib impostos_liquidos va* {	
	replace `k' = 1000 * `k'
}
*

order id_municipio ano pib impostos_liquidos va va_agropecuaria va_industria va_servicos va_adespss
sort  id_municipio ano

format PIB impostos_liquidos va* %20.0f

export delimited "output/municipio.csv", replace datafmt




