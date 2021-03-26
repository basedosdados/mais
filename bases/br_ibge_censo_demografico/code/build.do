
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all

local raiz "/atalho/para/pasta_do_censo"
cd `raiz'

//----------------------------------------------------------------------------//
// build: datazoom
//----------------------------------------------------------------------------//

local ufs_1970	RO AC AM RR PA AP    FN MA PI CE RN PB PE AL SE BA MG ES RJ GB SP PR SC RS    MT GO DF
local ufs_1980	RO AC AM RR PA AP    FN MA PI CE RN PB PE AL SE BA MG ES RJ    SP PR SC RS MS MT GO DF
local ufs_1991	RO AC AM RR PA AP TO FN MA PI CE RN PB PE AL SE BA MG ES RJ    SP PR SC RS MS MT GO DF
local ufs_2000	RO AC AM RR PA AP TO FN MA PI CE RN PB PE AL SE BA MG ES RJ    SP PR SC RS MS MT GO DF
local ufs_2010	RO AC AM RR PA AP TO FN MA PI CE RN PB PE AL SE BA MG ES RJ    SP PR SC RS MS MT GO DF

foreach ano in 1970 1980 1991 2000 2010 {
	
	if `ano' == 1970	local path_ano Censo_`ano'
	if `ano' == 1980	local path_ano Censo_`ano'/novos
	if `ano' == 1991	local path_ano Censo_`ano'
	if `ano' == 2000	local path_ano Censo_`ano'
	if `ano' == 2010	local path_ano Censo_`ano'
	
	//------------------//
	// isolado
	//------------------//
	
	datazoom_censo, pes ///
		years(`ano') ///
		ufs(`ufs_`ano'') ///
		original("`raiz'/input/DadosOriginais/`path_ano'") ///
		saving("`raiz'/tmp")
	
	datazoom_censo, dom ///
		years(`ano') ///
		ufs(`ufs_`ano'') ///
		original("`raiz'/input/DadosOriginais/`path_ano'") ///
		saving("`raiz'/tmp")
	
	//------------------//
	// compatibilizado
	//------------------//
	
	datazoom_censo, pes comp ///
		years(`ano') ///
		ufs(`ufs_`ano'') ///
		original("`raiz'/input/DadosOriginais/`path_ano'") ///
		saving("`raiz'/tmp")
	
	datazoom_censo, dom comp ///
		years(`ano') ///
		ufs(`ufs_`ano'') ///
		original("`raiz'/input/DadosOriginais/`path_ano'") ///
		saving("`raiz'/tmp")
	
}
*

//----------------------------------------------------------------------------//
// limpeza e particionamento
//----------------------------------------------------------------------------//

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) encoding("utf-8")
keep id_municipio id_municipio_6 sigla_uf
tempfile munic
save `munic'

//-------------------------------------//
// separados
//-------------------------------------//

local ufs_1970	RO AC AM RR PA AP    FN MA PI CE RN PB PE AL SE BA MG ES RJ GB SP PR SC RS    MT GO DF
local ufs_1980	RO AC AM RR PA AP    FN MA PI CE RN PB PE AL SE BA MG ES RJ    SP PR SC RS MS MT GO DF
local ufs_1991	RO AC AM RR PA AP TO    MA PI CE RN PB PE AL SE BA MG ES RJ    SP PR SC RS MS MT GO DF
local ufs_2000	RO AC AM RR PA AP TO    MA PI CE RN PB PE AL SE BA MG ES RJ    SP PR SC RS MS MT GO DF
local ufs_2010	RO AC AM RR PA AP TO    MA PI CE RN PB PE AL SE BA MG ES RJ    SP PR SC RS MS MT GO DF

foreach ano in 1970 1980 1991 2000 2010 {
	
	if `ano' == 1970	local ano_YY 70
	if `ano' == 1980	local ano_YY 80
	if `ano' == 1991	local ano_YY 91
	if `ano' == 2000	local ano_YY 00
	if `ano' == 2010	local ano_YY 10
	
	//-----------------------//
	// domicilio
	//-----------------------//
	
	! mkdir "output/microdados_domicilio_`ano'"
	
	foreach uf in `ufs_`ano'' {
		
		! mkdir "output/microdados_domicilio_`ano'/sigla_uf=`uf'"
		
		use "tmp/CENSO`ano_YY'_`uf'_dom.dta", clear
		
		if `ano' == 1970 {
			
			drop ano
			
			gen cod70 = substr(v001,1,2) + v002
			
			merge m:1 cod70 using "input/DadosOriginais/Censo_1970/cod1970.dta"
			drop if _merge == 2
			drop _merge cod70 uf_munic
			
			ren munic	id_municipio_6
			
			merge m:1 id_municipio_6 using `munic'
			drop if _merge == 2
			drop _merge id_municipio_6 UF
			
			ren id_dom	id_domicilio
			ren num_fam	numero_familia
			
			order sigla_uf id_municipio
			
		}
		if `ano' == 1980 {
			
			gen id_municipio_6 = real(string(v2) + v5)
			
			merge m:1 id_municipio_6 using `munic'
			drop if _merge == 2
			drop _merge v2 v5 id_municipio_6
			
			gen id_distrito = real(string(id_municipio) + v6)
			format id_distrito %9.0f
			drop v6
			
			order sigla_uf id_municipio id_distrito
			
		}
		if `ano' == 1991 {
			
			drop ano v1101 v1102 v7001 v7002 v7004
			
			ren v0102	id_questionario
			ren v7300	peso_amostral
			ren munic	id_municipio_6
			
			merge m:1 id_municipio_6 using `munic'
			drop if _merge == 2
			drop _merge id_municipio_6
			
			order sigla_uf id_municipio id_questionario peso_amostral
			
		}
		if `ano' == 2000 {
			
			drop v0102 ano munic
			
			ren v1001	id_regiao
			ren v1002	id_mesorregiao
			ren v1003	id_microrregiao
			ren v1004	id_regiao_metropolitana
			ren v0103	id_municipio
			ren v0104	id_distrito
			ren v0105	id_subdistrito
			ren v0300	controle
			ren v1005	situacao_setor
			ren v1006	situacao_domicilio
			ren v1007	tipo_setor
			ren AREAP	area_ponderacao
			ren P001	peso_amostral
			
			order id_regiao id_mesorregiao id_microrregiao id_regiao_metropolitana id_municipio id_distrito id_subdistrito ///
				controle situacao_setor situacao_domicilio tipo_setor peso_amostral area_ponderacao
			
		}
		if `ano' == 2010 {
			
			drop ano v0001 v0002
			
			ren v0010	peso_amostral
			ren v0011	area_ponderacao
			ren v0300	controle
			ren v1001	id_regiao
			ren v1002	id_mesorregiao
			ren v1003	id_microrregiao
			ren v1004	id_regiao_metropolitana
			ren v1005	situacao_setor
			ren v1006	situacao_domicilio
			ren munic	id_municipio_6
			
			merge m:1 id_municipio_6 using `munic'
			drop if _merge == 2
			drop _merge id_municipio_6
			
			order id_regiao sigla_uf id_mesorregiao id_microrregiao id_regiao_metropolitana id_municipio ///
				situacao_setor situacao_domicilio controle peso_amostral area_ponderacao
		
		}
		*
		
		cap drop sigla_uf
		
		export delimited "output/microdados_domicilio_`ano'/sigla_uf=`uf'/microdados_domicilio_`ano'.csv", replace
		
	}
	*
	
	//-----------------------//
	// pessoa
	//-----------------------//
	
	! mkdir "output/microdados_pessoa_`ano'"
	
	foreach uf in `ufs_`ano'' {
		
		! mkdir "output/microdados_pessoa_`ano'/sigla_uf=`uf'"
		
		use "tmp/CENSO`ano_YY'_`uf'_pes.dta", clear
		
		if `ano' == 1970 {
			
			ren munic	id_municipio_6
			ren id_dom	id_domicilio
			ren num_fam	numero_familia
			
			merge m:1 id_municipio_6 using `munic'
			drop if _merge == 2
			drop _merge
			
			drop ano cod70 id_municipio_6 UF
			
			order sigla_uf id_municipio
			
		}
		if `ano' == 1980 {
			
			drop ano v2 v5 v6
			
			ren v500	numero_ordem
			ren munic	id_municipio_6
			
			merge m:1 id_municipio_6 using `munic'
			drop if _merge == 2
			drop _merge id_municipio_6
			
			order sigla_uf id_municipio
			
		}
		if `ano' == 1991 {
			
			drop ano v1101 v1102 v7002 v7004
			
			ren v0102	id_questionario
			ren v0098	numero_ordem
			ren munic	id_municipio_6
			
			merge m:1 id_municipio_6 using `munic'
			drop if _merge == 2
			drop _merge id_municipio_6
			
			order sigla_uf id_municipio
			
		}
		if `ano' == 2000 {
			
			drop v0102 ano munic
			
			ren v1002	id_mesorregiao
			ren v1003	id_microrregiao
			ren v1004	id_regiao_metropolitana
			ren v0103	id_municipio
			ren v0104	id_distrito
			ren v0105	id_subdistrito
			ren v0300	controle
			ren v0400	serie
			ren AREAP	area_ponderacao
			
		}
		if `ano' == 2010 {
			
			drop ano v0001 v0002
			
			ren v0010	peso_amostral
			ren v0011	area_ponderacao
			ren v0300	controle
			ren v1001	id_regiao
			ren v1002	id_mesorregiao
			ren v1003	id_microrregiao
			ren v1004	id_regiao_metropolitana
			ren v1005	situacao_setor
			ren v1006	situacao_domicilio
			ren v0504	numero_ordem
			ren munic	id_municipio_6
			
			merge m:1 id_municipio_6 using `munic'
			drop if _merge == 2
			drop _merge id_municipio_6
			
			order id_regiao sigla_uf id_mesorregiao id_microrregiao id_regiao_metropolitana id_municipio ///
				area_ponderacao situacao_setor situacao_domicilio controle numero_ordem
		
		}
		*
		
		cap drop sigla_uf
		
		export delimited "output/microdados_pessoa_`ano'/sigla_uf=`uf'/microdados_pessoa_`ano'.csv", replace
		
	}
}
*
