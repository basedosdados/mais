
//----------------------------------------------------------------------------//
// build: partidos
//----------------------------------------------------------------------------//

//------------------------//
// lista de estados
//------------------------//

local estados_1990	AC AL AM AP BA    CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_1994	AC AL AM AP BA BR          GO MA    MS                            RR RS SC SE SP TO
local estados_1996	AC AL AM AP BA    CE    ES GO MA MG MS    PA PB PE PI       RN    RR RS    SE SP TO
local estados_1998	AC AL AM AP BA    CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2000	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2002	AC AL AM AP BA    CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2004	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2006	AC AL AM AP BA    CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2008	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2010	AC AL AM AP BA    CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2012	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2014	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2016	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2018	AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2020	AC AL AM AP BA    CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

//------------------------//
// loops
//------------------------//

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) case(preserve)
keep id_municipio id_municipio_tse
tempfile diretorio
save `diretorio'

foreach ano of numlist 1990 1994(2)2020 {

	foreach estado in `estados_`ano'' {
		
		cap import delimited "input/consulta_coligacao/CONSULTA_LEGENDA_`ano'/CONSULTA_LEGENDA_`ano'_`estado'.txt",     delim(";") varn(nonames) stringcols(_all) clear
		cap import delimited "input/consulta_coligacao/consulta_legendas_`ano'/CONSULTA_LEGENDA_`ano'_`estado'.txt",    delim(";") varn(nonames) stringcols(_all) clear
		cap import delimited "input/consulta_coligacao/consulta_legendas_`ano'/consulta_legendas_`ano'_`estado'.txt",   delim(";") varn(nonames) stringcols(_all) clear
		cap import delimited "input/consulta_coligacao/consulta_legendas_`ano'/consulta_legendas_`ano'_`estado'.csv",   delim(";") varn(nonames) stringcols(_all) clear
		cap import delimited "input/consulta_coligacao/consulta_coligacao_`ano'/consulta_coligacao_`ano'_`estado'.txt", delim(";") varn(nonames) stringcols(_all) clear
		cap import delimited "input/consulta_coligacao/consulta_coligacao_`ano'/consulta_coligacao_`ano'_`estado'.csv", delim(";") varn(nonames) stringcols(_all) clear
		
		if `ano' <= 2012 {
			
			keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v16 v18
			
			ren v3	ano
			ren v4	turno
			ren v5	tipo_eleicao
			ren v6	sigla_uf
			ren v7	id_municipio_tse
			ren v10	cargo
			ren v11	tipo_agremiacao
			ren v12	numero //_partido
			ren v13	sigla //_partido
			ren v14	nome //_partido
			ren v16	coligacao
			ren v18	sequencial_coligacao
			
		}
		else if `ano' >= 2014 {
			
			drop in 1
			
			keep v3 v5 v6 v10 v11 v14 v15 v16 v17 v18 v19 v20 
			
			ren v3	ano
			ren v5	tipo_eleicao
			ren v6	turno
			ren v10	sigla_uf
			ren v11	id_municipio_tse
			ren v14	cargo
			ren v15	tipo_agremiacao
			ren v16	numero
			ren v17	sigla
			ren v18	nome
			ren v19	sequencial_coligacao
			ren v20	coligacao
			
		}
		*
		
		destring ano turno id_municipio_tse numero sequencial_coligacao, replace force
		
		replace sequencial_coligacao = . if inlist(sequencial_coligacao, -3, -1)
		
		merge m:1 id_municipio_tse using `diretorio'
		drop if _merge == 2
		drop _merge
		order id_municipio, b(id_municipio_tse)
		
		//------------------//
		// limpa strings
		//------------------//
		
		replace coligacao = "" if coligacao == "#NE#" | coligacao == "#NULO#"
		
		foreach k in tipo_eleicao cargo tipo_agremiacao {
			cap clean_string `k'
		}
		foreach k in nome coligacao {
			cap replace `k' = ustrtitle(`k')
		}
		*
		
		limpa_tipo_eleicao `ano'
		limpa_partido `ano' sigla
		
		order ano turno tipo_eleicao
		
		tempfile partidos_`estado'_`ano'
		save `partidos_`estado'_`ano''
		
	}
	*
	
	//------------------//
	// append
	//------------------//
	
	use `partidos_AC_`ano'', clear
	foreach estado in `estados_`ano'' {
		if "`estado'" != "AC" {
			append using `partidos_`estado'_`ano''
		}
	}
	*
	
	compress
	
	save "output/partidos_`ano'.dta", replace
	
}
*
