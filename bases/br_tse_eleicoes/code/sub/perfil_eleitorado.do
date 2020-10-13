
//----------------------------------------------------------------------------//
// build: perfil eleitorado
//----------------------------------------------------------------------------//

//------------------------//
// loops
//------------------------//

foreach ano of numlist 1996(2)2020 {
	
	cap import delimited "input/perfil_eleitorado/perfil_eleitorado_`ano'/perfil_eleitorado_`ano'.txt", delim(";") stringcols(_all) varn(nonames) clear
	cap import delimited "input/perfil_eleitorado/perfil_eleitorado_`ano'/perfil_eleitorado_`ano'.csv", delim(";") stringcols(_all) varn(nonames) clear
	
	if `ano' <= 2016 {
		
		keep v1 v2 v4 v5 v6 v7 v8 v9
		
		ren v1 ano
		ren v2 estado_abrev
		ren v4 id_municipio_TSE
		ren v5 zona
		ren v6 genero
		ren v7 grupo_idade
		ren v8 instrucao
		ren v9 eleitores
		
	}
	else if `ano' >= 2018 {
		
		drop in 1
		
		keep v3 v4 v5 v8 v9 v11 v13 v15 v17 v18 v19 v20
		
		ren v3 ano
		ren v4 estado_abrev
		ren v5 id_municipio_TSE
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
	
	destring ano id_municipio_TSE zona eleitores*, replace force
	
	foreach k of varlist zona eleitores* {
		
		replace `k' = . if `k' == -1
		
	}
	*
	
	foreach k in genero grupo_idade instrucao estado_civil situacao_biometria {
		cap clean_string `k'
	}
	*
	
	limpa_instrucao
	limpa_estado_civil
	
	replace ano = 2014 if ano == 201407
	
	compress
	
	save "output/perfil_eleitorado_`ano'.dta", replace

}
*
