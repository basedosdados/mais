
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
cap log close

cd "path/to/Ehrl_AMCgeneration_EE"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

import delimited "../../municipios.csv", clear varn(1)

keep id_municipio

tempfile municipios
save `municipios'

//-------------------//
// pre-processamento
//-------------------//

do "_Crosswalk_pre.do"

//-------------------//
// loop
//-------------------//

local anos 1872 1900 1911 1920 1933 1940 1950 1960 1970 1980 1991 2000 2010

foreach de in `anos' {
	foreach para in `anos' {
		
		if `de' < `para' {
			
			do "_Crosswalk_main.do" `de' `para'
			
			//-------------------//
			// normaliza
			//-------------------//
			
			use "_Crosswalk_final_`de'_`para'.dta", clear
			
			keep code2010 amc
			
			ren code2010	id_municipio
			ren amc			id_AMC
			
			gen ano_de = `de'
			gen ano_para = `para'
			
			tempfile `de'_`para'
			save ``de'_`para''
			
		}
	}
}
*

use `1872_1900', clear
foreach de in `anos' {
	foreach para in `anos' {
		if `de' < `para' & !(`de' == 1872 & `para' == 1900) {
			append using ``de'_`para''
		}
	}
}
*

preserve
	
	import delimited "../../municipios.csv", clear varn(1)

	keep id_municipio
	
	tempfile municipios
	save `municipios'
	
restore

merge m:1 id_municipio using `municipios'
drop if _merge != 3
drop _merge

order id_municipio ano_de ano_para id_AMC
sort  id_municipio ano_de ano_para

export delimited "../output/municipio_de_para.csv", replace

! rm -f _Crosswalk_*.log
! rm -f _Crosswalk_final_*.dta
