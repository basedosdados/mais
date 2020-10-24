
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

cd "path/to/Pesquisa Nacional de Amostra de Domicilios COVID (PNAD COVID)"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

import delimited "input/estados.csv", clear varn(1) encoding("utf-8")

drop estado regiao

tempfile estados
save `estados'

foreach mes in 05 06 07 08 {
	
	import delimited "input/PNAD_COVID_`mes'2020.csv", clear varn(1) case(preserve)
	
	ren Ano		ano
	ren UF		id_estado
	ren CAPITAL	capital
	ren RM_RIDE	rm_ride
	ren V1008	numero_domicilio
	ren V1012	semana
	ren V1013	mes
	ren V1016	numero_entrevista
	ren Estrato	estrato
	ren UPA		UPA
	ren V1022	situacao
	ren V1023	tipo_area
	ren V1030	projecao_pop
	ren V1031	peso_pre_estrat
	ren V1032	peso_pos_estrat
	ren posest	posest
	ren A001	ordem
	
	merge m:1 id_estado using `estados'
	drop if _merge == 2
	drop _merge id_estado
	
	replace capital = (capital != .)
	replace rm_ride = (rm_ride != .)
	
	tempfile `mes'2020
	save ``mes'2020'
	
	
}
*

use `052020', clear
foreach mes in 06 07 08 {
	append using ``mes'2020'
}
*

order ano mes semana estado_abrev capital rm_ride estrato UPA numero_domicilio numero_entrevista ordem situacao tipo_area projecao_pop peso_pre_estrat peso_pos_estrat posest ///
	A001A A001B1 A001B2 A001B3 A002 A003 A004 A005 A006 A007 A008 A009 ///
	B0011 B0012 B0013 B0014 B0015 B0016 B0017 B0018 B0019 B00110 B00111 B00112 B00113 B002 B0031 B0032 B0033 B0034 B0035 B0036 B0037 B0041 B0042 B0043 B0044 B0045 B0046 B005 B006 B007 B008 B009A B009B B009C B009D B009E B009F B0101 B0102 B0103 B0104 B0105 B0106 B011 ///
	C001 C002 C003 C004 C005 C0051 C0052 C0053 C006 C007 C007A C007B C007C C007D C007E C007E1 C007E2 C007F C008 C009 C009A C010 C0101 C01011 C01012 C0102 C01021 C01022 C0103 C0104 C011A C011A1 C011A11 C011A12 C011A2 C011A21 C011A22 C012 C013 C014 C015 C016 C017A ///
	D0011 D0013 D0021 D0023 D0031 D0033 D0041 D0043 D0051 D0053 D0061 D0063 D0071 D0073 ///
	E001 E0021 E0022 E0023 E0024 ///
	F001 F0021 F0022 F006 F0061 F002A1 F002A2 F002A3 F002A4 F002A5

sort ano mes UPA numero_domicilio numero_entrevista posest ordem

compress

save "output/microdados.dta", replace

//------------------//
// particiona
//------------------//

!mkdir "output/microdados"

use "output/microdados.dta", clear

levelsof estado_abrev, l(estados)

foreach estado in `estados' {
	
	!mkdir "output/microdados/estado_abrev=`estado'"
	
	use "output/microdados.dta", clear
	keep if estado_abrev == "`estado'"
	drop estado_abrev
	export delimited "output/microdados/estado_abrev=`estado'/microdados.csv", replace
	
}
*
