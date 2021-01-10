
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
set more off
cap log close
set excelxlsxlargefile on

cd "path/to/dados_inep"

do "code/fnc/clean_string.do"

//----------------------------------------------------------------------------//
// build: media de alunos por turma
//----------------------------------------------------------------------------//

//-----------------------//
// brasil
//-----------------------//

foreach ano of numlist 2007(1)2019 {
	
	if `ano' <= 2010					import excel "input/media_alunos_turma/media_alunos_turma_brasil_regioes_ufs_`ano'/media_alunos_turma_brasil_`ano'.xls", clear locale("utf-8")
	if `ano' == 2011					import excel "input/media_alunos_turma/alunos_turma_brasil_regioes_UFs_`ano'/alunos_turma_brasil_`ano'.xls", clear locale("utf-8")
	if `ano' == 2012					import excel "input/media_alunos_turma/media_alunos_turma_brasil_regioes_UFs_`ano'/media_alunos_turma_brasil_`ano'.xls", clear locale("utf-8")
	if `ano' >= 2013 & `ano' <= 2014	import excel "input/media_alunos_turma/media_alunos_turma_brasil_regioes_UFs_`ano'/MÉDIA ALUNOS TURMA BRASIL `ano'.xls", clear locale("utf-8")
	if `ano' >= 2015 & `ano' <= 2016	import excel "input/media_alunos_turma/ATU_`ano'_BRASIL_REGIOES_UFS/ATU_BRASIL_`ano'.xlsx", clear locale("utf-8")
	if `ano' >= 2017 & `ano' <= 2019	import excel "input/media_alunos_turma/ATU_`ano'_BRASIL_REGIOES_UFS/ATU_BRASIL_REGIOES_UFS_`ano'.xls", clear locale("utf-8")
	
	keep if A == "`ano'"
	
	if `ano' >= 2017 & `ano' <= 2019	keep if B == "Brasil"
	drop B
	
	ren A ano
	ren C situacao
	ren D rede
	ren E atu_educacao_infantil
	ren F atu_educacao_infantil_creche
	ren G atu_educacao_infantil_pre_escola
	ren H atu_ensino_fund
	ren I atu_ensino_fund_anos_iniciais
	ren J atu_ensino_fund_anos_finais
	ren K atu_ensino_fund_1_ano
	ren L atu_ensino_fund_2_ano
	ren M atu_ensino_fund_3_ano
	ren N atu_ensino_fund_4_ano
	ren O atu_ensino_fund_5_ano
	ren P atu_ensino_fund_6_ano
	ren Q atu_ensino_fund_7_ano
	ren R atu_ensino_fund_8_ano
	ren S atu_ensino_fund_9_ano
	ren T atu_ensino_fund_turmas_unif
	ren U atu_ensino_medio
	ren V atu_ensino_medio_1_ano
	ren W atu_ensino_medio_2_ano
	ren X atu_ensino_medio_3_ano
	ren Y atu_ensino_medio_4_ano
	ren Z atu_ensino_medio_nao_seriado
	
	keep ano situacao rede atu_*
	
	destring, replace ignore("--")
	
	clean_string situacao
	clean_string rede
	
	tempfile atu_brasil_`ano'
	save `atu_brasil_`ano''
	
}
*

use `atu_brasil_2007', clear
foreach ano of numlist 2008(1)2019 {
	append using `atu_brasil_`ano''
}
*

tostring *, replace force
foreach v of varlist * {
	replace `v' = "" if `v' == "."
}
*

order situacao rede ano
sort  situacao rede ano

compress

export delimited "output/brasil.csv", replace

//-----------------------//
// regiao
//-----------------------//

foreach ano of numlist 2007(1)2019 {
	
	if `ano' <= 2010					import excel "input/media_alunos_turma/media_alunos_turma_brasil_regioes_ufs_`ano'/media_alunos_turma_regioes_`ano'.xls", clear locale("utf-8")
	if `ano' == 2011					import excel "input/media_alunos_turma/alunos_turma_brasil_regioes_UFs_`ano'/alunos_turma_regioes_`ano'.xls", clear locale("utf-8")
	if `ano' == 2012					import excel "input/media_alunos_turma/media_alunos_turma_brasil_regioes_UFs_`ano'/media_alunos_turma_regioes_`ano'.xls", clear locale("utf-8")
	if `ano' >= 2013 & `ano' <= 2014	import excel "input/media_alunos_turma/media_alunos_turma_brasil_regioes_UFs_`ano'/MÉDIA ALUNOS TURMA REGIÕES `ano'.xls", clear locale("utf-8")
	if `ano' >= 2015 & `ano' <= 2016	import excel "input/media_alunos_turma/ATU_`ano'_BRASIL_REGIOES_UFS/ATU_REGIOES_`ano'.xlsx", clear locale("utf-8")
	if `ano' >= 2017 & `ano' <= 2019	import excel "input/media_alunos_turma/ATU_`ano'_BRASIL_REGIOES_UFS/ATU_BRASIL_REGIOES_UFS_`ano'.xls", clear locale("utf-8")
	
	keep if A == "`ano'"
	
	if `ano' >= 2017 & `ano' <= 2019	keep if inlist(B, "Norte", "Nordeste", "Centro-Oeste", "Sudeste", "Sul")
	
	ren A ano
	ren B regiao
	ren C situacao
	ren D rede
	ren E atu_educacao_infantil
	ren F atu_educacao_infantil_creche
	ren G atu_educacao_infantil_pre_escola
	ren H atu_ensino_fund
	ren I atu_ensino_fund_anos_iniciais
	ren J atu_ensino_fund_anos_finais
	ren K atu_ensino_fund_1_ano
	ren L atu_ensino_fund_2_ano
	ren M atu_ensino_fund_3_ano
	ren N atu_ensino_fund_4_ano
	ren O atu_ensino_fund_5_ano
	ren P atu_ensino_fund_6_ano
	ren Q atu_ensino_fund_7_ano
	ren R atu_ensino_fund_8_ano
	ren S atu_ensino_fund_9_ano
	ren T atu_ensino_fund_turmas_unif
	ren U atu_ensino_medio
	ren V atu_ensino_medio_1_ano
	ren W atu_ensino_medio_2_ano
	ren X atu_ensino_medio_3_ano
	ren Y atu_ensino_medio_4_ano
	ren Z atu_ensino_medio_nao_seriado
	
	keep regiao ano situacao rede atu_*
	
	replace regiao = "Centro-Oeste" if regiao == "Centro - Oeste"
	
	destring, replace ignore("--")
	
	clean_string situacao
	clean_string rede
	
	tempfile atu_`ano'
	save `atu_`ano''
	
}
*

use `atu_2007', clear
foreach ano of numlist 2008(1)2019 {
	append using `atu_`ano''
}
*

tostring *, replace force
foreach v of varlist * {
	replace `v' = "" if `v' == "."
}
*

order regiao situacao rede ano
sort  regiao situacao rede ano

compress

export delimited "output/regiao.csv", replace

//-----------------------//
// uf
//-----------------------//

import delimited "input/br_bd_diretorios_brasil_uf.csv", clear varn(1) encoding("utf-8")
keep uf sigla_uf
tempfile uf
save `uf'

foreach ano of numlist 2007(1)2019 {
	
	if `ano' <= 2010					import excel "input/media_alunos_turma/media_alunos_turma_brasil_regioes_ufs_`ano'/media_alunos_turma_ufs_`ano'.xls", clear locale("utf-8")
	if `ano' == 2011					import excel "input/media_alunos_turma/alunos_turma_brasil_regioes_UFs_`ano'/alunos_turma_ufs_`ano'.xls", clear locale("utf-8")
	if `ano' == 2012					import excel "input/media_alunos_turma/media_alunos_turma_brasil_regioes_UFs_`ano'/media_alunos_turma_ufs_`ano'.xls", clear locale("utf-8")
	if `ano' >= 2013 & `ano' <= 2014	import excel "input/media_alunos_turma/media_alunos_turma_brasil_regioes_UFs_`ano'/MÉDIA ALUNOS TURMA UFS `ano'.xls", clear locale("utf-8")
	if `ano' == 2015					import excel "input/media_alunos_turma/ATU_`ano'_BRASIL_REGIOES_UFS/ATU_UF_`ano'.xlsx", clear locale("utf-8")
	if `ano' == 2016					import excel "input/media_alunos_turma/ATU_`ano'_BRASIL_REGIOES_UFS/ATU_UFS_`ano'.xlsx", clear locale("utf-8")
	if `ano' >= 2017 & `ano' <= 2019	import excel "input/media_alunos_turma/ATU_`ano'_BRASIL_REGIOES_UFS/ATU_BRASIL_REGIOES_UFS_`ano'.xls", clear locale("utf-8")
	
	keep if A == "`ano'"
	
	if `ano' <= 2016 {
		
		drop B
		
		ren A ano
		ren C sigla_uf
		ren D situacao
		ren E rede
		ren F atu_educacao_infantil
		ren G atu_educacao_infantil_creche
		ren H atu_educacao_infantil_pre_escola
		ren I atu_ensino_fund
		ren J atu_ensino_fund_anos_iniciais
		ren K atu_ensino_fund_anos_finais
		ren L atu_ensino_fund_1_ano
		ren M atu_ensino_fund_2_ano
		ren N atu_ensino_fund_3_ano
		ren O atu_ensino_fund_4_ano
		ren P atu_ensino_fund_5_ano
		ren Q atu_ensino_fund_6_ano
		ren R atu_ensino_fund_7_ano
		ren S atu_ensino_fund_8_ano
		ren T atu_ensino_fund_9_ano
		ren U atu_ensino_fund_turmas_unif
		ren V atu_ensino_medio
		ren W atu_ensino_medio_1_ano
		ren X atu_ensino_medio_2_ano
		ren Y atu_ensino_medio_3_ano
		ren Z atu_ensino_medio_4_ano
		ren AA	atu_ensino_medio_nao_seriado
		
	}
	if `ano' >= 2017 & `ano' <= 2019 {
		
		keep if !inlist(B, "Brasil", "Norte", "Nordeste", "Centro-Oeste", "Sudeste", "Sul")
		
		ren A ano
		ren B uf
		ren C situacao
		ren D rede
		ren E atu_educacao_infantil
		ren F atu_educacao_infantil_creche
		ren G atu_educacao_infantil_pre_escola
		ren H atu_ensino_fund
		ren I atu_ensino_fund_anos_iniciais
		ren J atu_ensino_fund_anos_finais
		ren K atu_ensino_fund_1_ano
		ren L atu_ensino_fund_2_ano
		ren M atu_ensino_fund_3_ano
		ren N atu_ensino_fund_4_ano
		ren O atu_ensino_fund_5_ano
		ren P atu_ensino_fund_6_ano
		ren Q atu_ensino_fund_7_ano
		ren R atu_ensino_fund_8_ano
		ren S atu_ensino_fund_9_ano
		ren T atu_ensino_fund_turmas_unif
		ren U atu_ensino_medio
		ren V atu_ensino_medio_1_ano
		ren W atu_ensino_medio_2_ano
		ren X atu_ensino_medio_3_ano
		ren Y atu_ensino_medio_4_ano
		ren Z atu_ensino_medio_nao_seriado
	
	}
	*
	
	if `ano' >= 2017 & `ano' <= 2019 {
		merge m:1 uf using `uf'
		drop if _merge == 2
		drop _merge
	}
	*
	
	keep sigla_uf ano situacao rede atu_*
	
	destring, replace ignore("--")
	
	clean_string situacao
	clean_string rede
	
	replace rede = "publica" if rede == "publico"
	
	tempfile atu_`ano'
	save `atu_`ano''
	
}
*

use `atu_2007', clear
foreach ano of numlist 2008(1)2019 {
	append using `atu_`ano''
}
*

tostring *, replace force
foreach v of varlist * {
	replace `v' = "" if `v' == "."
}
*

order sigla_uf situacao rede ano
sort  sigla_uf situacao rede ano

compress

export delimited "output/uf.csv", replace


//-----------------------//
// municipio
//-----------------------//

foreach ano of numlist 2007(1)2019 {
	
	if `ano' >= 2007 & `ano' <= 2010 {
		import excel "input/media_alunos_turma/media_alunos_turma_municipios_`ano'.xls", clear locale("utf-8") sheet("Municípios NO e NE")
		tempfile parte1
		save `parte1'
		import excel "input/media_alunos_turma/media_alunos_turma_municipios_`ano'.xls", clear locale("utf-8") sheet("Municípios SE, Sul e CO")
		tempfile parte2
		save `parte2'
		use `parte1', clear
		append using `parte2'
	}
	if `ano' == 2011 {
		import excel "input/media_alunos_turma/alunos_turma_municipios_`ano'.xls", clear locale("utf-8") sheet("Municípios NO e NE")
		tempfile parte1
		save `parte1'
		import excel "input/media_alunos_turma/alunos_turma_municipios_`ano'.xls", clear locale("utf-8") sheet("Municípios SE, Sul e CO")
		tempfile parte2
		save `parte2'
		use `parte1', clear
		append using `parte2'
	}
	if `ano' == 2012 {
		import excel "input/media_alunos_turma/media_alunos_turma_municipios_2012.xlsx", clear locale("utf-8")
	}
	if `ano' >= 2013 & `ano' <= 2014 {
		import excel "input/media_alunos_turma/MEDIA ALUNOS TURMA MUNICIPIOS `ano'.xlsx", clear locale("utf-8")
	}
	if `ano' >= 2015 & `ano' <= 2019 {
		import delimited "input/media_alunos_turma/ATU_`ano'_MUNICIPIOS/ATU_MUNICIPIOS_`ano'.csv", clear encoding("utf-8")
	}
	*
	
	if `ano' >= 2007 & `ano' <= 2014 {
		
		keep if A == "`ano'"
		
		drop B C E
		ren D id_municipio
	
		ren A	ano
		ren F	situacao
		ren G	rede
		ren H	atu_educacao_infantil
		ren I	atu_educacao_infantil_creche
		ren J	atu_educacao_infantil_pre_escola
		ren K	atu_ensino_fund
		ren L	atu_ensino_fund_anos_iniciais
		ren M	atu_ensino_fund_anos_finais
		ren N	atu_ensino_fund_1_ano
		ren O	atu_ensino_fund_2_ano
		ren P	atu_ensino_fund_3_ano
		ren Q	atu_ensino_fund_4_ano
		ren R	atu_ensino_fund_5_ano
		ren S	atu_ensino_fund_6_ano
		ren T 	atu_ensino_fund_7_ano
		ren U	atu_ensino_fund_8_ano
		ren V	atu_ensino_fund_9_ano
		ren W	atu_ensino_fund_turmas_unif
		ren X	atu_ensino_medio
		ren Y	atu_ensino_medio_1_ano
		ren Z	atu_ensino_medio_2_ano
		ren AA	atu_ensino_medio_3_ano
		ren AB	atu_ensino_medio_4_ano
		ren AC	atu_ensino_medio_nao_seriado
		
	}
	if `ano' >= 2015 & `ano' <= 2019 {
		
		keep if v1 == "`ano'"
		
		drop v2 v3 v5
		ren v4 id_municipio
		
		ren v1	ano
		ren v6	situacao
		ren v7	rede
		ren v8	atu_educacao_infantil
		ren v9	atu_educacao_infantil_creche
		ren v10	atu_educacao_infantil_pre_escola
		ren v11	atu_ensino_fund
		ren v12	atu_ensino_fund_anos_iniciais
		ren v13	atu_ensino_fund_anos_finais
		ren v14	atu_ensino_fund_1_ano
		ren v15	atu_ensino_fund_2_ano
		ren v16	atu_ensino_fund_3_ano
		ren v17	atu_ensino_fund_4_ano
		ren v18	atu_ensino_fund_5_ano
		ren v19	atu_ensino_fund_6_ano
		ren v20	atu_ensino_fund_7_ano
		ren v21	atu_ensino_fund_8_ano
		ren v22	atu_ensino_fund_9_ano
		ren v23	atu_ensino_fund_turmas_unif
		ren v24	atu_ensino_medio
		ren v25	atu_ensino_medio_1_ano
		ren v26	atu_ensino_medio_2_ano
		ren v27	atu_ensino_medio_3_ano
		ren v28	atu_ensino_medio_4_ano
		ren v29	atu_ensino_medio_nao_seriado
		
	}
	*
	
	keep id_municipio ano situacao rede atu_*
	
	destring, replace ignore("--")
	
	clean_string situacao
	clean_string rede
	
	replace rede = "publica" if rede == "publico"
	
	tempfile atu_`ano'
	save `atu_`ano''
	
}
*

use `atu_2007', clear
foreach ano of numlist 2008(1)2019 {
	append using `atu_`ano''
}
*

tostring *, replace force
foreach v of varlist * {
	replace `v' = "" if `v' == "."
}
*

order id_municipio situacao rede ano
sort  id_municipio situacao rede ano

compress

export delimited "output/municipio.csv", replace


//-----------------------//
// escola
//-----------------------//

foreach ano of numlist 2007(1)2019 {
	
	if `ano' >= 2007 & `ano' <= 2011 {
		
		import excel "input/media_alunos_turma/media_alunos_turma_escolas_`ano'.xls", clear locale("utf-8") sheet("NORTE")
		tempfile parte1
		save `parte1'
		import excel "input/media_alunos_turma/media_alunos_turma_escolas_`ano'.xls", clear locale("utf-8") sheet("NORDESTE-EXT MA E BA")
		tempfile parte2
		save `parte2'
		import excel "input/media_alunos_turma/media_alunos_turma_escolas_`ano'.xls", clear locale("utf-8") sheet("NORDESTE - SOMENTE MA E BA")
		tempfile parte3
		save `parte3'
		import excel "input/media_alunos_turma/media_alunos_turma_escolas_`ano'.xls", clear locale("utf-8") sheet("SUDESTE")
		tempfile parte4
		save `parte4'
		import excel "input/media_alunos_turma/media_alunos_turma_escolas_`ano'.xls", clear locale("utf-8") sheet("SUL")
		tempfile parte5
		save `parte5'
		import excel "input/media_alunos_turma/media_alunos_turma_escolas_`ano'.xls", clear locale("utf-8") sheet("CENTRO-OESTE")
		tempfile parte6
		save `parte6'
		use `parte1', clear
		append using `parte2'
		append using `parte3'
		append using `parte4'
		append using `parte5'
		append using `parte6'
		
	}
	if `ano' == 2012 {
		import excel "input/media_alunos_turma/media_alunos_turma_escolas_2012.xlsx", clear locale("utf-8")
	}
	if `ano' >= 2013 & `ano' <= 2014 {
		import excel "input/media_alunos_turma/MEDIA ALUNOS TURMA ESCOLAS `ano'.xlsx", clear locale("utf-8")
	}
	if `ano' >= 2015 & `ano' <= 2019 {
		import delimited "input/media_alunos_turma/ATU_`ano'_ESCOLAS/ATU_ESCOLAS_`ano'.csv", clear encoding("utf-8")
	}
	*
	
	if `ano' >= 2007 & `ano' <= 2014 {

		keep if A == "`ano'"
		
		if `ano' >= 2007 & `ano' <= 2009 {
			drop B C D
			ren E id_municipio
		}
		if `ano' >= 2010 & `ano' <= 2014 {
			drop B C E
			ren D id_municipio
		}
		*
			
		ren A	ano
		ren F	id_escola
		ren G	escola
		ren H	situacao
		ren I	rede
		ren J	atu_educacao_infantil
		ren K	atu_educacao_infantil_creche
		ren L	atu_educacao_infantil_pre_escola
		ren M	atu_ensino_fund
		ren N	atu_ensino_fund_anos_iniciais
		ren O	atu_ensino_fund_anos_finais
		ren P	atu_ensino_fund_1_ano
		ren Q	atu_ensino_fund_2_ano
		ren R	atu_ensino_fund_3_ano
		ren S	atu_ensino_fund_4_ano
		ren T 	atu_ensino_fund_5_ano
		ren U	atu_ensino_fund_6_ano
		ren V	atu_ensino_fund_7_ano
		ren W	atu_ensino_fund_8_ano
		ren X	atu_ensino_fund_9_ano
		ren Y	atu_ensino_fund_turmas_unif
		ren Z	atu_ensino_medio
		ren AA	atu_ensino_medio_1_ano
		ren AB	atu_ensino_medio_2_ano
		ren AC	atu_ensino_medio_3_ano
		ren AD	atu_ensino_medio_4_ano
		ren AE	atu_ensino_medio_nao_seriado
		
	}
	if `ano' >= 2015 & `ano' <= 2019 {
		
		keep if v1 == "`ano'"
		
		if `ano' == 2015 {
			drop v2 v3 v4
			ren v5	id_municipio
			ren v6	escola
			ren v7	id_escola
			
		}
		if `ano' >= 2016 & `ano' <= 2019 {
			drop v2 v3 v5
			ren v4 id_municipio
			ren v6	id_escola
			ren v7	escola
		}
		*
		
		ren v1	ano
		ren v8	situacao
		ren v9	rede
		ren v10	atu_educacao_infantil
		ren v11	atu_educacao_infantil_creche
		ren v12	atu_educacao_infantil_pre_escola
		ren v13	atu_ensino_fund
		ren v14	atu_ensino_fund_anos_iniciais
		ren v15	atu_ensino_fund_anos_finais
		ren v16	atu_ensino_fund_1_ano
		ren v17	atu_ensino_fund_2_ano
		ren v18	atu_ensino_fund_3_ano
		ren v19	atu_ensino_fund_4_ano
		ren v20	atu_ensino_fund_5_ano
		ren v21	atu_ensino_fund_6_ano
		ren v22	atu_ensino_fund_7_ano
		ren v23	atu_ensino_fund_8_ano
		ren v24	atu_ensino_fund_9_ano
		ren v25	atu_ensino_fund_turmas_unif
		ren v26	atu_ensino_medio
		ren v27	atu_ensino_medio_1_ano
		ren v28	atu_ensino_medio_2_ano
		ren v29	atu_ensino_medio_3_ano
		ren v30	atu_ensino_medio_4_ano
		ren v31	atu_ensino_medio_nao_seriado
		
	}
	*
	
	keep id_municipio id_escola escola ano situacao rede atu_*
	
	destring atu_*, replace ignore("--")
	
	clean_string situacao
	clean_string rede
	
	replace rede = "publica" if rede == "publico"
	
	tempfile atu_`ano'
	save `atu_`ano''
	
}
*

use `atu_2007', clear
foreach ano of numlist 2008(1)2019 {
	append using `atu_`ano''
}
*

tostring atu_*, replace force
foreach v of varlist * {
	replace `v' = "" if `v' == "."
}
*

order id_escola escola id_municipio situacao rede ano
sort  id_escola escola id_municipio situacao rede ano

compress

export delimited "output/escola.csv", replace

