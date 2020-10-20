
//-----------------------------//
// cobertura municipio-classe
//-----------------------------//

import excel "input/estatisticas/Dados_Cobertura_MapBiomas_5.0_UF-MUN_SITE_v2.xlsx", clear sheet("LAND COVER - BIOMAS e UF") firstrow locale("utf-8")

drop municipality state

ren territory_id id_municipio

ren level_0	nivel_0
ren level_1	nivel_1
ren level_2	nivel_2
ren level_3	nivel_3
ren level_4	nivel_4

ren I	area1985
ren J	area1986
ren K	area1987
ren L	area1988
ren M	area1989
ren N	area1990
ren O	area1991
ren P	area1992
ren Q	area1993
ren R	area1994
ren S	area1995
ren T	area1996
ren U	area1997
ren V	area1998
ren W	area1999
ren X	area2000
ren Y	area2001
ren Z	area2002
ren AA	area2003
ren AB	area2004
ren AC	area2005
ren AD	area2006
ren AE	area2007
ren AF	area2008
ren AG	area2009
ren AH	area2010
ren AI	area2011
ren AJ	area2012
ren AK	area2013
ren AL	area2014
ren AM	area2015
ren AN	area2016
ren AO	area2017
ren AP	area2018
ren AQ	area2019

replace nivel_0 = "antropico"			if nivel_0 == "Anthropic" | nivel_0 == "Antropic"
replace nivel_0 = "natural"				if nivel_0 == "Natural"
replace nivel_0 = "nao identificado"	if nivel_0 == "Not applied"

limpa_nivel nivel_1
limpa_nivel nivel_2
limpa_nivel nivel_3
limpa_nivel nivel_4

gen tipo_dado = ""
replace tipo_dado = "cobertura"		if nivel_0 == "natural"
replace tipo_dado = "uso"			if nivel_0 == "antropico"
replace tipo_dado = "nao aplica"	if nivel_0 == "nao identificado"
replace tipo_dado = "cobertura/uso" if nivel_2 == "outras areas nao-vegetadas"

gen id_classe = .
foreach nivel in 1 2 3 4 {

	replace id_classe = 1	if nivel_`nivel' == "1. floresta"
	replace id_classe = 2	if nivel_`nivel' == "1.1. floresta natural"
	replace id_classe = 3	if nivel_`nivel' == "1.1.1. formacao florestal"
	replace id_classe = 4	if nivel_`nivel' == "1.1.2. formacao savanica"
	replace id_classe = 5	if nivel_`nivel' == "1.1.3. mangue"
	replace id_classe = 9	if nivel_`nivel' == "1.2. floresta plantada"
	replace id_classe = 10	if nivel_`nivel' == "2. formacao natural nao-florestal"
	replace id_classe = 11	if nivel_`nivel' == "2.1. campo alagado e area pantanosa"
	replace id_classe = 12	if nivel_`nivel' == "2.2. formacao campestre"
	replace id_classe = 32	if nivel_`nivel' == "2.3. apicum"
	replace id_classe = 29	if nivel_`nivel' == "2.4. afloramento rochoso"
	replace id_classe = 13	if nivel_`nivel' == "2.5. outras formacoes nao-florestais"
	replace id_classe = 14	if nivel_`nivel' == "3. agropecuaria"
	replace id_classe = 15	if nivel_`nivel' == "3.1. pastagem"
	replace id_classe = 39	if nivel_`nivel' == "3.2.1.1. soja"
	replace id_classe = 20	if nivel_`nivel' == "3.2.1.2. cana"
	replace id_classe = 41	if nivel_`nivel' == "3.2.1.3. outras lavouras temporarias"
	replace id_classe = 36	if nivel_`nivel' == "3.2.2. lavoura perene"
	replace id_classe = 21	if nivel_`nivel' == "3.3. mosaico de agricultura e pastagem"
	replace id_classe = 22	if nivel_`nivel' == "4. area nao-vegetada"
	replace id_classe = 23	if nivel_`nivel' == "4.1. praia e duna"
	replace id_classe = 24	if nivel_`nivel' == "4.2. infraestrutura urbana"
	replace id_classe = 30	if nivel_`nivel' == "4.3. mineracao"
	replace id_classe = 25	if nivel_`nivel' == "4.4. outras areas nao-vegetadas"
	replace id_classe = 26	if nivel_`nivel' == "5. corpos d'agua"
	replace id_classe = 33	if nivel_`nivel' == "5.1. rio, lago e oceano"
	replace id_classe = 31	if nivel_`nivel' == "5.2. aquicultura"
	replace id_classe = 27	if nivel_`nivel' == "6. nao observado"
	
}
*

reshape long area, i(id_municipio tipo_dado id_classe nivel*) j(ano)

replace area = area / 100

sort  id_municipio id_classe ano
order id_municipio id_classe ano

compress

save "output/data/cobertura_municipio_classe.dta", replace


//-----------------------------//
// cobertura estado-bioma
//-----------------------------//

import delimited "input/estados.csv", clear encoding("utf-8")

keep estado_abrev estado

tempfile estados
save `estados'

import excel "input/estatisticas/Dados_Cobertura_MapBiomas_5.0_UF-BIOMAS_SITE.xlsx", clear sheet("LAND COVER - BIOMAS e UF") firstrow locale("utf-8")

ren biome		bioma
ren state		estado
ren Leval_zero	nivel_0
ren level_1		nivel_1
ren level_2		nivel_2
ren level_3		nivel_3
ren level_4		nivel_4

clean_string bioma

replace estado = "Espírito Santo" if estado == "Espirito Santo"
merge m:1 estado using `estados'
drop if _merge == 2
drop _merge estado

ren H	area1985
ren I	area1986
ren J	area1987
ren K	area1988
ren L	area1989
ren M	area1990
ren N	area1991
ren O	area1992
ren P	area1993
ren Q	area1994
ren R	area1995
ren S	area1996
ren T	area1997
ren U	area1998
ren V	area1999
ren W	area2000
ren X	area2001
ren Y	area2002
ren Z	area2003
ren AA	area2004
ren AB	area2005
ren AC	area2006
ren AD	area2007
ren AE	area2008
ren AF	area2009
ren AG	area2010
ren AH	area2011
ren AI	area2012
ren AJ	area2013
ren AK	area2014
ren AL	area2015
ren AM	area2016
ren AN	area2017
ren AO	area2018
ren AP	area2019

replace nivel_0 = "antropico"			if nivel_0 == "Anthropic" | nivel_0 == "Antropic"
replace nivel_0 = "natural"				if nivel_0 == "Natural"
replace nivel_0 = "nao identificado"	if nivel_0 == "Not applied" | nivel_0 == "Not Identified"

limpa_nivel nivel_1
limpa_nivel nivel_2
limpa_nivel nivel_3
limpa_nivel nivel_4

gen tipo_dado = ""
replace tipo_dado = "cobertura"		if nivel_0 == "natural"
replace tipo_dado = "uso"			if nivel_0 == "antropico"
replace tipo_dado = "nao aplica"	if nivel_0 == "nao identificado"
replace tipo_dado = "cobertura/uso" if nivel_2 == "outras areas nao-vegetadas"

gen id_classe = .
foreach nivel in 1 2 3 4 {

	replace id_classe = 1	if nivel_`nivel' == "1. floresta"
	replace id_classe = 2	if nivel_`nivel' == "1.1. floresta natural"
	replace id_classe = 3	if nivel_`nivel' == "1.1.1. formacao florestal"
	replace id_classe = 4	if nivel_`nivel' == "1.1.2. formacao savanica"
	replace id_classe = 5	if nivel_`nivel' == "1.1.3. mangue"
	replace id_classe = 9	if nivel_`nivel' == "1.2. floresta plantada"
	replace id_classe = 10	if nivel_`nivel' == "2. formacao natural nao-florestal"
	replace id_classe = 11	if nivel_`nivel' == "2.1. campo alagado e area pantanosa"
	replace id_classe = 12	if nivel_`nivel' == "2.2. formacao campestre"
	replace id_classe = 32	if nivel_`nivel' == "2.3. apicum"
	replace id_classe = 29	if nivel_`nivel' == "2.4. afloramento rochoso"
	replace id_classe = 13	if nivel_`nivel' == "2.5. outras formacoes nao-florestais"
	replace id_classe = 14	if nivel_`nivel' == "3. agropecuaria"
	replace id_classe = 15	if nivel_`nivel' == "3.1. pastagem"
	replace id_classe = 39	if nivel_`nivel' == "3.2.1.1. soja"
	replace id_classe = 20	if nivel_`nivel' == "3.2.1.2. cana"
	replace id_classe = 41	if nivel_`nivel' == "3.2.1.3. outras lavouras temporarias"
	replace id_classe = 36	if nivel_`nivel' == "3.2.2. lavoura perene"
	replace id_classe = 21	if nivel_`nivel' == "3.3. mosaico de agricultura e pastagem"
	replace id_classe = 22	if nivel_`nivel' == "4. area nao-vegetada"
	replace id_classe = 23	if nivel_`nivel' == "4.1. praia e duna"
	replace id_classe = 24	if nivel_`nivel' == "4.2. infraestrutura urbana"
	replace id_classe = 30	if nivel_`nivel' == "4.3. mineracao"
	replace id_classe = 25	if nivel_`nivel' == "4.4. outras areas nao-vegetadas"
	replace id_classe = 26	if nivel_`nivel' == "5. corpos d'agua"
	replace id_classe = 33	if nivel_`nivel' == "5.1. rio, lago e oceano"
	replace id_classe = 31	if nivel_`nivel' == "5.2. aquicultura"
	replace id_classe = 27	if nivel_`nivel' == "6. nao observado"
	
}
*

reshape long area, i(bioma estado_abrev tipo_dado id_classe nivel*) j(ano)

replace area = area / 100

sort  estado_abrev bioma id_classe ano
order estado_abrev bioma id_classe ano

compress

save "output/data/cobertura_estado_bioma_classe.dta", replace
