
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
set excelxlsxlargefile on

cd "atalho/para/SEEG"

//----------------------------------------------------------------------------//
// build: brasil
//----------------------------------------------------------------------------//

import excel "input/1-SEEG8_GERAL-BR_UF_2020.11.05_-_SITE.xls", clear sheet("GEE Brasil") locale("utf-8") // cellrang(A1:AF50000)

drop in 1

drop I BJ-BN

ren A	nivel_1
ren B	nivel_2
ren C	nivel_3
ren D	nivel_4
ren E	nivel_5
ren F	nivel_6
ren G	tipo_emissao
ren H	gas
ren J	atividade_economica
ren K	produto
ren L	emissao1970
ren M	emissao1971
ren N	emissao1972
ren O	emissao1973
ren P	emissao1974
ren Q	emissao1975
ren R	emissao1976
ren S	emissao1977
ren T	emissao1978
ren U	emissao1979
ren V	emissao1980
ren W	emissao1981
ren X	emissao1982
ren Y	emissao1983
ren Z	emissao1984
ren AA	emissao1985
ren AB	emissao1986
ren AC	emissao1987
ren AD	emissao1988
ren AE	emissao1989
ren AF	emissao1990
ren AG	emissao1991
ren AH	emissao1992
ren AI	emissao1993
ren AJ	emissao1994
ren AK	emissao1995
ren AL	emissao1996
ren AM	emissao1997
ren AN	emissao1998
ren AO	emissao1999
ren AP	emissao2000
ren AQ	emissao2001
ren AR	emissao2002
ren AS	emissao2003
ren AT	emissao2004
ren AU	emissao2005
ren AV	emissao2006
ren AW	emissao2007
ren AX	emissao2008
ren AY	emissao2009
ren AZ	emissao2010
ren BA	emissao2011
ren BB	emissao2012
ren BC	emissao2013
ren BD	emissao2014
ren BE	emissao2015
ren BF	emissao2016
ren BG	emissao2017
ren BH	emissao2018
ren BI	emissao2019

foreach k of varlist nivel_* atividade_economica produto {
	replace `k' = "" if `k' == "NA"
}
*

reshape long emissao, i(nivel_1 nivel_2 nivel_3 nivel_4 nivel_5 nivel_6 tipo_emissao gas) j(ano)

destring emissao, replace

order ano nivel_1 nivel_2 nivel_3 nivel_4 nivel_5 nivel_6 tipo_emissao gas atividade_economica produto ano emissao

export delimited "output/brasil.csv", replace datafmt

//----------------------------------------------------------------------------//
// build: UF
//----------------------------------------------------------------------------//

import excel "input/1-SEEG8_GERAL-BR_UF_2020.11.05_-_SITE.xls", clear sheet("GEE Estados") locale("utf-8") // cellrang(A1:AF50000)

drop in 1

ren A	nivel_1
ren B	nivel_2
ren C	nivel_3
ren D	nivel_4
ren E	nivel_5
ren F	nivel_6
ren G	tipo_emissao
ren H	gas
ren I	sigla_uf
ren J	atividade_economica
ren K	produto
ren L	emissao1970
ren M	emissao1971
ren N	emissao1972
ren O	emissao1973
ren P	emissao1974
ren Q	emissao1975
ren R	emissao1976
ren S	emissao1977
ren T	emissao1978
ren U	emissao1979
ren V	emissao1980
ren W	emissao1981
ren X	emissao1982
ren Y	emissao1983
ren Z	emissao1984
ren AA	emissao1985
ren AB	emissao1986
ren AC	emissao1987
ren AD	emissao1988
ren AE	emissao1989
ren AF	emissao1990
ren AG	emissao1991
ren AH	emissao1992
ren AI	emissao1993
ren AJ	emissao1994
ren AK	emissao1995
ren AL	emissao1996
ren AM	emissao1997
ren AN	emissao1998
ren AO	emissao1999
ren AP	emissao2000
ren AQ	emissao2001
ren AR	emissao2002
ren AS	emissao2003
ren AT	emissao2004
ren AU	emissao2005
ren AV	emissao2006
ren AW	emissao2007
ren AX	emissao2008
ren AY	emissao2009
ren AZ	emissao2010
ren BA	emissao2011
ren BB	emissao2012
ren BC	emissao2013
ren BD	emissao2014
ren BE	emissao2015
ren BF	emissao2016
ren BG	emissao2017
ren BH	emissao2018
ren BI	emissao2019

foreach k of varlist nivel_* atividade_economica produto {
	replace `k' = "" if `k' == "NA"
}
*

reshape long emissao, i(sigla_uf nivel_1 nivel_2 nivel_3 nivel_4 nivel_5 nivel_6 tipo_emissao gas) j(ano)

destring emissao, replace

order ano sigla_uf nivel_1 nivel_2 nivel_3 nivel_4 nivel_5 nivel_6 tipo_emissao gas atividade_economica produto ano emissao

tempfile uf
save `uf'

//-------------------//
// particiona
//-------------------//

! mkdir "output/uf"

levelsof ano, local(anos)

foreach ano in `anos' {
	
	! mkdir "output/uf/ano=`ano'"
	
	use `uf', clear
	keep if ano == `ano'
	drop ano
	export delimited "output/uf/ano=`ano'/uf.csv", replace datafmt
	
}
*


//----------------------------------------------------------------------------//
// build: municipio
//----------------------------------------------------------------------------//

import excel "input/TABELAO_MUNICIPIOS_COMPLETO_2000a2018_GWPAR5.xlsx", clear sheet("BD GEE Municipios GWP-AR5") locale("utf-8") // cellrang(A1:AF50000)

drop in 1

drop K

ren A	nivel_1
ren B	nivel_2
ren C	nivel_3
ren D	nivel_4
ren E	nivel_5
ren F	nivel_6
ren G	tipo_emissao
ren H	gas
ren I	sigla_uf
ren J	id_municipio
ren L	atividade_economica
ren M	produto
ren N	emissao2000
ren O	emissao2001
ren P	emissao2002
ren Q	emissao2003
ren R	emissao2004
ren S	emissao2005
ren T	emissao2006
ren U	emissao2007
ren V	emissao2008
ren W	emissao2009
ren X	emissao2010
ren Y	emissao2011
ren Z	emissao2012
ren AA	emissao2013
ren AB	emissao2014
ren AC	emissao2015
ren AD	emissao2016
ren AE	emissao2017
ren AF	emissao2018

drop if id_municipio == "NA"	// atencao: retirando observacoes sem municipio atribuido

foreach k of varlist nivel_* atividade_economica produto {
	replace `k' = "" if `k' == "NA"
}
*

reshape long emissao, i(id_municipio nivel_1 nivel_2 nivel_3 nivel_4 nivel_5 nivel_6) j(ano)

destring emissao, replace

order ano sigla_uf id_municipio nivel_1 nivel_2 nivel_3 nivel_4 nivel_5 nivel_6 tipo_emissao gas atividade_economica produto ano emissao

tempfile municipio
save `municipio'

//-------------------//
// particiona
//-------------------//

! mkdir "output/municipio"

levelsof ano, local(anos)

foreach ano in `anos' {
	
	! mkdir "output/municipio/ano=`ano'"
	
	use `municipio', clear
	keep if ano == `ano'
	drop ano
	export delimited "output/municipio/ano=`ano'/municipio.csv", replace datafmt
	
}
*

