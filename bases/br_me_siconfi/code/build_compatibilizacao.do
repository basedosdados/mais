
use "tmp/contas_2013.dta", clear
foreach ano of numlist 2014(1)2021 {
	append using "tmp/contas_`ano'.dta"
}

cap ren descricao conta

gen id_conta_bd = id_conta
gen conta_bd    = conta

order ano id_conta id_conta_bd conta conta_bd
sort  id_conta ano

export excel "tmp/compatibilizacao_balanco_patrimonial_automatico.xlsx", replace firstrow(variables)

/*
duplicates r ano id_conta
duplicates tag ano id_conta, gen(dup)
sort dup ano id_conta

replace conta_bd = "Ativo Não-Circulante"   if id_conta == "1.2.0.0.0.00.00"
replace conta_bd = "Passivo Não-Circulante" if id_conta == "2.2.0.0.0.00.00"


