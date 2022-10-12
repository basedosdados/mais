
//----------------------------------------------------------------------------//
// build: perfil eleitorado
//----------------------------------------------------------------------------//

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) case(preserve)
keep id_municipio id_municipio_tse
tempfile diretorio
save `diretorio'

//------------------------//
// loops
//------------------------//

foreach ano of numlist 1994(2)2022 {
	
	cap import delimited "input/perfil_eleitorado/perfil_eleitorado_`ano'/perfil_eleitorado_`ano'.txt", delim(";") stringcols(_all) varn(nonames) clear
	cap import delimited "input/perfil_eleitorado/perfil_eleitorado_`ano'/perfil_eleitorado_`ano'.csv", delim(";") stringcols(_all) varn(nonames) clear
	
	if `ano' <= 2016 & `ano' != 2012 {
		
		keep v1 v2 v4 v5 v6 v7 v8 v9
		
		ren v1 ano
		ren v2 sigla_uf
		ren v4 id_municipio_tse
		ren v5 zona
		ren v6 genero
		ren v7 grupo_idade
		ren v8 instrucao
		ren v9 eleitores
		
		gen situacao_biometria = ""
		gen estado_civil = ""
		gen eleitores_biometria = .
		gen eleitores_deficiencia = .
		
	}
	else if `ano' == 2012 | `ano' >= 2018 {
		
		drop in 1
		
		keep v3 v4 v5 v8 v9 v11 v13 v15 v17 v18 v19 v20
		
		ren v3 ano
		ren v4 sigla_uf
		ren v5 id_municipio_tse
		ren v8 situacao_biometria
		ren v9 zona
		ren v11 genero
		ren v13 estado_civil
		ren v15 grupo_idade
		ren v17 instrucao
		ren v18 eleitores
		ren v19 eleitores_biometria
		ren v20 eleitores_deficiencia
		
	}
	*
	
	destring ano id_municipio_tse zona eleitores*, replace force
	
	foreach k of varlist zona eleitores* {
		
		replace `k' = . if `k' == -1
		
	}
	*
	
	foreach k in genero grupo_idade instrucao estado_civil situacao_biometria {
		cap clean_string `k'
	}
	*
	
	cap limpa_instrucao
	cap limpa_estado_civil
	
	merge m:1 id_municipio_tse using `diretorio'
	drop if _merge == 2
	drop _merge
	order id_municipio, b(id_municipio_tse)
				
	replace ano = 2014 if ano == 201407
	
	order ano sigla_uf id_municipio id_municipio_tse situacao_biometria zona genero estado_civil grupo_idade instrucao ///
		eleitores eleitores_biometria eleitores_deficiencia
	
	compress
	
	save "output/perfil_eleitorado_municipio_zona_`ano'.dta", replace

}
*
