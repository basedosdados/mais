
cd "~/Downloads/br_me_cnpj"

local datas `" "2021-11-23" "2021-12-24" "2022-01-08" "2022-05-12" "2022-06-30" "2022-07-09" "2022-08-13" "2022-09-11" "2022-10-10" "2022-11-24" "2022-12-17" "2023-01-15" "2023-02-15" "2023-03-22" "2023-05-18" "'
	//  "2023-04-12"

!mkdir -p "output/empresas"
!mkdir -p "output/estabelecimentos"
!mkdir -p "output/socios"
!mkdir -p "output/simples"

foreach data in `datas' {
	
	if "`data'" == "2021-11-23" local subpath "D11009"
	if "`data'" == "2021-12-24" local subpath "D11211"
	if "`data'" == "2022-01-08" local subpath "D20108"
	if "`data'" == "2022-05-12" local subpath "D20409"
	if "`data'" == "2022-06-30" local subpath "D20611"
	if "`data'" == "2022-07-09" local subpath "D20709"
	if "`data'" == "2022-08-13" local subpath "D20813"
	if "`data'" == "2022-09-11" local subpath "D20910"
	if "`data'" == "2022-10-10" local subpath "D21008"
	if "`data'" == "2022-11-24" local subpath "D21119"
	if "`data'" == "2022-12-17" local subpath "D21119"
	if "`data'" == "2023-01-15" local subpath "D30114"
	if "`data'" == "2023-02-15" local subpath "D30211"
	if "`data'" == "2023-03-22" local subpath "D30311"
	//if "`data'" == "2023-04-12" local subpath "D30311"
	if "`data'" == "2023-05-18" local subpath "D30513"
	
	//---------------------------//
	// empresas
	//---------------------------//
	
	!mkdir -p "output/empresas/data=`data'"
	
	foreach j of numlist 0(1)9 {
		
		if inlist("`data'", "2021-11-23", "2021-12-24", "2022-01-08", "2022-05-12") {
			!unzip -o "input/`data'/K3241.K03200Y`j'.`subpath'.EMPRECSV.zip" -d "input/`data'"
		}
		else {
			!unzip -o "input/`data'/Empresas`j'.zip" -d "input/`data'"
		}
		
		import delimited "input/`data'/K3241.K03200Y`j'.`subpath'.EMPRECSV", clear stringcols(_all) //rowr(1:10000)
		
		ren v1 cnpj_basico
		ren v2 razao_social
		ren v3 natureza_juridica
		ren v4 qualificacao_responsavel
		ren v5 capital_social
		ren v6 porte
		ren v7 ente_federativo
		
		destring capital_social, replace dpcomma
		
		replace porte = "0" if porte == "00"
		replace porte = "1" if porte == "01"
		replace porte = "3" if porte == "03"
		replace porte = "5" if porte == "05"
		
		export delimited "output/empresas/data=`data'/empresas_`j'.csv", replace
		
		!rm "input/`data'/K3241.K03200Y`j'.`subpath'.EMPRECSV"
		
	}
	
	//---------------------------//
	// estabelecimentos
	//---------------------------//
	
	!mkdir -p "output/estabelecimentos/data=`data'"
	
	import delimited "input/municipio.csv", clear varn(1) encoding("utf-8")
	keep id_municipio id_municipio_rf
	tempfile municipio
	save `municipio'
	
	foreach j of numlist 0(1)9 {
		
		if inlist("`data'", "2021-11-23", "2021-12-24", "2022-01-08", "2022-05-12") {
			!unzip -o "input/`data'/K3241.K03200Y`j'.`subpath'.ESTABELE.zip" -d "input/`data'"
		}
		else {
			!unzip -o "input/`data'/Estabelecimentos`j'.zip" -d "input/`data'"
		}
		
		if "`data'" == "2022-12-26" & inlist(`j', 1, 5) {
			import delimited "input/`data'/K3241.K03200Y`j'.D21217.ESTABELE", clear stringcols(_all) //rowr(1:10000)
		}
		else {
			import delimited "input/`data'/K3241.K03200Y`j'.`subpath'.ESTABELE", clear stringcols(_all) //rowr(1:10000)
		}
		
		ren v1  cnpj_basico
		ren v2  cnpj_ordem
		ren v3  cnpj_dv
		ren v4	identificador_matriz_filial
		ren v5	nome_fantasia
		ren v6	situacao_cadastral
		ren v7	data_situacao_cadastral
		ren v8	motivo_situacao_cadastral
		ren v9	nome_cidade_exterior
		ren v10	id_pais
		ren v11	data_inicio_atividade
		ren v12	cnae_fiscal_principal
		ren v13	cnae_fiscal_secundaria
		ren v14	tipo_logradouro
		ren v15	logradouro
		ren v16	numero
		ren v17	complemento
		ren v18	bairro
		ren v19	cep
		ren v20	sigla_uf
		ren v21	id_municipio_rf
		ren v22	ddd_1
		ren v23	telefone_1
		ren v24	ddd_2
		ren v25	telefone_2
		ren v26	ddd_fax
		ren v27	fax
		ren v28	email
		ren v29	situacao_especial
		ren v30	data_situacao_especial
		
		gen cnpj = cnpj_basico + cnpj_ordem + cnpj_dv
		order cnpj, b(cnpj_basico)
		
		foreach k in situacao_cadastral motivo_situacao_cadastral {
			replace `k' = "0" if `k' == "00"
			replace `k' = "1" if `k' == "01"
			replace `k' = "2" if `k' == "02"
			replace `k' = "3" if `k' == "03"
			replace `k' = "4" if `k' == "04"
			replace `k' = "5" if `k' == "05"
			replace `k' = "6" if `k' == "06"
			replace `k' = "7" if `k' == "07"
			replace `k' = "8" if `k' == "08"
			replace `k' = "9" if `k' == "09"
		}
		
		destring id_pais, replace	// remove zeros to the left
		tostring id_pais, replace
		replace id_pais = "" if id_pais == "."
		
		foreach k of varlist data_* {
			replace `k' = "" if `k' == "0"
			replace `k' = substr(`k', 1, 4) + "-" + substr(`k', 5, 2) + "-" + substr(`k', 7, 2) if `k' != ""
		}
		
		replace email = lower(email)
		
		destring id_municipio_rf, replace  // remove zeros to the left
		merge m:1 id_municipio_rf using `municipio'
		drop if _merge == 2
		drop _merge
		order id_municipio, b(id_municipio_rf)
		
		order sigla_uf id_municipio id_municipio_rf, b(tipo_logradouro)
		
		levelsof sigla_uf, l(ufs)
		foreach uf in `ufs' {
			!mkdir -p "output/estabelecimentos/data=`data'/sigla_uf=`uf'"
			preserve
				keep if sigla_uf == "`uf'"
				drop sigla_uf
				export delimited "output/estabelecimentos/data=`data'/sigla_uf=`uf'/estabelecimentos_`j'.csv", replace
			restore
		}
		
		if "`data'" == "2022-12-26" & inlist(`j', 1, 5) {
			!rm "input/`data'/K3241.K03200Y`j'.D21217.ESTABELE"
		}
		else {
			!rm "input/`data'/K3241.K03200Y`j'.`subpath'.ESTABELE"
		}
		
	}
	
	//---------------------------//
	// socios
	//---------------------------//
	
	!mkdir -p "output/socios/data=`data'"
	
	foreach j of numlist 0(1)9 {
		
		if inlist("`data'", "2021-11-23", "2021-12-24", "2022-01-08", "2022-05-12") {
			!unzip -o "input/`data'/K3241.K03200Y`j'.`subpath'.SOCIOCSV.zip" -d "input/`data'"
		}
		else {
			!unzip -o "input/`data'/Socios`j'.zip" -d "input/`data'"
		}
		
		import delimited "input/`data'/K3241.K03200Y`j'.`subpath'.SOCIOCSV", clear stringcols(_all) //rowr(1:10000)
		
		ren v1  cnpj_basico
		ren v2  tipo
		ren v3  nome
		ren v4  documento
		ren v5  qualificacao
		ren v6  data_entrada_sociedade
		ren v7  id_pais
		ren v8  cpf_representante_legal
		ren v9  nome_representante_legal
		ren v10 qualificacao_representante_legal
		ren v11 faixa_etaria
		
		foreach k in qualificacao qualificacao_representante_legal {
			replace `k' = "0" if `k' == "00"
			replace `k' = "5" if `k' == "05"
			replace `k' = "6" if `k' == "06"
			replace `k' = "8" if `k' == "08"
			replace `k' = "9" if `k' == "09"
		}
		
		replace cpf_representante_legal = "" if cpf_representante_legal == "***000000**"
		
		foreach k of varlist data_* {
			replace `k' = "" if `k' == "0"
			replace `k' = substr(`k', 1, 4) + "-" + substr(`k', 5, 2) + "-" + substr(`k', 7, 2) if `k' != ""
		}
		
		export delimited "output/socios/data=`data'/socios_`j'.csv", replace
		
		!rm "input/`data'/K3241.K03200Y`j'.`subpath'.SOCIOCSV"
		
	}
	
}

//---------------------------//
// simples
// versão não-painel (pois todas informações estão a nível de cnpj_basico, sem variação no tempo)
//---------------------------//

local data		"2023-05-18"	// última disponível
local subpath	"D30513"

!mkdir -p "output/simples"

// PASSO EXTRA MANUAL: extrair e renomear $ para . (Stata usa $ para globals)
import delimited "input/`data'/F.K03200.W.SIMPLES.CSV.`subpath'", clear stringcols(_all) //rowr(1:10000)

ren v1 cnpj_basico
ren v2 opcao_simples
ren v3 data_opcao_simples
ren v4 data_exclusao_simples
ren v5 opcao_mei
ren v6 data_opcao_mei
ren v7 data_exclusao_mei

replace opcao_simples = "0" if opcao_simples == "N"
replace opcao_simples = "1" if opcao_simples == "S"

replace opcao_mei = "0" if opcao_mei == "N"
replace opcao_mei = "1" if opcao_mei == "S"

foreach k of varlist data_* {
	replace `k' = "" if `k' == "0" | `k' == "00000000"
	replace `k' = substr(`k', 1, 4) + "-" + substr(`k', 5, 2) + "-" + substr(`k', 7, 2) if `k' != ""
}

export delimited "output/simples/simples.csv", replace



