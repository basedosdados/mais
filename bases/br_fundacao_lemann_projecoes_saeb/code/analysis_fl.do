
//----------------------------------------------------------------------------//
// preface
//----------------------------------------------------------------------------//

clear all

cd "/Users/ricardodahis/Dropbox/basedosdados/projects/Lemann/projecao saeb"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

import excel "input/dados_moderna.xlsx", clear firstrow
keep if serie == 9
keep ano sigla_uf disciplina adequado
replace disciplina = "lp" if disciplina == "LP"
replace disciplina = "mt" if disciplina == "MT"
ren adequado adequado_moderna_
reshape wide adequado_moderna_, i(ano sigla_uf) j(disciplina) string
tempfile moderna
save `moderna'

import delimited "input/dados_fl.csv", clear encoding("utf-8")
tempfile dados
save `dados'

preserve
	keep sigla_uf
	duplicates drop
	expand 20
	bys sigla_uf: gen ano = 1993 + 2*_n
	tempfile base
	save `base'
restore

use `base', clear

drop if sigla_uf == "DF"

merge 1:1 sigla_uf ano using `moderna'
drop if _merge == 2
drop _merge

merge 1:1 sigla_uf ano using `dados'
drop if _merge == 2
drop _merge

foreach j in	insuficiente ///
				basico ///
				proficiente ///
				avancado ///
				adequado adequado_pb adequado_sp {
	foreach d in lp mt {
		foreach r in publica { // privada
			replace `j'_`d'_`r' = 100 * `j'_`d'_`r'
			cap replace `j'_`d'_`r'_pretos = 100 * `j'_`d'_`r'_pretos
		}
	}
}

gen ln_matriculas = ln(numero_matriculas_publica)
gen ln_populacao = ln(populacao)
gen ln_pib_pc    = ln(pib_pc)

//----------------------------------//
// predicted growth
//----------------------------------//

encode sigla_uf, gen(id_uf)
xtset id_uf ano, delta(2)
sort id_uf ano

foreach cov in pib_pc populacao numero_matriculas_publica {
	
	bys sigla_uf (ano): mipolate `cov' ano, gen(`cov'_NA) epolate
	
}

gen ln_matriculas_NA = ln(numero_matriculas_publica_NA)
gen ln_populacao_NA  = ln(populacao_NA)
gen ln_pib_pc_NA     = ln(pib_pc_NA)

local previsores	ln_pib_pc_NA ln_populacao_NA // ln_matriculas_NA

foreach outcome in	insuficiente_lp_publica basico_lp_publica proficiente_lp_publica avancado_lp_publica ///
					insuficiente_mt_publica basico_mt_publica proficiente_mt_publica avancado_mt_publica ///
					adequado_lp_publica adequado_lp_publica_pretos ///
					adequado_mt_publica adequado_mt_publica_pretos ///
					ideb {
	
	//------------------------//
	// average, adjusted
	//------------------------//
	
	gen `outcome'_A = `outcome'
	sort id_uf ano
	
	qui reghdfe `outcome'_A L.(c.`outcome'_A c.(`previsores')) /// // L.`outcome'_A L.(c.`outcome'_A#c.`outcome'_A) `previsores' ///
		if (ano >= 2011 & ano <= 2019) [aw=ln_populacao_NA], noabs vce(robust)
	
	foreach ano of numlist 2021(2)2033 {
		sort id_uf ano
		predict crescimento_previsto if ano == `ano', xb
		replace `outcome'_A = crescimento_previsto if ano == `ano'
		cap drop crescimento_previsto
	}
	
	cap drop in_sample
	
	/*
	//------------------------//
	// average, non-adjusted
	//------------------------//
	
	gen `outcome'_NA = `outcome'
	sort id_uf ano
	
	qui reghdfe `outcome'_NA L.(c.`outcome'_NA) /// L.`outcome'_NA L.(c.`outcome'_NA#c.`outcome'_NA) ///
		if (ano >= 2011 & ano <= 2019) [aw=ln_populacao_NA], noabs vce(robust)
	
	foreach ano of numlist 2021(2)2033 {
		sort id_uf ano
		predict crescimento_previsto if ano == `ano', xb
		replace `outcome'_NA = crescimento_previsto if ano == `ano'
		cap drop crescimento_previsto
	}
	
	cap drop in_sample
	
	//------------------------//
	// Ceará growth rate
	//------------------------//
	
	gen `outcome'_CE = `outcome'
	sort id_uf ano
	
	qui reghdfe `outcome'_CE L.(c.`outcome'_CE) /// c.ano /// c.ano c.ano#c.ano // L.`outcome'_OR /// // L.(c.`outcome'_OR#c.`outcome'_OR)
		if (ano >= 2011 & ano <= 2019) & sigla_uf == "CE", noabs vce(robust)
	
	foreach ano of numlist 2021(2)2033 {
		sort id_uf ano
		predict crescimento_previsto if ano == `ano', xb
		replace `outcome'_CE = crescimento_previsto if ano == `ano'
		cap drop crescimento_previsto
	}
	
	cap drop in_sample
	*/
	
	//------------------------//
	// best states rate
	//------------------------//
	
	gen crescimento = 100 * (`outcome'[_n] / `outcome'[_n-4] - 1) if ano == 2019
	sort crescimento
	gen aux = (_n >= 26 - 4 & _n <= 26) if crescimento != .
	bys sigla_uf: egen melhores = max(aux)
	levelsof sigla_uf if melhores, l(BS_`outcome') c
	
	gen `outcome'_BS = `outcome'
	sort id_uf ano
	
	qui reghdfe `outcome'_BS L.(c.`outcome'_BS) ///
		if (ano >= 2011 & ano <= 2019) & melhores [aw=ln_populacao_NA], noabs vce(robust)
	
	foreach ano of numlist 2021(2)2033 {
		sort id_uf ano
		predict crescimento_previsto if ano == `ano', xb
		replace `outcome'_BS = crescimento_previsto if ano == `ano'
		cap drop crescimento_previsto
	}
	
	drop crescimento aux melhores
	
	//------------------------//
	// worst states rate
	//------------------------//
	
	gen crescimento = 100 * (`outcome'[_n] / `outcome'[_n-4] - 1) if ano == 2019
	sort crescimento
	gen aux = (_n <= 5) if crescimento != .
	bys sigla_uf: egen piores = max(aux)
	levelsof sigla_uf if piores, l(WS_`outcome') c
	
	gen `outcome'_WS = `outcome'
	sort id_uf ano
	
	qui reghdfe `outcome'_WS L.(c.`outcome'_WS) /// // c.(`previsores')
		if (ano >= 2011 & ano <= 2019) & piores [aw=ln_populacao_NA], noabs vce(robust)
	
	foreach ano of numlist 2021(2)2033 {
		sort id_uf ano
		predict crescimento_previsto if ano == `ano', xb
		replace `outcome'_WS = crescimento_previsto if ano == `ano'
		cap drop crescimento_previsto
	}
	
	drop crescimento aux piores
	
}

//----------------------------------//
// COVID-19 pandemic discount
//----------------------------------//

foreach j in adequado { // insuficiente basico proficiente avancado
	foreach d in lp mt {
		foreach r in publica publica_pretos { // privada
			foreach c in pb sp {
				
				gen aux = 100 * (`j'_`d'_`r' - `j'_`c'_`d'_`r') / `j'_`d'_`r' if ano == 2019
				bys sigla_uf: egen desconto = max(aux)
				
				// summ desconto if ano == 2019, d
				// PT publica: media 34%
				// MT publica: media 55%
				
				//------------------------------//
				// pandemic as temporary shock
				//------------------------------//
				
				gen     desconto_ajustado =       desconto
				replace desconto_ajustado = 0.8 * desconto if ano == 2023
				replace desconto_ajustado = 0.6 * desconto if ano == 2025
				replace desconto_ajustado = 0.4 * desconto if ano == 2027
				replace desconto_ajustado = 0.2 * desconto if ano == 2029
				replace desconto_ajustado = 0   * desconto if ano == 2031
				replace desconto_ajustado = 0   * desconto if ano == 2033
				
				foreach g in A BS WS {
					
					gen     `j'_`d'_`r'_`g'_`c' =                               `j'_`d'_`r'_`g'
					replace `j'_`d'_`r'_`g'_`c' = (1 - desconto_ajustado/100) * `j'_`d'_`r'_`g' if ano >= 2021
					
				}
				
				/*
				//------------------------------//
				// pandemic as structural shock
				//------------------------------//
				
				// re-estimating average growth rates accounting for 2021 data
				
				gen     `j'_`d'_`r'_`c'2 =                               `j'_`d'_`r'
				replace `j'_`d'_`r'_`c'2 = (1 - desconto_ajustado/100) * `j'_`d'_`r'_A if ano == 2021
				sort id_uf ano
				
				qui reghdfe `j'_`d'_`r'_`c'2 L.(c.`j'_`d'_`r'_`c'2 c.(`previsores')) /// // L.`outcome'_A L.(c.`outcome'_A#c.`outcome'_A) `previsores' ///
					if (ano >= 2011 & ano <= 2021) [aw=ln_populacao_NA], noabs vce(robust)
				
				foreach ano of numlist 2023(2)2033 {
					sort id_uf ano
					predict crescimento_previsto if ano == `ano', xb
					replace `j'_`d'_`r'_`c'2 = crescimento_previsto if ano == `ano'
					cap drop crescimento_previsto
				}
				
				*/
				
				drop aux desconto desconto_ajustado
				
			}
			
			
		}
	}
}

/*
foreach outcome in	insuficiente_lp_publica basico_lp_publica proficiente_lp_publica avancado_lp_publica ///
					insuficiente_mt_publica basico_mt_publica proficiente_mt_publica avancado_mt_publica ///
					adequado_lp_publica adequado_lp_publica_pretos ///
					adequado_mt_publica adequado_mt_publica_pretos ///
	{
	
	foreach k in A BS WS { // NA CE
		
		gen `outcome'_`k'_C = `outcome'_`k'
		replace `outcome'_`k'_C = 0.8 * `outcome'_`k'_C  if ano == 2021
		replace `outcome'_`k'_C = 0.85 * `outcome'_`k'_C if ano == 2023
		replace `outcome'_`k'_C = 0.9 * `outcome'_`k'_C  if ano >= 2025
		
	}
}
*/

export delimited "output/data/uf.csv", replace datafmt


//----------------------------------------------------------------------------//
// analysis
//----------------------------------------------------------------------------//

//----------------------------------//
// scenarios - Brasil
//----------------------------------//

!mkdir "output/figures/brasil"

import delimited "output/data/uf.csv", clear varn(1) case(preserve)

keep if (ano >= 2011 & ano <= 2033)

collapse (mean) ///
	insuficiente_* basico_* proficiente_* avancado_* adequado_* ideb_* ///
	[aw=populacao_NA], ///
	by(ano)

export delimited "output/data/brasil.csv", replace datafmt

foreach outcome in	adequado_lp_publica adequado_lp_publica_pretos ///
					adequado_mt_publica adequado_mt_publica_pretos ///
					ideb {
					//insuficiente_lp_publica basico_lp_publica proficiente_lp_publica avancado_lp_publica ///
					//insuficiente_mt_publica basico_mt_publica proficiente_mt_publica avancado_mt_publica ///
	
	if substr("`outcome'", 1, 8) == "insuficiente"	local lab % Aprendizagem Insuficiente
	if substr("`outcome'", 1, 8) == "basico"		local lab % Aprendizagem Básica
	if substr("`outcome'", 1, 8) == "proficiente"	local lab % Aprendizagem Proficiente
	if substr("`outcome'", 1, 8) == "avancado"		local lab % Aprendizagem Avançada
	if substr("`outcome'", 1, 8) == "adequado"		local lab % Aprendizagem Adequada
	if substr("`outcome'", 1, 4) == "ideb"			local lab Ideb
	
	line `outcome'_A `outcome'_BS `outcome'_WS ano, ///
		msymbol(D) ///
		ytitle("`lab'") xtitle("Ano") ///
		xline(2020) xlabel(2011(2)2033, angle(45)) ///
		legend(r(2) lab(1 "Média Ajustada") lab(2 "UFs Maior Crescimento (`BS_`outcome'')") lab(3 "UFs Menor Crescimento (`WS_`outcome'')")) ///
		graphregion(fcolor(white) lcolor(white))
	graph display, xsize(7.5)
	graph export "output/figures/brasil/cenarios_`outcome'.png", replace
	
	if !inlist("`outcome'", "ideb") {
		
		foreach c in pb sp {
			
			line `outcome'_A_`c' `outcome'_BS_`c' `outcome'_WS_`c' ano, ///
				msymbol(D) ///
				ytitle("`lab'") xtitle("Ano") ///
				xline(2020) xlabel(2011(2)2033, angle(45)) ///
				legend(r(2) lab(1 "Média Ajustada") lab(2 "UFs Maior Crescimento (`BS_`outcome'')") lab(3 "UFs Menor Crescimento (`WS_`outcome'')")) ///
				graphregion(fcolor(white) lcolor(white))
			graph display, xsize(7.5)
			graph export "output/figures/brasil/cenarios_pandemia_temporario_`c'_`outcome'.png", replace
			
			line `outcome'_`c'2 ano, ///
				msymbol(D) ///
				ytitle("`lab'") xtitle("Ano") ///
				xline(2020) xlabel(2011(2)2033, angle(45)) ///
				legend(r(2) lab(1 "Média Ajustada") lab(2 "UFs Maior Crescimento (`BS_`outcome'')") lab(3 "UFs Menor Crescimento (`WS_`outcome'')")) ///
				graphregion(fcolor(white) lcolor(white))
			graph display, xsize(7.5)
			graph export "output/figures/brasil/cenarios_pandemia_estrutural_`c'_`outcome'.png", replace
			
		}
		
		
	}
}

foreach k in lp mt {
	
	gen razao_adequado_`k'_publica_A = 100 * adequado_`k'_publica_pretos_A / adequado_`k'_publica_A
	
	line razao_adequado_`k'_publica_A ano, ///
		msymbol(D) ///
		ytitle("`lab'") xtitle("Ano") ///
		xline(2020) xlabel(2011(2)2033, angle(45)) ///
		graphregion(fcolor(white) lcolor(white))
	graph display, xsize(7.5)
	graph export "output/figures/brasil/razao_pretos_media_adequado_`k'_publica.png", replace
	
}

//----------------------------------//
// scenarios - UFs
//----------------------------------//

!mkdir "output/figures/ufs"

import delimited "output/data/dados_analise_projecao_saeb_ufs.csv", clear varn(1) case(preserve)

keep if (ano >= 2011 & ano <= 2033)

foreach outcome in	adequado_lp_publica adequado_lp_publica_pretos ///
					adequado_mt_publica adequado_mt_publica_pretos ///
					ideb {
	
	if substr("`outcome'", 1, 8) == "adequado"	local lab % Aprendizagem Adequada
	if substr("`outcome'", 1, 4) == "ideb"		local lab Ideb
	
	line `outcome'_A `outcome'_BS `outcome'_WS ano, by(sigla_uf) ///
		msymbol(D) ///
		ytitle("`lab'") xtitle("Ano") ///
		xline(2020) xlabel(2011(2)2033, angle(45)) ///
		legend(r(1) lab(1 "Média Ajustada") lab(2 "Melhores UFs") lab(3 "Piores UFs")) ///
		graphregion(fcolor(white) lcolor(white))
	graph display, xsize(7.5)
	graph export "output/figures/ufs/cenarios_`outcome'.png", replace
	
}

//----------------------------------//
// bar graphs
//----------------------------------//

import delimited "output/data/dados_analise_projecao_saeb_brasil.csv", clear varn(1) case(preserve)

keep if ano == 2019 | ano == 2033

sort ano
foreach k in insuficiente_lp_publica_A basico_lp_publica_A proficiente_lp_publica_A avancado_lp_publica_A {
	gen g_`k' = `k'[_n] - `k'[_n-1]
}

graph bar g_insuficiente_lp_publica_A g_basico_lp_publica_A g_proficiente_lp_publica_A g_avancado_lp_publica_A if ano == 2033, ///
	ytitle("Mudança (%)") ///
	legend(r(1) lab(1 "Insuficiente") lab(2 "Básico") lab(3 "Proficiente") lab(4 "Avançado")) ///
	graphregion(fcolor(white) lcolor(white))
graph display, xsize(7.5)
graph export "output/figures/brasil/mudanca_por_categoria.png", replace

//----------------------------------//
// average vs blacks
//----------------------------------//

import delimited "output/data/dados_analise_projecao_saeb_brasil.csv", clear varn(1) case(preserve)

keep if ano >= 2011

foreach k in lp mt {
	
	gen razao_adequado_`k'_publica_A = 100 * adequado_`k'_publica_pretos_A / adequado_`k'_publica_A
	
	line razao_adequado_`k'_publica_A ano, by(sigla_uf) ///
		msymbol(D) ///
		ytitle("`lab'") xtitle("Ano") ///
		xline(2020) xlabel(2011(2)2033, angle(45)) ///
		graphregion(fcolor(white) lcolor(white))
	graph display, xsize(7.5)
	graph export "output/figures/ufs/razao_pretos_media_adequado_`k'_publica.png", replace
	
}

//----------------------------------//
// descriptive
//----------------------------------//

import delimited "output/data/dados_analise_projecao_saeb_ufs.csv", clear varn(1) case(preserve)

foreach d in lp_publica mt_publica lp_publica_pretos mt_publica_pretos {
	
	if "`d'" == "lp_publica"		local lab "Língua Portuguesa"
	if "`d'" == "mt_publica"		local lab "Matemática"
	if "`d'" == "lp_publica_pretos" local lab "Língua Portuguesa - Pretos"
	if "`d'" == "mt_publica_pretos" local lab "Matemática - Pretos"
	
	preserve
		
		keep if ano == 2011 | ano == 2019
		keep sigla_uf ano adequado_`d'
		ren adequado_`d' adequado_`d'_
		reshape wide adequado_`d'_, i(sigla_uf) j(ano)
		
		gen crescimento_`d' = 100 * ((adequado_`d'_2019 / adequado_`d'_2011) - 1)
		
		twoway	(scatter crescimento_`d' adequado_`d'_2011) ///
				(qfit crescimento_`d' adequado_`d'_2011), ///
			title("`lab'") ///
			ytitle("% Crescimento 2011-2019") xtitle("Nível 2011") ///
			legend(off) ///
			graphregion(fcolor(white) lcolor(white))
		graph export "output/figures/ufs/crescimento_vs_nivel_`d'.png", replace
		
	restore
	
}


