
//----------------------------------------------------------------------------//
// build: resultados municipio-zona
//----------------------------------------------------------------------------//

//------------------------//
// listas de estados
//------------------------//

local estados_1994_candidato	AC AL AM AP BA BR          GO MA    MS             PI             RR RS SC SE SP TO
local estados_1996_candidato	AC AL AM AP BA    CE    ES GO MA MG MS    PA PB PE PI       RN    RR RS    SE SP TO
local estados_1998_candidato	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO    //ZZ dados faltando no original do TSE. está afetando o somatório de votos para presidente
local estados_2000_candidato	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2002_candidato	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO    ZZ
local estados_2004_candidato	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2006_candidato	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO    ZZ
local estados_2008_candidato	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2010_candidato	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO VT ZZ
local estados_2012_candidato	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2014_candidato	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2016_candidato	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2018_candidato	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2020_candidato	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO	
local estados_2022_candidato	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

local estados_1994_partido		AC AL AM AP BA             GO MA    MS             PI             RR RS SC SE SP TO
local estados_1996_partido		AC AL AM AP BA    CE    ES GO MA MG MS    PA PB PE PI       RN    RR RS    SE SP TO
local estados_1998_partido		AC AL AM AP BA    CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO    ZZ
local estados_2000_partido		AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2002_partido		AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO    ZZ
local estados_2004_partido		AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2006_partido		AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO    ZZ
local estados_2008_partido		AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2010_partido		AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO    ZZ
local estados_2012_partido		AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2014_partido		AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2016_partido		AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2018_partido		AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO	
local estados_2020_partido		AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2022_partido		AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

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
	
	foreach tipo in candidato partido {
		
		if "`tipo'" == "candidato" {
			
			foreach estado in `estados_`ano'_candidato' {
				
				cap import delimited "input/votacao_candidato_munzona/votacao_candidato_munzona_`ano'/votacao_candidato_munzona_`ano'_`estado'.txt", ///
					delim(";") varn(nonames) stringcols(_all) clear //rowr(1:10000)
				cap import delimited "input/votacao_candidato_munzona/votacao_candidato_munzona_`ano'/votacao_candidato_munzona_`ano'_`estado'.csv", ///
					delim(";") varn(nonames) stringcols(_all) clear //rowr(1:10000)
				
				if `ano' <= 2012 {
					
					keep v3 v4 v5 v6 v8 v10 v12 v13 v14 v15 v16 v22 v23 v24 v29
					
					ren v3	ano
					ren v4	turno
					ren v5	tipo_eleicao
					ren v6	sigla_uf
					ren v8	id_municipio_tse
					ren v10	zona
					ren v12	numero_candidato
					ren v13	sequencial_candidato
					ren v14	nome_candidato
					ren v15	nome_urna_candidato
					ren v16	cargo
					ren v22	resultado
					ren v23 numero_partido
					ren v24	sigla_partido
					//ren v27	coligacao
					//ren v28	composicao
					ren v29	votos
					
				}
				else if `ano' >= 2014 & `ano' <= 2020 {
					
					drop in 1
					
					keep v3 v6 v8 v11 v14 v16 v18 v19 v20 v21 v22 v29 v30 v36 v38
					
					ren v3  ano
					ren v6  turno
					ren v8  tipo_eleicao
					ren v11 sigla_uf
					ren v14 id_municipio_tse
					ren v16 zona
					ren v19 sequencial_candidato
					ren v20 numero_candidato
					ren v21 nome_candidato
					ren v22 nome_urna_candidato
					ren v18 cargo
					ren v36 resultado
					ren v29 numero_partido
					ren v30 sigla_partido
					//ren v33 coligacao
					//ren v34 composicao
					ren v38 votos
					
				}
				else if `ano' >= 2022 {
					
					drop in 1
					
					keep v3 v5 v6 v11 v14 v16 v18 v19 v20 v21 v22 v29 v30 v40 v44
					
					ren v3  ano
					ren v5  tipo_eleicao
					ren v6  turno
					ren v11 sigla_uf
					ren v14 id_municipio_tse
					ren v16 zona
					ren v18 cargo
					ren v19 sequencial_candidato
					ren v20 numero_candidato
					ren v21 nome_candidato
					ren v22 nome_urna_candidato
					ren v29 numero_partido
					ren v30 sigla_partido
					//ren v37 coligacao
					//ren v38 composicao
					ren v40 votos
					ren v44 resultado
					
				}
				*
				
				//------------------//
				// limpa strings
				//------------------//
				
				destring ano turno id_municipio_tse zona numero_candidato numero_partido votos, replace force // sequencial_candidato
				
				replace sequencial_candidato = "" if sequencial_candidato == "-1"
				
				drop if turno == 2 & cargo == "PRESIDENTE" & "`estado'" != "BR" & `ano' == 2002
					// consertando problema que dados para presidente no 2o turno vem dobrados entre arquivos de UFs e BR em 2002.
				drop if cargo == "PRESIDENTE" & "`estado'" != "BR" & (`ano' == 2006 | `ano' == 2010)
				
				if "`estado'" == "BR" {
					ren sigla_uf sigla_uf_orig
					merge m:1 id_municipio_tse using `diretorio_ufs'
					drop if _merge == 2
					drop _merge
					replace sigla_uf_orig = sigla_uf if sigla_uf_orig == "BR"
					drop sigla_uf
					ren sigla_uf_orig sigla_uf
				}
				*
				
				foreach k of varlist _all {
					cap replace `k' = ""  if inlist(`k', "#NULO#", "#NULO", "#NE#", "#NE", "##VERIFICAR BASE 1994##")
				}
				*
				
				foreach k in tipo_eleicao cargo resultado {
					clean_string `k'
				}
				foreach k in nome_candidato nome_urna_candidato {
					replace `k' = ustrtitle(`k')
				}
				*
				
				limpa_tipo_eleicao	`ano'
				limpa_partido		`ano' sigla_partido
				limpa_resultado
				
				cap limpa_candidato
				
				merge m:1 id_municipio_tse using `diretorio'
				drop if _merge == 2
				drop _merge
				order id_municipio, b(id_municipio_tse)
				
				tempfile resultados_cand_`estado'_`ano'
				save `resultados_cand_`estado'_`ano''
				
			}
			
			//------------//
			// append
			//------------//
			
			use `resultados_cand_AC_`ano'', clear
			foreach estado in `estados_`ano'_candidato' {
				if "`estado'" != "AC" {
					append using `resultados_cand_`estado'_`ano''
				}
			}
			*
			
			//-------------------------//
			// conserta problema de
			// resultado nulo para UFs=VT,ZZ
			//-------------------------//
			
			preserve
				
				keep if cargo == "presidente"
				
				bys numero_candidato turno (resultado): replace resultado = resultado[_N] if cargo == "presidente"	
				
				tempfile presid
				save `presid'
				
			restore
			
			drop if cargo == "presidente"
			append using `presid'
			
			//-------------------------//
			// salva
			//-------------------------//
			
			drop if ano == 2009 | ano == 2011 // erros já vistos nos dados
			
			order votos, a(resultado)
			
			compress
			
			save "output/resultados_candidato_municipio_zona_`ano'.dta", replace
			
		}
		*
		
		if "`tipo'" == "partido" {
			
			foreach estado in `estados_`ano'_partido' {
				
				di "`ano'_`estado'_partido"
				
				cap import delimited "input/votacao_partido_munzona/votacao_partido_munzona_`ano'/votacao_partido_munzona_`ano'_`estado'.txt", ///
					delim(";") varn(nonames) stringcols(_all) clear //rowr(1:10000)
				cap import delimited "input/votacao_partido_munzona/votacao_partido_munzona_`ano'/votacao_partido_munzona_`ano'_`estado'.csv", ///
					delim(";") varn(nonames) stringcols(_all) clear //rowr(1:10000)
				
				if `ano' <= 2012 {
					
					keep v3 v4 v5 v6 v8 v10 v12 v16 v17 v19 v20
					
					ren v3	ano
					ren v4	turno
					ren v5	tipo_eleicao
					ren v6	sigla_uf
					ren v8	id_municipio_tse
					ren v10	zona
					ren v12	cargo
					//ren v14	coligacao
					//ren v15	composicao
					ren v17 numero_partido
					ren v16	sigla_partido
					ren v19	votos_nominais
					ren v20	votos_nao_nominais
					
					order numero_partido, b(sigla_partido)
					
				}
				else if `ano' >= 2014 & `ano' <= 2020 {
					
					drop in 1
					
					keep v3 v6 v8 v11 v14 v16 v18 v20 v21 v27 v28
					
					ren v3	ano
					ren v6	turno
					ren v8	tipo_eleicao
					ren v11	sigla_uf
					ren v14	id_municipio_tse
					ren v16	zona
					ren v18	cargo
					//ren v24	coligacao
					//ren v25	composicao
					ren v20 numero_partido
					ren v21	sigla_partido
					ren v27	votos_nominais
					ren v28	votos_nao_nominais
					
				}
				else if `ano' >= 2022 {
					
					drop in 1
					
					keep v3 v5 v6 v11 v14 v16 v18 v20 v21 v33 v34
					
					ren v3	ano
					ren v5	tipo_eleicao
					ren v6	turno
					ren v11	sigla_uf
					ren v14	id_municipio_tse
					ren v16	zona
					ren v18	cargo
					ren v20 numero_partido
					ren v21	sigla_partido
					//ren v28	coligacao
					//ren v29	composicao
					ren v33	votos_nao_nominais
					ren v34	votos_nominais
					
					order votos_nominais, b(votos_nao_nominais)
					
				}
				*
				
				//------------------//
				// limpa strings
				//------------------//
				
				destring ano turno id_municipio_tse zona numero_partido votos_*, replace force
				
				if "`estado'" == "BR" {
					ren sigla_uf sigla_uf_orig
					merge m:1 id_municipio_tse using `diretorio_ufs'
					drop if _merge == 2
					drop _merge
					replace sigla_uf_orig = sigla_uf if sigla_uf_orig == "BR"
					drop sigla_uf
					ren sigla_uf_orig sigla_uf
				}
				*
				
				foreach k of varlist _all {
					cap replace `k' = ""  if inlist(`k', "#NULO#", "#NULO", "#NE#", "#NE", "##VERIFICAR BASE 1994##")
				}
				*
				
				foreach k in tipo_eleicao cargo {
					clean_string `k'
				}
				
				limpa_tipo_eleicao	`ano'
				limpa_partido		`ano' sigla_partido
				
				merge m:1 id_municipio_tse using `diretorio'
				drop if _merge == 2
				drop _merge
				order id_municipio, b(id_municipio_tse)
				
				duplicates drop
				
				tempfile resultados_part_`estado'_`ano'
				save `resultados_part_`estado'_`ano''
				
			}
			
			//------------//
			// append
			//------------//
			
			use `resultados_part_AC_`ano'', clear
			foreach estado in `estados_`ano'_partido' {
				if "`estado'" != "AC" {
					append using `resultados_part_`estado'_`ano''
				}
			}
			*
			
			drop if ano == 2009 | ano == 2011
			
			compress
			
			save "output/resultados_partido_municipio_zona_`ano'.dta", replace
			
		}
	}
}
*
