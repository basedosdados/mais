
//----------------------------------------------------------------------------//
// build: detalhes votacao
//----------------------------------------------------------------------------//

//------------------------//
// listas de estados
//------------------------//

local estados_1994	AC AL AM AP BA             GO MA    MS             PI             RR RS SC SE SP TO BR_AC BR_AL BR_AM BR_AP BR_BA BR_GO BR_MA BR_MS BR_PI BR_RR BR_RS BR_SC BR_SE BR_SP BR_TO
local estados_1996	AC AL AM AP BA    CE    ES GO MA MG MS    PA PB    PI       RN    RR       SE SP TO
local estados_1998	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2000	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2002	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2004	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2006	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2008	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2010	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2012	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2014	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2016	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2018	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2020	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2022	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

//------------------------//
// loops
//------------------------//

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) encoding("utf-8") //stringcols(_all)
keep id_municipio id_municipio_tse
tempfile municipio
save `municipio'

foreach ano of numlist 2014(2)2022 { // 1994(2)2022 {
	
	foreach estado in `estados_`ano'' {
		
		cap import delimited using "input/detalhe_votacao_munzona/detalhe_votacao_munzona_`ano'/detalhe_votacao_munzona_`ano'_`estado'.txt", delimiter(";") varn(nonames) stringcols(_all) clear
		cap import delimited using "input/detalhe_votacao_munzona/detalhe_votacao_munzona_`ano'/detalhe_votacao_munzona_`ano'_`estado'.csv", delimiter(";") varn(nonames) stringcols(_all) clear
		
		if `ano' <= 2012 {
			
			keep v3 v4 v5 v6 v8 v10 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23
			
			ren v3 ano
			ren v4 turno
			ren v5 tipo_eleicao
			ren v6 sigla_uf
			ren v8 id_municipio_tse
			ren v10 zona
			ren v12 cargo
			ren v13 aptos
			ren v14 secoes
			ren v15 secoes_agregadas
			ren v16 aptos_totalizadas
			ren v17 secoes_totalizadas
			ren v18 comparecimento
			ren v19 abstencoes
			ren v20 votos_validos
			ren v21 votos_brancos
			ren v22 votos_nulos
			ren v23 votos_legenda
			
		}
		else if `ano' >= 2014 & `ano' <= 2020 {
			
			drop in 1
			
			keep v3 v6 v8 v11 v14 v16 v18 v19 v20 v21 v22 v23 v24 v25 v27 v28 v29 v30
			
			ren v3 ano
			ren v6 turno
			ren v8 tipo_eleicao
			ren v11 sigla_uf
			ren v14 id_municipio_tse
			ren v16 zona
			ren v18 cargo
			ren v19 aptos
			ren v20 secoes
			ren v21 secoes_agregadas
			ren v22 aptos_totalizadas
			ren v23 secoes_totalizadas
			ren v24 comparecimento
			ren v25 abstencoes
			ren v27 votos_validos
			ren v28 votos_brancos
			ren v29 votos_nulos
			ren v30 votos_legenda
			
		}
		else if `ano' >= 2022 {
			
			drop in 1
			
			keep v3 v6 v8 v11 v14 v16 v18 v19 v20 v21 v24 v26 v30 v41 v42 v32
			
			ren v3 ano
			ren v6 turno
			ren v8 tipo_eleicao
			ren v11 sigla_uf
			ren v14 id_municipio_tse
			ren v16 zona
			ren v18 cargo
			ren v19 aptos
			ren v20 secoes
			ren v21 secoes_agregadas
			//ren v22 aptos_totalizadas
			//ren v23 secoes_totalizadas
			ren v24 comparecimento
			ren v26 abstencoes
			ren v30 votos_validos
			ren v41 votos_brancos
			ren v42 votos_nulos
			ren v32 votos_legenda
			
			gen aptos_totalizadas = .
			gen secoes_totalizadas = .
			
		}
		*
		*
		
		destring ano turno id_municipio_tse zona aptos* secoes* comparecimento abstencoes votos_*, replace force
		
		foreach k of varlist zona aptos* secoes* comparecimento abstencoes votos_* {
			
			replace `k' = . if `k' == -1
			
		}
		*
		
		//------------------//
		// limpa strings
		//------------------//
		
		foreach k in tipo_eleicao cargo {
			cap clean_string `k'
		}
		*
		
		limpa_tipo_eleicao `ano'
		
		//------------------//
		// variaveis
		//------------------//
		
		merge m:1 id_municipio_tse using `municipio'
		drop if _merge == 2
		drop _merge
		order id_municipio, b(id_municipio_tse)
		
		gen proporcao_comparecimento = 100 * comparecimento / aptos
		la var proporcao_comparecimento "% Comparecimento"
		
		gen proporcao_votos_validos = 100 * votos_validos / comparecimento
		la var proporcao_votos_validos "% Votos Válidos"
		
		gen proporcao_votos_brancos = 100 * votos_brancos / comparecimento
		la var proporcao_votos_brancos "% Votos Brancos"
		
		gen proporcao_votos_nulos = 100 * votos_nulos / comparecimento
		la var proporcao_votos_nulos "% Votos Nulos"
		
		drop if mod(ano, 2) > 0
		
		duplicates drop
		
		compress
		
		tempfile detalhes_`ano'_`estado'
		save `detalhes_`ano'_`estado''
		
	}
	*
	
	//------------------//
	// append
	//------------------//
	
	use `detalhes_`ano'_AC', clear
	foreach estado in `estados_`ano'' {
		if "`estado'" != "AC" {
			append using `detalhes_`ano'_`estado''
		}
	}
	*
	
	order	ano turno tipo_eleicao sigla_uf id_municipio id_municipio_tse zona cargo aptos secoes secoes_agregadas aptos_totalizadas secoes_totalizadas ///
			comparecimento abstencoes votos_validos votos_brancos votos_nulos votos_legenda ///
			proporcao_*
	
	compress
	
	save "output/detalhes_votacao_municipio_zona_`ano'.dta", replace
	
}
*
