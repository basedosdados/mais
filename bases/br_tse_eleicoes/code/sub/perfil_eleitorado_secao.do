
//----------------------------------------------------------------------------//
// build: perfil eleitorado - secao eleitoral
//----------------------------------------------------------------------------//

//------------------------//
// listas de estados
//------------------------//

local estados_2008	AC AL AM AP BA CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2010	AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2012	AC AL AM AP BA CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2014	AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2016	AC AL AM AP BA CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2018	AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO ZZ
local estados_2020	AC AL AM AP BA CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
local estados_2022	AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO ZZ

//------------------------//
// loops
//------------------------//

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) case(preserve)
keep id_municipio id_municipio_tse
tempfile diretorio
save `diretorio'

foreach ano of numlist 2008(2)2022 {
	
	foreach estado in `estados_`ano'' {
		
		if `ano' <= 2010 {
			
			cap import delimited "input/perfil_eleitorado_secao/perfil_eleitor_secao_`ano'_`estado'.txt", delim(";") stringcols(_all) clear
			cap import delimited "input/perfil_eleitorado_secao/perfil_eleitor_secao_`ano'_`estado'.csv", delim(";") stringcols(_all) clear
		
		}
		else {
			
			cap import delimited "input/perfil_eleitorado_secao/perfil_eleitor_secao_`ano'_`estado'/perfil_eleitor_secao_`ano'_`estado'.txt", delim(";") stringcols(_all) clear
			cap import delimited "input/perfil_eleitorado_secao/perfil_eleitor_secao_`ano'_`estado'/perfil_eleitor_secao_`ano'_`estado'.csv", delim(";") stringcols(_all) clear
		
		}
		
		if "`estado'" == "DF" & `ano' == 2014 gen situacao_biometrica = ""
		
		keep ano_eleicao sg_uf cd_municipio cd_mun_sit_biometrica nr_zona nr_secao ///
			cd_genero cd_estado_civil cd_faixa_etaria cd_grau_escolaridade ///
			qt_eleitores_perfil qt_eleitores_biometria qt_eleitores_deficiencia qt_eleitores_inc_nm_social
		
		ren ano_eleicao					ano
		ren sg_uf						sigla_uf
		ren cd_municipio				id_municipio_tse
		ren cd_mun_sit_biometrica		situacao_biometria
		ren nr_zona						zona
		ren nr_secao					secao
		ren cd_genero					genero
		ren cd_estado_civil				estado_civil
		ren cd_faixa_etaria				grupo_idade
		ren cd_grau_escolaridade		instrucao
		ren qt_eleitores_perfil			eleitores
		ren qt_eleitores_biometria		eleitores_biometria
		ren qt_eleitores_deficiencia	eleitores_deficiencia
		ren qt_eleitores_inc_nm_social	eleitores_inclusao_nome_social
		
		foreach k of varlist eleitores* {
			
			cap replace `k' = "" if `k' == "-1"
			
		}
		*
		
		destring id_municipio_tse zona secao eleitores*, replace force
		
		collapse (sum) eleitores*, by(ano sigla_uf id_municipio_tse situacao_biometria zona secao genero estado_civil grupo_idade instrucao) // depois da limpeza de strings
		
		merge m:1 id_municipio_tse using `diretorio'
		drop if _merge == 2
		drop _merge
		order id_municipio, b(id_municipio_tse)
		
		tempfile perfil_`ano'_`estado'
		save `perfil_`ano'_`estado''
		
	}
	*
	
	use `perfil_`ano'_AC', clear
	foreach estado in `estados_`ano'' {
		if "`estado'" != "AC" {
			append using `perfil_`ano'_`estado''
		}
	}
	*
	
	compress
	
	save "output/perfil_eleitorado_secao_`ano'.dta", replace

}
*
