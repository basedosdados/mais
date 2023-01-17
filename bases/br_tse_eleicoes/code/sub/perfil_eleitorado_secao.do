
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

foreach ano of numlist 2022 { //2008(2)2022 {
	
	foreach estado in `estados_`ano'' {
		
		if `ano' <= 2010 {
			
			cap import delimited "input/perfil_eleitorado_secao/perfil_eleitor_secao_`ano'_`estado'/perfil_eleitor_secao_`ano'_`estado'.txt", delim(";") stringcols(_all) varn(nonames) clear
			cap import delimited "input/perfil_eleitorado_secao/perfil_eleitor_secao_`ano'_`estado'/perfil_eleitor_secao_`ano'_`estado'.csv", delim(";") stringcols(_all) varn(nonames) clear
			
			keep v3 v4 v5 v7 v8 v10 v12 v14 v16 v17
			
			ren v3	ano
			ren v4	sigla_uf
			ren v5	id_municipio_tse
			ren v7	zona
			ren v8	secao
			ren v10	estado_civil
			ren v12	grupo_idade
			ren v14	instrucao
			ren v16	genero
			ren v17	eleitores
			
			gen situacao_biometria = ""
			gen eleitores_biometria = ""
			gen eleitores_deficiencia = ""
			gen eleitores_inclusao_nome_social = ""
			
			order ano sigla_uf id_municipio_tse situacao_biometria zona secao ///
				genero estado_civil grupo_idade instrucao ///
				eleitores eleitores_biometria eleitores_deficiencia eleitores_inclusao_nome_social
			
		}
		if `ano' == 2012 {
			
			cap import delimited "input/perfil_eleitorado_secao/perfil_eleitor_secao_`ano'_`estado'/perfil_eleitor_secao_`ano'_`estado'.txt", delim(";") stringcols(_all) clear
			cap import delimited "input/perfil_eleitorado_secao/perfil_eleitor_secao_`ano'_`estado'/perfil_eleitor_secao_`ano'_`estado'.csv", delim(";") stringcols(_all) clear
			
			keep ano_eleicao sg_uf cd_municipio ds_mun_sit_biometria nr_zona nr_secao ///
				ds_genero ds_estado_civil ds_faixa_etaria ds_grau_escolaridade ///
				qt_eleitores_perfil qt_eleitores_biometria qt_eleitores_deficiencia qt_eleitores_inc_nm_social
			
			ren ano_eleicao					ano
			ren sg_uf						sigla_uf
			ren cd_municipio				id_municipio_tse
			ren ds_mun_sit_biometria		situacao_biometria
			ren nr_zona						zona
			ren nr_secao					secao
			ren ds_genero					genero
			ren ds_estado_civil				estado_civil
			ren ds_faixa_etaria				grupo_idade
			ren ds_grau_escolaridade		instrucao
			ren qt_eleitores_perfil			eleitores
			ren qt_eleitores_biometria		eleitores_biometria
			ren qt_eleitores_deficiencia	eleitores_deficiencia
			ren qt_eleitores_inc_nm_social	eleitores_inclusao_nome_social
			
		}
		if `ano' >= 2014 {
			
			cap import delimited "input/perfil_eleitorado_secao/perfil_eleitor_secao_`ano'_`estado'/perfil_eleitor_secao_`ano'_`estado'.txt", delim(";") stringcols(_all) clear
			cap import delimited "input/perfil_eleitorado_secao/perfil_eleitor_secao_`ano'_`estado'/perfil_eleitor_secao_`ano'_`estado'.csv", delim(";") stringcols(_all) clear
			
			if "`estado'" == "DF" & `ano' == 2014 {
				
				keep aa_eleicao sg_uf cd_municipio nr_zona nr_secao ///
					ds_genero ds_estado_civil ds_faixa_etaria ds_grau_escolaridade ///
					qt_eleitores_perfil qt_eleitores_biometria qt_eleitores_deficiencia qt_eleitores_inc_nm_social
				
				ren aa_eleicao					ano
				ren sg_uf						sigla_uf
				ren cd_municipio				id_municipio_tse
				ren nr_zona						zona
				ren nr_secao					secao
				ren ds_genero					genero
				ren ds_estado_civil				estado_civil
				ren ds_faixa_etaria				grupo_idade
				ren ds_grau_escolaridade		instrucao
				ren qt_eleitores_perfil			eleitores
				ren qt_eleitores_biometria		eleitores_biometria
				ren qt_eleitores_deficiencia	eleitores_deficiencia
				ren qt_eleitores_inc_nm_social	eleitores_inclusao_nome_social
				
				gen situacao_biometria = ""
				
			}
			else {
				
				if `ano' == 2022 ren ds_mun_sit_biometrica ds_mun_sit_biometria
				
				keep ano_eleicao sg_uf cd_municipio ds_mun_sit_biometria nr_zona nr_secao ///
					ds_genero ds_estado_civil ds_faixa_etaria ds_grau_escolaridade ///
					qt_eleitores_perfil qt_eleitores_biometria qt_eleitores_deficiencia qt_eleitores_inc_nm_social
				
				ren ano_eleicao					ano
				ren sg_uf						sigla_uf
				ren cd_municipio				id_municipio_tse
				ren ds_mun_sit_biometria		situacao_biometria
				ren nr_zona						zona
				ren nr_secao					secao
				ren ds_genero					genero
				ren ds_estado_civil				estado_civil
				ren ds_faixa_etaria				grupo_idade
				ren ds_grau_escolaridade		instrucao
				ren qt_eleitores_perfil			eleitores
				ren qt_eleitores_biometria		eleitores_biometria
				ren qt_eleitores_deficiencia	eleitores_deficiencia
				ren qt_eleitores_inc_nm_social	eleitores_inclusao_nome_social
				
			}
			
		}
		*
		
		destring id_municipio_tse zona secao, replace force
		
		foreach k of varlist zona secao eleitores* {
			
			cap replace `k' = "" if `k' == "-1"
			
		}
		*
		
		foreach k in situacao_biometria genero grupo_idade instrucao estado_civil {
			cap clean_string `k'
		}
		*
		
		cap limpa_instrucao
		cap limpa_estado_civil
		
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
