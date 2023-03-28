
//----------------------------------------------------------------------------//
// build: candidatos
//----------------------------------------------------------------------------//

//------------------------//
// lista de estados
//------------------------//

local estados_1994	AC AL AM AP BA          GO MA    MS                         RO RR RS SC SE SP TO
local estados_1996	AC AL AM AP BA CE    ES GO MA MG MS    PA PB PE PI       RN    RR RS    SE SP TO
local estados_1998	AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2000	AC AL AM AP BA CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2002	AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2004	AC AL AM AP BA CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2006	AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2008	AC AL AM AP BA CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2010	AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2012	AC AL AM AP BA CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2014	AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2016	AC AL AM AP BA CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2018	AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2020	AC AL AM AP BA CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2022	AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

//------------------------//
// loops
//------------------------//

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) encoding("utf-8")
keep id_municipio id_municipio_tse
tempfile diretorio
save `diretorio'

foreach ano of numlist 1994(2)2022 {
	
	foreach estado in `estados_`ano'' {
		
		di "`ano'_`estado'_candidatos"
		
		cap import delimited using "input/consulta_vagas/consulta_vagas_`ano'/consulta_vagas_`ano'_`estado'.txt", delim(";") varn(nonames) stringcols(_all) clear
		cap import delimited using "input/consulta_vagas/consulta_vagas_`ano'/consulta_vagas_`ano'_`estado'.csv", delim(";") varn(nonames) stringcols(_all) clear
		
		if `ano' <= 2012 {

			keep v3 v4 v5 v6 v9 v10
			
			ren v3	ano
			ren v4	tipo_eleicao
			ren v5	sigla_uf
			ren v6	id_municipio_tse
			ren v9	cargo
			ren v10	vagas
		
		}
		else if `ano' >= 2014 {
			
			drop in 1
			
			keep v3 v5 v10 v11 v14 v15
			
			ren v3	ano
			ren v5	tipo_eleicao
			ren v10	sigla_uf
			ren v11	id_municipio_tse
			ren v14	cargo
			ren v15	vagas
			
		}
		*
		
		destring ano id_municipio_tse vagas, replace force
		
		//------------------//
		// limpa strings
		//------------------//
		
		foreach k in tipo_eleicao cargo {
			cap clean_string `k'
		}
		*
		
		limpa_tipo_eleicao `ano'
		
		drop if mod(ano, 2) > 0
		
		merge m:1 id_municipio_tse using `diretorio'
		drop if _merge == 2
		drop _merge
		order id_municipio, b(id_municipio_tse)
		
		duplicates drop
		
		tempfile vagas_`estado'_`ano'
		save `vagas_`estado'_`ano''
		
	}
	*
	
	//------------------//
	// append
	//------------------//
	
	use `vagas_AC_`ano'', clear
	foreach estado in `estados_`ano'' {
		if "`estado'" != "AC" {
			append using `vagas_`estado'_`ano''
		}
	}
	*
	
	compress
	
	save "output/vagas_`ano'.dta", replace
	
}
*
