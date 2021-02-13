
//----------------------------------------------------------------------------//
// build: candidatos
//----------------------------------------------------------------------------//

//------------------------//
// lista de estados
//------------------------//

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

//------------------------//
// loops
//------------------------//

foreach ano of numlist 1998(2)2020 {

	foreach estado in `estados_`ano'' {
		
		di "`ano'_`estado'_candidatos"
		
		cap import delimited "input/consulta_cand/consulta_cand_`ano'/consulta_cand_`ano'_`estado'.txt", delim(";") varn(nonames) stringcols(_all) clear
		cap import delimited "input/consulta_cand/consulta_cand_`ano'/consulta_cand_`ano'_`estado'.csv", delim(";") varn(nonames) stringcols(_all) clear
		
		if `ano' <= 2010 {
			
			keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v15 v17 v18 v19 v23 v24 v26 v27 v28 v31 v33 v35 v37 v38 v40 v43
			
			ren v3 ano
			ren v4 turno
			ren v5 tipo_eleicao
			ren v6 sigla_uf
			ren v7 id_municipio_tse
			ren v10 cargo
			ren v11 nome_candidato
			ren v12 sequencial_candidato
			ren v13 numero_candidato
			ren v14 cpf
			ren v15 nome_urna_candidato
			ren v17 situacao
			ren v18 numero_partido
			ren v19 sigla_partido
			ren v23 composicao
			ren v24 coligacao
			ren v26 ocupacao
			ren v27 data_nasc
			ren v28 titulo_eleitoral
			ren v31 genero
			ren v33 instrucao
			ren v35 estado_civil
			ren v37 nacionalidade
			ren v38 sigla_uf_nasc
			ren v40 municipio_nasc
			ren v43 resultado
			
		}
		else if `ano' == 2012 {
			
			keep v3 v4 v5 v6 v7 v10 v11 v12 v13 v14 v15 v17 v18 v19 v23 v24 v26 v27 v28 v31 v33 v35 v37 v38 v40 v43 v44
			
			ren v3 ano
			ren v4 turno
			ren v5 tipo_eleicao
			ren v6 sigla_uf
			ren v7 id_municipio_tse
			ren v10 cargo
			ren v11 nome_candidato
			ren v12 sequencial_candidato
			ren v13 numero_candidato
			ren v14 cpf
			ren v15 nome_urna_candidato
			ren v17 situacao
			ren v18 numero_partido
			ren v19 sigla_partido
			ren v23 composicao
			ren v24 coligacao
			ren v26 ocupacao
			ren v27 data_nasc
			ren v28 titulo_eleitoral
			ren v31 genero
			ren v33 instrucao
			ren v35 estado_civil
			ren v37 nacionalidade
			ren v38 sigla_uf_nasc
			ren v40 municipio_nasc
			ren v43 resultado
			ren v44 email
			
		}
		else if `ano' >= 2014 {
			
			keep v3 v6 v8 v11 v12 v15 v16 v17 v18 v19 v21 v22 v26 v28 v29 v32 v33 v35 v36 v38 v39 v41 v43 v45 v47 v49 v51 v54
			
			ren v3 ano
			ren v6 turno
			ren v8 tipo_eleicao
			ren v11 sigla_uf
			ren v12 id_municipio_tse
			ren v15 cargo
			ren v16 sequencial_candidato
			ren v17 numero_candidato
			ren v18 nome_candidato
			ren v19 nome_urna_candidato
			ren v21 cpf
			ren v22 email
			ren v26 situacao
			ren v28 numero_partido
			ren v29 sigla_partido
			ren v32 coligacao
			ren v33 composicao
			ren v35 nacionalidade
			ren v36 sigla_uf_nasc
			ren v38 municipio_nasc
			ren v39 data_nasc
			ren v41 titulo_eleitoral
			ren v43 genero
			ren v45 instrucao
			ren v47 estado_civil
			ren v49 raca
			ren v51 ocupacao
			ren v54 resultado
			
		}
		*
		
		if `ano' == 2020 drop in 1
		
		destring ano id_municipio_tse turno sequencial_candidato numero_candidato numero_partido, replace force
		replace sequencial_candidato = . if sequencial_candidato == -1
		
		//------------------//
		// limpa strings
		//------------------//
		
		cap replace email = ""  if email == "#NULO#"
		replace resultado = ""  if resultado == "#NULO#" | resultado == "#NE#"
		replace composicao = "" if composicao == "#NE#"
		replace coligacao = ""	if coligacao == "#NE#"
		
		foreach k in tipo_eleicao cargo situacao nacionalidade genero instrucao estado_civil raca ocupacao email resultado {
			cap clean_string `k'
		}
		foreach k in nome_candidato nome_urna_candidato municipio_nasc {
			cap replace `k' = ustrtitle(`k')
		}
		*
		
		limpa_tipo_eleicao `ano'
		limpa_partido `ano'
		limpa_instrucao
		limpa_estado_civil
		limpa_resultado
		
		replace genero = "" if genero == "nao divulgavel"
		replace genero = "" if genero == "nao informado"
		
		replace nacionalidade = "brasileira"	if nacionalidade == "brasileira nata"
		replace nacionalidade = ""				if nacionalidade == "nao divulgavel"
		replace nacionalidade = ""				if nacionalidade == "nao informado"
		
		cap replace raca = "" if raca == "sem informacao"
		cap replace raca = "" if raca == "nao divulgavel"
		
		//------------------//
		// limpa data_nasc
		//------------------//
		
		replace data_nasc = substr(data_nasc, 1, 4) + "1" + substr(data_nasc, 6, .) if strlen(data_nasc) == 8 & substr(data_nasc, 5, 1) == "0"
		if `ano' == 1996 {
			replace data_nasc = subinstr(data_nasc, "/", "", .)
			replace data_nasc = substr(data_nasc, 1, 4) + "19" + substr(data_nasc, 5, 6)
		}
		else if inlist(`ano', 2006, 2008, 2012, 2014, 2016, 2018, 2020) {
			replace data_nasc = subinstr(data_nasc, "/", "", .)
		}
		else if inlist(`ano', 2010) { // 2008, 
			gen aux_mes = ""
			replace aux_mes = "01" if substr(data_nasc, 4, 3) == "JAN"
			replace aux_mes = "02" if substr(data_nasc, 4, 3) == "FEB"
			replace aux_mes = "03" if substr(data_nasc, 4, 3) == "MAR"
			replace aux_mes = "04" if substr(data_nasc, 4, 3) == "APR"
			replace aux_mes = "05" if substr(data_nasc, 4, 3) == "MAY"
			replace aux_mes = "06" if substr(data_nasc, 4, 3) == "JUN"
			replace aux_mes = "07" if substr(data_nasc, 4, 3) == "JUL"
			replace aux_mes = "08" if substr(data_nasc, 4, 3) == "AUG"
			replace aux_mes = "09" if substr(data_nasc, 4, 3) == "SEP"
			replace aux_mes = "10" if substr(data_nasc, 4, 3) == "OCT"
			replace aux_mes = "11" if substr(data_nasc, 4, 3) == "NOV"
			replace aux_mes = "12" if substr(data_nasc, 4, 3) == "DEC"
			replace data_nasc = substr(data_nasc, 1, 2) + aux_mes + "19" + substr(data_nasc, 8, 9)
		}
		*
		
		replace data_nasc = substr(data_nasc, 5, 4) + "-" + substr(data_nasc, 3, 2) + "-" + substr(data_nasc, 1, 2)
		
		gen aux_data_nasc = date(data_nasc, "YMD")
		format aux_data_nasc %td
		gen idade = round((td(01oct`ano') - aux_data_nasc) / 365.25, 1)
		replace idade = . if idade < 15 | idade > 100
		order idade, a(data_nasc)
		drop aux_data_nasc
		
		cap drop aux*
		
		drop if	cargo != "1º suplente" & ///
				cargo != "1º suplente senador" & ///
				cargo != "2º suplente" & ///
				cargo != "2º suplente senador" & ///
				cargo != "deputado distrital" & ///
				cargo != "deputado estadual" & ///
				cargo != "deputado federal" & ///
				cargo != "presidente" & ///
				cargo != "governador" & ///
				cargo != "prefeito" & ///
				cargo != "senador" & ///
				cargo != "vereador" & ///
				cargo != "vice-governador" & ///
				cargo != "vice-prefeito"
		
		drop if cpf == ""
		
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
