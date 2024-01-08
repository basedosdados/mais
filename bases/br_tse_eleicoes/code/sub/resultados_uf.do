
//----------------------------------------------------------------------------//
// build: resultados municipio-zona
//----------------------------------------------------------------------------//

//------------------------//
// listas de estados
//------------------------//

local estados_1933_candidato	               BR
local estados_1934_candidato	               BR
local estados_1945_candidato	   AL AM AP BA    CE DF ES    GO GP MA MG    MT PA PB PE PI PR RB RJ RN       RS SC SE SP "Fernando de Noronha" "Iguacu" "Ponta Pora"
local estados_1947_candidato	   AL AM AP BA    CE DF ES    GO GP MA MG    MT PA PB PE PI PR RB RJ RN       RS SC SE SP
local estados_1950_candidato	AC AL AM AP BA    CE DF ES    GO GP MA MG    MT PA PB PE PI PR RB RJ RN       RS SC SE SP
local estados_1954_candidato	AC AL AM AP BA    CE DF ES    GO GP MA MG    MT PA PB PE PI PR RB RJ RN       RS SC SE SP
local estados_1955_candidato	               BR
local estados_1958_candidato	AC AL AM AP BA    CE DF ES    GO    MA MG    MT PA PB PE PI PR RB RJ RN RO    RS SC SE SP
local estados_1960_candidato	               BR
local estados_1962_candidato	AC AL AM AP BA    CE    ES GB GO    MA MG    MT PA PB PE PI PR    RJ RN RO    RS SC SE SP
local estados_1965_candidato	               BR
local estados_1966_candidato	AC AL AM AP BA    CE    ES GB GO    MA MG    MT PA PB PE PI PR    RJ RN RO RR RS SC SE SP
local estados_1970_candidato	AC AL AM AP BA    CE    ES GB GO    MA MG    MT PA PB PE PI PR    RJ RN RO RR RS SC SE SP
local estados_1974_candidato	AC AL AM AP BA    CE    ES GB GO    MA MG    MT PA PB PE PI PR    RJ RN RO RR RS SC SE SP
local estados_1978_candidato	AC AL AM AP BA    CE    ES    GO    MA MG MS MT PA PB PE PI PR    RJ RN RO RR RS SC SE SP
local estados_1982_candidato	AC AL AM AP BA    CE    ES    GO    MA MG MS MT PA PB PE PI PR    RJ RN RO RR RS SC SE SP
local estados_1986_candidato	AC AL AM AP BA    CE DF ES    GO    MA MG MS MT PA PB PE PI PR    RJ RN RO RR RS SC SE SP
local estados_1989_candidato	               BR
local estados_1990_candidato	AC AL AM AP BA    CE DF ES    GO    MA MG MS MT PA PB PE PI PR    RJ RN RO RR RS SC SE SP TO

local estados_1933_partido	               BR
local estados_1934_partido	               BR
local estados_1945_partido	AC AL AM    BA    CE DF ES    GO    MA MG    MT PA PB PE PI PR    RJ RN       RS SC SE SP
local estados_1947_partido	   AL AM AP BA    CE DF ES    GO GP MA MG    MT PA PB PE PI PR RB RJ RN       RS SC SE SP
local estados_1950_partido	AC AL AM AP BA    CE DF ES    GO GP MA MG    MT PA PB PE PI PR RB RJ RN       RS SC SE SP
local estados_1954_partido	AC AL AM AP BA    CE DF ES    GO GP MA MG    MT PA PB PE PI PR RB RJ RN       RS SC SE SP
local estados_1955_partido	               BR
local estados_1958_partido	AC AL AM AP BA    CE DF ES    GO    MA MG    MT PA PB PE PI PR RB RJ RN RO    RS SC SE SP
local estados_1960_partido	               BR
local estados_1962_partido	AC AL AM AP BA    CE    ES GB GO    MA MG    MT PA PB PE PI PR    RJ RN RO    RS SC SE SP
local estados_1965_partido	               BR
local estados_1966_partido	AC AL AM AP BA    CE    ES GB GO    MA MG    MT PA PB PE PI PR    RJ RN RO RR RS SC SE SP
local estados_1970_partido	AC AL AM AP BA    CE    ES GB GO    MA MG    MT PA PB PE PI PR    RJ RN RO RR RS SC SE SP
local estados_1974_partido	AC AL AM AP BA    CE    ES GB GO    MA MG    MT PA PB PE PI PR    RJ RN RO RR RS SC SE SP
local estados_1978_partido	AC AL AM AP BA    CE    ES    GO    MA MG MS MT PA PB PE PI PR    RJ RN RO RR RS SC SE SP
local estados_1982_partido	AC AL AM AP BA    CE    ES    GO    MA MG MS MT PA PB PE PI PR    RJ RN RO RR RS SC SE SP
local estados_1986_partido	AC AL AM AP BA    CE DF ES    GO    MA MG MS MT PA PB PE PI PR    RJ RN RO RR RS SC SE SP
local estados_1990_partido	AC AL AM AP BA    CE DF ES    GO    MA MG MS MT PA PB PE PI PR    RJ RN RO RR RS SC SE SP TO

//------------------------//
// loops
//------------------------//

foreach ano of numlist 1945 1947 1955(5)1965 1950(4)1990 1989 { // 1933 1934
	
	foreach tipo in candidato partido {
		
		if "`tipo'" == "candidato" {
			
			foreach estado in `estados_`ano'_candidato' {
				
				cap import delimited "input/votacao_candidato_uf/votacao_candidato_uf_`ano'_br/VOTACAO_CANDIDATO_UF_`ano'_`estado'.txt", ///
					delim(";") varn(nonames) stringcols(_all) clear
				
				if `ano' == 1933 | `ano' == 1934 {
					drop in 1
				}
				
				cap import delimited "input/votacao_candidato_uf/VOTACAO_CANDIDATO_`ano'/VOTACAO_CANDIDATO_UF_`ano'_`estado'.txt", ///
					delim(";") varn(nonames) stringcols(_all) clear
				
				cap import delimited "input/votacao_candidato_uf/VOTACAO_CANDIDATO_UF_`ano'/VOTACAO_CANDIDATO_UF_`ano'_`estado'.txt", ///
					delim(";") varn(nonames) stringcols(_all) clear
				
				if `ano' == 1955 | `ano' == 1960 | `ano' == 1965 {
					
					import delimited "input/votacao_candidato_uf/VOTACAO_CANDIDATO_UF_`ano'/VOTACAO_CANDIDATO_UF_`ano'.txt", ///
						delim(";") varn(nonames) stringcols(_all) clear
					
					keep v3 v4 v5 v6 v11 v13 v19 v21 v24 v25 v26
					
					ren v3	ano
					ren v4	turno
					ren v5	tipo_eleicao
					ren v6	sigla_uf
					ren v11	nome_candidato
					ren v13	cargo
					ren v19	resultado
					ren v21	sigla_partido
					ren v24	coligacao
					ren v25	composicao
					ren v26 votos
					
				}
				
				if `ano' == 1989 {
					
					cap import delimited "input/votacao_candidato_uf/VOTACAO_CANDIDATO_UF_`ano'/VOTACAO_CANDIDATO_UF_`ano'.txt", ///
						delim(";") varn(nonames) stringcols(_all) clear
					
					keep v3 v4 v5 v6 v9 v11 v13 v19 v20 v21 v24 v25 v26
					
					ren v3	ano
					ren v4	turno
					ren v5	tipo_eleicao
					ren v6	sigla_uf
					ren v9	numero_candidato
					ren v11	nome_candidato
					ren v13	cargo
					ren v19	resultado
					ren v20 numero_partido
					ren v21	sigla_partido
					ren v24	coligacao
					ren v25	composicao
					ren v26 votos
					
				}
				
				if `ano' == 1933 | `ano' == 1934 | `ano' == 1945 | `ano' == 1947 | (mod(`ano', 4) == 2 & `ano' <= 1982) {
					
					keep v3 v4 v5 v6 v11 v13 v19 v21 v24 v25 v26
					
					ren v3	ano
					ren v4	turno
					ren v5	tipo_eleicao
					ren v6	sigla_uf
					ren v11	nome_candidato
					ren v13	cargo
					ren v19	resultado
					ren v21	sigla_partido
					ren v24	coligacao
					ren v25	composicao
					ren v26 votos
					
				}
				
				if `ano' == 1986 | `ano' == 1990 {
					
					keep v3 v4 v5 v6 v9 v11 v13 v19 v20 v21 v24 v25 v26
					
					ren v3	ano
					ren v4	turno
					ren v5	tipo_eleicao
					ren v6	sigla_uf
					ren v9	numero_candidato
					ren v11	nome_candidato
					ren v13	cargo
					ren v19	resultado
					ren v20 numero_partido
					ren v21	sigla_partido
					ren v24	coligacao
					ren v25	composicao
					ren v26 votos
					
				}
				
				destring ano turno votos, replace force
				
				//------------------//
				// limpa strings
				//------------------//
				
				foreach k of varlist _all {
					cap replace `k' = ""  if inlist(`k', "#NULO#", "#NULO", "#NE#", "#NE", "#AVULSO#")
				}
				*
				
				replace cargo = "SUPLENTE DE SENADOR" if cargo == "SUPLENTE DE SENADOR 1945"
				
				foreach k in tipo_eleicao cargo resultado {
					clean_string `k'
				}
				foreach k in nome_candidato {
					replace `k' = ustrtitle(`k')
				}
				*
				
				limpa_tipo_eleicao	`ano'
				limpa_partido		`ano' sigla_partido
				limpa_resultado
				
				cap limpa_candidato
				
				tempfile resultados_cand_`estado'_`ano'
				save    `resultados_cand_`estado'_`ano''
				
			}
			
			//------------//
			// append
			//------------//
			
			local first: word 1 of `estados_`ano'_candidato'
			use `resultados_cand_`first'_`ano'', clear
			foreach estado in `estados_`ano'_candidato' {
				if "`estado'" != "`first'" {
					append using `resultados_cand_`estado'_`ano''
				}
			}
			*
			
			//-------------------------//
			// salva
			//-------------------------//
			
			order votos, a(resultado)
			
			compress
			
			save "output/resultados_candidato_uf_`ano'.dta", replace
			
		}
		
		if "`tipo'" == "partido" & `ano' != 1989 {
			
			foreach estado in `estados_`ano'_partido' {
				
				cap import delimited "input/votacao_partido_uf/VOTACAO_PARTIDO_UF_`ano'/VOTACAO_PARTIDO_UF_`ano'.txt", ///
					delim(";") varn(nonames) stringcols(_all) clear
				
				cap import delimited "input/votacao_partido_uf/VOTACAO_PARTIDO_UF_`ano'/VOTACAO_PARTIDO_UF_`ano'_`estado'.txt", ///
					delim(";") varn(nonames) stringcols(_all) clear
				
				keep v3 v4 v5 v6 v9 v11 v12 v13 v16 v17
				
				ren v3	ano
				ren v4	turno
				ren v5	tipo_eleicao
				ren v6	sigla_uf
				ren v9	cargo
				ren v11	coligacao
				ren v12	composicao
				ren v13	sigla_partido
				ren v16	votos_nominais
				ren v17	votos_nao_nominais
				
				destring ano turno votos_*, replace force
				
				//------------------//
				// limpa strings
				//------------------//
				
				foreach k of varlist _all {
					cap replace `k' = ""  if inlist(`k', "#NULO#", "#NULO", "#NE#", "#NE")
				}
				*
				
				foreach k in tipo_eleicao cargo {
					clean_string `k'
				}
				
				limpa_tipo_eleicao `ano'
				limpa_partido      `ano' sigla_partido
				
				//duplicates drop
				
				tempfile resultados_part_`estado'_`ano'
				save    `resultados_part_`estado'_`ano''
				
			}
			
			//------------//
			// append
			//------------//
			
			local first: word 1 of `estados_`ano'_partido'
			use `resultados_part_`first'_`ano'', clear
			foreach estado in `estados_`ano'_partido' {
				if "`estado'" != "`first'" {
					append using `resultados_part_`estado'_`ano''
				}
			}
			*
			
			compress
			
			save "output/resultados_partido_uf_`ano'.dta", replace
			
		}
		
	}
}
