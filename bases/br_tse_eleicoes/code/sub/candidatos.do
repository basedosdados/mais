
//----------------------------------------------------------------------------//
// build: candidatos
//----------------------------------------------------------------------------//

//------------------------//
// lista de estados
//------------------------//

local estados_1994	AC AL AM AP BA BR          GO MA    MS             PI             RR RS    SE SP TO
local estados_1996	AC AL AM AP BA    CE    ES GO MA MG MS    PA PB PE PI       RN    RR RS    SE SP TO
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

foreach ano of numlist 2000 { // 1994(2)2022 {
	
	foreach estado in `estados_`ano'' {
		
		di "`ano'_`estado'_candidatos"
		
		cap import delimited "input/consulta_cand/consulta_cand_`ano'/consulta_cand_`ano'_`estado'.txt", ///
			delim(";") varn(nonames) stripquotes(yes) bindquotes(nobind) stringcols(_all) clear
		cap import delimited "input/consulta_cand/consulta_cand_`ano'/consulta_cand_`ano'_`estado'.csv", ///
			delim(";") varn(nonames) stripquotes(yes) bindquotes(nobind) stringcols(_all) clear
		
		if `ano' == 1994 & "`estado'" == "BR" {
			
			keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v15 v17 v18 v19 v27 v28 v29 v32 v34 v36 v38 v39 v41 v44
			
			ren v3 ano
			ren v4 turno
			ren v5 tipo_eleicao
			ren v6 sigla_uf
			ren v7 id_municipio_tse
			ren v10 cargo
			ren v11 nome
			ren v12 sequencial
			ren v13 numero
			ren v14 cpf
			ren v15 nome_urna
			ren v17 situacao
			ren v18 numero_partido
			ren v19 sigla_partido
			//ren v24 composicao
			//ren v25 coligacao
			ren v27 ocupacao
			ren v28 data_nascimento
			ren v29 titulo_eleitoral
			ren v32 genero
			ren v34 instrucao
			ren v36 estado_civil
			ren v38 nacionalidade
			ren v39 sigla_uf_nascimento
			ren v41 municipio_nascimento
			ren v44 resultado
			
		}
		else if (`ano' <= 1998 | (`ano' >= 2002 & `ano' <= 2006) | `ano' == 2010) & !(`ano' == 1994 & "`estado'" == "BR") {
			
			keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v15 v17 v18 v19 v26 v27 v28 v31 v33 v35 v37 v38 v40 v43
			
			ren v3 ano
			ren v4 turno
			ren v5 tipo_eleicao
			ren v6 sigla_uf
			ren v7 id_municipio_tse
			ren v10 cargo
			ren v11 nome
			ren v12 sequencial
			ren v13 numero
			ren v14 cpf
			ren v15 nome_urna
			ren v17 situacao
			ren v18 numero_partido
			ren v19 sigla_partido
			//ren v23 composicao
			//ren v24 coligacao
			ren v26 ocupacao
			ren v27 data_nascimento
			ren v28 titulo_eleitoral
			ren v31 genero
			ren v33 instrucao
			ren v35 estado_civil
			ren v37 nacionalidade
			ren v38 sigla_uf_nascimento
			ren v40 municipio_nascimento
			ren v43 resultado
			
		}
		else if `ano' == 2000 {
			
			cap confirm variable v44
			if !_rc {	// if exists
				
				cap confirm variable v45
				if !_rc {	// if exists
					
					preserve
						
						//--------------------//
						// linhas corretas
						//--------------------//
						
						keep if v44 == "" & v45 == ""
						
						keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v15 v17 v18 v19 v26 v27 v28 v31 v33 v35 v37 v38 v40 v43
						
						ren v3 ano
						ren v4 turno
						ren v5 tipo_eleicao
						ren v6 sigla_uf
						ren v7 id_municipio_tse
						ren v10 cargo
						ren v11 nome
						ren v12 sequencial
						ren v13 numero
						ren v14 cpf
						ren v15 nome_urna
						ren v17 situacao
						ren v18 numero_partido
						ren v19 sigla_partido
						//ren v23 composicao
						//ren v24 coligacao
						ren v26 ocupacao
						ren v27 data_nascimento
						ren v28 titulo_eleitoral
						ren v31 genero
						ren v33 instrucao
						ren v35 estado_civil
						ren v37 nacionalidade
						ren v38 sigla_uf_nascimento
						ren v40 municipio_nascimento
						ren v43 resultado
						
						tempfile corretas
						save `corretas'
					
					restore
					preserve
						
						//--------------------//
						// linhas erradas I
						//--------------------//
						
						keep if v44 != "" & v45 == "" //& !inlist(v14, "69254800082")
						
						keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v16 v18 v19 v20 v27 v28 v29 v32 v34 v36 v38 v39 v41 v44
						
						ren v3 ano
						ren v4 turno
						ren v5 tipo_eleicao
						ren v6 sigla_uf
						ren v7 id_municipio_tse
						ren v10 cargo
						ren v11 nome
						ren v12 sequencial
						ren v13 numero
						ren v14 cpf
						ren v16 nome_urna
						ren v18 situacao
						ren v19 numero_partido
						ren v20 sigla_partido
						//ren v24 composicao
						//ren v25 coligacao
						ren v27 ocupacao
						ren v28 data_nascimento
						ren v29 titulo_eleitoral
						ren v32 genero
						ren v34 instrucao
						ren v36 estado_civil
						ren v38 nacionalidade
						ren v39 sigla_uf_nascimento
						ren v41 municipio_nascimento
						ren v44 resultado
						
						tempfile erradas_I
						save `erradas_I'
						
					restore
					preserve
						
						//--------------------//
						// linhas erradas II
						//--------------------//
						
						keep if v44 != "" & v45 != "" & usubstr(v45, 1, 8) != "CASSAÇÃO"
						
						keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v16 v19 v20 v21 v28 v29 v30 v33 v35 v37 v39 v40 v42 v45
						
						ren v3 ano
						ren v4 turno
						ren v5 tipo_eleicao
						ren v6 sigla_uf
						ren v7 id_municipio_tse
						ren v10 cargo
						ren v11 nome
						ren v12 sequencial
						ren v13 numero
						ren v14 cpf
						ren v16 nome_urna
						ren v19 situacao
						ren v20 numero_partido
						ren v21 sigla_partido
						//ren v25 composicao
						//ren v26 coligacao
						ren v28 ocupacao
						ren v29 data_nascimento
						ren v30 titulo_eleitoral
						ren v33 genero
						ren v35 instrucao
						ren v37 estado_civil
						ren v39 nacionalidade
						ren v40 sigla_uf_nascimento
						ren v42 municipio_nascimento
						ren v45 resultado
						
						tempfile erradas_II
						save `erradas_II'
						
					restore
					preserve
						
						//--------------------//
						// linhas erradas III
						//--------------------//
						
						keep if v44 != "" & v45 != "" & usubstr(v45, 1, 8) == "CASSAÇÃO"
						
						keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v15 v17 v18 v19 v26 v27 v28 v31 v33 v35 v37 v38 v40 v43
						
						ren v3 ano
						ren v4 turno
						ren v5 tipo_eleicao
						ren v6 sigla_uf
						ren v7 id_municipio_tse
						ren v10 cargo
						ren v11 nome
						ren v12 sequencial
						ren v13 numero
						ren v14 cpf
						ren v15 nome_urna
						ren v17 situacao
						ren v18 numero_partido
						ren v19 sigla_partido
						//ren v23 composicao
						//ren v24 coligacao
						ren v26 ocupacao
						ren v27 data_nascimento
						ren v28 titulo_eleitoral
						ren v31 genero
						ren v33 instrucao
						ren v35 estado_civil
						ren v37 nacionalidade
						ren v38 sigla_uf_nascimento
						ren v40 municipio_nascimento
						ren v43 resultado
						
						tempfile erradas_III
						save `erradas_III'
						
					restore
					
					use `corretas', clear
					append using `erradas_I'
					append using `erradas_II'
					append using `erradas_III'
					
				}
				else {
					
					preserve
						
						//--------------------//
						// linhas corretas
						//--------------------//
						
						keep if v44 == ""
						
						keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v15 v17 v18 v19 v26 v27 v28 v31 v33 v35 v37 v38 v40 v43
						
						ren v3 ano
						ren v4 turno
						ren v5 tipo_eleicao
						ren v6 sigla_uf
						ren v7 id_municipio_tse
						ren v10 cargo
						ren v11 nome
						ren v12 sequencial
						ren v13 numero
						ren v14 cpf
						ren v15 nome_urna
						ren v17 situacao
						ren v18 numero_partido
						ren v19 sigla_partido
						//ren v23 composicao
						//ren v24 coligacao
						ren v26 ocupacao
						ren v27 data_nascimento
						ren v28 titulo_eleitoral
						ren v31 genero
						ren v33 instrucao
						ren v35 estado_civil
						ren v37 nacionalidade
						ren v38 sigla_uf_nascimento
						ren v40 municipio_nascimento
						ren v43 resultado
						
						tempfile corretas
						save `corretas'
					
					restore
					preserve
						
						//--------------------//
						// linhas erradas I
						//--------------------//
						
						keep if v44 != "" & !inlist(v14, "51358891168")
						
						keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v16 v18 v19 v20 v27 v28 v29 v32 v34 v36 v38 v39 v41 v44
						
						ren v3 ano
						ren v4 turno
						ren v5 tipo_eleicao
						ren v6 sigla_uf
						ren v7 id_municipio_tse
						ren v10 cargo
						ren v11 nome
						ren v12 sequencial
						ren v13 numero
						ren v14 cpf
						ren v16 nome_urna
						ren v18 situacao
						ren v19 numero_partido
						ren v20 sigla_partido
						//ren v24 composicao
						//ren v25 coligacao
						ren v27 ocupacao
						ren v28 data_nascimento
						ren v29 titulo_eleitoral
						ren v32 genero
						ren v34 instrucao
						ren v36 estado_civil
						ren v38 nacionalidade
						ren v39 sigla_uf_nascimento
						ren v41 municipio_nascimento
						ren v44 resultado
						
						tempfile erradas_I
						save `erradas_I'
						
					restore
					preserve
						
						//--------------------//
						// linhas erradas II
						//--------------------//
						
						keep if v44 != "" & inlist(v14, "51358891168")
						
						keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v15 v17 v18 v19 v26 v27 v28 v31 v33 v35 v37 v38 v40 v44
						
						ren v3 ano
						ren v4 turno
						ren v5 tipo_eleicao
						ren v6 sigla_uf
						ren v7 id_municipio_tse
						ren v10 cargo
						ren v11 nome
						ren v12 sequencial
						ren v13 numero
						ren v14 cpf
						ren v15 nome_urna
						ren v17 situacao
						ren v18 numero_partido
						ren v19 sigla_partido
						//ren v23 composicao
						//ren v24 coligacao
						ren v26 ocupacao
						ren v27 data_nascimento
						ren v28 titulo_eleitoral
						ren v31 genero
						ren v33 instrucao
						ren v35 estado_civil
						ren v37 nacionalidade
						ren v38 sigla_uf_nascimento
						ren v40 municipio_nascimento
						ren v44 resultado
						
						tempfile erradas_II
						save `erradas_II'
						
					restore
					
					use `corretas', clear
					append using `erradas_I'
					append using `erradas_II'
					
				}
			}
			else {
				
				keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v15 v17 v18 v19 v26 v27 v28 v31 v33 v35 v37 v38 v40 v43
				
				ren v3 ano
				ren v4 turno
				ren v5 tipo_eleicao
				ren v6 sigla_uf
				ren v7 id_municipio_tse
				ren v10 cargo
				ren v11 nome
				ren v12 sequencial
				ren v13 numero
				ren v14 cpf
				ren v15 nome_urna
				ren v17 situacao
				ren v18 numero_partido
				ren v19 sigla_partido
				//ren v23 composicao
				//ren v24 coligacao
				ren v26 ocupacao
				ren v27 data_nascimento
				ren v28 titulo_eleitoral
				ren v31 genero
				ren v33 instrucao
				ren v35 estado_civil
				ren v37 nacionalidade
				ren v38 sigla_uf_nascimento
				ren v40 municipio_nascimento
				ren v43 resultado
				
			}
			
		}
		else if `ano' == 2008 {
			
			cap confirm variable v44
			if !_rc {	// if exists
				
				cap confirm variable v45
				if !_rc {	// if exists
					
					preserve
						
						//--------------------//
						// linhas corretas
						//--------------------//
						
						keep if v44 == "" & v45 == ""
						
						keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v15 v17 v18 v19 v26 v27 v28 v31 v33 v35 v37 v38 v40 v43
						
						ren v3 ano
						ren v4 turno
						ren v5 tipo_eleicao
						ren v6 sigla_uf
						ren v7 id_municipio_tse
						ren v10 cargo
						ren v11 nome
						ren v12 sequencial
						ren v13 numero
						ren v14 cpf
						ren v15 nome_urna
						ren v17 situacao
						ren v18 numero_partido
						ren v19 sigla_partido
						//ren v23 composicao
						//ren v24 coligacao
						ren v26 ocupacao
						ren v27 data_nascimento
						ren v28 titulo_eleitoral
						ren v31 genero
						ren v33 instrucao
						ren v35 estado_civil
						ren v37 nacionalidade
						ren v38 sigla_uf_nascimento
						ren v40 municipio_nascimento
						ren v43 resultado
						
						tempfile corretas
						save `corretas'
					
					restore
					preserve
						
						//--------------------//
						// linhas erradas I
						//--------------------//
						
						keep if v44 != "" & v45 == "" & !inlist(v14, "69254800082")
						
						keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v16 v18 v19 v20 v27 v28 v29 v32 v34 v36 v38 v39 v41 v44
						
						ren v3 ano
						ren v4 turno
						ren v5 tipo_eleicao
						ren v6 sigla_uf
						ren v7 id_municipio_tse
						ren v10 cargo
						ren v11 nome
						ren v12 sequencial
						ren v13 numero
						ren v14 cpf
						ren v16 nome_urna
						ren v18 situacao
						ren v19 numero_partido
						ren v20 sigla_partido
						//ren v24 composicao
						//ren v25 coligacao
						ren v27 ocupacao
						ren v28 data_nascimento
						ren v29 titulo_eleitoral
						ren v32 genero
						ren v34 instrucao
						ren v36 estado_civil
						ren v38 nacionalidade
						ren v39 sigla_uf_nascimento
						ren v41 municipio_nascimento
						ren v44 resultado
						
						tempfile erradas_I
						save `erradas_I'
						
					restore
					preserve
						
						//--------------------//
						// linhas erradas II
						//--------------------//
						
						keep if v44 != "" & v45 == "" & inlist(v14, "69254800082")
						
						keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v15 v17 v18 v19 v26 v27 v28 v31 v33 v35 v37 v38 v40 v44
						
						ren v3 ano
						ren v4 turno
						ren v5 tipo_eleicao
						ren v6 sigla_uf
						ren v7 id_municipio_tse
						ren v10 cargo
						ren v11 nome
						ren v12 sequencial
						ren v13 numero
						ren v14 cpf
						ren v15 nome_urna
						ren v17 situacao
						ren v18 numero_partido
						ren v19 sigla_partido
						//ren v23 composicao
						//ren v24 coligacao
						ren v26 ocupacao
						ren v27 data_nascimento
						ren v28 titulo_eleitoral
						ren v31 genero
						ren v33 instrucao
						ren v35 estado_civil
						ren v37 nacionalidade
						ren v38 sigla_uf_nascimento
						ren v40 municipio_nascimento
						ren v44 resultado
						
						tempfile erradas_II
						save `erradas_II'
						
					restore
					preserve
						
						//--------------------//
						// linhas erradas III
						//--------------------//
						
						keep if v44 != "" & v45 != ""
						
						keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v16 v19 v20 v21 v28 v29 v30 v33 v35 v37 v39 v40 v42 v45
						
						ren v3 ano
						ren v4 turno
						ren v5 tipo_eleicao
						ren v6 sigla_uf
						ren v7 id_municipio_tse
						ren v10 cargo
						ren v11 nome
						ren v12 sequencial
						ren v13 numero
						ren v14 cpf
						ren v16 nome_urna
						ren v19 situacao
						ren v20 numero_partido
						ren v21 sigla_partido
						//ren v25 composicao
						//ren v26 coligacao
						ren v28 ocupacao
						ren v29 data_nascimento
						ren v30 titulo_eleitoral
						ren v33 genero
						ren v35 instrucao
						ren v37 estado_civil
						ren v39 nacionalidade
						ren v40 sigla_uf_nascimento
						ren v42 municipio_nascimento
						ren v45 resultado
						
						tempfile erradas_III
						save `erradas_III'
						
					restore
					
					use `corretas', clear
					append using `erradas_I'
					append using `erradas_II'
					append using `erradas_III'
					
				}
				else {
					
					preserve
						
						//--------------------//
						// linhas corretas
						//--------------------//
						
						keep if v44 == ""
						
						keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v15 v17 v18 v19 v26 v27 v28 v31 v33 v35 v37 v38 v40 v43
						
						ren v3 ano
						ren v4 turno
						ren v5 tipo_eleicao
						ren v6 sigla_uf
						ren v7 id_municipio_tse
						ren v10 cargo
						ren v11 nome
						ren v12 sequencial
						ren v13 numero
						ren v14 cpf
						ren v15 nome_urna
						ren v17 situacao
						ren v18 numero_partido
						ren v19 sigla_partido
						//ren v23 composicao
						//ren v24 coligacao
						ren v26 ocupacao
						ren v27 data_nascimento
						ren v28 titulo_eleitoral
						ren v31 genero
						ren v33 instrucao
						ren v35 estado_civil
						ren v37 nacionalidade
						ren v38 sigla_uf_nascimento
						ren v40 municipio_nascimento
						ren v43 resultado
						
						tempfile corretas
						save `corretas'
					
					restore
					preserve
						
						//--------------------//
						// linhas erradas I
						//--------------------//
						
						keep if v44 != "" & !inlist(v14, "31988130506")
						
						keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v16 v18 v19 v20 v27 v28 v29 v32 v34 v36 v38 v39 v41 v44
						
						ren v3 ano
						ren v4 turno
						ren v5 tipo_eleicao
						ren v6 sigla_uf
						ren v7 id_municipio_tse
						ren v10 cargo
						ren v11 nome
						ren v12 sequencial
						ren v13 numero
						ren v14 cpf
						ren v16 nome_urna
						ren v18 situacao
						ren v19 numero_partido
						ren v20 sigla_partido
						//ren v24 composicao
						//ren v25 coligacao
						ren v27 ocupacao
						ren v28 data_nascimento
						ren v29 titulo_eleitoral
						ren v32 genero
						ren v34 instrucao
						ren v36 estado_civil
						ren v38 nacionalidade
						ren v39 sigla_uf_nascimento
						ren v41 municipio_nascimento
						ren v44 resultado
						
						tempfile erradas_I
						save `erradas_I'
						
					restore
					preserve
						
						//--------------------//
						// linhas erradas II
						//--------------------//
						
						keep if v44 != "" & inlist(v14, "31988130506")
						
						keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v15 v17 v18 v19 v26 v27 v28 v31 v33 v35 v37 v38 v40 v44
						
						ren v3 ano
						ren v4 turno
						ren v5 tipo_eleicao
						ren v6 sigla_uf
						ren v7 id_municipio_tse
						ren v10 cargo
						ren v11 nome
						ren v12 sequencial
						ren v13 numero
						ren v14 cpf
						ren v15 nome_urna
						ren v17 situacao
						ren v18 numero_partido
						ren v19 sigla_partido
						//ren v23 composicao
						//ren v24 coligacao
						ren v26 ocupacao
						ren v27 data_nascimento
						ren v28 titulo_eleitoral
						ren v31 genero
						ren v33 instrucao
						ren v35 estado_civil
						ren v37 nacionalidade
						ren v38 sigla_uf_nascimento
						ren v40 municipio_nascimento
						ren v44 resultado
						
						tempfile erradas_II
						save `erradas_II'
						
					restore
					
					use `corretas', clear
					append using `erradas_I'
					append using `erradas_II'
					
				}
			}
			else {
				
				keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v15 v17 v18 v19 v26 v27 v28 v31 v33 v35 v37 v38 v40 v43
				
				ren v3 ano
				ren v4 turno
				ren v5 tipo_eleicao
				ren v6 sigla_uf
				ren v7 id_municipio_tse
				ren v10 cargo
				ren v11 nome
				ren v12 sequencial
				ren v13 numero
				ren v14 cpf
				ren v15 nome_urna
				ren v17 situacao
				ren v18 numero_partido
				ren v19 sigla_partido
				//ren v23 composicao
				//ren v24 coligacao
				ren v26 ocupacao
				ren v27 data_nascimento
				ren v28 titulo_eleitoral
				ren v31 genero
				ren v33 instrucao
				ren v35 estado_civil
				ren v37 nacionalidade
				ren v38 sigla_uf_nascimento
				ren v40 municipio_nascimento
				ren v43 resultado
				
			}
			
		}
		else if `ano' == 2012 {
			
			keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v15 v17 v18 v19 v26 v27 v28 v31 v33 v35 v37 v38 v40 v43 v44
			
			ren v3 ano
			ren v4 turno
			ren v5 tipo_eleicao
			ren v6 sigla_uf
			ren v7 id_municipio_tse
			ren v10 cargo
			ren v11 nome
			ren v12 sequencial
			ren v13 numero
			ren v14 cpf
			ren v15 nome_urna
			ren v17 situacao
			ren v18 numero_partido
			ren v19 sigla_partido
			//ren v23 composicao
			//ren v24 coligacao
			ren v26 ocupacao
			ren v27 data_nascimento
			ren v28 titulo_eleitoral
			ren v31 genero
			ren v33 instrucao
			ren v35 estado_civil
			ren v37 nacionalidade
			ren v38 sigla_uf_nascimento
			ren v40 municipio_nascimento
			ren v43 resultado
			ren v44 email
			
		}
		else if `ano' >= 2014 & `ano' <= 2020 {
			
			keep v3 v6 v8 v11 v12 v15 v16 v17 v18 v19 v21 v22 v26 v28 v29 v35 v36 v38 v39 v41 v43 v45 v47 v49 v51 v54
			
			ren v3 ano
			ren v6 turno
			ren v8 tipo_eleicao
			ren v11 sigla_uf
			ren v12 id_municipio_tse
			ren v15 cargo
			ren v16 sequencial
			ren v17 numero
			ren v18 nome
			ren v19 nome_urna
			ren v21 cpf
			ren v22 email
			ren v26 situacao
			ren v28 numero_partido
			ren v29 sigla_partido
			//ren v32 coligacao
			//ren v33 composicao
			ren v35 nacionalidade
			ren v36 sigla_uf_nascimento
			ren v38 municipio_nascimento
			ren v39 data_nascimento
			ren v41 titulo_eleitoral
			ren v43 genero
			ren v45 instrucao
			ren v47 estado_civil
			ren v49 raca
			ren v51 ocupacao
			ren v54 resultado
			
		}
		else if `ano' >= 2022 {
			
			keep v3 v6 v8 v11 v12 v15 v16 v17 v18 v19 v21 v22 v26 v28 v29 v39 v40 v42 v43 v45 v47 v49 v51 v53 v55 v58
			
			ren v3  ano
			ren v6  turno
			ren v8  tipo_eleicao
			ren v11 sigla_uf
			ren v12 id_municipio_tse
			ren v15 cargo
			ren v16 sequencial
			ren v17 numero
			ren v18 nome
			ren v19 nome_urna
			ren v21 cpf
			ren v22 email
			ren v26 situacao
			ren v28 numero_partido
			ren v29 sigla_partido
			//ren v32 coligacao
			//ren v33 composicao
			ren v39 nacionalidade
			ren v40 sigla_uf_nascimento
			ren v42 municipio_nascimento
			ren v43 data_nascimento
			ren v45 titulo_eleitoral
			ren v47 genero
			ren v49 instrucao
			ren v51 estado_civil
			ren v53 raca
			ren v55 ocupacao
			ren v58 resultado
			
		}
		*
		
		if `ano' >= 2020 drop in 1
		
		//------------------//
		// limpa strings
		//------------------//
		
		destring ano turno id_municipio_tse, replace force
		replace sequencial = "" if sequencial == "-1"
		
		merge m:1 id_municipio_tse using `municipio'
		drop if _merge == 2
		drop _merge
		order id_municipio, b(id_municipio_tse)
		
		foreach k of varlist _all {
			cap replace `k' = ""  if inlist(`k', "#NULO#", "#NULO", "#NE#", "#NE", "##VERIFICAR BASE 1994##", "NÃO DIVULGÁVEL")
		}
		*
		
		foreach k in tipo_eleicao cargo situacao nacionalidade genero instrucao estado_civil raca ocupacao email resultado {
			cap clean_string `k'
		}
		foreach k in nome nome_urna municipio_nascimento {
			cap replace `k' = ustrtitle(`k')
		}
		*
		
		limpa_tipo_eleicao	`ano'
		limpa_partido		`ano' sigla_partido
		limpa_candidato
		limpa_instrucao
		limpa_estado_civil
		limpa_resultado
		
		replace cargo = "vice-presidente" 		if cargo == "vice presidente"
		replace cargo = "vice-prefeito"   		if cargo == "vice prefeito"
		
		replace genero = "" 					if genero == "nao divulgavel"
		replace genero = "" 					if genero == "nao informado"
		
		replace nacionalidade = "brasileira"	if nacionalidade == "brasileira nata"
		replace nacionalidade = ""				if nacionalidade == "nao divulgavel"
		replace nacionalidade = ""				if nacionalidade == "nao informado"
		
		cap replace raca = "" 					if raca == "sem informacao"
		cap replace raca = "" 					if raca == "nao divulgavel"
		
		replace resultado = "" 					if inlist(resultado, "-1", "1", "4")
		
		replace sigla_uf = "" 					if cargo == "presidente" | cargo == "vice-presidente"
		
		//------------------//
		// limpa data_nascimento
		//------------------//
		
		replace data_nascimento = substr(data_nascimento, 1, 4) + "1" + substr(data_nascimento, 6, .) if strlen(data_nascimento) == 8 & substr(data_nascimento, 5, 1) == "0"
		if `ano' == 1994 {
			replace data_nascimento = subinstr(data_nascimento, "/", "", .)
			replace data_nascimento = substr(data_nascimento, 1, 4) + "19" + substr(data_nascimento, 5, 6)
		}
		if `ano' == 1996 {
			replace data_nascimento = subinstr(data_nascimento, "/", "", .)
			replace data_nascimento = substr(data_nascimento, 1, 4) + "19" + substr(data_nascimento, 5, 6)
		}
		else if inlist(`ano', 2006, 2008, 2012, 2014, 2016, 2018, 2020, 2022) {
			replace data_nascimento = subinstr(data_nascimento, "/", "", .)
		}
		else if inlist(`ano', 2010) {
			gen aux_mes = ""
			replace aux_mes = "01" if substr(data_nascimento, 4, 3) == "JAN"
			replace aux_mes = "02" if substr(data_nascimento, 4, 3) == "FEB"
			replace aux_mes = "03" if substr(data_nascimento, 4, 3) == "MAR"
			replace aux_mes = "04" if substr(data_nascimento, 4, 3) == "APR"
			replace aux_mes = "05" if substr(data_nascimento, 4, 3) == "MAY"
			replace aux_mes = "06" if substr(data_nascimento, 4, 3) == "JUN"
			replace aux_mes = "07" if substr(data_nascimento, 4, 3) == "JUL"
			replace aux_mes = "08" if substr(data_nascimento, 4, 3) == "AUG"
			replace aux_mes = "09" if substr(data_nascimento, 4, 3) == "SEP"
			replace aux_mes = "10" if substr(data_nascimento, 4, 3) == "OCT"
			replace aux_mes = "11" if substr(data_nascimento, 4, 3) == "NOV"
			replace aux_mes = "12" if substr(data_nascimento, 4, 3) == "DEC"
			replace data_nascimento = substr(data_nascimento, 1, 2) + aux_mes + "19" + substr(data_nascimento, 8, 9)
		}
		*
		
		replace data_nascimento = substr(data_nascimento, 5, 4) + "-" + substr(data_nascimento, 3, 2) + "-" + substr(data_nascimento, 1, 2)
		
		replace data_nascimento = "" if real(substr(data_nascimento, 1, 4)) < 1900
		
		gen aux_data_nascimento = date(data_nascimento, "YMD")
		format aux_data_nascimento %td
		gen idade = round((td(01oct`ano') - aux_data_nascimento) / 365.25, 1)
		replace idade = . if idade < 15 | idade > 100
		order idade, a(data_nascimento)
		drop aux_data_nascimento
		
		cap drop aux*
		
		//------------------//
		// ajustes e salva
		//------------------//
		
		drop if ano == .
		drop if tipo_eleicao == "plebiscito"
		
		duplicates drop
		
		tempfile candidatos_`estado'_`ano'
		save `candidatos_`estado'_`ano''
		
	}
	*
	
	//------------------//
	// append
	//------------------//
	
	use `candidatos_AC_`ano'', clear
	foreach estado in `estados_`ano'' {
		if "`estado'" != "AC" {
			append using `candidatos_`estado'_`ano''
		}
	}
	*
	
	compress
	
	save "output/candidatos_`ano'.dta", replace
	
}
*
