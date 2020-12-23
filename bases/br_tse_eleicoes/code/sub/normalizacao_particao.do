
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

merge m:1 cpf titulo_eleitoral nome_candidato using "output/id_candidato_bd.dta"
keep if _merge == 3	// dropa observacoes sem id_candidato
drop _merge

//------------//
// limpando
// duplicadas
//------------//

local vars ano tipo_eleicao sigla_uf id_municipio_tse numero_candidato cargo id_candidato_bd
duplicates tag `vars', gen(dup)
duplicates drop `vars' if dup > 0, force
drop dup

local vars ano tipo_eleicao sigla_uf id_municipio_tse numero_candidato cargo
duplicates tag `vars', gen(dup)
drop if dup > 0 & situacao != "deferido"
drop dup

local vars ano tipo_eleicao sigla_uf id_municipio_tse numero_candidato cargo
duplicates tag `vars', gen(dup)
drop if dup > 0
drop dup

local vars id_candidato_bd ano tipo_eleicao
duplicates drop `vars', force

drop coligacao composicao

order tipo_eleicao ano id_candidato_bd cpf titulo_eleitoral sequencial_candidato ///
	numero_candidato nome_candidato nome_urna_candidato numero_partido sigla_partido cargo sigla_uf id_municipio_tse

compress

save "output/norm_candidatos.dta", replace

//------------//
// particiona
//------------//

!mkdir "output/candidatos"

use "output/norm_candidatos.dta", clear

levelsof ano, l(anos)
foreach ano in `anos' {
	levelsof sigla_uf if ano == `ano', l(estados_`ano')
}
*

foreach ano in `anos' {
	
	!mkdir "output/candidatos/ano=`ano'"
	
	foreach sigla_uf in `estados_`ano'' {
		
		!mkdir "output/candidatos/ano=`ano'/sigla_uf=`sigla_uf'"
		
		use "output/norm_candidatos.dta", clear
		keep if ano == `ano' & sigla_uf == "`sigla_uf'"
		drop ano sigla_uf
		export delimited "output/candidatos/ano=`ano'/sigla_uf=`sigla_uf'/candidatos.csv", replace
		
	}
}
*

//-------------------------------------------------//
// partidos
//-------------------------------------------------//

use "output/norm_candidatos.dta", clear

keep ano numero_partido sigla_partido

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
	
	levelsof sigla_uf, l(estados)
	
	foreach sigla_uf in `estados' {
		
		!mkdir "output/coligacoes/ano=`ano'/sigla_uf=`sigla_uf'"
		
		use "output/coligacoes_`ano'.dta", clear
		keep if ano == `ano' & sigla_uf == "`sigla_uf'"
		drop ano sigla_uf
		export delimited "output/coligacoes/ano=`ano'/sigla_uf=`sigla_uf'/coligacoes.csv", replace
		
	}
}
*

//-------------------------------------------------//
// resultados municipio-zona
//-------------------------------------------------//

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 0
keep id_candidato_bd ano tipo_eleicao sigla_uf id_municipio_tse cargo numero_candidato

tempfile candidatos_mod0
save `candidatos_mod0'

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 2 & cargo != "presidente"
keep id_candidato_bd ano tipo_eleicao sigla_uf cargo numero_candidato

tempfile candidatos_mod2_estadual
save `candidatos_mod2_estadual'

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 2 & cargo == "presidente"
keep id_candidato_bd ano tipo_eleicao cargo numero_candidato

tempfile candidatos_mod2_presid
save `candidatos_mod2_presid'

!mkdir "output/resultados_candidato_municipio_zona"
!mkdir "output/resultados_partido_municipio_zona"
!mkdir "output/resultados_candidato"

foreach ano of numlist 1998(2)2020 {
	
	//---------------------//
	// candidato-municipio-zona
	//---------------------//
	
	use "output/resultados_candidato_municipio_zona_`ano'.dta", clear
	
	if mod(`ano', 4) == 0 {
		
		merge m:1 ano tipo_eleicao sigla_uf id_municipio_tse cargo numero_candidato using `candidatos_mod0'
		drop if _merge == 2
		drop _merge
		
	}
	else {
		
		preserve
			
			keep if cargo != "presidente"
			
			merge m:1 ano tipo_eleicao sigla_uf cargo numero_candidato using `candidatos_mod2_estadual'
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
	
	drop nome_candidato nome_urna_candidato sequencial_candidato coligacao composicao
	
	local vars tipo_eleicao ano turno sigla_uf id_municipio_tse zona numero_candidato id_candidato_bd cargo sigla_partido votos resultado
	
	order `vars'
	sort  `vars'
	
	tempfile resultados_candidato
	save `resultados_candidato'
	
	//------------//
	// particiona
	//------------//
	
	!mkdir "output/resultados_candidato_municipio_zona/ano=`ano'"
	
	use `resultados_candidato', clear
	
	levelsof sigla_uf, l(estados)
	foreach sigla_uf in `estados' {
		
		!mkdir "output/resultados_candidato_municipio_zona/ano=`ano'/sigla_uf=`sigla_uf'"
		
		use `resultados_candidato', clear
		keep if ano == `ano' & sigla_uf == "`sigla_uf'"
		drop ano sigla_uf
		export delimited "output/resultados_candidato_municipio_zona/ano=`ano'/sigla_uf=`sigla_uf'/resultados_candidato_municipio_zona.csv", replace
		
	}
	*
	
	//---------------------//
	// partido-municipio-zona
	//---------------------//
	
	use "output/resultados_partido_municipio_zona_`ano'.dta", clear
	
	drop coligacao composicao
	
	local vars tipo_eleicao ano turno sigla_uf id_municipio_tse zona cargo sigla_partido
	
	order `vars'
	sort  `vars'
	
	tempfile resultados_partido
	save `resultados_partido'
	
	//------------//
	// particiona
	//------------//
	
	!mkdir "output/resultados_partido_municipio_zona/ano=`ano'"
	
	use `resultados_partido', clear
	
	levelsof sigla_uf, l(estados)
	foreach sigla_uf in `estados' {
		
		!mkdir "output/resultados_partido_municipio_zona/ano=`ano'/sigla_uf=`sigla_uf'"
		
		use `resultados_partido', clear
		keep if ano == `ano' & sigla_uf == "`sigla_uf'"
		drop ano sigla_uf
		export delimited "output/resultados_partido_municipio_zona/ano=`ano'/sigla_uf=`sigla_uf'/resultados_partido_municipio_zona.csv", replace
		
	}
	*
	
	//---------------------//
	// candidato
	//---------------------//
	
	//------------//
	// particiona
	//------------//
	
	!mkdir "output/resultados_candidato/ano=`ano'"
	
	use `resultados_candidato', clear
	
	replace sigla_uf = ""			if cargo == "presidente"
	replace id_municipio_tse = .	if mod(ano, 4) == 2
	drop if id_candidato_bd == .
	drop if resultado == "2º turno"
	
	collapse (sum) votos, by(tipo_eleicao sigla_uf id_municipio_tse turno numero_candidato id_candidato_bd cargo sigla_partido resultado)
	
	sort id_candidato_bd
	
	export delimited "output/resultados_candidato/ano=`ano'/resultados_candidato.csv", replace
	
}
*

//-------------------------------------------------//
// resultados secao
//-------------------------------------------------//

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 0
keep id_candidato_bd ano tipo_eleicao sigla_uf id_municipio_tse cargo numero_candidato sigla_partido

tempfile candidatos_mod0
save `candidatos_mod0'

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 2 & cargo != "presidente"
keep id_candidato_bd ano tipo_eleicao sigla_uf cargo numero_candidato sigla_partido

tempfile candidatos_mod2_estadual
save `candidatos_mod2_estadual'

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 2 & cargo == "presidente"
keep id_candidato_bd ano tipo_eleicao cargo numero_candidato sigla_partido

tempfile candidatos_mod2_presid
save `candidatos_mod2_presid'

!mkdir "output/resultados_candidato_secao"
!mkdir "output/resultados_partido_secao"

foreach ano of numlist 2020 { // 1998(2)2020 {
	
	/*
	//---------------------//
	// candidato
	//---------------------//
	
	use "output/resultados_candidato_secao_`ano'.dta", clear
	
	if mod(`ano', 4) == 0 {
		
		merge m:1 ano tipo_eleicao sigla_uf id_municipio_tse cargo numero_candidato using `candidatos_mod0'
		drop if _merge == 2
		drop _merge
		
	}
	else {
		
		preserve
			
			keep if cargo != "presidente"
			
			merge m:1 ano tipo_eleicao sigla_uf cargo numero_candidato using `candidatos_mod2_estadual'
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
	
	local vars ano tipo_eleicao turno sigla_uf id_municipio_tse zona secao numero_candidato id_candidato_bd cargo sigla_partido votos
	
	order `vars'
	sort  `vars'
	
	tempfile resultados_candidato
	save `resultados_candidato'
	
	//------------//
	// particiona
	//------------//
	
	!mkdir "output/resultados_candidato_secao/ano=`ano'"
	
	use `resultados_candidato', clear
	
	levelsof sigla_uf, l(estados)
	foreach sigla_uf in `estados' {
		
		!mkdir "output/resultados_candidato_secao/ano=`ano'/sigla_uf=`sigla_uf'"
		
		use `resultados_candidato', clear
		keep if ano == `ano' & sigla_uf == "`sigla_uf'"
		drop ano sigla_uf
		export delimited "output/resultados_candidato_secao/ano=`ano'/sigla_uf=`sigla_uf'/resultados_candidato_secao.csv", replace
		
	}
	*/
	
	//---------------------//
	// partido
	//---------------------//
	
	use "output/resultados_partido_secao_`ano'.dta", clear
	
	merge m:1 ano numero_partido using "output/norm_partidos.dta"
	drop if _merge == 2
	drop _merge
	
	drop numero_partido
	
	local vars ano tipo_eleicao turno sigla_uf id_municipio_tse zona secao cargo sigla_partido
	
	order `vars'
	sort  `vars'
	
	tempfile resultados_partido
	save `resultados_partido'
	
	//------------//
	// particiona
	//------------//
	
	!mkdir "output/resultados_partido_secao/ano=`ano'"
	
	use `resultados_partido', clear
	
	levelsof sigla_uf, l(estados)
	foreach sigla_uf in `estados' {
		
		!mkdir "output/resultados_partido_secao/ano=`ano'/sigla_uf=`sigla_uf'"
		
		use `resultados_partido', clear
		keep if ano == `ano' & sigla_uf == "`sigla_uf'"
		drop ano sigla_uf
		export delimited "output/resultados_partido_secao/ano=`ano'/sigla_uf=`sigla_uf'/resultados_partido_secao.csv", replace
		
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
	levelsof sigla_uf, l(estados)
	
	foreach sigla_uf in `estados' {
		
		!mkdir "output/perfil_eleitorado/ano=`ano'/sigla_uf=`sigla_uf'"
		
		use "output/perfil_eleitorado_`ano'.dta", clear
		keep if sigla_uf == "`sigla_uf'"
		drop ano sigla_uf
		export delimited "output/perfil_eleitorado/ano=`ano'/sigla_uf=`sigla_uf'/perfil_eleitorado.csv", replace
		
	}
}
*

//-------------------------------------------------//
// perfil eleitorado - local votacao
//-------------------------------------------------//

!mkdir "output/perfil_eleitorado_local_votacao"

foreach ano of numlist 2016(2)2020 {
	
	!mkdir "output/perfil_eleitorado_local_votacao/ano=`ano'"
	
	use "output/perfil_eleitorado_local_votacao.dta", clear
	keep if ano == `ano'
	levelsof sigla_uf, l(estados)
	
	foreach sigla_uf in `estados' {
		
		!mkdir "output/perfil_eleitorado_local_votacao/ano=`ano'/sigla_uf=`sigla_uf'"
		
		preserve
			keep if sigla_uf == "`sigla_uf'"
			drop ano sigla_uf
			export delimited "output/perfil_eleitorado_local_votacao/ano=`ano'/sigla_uf=`sigla_uf'/perfil_eleitorado_local_votacao.csv", replace
		restore
		
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
	
	levelsof sigla_uf, l(estados)
	
	foreach sigla_uf in `estados' {
		
		!mkdir "output/detalhes_votacao_municipio_zona/ano=`ano'/sigla_uf=`sigla_uf'"
		
		use "output/detalhes_votacao_municipio_zona_`ano'.dta", clear
		keep if sigla_uf == "`sigla_uf'"
		drop ano sigla_uf
		export delimited "output/detalhes_votacao_municipio_zona/ano=`ano'/sigla_uf=`sigla_uf'/detalhes_votacao_municipio_zona.csv", replace
		
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
	
	levelsof sigla_uf, l(estados)
	
	foreach sigla_uf in `estados' {
		
		!mkdir "output/detalhes_votacao_secao/ano=`ano'/sigla_uf=`sigla_uf'"
		
		use "output/detalhes_votacao_secao_`ano'.dta", clear
		keep if sigla_uf == "`sigla_uf'"
		drop ano sigla_uf
		export delimited "output/detalhes_votacao_secao/ano=`ano'/sigla_uf=`sigla_uf'/detalhes_votacao_secao.csv", replace
		
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
	levelsof sigla_uf if ano == `ano', l(estados_`ano')
}
*

foreach ano in `anos' {
	
	!mkdir "output/vagas/ano=`ano'"
	
	foreach sigla_uf in `estados_`ano'' {
		
		!mkdir "output/vagas/ano=`ano'/sigla_uf=`sigla_uf'"
		
		use "output/norm_vagas.dta", clear
		keep if ano == `ano' & sigla_uf == "`sigla_uf'"
		drop ano sigla_uf
		export delimited "output/vagas/ano=`ano'/sigla_uf=`sigla_uf'/vagas.csv", replace
		
	}
}
*

//-------------------------------------------------//
// filiacao partidaria
//-------------------------------------------------//

!mkdir "output/filiacao_partidaria"

use "output/filiacao_partidaria.dta", clear

levelsof sigla_uf, l(estados)
foreach estado in `estados' {
	levelsof sigla_partido if sigla_uf == "`estado'", l(partidos_`estado')
}
*

foreach estado in `estados' {
	
	!mkdir "output/filiacao_partidaria/sigla_uf=`estado'"
	
	foreach partido in `partidos_`estado'' {
		
		!mkdir "output/filiacao_partidaria/sigla_uf=`estado'/sigla_partido=`partido'"
		
		use "output/filiacao_partidaria.dta", clear
		keep if sigla_uf == "`estado'" & sigla_partido == "`partido'"
		drop sigla_uf sigla_partido
		export delimited "output/filiacao_partidaria/sigla_uf=`estado'/sigla_partido=`partido'/filiacao_partidaria.csv", replace
		
	}
}
*


//-------------------------------------------------//
// bens - candidato
//-------------------------------------------------//

//--------------------//
// merge com id_candidato
// particiona
//--------------------//

use "output/norm_candidatos.dta", clear

keep if ano >= 2006

keep id_candidato_bd ano tipo_eleicao sigla_uf sequencial_candidato

tempfile candidatos
save `candidatos'

!mkdir "output/bens_candidato"

foreach ano of numlist 2006(2)2020 {
	
	!mkdir "output/bens_candidato/ano=`ano'"
	
	use "output/bens_candidato_`ano'.dta", clear
	
	merge m:1 ano tipo_eleicao sigla_uf sequencial_candidato using `candidatos'
	drop if _merge == 2
	drop _merge
	
	order ano tipo_eleicao sigla_uf sequencial_candidato id_candidato_bd id_tipo_item tipo_item descricao_item valor_item
	
	tempfile bens
	save `bens'
	
	levelsof sigla_uf, l(ufs)
	foreach uf in `ufs' {
		!mkdir "output/bens_candidato/ano=`ano'/sigla_uf=`uf'"
		use `bens', clear
		keep if ano == `ano' & sigla_uf == "`uf'"
		drop ano sigla_uf
		export delimited "output/bens_candidato/ano=`ano'/sigla_uf=`uf'/bens_candidato.csv", replace
	}
}
*

//-------------------------------------------------//
// receita - candidato
//-------------------------------------------------//

//--------------------//
// unifica header
//--------------------//

foreach ano of numlist 2002(2)2020 {
	
	use "output/receita_candidato_`ano'.dta", clear
	
	keep in 1/10
	
	tempfile c`ano'
	save `c`ano''
	
}
*

use `c2002', clear
foreach ano of numlist 2004(2)2020 {
	append using `c`ano''
}
*
drop if _n >= 1
tempfile vazio
save `vazio'

//--------------------//
// merge com id_candidato
// particiona
//--------------------//

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 0
keep id_candidato_bd ano tipo_eleicao sigla_uf id_municipio_tse cargo numero_candidato

tempfile candidatos_mod0
save `candidatos_mod0'

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 2 & cargo != "presidente"
keep id_candidato_bd ano tipo_eleicao sigla_uf cargo sequencial_candidato numero_candidato

tempfile candidatos_mod2_estadual
save `candidatos_mod2_estadual'

use "output/norm_candidatos.dta", clear

keep if mod(ano, 4) == 2 & cargo == "presidente"
keep id_candidato_bd ano tipo_eleicao cargo sequencial_candidato numero_candidato

tempfile candidatos_mod2_presid
save `candidatos_mod2_presid'


!mkdir "output/receita_candidato"

foreach ano of numlist 2002(2)2020 {
	
	!mkdir "output/receita_candidato/ano=`ano'"
	
	use `vazio', clear
	append using "output/receita_candidato_`ano'.dta"
	
	if `ano' <= 2012 replace tipo_eleicao = "eleicao ordinaria" if tipo_eleicao == ""
	cap destring sequencial_candidato, replace
	
	if mod(`ano', 4) == 0 {
		
		merge m:1 ano tipo_eleicao sigla_uf id_municipio_tse cargo numero_candidato using `candidatos_mod0'
		drop if _merge == 2
		drop _merge
		
	}
	else {
		
		preserve
			
			keep if cargo != "presidente"
			
			merge m:1 ano tipo_eleicao sigla_uf cargo numero_candidato using `candidatos_mod2_estadual'
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
	
	order ano tipo_eleicao sigla_uf id_municipio_tse turno ///
		id_candidato_bd sequencial_candidato numero_candidato cpf_candidato cnpj_candidato titulo_eleitor_candidato nome_candidato cpf_vice_suplente numero_partido nome_partido sigla_partido cargo ///
		sequencial_receita data_receita tipo_receita tipo_fonte_receita fonte_receita situacao_receita origem_receita natureza_receita descricao_receita valor_receita ///
		sequencial_candidato_doador cpf_cnpj_doador sigla_uf_doador id_municipio_tse_doador nome_doador nome_doador_rf cargo_candidato_doador numero_partido_doador sigla_partido_doador nome_partido_doador esfera_partidaria_doador numero_candidato_doador id_setor_economico_doador setor_economico_doador ///
		cpf_cnpj_doador_orig nome_doador_orig nome_doador_orig_rf tipo_doador_orig setor_economico_doador_orig ///
		nome_administrador cpf_administrador numero_recibo_eleitoral numero_documento numero_recibo_doacao numero_documento_doacao tipo_prestacao_contas data_prestacao_contas sequencial_prestador_contas cnpj_prestador_contas entrega_conjunto
	
	drop ano
	export delimited "output/receita_candidato/ano=`ano'/receita_candidato.csv", replace
	
}
*


