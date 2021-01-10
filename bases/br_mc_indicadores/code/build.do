
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
set more off
cap log close

cd "path/to/Ministerio da Cidadania"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) stringc(_all)

keep id_municipio id_municipio_6

tempfile munic
save `munic'

//----------------------------//
// bolsa familia - familias
//----------------------------//

import delimited "input/visdata3-download-01-12-2020 001536.csv", clear varn(nonames) stringc(_all)

drop in 1
drop v2

ren v1	id_municipio_6
ren v4	familias_beneficiarias_pbf

gen ano = substr(v3, 4, 4)
gen mes = substr(v3, 1, 2)
drop v3

tempfile pbf_familias
save `pbf_familias'

//----------------------------//
// bolsa familia - recursos
//----------------------------//

import delimited "input/visdata3-download-01-12-2020 172626.csv", clear varn(nonames) stringc(_all)

drop in 1
drop v2

ren v1	id_municipio_6
ren v4	valor_pago_pbf

gen ano = substr(v3, 4, 4)
gen mes = substr(v3, 1, 2)
drop v3

tempfile pbf_recursos
save `pbf_recursos'

//----------------------------//
// cadastro unico - familias
//----------------------------//

import delimited "input/visdata3-download-01-12-2020 002233.csv", clear varn(nonames) stringc(_all)

drop in 1
drop v2

ren v1	id_municipio_6
ren v4	familias_cadastradas_cu

gen ano = substr(v3, 4, 4)
gen mes = substr(v3, 1, 2)
drop v3

tempfile cadastro_unico_familias
save `cadastro_unico_familias'

//----------------------------//
// cadastro unico - pessoas
//----------------------------//

import delimited "input/visdata3-download-01-12-2020 172158.csv", clear varn(nonames) stringc(_all)

drop in 1
drop v2

ren v1	id_municipio_6
ren v4	pessoas_cadastradas_cu

gen ano = substr(v3, 4, 4)
gen mes = substr(v3, 1, 2)
drop v3

tempfile cadastro_unico_pessoas
save `cadastro_unico_pessoas'

//----------------------------//
// merge
//----------------------------//

use `pbf_familias', clear

merge 1:1 id_municipio ano mes using `pbf_recursos'
drop _merge

merge 1:1 id_municipio ano mes using `cadastro_unico_familias'
drop _merge

merge 1:1 id_municipio ano mes using `cadastro_unico_pessoas'
drop _merge

merge m:1 id_municipio_6 using `munic'
drop if _merge == 2
drop _merge id_municipio_6

order id_municipio ano mes
sort  id_municipio ano mes

export delimited "output/transferencias_municipio.csv", replace
