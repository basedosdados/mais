
//-----------------------------------//
// empresa
//-----------------------------------//

import delimited "input/municipios.csv", clear varn(1) stringc(_all) case(preserve)

keep id_municipio id_municipio_RF

tempfile municipios
save `municipios'

import delimited "input/estados.csv", clear varn(1) stringc(_all)

keep id_estado estado_abrev

tempfile estados
save `estados'

//------------//
// serializa
//------------//

local BLOCK_SIZE = 1000000

!mkdir "output/empresa"

foreach estado in AC AL AM AP BA CE DF ES EX GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO {
	
	!mkdir "output/empresa/estado_abrev=`estado'"
	
	local i = 1
	local cond = "TRUE"
	
	while "`cond'" == "TRUE" { // & `i' <= 3
		
		di "i = `i'"
		
		local row_start = (`i' - 1) * `BLOCK_SIZE' + 1
		local row_end = `i' * `BLOCK_SIZE'
		import delimited "input/empresa.csv", clear varn(nonames) stringc(_all) rowr(`row_start':`row_end')
		
		drop if v1 == "cnpj"
		
		ren v1	CNPJ
		ren v2	identificador_matriz_filial
		ren v3	razao_social
		ren v4	nome_fantasia
		ren v5	situacao_cadastral
		ren v6	data_situacao_cadastral
		ren v7	motivo_situacao_cadastral
		ren v8	nome_cidade_exterior
		ren v9	codigo_natureza_juridica
		ren v10	data_inicio_atividade
		ren v11	CNAE_fiscal
		ren v12	descricao_tipo_logradouro
		ren v13	logradouro
		ren v14	numero
		ren v15	complemento
		ren v16	bairro
		ren v17	CEP
		ren v18	estado_abrev
		ren v19	codigo_municipio
		ren v20	municipio
		ren v21	DDD_telefone_1
		ren v22	DDD_telefone_2
		ren v23	DDD_fax
		ren v24	qualificacao_do_responsavel
		ren v25	capital_social
		ren v26	porte
		ren v27	opcao_pelo_simples
		ren v28	data_opcao_pelo_simples
		ren v29	data_exclusao_do_simples
		ren v30	opcao_pelo_MEI
		ren v31	situacao_especial
		ren v32	data_situacao_especial
		
		keep if estado_abrev == "`estado'"
		
		drop municipio
		
		merge m:1 estado_abrev using `estados'
		drop if _merge == 2
		drop _merge id_estado
		
		ren codigo_municipio id_municipio_RF
		merge m:1 id_municipio_RF using `municipios'
		drop if _merge == 2
		order id_municipio, a(id_municipio_RF)
		drop _merge
		
		replace razao_social				= ustrtitle(razao_social)
		replace nome_fantasia				= ustrtitle(nome_fantasia)
		replace descricao_tipo_logradouro	= lower(razao_social)
		replace logradouro					= ustrtitle(logradouro)
		replace complemento					= ustrtitle(complemento)
		replace bairro						= ustrtitle(bairro)
		
		tempfile empresa_`estado'_`i'
		save `empresa_`estado'_`i''
		
		//-------------------//
		// atualiza counters
		//-------------------//
		
		local i = `i' + 1
		
		if _N < `BLOCK_SIZE' - 1 {
			
			local cond = "FALSE"
			
		}
		else {
			
			local cond = "TRUE"
			
		}
	}
	*
	
	//------------//
	// append
	//------------//
	
	use `empresa_`estado'_1', clear
	
	local ub = `i' - 1
	foreach n of numlist 2(1)`ub' {
		
		append using `empresa_`estado'_`n''
		
	}
	*
	
	drop estado_abrev
	export delimited "output/empresa/estado_abrev=`estado'/empresa.csv", replace
	
}
*

//-----------------------------------//
// socio
//-----------------------------------//

import delimited "input/socio.csv", clear varn(1) stringc(_all) case(preserve)

ren cnpj								CNPJ
ren cnpj_cpf_do_socio					CNPJ_CPF_do_socio
ren cpf_representante_legal				CPF_representante_legal

//a
ren codigo_qualificacao_representant	codigo_qual_representante_legal

replace nome_socio					= ustrtitle(nome_socio)
replace nome_representante_legal	= ustrtitle(nome_representante_legal)

gen ano_entrada_sociedade = real(substr(data_entrada_sociedade, 1, 4))
order ano_entrada_sociedade, a(data_entrada_sociedade)

tempfile socio
save `socio'

//------------//
// particiona
//------------//

!mkdir "output/socio"

use `socio', clear

levelsof ano_entrada_sociedade, l(anos)

foreach ano in `anos' {
	
	!mkdir "output/socio/ano_entrada_sociedade=`ano'"
	
	use `socio', clear
	keep if ano_entrada_sociedade == `ano'
	drop ano_entrada_sociedade
	export delimited "output/socio/ano_entrada_sociedade=`ano'/socio.csv", replace
	
}
*

//-----------------------------------//
// holding
//-----------------------------------//

import delimited "input/holding.csv", clear varn(1) stringc(_all) case(preserve) encoding("utf-8")

ren holding_cnpj			CNPJ_holding
ren holding_razao_social	razao_social_holding
ren cnpj					CNPJ

replace razao_social_holding	= ustrtitle(razao_social_holding)
replace razao_social			= ustrtitle(razao_social)

export delimited "output/holding.csv", replace

//-----------------------------------//
// CNAE-CNPJ
//-----------------------------------//

import delimited "input/cnae_cnpj.csv", clear varn(1) stringc(_all) case(preserve)

ren cnpj	CNPJ
ren cnae	CNAE

export delimited "output/cnae_cnpj.csv", replace


//-----------------------------------//
// CNAE secundaria
//-----------------------------------//

import delimited "input/cnae_secundaria.csv", clear varn(1) stringc(_all) case(preserve)

ren cnpj	CNPJ
ren cnae	CNAE

export delimited "output/cnae_secundaria.csv", replace

