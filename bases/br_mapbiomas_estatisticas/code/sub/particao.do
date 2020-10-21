
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
// estado-bioma
//------------------//

!mkdir "output/data/cobertura_estado_bioma_classe"

use "output/data/cobertura_estado_bioma_classe.dta", clear

levelsof ano, l(anos)

foreach ano in `anos' {
	
	!mkdir "output/data/cobertura_estado_bioma_classe/ano=`ano'"
	
	use "output/data/cobertura_estado_bioma_classe.dta", clear
	keep if ano == `ano'
	drop ano
	export delimited "output/data/cobertura_estado_bioma_classe/ano=`ano'/cobertura_estado_bioma_classe.csv", replace
	
}
*

//----------------------------------------------------------------------------//
// transicao municipio
//----------------------------------------------------------------------------//

foreach l in municipio estado_bioma {
	
	foreach k in quinquenal decenal anual {
		
		!mkdir "output/data/transicao_`l'_de_para_`k'"
		
		use "output/data/transicao_`l'_de_para_`k'.dta", clear
		
		levelsof ano, l(anos)
		foreach ano in `anos' {
			levelsof estado_abrev if ano == `ano', l(estados_`ano')
		}
		*
		
		foreach ano in `anos' {
			
			!mkdir "output/data/transicao_`l'_de_para_`k'/ano=`ano'"
			
			foreach estado_abrev in `estados_`ano'' {
				
				!mkdir "output/data/transicao_`l'_de_para_`k'/ano=`ano'/estado_abrev=`estado_abrev'"
				
				use "output/data/transicao_`l'_de_para_`k'.dta", clear
				keep if ano == `ano' & estado_abrev == "`estado_abrev'"
				drop ano estado_abrev
				export delimited "output/data/transicao_`l'_de_para_`k'/ano=`ano'/estado_abrev=`estado_abrev'/transicao_`l'_de_para_`k'.csv", replace
				
			}
		}
	}
}
*
	
