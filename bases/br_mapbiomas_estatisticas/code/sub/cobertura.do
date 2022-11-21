
import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) encoding("utf-8")
keep id_municipio nome sigla_uf
ren nome nome_municipio
clean_string nome_municipio
tempfile municipio
save `municipio'

//-----------------------------//
// cobertura municipio-classe
//-----------------------------//

import excel "input/estatisticas/1-tabela-geral-col7-mapbiomas-biomas-municipio-final.xlsx", clear sheet("COBERTURA_COL7") firstrow locale("utf-8")

drop biome level_* color

ren UF           sigla_uf
ren municipality nome_municipio
ren class_id     id_classe

ren L	area1985
ren M	area1986
ren N	area1987
ren O	area1988
ren P	area1989
ren Q	area1990
ren R	area1991
ren S	area1992
ren T	area1993
ren U	area1994
ren V	area1995
ren W	area1996
ren X	area1997
ren Y	area1998
ren Z	area1999
ren AA	area2000
ren AB	area2001
ren AC	area2002
ren AD	area2003
ren AE	area2004
ren AF	area2005
ren AG	area2006
ren AH	area2007
ren AI	area2008
ren AJ	area2009
ren AK	area2010
ren AL	area2011
ren AM	area2012
ren AN	area2013
ren AO	area2014
ren AP	area2015
ren AQ	area2016
ren AR	area2017
ren AS	area2018
ren AT	area2019
ren AU	area2020
ren AV	area2021

replace sigla_uf = strtrim(sigla_uf)
clean_string nome_municipio

replace nome_municipio = "muquem de sao francisco" if sigla_uf == "BA" & nome_municipio == "muquem do sao francisco"
replace nome_municipio = "santa teresinha"         if sigla_uf == "BA" & nome_municipio == "santa terezinha"
replace nome_municipio = "itapage"                 if sigla_uf == "CE" & nome_municipio == "itapaje"
replace nome_municipio = "dona eusebia"            if sigla_uf == "MG" & nome_municipio == "dona euzebia"
replace nome_municipio = "passa-vinte"             if sigla_uf == "MG" & nome_municipio == "passa vinte"
replace nome_municipio = "sao thome das letras"    if sigla_uf == "MG" & nome_municipio == "sao tome das letras"
replace nome_municipio = "poxoreo"                 if sigla_uf == "MT" & nome_municipio == "poxoreu"
replace nome_municipio = "santa isabel do para"    if sigla_uf == "PA" & nome_municipio == "santa izabel do para"
replace nome_municipio = "iguaraci"                if sigla_uf == "PE" & nome_municipio == "iguaracy"
replace nome_municipio = "olho-dagua do borges"    if sigla_uf == "RN" & nome_municipio == "olho dagua do borges"
replace nome_municipio = "grao para"               if sigla_uf == "SC" & nome_municipio == "grao-para"
replace nome_municipio = "amparo de sao francisco" if sigla_uf == "SE" & nome_municipio == "amparo do sao francisco"
replace nome_municipio = "biritiba-mirim"          if sigla_uf == "SP" & nome_municipio == "biritiba mirim"
replace nome_municipio = "florinia"                if sigla_uf == "SP" & nome_municipio == "florinea"
replace nome_municipio = "sao luis do paraitinga"  if sigla_uf == "SP" & nome_municipio == "sao luiz do paraitinga"
replace nome_municipio = "fortaleza do tabocao"    if sigla_uf == "TO" & nome_municipio == "tabocao"

merge m:1 sigla_uf nome_municipio using `municipio'
drop if _merge != 3	// deleta "lagoa dos patos" e "lagoa mirim"
drop _merge nome_municipio

preserve
	keep feature_id id_municipio
	duplicates drop
	save "tmp/feature_id_municipio.dta", replace
restore
drop feature_id

collapse (sum) area*, by(sigla_uf id_municipio id_classe)

reshape long area, i(sigla_uf id_municipio id_classe) j(ano)

replace area = area / 100

drop if area == 0 | area == .

order sigla_uf id_municipio id_classe ano
sort           id_municipio id_classe ano

compress

save "output/data/cobertura_municipio_classe.dta", replace

//-----------------------------//
// cobertura uf-classe
//-----------------------------//

import delimited "input/br_bd_diretorios_brasil_uf.csv", clear encoding("utf-8")
keep sigla nome
ren sigla sigla_uf
ren nome nome_uf
clean_string nome_uf
tempfile uf
save `uf'

import excel "input/estatisticas/1_-_TABELA_GERAL_COL7_MAPBIOMAS_BIOMAS_UF_FINAL.xlsx", clear sheet("COBERTURA_COL7") firstrow locale("latin1") //cellrange(A1:CB1000)

drop COLECAO biome feature_id level_* color

ren state        nome_uf
ren class_id     id_classe

ren L	area1985
ren M	area1986
ren N	area1987
ren O	area1988
ren P	area1989
ren Q	area1990
ren R	area1991
ren S	area1992
ren T	area1993
ren U	area1994
ren V	area1995
ren W	area1996
ren X	area1997
ren Y	area1998
ren Z	area1999
ren AA	area2000
ren AB	area2001
ren AC	area2002
ren AD	area2003
ren AE	area2004
ren AF	area2005
ren AG	area2006
ren AH	area2007
ren AI	area2008
ren AJ	area2009
ren AK	area2010
ren AL	area2011
ren AM	area2012
ren AN	area2013
ren AO	area2014
ren AP	area2015
ren AQ	area2016
ren AR	area2017
ren AS	area2018
ren AT	area2019
ren AU	area2020
ren AV	area2021

clean_string nome_uf
merge m:1 nome_uf using `uf'
drop if _merge == 2
drop _merge nome_uf

collapse (sum) area*, by(sigla_uf id_classe)

reshape long area, i(sigla_uf id_classe) j(ano)

replace area = area / 100

drop if area == 0 | area == .

order sigla_uf id_classe ano
sort  sigla_uf id_classe ano

compress

save "output/data/cobertura_uf_classe.dta", replace
