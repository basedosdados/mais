
//----------------------------------------------------------------------------//
// build: bens declarados
//----------------------------------------------------------------------------//

foreach ano of numlist 2006(2)2020 {
	
	if mod(`ano', 4) == 0 local estados AC AL AM AP BA CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
	if mod(`ano', 4) == 2 local estados AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
	
	foreach estado in `estados' {
		
		cap import delimited "input/bem_candidato/bem_candidato_`ano'/bem_candidato_`ano'_`estado'.txt", clear delim(";") varnames(nonames) stringc(_all)
		cap import delimited "input/bem_candidato/bem_candidato_`ano'/bem_candidato_`ano'_`estado'.csv", clear delim(";") varnames(nonames) stringc(_all)
		
		if `ano' <= 2012 {
		
			keep v3 v4 v5 v6 v9 v10
			
			ren v3	ano
			ren v4	tipo_eleicao
			ren v5	sigla_uf
			ren v6	sequencial_candidato
			ren v9	descricao_item
			ren v10	valor_item
			
			foreach k in tipo_eleicao {
				cap clean_string `k'
			}
			*
			
			limpa_tipo_eleicao `ano'
			
			replace descricao_item = "" if descricao_item == "#NULO#"
			replace valor_item = subinstr(valor_item, ",", ".", .)
			
			destring ano sequencial_candidato valor_item, replace force
			
			gen id_tipo_item = .
			gen tipo_item = ""
			
		}
		if `ano' >= 2014 {
			
			drop in 1
			
			keep v3 v5 v9 v12 v14 v15 v16 v17
			
			ren v3	ano
			ren v5	tipo_eleicao
			ren v9	sigla_uf
			ren v12	sequencial_candidato
			ren v14	id_tipo_item
			ren v15	tipo_item
			ren v16	descricao_item
			ren v17	valor_item
			
			clean_string tipo_eleicao
			limpa_tipo_eleicao `ano'
			
			replace descricao_item = "" if descricao_item == "#NULO#"
			
			replace valor_item = subinstr(valor_item, ",", ".", .)
			destring ano sequencial_candidato id_tipo_item valor_item, replace force
			
		}
		*
		
		drop if ano == .	// casos de leitura problematica do csv
		
		compress
		
		tempfile bens_`ano'_`estado'
		save `bens_`ano'_`estado''
		
	}
	*
	
	use `bens_`ano'_AC', clear
	foreach estado in `estados' {
		if "`estado'" != "AC" {
			qui append using `bens_`ano'_`estado''
		}
	}
	*
	
	order ano tipo_eleicao sigla_uf sequencial_candidato id_tipo_item tipo_item descricao_item valor_item
	
	save "output/bens_candidato_`ano'.dta", replace
	
}
*


//----------------------------------------------------------------------------//
// build: prestacao de contas
//----------------------------------------------------------------------------//

//---------------------------------------------//
// receita candidato
//---------------------------------------------//

foreach ano of numlist 2002(2)2020 {

	if `ano' == 2002 {
		
		import delimited "input/prestacao_contas/prestacao_contas_2002/2002/Candidato/Receita/ReceitaCandidato.csv", clear ///
			delim(";") varnames(nonames) stringc(_all)
		
		drop in 1
		
		ren v1	sequencial_candidato
		ren v2	sigla_uf
		ren v3	sigla_partido
		ren v4	cargo
		ren v5	nome_candidato
		ren v6	numero_candidato
		ren v7	data_receita
		ren v8	cpf_cnpj_doador
		ren v9	sigla_uf_doador
		ren v10	nome_doador
		ren v11	valor_receita
		ren v12	tipo_receita
		
		foreach k in sigla_uf sigla_uf_doador {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist *_doador* {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist cargo tipo_receita {
			clean_string `var'
		}
		*
		
		foreach k in receita {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_receita = subinstr(valor_receita, ",", ".", .)
		
		destring numero_candidato*, replace force
		
	}
	if `ano' == 2004 {
		
		import delimited "input/prestacao_contas/prestacao_contas_2004/2004/Candidato/Receita/ReceitaCandidato.csv", ///
			clear varnames(nonames) delim(";") stringc(_all) bindquotes(nobind)
		
		foreach k of varlist _all {
			replace `k' = subinstr(`k', `"""', "", .)
		}
		*
		
		drop in 1
		
		drop v3 v6 v8 v13 v15
		
		ren v1	nome_candidato
		ren v2	cargo
		ren v4	numero_candidato
		ren v5	sigla_uf
		ren v7	id_municipio_tse
		ren v9	sigla_partido
		ren v10	valor_receita
		ren v11	data_receita
		ren v12	tipo_fonte_receita
		ren v14	tipo_receita
		ren v16	nome_doador
		ren v17	cpf_cnpj_doador
		ren v18	situacao_receita
		
		foreach k in sigla_uf {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist *_doador* {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist cargo tipo_fonte_receita tipo_receita situacao_receita {
			clean_string `var'
		}
		*
		
		foreach k in receita {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_receita = subinstr(valor_receita, ",", ".", .)
		
		destring numero_candidato* id_municipio_tse*, replace force
		
	}
	if `ano' == 2006 {
		
		import delimited "input/prestacao_contas/prestacao_contas_2006/2006/Candidato/Receita/ReceitaCandidato.csv", ///
			clear varnames(nonames) delim(";") stringc(_all)
		
		drop in 1
		
		drop v4 v8 v13 v15
		
		ren v1	sequencial_candidato
		ren v2	nome_candidato
		ren v3	cargo
		ren v5	numero_candidato
		ren v6	sigla_uf
		ren v7	cnpj_candidato
		ren v9	sigla_partido
		ren v10	valor_receita
		ren v11	data_receita
		ren v12	tipo_fonte_receita
		ren v14	tipo_receita
		ren v16	nome_doador
		ren v17	cpf_cnpj_doador
		ren v18	sigla_uf_doador
		ren v19	situacao_receita
		
		foreach k in sigla_uf sigla_uf_doador {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist *_doador* {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist cargo tipo_fonte_receita tipo_receita situacao_receita {
			clean_string `var'
		}
		*
		
		foreach k in receita {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_receita = subinstr(valor_receita, ",", ".", .)
		
		destring numero_candidato*, replace force
		
	}
	if `ano' == 2008 {
		
		import delimited "input/prestacao_contas/prestacao_contas_2008/receitas_candidatos_2008_brasil.csv", ///
			clear varnames(nonames) delim(";") stringc(_all)
		
		drop in 1
		
		drop v3 v5 v8 v13 v18 v20 v24
		
		ren v1	sequencial_candidato
		ren v2	nome_candidato
		ren v4	cargo
		ren v6	numero_candidato
		ren v7	sigla_uf
		ren v9	id_municipio_tse
		ren v10	titulo_eleitor_candidato
		ren v11	cpf_candidato
		ren v12	cnpj_candidato
		ren v14	sigla_partido
		ren v15	valor_receita
		ren v16	data_receita
		ren v17	tipo_fonte_receita
		ren v19	tipo_receita
		ren v21	nome_doador
		ren v22	cpf_cnpj_doador
		ren v23	sigla_uf_doador
		ren v25	id_municipio_tse_doador
		ren v26	situacao_receita
		ren v27	nome_administrador
		ren v28	cpf_administrador
		
		foreach k in sigla_uf sigla_uf_doador {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist *_doador* {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist cargo tipo_fonte_receita tipo_receita situacao_receita {
			clean_string `var'
		}
		*
		
		foreach k in receita {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_receita = subinstr(valor_receita, ",", ".", .)
		
		destring numero_candidato* id_municipio_tse*, replace force
		
	}
	if `ano' == 2010 {
		
		local estados AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_contas_2010/candidato/`estado'/ReceitasCandidatos.txt", ///
				clear varnames(nonames) delim(";") stringc(_all)
			
			drop in 1
			drop v1
			
			ren v2	sequencial_candidato
			ren v3	sigla_uf
			ren v4	sigla_partido
			ren v5	numero_candidato
			ren v6	cargo
			ren v7	nome_candidato
			ren v8	cpf_candidato
			ren v9	entrega_conjunto
			ren v10	numero_recibo_eleitoral
			ren v11	numero_documento
			ren v12	cpf_cnpj_doador
			ren v13	nome_doador
			ren v14	data_receita
			ren v15	valor_receita
			ren v16	tipo_fonte_receita
			ren v17	fonte_receita
			ren v18	tipo_receita
			ren v19	descricao_receita
			
			gen cnpj_candidato = ""
			
			tempfile f_`estado'
			save `f_`estado''
		
		}
		*
		
		use `f_AC', clear
		foreach estado in `estados' {
			if "`estado'" != "AC" {
				qui append using `f_`estado''
			}
		}
		*
		
		replace descricao_receita = trim(descricao_receita)
		replace descricao_receita = subinstr(descricao_receita, `"""', "", .)
		
		foreach k in sigla_uf {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist numero_documento descricao_receita *_doador* {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist cargo entrega_conjunto tipo_fonte_receita fonte_receita tipo_receita {
			clean_string `var'
		}
		*
		
		foreach k in receita {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_receita = subinstr(valor_receita, ",", ".", .)
		
		destring numero_candidato*, replace force
		
	}
	if `ano' == 2012 {
		
		local estados AC AL AM AP BA CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_final_2012/receitas_candidatos_2012_`estado'.txt", ///
				clear varnames(nonames) delim(";") stringc(_all)
			
			drop in 1
			
			drop v1 v5
			
			ren v2	sequencial_candidato
			ren v3	sigla_uf
			ren v4	id_municipio_tse
			ren v6	sigla_partido
			ren v7	numero_candidato
			ren v8	cargo
			ren v9	nome_candidato
			ren v10	cpf_candidato
			ren v11	numero_recibo_eleitoral
			ren v12	numero_documento
			ren v13	cpf_cnpj_doador
			ren v14	nome_doador
			ren v15	nome_doador_rf
			ren v16	setor_economico_doador
			ren v17	data_receita
			ren v18	valor_receita
			ren v19	tipo_fonte_receita
			ren v20	fonte_receita
			ren v21	tipo_receita
			ren v22	descricao_receita
			
			tempfile f_`estado'
			save `f_`estado''
		
		}
		*
		
		use `f_AC', clear
		foreach estado in `estados' {
			if "`estado'" != "AC" {
				qui append using `f_`estado''
			}
		}
		*
		
		foreach k in sigla_uf {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist numero_documento descricao_receita *_doador* {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist cargo tipo_fonte_receita fonte_receita tipo_receita {
			clean_string `var'
		}
		*
		
		foreach k in receita {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_receita = subinstr(valor_receita, ",", ".", .)
		
		destring numero_candidato* id_municipio_tse*, replace force
		
	}
	if `ano' == 2014 {
		
		//---------------//
		// final
		//---------------//
		
		local estados AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_final_2014/receitas_candidatos_2014_`estado'.txt", ///
				clear varnames(nonames) delim(";") stringc(_all)
			
			drop in 1
			drop v1 v3
			
			ren v2	tipo_eleicao
			ren v4	cnpj_prestador_contas
			ren v5	sequencial_candidato
			ren v6	sigla_uf
			ren v7	sigla_partido
			ren v8	numero_candidato
			ren v9	cargo
			ren v10	nome_candidato
			ren v11	cpf_candidato
			ren v12	numero_recibo_eleitoral
			ren v13	numero_documento
			ren v14	cpf_cnpj_doador
			ren v15	nome_doador
			ren v16	nome_doador_rf
			ren v17	sigla_uf_doador
			ren v18	numero_partido_doador
			ren v19	numero_candidato_doador
			ren v20	id_setor_economico_doador
			ren v21	setor_economico_doador
			ren v22	data_receita
			ren v23	valor_receita
			ren v24	tipo_fonte_receita
			ren v25	fonte_receita
			ren v26	tipo_receita
			ren v27	descricao_receita
			ren v28	cpf_cnpj_doador_orig
			ren v29	nome_doador_orig
			ren v30	tipo_doador_orig
			ren v31	setor_economico_doador_orig
			ren v32	nome_doador_orig_rf
			
			replace data_receita = substr(data_receita, 1, 10)
			
			tempfile f_`estado'
			save `f_`estado''
		
		}
		*
		
		use `f_AC', clear
		foreach estado in `estados' {
			if "`estado'" != "AC" {
				qui append using `f_`estado''
			}
		}
		*
		
		tempfile final
		save `final'
		
		//---------------//
		// suplementar
		//---------------//
		
		import delimited "input/prestacao_contas/prestacao_contas_final_sup_2014/receitas_candidatos_prestacao_contas_final_2014_sup.txt", ///
			clear varnames(nonames) delim(";") stringc(_all)
		
		drop in 1
		drop v1 v3 v7 v8
		
		ren v2	tipo_eleicao
		ren v4	cnpj_prestador_contas
		ren v5	sequencial_candidato
		ren v6	sigla_uf
		ren v9	sigla_partido
		ren v10	numero_candidato
		ren v11	cargo
		ren v12	nome_candidato
		ren v13	cpf_candidato
		ren v14	cpf_vice_suplente
		ren v15	numero_recibo_eleitoral
		ren v16	numero_documento
		ren v17	cpf_cnpj_doador
		ren v18	nome_doador
		ren v19	nome_doador_rf
		ren v20	sigla_uf_doador
		ren v21	numero_partido_doador
		ren v22	numero_candidato_doador
		ren v23	id_setor_economico_doador
		ren v24	setor_economico_doador
		ren v25	data_receita
		ren v26	valor_receita
		ren v27	tipo_fonte_receita
		ren v28	fonte_receita
		ren v29	tipo_receita
		ren v30	descricao_receita
		ren v31	cpf_cnpj_doador_orig
		ren v32	nome_doador_orig
		ren v33	tipo_doador_orig
		ren v34	setor_economico_doador_orig
		ren v35	nome_doador_orig_rf
		
		replace data_receita = substr(data_receita, 1, 10)
		
		tempfile suplementar
		save `suplementar'
		
		//---------------//
		// append
		//---------------//
		
		use `final'
		append using `suplementar'
		
		foreach k in sigla_uf sigla_uf_doador {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist cpf_vice_suplente numero_documento descricao_receita *_doador* {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_eleicao cargo tipo_fonte_receita fonte_receita tipo_receita {
			clean_string `var'
		}
		*
		
		foreach k in receita {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_receita = subinstr(valor_receita, ",", ".", .)
		
		limpa_tipo_eleicao `ano'
		
		destring numero_candidato* numero_partido*, replace force
		
	}
	if `ano' == 2016 {
		
		//---------------//
		// final
		//---------------//
		
		local estados AC AL AM AP BA CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_contas_final_2016/receitas_candidatos_prestacao_contas_final_2016_`estado'.txt", ///
				clear varnames(nonames) delim(";") stringc(_all)
			
			drop in 1
			drop v1 v3 v8
			
			ren v2	tipo_eleicao
			ren v4	cnpj_prestador_contas
			ren v5	sequencial_candidato
			ren v6	sigla_uf
			ren v7	id_municipio_tse
			ren v9	sigla_partido
			ren v10	numero_candidato
			ren v11	cargo
			ren v12	nome_candidato
			ren v13	cpf_candidato
			ren v14 cpf_vice_suplente
			ren v15	numero_recibo_eleitoral
			ren v16	numero_documento
			ren v17	cpf_cnpj_doador
			ren v18	nome_doador
			ren v19	nome_doador_rf
			ren v20	ue_doador
			ren v21	numero_partido_doador
			ren v22	numero_candidato_doador
			ren v23	id_setor_economico_doador
			ren v24	setor_economico_doador
			ren v25	data_receita
			ren v26	valor_receita
			ren v27	tipo_fonte_receita
			ren v28	fonte_receita
			ren v29	tipo_receita
			ren v30	descricao_receita
			ren v31	cpf_cnpj_doador_orig
			ren v32	nome_doador_orig
			ren v33	tipo_doador_orig
			ren v34	setor_economico_doador_orig
			ren v35	nome_doador_orig_rf
			
			replace data_receita = substr(data_receita, 1, 10)
			
			tempfile f_`estado'
			save `f_`estado''
		
		}
		*
		
		use `f_AC', clear
		foreach estado in `estados' {
			if "`estado'" != "AC" {
				qui append using `f_`estado''
			}
		}
		*
		
		tempfile final
		save `final'
		
		//---------------//
		// suplementar
		//---------------//
		
		import delimited "input/prestacao_contas/prestacao_contas_final_sup_2016/receitas_candidatos_prestacao_contas_final_sup_2016.txt", ///
			clear varnames(nonames) delim(";") stringc(_all)
		
		drop in 1
		drop v1 v3 v8
		
		ren v2	tipo_eleicao
		ren v4	cnpj_prestador_contas
		ren v5	sequencial_candidato
		ren v6	sigla_uf
		ren v7	id_municipio_tse
		ren v9	sigla_partido
		ren v10	numero_candidato
		ren v11	cargo
		ren v12	nome_candidato
		ren v13	cpf_candidato
		ren v14 cpf_vice_suplente
		ren v15	numero_recibo_eleitoral
		ren v16	numero_documento
		ren v17	cpf_cnpj_doador
		ren v18	nome_doador
		ren v19	nome_doador_rf
		ren v20	ue_doador
		ren v21	numero_partido_doador
		ren v22	numero_candidato_doador
		ren v23	id_setor_economico_doador
		ren v24	setor_economico_doador
		ren v25	data_receita
		ren v26	valor_receita
		ren v27	tipo_fonte_receita
		ren v28	fonte_receita
		ren v29	tipo_receita
		ren v30	descricao_receita
		ren v31	cpf_cnpj_doador_orig
		ren v32	nome_doador_orig
		ren v33	tipo_doador_orig
		ren v34	setor_economico_doador_orig
		ren v35	nome_doador_orig_rf
		
		replace data_receita = substr(data_receita, 1, 10)
		
		tempfile suplementar
		save `suplementar'
		
		//---------------//
		// append
		//---------------//
		
		use `final'
		append using `suplementar'
		
		gen sigla_uf_doador = ue_doador if length(ue_doador) == 2
		gen id_municipio_tse_doador = ue_doador if length(ue_doador) > 2
		drop ue_doador
		
		foreach k in sigla_uf sigla_uf_doador {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist cpf_vice_suplente numero_documento descricao_receita *_doador* {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_eleicao cargo tipo_fonte_receita fonte_receita tipo_receita {
			clean_string `var'
		}
		*
		
		foreach k in receita {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_receita = subinstr(valor_receita, ",", ".", .)
		
		limpa_tipo_eleicao `ano'
		
		destring numero_candidato* numero_partido* id_municipio_tse*, replace force
		
	}
	if `ano' == 2018 {
		
		//-------------------//
		// candidato
		//-------------------//
		
		local estados AC AL AM AP BA BR CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_de_contas_eleitorais_candidatos_2018/receitas_candidatos_2018_`estado'.csv", ///
				clear varnames(nonames) delim(";") stringc(_all)
			
			drop in 1
			drop v1 v2 v3 v4 v6 v7 v8 v14 v15 v17 v27 v29 v31 v33 v40 v44 v47
			
			ren v5	tipo_eleicao
			ren v9	turno
			ren v10	tipo_prestacao_contas
			ren v11	data_prestacao_contas
			ren v12	sequencial_prestador_contas
			ren v13	sigla_uf
			ren v16	cnpj_prestador_contas
			ren v18	cargo
			ren v19	sequencial_candidato
			ren v20	numero_candidato
			ren v21	nome_candidato
			ren v22	cpf_candidato
			ren v23	cpf_vice_suplente
			ren v24	numero_partido
			ren v25	sigla_partido
			ren v26	nome_partido
			ren v28	tipo_fonte_receita
			ren v30	origem_receita
			ren v32	natureza_receita
			ren v34	tipo_receita
			ren v35	id_setor_economico_doador
			ren v36	setor_economico_doador
			ren v37	cpf_cnpj_doador
			ren v38	nome_doador
			ren v39	nome_doador_rf
			ren v41	esfera_partidaria_doador
			ren v42	sigla_uf_doador
			ren v43	id_municipio_tse_doador
			ren v45	sequencial_candidato_doador
			ren v46	numero_candidato_doador
			ren v48	cargo_candidato_doador
			ren v49	numero_partido_doador
			ren v50	sigla_partido_doador
			ren v51	nome_partido_doador
			ren v52	numero_recibo_doacao
			ren v53	numero_documento_doacao
			ren v54	sequencial_receita
			ren v55	data_receita
			ren v56	descricao_receita
			ren v57	valor_receita
			
			replace data_receita = substr(data_receita, 1, 10)
			
			tempfile f_`estado'
			save `f_`estado''
		
		}
		*
		
		use `f_AC', clear
		foreach estado in `estados' {
			if "`estado'" != "AC" {
				qui append using `f_`estado''
			}
		}
		*
		
		tempfile f_cand
		save `f_cand'
		
		/*	TODO: entender se precisa dar um append nesses dados
		
		//-------------------//
		// doador originario
		//-------------------//
		
		local estados AC AL AM AP BA BR CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_de_contas_eleitorais_candidatos_2018/receitas_candidatos_doador_originario_2018_`estado'.csv", ///
				clear varnames(nonames) delim(";") stringc(_all)
			
			drop in 1
			drop v1 v2 v3 v4 v6 v7 v8
			
			ren v5	tipo_eleicao
			ren v9	turno
			
			ren v10	tipo_prestacao_contas
			ren v11	data_prestacao_contas
			ren v12	sequencial_prestador_contas
			ren v13	sigla_uf
			ren v14	cpf_cnpj_doador_orig
			ren v15	nome_doador_orig
			ren v16	nome_doador_orig_rf
			ren v17	tipo_doador_orig
			ren v18	id_setor_economico_doador
			ren v19	setor_economico_doador
			ren v20	sequencial_receita
			ren v21	data_receita
			ren v22	descricao_receita
			ren v23	valor_receita
			
			replace data_receita = substr(data_receita, 1, 10)
			
			tempfile f_`estado'
			save `f_`estado''
		
		}
		*
		
		use `f_AC', clear
		foreach estado in `estados' {
			if "`estado'" != "AC" {
				qui append using `f_`estado''
			}
		}
		*
		
		tempfile f_cand_doador_orig
		save `f_cand_doador_orig'
		
		
		//-------------------//
		// append
		//-------------------//
		
		use `f_cand', clear
		append using `f_cand_doador_orig'
		
		*/
		
		foreach k in sigla_uf sigla_uf_doador {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist cpf_vice_suplente numero_documento origem_receita natureza_receita descricao_receita *_doador* *_doacao {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_eleicao tipo_prestacao_contas cargo tipo_fonte_receita tipo_receita origem_receita natureza_receita ///
			cargo_candidato_doador esfera_partidaria_doador {
			clean_string `var'
		}
		*
		
		foreach k in receita prestacao_contas {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_receita = subinstr(valor_receita, ",", ".", .)
		
		limpa_tipo_eleicao `ano'
		
		destring numero_candidato* numero_partido* id_municipio_tse*, replace force
		
	}
	if `ano' == 2020 {
		
		local estados AC AL AM AP BA CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_de_contas_eleitorais_candidatos_2020/receitas_candidatos_2020_`estado'.csv", ///
				clear varnames(nonames) delim(";") stringc(_all)
			
			drop in 1
			drop v1 v2 v3 v4 v6 v7 v8 v15 v17 v27 v29 v31 v33 v40 v44 v47
			
			ren v5	tipo_eleicao
			ren v9	turno
			ren v10	tipo_prestacao_contas
			ren v11	data_prestacao_contas
			ren v12	sequencial_prestador_contas
			ren v13	sigla_uf
			ren v14	id_municipio_tse
			ren v16	cnpj_prestador_contas
			ren v18	cargo
			ren v19	sequencial_candidato
			ren v20	numero_candidato
			ren v21	nome_candidato
			ren v22	cpf_candidato
			ren v23	cpf_vice_suplente
			ren v24	numero_partido
			ren v25	sigla_partido
			ren v26	nome_partido
			ren v28	tipo_fonte_receita
			ren v30	origem_receita
			ren v32	natureza_receita
			ren v34	tipo_receita
			ren v35	id_setor_economico_doador
			ren v36	setor_economico_doador
			ren v37	cpf_cnpj_doador
			ren v38	nome_doador
			ren v39	nome_doador_rf
			ren v41	esfera_partidaria_doador
			ren v42	sigla_uf_doador
			ren v43	id_municipio_tse_doador
			ren v45	sequencial_candidato_doador
			ren v46	numero_candidato_doador
			ren v48	cargo_candidato_doador
			ren v49	numero_partido_doador
			ren v50	sigla_partido_doador
			ren v51	nome_partido_doador
			ren v52	numero_recibo_doacao
			ren v53	numero_documento_doacao
			ren v54	sequencial_receita
			ren v55	data_receita
			ren v56	descricao_receita
			ren v57	valor_receita
			
			replace data_receita = substr(data_receita, 1, 10)
			
			tempfile f_`estado'
			save `f_`estado''
		
		}
		*
		
		use `f_AC', clear
		foreach estado in `estados' {
			if "`estado'" != "AC" {
				qui append using `f_`estado''
			}
		}
		*
		
		tempfile f_cand
		save `f_cand'
		
		/*	TODO: entender se precisa dar um append nesses dados
		
		//-------------------//
		// doador originario
		//-------------------//
		
		local estados AC AL AM AP BA CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_de_contas_eleitorais_candidatos_2020/receitas_candidatos_doador_originario_2020_`estado'.csv", ///
				clear varnames(nonames) delim(";") stringc(_all)
			
			drop in 1
			drop v1 v2 v3 v4 v6 v7 v8
			
			ren v5	tipo_eleicao
			ren v9	turno
			
			ren v10	tipo_prestacao_contas
			ren v11	data_prestacao_contas
			ren v12	sequencial_prestador_contas
			ren v13	sigla_uf
			ren v14	cpf_cnpj_doador_orig
			ren v15	nome_doador_orig
			ren v16	nome_doador_orig_rf
			ren v17	tipo_doador_orig
			ren v18	id_setor_economico_doador
			ren v19	setor_economico_doador
			ren v20	sequencial_receita
			ren v21	data_receita
			ren v22	descricao_receita
			ren v23	valor_receita
			
			replace data_receita = substr(data_receita, 1, 10)
			
			tempfile f_`estado'
			save `f_`estado''
		
		}
		*
		
		use `f_AC', clear
		foreach estado in `estados' {
			if "`estado'" != "AC" {
				qui append using `f_`estado''
			}
		}
		*
		
		tempfile f_cand_doador_orig
		save `f_cand_doador_orig'
		
		//-------------------//
		// append
		//-------------------//
		
		use `f_cand', clear
		append using `f_cand_doador_orig'
		
		*/
		
		foreach k in sigla_uf sigla_uf_doador {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist cpf_vice_suplente numero_documento origem_receita natureza_receita descricao_receita *_doador* *_doacao {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_eleicao tipo_prestacao_contas cargo tipo_fonte_receita tipo_receita origem_receita natureza_receita ///
			cargo_candidato_doador esfera_partidaria_doador {
			clean_string `var'
		}
		*
		
		foreach k in receita prestacao_contas {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_receita = subinstr(valor_receita, ",", ".", .)
		
		limpa_tipo_eleicao `ano'
		
		destring numero_candidato* numero_partido* id_municipio_tse*, replace force
		
	}
	*
	
	gen ano = `ano'
	
	compress
	
	save "output/receita_candidato_`ano'.dta", replace
	
}
*

/*


/*
use "output/incumbency_1996-2018.dta", clear

keep if year_election >= 2006

keep id_politician candidate_seq state_abbrev year_election

duplicates tag candidate_seq state_abbrev year_election, gen(dup)	// deleting duplicate politician
drop if dup > 0
drop dup

merge 1:m candidate_seq state_abbrev year_election using "tmp/wealth.dta"
drop if _merge == 2
drop _merge

sort id_politician year_election item_description

save "output/wealth_declared_2006-2018.dta", replace
*/

/*
//----------------------------------------------------------------------------//
// build: doacoes
//----------------------------------------------------------------------------//

//---------------------------------------------//
// 2002
//---------------------------------------------//

//---------------------//
// candidato
//---------------------//

import delimited "input/prestacao_contas_2002/2002/Candidato/Receita/ReceitaCandidato.csv", clear delim(";") varnames(nonames) stringc(_all)

drop in 1
drop v1 v9

ren v2		state_abbrev
ren v3		party
ren v4		office
ren v5		candidate_name
ren v6		candidate_number
ren v7		rev_date
ren v8		donor
ren v10		donor_name
ren v11		rev_value
ren v12		rev_type

replace rev_value = subinstr(rev_value, ",", ".", .)
destring candidate_number rev_value, replace

foreach var of varlist	office candidate_name donor_name rev_type {
	clean_string `var'
}
*

replace rev_date = "0" + rev_date if length(rev_date) == 9

gen year_election = 2002

compress

save "tmp/rev_candidate_2002.dta", replace


//---------------------//
// committee
//---------------------//

// import delimited "input/prestacao_contas 2002-2016/prestacao_contas_2002/2002/Comitê/Receita/ReceitaComite.csv", clear delim(";") varn(1) stringc(_all)



//---------------------------------------------//
// 2004
//---------------------------------------------//

//---------------------//
// candidate
//---------------------//

import delimited "input/prestacao_contas 2002-2018/prestacao_contas_2004/2004/Candidato/Receita/ReceitaCandidato.csv", ///
	clear varnames(nonames) delim(";") stringc(_all) bindquotes(nobind)

drop in 1
drop v3 v6 v8 v13 v15 v18

foreach k of varlist _all {
	replace `k' = subinstr(`k', `"""', "", .)
}
*

ren v1	candidate_name
ren v2	office
ren v4	candidate_number
ren v5	state_abbrev
ren v7	id_TSE
ren v9	party
ren v10	rev_value
ren v11	rev_date
ren v12	rev_source_type
ren v14	rev_type
ren v16	donor_name
ren v17	donor

replace rev_value = subinstr(rev_value, ",", ".", .)
destring id_TSE candidate_number rev_value, replace

foreach var of varlist	office candidate_name donor_name rev_source_type rev_type {
	clean_string `var'
}
*

replace rev_date = "0" + rev_date if length(rev_date) == 9

gen year_election = 2004

compress

save "tmp/rev_candidate_2004.dta", replace



//---------------------------------------------//
// 2006
//---------------------------------------------//

//---------------------//
// candidate
//---------------------//

import delimited "input/prestacao_contas 2002-2018/prestacao_contas_2006/2006/Candidato/Receita/ReceitaCandidato.csv", ///
	clear varnames(nonames) delim(";") stringc(_all)

drop in 1
drop v4 v8 v13 v15 v18 v19

ren v1	candidate_seq
ren v2	candidate_name
ren v3	office
ren v5	candidate_number
ren v6	state_abbrev
ren v7	candidate_CNPJ
ren v9	party
ren v10	rev_value
ren v11	rev_date
ren v12	rev_source_type
ren v14	rev_type
ren v16	donor_name
ren v17	donor

replace rev_value = subinstr(rev_value, ",", ".", .)
destring candidate_seq candidate_number rev_value, replace

foreach var of varlist	office candidate_name donor_name rev_source_type rev_type {
	clean_string `var'
}
*

replace rev_date = "0" + rev_date if length(rev_date) == 9

gen year_election = 2006

compress

save "tmp/rev_candidate_2006.dta", replace



//---------------------------------------------//
// 2008
//---------------------------------------------//

//---------------------//
// candidate
//---------------------//

import delimited "input/prestacao_contas 2002-2018/prestacao_contas_2008/receitas_candidatos_2008_brasil.csv", ///
	clear varnames(nonames) delim(";") stringc(_all)

drop in 1
drop v3 v5 v8 v13 v18 v20 v23 v24 v25 v26 v27 v28

ren v1	candidate_seq
ren v2	candidate_name
ren v4	office
ren v6	candidate_number
ren v7	state_abbrev
ren v9	id_TSE
ren v10	electoral_id
ren v11	CPF
ren v12	candidate_CNPJ
ren v14	party
ren v15	rev_value
ren v16	rev_date
ren v17	rev_source_type
ren v19	rev_type
ren v21	donor_name
ren v22	donor

replace rev_value = subinstr(rev_value, ",", ".", .)
destring candidate_seq candidate_number id_TSE rev_value, replace

foreach var of varlist	office candidate_name donor_name rev_source_type rev_type {
	clean_string `var'
}
*

replace rev_date = "0" + rev_date if length(rev_date) == 9

gen year_election = 2008

compress

save "tmp/rev_candidate_2008.dta", replace



//---------------------------------------------//
// 2010
//---------------------------------------------//

//---------------------//
// candidate
//---------------------//

local states AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

foreach state in `states' {
	
	import delimited "input/prestacao_contas 2002-2018/prestacao_contas_2010/candidato/`estado'/ReceitasCandidatos.txt", ///
		clear varnames(nonames) delim(";") stringc(_all)
	
	drop in 1
	drop v1 v9 v10 v11 v17 v19
	
	ren v2	candidate_seq
	ren v3	state_abbrev
	ren v4	party
	ren v5	candidate_number
	ren v6	office
	ren v7	candidate_name
	ren v8	CPF
	ren v12	donor
	ren v13	donor_name
	ren v14	rev_date
	ren v15	rev_value
	ren v16	rev_source_type
	ren v18	rev_type
	
	replace rev_value = subinstr(rev_value, ",", ".", .)
	destring candidate_seq candidate_number rev_value, replace
	
	foreach var of varlist	office candidate_name donor_name rev_source_type rev_type {
		clean_string `var'
	}
	*
	
	gen year_election = 2010
	
	compress
	
	save "tmp/rev_candidate_2010_`estado'.dta", replace

}
*

local first: word 1 of `states'
use "tmp/rev_candidate_2010_`first'.dta", clear
foreach state in `states' {
	if "`estado'" != "`first'" {
		qui append using "tmp/rev_candidate_2010_`estado'.dta"
	}
}
*

save "tmp/rev_candidate_2010.dta", replace



//---------------------------------------------//
// 2012
//---------------------------------------------//

//---------------------//
// candidate
//---------------------//

local states AC AL AM AP BA brasil CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

foreach state in `states' {
	
	import delimited "input/prestacao_contas 2002-2018/prestacao_contas_2012/receitas_candidatos_2012_`estado'.txt", ///
		clear varnames(nonames) delim(";") stringc(_all)
	
	drop in 1
	drop v1 v2 v3 v7 v13 v14 v17 v18 v19 v20 v21 v22 v26 v28
	cap drop v29
	
	foreach k of varlist _all {
		replace `k' = subinstr(`k', `"""', "", .)
	}
	*
	
	ren v4	candidate_seq
	ren v5	state_abbrev
	ren v6	id_TSE
	ren v8	party
	ren v9	candidate_number
	ren v10	office
	ren v11	candidate_name
	ren v12	CPF
	ren v15	donor
	ren v16	donor_name
	ren v23	rev_date
	ren v24	rev_value
	ren v25	rev_source_type
	ren v27	rev_type
	
	replace rev_date = substr(rev_date, 1, 10)
	
	replace rev_value = subinstr(rev_value, ",", ".", .)
	destring candidate_seq id_TSE candidate_number rev_value, replace force
	
	foreach var of varlist office candidate_name donor_name rev_source_type rev_type {
		clean_string `var'
	}
	*
	
	gen year_election = 2012
	
	compress
	
	save "tmp/rev_candidate_2012_`estado'.dta", replace
	
}
*

local first: word 1 of `states'
use "tmp/rev_candidate_2012_`first'.dta", clear
foreach state in `states' {
	if "`estado'" != "`first'" {
		qui append using "tmp/rev_candidate_2012_`estado'.dta"
	}
}
*

save "tmp/rev_candidate_2012.dta", replace




//---------------------------------------------//
// 2014
//---------------------------------------------//

//---------------------//
// candidate
//---------------------//

local states AC AL AM AP BA brasil CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

foreach state in `states' {
	
	import delimited "input/prestacao_contas 2002-2018/prestacao_contas_2014/receitas_candidatos_2014_`estado'.txt", ///
		clear varnames(nonames) delim(";") stringc(_all)
	
	drop in 1
	drop v1 v2 v3 v12 v13 v16 v17 v18 v19 v20 v21 v25 v27 v28 v29 v30 v31 v32
	cap drop v33
	
	foreach k of varlist _all {
		replace `k' = subinstr(`k', `"""', "", .)
	}
	*
	
	ren v4	candidate_CNPJ
	ren v5	candidate_seq
	ren v6	state_abbrev
	ren v7	party
	ren v8	candidate_number
	ren v9	office
	ren v10	candidate_name
	ren v11	CPF
	ren v14	donor
	ren v15	donor_name
	ren v22	rev_date
	ren v23	rev_value
	ren v24	rev_source_type
	ren v26	rev_type
	
	replace rev_date = substr(rev_date, 1, 10)
	
	replace rev_value = subinstr(rev_value, ",", ".", .)
	destring candidate_seq candidate_number rev_value, replace force
	
	foreach var of varlist	office candidate_name donor_name rev_source_type rev_type {
		clean_string `var'
	}
	*
	
	gen year_election = 2014
	
	compress
	
	save "tmp/rev_candidate_2014_`estado'.dta", replace
	
}
*

local first: word 1 of `states'
use "tmp/rev_candidate_2014_`first'.dta", clear
foreach state in `states' {
	if "`estado'" != "`first'" {
		qui append using "tmp/rev_candidate_2014_`estado'.dta"
	}
}
*

save "tmp/rev_candidate_2014.dta", replace




//---------------------------------------------//
// 2016
//---------------------------------------------//

local states AC AL AM AP BA brasil CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

foreach state in `states' {
	
	import delimited "input/prestacao_contas 2002-2018/prestacao_contas_2016/receitas_candidatos_prestacao_contas_final_2016_`estado'.txt", ///
		clear varnames(nonames) delim(";") stringc(_all)
	
	drop in 1
	drop v1 v2 v3 v8 v14 v15 v16 v19 v20 v21 v22 v23 v24 v28 v30 v31 v32 v33 v34 v35
	
	foreach k of varlist _all {
		replace `k' = subinstr(`k', `"""', "", .)
	}
	*
	
	ren v4	candidate_CNPJ
	ren v5	candidate_seq
	ren v6	state_abbrev
	ren v7	id_TSE
	ren v9	party
	ren v10	candidate_number
	ren v11	office
	ren v12	candidate_name
	ren v13	CPF
	ren v17	donor
	ren v18	donor_name
	ren v25	rev_date
	ren v26	rev_value
	ren v27	rev_source_type
	ren v29	rev_type
	
	replace rev_date = substr(rev_date, 1, 10)
	
	replace rev_value = subinstr(rev_value, ",", ".", .)
	destring candidate_seq id_TSE candidate_number rev_value, replace force
	
	foreach var of varlist office candidate_name donor_name rev_source_type rev_type {
		clean_string `var'
	}
	*
	
	gen year_election = 2016
	
	compress
	
	save "tmp/rev_candidate_2016_`estado'.dta", replace
	
}
*

local first: word 1 of `states'
use "tmp/rev_candidate_2016_`first'.dta", clear
foreach state in `states' {
	if "`estado'" != "`first'" {
		qui append using "tmp/rev_candidate_2016_`estado'.dta"
	}
}
*

save "tmp/rev_candidate_2016.dta", replace




//---------------------------------------------//
// 2018
//---------------------------------------------//

local states AC AL AM AP BA brasil CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

foreach state in `states' {
	
	import delimited "input/prestacao_contas 2002-2018/prestacao_de_contas_eleitorais_candidatos_2018/despesas_contratadas_candidatos_2018_`estado'.csv", ///
		clear varnames(nonames) delim(";") stringc(_all)
	
	drop in 1
	
	keep v14 v16 v18 v19 v20 v21 v22 v25 v31 v32 v51 v53
	
	ren v16	candidate_CNPJ
	ren v19	candidate_seq
	ren v14	state_abbrev
	ren v25	party
	ren v20	candidate_number
	ren v18	office
	ren v21	candidate_name
	ren v22	CPF
	ren v31	donor
	ren v32	donor_name
	ren v51	rev_date
	ren v53	rev_value
	
	replace rev_date = substr(rev_date, 1, 10)
	
	replace rev_value = subinstr(rev_value, ",", ".", .)
	destring candidate_seq candidate_number rev_value, replace force
	
	foreach var of varlist office candidate_name donor_name {
		clean_string `var'
	}
	*
	
	gen year_election = 2018
	
	compress
	
	save "tmp/rev_candidate_2018_`estado'.dta", replace
	
}
*

local first: word 1 of `states'
use "tmp/rev_candidate_2018_`first'.dta", clear
foreach state in `states' {
	if "`estado'" != "`first'" {
		qui append using "tmp/rev_candidate_2018_`estado'.dta"
	}
}
*

save "tmp/rev_candidate_2018.dta", replace




//---------------------------------------------//
// append and save
//---------------------------------------------//

use "output/incumbency_1996-2018.dta", clear

keep id_politician CPF candidate_number candidate_name year_election party office // id_TSE

drop if year_election <= 2000

duplicates tag candidate_number candidate_name year_election party office, gen(dup)	// observations not identified with CPF.
drop if dup > 0																		// have no CPF for before 2008 below.
drop dup

save "tmp/data_id_politician.dta", replace


use "tmp/rev_candidate_2002.dta", replace
append using "tmp/rev_candidate_2004.dta"
append using "tmp/rev_candidate_2006.dta"
append using "tmp/rev_candidate_2008.dta"
append using "tmp/rev_candidate_2010.dta"
append using "tmp/rev_candidate_2012.dta"
append using "tmp/rev_candidate_2014.dta"
append using "tmp/rev_candidate_2016.dta"
append using "tmp/rev_candidate_2018.dta"

cap drop v34
cap drop v36

//---------------------//
// adjustments
//---------------------//

replace donor_name = "" if length(donor_name) > 100

foreach k in rev_type rev_source_type {
	
	foreach n of numlist 0(1)9 {
		replace `k' = usubinstr(`k', "`n'", "", .)
	}
	
	encode `k', gen(aux_`k')
	order aux_`k', a(`k')
	drop `k'
	ren aux_`k' `k'	
}
*


//---------------------//
// merge id_politician
//---------------------//

preserve
	
	keep if year <= 2006
	
	merge m:1 candidate_number candidate_name year_election party office using "tmp/data_id_politician.dta"
	drop if _merge != 3
	drop _merge
	
	save "tmp/merged_2008b.dta", replace
	
restore

preserve
	
	keep if year >= 2008
	
	merge m:1 CPF candidate_number year_election party using "tmp/data_id_politician.dta"
	drop if _merge != 3
	drop _merge
	
	save "tmp/merged_2008p.dta", replace
	
restore

use "tmp/merged_2008b.dta", clear
append using "tmp/merged_2008p.dta"

drop CPF electoral_id candidate_number candidate_seq candidate_name candidate_CNPJ id_TSE state_abbrev party office

la var year_election	"Year"
la var rev_date			"Revenue Date"
la var donor			"ID Donor"
la var donor_name		"Donor"
la var rev_value		"Revenue Value"
la var rev_type			"Revenue Type"
la var rev_source_type	"Revenue Source Type"

order id_politician year_election
sort  id_politician year_election

compress

save "output/donations_rev_candidate_2002-2018.dta", replace
















