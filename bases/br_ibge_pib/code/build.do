
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
set more off

cd "/path/to/PIB"

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
ren AM	PIB
ren AL	impostos_liquidos
ren AK	VA
ren AG	VA_agropecuaria
ren AH	VA_industria
ren AI 	VA_servicos
ren AJ	VA_ADESPSS

keep id_municipio ano PIB VA* impostos*

tempfile f2002_2009
save `f2002_2009'

import excel "input/PIB dos Municípios - base de dados 2010-2018.xls", clear

drop in 1

ren G	id_municipio
ren A	ano
ren AM	PIB
ren AL	impostos_liquidos
ren AK	VA
ren AG	VA_agropecuaria
ren AH	VA_industria
ren AI 	VA_servicos
ren AJ	VA_ADESPSS

keep id_municipio ano PIB impostos* VA*

tempfile f2010_2018
save `f2010_2018'

use `f2002_2009', clear
append using `f2010_2018'

destring, replace

foreach k of varlist PIB impostos_liquidos VA* {	
	replace `k' = 1000 * `k'
}
*

order id_municipio ano PIB impostos_liquidos VA VA_agropecuaria VA_industria VA_servicos VA_ADESPSS
sort  id_municipio ano

format PIB impostos_liquidos VA* %20.0f

export delimited "output/municipios.csv", replace datafmt

