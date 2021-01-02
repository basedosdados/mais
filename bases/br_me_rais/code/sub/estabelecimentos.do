
//----------------------------------------------------------------------------//
// build: microdados - estabelecimentos
//----------------------------------------------------------------------------//

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) encoding("utf-8")

keep id_municipio id_municipio_6
tostring id_municipio id_municipio_6, replace force

tempfile dir_munic
save `dir_munic'

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) encoding("utf-8")

keep id_uf sigla_uf
duplicates drop
tostring id_uf, replace

tempfile dir_uf
save `dir_uf'

!mkdir "output/microdados_estabelecimentos"

foreach ano of numlist 1985(1)2019 {
	
	if `ano' >= 1985 & `ano' <= 2001	local arquivo ESTB`ano'
	if `ano' == 2002					local arquivo consulta21554418
	if `ano' == 2003					local arquivo consulta66624895
	if `ano' == 2004					local arquivo consulta44651176
	if `ano' == 2005					local arquivo consulta8599625
	if `ano' == 2006					local arquivo consulta60747774
	if `ano' == 2007					local arquivo ESTB`ano'
	if `ano' == 2008					local arquivo Estb`ano'
	if `ano' >= 2009 & `ano' <= 2011	local arquivo ESTB`ano'
	if `ano' == 2012					local arquivo Estb`ano'
	if `ano' >= 2013 & `ano' <= 2017	local arquivo ESTB`ano'
	if `ano' >= 2018 & `ano' <= 2019	local arquivo RAIS_ESTAB_PUB
	
	import delimited "input/`ano'/`arquivo'.txt", clear varn(nonames) delim(";") case(preserve) stringcols(_all)
	
	drop in 1
	
	if `ano' == 1985 | (`ano' >= 1989 & `ano' <= 1990) {

		ren v1	bairros_sp
		ren v2	qtde_vinculos_ativos
		ren v3	id_municipio_6
		ren v4	tamanho_estabelecimento
		ren v5	tipo_estabelecimento
		ren v6	sigla_uf
		ren v7	subsetor_ibge
		ren v8	subatividade_ibge
		
	}
	if (`ano' >= 1986 & `ano' <= 1988) | (`ano' >= 1991 & `ano' <= 1992) {
		
		ren v1	bairros_sp
		ren v2	qtde_vinculos_ativos
		ren v3	distritos_sp
		ren v4	id_municipio_6
		ren v5	tamanho_estabelecimento
		ren v6	tipo_estabelecimento
		ren v7	sigla_uf
		ren v8	subsetor_ibge
		ren v9	subatividade_ibge
		
	}
	if `ano' == 1993 {
		
		ren v1	qtde_vinculos_ativos
		ren v2	id_municipio_6
		ren v3	tamanho_estabelecimento
		ren v4	tipo_estabelecimento
		ren v5	sigla_uf
		ren v6	subsetor_ibge
		ren v7	subatividade_ibge
		
	}
	if `ano' == 1994 {
		
		ren v1	bairros_sp
		ren v2	cnae_1
		ren v3	distritos_sp
		ren v4	qtde_vinculos_ativos
		ren v5	id_municipio_6
		ren v6	natureza_estabelecimento
		ren v7	tamanho_estabelecimento
		ren v8	tipo_estabelecimento
		ren v9	sigla_uf
		ren v10	subsetor_ibge
		ren v11	subatividade_ibge
		
	}
	if `ano' == 1995 {
		
		ren v1	bairros_sp
		ren v2	cnae_1
		ren v3	distritos_sp
		ren v4	qtde_vinculos_ativos
		ren v5	indicador_rais_negativa
		ren v6	id_municipio_6
		ren v7	natureza_juridica
		ren v8	tamanho_estabelecimento
		ren v9	tipo_estabelecimento
		ren v10	sigla_uf
		ren v11	subsetor_ibge
		
	}
	if `ano' == 1996 {
		
		ren v1	bairros_sp
		ren v2	bairros_fortaleza
		ren v3	bairros_rj
		ren v4	cnae_1
		ren v5	distritos_sp
		ren v6	qtde_vinculos_ativos
		ren v7	indicador_rais_negativa
		ren v8	id_municipio_6
		ren v9	natureza_juridica
		ren v10	regioes_administrativas_df
		ren v11	tamanho_estabelecimento
		ren v12	tipo_estabelecimento
		ren v13	sigla_uf
		ren v14	subsetor_ibge
		
	}
	if `ano' == 1997 {
		
		ren v1	bairros_fortaleza
		ren v2	bairros_rj
		ren v3	cnae_1
		ren v4	qtde_vinculos_ativos
		ren v5	indicador_rais_negativa
		ren v6	id_municipio_6
		ren v7	natureza_juridica
		ren v8	regioes_administrativas_df
		ren v9	tamanho_estabelecimento
		ren v10	tipo_estabelecimento
		ren v11	sigla_uf
		ren v12	subsetor_ibge
		
	}
	if `ano' == 1998 {
		
		ren v1	bairros_sp
		ren v2	bairros_fortaleza
		ren v3	bairros_rj
		ren v4	cnae_1
		ren v5	distritos_sp
		ren v6	qtde_vinculos_ativos
		ren v7	indicador_rais_negativa
		ren v8	id_municipio_6
		ren v9	natureza_juridica
		ren v10	regioes_administrativas_df
		ren v11	tamanho_estabelecimento
		ren v12	tipo_estabelecimento
		ren v13	sigla_uf
		ren v14	subsetor_ibge
		
	}
	if `ano' >= 1999 & `ano' <= 2000 {
		
		ren v1	bairros_sp
		ren v2	bairros_fortaleza
		ren v3	bairros_rj
		ren v4	cnae_1
		ren v5	distritos_sp
		ren v6	qtde_vinculos_ativos
		ren v7	indicador_cei_vinculado
		ren v8	indicador_pat
		ren v9	indicador_rais_negativa
		ren v10	indicador_simples
		ren v11	id_municipio_6
		ren v12	natureza_juridica
		ren v13	regioes_administrativas_df
		ren v14	tamanho_estabelecimento
		ren v15	tipo_estabelecimento
		ren v16	sigla_uf
		ren v17	subsetor_ibge
		
	}
	if `ano' == 2001 {
		
		ren v1	bairros_sp
		ren v2	bairros_fortaleza
		ren v3	bairros_rj
		ren v4	cnae_1
		ren v5	distritos_sp
		ren v6	qtde_vinculos_clt
		ren v7	qtde_vinculos_ativos
		ren v8	qtde_vinculos_estatutarios
		ren v9	indicador_cei_vinculado
		ren v10	indicador_pat
		ren v11	indicador_rais_negativa
		ren v12	indicador_simples
		ren v13	id_municipio_6
		ren v14	natureza_juridica
		ren v15	tamanho_estabelecimento
		ren v16	regioes_administrativas_df
		ren v17	tipo_estabelecimento
		ren v18	sigla_uf
		ren v19	subsetor_ibge
		
	}
	if `ano' >= 2002 & `ano' <= 2004 {
		
		drop v17
		
		ren v1	bairros_sp
		ren v2	bairros_fortaleza
		ren v3	bairros_rj
		ren v4	cnae_1
		ren v5	distritos_sp
		ren v6	qtde_vinculos_clt
		ren v7	qtde_vinculos_ativos
		ren v8	qtde_vinculos_estatutarios
		ren v9	indicador_cei_vinculado
		ren v10	indicador_pat
		ren v11	indicador_rais_negativa
		ren v12	indicador_simples
		ren v13	id_municipio_6
		ren v14	natureza_juridica
		ren v15	regioes_administrativas_df
		ren v16	tamanho_estabelecimento
		ren v18	tipo_estabelecimento
		
	}
	if `ano' == 2005 {
		
		drop v18
		
		ren v1	bairros_sp
		ren v2	bairros_fortaleza
		ren v3	bairros_rj
		ren v4	cnae_1
		ren v5	distritos_sp
		ren v6	qtde_vinculos_clt
		ren v7	qtde_vinculos_ativos
		ren v8	qtde_vinculos_estatutarios
		ren v9	indicador_atividade_ano
		ren v10	indicador_cei_vinculado
		ren v11	indicador_pat
		ren v12	indicador_rais_negativa
		ren v13	indicador_simples
		ren v14	id_municipio_6
		ren v15	natureza_juridica
		ren v16	regioes_administrativas_df
		ren v17	tamanho_estabelecimento
		ren v19	tipo_estabelecimento
		
	}
	if `ano' >= 2006 & `ano' <= 2013 {
		
		drop v20
		if `ano' == 2013 drop v22
		
		ren v1	bairros_sp
		ren v2	bairros_fortaleza
		ren v3	bairros_rj
		ren v4	cnae_2
		ren v5	cnae_1
		ren v6	distritos_sp
		ren v7	qtde_vinculos_clt
		ren v8	qtde_vinculos_ativos
		ren v9	qtde_vinculos_estatutarios
		ren v10	indicador_atividade_ano
		ren v11	indicador_cei_vinculado
		ren v12	indicador_pat
		ren v13	indicador_rais_negativa
		ren v14	indicador_simples
		ren v15	id_municipio_6
		ren v16	natureza_juridica
		ren v17	regioes_administrativas_df
		ren v18	cnae_2_subclasse
		ren v19	tamanho_estabelecimento
		ren v21	tipo_estabelecimento
		
	}
	if `ano' >= 2014 & `ano' <= 2019 {
		
		drop v20 v22
		
		ren v1	bairros_sp
		ren v2	bairros_fortaleza
		ren v3	bairros_rj
		ren v4	cnae_2
		ren v5	cnae_1
		ren v6	distritos_sp
		ren v7	qtde_vinculos_clt
		ren v8	qtde_vinculos_ativos
		ren v9	qtde_vinculos_estatutarios
		ren v10	indicador_atividade_ano
		ren v11	indicador_cei_vinculado
		ren v12	indicador_pat
		ren v13	indicador_rais_negativa
		ren v14	indicador_simples
		ren v15	id_municipio_6
		ren v16	natureza_juridica
		ren v17	regioes_administrativas_df
		ren v18	cnae_2_subclasse
		ren v19	tamanho_estabelecimento
		ren v21	tipo_estabelecimento
		ren v23	subsetor_ibge
		ren v24	cep_estabelecimento
		
	}
	*
	
	//--------------------------//
	// adiciona identificadores
	//--------------------------//
	
	merge m:1 id_municipio_6 using `dir_munic'
	drop if _merge == 2
	drop _merge
	
	cap drop sigla_uf
	gen id_uf = substr(id_municipio_6, 1, 2)
	merge m:1 id_uf using `dir_uf'
	drop if _merge == 2
	drop _merge id_uf
	
	replace sigla_uf = "IGNORADO" if sigla_uf == ""
	
	//--------------------------//
	// padroniza variáveis e dados
	//--------------------------//
	
	foreach k of varlist _all {
		
		replace `k' = trim(`k')
		replace `k' = "" if inlist(`k', "{ñ", "{ñ class}", "{ñ c")
		
	}
	*
	
	local vars	sigla_uf id_municipio id_municipio_6 ///
				qtde_vinculos_ativos qtde_vinculos_clt qtde_vinculos_estatutarios ///
				natureza_estabelecimento natureza_juridica tamanho_estabelecimento tipo_estabelecimento ///
				indicador_cei_vinculado indicador_pat indicador_simples indicador_rais_negativa indicador_atividade_ano ///
				cnae_1 cnae_2 cnae_2_subclasse subsetor_ibge subatividade_ibge ///
				cep_estabelecimento bairros_sp distritos_sp bairros_fortaleza bairros_rj regioes_administrativas_df
	
	foreach var in `vars' {
		cap confirm variable `var'
		if _rc {
			gen `var' = ""
		}
	}
	*
	
	foreach k of varlist _all {
		
		replace `k' = trim(`k')
		replace `k' = "" if inlist(`k', "{ñ", "{ñ class}", "{ñ c", "{ñ clas")
		
	}
	*
	
	foreach k of varlist bairros_* distritos_sp regioes_administrativas_df ///
		id_municipio_6 ///
		cnae_2 cnae_2_subclasse subsetor_ibge subatividade_ibge {
		replace `k' = "" if inlist(`k', "0000", "00000", "000000", "0000000", "0000-1", "000-1") | ///
							inlist(`k', "998", "999", "00", "-1")
	}
	*
	
	replace tipo_estabelecimento = "CNPJ"	if inlist(tipo_estabelecimento, "Cnpj", "01", "1")
	replace tipo_estabelecimento = "CEI"	if inlist(tipo_estabelecimento, "Cei", "03", "3")
	replace tipo_estabelecimento = ""		if inlist(tipo_estabelecimento, "-1")
	
	destring id_municipio id_municipio_6 qtde_* tamanho_estabelecimento indicador_*, replace
	
	order `vars'
	
	tempfile estab
	save `estab'
	
	//--------------------------//
	// particiona
	//--------------------------//
	
	!mkdir "output/microdados_estabelecimentos/ano=`ano'"
	
	levelsof sigla_uf, l(intra_ufs)
	foreach intra_uf in `intra_ufs' {
		
		!mkdir "output/microdados_estabelecimentos/ano=`ano'/sigla_uf=`intra_uf'"
		
		use `estab', clear
		keep if sigla_uf == "`intra_uf'"
		drop sigla_uf
		export delimited "output/microdados_estabelecimentos/ano=`ano'/sigla_uf=`intra_uf'/microdados_estabelecimentos.csv", replace
		
	}
}
*
