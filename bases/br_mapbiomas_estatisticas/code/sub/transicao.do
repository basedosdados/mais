
//-----------------------------//
// transicao municipio
//-----------------------------//

import excel "input/estatisticas/1-tabela-geral-col7-mapbiomas-biomas-municipio-final.xlsx", clear sheet("TRANSICAO_COL7") firstrow locale("latin1") //cellrange(A1:BV1000)

drop municipality biome class_id level_* color

ren UF           sigla_uf
ren from_class   id_classe_de
ren to_class     id_classe_para

replace sigla_uf = strtrim(sigla_uf)

merge m:1 feature_id using "tmp/feature_id_municipio.dta"
drop if _merge == 2
drop _merge feature_id

preserve
	
	//---------//
	// anual
	//---------//
	
	ren N  area1986
	ren Q  area1987
	ren S  area1988
	ren T  area1989
	ren U  area1990
	ren V  area1991
	ren AA area1992
	ren AB area1993 
	ren AC area1994
	ren AE area1995
	ren AG area1996
	ren AI area1997
	ren AK area1998
	ren AL area1999
	ren AM area2000
	ren AN area2001
	ren AR area2002
	ren AT area2003
	ren AV area2004
	ren AW area2005
	ren AX area2006
	ren AZ area2007
	ren BA area2008
	ren BB area2009
	ren BE area2010
	ren BF area2011
	ren BJ area2012
	ren BK area2013
	ren BM area2014
	ren BN area2015
	ren BO area2016
	ren BQ area2017
	ren BS area2018
	ren BT area2019
	ren BU area2020
	ren BV area2021
	
	keep sigla_uf id_municipio id_classe* area*
	
	collapse (sum) area*, by(sigla_uf id_municipio id_classe_de id_classe_para)
	
	reshape long area, i(sigla_uf id_municipio id_classe_de id_classe_para) j(ano)
	
	replace area = area / 100

	drop if area == 0 | area == .
	
	order sigla_uf id_municipio ano id_classe_de id_classe_para
	sort           id_municipio ano id_classe_de id_classe_para
	
	compress
	
	save "output/data/transicao_municipio_de_para_anual.dta", replace
	
restore

preserve
	
	//---------//
	// quinquenal
	//---------//
	
	ren O	area1990
	ren W	area1995
	ren AH	area2000
	ren AO	area2005
	ren AY	area2010
	ren BG	area2015
	ren BP	area2020
	
	keep sigla_uf id_municipio id_classe* area*
	
	collapse (sum) area*, by(sigla_uf id_municipio id_classe_de id_classe_para)
	
	reshape long area, i(sigla_uf id_municipio id_classe_de id_classe_para) j(ano)
	
	replace area = area / 100

	drop if area == 0 | area == .
	
	order sigla_uf id_municipio ano id_classe_de id_classe_para
	sort           id_municipio ano id_classe_de id_classe_para
	
	compress
	
	save "output/data/transicao_municipio_de_para_quinquenal.dta", replace
	
restore

preserve
	
	//---------//
	// decenal
	//---------//
	
	ren X	area2000
	ren AP	area2010
	ren BI	area2020
	
	keep sigla_uf id_municipio id_classe* area*
	
	collapse (sum) area*, by(sigla_uf id_municipio id_classe_de id_classe_para)
	
	reshape long area, i(sigla_uf id_municipio id_classe_de id_classe_para) j(ano)
	
	replace area = area / 100

	drop if area == 0 | area == .
	
	order sigla_uf id_municipio ano id_classe_de id_classe_para
	sort           id_municipio ano id_classe_de id_classe_para
	
	compress
	
	save "output/data/transicao_municipio_de_para_decenal.dta", replace
	
restore

//-----------------------------//
// transicao estado-bioma
//-----------------------------//

import delimited "input/br_bd_diretorios_brasil_uf.csv", clear encoding("utf-8")
keep sigla nome
ren sigla sigla_uf
ren nome nome_uf
clean_string nome_uf
tempfile uf
save `uf'

import excel "input/estatisticas/1_-_TABELA_GERAL_COL7_MAPBIOMAS_BIOMAS_UF_FINAL.xlsx", clear sheet("TRANSICOES_COL7") firstrow locale("latin1") //cellrange(A1:CB1000)

drop biome feature_id class_id_to to_level_* to_color class_id_from from_level_* from_color

ren state        nome_uf
ren from_class   id_classe_de
ren to_class     id_classe_para

clean_string nome_uf
merge m:1 nome_uf using `uf'
drop if _merge == 2
drop _merge nome_uf

preserve
	
	//---------//
	// anual
	//---------//
	
	ren T  area1986
	ren W  area1987
	ren Y  area1988
	ren Z  area1989
	ren AA area1990
	ren AB area1991
	ren AG area1992
	ren AH area1993
	ren AI area1994
	ren AK area1995
	ren AM area1996
	ren AO area1997
	ren AQ area1998
	ren AR area1999
	ren AS area2000
	ren AT area2001
	ren AX area2002
	ren AZ area2003
	ren BB area2004
	ren BC area2005
	ren BD area2006
	ren BF area2007
	ren BG area2008
	ren BH area2009
	ren BK area2010
	ren BL area2011
	ren BP area2012
	ren BQ area2013
	ren BS area2014
	ren BT area2015
	ren BU area2016
	ren BW area2017
	ren BY area2018
	ren BZ area2019
	ren CA area2020
	ren CB area2021
	
	keep sigla_uf id_classe* area*
	
	collapse (sum) area*, by(sigla_uf id_classe_de id_classe_para)
	
	reshape long area, i(sigla_uf id_classe_de id_classe_para) j(ano)
	
	replace area = area / 100
	
	drop if area == 0 | area == .
	
	order sigla_uf ano id_classe_de id_classe_para
	sort  sigla_uf ano id_classe_de id_classe_para
	
	compress
	
	save "output/data/transicao_uf_de_para_anual.dta", replace
	
restore

preserve
	
	//---------//
	// quinquenal
	//---------//
	
	ren U  area1990
	ren AC area1995
	ren AN area2000
	ren AU area2005
	ren BE area2010
	ren BM area2015
	ren BV area2020
	
	keep sigla_uf id_classe* area*
	
	collapse (sum) area*, by(sigla_uf id_classe_de id_classe_para)
	
	reshape long area, i(sigla_uf id_classe_de id_classe_para) j(ano)
	
	replace area = area / 100

	drop if area == 0 | area == .
	
	order sigla_uf ano id_classe_de id_classe_para
	sort  sigla_uf ano id_classe_de id_classe_para
	
	compress
	
	save "output/data/transicao_uf_de_para_quinquenal.dta", replace
	
restore

preserve
	
	//---------//
	// decenal
	//---------//
	
	ren AD	area2000
	ren AV	area2010
	ren BO	area2020
	
	keep sigla_uf id_classe* area*
	
	collapse (sum) area*, by(sigla_uf id_classe_de id_classe_para)
	
	reshape long area, i(sigla_uf id_classe_de id_classe_para) j(ano)
	
	replace area = area / 100

	drop if area == 0 | area == .
	
	order sigla_uf ano id_classe_de id_classe_para
	sort  sigla_uf ano id_classe_de id_classe_para
	
	compress
	
	save "output/data/transicao_uf_de_para_decenal.dta", replace
	
restore

