
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

// fonte: https://dados.gov.br/dataset/gestao-de-pessoas-executivo-federal-pensionistas

clear all
set more off

cd "~/Downloads/dados_pensionistas"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

!mkdir "output/microdados"

foreach ano of numlist 1994(1)2021 {
	
	!mkdir "output/microdados/ano=`ano'"
	
	if `ano' <= 2020 local meses 1(1)12
	if `ano' >= 2021 local meses 1(1)5
	
	foreach mes of numlist `meses' {
		
		!mkdir "output/microdados/ano=`ano'/mes=`mes'"
		
		if `mes' < 10  local mes0 = "0`mes'"
		if `mes' >= 10 local mes0 = "`mes'"
		
		if `ano' <= 2019 {
			!gunzip -k "input/`ano'/PENSIONISTAS_`mes0'`ano'.csv.gz"
		}
		if `ano' >= 2020 {
			!unzip -d "input/`ano'" "input/`ano'/PENSIONISTAS_`mes0'`ano'.zip"
		}
		
		import delimited "input/`ano'/PENSIONISTAS_`mes0'`ano'.csv", clear varn(nonames) stringcols(_all) delim(";") bindquotes(nobind) stripquotes(yes)
		
		drop in 1
		drop v29
		
		ren v1	nome_servidor
		ren v2	cpf_servidor
		ren v3	data_nascimento_servidor
		ren v4	data_falecimento_servidor
		ren v5	matricula_servidor
		ren v6	nome_orgao
		ren v7	sigla_orgao
		ren v8	codigo_orgao_superior
		ren v9	cargo_servidor
		ren v10	escolaridade_cargo
		ren v11	classe_servidor
		ren v12	padrao_servidor
		ren v13	referencia_servidor
		ren v14	nivel_servidor
		ren v15	ocorrencia_isp_servidor
		ren v16	data_ocorrencia_isp_servidor
		ren v17	nome_beneficiario
		ren v18	cpf_beneficiario
		ren v19	data_nascimento_beneficiario
		ren v20	sigla_uf_upag_vinculacao
		ren v21	tipo_beneficiario
		ren v22	tipo_pensao
		ren v23	natureza_pensao
		ren v24	data_inicio_beneficio
		ren v25	data_fim_beneficio
		ren v26	rendimento_bruto
		ren v27	rendimento_liquido
		ren v28	pagamento_suspenso
		
		foreach k of varlist cpf* {
			replace `k' = "" if `k' == "00000000000"
		}
		
		foreach k of varlist data* {
			
			replace `k' = "" if `k' == "00000000"
			replace `k' = substr(`k', 5, 4) + "-" + substr(`k', 3, 2) + "-" + substr(`k', 1, 2) if `k' != ""
			
		}
		
		foreach k of varlist rendimento* {
			replace `k' = subinstr(`k', ".", "", .)
			replace `k' = subinstr(`k', ",", ".", .)
			destring `k', replace
		}
		
		/*
		replace pagamento_suspenso = "Não" if pagamento_suspenso == "NAO"
		replace pagamento_suspenso = "Sim" if pagamento_suspenso == "SIM"
		
		replace natureza_pensao = "Temporária" if natureza_pensao == "TEMPORARIA"
		replace natureza_pensao = "Vitalícia" if natureza_pensao == "VITALICIA"
		*/
		
		export delimited "output/microdados/ano=`ano'/mes=`mes'/microdados.csv", replace datafmt
		
		!rm "input/`ano'/PENSIONISTAS_`mes0'`ano'.csv"
	
	}
}
