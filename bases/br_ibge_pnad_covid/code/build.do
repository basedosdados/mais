
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
set more off

cd "path/to/Pesquisa Nacional de Amostra de Domicilios COVID (PNAD COVID)"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

import delimited "input/estados.csv", clear varn(1) encoding("utf-8")

keep id_estado estado_abrev
ren id_estado		id_uf
ren estado_abrev	sigla_uf

tempfile estados
save `estados'

foreach mes in 05 06 07 08 09 10 11 {
	
	import delimited "input/PNAD_COVID_`mes'2020.csv", clear varn(1) case(lower)
	
	ren uf		id_uf
	ren v1012	semana
	ren v1013	mes
	
	merge m:1 id_uf using `estados'
	drop if _merge == 2
	drop _merge id_uf
	
	tempfile `mes'2020
	save ``mes'2020'
	
	
}
*

use `052020', clear
foreach mes in 06 07 08 09 10 11 {
	append using ``mes'2020'
}
*

order ano mes semana sigla_uf capital rm_ride estrato upa v1008 v1016 v1022 v1023 v1030 v1031 v1032 posest ///
	a001 a001a a001b1 a001b2 a001b3 a002 a003 a004 a005 a006 a006a a006b a007 a007a a008 a009 ///
	b0011 b0012 b0013 b0014 b0015 b0016 b0017 b0018 b0019 b00110 b00111 b00112 b00113 b002 b0031 b0032 b0033 b0034 b0035 b0036 b0037 b0041 b0042 b0043 b0044 b0045 b0046 b005 b006 b007 b008 b009a b009b b009c b009d b009e b009f b0101 b0102 b0103 b0104 b0105 b0106 b011 ///
	c001 c002 c003 c004 c005 c0051 c0052 c0053 c006 c007 c007a c007b c007c c007d c007e c007e1 c007e2 c007f c008 c009 c009a c010 c0101 c01011 c01012 c0102 c01021 c01022 c0103 c0104 c011a c011a1 c011a11 c011a12 c011a2 c011a21 c011a22 c012 c013 c014 c015 c016 c017a ///
	d0011 d0013 d0021 d0023 d0031 d0033 d0041 d0043 d0051 d0053 d0061 d0063 d0071 d0073 ///
	e001 e0021 e0022 e0023 e0024 ///
	f001 f0021 f0022 f002a1 f002a2 f002a3 f002a4 f002a5 f0061 f006

sort ano mes upa v1008 v1016 posest a001

compress

tempfile microdados
save `microdados'

//------------------//
// particiona
//------------------//

!mkdir "output/microdados"

use `microdados', clear

levelsof sigla_uf, l(ufs)

foreach uf in `ufs' {
	
	!mkdir "output/microdados/sigla_uf=`uf'"
	
	use `microdados', clear
	keep if sigla_uf == "`uf'"
	drop sigla_uf
	export delimited "output/microdados/sigla_uf=`uf'/microdados.csv", replace datafmt
	
}
*
