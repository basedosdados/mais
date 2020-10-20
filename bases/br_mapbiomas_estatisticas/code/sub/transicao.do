
//-----------------------------//
// transicao estado-bioma
//-----------------------------//

import delimited "input/estados.csv", clear encoding("utf-8")

keep estado_abrev estado

tempfile estados
save `estados'

import excel "input/estatisticas/Dados_Transicao_MapBiomas_5.0_UF-MUN_SITE_v2.xlsx", clear sheet("BD_TRANSICAO_BIOMA-UF") locale("utf-8")

drop in 1

ren A	id_municipio
ren C	estado_abrev
ren D	de_id_classe
ren E	para_id_classe
ren F	de_nivel_0
ren G	de_nivel_1
ren H	de_nivel_2
ren I	de_nivel_3
ren J	de_nivel_4
ren K	para_nivel_0
ren L	para_nivel_1
ren M	para_nivel_2
ren N	para_nivel_3
ren O	para_nivel_4

destring, replace

foreach k in de para {
	
	replace `k'_id_classe = 27					if `k'_id_classe == 0
	replace `k'_nivel_0 = "antropico"			if `k'_nivel_0 == "Anthropic" | `k'_nivel_0 == "Antropic"
	replace `k'_nivel_0 = "natural"				if `k'_nivel_0 == "Natural"
	replace `k'_nivel_0 = "nao identificado"	if `k'_nivel_0 == "Not applied" | `k'_nivel_0 == "Not Identified"
	
	limpa_nivel `k'_nivel_1
	limpa_nivel `k'_nivel_2
	limpa_nivel `k'_nivel_3
	limpa_nivel `k'_nivel_4

}
*

preserve
	
	//---------//
	// anual
	//---------//
	
	ren P	area1986
	ren S	area1987
	ren U	area1988
	ren V	area1989
	ren W	area1990
	ren X	area1991
	ren AC	area1992
	ren AD	area1993
	ren AE	area1994
	ren AF	area1995
	ren AH	area1996
	ren AJ	area1997
	ren AL	area1998
	ren AM	area1999
	ren AN	area2000
	ren AO	area2001
	ren AS	area2002
	ren AU	area2003
	ren AW	area2004
	ren AX	area2005
	ren AY	area2006
	ren BA	area2007
	ren BB	area2008
	ren BC	area2009
	ren BF	area2010
	ren BG	area2011
	ren BK	area2012
	ren BL	area2013
	ren BN	area2014
	ren BO	area2015
	ren BP	area2016
	ren BR	area2017
	ren BS	area2018
	ren BT	area2019
	
	keep id_municipio estado_abrev de_* para_* area*
	
	reshape long area, i(id_municipio estado_abrev de_id_classe para_id_classe) j(ano)
	
	order id_municipio estado_abrev ano de_* para_*
	sort  id_municipio estado_abrev ano de_id_classe para_id_classe
	
	compress
	
	save "output/data/transicao_municipio_de_para_anual.dta", replace
	
restore

preserve
	
	//---------//
	// quinquenal
	//---------//
	
	ren Q	area1990
	ren Y	area1995
	ren AI	area2000
	ren AP	area2005
	ren AZ	area2010
	ren BH	area2015
	
	keep id_municipio estado_abrev de_* para_* area*
	
	reshape long area, i(id_municipio estado_abrev de_id_classe para_id_classe) j(ano)
	
	order id_municipio estado_abrev ano de_* para_*
	sort  id_municipio estado_abrev ano de_id_classe para_id_classe
	
	compress
	
	save "output/data/transicao_municipio_de_para_quinquenal.dta", replace
	
restore

preserve
	
	//---------//
	// decenal
	//---------//
	
	ren Z	area2000
	ren AQ	area2010
	
	keep id_municipio estado_abrev de_* para_* area*
	
	reshape long area, i(id_municipio estado_abrev de_id_classe para_id_classe) j(ano)
	
	order id_municipio estado_abrev ano de_* para_*
	sort  id_municipio estado_abrev ano de_id_classe para_id_classe
	
	compress
	
	save "output/data/transicao_municipio_de_para_decenal.dta", replace
	
restore




//-----------------------------//
// transicao estado-bioma
//-----------------------------//

import delimited "input/estados.csv", clear encoding("utf-8")

keep estado_abrev estado

tempfile estados
save `estados'

import excel "input/estatisticas/Dados_Transicao_MapBiomas_5.0_UF-BIOMAS_SITE.xlsx", clear sheet("BD_TRANSICAO_BIOMA-UF") locale("utf-8")

drop in 1

ren A	bioma
ren B	estado
ren C	de_id_classe
ren D	para_id_classe
ren E	de_nivel_0
ren F	de_nivel_1
ren G	de_nivel_2
ren H	de_nivel_3
ren I	de_nivel_4
ren J	para_nivel_0
ren K	para_nivel_1
ren L	para_nivel_2
ren M	para_nivel_3
ren N	para_nivel_4

clean_string bioma

replace estado = "Espírito Santo" if estado == "Espirito Santo"
merge m:1 estado using `estados'
drop if _merge == 2
drop _merge estado

destring, replace

foreach k in de para {
	
	replace `k'_id_classe = 27					if `k'_id_classe == 0
	replace `k'_nivel_0 = "antropico"			if `k'_nivel_0 == "Anthropic" | `k'_nivel_0 == "Antropic"
	replace `k'_nivel_0 = "natural"				if `k'_nivel_0 == "Natural"
	replace `k'_nivel_0 = "nao identificado"	if `k'_nivel_0 == "Not applied" | `k'_nivel_0 == "Not Identified"
	
	limpa_nivel `k'_nivel_1
	limpa_nivel `k'_nivel_2
	limpa_nivel `k'_nivel_3
	limpa_nivel `k'_nivel_4

}
*

preserve
	
	//---------//
	// anual
	//---------//
	
	ren O	area1986
	ren R	area1987
	ren T	area1988
	ren U	area1989
	ren V	area1990
	ren W	area1991
	ren AB	area1992
	ren AC	area1993
	ren AD	area1994
	ren AE	area1995
	ren AG	area1996
	ren AI	area1997
	ren AK	area1998
	ren AL	area1999
	ren AM	area2000
	ren AN	area2001
	ren AR	area2002
	ren AT	area2003
	ren AV	area2004
	ren AW	area2005
	ren AX	area2006
	ren AZ	area2007
	ren BA	area2008
	ren BB	area2009
	ren BE	area2010
	ren BF	area2011
	ren BJ	area2012
	ren BK	area2013
	ren BM	area2014
	ren BN	area2015
	ren BO	area2016
	ren BQ	area2017
	ren BR	area2018
	ren BS	area2019
	
	keep bioma estado de_* para_* area*
	
	reshape long area, i(estado_abrev bioma de_id_classe para_id_classe) j(ano)
	
	order estado_abrev bioma ano de_* para_*
	sort  estado_abrev bioma ano de_id_classe para_id_classe
	
	compress
	
	save "output/data/transicao_estado_bioma_de_para_anual.dta", replace
	
restore

preserve
	
	//---------//
	// quinquenal
	//---------//
	
	ren P	area1990
	ren X	area1995
	ren AH	area2000
	ren AO	area2005
	ren AY	area2010
	ren BG	area2015
	
	keep bioma estado de_* para_* area*
	
	reshape long area, i(estado_abrev bioma de_id_classe para_id_classe) j(ano)
	
	order estado_abrev bioma ano de_* para_*
	sort  estado_abrev bioma ano de_id_classe para_id_classe
	
	compress
	
	save "output/data/transicao_estado_bioma_de_para_quinquenal.dta", replace
	
restore

preserve
	
	//---------//
	// decenal
	//---------//
	
	ren Y	area2000
	ren AP	area2010
	
	keep bioma estado de_* para_* area*
	
	reshape long area, i(estado_abrev bioma de_id_classe para_id_classe) j(ano)
	
	order estado_abrev bioma ano de_* para_*
	sort  estado_abrev bioma ano de_id_classe para_id_classe
	
	compress
	
	save "output/data/transicao_estado_bioma_de_para_decenal.dta", replace
	
restore

