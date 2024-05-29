
//----------------------------------------------------------------------------//
// build: detalhes votacao secao
//----------------------------------------------------------------------------//

//------------------------//
// listas de estados
//------------------------//

local estados_1994	AC AL AM AP BA BRASIL          GO MA    MS             PI                RS SC SE SP TO
local estados_1996	AC AL AM AP BA        CE    ES GO MA MG MS    PA PB PE PI       RN    RR RS    SE SP TO
local estados_1998	AC AL AM AP BA BRASIL CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2000	AC AL AM AP BA        CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP 
local estados_2002	AC AL AM AP BA BR     CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2004	AC AL AM AP BA        CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2006	AC AL AM AP BA BR     CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2008	AC AL AM AP BA        CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2010	AC AL AM AP BA BR     CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2012	AC AL AM AP BA        CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2014	AC AL AM AP BA BR     CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2016	AC AL AM AP BA        CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2018	AC AL AM AP BA BR     CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2020	AC AL AM AP BA        CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2022	AC AL AM AP BA BR     CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

//------------------------//
// loops
//------------------------//

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) encoding("utf-8") //stringcols(_all)
keep id_municipio id_municipio_tse
tempfile municipio
save `municipio'

foreach ano of numlist 2002(2)2022 { // 1994(2)2022 {
	
	foreach estado in `estados_`ano'' {
		
		di "Ano: `ano' - UF: `estado'"
		
		local ano 2008
		local estado MA
		cap import delimited using "input/detalhe_votacao_secao/detalhe_votacao_secao_`ano'/detalhe_votacao_secao_`ano'_`estado'.txt", delimiter(";") varn(nonames) stringcols(_all) clear
		cap import delimited using "input/detalhe_votacao_secao/detalhe_votacao_secao_`ano'/detalhe_votacao_secao_`ano'_`estado'.csv", delimiter(";") varn(nonames) stringcols(_all) clear
		
		sort v7
		br if id_municipio_tse == 9156 & zona == 21 & tipo_eleicao != "Eleição Ordinária"
		
		/*
		if `ano' <= 2016 {
			
			keep v3 v4 v5 v6 v8 v10 v11 v13 v14 v15 v16 v17 v18 v19 v20 v21
			
			ren v3 ano
			ren v4 turno
			ren v5 tipo_eleicao
			ren v6 sigla_uf
			ren v8 id_municipio_tse
			ren v10 zona
			ren v11 secao
			ren v13 cargo
			ren v14 aptos
			ren v15 comparecimento
			ren v16 abstencoes
			ren v17 votos_nominais
			ren v18 votos_brancos
			ren v19 votos_nulos
			ren v20 votos_legenda
			ren v21 votos_nulos_apu_sep
			
			gen votos_pendentes = .
			
		}
		else if `ano' >= 2014 {
		*/
	
		drop in 1
		
		keep v3 v5 v6 v11 v14 v16 v17 v19 v20 v21 v22 v23 v24 v25 v26 v27
		
		ren v3 ano
		ren v5 tipo_eleicao
		ren v6 turno
		ren v11 sigla_uf
		ren v14 id_municipio_tse
		ren v16 zona
		ren v17 secao
		ren v19 cargo
		ren v20 aptos
		ren v21 comparecimento
		ren v22 abstencoes
		ren v23 votos_nominais
		ren v24 votos_brancos
		ren v25 votos_nulos
		ren v26 votos_legenda
		ren v27 votos_nulos_apu_sep
		
		destring ano turno id_municipio_tse zona secao aptos* comparecimento abstencoes votos_*, replace force
		
		foreach k of varlist zona secao aptos* comparecimento abstencoes votos_* {
			
			replace `k' = . if `k' == -1
			
		}
		*
		
		if "`estado'" == "BRASIL" {
			keep if cargo == "PRESIDENTE" | sigla_uf == "DF"
		}
		
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
		
		gen proporcao_votos_nominais = 100 * votos_nominais / comparecimento
		la var proporcao_votos_nominais "% Votos Nominais"
		
		gen proporcao_votos_legenda = 100 * votos_legenda / comparecimento
		la var proporcao_votos_legenda "% Votos em Legenda"
		
		gen proporcao_votos_brancos = 100 * votos_brancos / comparecimento
		la var proporcao_votos_brancos "% Votos Brancos"
		
		gen proporcao_votos_nulos = 100 * votos_nulos / comparecimento
		la var proporcao_votos_nulos "% Votos Nulos"
		
		drop if mod(ano, 2) > 0
		
		duplicates tag ano turno tipo_eleicao sigla_uf id_municipio_tse zona secao cargo, gen(dup) // idealmente usar o codigo_eleicao (v7) para identificar
		drop if dup > 0
		drop dup
		
		tempfile detalhes_secao_`ano'_`estado'
		save `detalhes_secao_`ano'_`estado''
		
	}
	*
	
	//------------------//
	// append
	//------------------//
	
	use `detalhes_secao_`ano'_AC', clear
	foreach estado in `estados_`ano'' {
		if "`estado'" != "AC" {
			append using `detalhes_secao_`ano'_`estado''
		}
	}
	*
	
	order	ano turno tipo_eleicao sigla_uf id_municipio id_municipio_tse zona secao cargo aptos comparecimento abstencoes ///
			votos_nominais votos_brancos votos_nulos votos_legenda votos_nulos_apu_sep //votos_pendentes
	
	compress
	
	save "output/detalhes_votacao_secao_`ano'.dta", replace
	
}
*
