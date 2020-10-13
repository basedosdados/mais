
//----------------------------------------------------------------------------//
// build: limpeza e normalizacao
//----------------------------------------------------------------------------//

//-------------------------------------------------//
// candidatos
//-------------------------------------------------//

use "output/candidatos_1998.dta", clear
append using "output/candidatos_2000.dta"
append using "output/candidatos_2002.dta"
append using "output/candidatos_2004.dta"
append using "output/candidatos_2006.dta"
append using "output/candidatos_2008.dta"
append using "output/candidatos_2010.dta"
append using "output/candidatos_2012.dta"
append using "output/candidatos_2014.dta"
append using "output/candidatos_2016.dta"
append using "output/candidatos_2018.dta"
append using "output/candidatos_2020.dta"

drop if turno == 2
drop turno resultado

merge m:1 CPF titulo_eleitoral nome_candidato using "output/id_candidato_BD.dta"
keep if _merge == 3	// dropa observacoes sem id_candidato
drop _merge

//------------//
// limpando
// duplicadas
//------------//

local vars ano tipo_eleicao estado_abrev id_municipio_TSE numero_candidato cargo id_candidato_BD
duplicates tag `vars', gen(dup)
duplicates drop `vars' if dup > 0, force
drop dup

local vars ano tipo_eleicao estado_abrev id_municipio_TSE numero_candidato cargo
duplicates tag `vars', gen(dup)
drop if dup > 0 & situacao != "deferido"
drop dup

local vars ano tipo_eleicao estado_abrev id_municipio_TSE numero_candidato cargo
duplicates tag `vars', gen(dup)
drop if dup > 0
drop dup

local vars id_candidato_BD ano tipo_eleicao
duplicates drop `vars', force

drop coligacao composicao

order tipo_eleicao ano id_candidato_BD CPF titulo_eleitoral sequencial_candidato ///
	numero_candidato nome_candidato nome_urna_candidato numero_partido partido cargo estado_abrev id_municipio_TSE

compress

save "output/norm_candidatos.dta", replace

//------------//
// particiona
//------------//

!mkdir "output/candidatos"

use "output/norm_candidatos.dta", clear

levelsof ano, l(anos)
foreach ano in `anos' {
	levelsof estado_abrev if ano == `ano', l(estados_`ano')
}
*

foreach ano in `anos' {
	
	!mkdir "output/candidatos/ano=`ano'"
	
	foreach estado_abrev in `estados_`ano'' {
		
		!mkdir "output/candidatos/ano=`ano'/estado_abrev=`estado_abrev'"
		
		use "output/norm_candidatos.dta", clear
		keep if ano == `ano' & estado_abrev == "`estado_abrev'"
		drop ano estado_abrev
		export delimited "output/candidatos/ano=`ano'/estado_abrev=`estado_abrev'/candidatos.csv", replace
		
	}
}
*

//-------------------------------------------------//
// partidos
//-------------------------------------------------//

use "output/norm_candidatos.dta", clear

keep ano numero_partido partido

duplicates drop

compress

save "output/norm_partidos.dta", replace

//-------------------------------------------------//
// coligacoes
//-------------------------------------------------//

!mkdir "output/coligacoes"

foreach ano of numlist 1990 1994(2)2020 {
	
	!mkdir "output/coligacoes/ano=`ano'"
	
	use "output/coligacoes_`ano'.dta", clear
	
	levelsof estado_abrev, l(estados)
	
	foreach estado_abrev in `estados' {
		
		!mkdir "output/coligacoes/ano=`ano'/estado_abrev=`estado_abrev'"
		
		use "output/coligacoes_`ano'.dta", clear
		keep if ano == `ano' & estado_abrev == "`estado_abrev'"
		drop ano estado_abrev
		export delimited "output/coligacoes/ano=`ano'/estado_abrev=`estado_abrev'/coligacoes.csv", replace
		
	}
}
*

//-------------------------------------------------//
// resultados municipio-zona
//-------------------------------------------------//

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 0
keep id_candidato_BD ano tipo_eleicao estado_abrev id_municipio_TSE cargo numero_candidato

tempfile candidatos_mod0
save `candidatos_mod0'

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 2 & cargo != "presidente"
keep id_candidato_BD ano tipo_eleicao estado_abrev cargo numero_candidato

tempfile candidatos_mod2_estadual
save `candidatos_mod2_estadual'

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 2 & cargo == "presidente"
keep id_candidato_BD ano tipo_eleicao cargo numero_candidato

tempfile candidatos_mod2_presid
save `candidatos_mod2_presid'

!mkdir "output/resultados_candidato_municipio_zona"
!mkdir "output/resultados_partido_municipio_zona"

foreach ano of numlist 1998(2)2018 {
	
	//---------------------//
	// candidato
	//---------------------//
	
	use "output/resultados_candidato_municipio_zona_`ano'.dta", clear
	
	if mod(`ano', 4) == 0 {
		
		merge m:1 ano tipo_eleicao estado_abrev id_municipio_TSE cargo numero_candidato using `candidatos_mod0'
		drop if _merge == 2
		drop _merge
		
	}
	else {
		
		preserve
			
			keep if cargo != "presidente"
			
			merge m:1 ano tipo_eleicao estado_abrev cargo numero_candidato using `candidatos_mod2_estadual' // nome_candidato
			drop if _merge == 2
			drop _merge
			
			tempfile resultados_mod2_estadual
			save `resultados_mod2_estadual'
			
		restore
		preserve
			
			keep if cargo == "presidente"
			
			merge m:1 ano tipo_eleicao cargo numero_candidato using `candidatos_mod2_presid' // nome_candidato
			drop if _merge == 2
			drop _merge
			
			tempfile resultados_mod2_presid
			save `resultados_mod2_presid'
			
		restore
		
		use `resultados_mod2_estadual', clear
		append using `resultados_mod2_presid'
		
	}
	*
	
	drop nome_candidato nome_urna_candidato sequencial_candidato coligacao composicao
	
	local vars tipo_eleicao ano turno estado_abrev id_municipio_TSE zona numero_candidato id_candidato_BD cargo partido votos resultado
	
	order `vars'
	sort  `vars'
	
	tempfile resultados_candidato
	save `resultados_candidato'
	
	//------------//
	// particiona
	//------------//
	
	!mkdir "output/resultados_candidato_municipio_zona/ano=`ano'"
	
	use `resultados_candidato', clear
	
	levelsof estado_abrev, l(estados)
	foreach estado_abrev in `estados' {
		
		!mkdir "output/resultados_candidato_municipio_zona/ano=`ano'/estado_abrev=`estado_abrev'"
		
		use `resultados_candidato', clear
		keep if ano == `ano' & estado_abrev == "`estado_abrev'"
		drop ano estado_abrev
		export delimited "output/resultados_candidato_municipio_zona/ano=`ano'/estado_abrev=`estado_abrev'/resultados_candidato_municipio_zona.csv", replace
		
	}
	*
	
	//---------------------//
	// partido
	//---------------------//
	
	use "output/resultados_partido_municipio_zona_`ano'.dta", clear
	
	drop coligacao composicao
	
	local vars tipo_eleicao ano turno estado_abrev id_municipio_TSE zona cargo partido
	
	order `vars'
	sort  `vars'
	
	tempfile resultados_partido
	save `resultados_partido'
	
	//------------//
	// particiona
	//------------//
	
	!mkdir "output/resultados_partido_municipio_zona/ano=`ano'"
	
	use `resultados_partido', clear
	
	levelsof estado_abrev, l(estados)
	foreach estado_abrev in `estados' {
		
		!mkdir "output/resultados_partido_municipio_zona/ano=`ano'/estado_abrev=`estado_abrev'"
		
		use `resultados_partido', clear
		keep if ano == `ano' & estado_abrev == "`estado_abrev'"
		drop ano estado_abrev
		export delimited "output/resultados_partido_municipio_zona/ano=`ano'/estado_abrev=`estado_abrev'/resultados_partido_municipio_zona.csv", replace
		
	}
}
*

//-------------------------------------------------//
// resultados secao
//-------------------------------------------------//

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 0
keep id_candidato_BD ano tipo_eleicao estado_abrev id_municipio_TSE cargo numero_candidato partido

tempfile candidatos_mod0
save `candidatos_mod0'

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 2 & cargo != "presidente"
keep id_candidato_BD ano tipo_eleicao estado_abrev cargo numero_candidato partido

tempfile candidatos_mod2_estadual
save `candidatos_mod2_estadual'

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 2 & cargo == "presidente"
keep id_candidato_BD ano tipo_eleicao cargo numero_candidato partido

tempfile candidatos_mod2_presid
save `candidatos_mod2_presid'

!mkdir "output/resultados_candidato_secao"
!mkdir "output/resultados_partido_secao"

foreach ano of numlist 1998(2)2018 {
	
	//---------------------//
	// candidato
	//---------------------//
	
	use "output/resultados_candidato_secao_`ano'.dta", clear
	
	if mod(`ano', 4) == 0 {
		
		merge m:1 ano tipo_eleicao estado_abrev id_municipio_TSE cargo numero_candidato using `candidatos_mod0'
		drop if _merge == 2
		drop _merge
		
	}
	else {
		
		preserve
			
			keep if cargo != "presidente"
			
			merge m:1 ano tipo_eleicao estado_abrev cargo numero_candidato using `candidatos_mod2_estadual'
			drop if _merge == 2
			drop _merge
			
			tempfile resultados_mod2_estadual
			save `resultados_mod2_estadual'
			
		restore
		preserve
			
			keep if cargo == "presidente"
			
			merge m:1 ano tipo_eleicao cargo numero_candidato using `candidatos_mod2_presid'
			drop if _merge == 2
			drop _merge
			
			tempfile resultados_mod2_presid
			save `resultados_mod2_presid'
			
		restore
		
		use `resultados_mod2_estadual', clear
		append using `resultados_mod2_presid'
		
	}
	*
	
	local vars ano tipo_eleicao turno estado_abrev id_municipio_TSE zona secao numero_candidato id_candidato_BD cargo partido votos
	
	order `vars'
	sort  `vars'
	
	tempfile resultados_candidato
	save `resultados_candidato'
	
	//------------//
	// particiona
	//------------//
	
	!mkdir "output/resultados_candidato_secao/ano=`ano'"
	
	use `resultados_candidato', clear
	
	levelsof estado_abrev, l(estados)
	foreach estado_abrev in `estados' {
		
		!mkdir "output/resultados_candidato_secao/ano=`ano'/estado_abrev=`estado_abrev'"
		
		use `resultados_candidato', clear
		keep if ano == `ano' & estado_abrev == "`estado_abrev'"
		drop ano estado_abrev
		export delimited "output/resultados_candidato_secao/ano=`ano'/estado_abrev=`estado_abrev'/resultados_candidato_secao.csv", replace
		
	}
	*
	
	//---------------------//
	// partido
	//---------------------//
	
	use "output/resultados_partido_secao_`ano'.dta", clear
	
	merge m:1 ano numero_partido using "output/norm_partidos.dta"
	drop if _merge == 2
	drop _merge
	
	drop numero_partido
	
	local vars ano tipo_eleicao turno estado_abrev id_municipio_TSE zona secao cargo partido
	
	order `vars'
	sort  `vars'
	
	tempfile resultados_partido
	save `resultados_partido'
	
	//------------//
	// particiona
	//------------//
	
	!mkdir "output/resultados_partido_secao/ano=`ano'"
	
	use `resultados_partido', clear
	
	levelsof estado_abrev, l(estados)
	foreach estado_abrev in `estados' {
		
		!mkdir "output/resultados_partido_secao/ano=`ano'/estado_abrev=`estado_abrev'"
		
		use `resultados_partido', clear
		keep if ano == `ano' & estado_abrev == "`estado_abrev'"
		drop ano estado_abrev
		export delimited "output/resultados_partido_secao/ano=`ano'/estado_abrev=`estado_abrev'/resultados_partido_secao.csv", replace
		
	}
}
*

//-------------------------------------------------//
// perfil eleitorado
//-------------------------------------------------//

!mkdir "output/perfil_eleitorado"

foreach ano of numlist 1996(2)2020 {
	
	!mkdir "output/perfil_eleitorado/ano=`ano'"
	
	use "output/perfil_eleitorado_`ano'.dta", clear
	levelsof estado_abrev, l(estados)
	
	foreach estado_abrev in `estados' {
		
		!mkdir "output/perfil_eleitorado/ano=`ano'/estado_abrev=`estado_abrev'"
		
		use "output/perfil_eleitorado_`ano'.dta", clear
		keep if estado_abrev == "`estado_abrev'"
		drop ano estado_abrev
		export delimited "output/perfil_eleitorado/ano=`ano'/estado_abrev=`estado_abrev'/perfil_eleitorado.csv", replace
		
	}
}
*

//-------------------------------------------------//
// detalhes votacao municipio-zona
//-------------------------------------------------//

!mkdir "output/detalhes_votacao_municipio_zona"

foreach ano of numlist 1998(2)2018 {
	
	!mkdir "output/detalhes_votacao_municipio_zona/ano=`ano'"
	
	use "output/detalhes_votacao_municipio_zona_`ano'.dta", clear
	
	levelsof estado_abrev, l(estados)
	
	foreach estado_abrev in `estados' {
		
		!mkdir "output/detalhes_votacao_municipio_zona/ano=`ano'/estado_abrev=`estado_abrev'"
		
		use "output/detalhes_votacao_municipio_zona_`ano'.dta", clear
		keep if estado_abrev == "`estado_abrev'"
		drop ano estado_abrev
		export delimited "output/detalhes_votacao_municipio_zona/ano=`ano'/estado_abrev=`estado_abrev'/detalhes_votacao_municipio_zona.csv", replace
		
	}
}
*

//-------------------------------------------------//
// detalhes votacao secao
//-------------------------------------------------//

!mkdir "output/detalhes_votacao_secao"

foreach ano of numlist 1994(2)2018 {
	
	!mkdir "output/detalhes_votacao_secao/ano=`ano'"
	
	use "output/detalhes_votacao_secao_`ano'.dta", clear
	
	levelsof estado_abrev, l(estados)
	
	foreach estado_abrev in `estados' {
		
		!mkdir "output/detalhes_votacao_secao/ano=`ano'/estado_abrev=`estado_abrev'"
		
		use "output/detalhes_votacao_secao_`ano'.dta", clear
		keep if estado_abrev == "`estado_abrev'"
		drop ano estado_abrev
		export delimited "output/detalhes_votacao_secao/ano=`ano'/estado_abrev=`estado_abrev'/detalhes_votacao_secao.csv", replace
		
	}
}
*

//-------------------------------------------------//
// vagas
//-------------------------------------------------//

use "output/vagas_1996.dta", clear
foreach ano of numlist 1998(2)2020 {
	append using "output/vagas_`ano'.dta"
}
save "output/norm_vagas.dta", replace

!mkdir "output/vagas"

use "output/norm_vagas.dta", clear

levelsof ano, l(anos)
foreach ano in `anos' {
	levelsof estado_abrev if ano == `ano', l(estados_`ano')
}
*

foreach ano in `anos' {
	
	!mkdir "output/vagas/ano=`ano'"
	
	foreach estado_abrev in `estados_`ano'' {
		
		!mkdir "output/vagas/ano=`ano'/estado_abrev=`estado_abrev'"
		
		use "output/norm_vagas.dta", clear
		keep if ano == `ano' & estado_abrev == "`estado_abrev'"
		drop ano estado_abrev
		export delimited "output/vagas/ano=`ano'/estado_abrev=`estado_abrev'/vagas.csv", replace
		
	}
}
*

//-------------------------------------------------//
// filiacao partidaria
//-------------------------------------------------//

!mkdir "output/filiacao_partidaria"

use "output/filiacao_partidaria.dta", clear

levelsof estado_abrev, l(estados)
foreach estado in `estados' {
	levelsof partido if estado_abrev == "`estado'", l(partidos_`estado')
}
*

foreach estado in `estados' {
	
	!mkdir "output/filiacao_partidaria/estado_abrev=`estado'"
	
	foreach partido in `partidos_`estado'' {
		
		!mkdir "output/filiacao_partidaria/estado_abrev=`estado'/partido=`partido'"
		
		use "output/filiacao_partidaria.dta", clear
		keep if estado_abrev == "`estado'" & partido == "`partido'"
		drop estado_abrev partido
		export delimited "output/filiacao_partidaria/estado_abrev=`estado'/partido=`partido'/filiacao_partidaria.csv", replace
		
	}
}
*




