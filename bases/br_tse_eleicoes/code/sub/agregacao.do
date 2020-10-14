
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
// candidato
//--------------//

!mkdir "output/resultados_candidato_municipio"

foreach ano of numlist 1998(2)2018 {
	
	!mkdir "output/resultados_candidato_municipio/ano=`ano'"
	
	local subdirs : dir "output/resultados_candidato_municipio_zona/ano=`ano'/" dirs "*"
	
	foreach subdir in `subdirs' {
		
		local estado_abrev = substr("`subdir'", 14, 2)
		!mkdir "output/resultados_candidato_municipio_zona/ano=`ano'/estado_abrev=`estado_abrev'"
		
		import delimited "output/resultados_candidato_municipio_zona/ano=`ano'/estado_abrev=`estado_abrev'/resultados_candidato_municipio_zona.csv", clear varn(1) case(preserve)
		collapse (sum) votos, by(tipo_eleicao turno id_municipio_TSE numero_candidato id_candidato_BD cargo partido resultado)
		export delimited "output/resultados_candidato_municipio/ano=`ano'/estado_abrev=`estado_abrev'/resultados_candidato_municipio.csv", replace
		
	}
}
*

//--------------//
// partido
//--------------//

!mkdir "output/resultados_partido_municipio"

foreach ano of numlist 1998(2)2018 {
	
	!mkdir "output/resultados_partido_municipio/ano=`ano'"
	
	local subdirs : dir "output/resultados_partido_municipio_zona/ano=`ano'/" dirs "*"
	
	foreach subdir in `subdirs' {
		
		local estado_abrev = substr("`subdir'", 14, 2)
		!mkdir "output/resultados_partido_municipio/ano=`ano'/estado_abrev=`estado_abrev'"
		
		import delimited "output/resultados_partido_municipio_zona/ano=`ano'/estado_abrev=`estado_abrev'/resultados_partido_municipio_zona.csv", clear varn(1) case(preserve)
		collapse (sum) votos*, by(tipo_eleicao turno id_municipio_TSE cargo partido)
		export delimited "output/resultados_partido_municipio/ano=`ano'/estado_abrev=`estado_abrev'/resultados_partido_municipio.csv", replace
		
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
		
		local estado_abrev = substr("`subdir'", 14, 2)
		!mkdir "output/detalhes_votacao_municipio/ano=`ano'/estado_abrev=`estado_abrev'"
		
		import delimited "output/detalhes_votacao_municipio_zona/ano=`ano'/estado_abrev=`estado_abrev'/detalhes_votacao_municipio_zona.csv", clear varn(1) case(preserve)
		
		collapse (sum) aptos secoes secoes_agregadas aptos_tot secoes_tot comparecimento abstencoes votos_*, by(tipo_eleicao turno id_municipio_TSE cargo)
		
		gen prop_comparecimento = 100 * comparecimento / aptos
		gen prop_votos_validos	= 100 * votos_validos / comparecimento
		gen prop_votos_brancos	= 100 * votos_brancos / comparecimento
		gen prop_votos_nulos	= 100 * votos_nulos / comparecimento
		
		export delimited "output/detalhes_votacao_municipio/ano=`ano'/estado_abrev=`estado_abrev'/detalhes_votacao_municipio.csv", replace
		
	}
}
*
