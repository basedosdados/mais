
//----------------------------------------------------------------------------//
// build: agregacao
//----------------------------------------------------------------------------//

//---------------------------------//
// resultados
//---------------------------------//

//---------------------//
// candidato-municipio
//---------------------//

!mkdir "output/resultados_candidato_municipio"

foreach ano of numlist 1994(2)2022 {
	
	!mkdir "output/resultados_candidato_municipio/ano=`ano'"
	
	local subdirs : dir "output/resultados_candidato_municipio_zona/ano=`ano'/" dirs "*"
	
	foreach subdir in `subdirs' {
		
		local sigla_uf = substr("`subdir'", 10, 2)
		!mkdir "output/resultados_candidato_municipio/ano=`ano'/sigla_uf=`sigla_uf'"
		
		import delimited "output/resultados_candidato_municipio_zona/ano=`ano'/sigla_uf=`sigla_uf'/resultados_candidato_municipio_zona.csv", ///
			clear varn(1) encoding("utf-8") case(preserve)
		
		collapse (sum) votos, by(turno tipo_eleicao id_municipio id_municipio_tse cargo numero_partido sigla_partido numero_candidato sequencial_candidato id_candidato_bd resultado)
		
		export delimited "output/resultados_candidato_municipio/ano=`ano'/sigla_uf=`sigla_uf'/resultados_candidato_municipio.csv", replace
		
	}
}
*

//---------------------//
// partido-municipio
//---------------------//

!mkdir "output/resultados_partido_municipio"

foreach ano of numlist 1994(2)2022 {
	
	!mkdir "output/resultados_partido_municipio/ano=`ano'"
	
	local subdirs : dir "output/resultados_partido_municipio_zona/ano=`ano'/" dirs "*"
	
	foreach subdir in `subdirs' {
		
		local sigla_uf = substr("`subdir'", 10, 2)
		!mkdir "output/resultados_partido_municipio/ano=`ano'/sigla_uf=`sigla_uf'"
		
		import delimited "output/resultados_partido_municipio_zona/ano=`ano'/sigla_uf=`sigla_uf'/resultados_partido_municipio_zona.csv", clear varn(1) encoding("utf-8") case(preserve)
		
		collapse (sum) votos*, by(turno tipo_eleicao id_municipio id_municipio_tse cargo numero_partido sigla_partido)
		
		export delimited "output/resultados_partido_municipio/ano=`ano'/sigla_uf=`sigla_uf'/resultados_partido_municipio.csv", replace
		
	}
}
*

//---------------------//
// candidato
//---------------------//

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 0
keep id_candidato_bd ano tipo_eleicao sigla_uf id_municipio_tse cargo numero numero_partido sigla_partido

tempfile candidatos_mod0
save `candidatos_mod0'

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 2 & cargo != "presidente"
keep id_candidato_bd ano tipo_eleicao sigla_uf cargo numero numero_partido sigla_partido

tempfile candidatos_mod2_estadual
save `candidatos_mod2_estadual'

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 2 & cargo == "presidente"
keep id_candidato_bd ano tipo_eleicao cargo numero numero_partido sigla_partido

tempfile candidatos_mod2_presid
save `candidatos_mod2_presid'

!mkdir "output/resultados_candidato"

foreach ano of numlist 1994(2)2022 {
	
	!mkdir "output/resultados_candidato/ano=`ano'"
	
	use "output/resultados_candidato_municipio_zona_`ano'.dta", clear
	
	cap ren sequencial sequencial_candidato
	cap ren numero numero_candidato
	cap ren nome nome_candidato
	cap ren nome_urna nome_urna_candidato
	
	ren numero_candidato numero
	
	if mod(`ano', 4) == 0 {
		
		merge m:1 ano tipo_eleicao sigla_uf id_municipio_tse cargo numero using `candidatos_mod0'
		drop if _merge == 2
		drop _merge
		
	}
	else {
		
		preserve
			
			keep if cargo != "presidente"
			
			merge m:1 ano tipo_eleicao sigla_uf cargo numero using `candidatos_mod2_estadual'
			drop if _merge == 2
			drop _merge
			
			tempfile resultados_mod2_estadual
			save `resultados_mod2_estadual'
			
		restore
		preserve
			
			keep if cargo == "presidente"
			
			merge m:1 ano tipo_eleicao cargo numero using `candidatos_mod2_presid'
			drop if _merge == 2
			drop _merge
			
			tempfile resultados_mod2_presid
			save `resultados_mod2_presid'
			
		restore
		
		use `resultados_mod2_estadual', clear
		append using `resultados_mod2_presid'
		
	}
	*
	
	ren numero numero_candidato
	
	replace sigla_uf = ""			if cargo == "presidente"
	replace id_municipio = .		if mod(ano, 4) == 2
	replace id_municipio_tse = .	if mod(ano, 4) == 2
	
	collapse (sum) votos, by(turno tipo_eleicao sigla_uf id_municipio id_municipio_tse cargo numero_partido sigla_partido sequencial_candidato numero_candidato id_candidato_bd resultado)
	
	order turno tipo_eleicao sigla_uf id_municipio id_municipio_tse cargo numero_partido sigla_partido numero_candidato sequencial_candidato id_candidato_bd resultado votos
	
	export delimited "output/resultados_candidato/ano=`ano'/resultados_candidato.csv", replace
	
}
*

//---------------------------------//
// detalhes votacao municipio
//---------------------------------//

!mkdir "output/detalhes_votacao_municipio"

foreach ano of numlist 2022 { // 1994(2)2022 {
	
	!mkdir "output/detalhes_votacao_municipio/ano=`ano'"
	
	local subdirs : dir "output/detalhes_votacao_municipio_zona/ano=`ano'/" dirs "*"
	
	foreach subdir in `subdirs' {
		
		local sigla_uf = substr("`subdir'", 10, 2)
		!mkdir "output/detalhes_votacao_municipio/ano=`ano'/sigla_uf=`sigla_uf'"
		
		import delimited "output/detalhes_votacao_municipio_zona/ano=`ano'/sigla_uf=`sigla_uf'/detalhes_votacao_municipio_zona.csv", clear varn(1) case(preserve)
		
		collapse (sum) aptos secoes secoes_agregadas aptos_totalizadas secoes_totalizadas comparecimento abstencoes votos_*, by(turno tipo_eleicao id_municipio id_municipio_tse cargo)
		
		gen proporcao_comparecimento = 100 * comparecimento / aptos
		gen proporcao_votos_validos	 = 100 * votos_validos  / comparecimento
		gen proporcao_votos_brancos	 = 100 * votos_brancos  / comparecimento
		gen proporcao_votos_nulos	 = 100 * votos_nulos    / comparecimento
		
		export delimited "output/detalhes_votacao_municipio/ano=`ano'/sigla_uf=`sigla_uf'/detalhes_votacao_municipio.csv", replace
		
	}
}
*
