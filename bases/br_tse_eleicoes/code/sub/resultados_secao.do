
//----------------------------------------------------------------------------//
// build: resultados secao
//----------------------------------------------------------------------------//

//------------------------//
// listas de estados
//------------------------//

local estados_1994	AC AL AM AP BA BR          GO MA                   PI          RO    RS SC SE SP TO
local estados_1996	AC AL AM AP BA    CE    ES GO MA MG MS    PA PB PE PI       RN    RR RS    SE SP TO
local estados_1998	AC AL AM AP BA    CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO    ZZ
local estados_2000	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP   
local estados_2002	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO    ZZ
local estados_2004	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2006	AC AL AM AP BA    CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO    ZZ
local estados_2008	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2010	AC AL AM AP BA    CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO VT ZZ
local estados_2012	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2014	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2016	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2018	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO	
local estados_2020	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2022	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO	

//------------------------//
// loops
//------------------------//

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) case(preserve)
keep id_municipio id_municipio_tse
tempfile diretorio
save `diretorio'

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) case(preserve)
keep id_municipio_tse sigla_uf
tempfile diretorio_ufs
save `diretorio_ufs'

foreach ano of numlist 1994(2)2022 {
	
	foreach estado in `estados_`ano'' {
		
		di "`ano'_`estado'"
		
		local ano 2022
		local estado AC
		if `ano' == 2012 {
			
			import delimited "input/votacao_secao/votacao_secao_`ano'_`estado'_1t/votacao_secao_`ano'_`estado'.txt", delim(";") varn(nonames) stringcols(_all) clear
			tempfile 1t
			save `1t'
			
			cap confirm file "input/votacao_secao/votacao_secao_`ano'_`estado'_2t/votacao_secao_`ano'_`estado'_48.txt"
			if _rc==0 {
				import delimited "input/votacao_secao/votacao_secao_`ano'_`estado'_2t/votacao_secao_`ano'_`estado'_48.txt", delim(";") varn(nonames) stringcols(_all) clear
				tempfile 2t
				save `2t'
			}
			use `1t'
			if _rc==0 append using `2t'
			
		}
		else {
			
			cap import delimited "input/votacao_secao/votacao_secao_`ano'_`estado'/votacao_secao_`ano'_`estado'.txt", delim(";") varn(nonames) stringcols(_all) clear
			cap import delimited "input/votacao_secao/votacao_secao_`ano'_`estado'/votacao_secao_`ano'_`estado'.csv", delim(";") varn(nonames) stringcols(_all) clear
			
		}
		*
		
		if `ano' <= 2016 {
			
			keep v3 v4 v5 v6 v8 v10 v11 v13 v14 v15
			
			ren v3	ano
			ren v4	turno
			ren v5	tipo_eleicao
			ren v6	sigla_uf
			ren v8	id_municipio_tse
			ren v10	zona
			ren v11	secao
			ren v13	cargo
			ren v14	numero_votavel
			ren v15	votos
			
		}
		else if `ano' >= 2018 {
			
			drop in 1
			
			keep v3 v5 v6 v11 v14 v16 v17 v19 v20 v22
			
			ren v3	ano
			ren v5	tipo_eleicao
			ren v6	turno
			ren v11	sigla_uf
			ren v14	id_municipio_tse
			ren v16	zona
			ren v17	secao
			ren v19	cargo
			ren v20	numero_votavel
			ren v22	votos
			
		}
		*
		
		destring ano turno id_municipio_tse zona secao numero_votavel votos, replace force
		
		//------------------//
		// limpa strings
		//------------------//
		
		if "`estado'" == "BR" {
			drop sigla_uf
			merge m:1 id_municipio_tse using `diretorio_ufs'
			drop if _merge == 2
			drop _merge
			replace sigla_uf = "ZZ" if sigla_uf == ""
		}
		*
		
		foreach k in tipo_eleicao cargo {
			clean_string `k'
		}
		*
		
		limpa_tipo_eleicao `ano'
		
		cap limpa_candidato
		
		merge m:1 id_municipio_tse using `diretorio'
		drop if _merge == 2
		drop _merge
		order id_municipio, b(id_municipio_tse)
		
		tempfile resultados_secao_`estado'_`ano'
		save `resultados_secao_`estado'_`ano''
		
		//------------------------------------//
		// separa votos candidato vs partido
		// para seguir output original do tse
		// a nivel municipio-zona
		//------------------------------------//
		
		//-------------//
		// candidato
		//-------------//
		
		use `resultados_secao_`estado'_`ano''
		
		drop if inlist(numero_votavel, 95, 96, 97)
		
		drop if length(string(numero_votavel)) == 2 & ///
				inlist(cargo, "vereador", "deputado estadual", "deputado distrital", "deputado federal", "senador")
		
		ren numero_votavel numero_candidato
		
		tempfile resultados_cand_secao_`estado'_`ano'
		save `resultados_cand_secao_`estado'_`ano''
		
		//-------------//
		// partido
		//-------------//
		
		use `resultados_secao_`estado'_`ano'', clear
		
		drop if inlist(numero_votavel, 95, 96, 97)
		
		preserve
			
			gen numero_partido = real(substr(string(numero_votavel), 1, 2))
			
			drop if length(string(numero_votavel)) == 2 & ///
					inlist(cargo, "vereador", "deputado estadual", "deputado distrital", "deputado federal", "senador")
			
			collapse (sum) votos, by(ano tipo_eleicao turno sigla_uf id_municipio id_municipio_tse zona secao cargo numero_partido)
			
			ren votos votos_nominais
			
			tempfile votos_nominais
			save `votos_nominais'
			
		restore
		preserve
			
			keep if length(string(numero_votavel)) == 2 & ///
					inlist(cargo, "vereador", "deputado estadual", "deputado distrital", "deputado federal", "senador")
			
			ren numero_votavel	numero_partido
			ren votos			votos_nao_nominais
			
			tempfile votos_nao_nominais
			save `votos_nao_nominais'
			
		restore
		
		use `votos_nominais', clear
		
		merge 1:1 ano tipo_eleicao turno sigla_uf id_municipio_tse zona secao cargo numero_partido using `votos_nao_nominais'
		drop _merge
		
		replace votos_nominais = 0		if votos_nominais == .
		replace votos_nao_nominais = 0	if votos_nao_nominais == .
		
		tempfile resultados_part_secao_`estado'_`ano'
		save `resultados_part_secao_`estado'_`ano''
		
	}
	*
	
	//-------------------//
	// append candidato
	//-------------------//
	
	use `resultados_cand_secao_AC_`ano'', clear
	foreach estado in `estados_`ano'' {
		if "`estado'" != "AC" {
			append using `resultados_cand_secao_`estado'_`ano''
		}
	}
	*
	
	local vars ano turno tipo_eleicao sigla_uf id_municipio id_municipio_tse zona secao cargo numero_candidato
	
	order `vars'
	sort  `vars'
	
	compress
	
	save "output/resultados_candidato_secao_`ano'.dta", replace
	
	//-------------------//
	// append partido
	//-------------------//
	
	use `resultados_part_secao_AC_`ano'', clear
	foreach estado in `estados_`ano'' {
		if "`estado'" != "AC" {
			append using `resultados_part_secao_`estado'_`ano''
		}
	}
	*
	
	local vars ano turno tipo_eleicao sigla_uf id_municipio id_municipio_tse zona secao cargo numero_partido
	
	order `vars'
	sort  `vars'
	
	compress
	
	save "output/resultados_partido_secao_`ano'.dta", replace
	
}
*
