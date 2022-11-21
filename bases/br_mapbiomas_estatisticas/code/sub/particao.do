
//----------------------------------------------------------------------------//
// cobertura
//----------------------------------------------------------------------------//

//------------------//
// municipio
//------------------//

!mkdir "output/data/cobertura_municipio_classe"

use "output/data/cobertura_municipio_classe.dta", clear

levelsof ano, l(anos)

foreach ano in `anos' {
	
	!mkdir "output/data/cobertura_municipio_classe/ano=`ano'"
	
	use "output/data/cobertura_municipio_classe.dta", clear
	keep if ano == `ano'
	drop ano
	export delimited "output/data/cobertura_municipio_classe/ano=`ano'/cobertura_municipio_classe.csv", replace
	
}
*

//------------------//
// uf
//------------------//

!mkdir "output/data/cobertura_uf_classe"

use "output/data/cobertura_uf_classe.dta", clear

levelsof ano, l(anos)

foreach ano in `anos' {
	
	!mkdir "output/data/cobertura_uf_classe/ano=`ano'"
	
	use "output/data/cobertura_uf_classe.dta", clear
	keep if ano == `ano'
	drop ano
	export delimited "output/data/cobertura_uf_classe/ano=`ano'/cobertura_uf_classe.csv", replace
	
}
*

//----------------------------------------------------------------------------//
// transicao
//----------------------------------------------------------------------------//

foreach l in municipio uf {
	
	foreach k in anual quinquenal decenal {
		
		!mkdir "output/data/transicao_`l'_de_para_`k'"
		
		use "output/data/transicao_`l'_de_para_`k'.dta", clear
		
		levelsof ano, l(anos)
		//foreach ano in `anos' {
		//	levelsof sigla_uf if ano == `ano', l(estados_`ano')
		//}
		*
		
		foreach ano in `anos' {
			
			!mkdir "output/data/transicao_`l'_de_para_`k'/ano=`ano'"
			
			use "output/data/transicao_`l'_de_para_`k'.dta", clear
			keep if ano == `ano'
			drop ano
			export delimited "output/data/transicao_`l'_de_para_`k'/ano=`ano'/transicao_`l'_de_para_`k'.csv", replace
			
		}
	}
}
*
	
