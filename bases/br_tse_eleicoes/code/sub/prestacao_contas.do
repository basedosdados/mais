
//----------------------------------------------------------------------------//
// build: bens declarados
//----------------------------------------------------------------------------//

foreach ano of numlist 2006(2)2022 {
	
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
			
			destring ano valor_item, replace force
			
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
			destring ano id_tipo_item valor_item, replace force // sequencial_candidato
			
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
// receitas candidato
//---------------------------------------------//

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) case(preserve)
keep id_municipio id_municipio_tse
tempfile diretorio
save `diretorio'

foreach ano of numlist 2014(2)2022 { // 2002(2)2022 {
	
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
		ren v12	especie_receita
		
		foreach k in sigla_uf sigla_uf_doador {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist *_doador* {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist cargo especie_receita {
			clean_string `var'
		}
		*
		
		foreach k in receita {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_receita = subinstr(valor_receita, ",", ".", .)
		
		destring numero_candidato, replace force
		
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
		ren v12	origem_receita
		ren v14	especie_receita
		ren v16	nome_doador
		ren v17	cpf_cnpj_doador
		ren v18	situacao_receita
		
		foreach k in sigla_uf {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist *_doador* origem_receita {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist cargo origem_receita especie_receita situacao_receita {
			clean_string `var'
		}
		*
		
		foreach k in receita {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_receita = subinstr(valor_receita, ",", ".", .)
		
		destring numero_candidato id_municipio_tse*, replace force
		
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
		ren v12	origem_receita
		ren v14	especie_receita
		ren v16	nome_doador
		ren v17	cpf_cnpj_doador
		ren v18	sigla_uf_doador
		ren v19	situacao_receita
		
		foreach k in sigla_uf sigla_uf_doador {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist *_doador* origem_receita {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist cargo origem_receita especie_receita situacao_receita {
			clean_string `var'
		}
		*
		
		foreach k in receita {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_receita = subinstr(valor_receita, ",", ".", .)
		
		destring numero_candidato, replace force
		
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
		ren v17	origem_receita
		ren v19	especie_receita
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
		
		foreach k of varlist *_doador* origem_receita {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist cargo origem_receita especie_receita situacao_receita {
			clean_string `var'
		}
		*
		
		foreach k in receita {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_receita = subinstr(valor_receita, ",", ".", .)
		
		destring numero_candidato id_municipio_tse*, replace force
		
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
			ren v16	origem_receita
			ren v17	fonte_receita
			ren v18	natureza_receita
			ren v19	descricao_receita
			
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
		
		foreach k of varlist numero_documento origem_receita natureza_receita descricao_receita *_doador* {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist cargo entrega_conjunto origem_receita fonte_receita natureza_receita {
			clean_string `var'
		}
		*
		
		foreach k in receita {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_receita = subinstr(valor_receita, ",", ".", .)
		
		destring numero_candidato, replace force
		
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
			ren v16	descricao_cnae_2_doador
			ren v17	data_receita
			ren v18	valor_receita
			ren v19	origem_receita
			ren v20	fonte_receita
			ren v21	natureza_receita
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
		
		foreach k of varlist numero_documento origem_receita natureza_receita descricao_receita *_doador* {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist cargo descricao_cnae_2_doador ///
			origem_receita fonte_receita natureza_receita {
			clean_string `var'
		}
		*
		
		foreach k in receita {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_receita = subinstr(valor_receita, ",", ".", .)
		
		destring numero_candidato id_municipio_tse*, replace force
		
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
			ren v20	cnae_2_doador
			ren v21	descricao_cnae_2_doador
			ren v22	data_receita
			ren v23	valor_receita
			ren v24	origem_receita
			ren v25	fonte_receita
			ren v26	natureza_receita
			ren v27	descricao_receita
			ren v28	cpf_cnpj_doador_orig
			ren v29	nome_doador_orig
			ren v30	tipo_doador_orig
			ren v31	descricao_cnae_2_doador_orig
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
		ren v23	cnae_2_doador
		ren v24	descricao_cnae_2_doador
		ren v25	data_receita
		ren v26	valor_receita
		ren v27	origem_receita
		ren v28	fonte_receita
		ren v29	natureza_receita
		ren v30	descricao_receita
		ren v31	cpf_cnpj_doador_orig
		ren v32	nome_doador_orig
		ren v33	tipo_doador_orig
		ren v34	descricao_cnae_2_doador_orig
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
		
		foreach k of varlist cpf_vice_suplente numero_documento origem_receita natureza_receita descricao_receita *_doador* {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_eleicao cargo descricao_cnae_2_doador ///
			origem_receita fonte_receita natureza_receita {
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
		// completo
		//---------------//
		
		local estados AC AL AM AP BA CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_contas_2016/receitas_candidatos_2016_`estado'.txt", ///
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
			ren v23	cnae_2_doador
			ren v24	descricao_cnae_2_doador
			ren v25	data_receita
			ren v26	valor_receita
			ren v27	origem_receita
			ren v28	fonte_receita
			ren v29	natureza_receita
			ren v30	descricao_receita
			ren v31	cpf_cnpj_doador_orig
			ren v32	nome_doador_orig
			ren v33	tipo_doador_orig
			ren v34	descricao_cnae_2_doador_orig
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
		
		/*
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
			ren v23	cnae_2_doador
			ren v24	descricao_cnae_2_doador
			ren v25	data_receita
			ren v26	valor_receita
			ren v27	origem_receita
			ren v28	fonte_receita
			ren v29	natureza_receita
			ren v30	descricao_receita
			ren v31	cpf_cnpj_doador_orig
			ren v32	nome_doador_orig
			ren v33	tipo_doador_orig
			ren v34	descricao_cnae_2_doador_orig
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
		ren v23	cnae_2_doador
		ren v24	descricao_cnae_2_doador
		ren v25	data_receita
		ren v26	valor_receita
		ren v27	origem_receita
		ren v28	fonte_receita
		ren v29	natureza_receita
		ren v30	descricao_receita
		ren v31	cpf_cnpj_doador_orig
		ren v32	nome_doador_orig
		ren v33	tipo_doador_orig
		ren v34	descricao_cnae_2_doador_orig
		ren v35	nome_doador_orig_rf
		
		replace data_receita = substr(data_receita, 1, 10)
		
		tempfile suplementar
		save `suplementar'
		
		//---------------//
		// append
		//---------------//
		
		use `final'
		append using `suplementar'
		*/
		
		gen sigla_uf_doador = ue_doador if length(ue_doador) == 2
		gen id_municipio_tse_doador = ue_doador if length(ue_doador) > 2
		drop ue_doador
		
		foreach k in sigla_uf sigla_uf_doador {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist cpf_vice_suplente numero_documento origem_receita natureza_receita descricao_receita *_doador* {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_eleicao cargo descricao_cnae_2_doador ///
			origem_receita fonte_receita natureza_receita {
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
		
		local estados AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
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
			ren v28	fonte_receita
			ren v30	origem_receita
			ren v32	natureza_receita
			ren v34	especie_receita
			ren v35	cnae_2_doador
			ren v36	descricao_cnae_2_doador
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
		
		foreach k in sigla_uf sigla_uf_doador {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist cpf_vice_suplente origem_receita natureza_receita descricao_receita *_doador* *_doacao {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_eleicao tipo_prestacao_contas cargo ///
			fonte_receita origem_receita natureza_receita especie_receita ///
			descricao_cnae_2_doador cargo_candidato_doador esfera_partidaria_doador {
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
	if `ano' >= 2020 {
		
		local estados AC AL AM AP BA CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_de_contas_eleitorais_candidatos_`ano'/receitas_candidatos_`ano'_`estado'.csv", ///
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
			ren v28	fonte_receita
			ren v30	origem_receita
			ren v32	natureza_receita
			ren v34	especie_receita
			ren v35	cnae_2_doador
			ren v36	descricao_cnae_2_doador
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
		
		foreach k in sigla_uf sigla_uf_doador {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist cpf_vice_suplente origem_receita natureza_receita descricao_receita *_doador* *_doacao {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_eleicao tipo_prestacao_contas cargo ///
			fonte_receita origem_receita natureza_receita especie_receita ///
			descricao_cnae_2_doador cargo_candidato_doador esfera_partidaria_doador {
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
		
		destring numero_candidato* numero_partido* id_municipio_tse*, replace force // sequencial_candidato
		
	}
	*
	
	cap confirm variable id_municipio_tse
	if !_rc {
		merge m:1 id_municipio_tse using `diretorio'
		drop if _merge == 2
		drop _merge
		order id_municipio, b(id_municipio_tse)
	}
	
	gen ano = `ano'
	
	compress
	
	save "output/receitas_candidato_`ano'.dta", replace
	
}
*

//---------------------------------------------//
// despesas - candidato
//---------------------------------------------//

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) case(preserve)
keep id_municipio id_municipio_tse
tempfile diretorio
save `diretorio'

foreach ano of numlist 2002(2)2022 {
	
	if `ano' == 2002 {
		
		import delimited "input/prestacao_contas/prestacao_contas_2002/2002/Candidato/Despesa/DespesaCandidato.csv", ///
			clear varnames(nonames) delim(";") stringc(_all)
		
		drop in 1
		drop v9
		
		ren v1	sequencial_candidato
		ren v2	sigla_uf
		ren v3	sigla_partido
		ren v4	cargo
		ren v5	nome_candidato
		ren v6	numero_candidato
		ren v7	data_despesa
		ren v8	cpf_cnpj_fornecedor
		ren v10	nome_fornecedor
		ren v11	valor_despesa
		ren v12	tipo_despesa
		
		foreach k in sigla_uf {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist tipo_despesa cpf_cnpj_fornecedor {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist cargo tipo_despesa {
			clean_string `var'
		}
		*
		
		gen numero_partido = substr(numero_candidato, 1, 2)
		
		foreach k in despesa {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_despesa = subinstr(valor_despesa, ",", ".", .)
		
		destring numero_candidato* numero_partido, replace force
		
	}
	if `ano' == 2004 {
		
		import delimited "input/prestacao_contas/prestacao_contas_2004/2004/Candidato/Despesa/DespesaCandidato.csv", ///
			clear varnames(nonames) delim(";") stringc(_all) bindquote(nobind) stripquotes(yes)
		
		drop in 1
		drop v3 v6 v13 v15 v18 v21 v22
		
		ren v1	nome_candidato
		ren v2	cargo
		ren v4	numero_candidato
		ren v5	sigla_uf
		ren v7	id_municipio_tse
		ren v8	numero_partido
		ren v9	sigla_partido
		ren v10	valor_despesa
		ren v11	data_despesa
		ren v12	tipo_despesa
		ren v14	especie_recurso
		ren v16	numero_documento
		ren v17	tipo_documento
		ren v19	nome_fornecedor
		ren v20	cpf_cnpj_fornecedor
		
		foreach k in sigla_uf {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist ///
			tipo_documento numero_documento tipo_despesa cpf_cnpj_fornecedor {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_documento cargo tipo_despesa especie_recurso {
			clean_string `var'
		}
		*
		
		foreach k in despesa {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_despesa = subinstr(valor_despesa, ",", ".", .)
		
		destring numero_candidato* numero_partido id_municipio_tse, replace force
		
	}
	if `ano' == 2006 {
		
		import delimited "input/prestacao_contas/prestacao_contas_2006/2006/Candidato/Despesa/DespesaCandidato.csv", ///
			clear varnames(nonames) delim(";") stringc(_all)
		
		drop in 1
		drop v4 v13 v15 v18 v21 v22
		
		ren v1	sequencial_candidato
		ren v2	nome_candidato
		ren v3	cargo
		ren v5	numero_candidato
		ren v6	sigla_uf
		ren v7	cnpj_candidato
		ren v8	numero_partido
		ren v9	sigla_partido
		ren v10	valor_despesa
		ren v11	data_despesa
		ren v12	tipo_despesa
		ren v14	especie_recurso
		ren v16	numero_documento
		ren v17	tipo_documento
		ren v19	nome_fornecedor
		ren v20	cpf_cnpj_fornecedor
		
		foreach k in sigla_uf {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist ///
			tipo_documento numero_documento tipo_despesa cpf_cnpj_fornecedor {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_documento cargo tipo_despesa especie_recurso {
			clean_string `var'
		}
		*
		
		foreach k in despesa {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_despesa = subinstr(valor_despesa, ",", ".", .)
		
		destring numero_candidato* numero_partido, replace force
		
	}
	if `ano' == 2008 {
		
		import delimited "input/prestacao_contas/prestacao_contas_2008/despesas_candidatos_2008_brasil.csv", ///
			clear varnames(nonames) delim(";") stringc(_all)
		
		drop in 1
		drop v4 v7 v15 v17 v20 v23 v24 v25 v26 v27 v28 v29
		
		ren v1	sequencial_candidato
		ren v2	nome_candidato
		ren v3	cargo
		ren v5	numero_candidato
		ren v6	sigla_uf
		ren v8	id_municipio_tse
		ren v9	cnpj_candidato
		ren v10	numero_partido
		ren v11	sigla_partido
		ren v12	valor_despesa
		ren v13	data_despesa
		ren v14	tipo_despesa
		ren v16	especie_recurso
		ren v18	numero_documento
		ren v19	tipo_documento
		ren v21	nome_fornecedor
		ren v22	cpf_cnpj_fornecedor
		
		foreach k in sigla_uf {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist ///
			tipo_documento numero_documento tipo_despesa cpf_cnpj_fornecedor {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_documento cargo tipo_despesa especie_recurso {
			clean_string `var'
		}
		*
		
		foreach k in despesa {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_despesa = subinstr(valor_despesa, ",", ".", .)
		
		destring numero_candidato* numero_partido id_municipio_tse, replace force
		
	}
	if `ano' == 2010 {
		
		local estados AC AL AM AP BA CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_contas_2010/candidato/`estado'/DespesasCandidatos.txt", ///
				clear varnames(nonames) delim(";") stringc(_all)
			
			drop in 1
			drop v1 v9
			
			ren v2	sequencial_candidato
			ren v3	sigla_uf
			ren v4	sigla_partido
			ren v5	numero_candidato
			ren v6	cargo
			ren v7	nome_candidato
			ren v8	cpf_candidato
			ren v10	tipo_documento
			ren v11	numero_documento
			ren v12	cpf_cnpj_fornecedor
			ren v13	nome_fornecedor
			ren v14	data_despesa
			ren v15	valor_despesa
			ren v16	tipo_despesa
			ren v17	fonte_recurso
			ren v18	especie_recurso
			ren v19	descricao_despesa
			
			tempfile f_`estado'
			save `f_`estado''
			
		}
		
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
		
		foreach k of varlist cpf_candidato ///
			tipo_documento numero_documento descricao_despesa ///
			cpf_cnpj_fornecedor {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_documento cargo tipo_despesa especie_recurso {
			clean_string `var'
		}
		*
		
		gen numero_partido = substr(numero_candidato, 1, 2)
		
		foreach k in despesa {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_despesa = subinstr(valor_despesa, ",", ".", .)
		
		destring numero_candidato* numero_partido, replace force
		
	}
	if `ano' == 2012 {
		
		//---------------//
		// final
		//---------------//
		
		local estados AC AL AM AP BA CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_final_2012/despesas_candidatos_`ano'_`estado'.txt", ///
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
			ren v11	tipo_documento
			ren v12	numero_documento
			ren v13	cpf_cnpj_fornecedor
			ren v14	nome_fornecedor
			ren v15	nome_fornecedor_rf
			ren v16	descricao_cnae_2_fornecedor
			ren v17	data_despesa
			ren v18	valor_despesa
			ren v19	tipo_despesa
			ren v20	descricao_despesa
			
			tempfile f_`estado'
			save `f_`estado''
			
		}
		
		use `f_AC', clear
		foreach estado in `estados' {
			if "`estado'" != "AC" {
				qui append using `f_`estado''
			}
		}
		*
		
		/*
		tempfile final
		save `final'
		
		//---------------//
		// suplementar
		//---------------//
		
		import delimited "input/prestacao_contas/prestacao_contas_final_sup_2016/despesas_candidatos_prestacao_contas_final_sup_2016.txt", ///
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
		ren v14	cpf_vice_suplente
		ren v15	tipo_documento
		ren v16	numero_documento
		ren v17	cpf_cnpj_fornecedor
		ren v18	nome_fornecedor
		ren v19	nome_fornecedor_rf
		ren v20	cnae_2_fornecedor
		ren v21	descricao_cnae_2_fornecedor
		ren v22	data_despesa
		ren v23	valor_despesa
		ren v24	tipo_despesa
		ren v25	descricao_despesa
			
		tempfile suplementar
		save `suplementar'
		
		//-----------------------//
		// limpeza
		//-----------------------//
		
		use `final'
		append using `suplementar'
		*/
		
		foreach k in sigla_uf {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist cpf_candidato ///
			tipo_documento numero_documento descricao_despesa ///
			cpf_cnpj_fornecedor ///
			descricao_cnae_2_fornecedor {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_documento cargo ///
			descricao_cnae_2_fornecedor tipo_despesa {
			clean_string `var'
		}
		*
		
		gen numero_partido = substr(numero_candidato, 1, 2)
		
		replace data_despesa = "20" + data_despesa if length(data_despesa) == 8
		
		replace valor_despesa = subinstr(valor_despesa, ",", ".", .)
		
		destring numero_candidato* numero_partido id_municipio_tse*, replace force
		
	}
	if `ano' == 2014 {
		
		//---------------//
		// final
		//---------------//
		
		local estados AC AL AM AP BA CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_final_2014/despesas_candidatos_`ano'_`estado'.txt", ///
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
			ren v12	tipo_documento
			ren v13	numero_documento
			ren v14	cpf_cnpj_fornecedor
			ren v15	nome_fornecedor
			ren v16	nome_fornecedor_rf
			ren v17	cnae_2_fornecedor
			ren v18	descricao_cnae_2_fornecedor
			ren v19	data_despesa
			ren v20	valor_despesa
			ren v21	tipo_despesa
			ren v22	descricao_despesa
			
			tempfile f_`estado'
			save `f_`estado''
			
		}
		
		use `f_AC', clear
		foreach estado in `estados' {
			if "`estado'" != "AC" {
				qui append using `f_`estado''
			}
		}
		*
		
		/*
		tempfile final
		save `final'
		
		//---------------//
		// suplementar
		//---------------//
		
		import delimited "input/prestacao_contas/prestacao_contas_final_sup_2016/despesas_candidatos_prestacao_contas_final_sup_2016.txt", ///
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
		ren v14	cpf_vice_suplente
		ren v15	tipo_documento
		ren v16	numero_documento
		ren v17	cpf_cnpj_fornecedor
		ren v18	nome_fornecedor
		ren v19	nome_fornecedor_rf
		ren v20	cnae_2_fornecedor
		ren v21	descricao_cnae_2_fornecedor
		ren v22	data_despesa
		ren v23	valor_despesa
		ren v24	tipo_despesa
		ren v25	descricao_despesa
			
		tempfile suplementar
		save `suplementar'
		
		//-----------------------//
		// limpeza
		//-----------------------//
		
		use `final'
		append using `suplementar'
		*/
		
		foreach k in sigla_uf {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist cpf_candidato ///
			tipo_documento numero_documento descricao_despesa ///
			cpf_cnpj_fornecedor ///
			cnae_2_fornecedor descricao_cnae_2_fornecedor {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_eleicao tipo_documento cargo ///
			descricao_cnae_2_fornecedor tipo_despesa {
			clean_string `var'
		}
		*
		
		gen numero_partido = substr(numero_candidato, 1, 2)
		
		foreach k in despesa {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_despesa = subinstr(valor_despesa, ",", ".", .)
		
		limpa_tipo_eleicao `ano'
		
		destring numero_candidato* numero_partido, replace force
		
	}
	if `ano' == 2016 {
		
		//---------------//
		// final
		//---------------//
		
		local estados AC AL AM AP BA CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_contas_final_2016/despesas_candidatos_prestacao_contas_final_`ano'_`estado'.txt", ///
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
			ren v14	cpf_vice_suplente
			ren v15	tipo_documento
			ren v16	numero_documento
			ren v17	cpf_cnpj_fornecedor
			ren v18	nome_fornecedor
			ren v19	nome_fornecedor_rf
			ren v20	cnae_2_fornecedor
			ren v21	descricao_cnae_2_fornecedor
			ren v22	data_despesa
			ren v23	valor_despesa
			ren v24	tipo_despesa
			ren v25	descricao_despesa
			
			tempfile f_`estado'
			save `f_`estado''
			
		}
		
		use `f_AC', clear
		foreach estado in `estados' {
			if "`estado'" != "AC" {
				qui append using `f_`estado''
			}
		}
		*
		
		/*
		//---------------//
		// final
		//---------------//
		
		local estados AC AL AM AP BA CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_contas_final_`ano'/despesas_candidatos_prestacao_contas_final_`ano'_`estado'.txt", ///
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
			ren v14	cpf_vice_suplente
			ren v15	tipo_documento
			ren v16	numero_documento
			ren v17	cpf_cnpj_fornecedor
			ren v18	nome_fornecedor
			ren v19	nome_fornecedor_rf
			ren v20	cnae_2_fornecedor
			ren v21	descricao_cnae_2_fornecedor
			ren v22	data_despesa
			ren v23	valor_despesa
			ren v24	tipo_despesa
			ren v25	descricao_despesa
			
			tempfile f_`estado'
			save `f_`estado''
			
		}
		
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
		
		import delimited "input/prestacao_contas/prestacao_contas_final_sup_2016/despesas_candidatos_prestacao_contas_final_sup_2016.txt", ///
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
		ren v14	cpf_vice_suplente
		ren v15	tipo_documento
		ren v16	numero_documento
		ren v17	cpf_cnpj_fornecedor
		ren v18	nome_fornecedor
		ren v19	nome_fornecedor_rf
		ren v20	cnae_2_fornecedor
		ren v21	descricao_cnae_2_fornecedor
		ren v22	data_despesa
		ren v23	valor_despesa
		ren v24	tipo_despesa
		ren v25	descricao_despesa
			
		tempfile suplementar
		save `suplementar'
		
		//-----------------------//
		// limpeza
		//-----------------------//
		
		use `final'
		append using `suplementar'
		*/
		
		foreach k in sigla_uf {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist cpf_candidato cpf_vice_suplente ///
			tipo_documento numero_documento descricao_despesa ///
			cpf_cnpj_fornecedor ///
			cnae_2_fornecedor descricao_cnae_2_fornecedor {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_eleicao tipo_documento cargo ///
			descricao_cnae_2_fornecedor tipo_despesa {
			clean_string `var'
		}
		*
		
		gen numero_partido = substr(numero_candidato, 1, 2)
		
		foreach k in despesa {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_despesa = subinstr(valor_despesa, ",", ".", .)
		
		limpa_tipo_eleicao `ano'
		
		destring numero_candidato* numero_partido id_municipio_tse*, replace force
		
	}
	if `ano' == 2018 {
		
		local estados AC AL AM AP BA CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_de_contas_eleitorais_candidatos_`ano'/despesas_contratadas_candidatos_`ano'_`estado'.csv", ///
				clear varnames(nonames) delim(";") stringc(_all) // rowr(1:1000)
			
			drop in 1
			drop v1 v2 v3 v4 v6 v7 v8 v15 v17 v27 v34 v38 v41 v48
			
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
			ren v28	tipo_fornecedor
			ren v29	cnae_2_fornecedor
			ren v30	descricao_cnae_2_fornecedor
			ren v31	cpf_cnpj_fornecedor
			ren v32	nome_fornecedor
			ren v33	nome_fornecedor_rf
			ren v35	esfera_partidaria_fornecedor
			ren v36	sigla_uf_fornecedor
			ren v37	id_municipio_tse_fornecedor
			ren v39	sequencial_candidato_fornecedor
			ren v40	numero_candidato_fornecedor
			ren v42	cargo_fornecedor
			ren v43	numero_partido_fornecedor
			ren v44	sigla_partido_fornecedor
			ren v45	nome_partido_fornecedor
			ren v46	tipo_documento
			ren v47	numero_documento
			ren v49	origem_despesa
			ren v50	sequencial_despesa
			ren v51	data_despesa
			ren v52	descricao_despesa
			ren v53	valor_despesa
			
			tempfile f_`estado'
			save `f_`estado''
			
		}
		
		use `f_AC', clear
		foreach estado in `estados' {
			if "`estado'" != "AC" {
				qui append using `f_`estado''
			}
		}
		*
		
		tempfile f_cand
		save `f_cand'
		
		//-----------------------//
		// limpeza
		//-----------------------//
		
		foreach k in sigla_uf {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist cpf_vice_suplente tipo_fornecedor cnae_2_fornecedor descricao_cnae_2_fornecedor ///
			nome_fornecedor nome_fornecedor_rf esfera_partidaria_fornecedor sigla_uf_fornecedor ///
			cpf_cnpj_fornecedor id_municipio_tse_fornecedor sequencial_candidato_fornecedor numero_candidato_fornecedor ///
			cargo_fornecedor numero_partido_fornecedor sigla_partido_fornecedor ///
			nome_partido_fornecedor tipo_documento numero_documento descricao_despesa {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_eleicao cargo tipo_fornecedor origem_despesa tipo_documento tipo_prestacao_contas ///
			descricao_cnae_2_fornecedor {
			clean_string `var'
		}
		*
		
		foreach k in despesa prestacao_contas {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_despesa = subinstr(valor_despesa, ",", ".", .)
		
		limpa_tipo_eleicao `ano'
		
		destring turno numero_candidato* numero_partido* id_municipio_tse*, replace force
		
	}
	*
	if `ano' >= 2020 {
		
		local estados AC AL AM AP BA CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
		
		foreach estado in `estados' {
			
			import delimited "input/prestacao_contas/prestacao_de_contas_eleitorais_candidatos_`ano'/despesas_contratadas_candidatos_`ano'_`estado'.csv", ///
				clear varnames(nonames) delim(";") stringc(_all) // rowr(1:1000)
			
			drop in 1
			drop v1 v2 v3 v4 v6 v7 v8 v15 v17 v27 v34 v38 v41 v48
			
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
			ren v28	tipo_fornecedor
			ren v29	cnae_2_fornecedor
			ren v30	descricao_cnae_2_fornecedor
			ren v31	cpf_cnpj_fornecedor
			ren v32	nome_fornecedor
			ren v33	nome_fornecedor_rf
			ren v35	esfera_partidaria_fornecedor
			ren v36	sigla_uf_fornecedor
			ren v37	id_municipio_tse_fornecedor
			ren v39	sequencial_candidato_fornecedor
			ren v40	numero_candidato_fornecedor
			ren v42	cargo_fornecedor
			ren v43	numero_partido_fornecedor
			ren v44	sigla_partido_fornecedor
			ren v45	nome_partido_fornecedor
			ren v46	tipo_documento
			ren v47	numero_documento
			ren v49	origem_despesa
			ren v50	sequencial_despesa
			ren v51	data_despesa
			ren v52	descricao_despesa
			ren v53	valor_despesa
			
			tempfile f_`estado'
			save `f_`estado''
			
		}
		
		use `f_AC', clear
		foreach estado in `estados' {
			if "`estado'" != "AC" {
				qui append using `f_`estado''
			}
		}
		*
		
		tempfile f_cand
		save `f_cand'
		
		//-----------------------//
		// limpeza
		//-----------------------//
		
		foreach k in sigla_uf {
			replace `k' = "" if `k' == "BR"
		}
		*
		
		foreach k of varlist cpf_vice_suplente cpf_cnpj_fornecedor tipo_fornecedor cnae_2_fornecedor descricao_cnae_2_fornecedor ///
			nome_fornecedor nome_fornecedor_rf esfera_partidaria_fornecedor sigla_uf_fornecedor ///
			id_municipio_tse_fornecedor sequencial_candidato_fornecedor numero_candidato_fornecedor ///
			cargo_fornecedor numero_partido_fornecedor sigla_partido_fornecedor ///
			nome_partido_fornecedor tipo_documento numero_documento descricao_despesa {
			replace `k' = "" if inlist(`k', "#NULO#", "#NULO", "-1")
		}
		*
		
		foreach var of varlist tipo_eleicao cargo tipo_fornecedor origem_despesa tipo_documento tipo_prestacao_contas ///
			descricao_cnae_2_fornecedor {
			clean_string `var'
		}
		*
		
		foreach k in despesa prestacao_contas {
			
			replace data_`k' = "0" + data_`k' if length(data_`k') == 9
			replace data_`k' = substr(data_`k', 7, 4) + "-" + substr(data_`k', 4, 2) + "-" + substr(data_`k', 1, 2) if length(data_`k') > 0
		
		}
		*
		
		replace valor_despesa = subinstr(valor_despesa, ",", ".", .)
		
		limpa_tipo_eleicao `ano'
		
		destring turno numero_candidato* numero_partido* id_municipio_tse*, replace force
		
	}
	*
	
	cap gen id_municipio_tse = .
	merge m:1 id_municipio_tse using `diretorio'
	drop if _merge == 2
	drop _merge
	order id_municipio, b(id_municipio_tse)
	
	gen ano = `ano'
	
	compress
	
	save "output/despesas_candidato_`ano'.dta", replace
	
}
*

