
//----------------------------------------------------------------------------//
// build: agregacao
//----------------------------------------------------------------------------//

/*

TODO:

cargo: Vereador, Prefeito, Deputado Estadual, Deputado Federal, Senador, Governador, Presidente

geo: Brasil, Macro, Estado, Meso, Micro, Municipio, Municipio-Zona, Votação Seção.

politica: Candidato, Partido, Coaligacao, Consolidado.

*/

//---------------------------------//
// resultados
//---------------------------------//

//--------------//
// candidato-municipio
//--------------//

!mkdir "output/resultados_candidato_municipio"

foreach ano of numlist 1998(2)2020 {
	
	!mkdir "output/resultados_candidato_municipio/ano=`ano'"
	
	local subdirs : dir "output/resultados_candidato_municipio_zona/ano=`ano'/" dirs "*"
	
	//di "`subdirs'"
		
	foreach subdir in `subdirs' {
		
		local sigla_uf = substr("`subdir'", 10, 2)
		!mkdir "output/resultados_candidato_municipio/ano=`ano'/sigla_uf=`sigla_uf'"
		
		import delimited "output/resultados_candidato_municipio_zona/ano=`ano'/sigla_uf=`sigla_uf'/resultados_candidato_municipio_zona.csv", clear varn(1) case(preserve)
		collapse (sum) votos, by(tipo_eleicao turno id_municipio_tse numero_candidato id_candidato_bd cargo sigla_partido resultado)
		export delimited "output/resultados_candidato_municipio/ano=`ano'/sigla_uf=`sigla_uf'/resultados_candidato_municipio.csv", replace
		
	}
}
*

//--------------//
// candidato
//--------------//

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 0
keep id_candidato_bd ano tipo_eleicao sigla_uf id_municipio_tse cargo numero_candidato

tempfile candidatos_mod0
save `candidatos_mod0'

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 2 & cargo != "presidente"
keep id_candidato_bd ano tipo_eleicao sigla_uf cargo numero_candidato

tempfile candidatos_mod2_estadual
save `candidatos_mod2_estadual'

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 2 & cargo == "presidente"
keep id_candidato_bd ano tipo_eleicao cargo numero_candidato

tempfile candidatos_mod2_presid
save `candidatos_mod2_presid'

!mkdir "output/resultados_candidato_municipio_zona"
!mkdir "output/resultados_partido_municipio_zona"
!mkdir "output/resultados_candidato"

foreach ano of numlist 1998(2)2020 {
	
	//---------------------//
	// candidato-municipio-zona
	//---------------------//
	
	use "output/resultados_candidato_municipio_zona_`ano'.dta", clear
	
	if mod(`ano', 4) == 0 {
		
		merge m:1 ano tipo_eleicao sigla_uf id_municipio_tse cargo numero_candidato using `candidatos_mod0'
		drop if _merge == 2
		drop _merge
		
	}
	else {
		
		preserve
			
			keep if cargo != "presidente"
			
			merge m:1 ano tipo_eleicao sigla_uf cargo numero_candidato using `candidatos_mod2_estadual'
			drop if _merge == 2
			drop _merge
			
			tempfile resultados_mod2_estadual
			save `resultados_mod2_estadual'
			
		restore
		preserve
			
			keep if cargo == "presidente"
			
			merge m:1 ano tipo_eleicao cargo numero_candidato using `candidatos_mod2_presid'
			drop if _merge == 2
			drop _merge
			
			tempfile resultados_mod2_presid
			save `resultados_mod2_presid'
			
		restore
		
		use `resultados_mod2_estadual', clear
		append using `resultados_mod2_presid'
		
	}
	*
	
	drop nome_candidato nome_urna_candidato sequencial_candidato coligacao composicao
	
	local vars tipo_eleicao ano turno sigla_uf id_municipio_tse zona numero_candidato id_candidato_bd cargo sigla_partido votos resultado
	
	order `vars'
	sort  `vars'
	
	tempfile resultados_candidato
	save `resultados_candidato'
	
	//------------//
	// agrega e 
	// particiona
	//------------//
	
	!mkdir "output/resultados_candidato/ano=`ano'"
	
	use `resultados_candidato', clear
	
	replace sigla_uf = ""			if cargo == "presidente"
	replace id_municipio_tse = .	if mod(ano, 4) == 2
	drop if id_candidato_bd == .
	drop if resultado == "2º turno"
	
	collapse (sum) votos, by(tipo_eleicao sigla_uf id_municipio_tse turno numero_candidato id_candidato_bd cargo sigla_partido resultado)
	
	sort id_candidato_bd
	
	export delimited "output/resultados_candidato/ano=`ano'/resultados_candidato.csv", replace
	
}
*

//--------------//
// partido
//--------------//

!mkdir "output/resultados_partido_municipio"

foreach ano of numlist 1998(2)2020 {
	
	!mkdir "output/resultados_partido_municipio/ano=`ano'"
	
	local subdirs : dir "output/resultados_partido_municipio_zona/ano=`ano'/" dirs "*"
	
	foreach subdir in `subdirs' {
		
		local sigla_uf = substr("`subdir'", 10, 2)
		!mkdir "output/resultados_partido_municipio/ano=`ano'/sigla_uf=`sigla_uf'"
		
		import delimited "output/resultados_partido_municipio_zona/ano=`ano'/sigla_uf=`sigla_uf'/resultados_partido_municipio_zona.csv", clear varn(1) case(preserve)
		collapse (sum) votos*, by(tipo_eleicao turno id_municipio_tse cargo sigla_partido)
		export delimited "output/resultados_partido_municipio/ano=`ano'/sigla_uf=`sigla_uf'/resultados_partido_municipio.csv", replace
		
	}
}
*

//---------------------------------//
// detalhes votacao municipio
//---------------------------------//

!mkdir "output/detalhes_votacao_municipio"

foreach ano of numlist 1998(2)2018 {
	
	!mkdir "output/detalhes_votacao_municipio/ano=`ano'"
	
	local subdirs : dir "output/detalhes_votacao_municipio_zona/ano=`ano'/" dirs "*"
	
	foreach subdir in `subdirs' {
		
		local sigla_uf = substr("`subdir'", 10, 2)
		!mkdir "output/detalhes_votacao_municipio/ano=`ano'/sigla_uf=`sigla_uf'"
		
		import delimited "output/detalhes_votacao_municipio_zona/ano=`ano'/sigla_uf=`sigla_uf'/detalhes_votacao_municipio_zona.csv", clear varn(1) case(preserve)
		
		collapse (sum) aptos secoes secoes_agregadas aptos_tot secoes_tot comparecimento abstencoes votos_*, by(tipo_eleicao turno id_municipio_tse cargo)
		
		gen prop_comparecimento = 100 * comparecimento / aptos
		gen prop_votos_validos	= 100 * votos_validos / comparecimento
		gen prop_votos_brancos	= 100 * votos_brancos / comparecimento
		gen prop_votos_nulos	= 100 * votos_nulos / comparecimento
		
		export delimited "output/detalhes_votacao_municipio/ano=`ano'/sigla_uf=`sigla_uf'/detalhes_votacao_municipio.csv", replace
		
	}
}
*
