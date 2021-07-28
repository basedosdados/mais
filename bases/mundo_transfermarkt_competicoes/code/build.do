
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

cd "atalho/para/dados"

import delimited "brasileirao.csv", delimiter(comma) case (preserve) encoding(UTF-8) clear

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

replace publico = subinstr(publico, ".", "", .)
replace publico = subinstr(publico, "sold out", "", .)
replace publico_max = real(subinstr(string(publico_max), ".", "", .))
destring publico* gols*, replace
foreach k of varlist estadio arbitro {
	replace `k' = trim(`k')
}
*

gen aux_ano = real(substr(data, 1, 4))
gen aux_mes = real(substr(data, 6, 2))

gen ano_campeonato = aux_ano
replace ano_campeonato = 2020 if aux_ano == 2020 | (aux_ano == 2021 & aux_mes <= 2)
order ano_campeonato

replace data = "2016-12-11" if time_man == "Chapecoense" & time_vis == "Atlético-MG" & data == ""
replace rodada = 38 if time_man == "Chapecoense" & time_vis == "Atlético-MG" & rodada == .
replace estadio = "Arena Condá" if time_man == "Chapecoense" & time_vis == "Atlético-MG" & estadio == ""
replace arbitro = "Rodrigo D'Alonso Ferreira" if time_man == "Chapecoense" & time_vis == "Atlético-MG" & arbitro == ""

drop aux*

order valor_equipe_titular_* idade_media_titular_*, a(colocacao_vis)

export delimited "brasileirao_serie_a.csv", replace datafmt
