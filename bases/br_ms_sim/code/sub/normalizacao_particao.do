
//----------------------------------------------------------------------------//
// build: limpeza e normalizacao
//----------------------------------------------------------------------------//

//------------//
// particiona
//------------//

!mkdir "output/microdados"

use "output/microdados.dta", clear

levelsof ano, l(anos)
foreach ano in `anos' {
	levelsof estado_abrev if ano == `ano', l(estados_`ano')
}
*

foreach ano in `anos' {
	
	!mkdir "output/microdados/ano=`ano'"
	
	foreach estado_abrev in `estados_`ano'' {
		
		!mkdir "output/microdados/ano=`ano'/estado_abrev=`estado_abrev'"
		
		use "output/microdados.dta", clear
		keep if ano == `ano' & estado_abrev == "`estado_abrev'"
		drop ano estado_abrev
		export delimited "output/microdados/ano=`ano'/estado_abrev=`estado_abrev'/microdados.csv", replace
		
	}
}
*
