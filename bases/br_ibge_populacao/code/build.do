
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
set more off

cd "/Users/rdahis/Dropbox/Academic/Data/Brazil/Municipios/Populacao"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

//-----------------//
// 1991-2000-2010
//-----------------//

import delimited "raw/populacao_censos.csv", clear //delim(";")
drop in 1/4
drop in 16696/16698
split v1, parse(;)
split v11, parse(" - ")
ren v111 id_municipio
ren v112 municipio
ren v12 ano
ren v13 populacao
replace ano = subinstr(ano, `"""',  "", .)
gen id_municipio_6 = substr(id_municipio, 1, 6)
destring, replace
destring populacao, replace force
drop if populacao == .
keep id_municipio_6 id_municipio ano municipio populacao
order id_municipio_6 id_municipio ano municipio populacao
save "tmp/1991_2010.dta", replace

//-----------------//
// 1992
//-----------------//

import excel "raw/1992/estimativa_populacao_1992.xls", clear
drop in 1/3
drop in 4975/4977
gen id_municipio_6 = B + substr(C, 2, 5)
ren D municipio
ren E populacao
drop A-C F-AT
destring, replace
gen ano = 1992
order id_municipio_6 municipio ano populacao
save "tmp/1992.dta", replace

//-----------------//
// 1993
//-----------------//

import excel "raw/1993/estimativa_populacao_1993.xls", clear
drop in 1/3
drop in 4975/5507
gen id_municipio_6 = B + substr(C, 2, 5)
ren D municipio
ren E populacao
drop A-C F-AN
destring, replace
gen ano = 1993
order id_municipio_6 municipio ano populacao
save "tmp/1993.dta", replace

//-----------------//
// 1994
//-----------------//

import excel "raw/1994/estimativa_populacao_1994.xls", clear
drop in 1/3
gen id_municipio_6 = B + substr(C, 2, 5)
ren D municipio
ren E populacao
drop A-C
destring, replace
gen ano = 1994
order id_municipio_6 municipio ano populacao
save "tmp/1994.dta", replace

//-----------------//
// 1995
//-----------------//

import excel "raw/1995/estimativa_populacao_1995.xls", clear
drop in 1/3
drop in 4975/4977
gen id_municipio_6 = B + substr(C, 2, 5)
ren D municipio
ren E populacao
drop A-C
destring, replace
gen ano = 1995
order id_municipio_6 municipio ano populacao
save "tmp/1995.dta", replace

//-----------------//
// 1996
//-----------------//

foreach uf in RO AC AM RR PA AP TO MA PI CE RN PB PE AL SE BA MG ES RJ SP PR SC RS MS MT GO DF {
	
	foreach k in CONT CONT96 {
		
		if "`k'" == "CONT" {
			local pop pop_expost_cf
		}
		else {
			local pop populacao
		}
		
		import excel "raw/1996/`k'/`uf'_`k'.xls", clear
		drop in 1/2
		drop if A == ""
		gen id_municipio = ""
		replace id_municipio = "11" + A if "`uf'" == "RO"
		replace id_municipio = "12" + A if "`uf'" == "AC"
		replace id_municipio = "13" + A if "`uf'" == "AM"
		replace id_municipio = "14" + A if "`uf'" == "RR"
		replace id_municipio = "15" + A if "`uf'" == "PA"
		replace id_municipio = "16" + A if "`uf'" == "AP"
		replace id_municipio = "17" + A if "`uf'" == "TO"
		replace id_municipio = "21" + A if "`uf'" == "MA"
		replace id_municipio = "22" + A if "`uf'" == "PI"
		replace id_municipio = "23" + A if "`uf'" == "CE"
		replace id_municipio = "24" + A if "`uf'" == "RN"
		replace id_municipio = "25" + A if "`uf'" == "PB"
		replace id_municipio = "26" + A if "`uf'" == "PE"
		replace id_municipio = "27" + A if "`uf'" == "AL"
		replace id_municipio = "28" + A if "`uf'" == "SE"
		replace id_municipio = "29" + A if "`uf'" == "BA"
		replace id_municipio = "31" + A if "`uf'" == "MG"
		replace id_municipio = "32" + A if "`uf'" == "ES"
		replace id_municipio = "33" + A if "`uf'" == "RJ"
		replace id_municipio = "35" + A if "`uf'" == "SP"
		replace id_municipio = "41" + A if "`uf'" == "PR"
		replace id_municipio = "42" + A if "`uf'" == "SC"
		replace id_municipio = "43" + A if "`uf'" == "RS"
		replace id_municipio = "50" + A if "`uf'" == "MS"
		replace id_municipio = "51" + A if "`uf'" == "MT"
		replace id_municipio = "52" + A if "`uf'" == "GO"
		replace id_municipio = "53" + A if "`uf'" == "DF"
		ren C `pop'
		keep id_municipio `pop'
		destring, replace ignore("-")
		save "tmp/1996_`k'_`uf'.dta", replace
	
	}
	
	use "tmp/1996_CONT_`uf'.dta", clear
	merge 1:1 id_municipio using "tmp/1996_CONT96_`uf'.dta"
	drop _merge
	order id_municipio
	save "tmp/1996_`uf'.dta", replace
	
	
}
*
use "tmp/1996_AC.dta", clear
foreach uf in RO AM RR PA AP TO MA PI CE RN PB PE AL SE BA MG ES RJ SP PR SC RS MS MT GO DF {
	append using "tmp/1996_`uf'.dta"
}
gen ano = 1996
gen id_municipio_6 = real(substr(string(id_municipio,"%7.0f"),1,6))
order id_municipio_6 id_municipio ano populacao
sort id_municipio
save "tmp/1996.dta", replace

//-----------------//
// 1997
//-----------------//

import excel "raw/1997/estimativa_populacao_1997.xls", clear
drop in 1/3
drop in 5508/5510
gen id_municipio_6 = B + substr(C, 2, 5)
ren D municipio
ren E populacao
drop A-C
destring, replace
gen ano = 1997
order id_municipio_6 municipio ano populacao
save "tmp/1997.dta", replace

//-----------------//
// 1998
//-----------------//

import excel "raw/1998/estimativa_populacao_1998.xls", clear
drop in 1/3
drop in 5508/5509
gen id_municipio_6 = B + substr(C, 2, 5)
ren D municipio
ren E populacao
drop A-C
destring, replace
gen ano = 1998
order id_municipio_6 municipio ano populacao
save "tmp/1998.dta", replace

//-----------------//
// 1999
//-----------------//

import excel "raw/1999/estimativa_populacao_1999.xls", clear
drop in 1/3
drop in 5508/5509
gen id_municipio_6 = B + substr(C, 2, 5)
ren D municipio
ren E populacao
drop A-C
destring, replace
gen ano = 1999
order id_municipio_6 municipio ano populacao
save "tmp/1999.dta", replace

//-----------------//
// 2001
//-----------------//

import excel "raw/2001/UF_Municipio.xls", clear
drop in 1/5
gen aux = strlen(C)
gen id_municipio_6 = ""
replace id_municipio_6 = B + "000" + C if aux == 1
replace id_municipio_6 = B + "00" + C if aux == 2
replace id_municipio_6 = B + "0" + C if aux == 3
replace id_municipio_6 = B + C if aux == 4
ren D municipio
ren E populacao
drop A-C F G aux
destring, replace
gen ano = 2001
order id_municipio_6 municipio ano populacao
save "tmp/2001.dta", replace

//-----------------//
// 2002
//-----------------//

import excel "raw/2002/POP-2002-DOU.xls", clear
drop in 1/6
drop in 5561
gen aux = strlen(C)
gen id_municipio_6 = ""
replace id_municipio_6 = B + "000" + C if aux == 1
replace id_municipio_6 = B + "00" + C if aux == 2
replace id_municipio_6 = B + "0" + C if aux == 3
replace id_municipio_6 = B + C if aux == 4
ren D municipio
ren E populacao
drop A-C aux
destring, replace
gen ano = 2002
order id_municipio_6 municipio ano populacao
save "tmp/2002.dta", replace

//-----------------//
// 2003
//-----------------//

import excel "raw/2003/POP-2003-TCU.xls", clear
drop in 1/5
drop in 5561/5566
gen aux = strlen(C)
gen id_municipio_6 = ""
replace id_municipio_6 = B + "000" + C if aux == 1
replace id_municipio_6 = B + "00" + C if aux == 2
replace id_municipio_6 = B + "0" + C if aux == 3
replace id_municipio_6 = B + C if aux == 4
ren D municipio
ren E populacao
drop A-C aux
destring, replace
gen ano = 2003
order id_municipio_6 municipio ano populacao
save "tmp/2003.dta", replace

//-----------------//
// 2004
//-----------------//

import excel "raw/2004/POP2004-TCU.xls", clear
drop in 1/5
drop in 5565/5570
gen aux = strlen(C)
gen id_municipio_6 = ""
replace id_municipio_6 = B + "000" + C if aux == 1
replace id_municipio_6 = B + "00" + C if aux == 2
replace id_municipio_6 = B + "0" + C if aux == 3
replace id_municipio_6 = B + C if aux == 4
ren D municipio
ren E populacao
drop A-C aux
destring, replace
gen ano = 2004
order id_municipio_6 municipio ano populacao
save "tmp/2004.dta", replace

//-----------------//
// 2005
//-----------------//

import excel "raw/2005/POP-2005-DOU.xls", clear
drop in 1/5
drop in 5565
gen aux = strlen(C)
gen id_municipio_6 = ""
replace id_municipio_6 = B + "000" + C if aux == 1
replace id_municipio_6 = B + "00" + C if aux == 2
replace id_municipio_6 = B + "0" + C if aux == 3
replace id_municipio_6 = B + C if aux == 4
ren D municipio
ren E populacao
drop A-C aux
destring, replace
gen ano = 2005
order id_municipio_6 municipio ano populacao
save "tmp/2005.dta", replace

//-----------------//
// 2006
//-----------------//

import excel "raw/2006/POP2006-TCU.xls", clear
drop in 1/5
drop in 5565/5567
gen aux = strlen(C)
gen id_municipio_6 = ""
replace id_municipio_6 = B + "000" + C if aux == 1
replace id_municipio_6 = B + "00" + C if aux == 2
replace id_municipio_6 = B + "0" + C if aux == 3
replace id_municipio_6 = B + C if aux == 4
ren D municipio
ren E populacao
drop A-C aux
destring, replace
gen ano = 2006
order id_municipio_6 municipio ano populacao
save "tmp/2006.dta", replace

//-----------------//
// 2007
//-----------------//

import excel "raw/2007/popmunic2007layoutTCU14112007.xls", clear
drop in 1/4
drop in 5565/5570
gen id_municipio = B + C
gen id_municipio_6 = substr(id_municipio, 1, 6)
ren D municipio
ren E populacao
drop A-C
destring, replace
gen ano = 2007
order id_municipio_6 id_municipio municipio ano populacao
save "tmp/2007.dta", replace

//-----------------//
// 2008
//-----------------//

import excel "raw/2008/POP2008_DOU.xls", clear
drop in 1/5
drop in 5566/5567
gen id_municipio = B + C
gen id_municipio_6 = substr(id_municipio, 1, 6)
ren D municipio
ren E populacao
drop A-C
destring, replace
gen ano = 2008
order id_municipio_6 id_municipio municipio ano populacao
save "tmp/2008.dta", replace

//-----------------//
// 2009
//-----------------//

import excel "raw/2009/UF_Municipio.xls", clear //  2
drop in 1/5
drop in 5566/5571
gen aux = strlen(C)
gen id_municipio = ""
replace id_municipio = B + "0000" + C if aux == 1
replace id_municipio = B + "000"  + C if aux == 2
replace id_municipio = B + "00"   + C if aux == 3
replace id_municipio = B + "0"    + C if aux == 4
replace id_municipio = B          + C if aux == 5
gen id_municipio_6 = substr(id_municipio, 1, 6)
ren D municipio
ren E populacao
drop A-C F aux
destring, replace
destring populacao, force replace
gen ano = 2009
order id_municipio_6 id_municipio municipio ano populacao
save "tmp/2009.dta", replace

//-----------------//
// 2011
//-----------------//

import excel "raw/2011/POP2011_DOU.xls", clear
drop in 1/3
drop in 5566/65530
gen id_municipio = B + C
gen id_municipio_6 = substr(id_municipio, 1, 6)
ren D municipio
ren E populacao
drop A-C
replace populacao = subinstr(populacao, "(*)", "", .)
replace populacao = subinstr(populacao, ".", "", .)
destring, replace
gen ano = 2011
order id_municipio_6 id_municipio municipio ano populacao
save "tmp/2011.dta", replace

//-----------------//
// 2012
//-----------------//

import excel "raw/2012/estimativa_2012_TCU_20170614.xls", clear sheet("Municípios")
drop in 1/2
drop in 5571/5575
gen id_municipio = B + C
gen id_municipio_6 = substr(id_municipio, 1, 6)
ren D municipio
ren E populacao
drop A-C F
replace populacao = subinstr(populacao, "(*)", "", .)
replace populacao = subinstr(populacao, "(1)", "", .)
replace populacao = subinstr(populacao, "(2)", "", .)
replace populacao = subinstr(populacao, "(3)", "", .)
replace populacao = subinstr(populacao, ".", "", .)
destring, replace
gen ano = 2012
order id_municipio_6 id_municipio municipio ano populacao
save "tmp/2012.dta", replace

//-----------------//
// 2013
//-----------------//

import excel "raw/2013/estimativa_2013_TCU_20170614.xls", clear sheet("Municípios")
drop in 1/2
drop in 5571/5573
gen id_municipio = B + C
gen id_municipio_6 = substr(id_municipio, 1, 6)
ren D municipio
ren E populacao
drop A-C
replace populacao = subinstr(populacao, "(*)", "", .)
replace populacao = subinstr(populacao, "(1)", "", .)
replace populacao = subinstr(populacao, "(2)", "", .)
replace populacao = subinstr(populacao, "(3)", "", .)
replace populacao = subinstr(populacao, ".", "", .)
destring, replace
gen ano = 2013
order id_municipio_6 id_municipio municipio ano populacao
save "tmp/2013.dta", replace

//-----------------//
// 2014
//-----------------//

import excel "raw/2014/estimativa_TCU_2014_20170614.xls", clear sheet("Municípios")
drop in 1/2
drop in 5571/5576
gen id_municipio = B + C
gen id_municipio_6 = substr(id_municipio, 1, 6)
ren D municipio
ren E populacao
drop A-C F
replace populacao = subinstr(populacao, "(1)", "", .)
replace populacao = subinstr(populacao, "(2)", "", .)
replace populacao = subinstr(populacao, ".", "", .)
destring, replace
gen ano = 2014
order id_municipio_6 id_municipio municipio ano populacao
save "tmp/2014.dta", replace

//-----------------//
// 2015
//-----------------//

import excel "raw/2015/estimativa_TCU_2015_20170614.xls", clear sheet("Municípios")
drop in 1/2
drop in 5571/5577
gen id_municipio = B + C
gen id_municipio_6 = substr(id_municipio, 1, 6)
ren D municipio
ren E populacao
drop A-C
replace populacao = subinstr(populacao, "(*)", "", .)
replace populacao = subinstr(populacao, "(1)", "", .)
replace populacao = subinstr(populacao, "(2)", "", .)
replace populacao = subinstr(populacao, "(3)", "", .)
replace populacao = subinstr(populacao, "(4)", "", .)
replace populacao = subinstr(populacao, "(5)", "", .)
replace populacao = subinstr(populacao, ".", "", .)
destring, replace
gen ano = 2015
order id_municipio_6 id_municipio municipio ano populacao
save "tmp/2015.dta", replace

//-----------------//
// 2016
//-----------------//

import excel "raw/2016/estimativa_TCU_2016_20170614.xls", clear sheet("Municípios")
drop in 1/2
drop in 5571/5577
gen id_municipio = B + C
gen id_municipio_6 = substr(id_municipio, 1, 6)
ren D municipio
ren E populacao
drop A-C
replace populacao = subinstr(populacao, "(*)", "", .)
replace populacao = subinstr(populacao, "(1)", "", .)
replace populacao = subinstr(populacao, "(2)", "", .)
replace populacao = subinstr(populacao, "(3)", "", .)
replace populacao = subinstr(populacao, "(4)", "", .)
replace populacao = subinstr(populacao, "(5)", "", .)
replace populacao = subinstr(populacao, ".", "", .)
destring, replace
gen ano = 2016
order id_municipio_6 id_municipio municipio ano populacao
save "tmp/2016.dta", replace

//-----------------//
// 2017
//-----------------//

import excel "raw/2017/POP2017_20210331.xls", clear sheet(Municípios)
drop in 1/2
drop in 5571/5585
gen id_municipio = B + C
gen id_municipio_6 = substr(id_municipio, 1, 6)
ren D municipio
ren E populacao
drop A-C
split populacao, p("(")
drop populacao populacao2
ren populacao1 populacao
replace populacao = subinstr(populacao, ".", "", .)
destring, replace
gen ano = 2017
order id_municipio_6 id_municipio municipio ano populacao
save "tmp/2017.dta", replace

//-----------------//
// 2018
//-----------------//

import excel "raw/2018/estimativa_TCU_2018_20200622.xls", clear sheet(Municípios)
drop in 1/2
drop in 5571/5594
gen id_municipio = B + C
gen id_municipio_6 = substr(id_municipio, 1, 6)
ren D municipio
ren E populacao
drop A-C F-N
split populacao, p("(")
drop populacao populacao2
ren populacao1 populacao
destring, replace
gen ano = 2018
order id_municipio_6 id_municipio municipio ano populacao
save "tmp/2018.dta", replace

//-----------------//
// 2019
//-----------------//

import excel "raw/2019/estimativa_TCU_2019_20200622.xls", clear sheet(Municípios)
drop in 1/2
drop in 5571/5591
gen id_municipio = B + C
gen id_municipio_6 = substr(id_municipio, 1, 6)
ren D municipio
ren E populacao
drop A-C
split populacao, p("(")
drop populacao populacao2
ren populacao1 populacao
replace populacao = subinstr(populacao, ".", "", .)
destring, replace
gen ano = 2019
order id_municipio_6 id_municipio municipio ano populacao
save "tmp/2019.dta", replace

//-----------------//
// 2020
//-----------------//

import excel "raw/2020/POP2020_20210331.xls", clear sheet(Municípios)
drop in 1/2
drop in 5571/5593
gen id_municipio = B + C
gen id_municipio_6 = substr(id_municipio, 1, 6)
ren D municipio
ren E populacao
split populacao, p("(") l(1)
drop populacao
ren populacao1 populacao
destring, replace
gen ano = 2020
keep  id_municipio_6 id_municipio municipio ano populacao
order id_municipio_6 id_municipio municipio ano populacao
save "tmp/2020.dta", replace

//-----------------//
// 2021
//-----------------//

import excel "raw/2021/estimativa_dou_2021.xls", clear sheet(Municípios)
drop in 1/2
drop in 5571/5593
gen id_municipio = B + C
gen id_municipio_6 = substr(id_municipio, 1, 6)
ren D municipio
ren E populacao
split populacao, p("(") l(1)
drop populacao
ren populacao1 populacao
replace populacao = subinstr(populacao, ".", "", .)
destring, replace
gen ano = 2021
keep  id_municipio_6 id_municipio municipio ano populacao
order id_municipio_6 id_municipio municipio ano populacao
save "tmp/2021.dta", replace

//-----------------//
// 2022
//-----------------//

import excel "raw/2022/POP2022_Municipios_20230616.xls", clear //sheet()
drop in 1/2
drop in 5571/5605
gen id_municipio = B + C
gen id_municipio_6 = substr(id_municipio, 1, 6)
ren D municipio
ren E populacao
split populacao, p("(") l(1)
drop populacao
ren populacao1 populacao
replace populacao = subinstr(populacao, ".", "", .)
destring, replace
gen ano = 2022
keep  id_municipio_6 id_municipio municipio ano populacao
order id_municipio_6 id_municipio municipio ano populacao
save "tmp/2022.dta", replace


//-------------------------------//
// append
//-------------------------------//

import delimited "../../Diretorio/municipio.csv", clear
keep id_municipio id_municipio_6 sigla_uf
tempfile munic
save `munic'

use "tmp/1991_2010.dta", clear
foreach ano of numlist 1992(1)1999 2001(1)2009 2011(1)2022 {
	append using "tmp/`ano'.dta"
}
*

drop id_municipio

merge m:1 id_municipio_6 using `munic'
drop if _merge == 2
drop _merge

keep  ano sigla_uf id_municipio populacao
order ano sigla_uf id_municipio populacao
sort  id_municipio ano

export delimited "output/municipio.csv", replace

//-------------------------------//
// agregacoes
//-------------------------------//

//--------------//
// UF
//--------------//

// 2023-06-16
//	atenção à inconsistência nos dados de AM de 2022
//	a soma de municípios dá diferente do que o IBGE reporta como total da UF.
//	nossa decisão: seguir a planilha de UF, e consertar na mão essa soma abaixo

collapse (sum) populacao, by(ano sigla_uf)

export delimited "output/uf.csv", replace

//--------------//
// Brasil
//--------------//

collapse (sum) populacao, by(ano)

export delimited "output/brasil.csv", replace

