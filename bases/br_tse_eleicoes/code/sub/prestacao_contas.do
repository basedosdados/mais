
//----------------------------------------------------------------------------//
// build: bens declarados
//----------------------------------------------------------------------------//

foreach ano of numlist 2006(2)2018 {
	
	if mod(`ano', 4) == 0 local estados AC AL AM AP BA CE    ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
	if mod(`ano', 4) == 2 local estados AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
	
	foreach estado in `estados' {
		
		di "bens_`ano'_`estado'"
		
		cap import delimited "input/bem_candidato_`ano'/bem_candidato_`ano'_`estado'.txt", clear delim(";") varnames(nonames) stringc(_all)
		cap import delimited "input/bem_candidato_`ano'/bem_candidato_`ano'_`estado'.csv", clear delim(";") varnames(nonames) stringc(_all)
		
		if `ano' <= 2012 {
		
			keep v3 v5 v6 v9 v10
			
			ren v3	ano
			ren v5	estado_abrev
			ren v6	sequencial_candidato
			ren v9	descricao_item
			ren v10	valor_item
			
			replace descricao_item = "" if descricao_item == "#NULO#"
			clean_string descricao_item
			
			destring ano sequencial_candidato valor_item, replace force
			
		}
		if `ano' >= 2014 {
			
			drop in 1
			
			keep v3 v9 v12 v14 v15 v16 v17
			
			ren v3	ano
			ren v9	estado_abrev
			ren v12	sequencial_candidato
			ren v14	codigo_tipo_item
			ren v15	tipo_item
			ren v16	descricao_item
			ren v17	valor_item
			
			replace descricao_item = "" if descricao_item == "#NULO#"
			clean_string tipo_item
			clean_string descricao_item
			
			replace valor_item = subinstr(valor_item, ",", ".", .)
			destring ano sequencial_candidato codigo_tipo_item valor_item, replace
			
		}
		*
		
		compress
		
		tempfile bens_`ano'_`estado'
		save `bens_`ano'_`estado''
		
	}
	*
	
	use `bens_`ano'_AC', clear
	foreach state in `states' {
		if "`estado'" != "AC" {
			qui append using `bens_`ano'_`estado''
		}
	}
	*
	
	save "output/bens_`ano'.dta", replace
	
}
*

/*
use "output/incumbency_1996-2018.dta", clear

keep if year_election >= 2006

keep id_politician candidate_seq state_abbrev year_election

duplicates tag candidate_seq state_abbrev year_election, gen(dup)	// deleting duplicate politician
drop if dup > 0
drop dup

merge 1:m candidate_seq state_abbrev year_election using "tmp/wealth.dta"
drop if _merge == 2
drop _merge

sort id_politician year_election item_description

save "output/wealth_declared_2006-2018.dta", replace
*/

/*
//----------------------------------------------------------------------------//
// build: doacoes
//----------------------------------------------------------------------------//

//---------------------------------------------//
// 2002
//---------------------------------------------//

//---------------------//
// candidato
//---------------------//

import delimited "input/prestacao_contas_2002/2002/Candidato/Receita/ReceitaCandidato.csv", clear delim(";") varnames(nonames) stringc(_all)

drop in 1
drop v1 v9

ren v2		state_abbrev
ren v3		party
ren v4		office
ren v5		candidate_name
ren v6		candidate_number
ren v7		rev_date
ren v8		donor
ren v10		donor_name
ren v11		rev_value
ren v12		rev_type

replace rev_value = subinstr(rev_value, ",", ".", .)
destring candidate_number rev_value, replace

foreach var of varlist	office candidate_name donor_name rev_type {
	clean_string `var'
}
*

replace rev_date = "0" + rev_date if length(rev_date) == 9

gen year_election = 2002

compress

save "tmp/rev_candidate_2002.dta", replace


//---------------------//
// committee
//---------------------//

// import delimited "input/prestacao_contas 2002-2016/prestacao_contas_2002/2002/Comitê/Receita/ReceitaComite.csv", clear delim(";") varn(1) stringc(_all)



//---------------------------------------------//
// 2004
//---------------------------------------------//

//---------------------//
// candidate
//---------------------//

import delimited "input/prestacao_contas 2002-2018/prestacao_contas_2004/2004/Candidato/Receita/ReceitaCandidato.csv", ///
	clear varnames(nonames) delim(";") stringc(_all) bindquotes(nobind)

drop in 1
drop v3 v6 v8 v13 v15 v18

foreach k of varlist _all {
	replace `k' = subinstr(`k', `"""', "", .)
}
*

ren v1	candidate_name
ren v2	office
ren v4	candidate_number
ren v5	state_abbrev
ren v7	id_TSE
ren v9	party
ren v10	rev_value
ren v11	rev_date
ren v12	rev_source_type
ren v14	rev_type
ren v16	donor_name
ren v17	donor

replace rev_value = subinstr(rev_value, ",", ".", .)
destring id_TSE candidate_number rev_value, replace

foreach var of varlist	office candidate_name donor_name rev_source_type rev_type {
	clean_string `var'
}
*

replace rev_date = "0" + rev_date if length(rev_date) == 9

gen year_election = 2004

compress

save "tmp/rev_candidate_2004.dta", replace



//---------------------------------------------//
// 2006
//---------------------------------------------//

//---------------------//
// candidate
//---------------------//

import delimited "input/prestacao_contas 2002-2018/prestacao_contas_2006/2006/Candidato/Receita/ReceitaCandidato.csv", ///
	clear varnames(nonames) delim(";") stringc(_all)

drop in 1
drop v4 v8 v13 v15 v18 v19

ren v1	candidate_seq
ren v2	candidate_name
ren v3	office
ren v5	candidate_number
ren v6	state_abbrev
ren v7	candidate_CNPJ
ren v9	party
ren v10	rev_value
ren v11	rev_date
ren v12	rev_source_type
ren v14	rev_type
ren v16	donor_name
ren v17	donor

replace rev_value = subinstr(rev_value, ",", ".", .)
destring candidate_seq candidate_number rev_value, replace

foreach var of varlist	office candidate_name donor_name rev_source_type rev_type {
	clean_string `var'
}
*

replace rev_date = "0" + rev_date if length(rev_date) == 9

gen year_election = 2006

compress

save "tmp/rev_candidate_2006.dta", replace



//---------------------------------------------//
// 2008
//---------------------------------------------//

//---------------------//
// candidate
//---------------------//

import delimited "input/prestacao_contas 2002-2018/prestacao_contas_2008/receitas_candidatos_2008_brasil.csv", ///
	clear varnames(nonames) delim(";") stringc(_all)

drop in 1
drop v3 v5 v8 v13 v18 v20 v23 v24 v25 v26 v27 v28

ren v1	candidate_seq
ren v2	candidate_name
ren v4	office
ren v6	candidate_number
ren v7	state_abbrev
ren v9	id_TSE
ren v10	electoral_id
ren v11	CPF
ren v12	candidate_CNPJ
ren v14	party
ren v15	rev_value
ren v16	rev_date
ren v17	rev_source_type
ren v19	rev_type
ren v21	donor_name
ren v22	donor

replace rev_value = subinstr(rev_value, ",", ".", .)
destring candidate_seq candidate_number id_TSE rev_value, replace

foreach var of varlist	office candidate_name donor_name rev_source_type rev_type {
	clean_string `var'
}
*

replace rev_date = "0" + rev_date if length(rev_date) == 9

gen year_election = 2008

compress

save "tmp/rev_candidate_2008.dta", replace



//---------------------------------------------//
// 2010
//---------------------------------------------//

//---------------------//
// candidate
//---------------------//

local states AC AL AM AP BA BR CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

foreach state in `states' {
	
	import delimited "input/prestacao_contas 2002-2018/prestacao_contas_2010/candidato/`estado'/ReceitasCandidatos.txt", ///
		clear varnames(nonames) delim(";") stringc(_all)
	
	drop in 1
	drop v1 v9 v10 v11 v17 v19
	
	ren v2	candidate_seq
	ren v3	state_abbrev
	ren v4	party
	ren v5	candidate_number
	ren v6	office
	ren v7	candidate_name
	ren v8	CPF
	ren v12	donor
	ren v13	donor_name
	ren v14	rev_date
	ren v15	rev_value
	ren v16	rev_source_type
	ren v18	rev_type
	
	replace rev_value = subinstr(rev_value, ",", ".", .)
	destring candidate_seq candidate_number rev_value, replace
	
	foreach var of varlist	office candidate_name donor_name rev_source_type rev_type {
		clean_string `var'
	}
	*
	
	gen year_election = 2010
	
	compress
	
	save "tmp/rev_candidate_2010_`estado'.dta", replace

}
*

local first: word 1 of `states'
use "tmp/rev_candidate_2010_`first'.dta", clear
foreach state in `states' {
	if "`estado'" != "`first'" {
		qui append using "tmp/rev_candidate_2010_`estado'.dta"
	}
}
*

save "tmp/rev_candidate_2010.dta", replace



//---------------------------------------------//
// 2012
//---------------------------------------------//

//---------------------//
// candidate
//---------------------//

local states AC AL AM AP BA brasil CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

foreach state in `states' {
	
	import delimited "input/prestacao_contas 2002-2018/prestacao_contas_2012/receitas_candidatos_2012_`estado'.txt", ///
		clear varnames(nonames) delim(";") stringc(_all)
	
	drop in 1
	drop v1 v2 v3 v7 v13 v14 v17 v18 v19 v20 v21 v22 v26 v28
	cap drop v29
	
	foreach k of varlist _all {
		replace `k' = subinstr(`k', `"""', "", .)
	}
	*
	
	ren v4	candidate_seq
	ren v5	state_abbrev
	ren v6	id_TSE
	ren v8	party
	ren v9	candidate_number
	ren v10	office
	ren v11	candidate_name
	ren v12	CPF
	ren v15	donor
	ren v16	donor_name
	ren v23	rev_date
	ren v24	rev_value
	ren v25	rev_source_type
	ren v27	rev_type
	
	replace rev_date = substr(rev_date, 1, 10)
	
	replace rev_value = subinstr(rev_value, ",", ".", .)
	destring candidate_seq id_TSE candidate_number rev_value, replace force
	
	foreach var of varlist office candidate_name donor_name rev_source_type rev_type {
		clean_string `var'
	}
	*
	
	gen year_election = 2012
	
	compress
	
	save "tmp/rev_candidate_2012_`estado'.dta", replace
	
}
*

local first: word 1 of `states'
use "tmp/rev_candidate_2012_`first'.dta", clear
foreach state in `states' {
	if "`estado'" != "`first'" {
		qui append using "tmp/rev_candidate_2012_`estado'.dta"
	}
}
*

save "tmp/rev_candidate_2012.dta", replace




//---------------------------------------------//
// 2014
//---------------------------------------------//

//---------------------//
// candidate
//---------------------//

local states AC AL AM AP BA brasil CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

foreach state in `states' {
	
	import delimited "input/prestacao_contas 2002-2018/prestacao_contas_2014/receitas_candidatos_2014_`estado'.txt", ///
		clear varnames(nonames) delim(";") stringc(_all)
	
	drop in 1
	drop v1 v2 v3 v12 v13 v16 v17 v18 v19 v20 v21 v25 v27 v28 v29 v30 v31 v32
	cap drop v33
	
	foreach k of varlist _all {
		replace `k' = subinstr(`k', `"""', "", .)
	}
	*
	
	ren v4	candidate_CNPJ
	ren v5	candidate_seq
	ren v6	state_abbrev
	ren v7	party
	ren v8	candidate_number
	ren v9	office
	ren v10	candidate_name
	ren v11	CPF
	ren v14	donor
	ren v15	donor_name
	ren v22	rev_date
	ren v23	rev_value
	ren v24	rev_source_type
	ren v26	rev_type
	
	replace rev_date = substr(rev_date, 1, 10)
	
	replace rev_value = subinstr(rev_value, ",", ".", .)
	destring candidate_seq candidate_number rev_value, replace force
	
	foreach var of varlist	office candidate_name donor_name rev_source_type rev_type {
		clean_string `var'
	}
	*
	
	gen year_election = 2014
	
	compress
	
	save "tmp/rev_candidate_2014_`estado'.dta", replace
	
}
*

local first: word 1 of `states'
use "tmp/rev_candidate_2014_`first'.dta", clear
foreach state in `states' {
	if "`estado'" != "`first'" {
		qui append using "tmp/rev_candidate_2014_`estado'.dta"
	}
}
*

save "tmp/rev_candidate_2014.dta", replace




//---------------------------------------------//
// 2016
//---------------------------------------------//

local states AC AL AM AP BA brasil CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

foreach state in `states' {
	
	import delimited "input/prestacao_contas 2002-2018/prestacao_contas_2016/receitas_candidatos_prestacao_contas_final_2016_`estado'.txt", ///
		clear varnames(nonames) delim(";") stringc(_all)
	
	drop in 1
	drop v1 v2 v3 v8 v14 v15 v16 v19 v20 v21 v22 v23 v24 v28 v30 v31 v32 v33 v34 v35
	
	foreach k of varlist _all {
		replace `k' = subinstr(`k', `"""', "", .)
	}
	*
	
	ren v4	candidate_CNPJ
	ren v5	candidate_seq
	ren v6	state_abbrev
	ren v7	id_TSE
	ren v9	party
	ren v10	candidate_number
	ren v11	office
	ren v12	candidate_name
	ren v13	CPF
	ren v17	donor
	ren v18	donor_name
	ren v25	rev_date
	ren v26	rev_value
	ren v27	rev_source_type
	ren v29	rev_type
	
	replace rev_date = substr(rev_date, 1, 10)
	
	replace rev_value = subinstr(rev_value, ",", ".", .)
	destring candidate_seq id_TSE candidate_number rev_value, replace force
	
	foreach var of varlist office candidate_name donor_name rev_source_type rev_type {
		clean_string `var'
	}
	*
	
	gen year_election = 2016
	
	compress
	
	save "tmp/rev_candidate_2016_`estado'.dta", replace
	
}
*

local first: word 1 of `states'
use "tmp/rev_candidate_2016_`first'.dta", clear
foreach state in `states' {
	if "`estado'" != "`first'" {
		qui append using "tmp/rev_candidate_2016_`estado'.dta"
	}
}
*

save "tmp/rev_candidate_2016.dta", replace




//---------------------------------------------//
// 2018
//---------------------------------------------//

local states AC AL AM AP BA brasil CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

foreach state in `states' {
	
	import delimited "input/prestacao_contas 2002-2018/prestacao_de_contas_eleitorais_candidatos_2018/despesas_contratadas_candidatos_2018_`estado'.csv", ///
		clear varnames(nonames) delim(";") stringc(_all)
	
	drop in 1
	
	keep v14 v16 v18 v19 v20 v21 v22 v25 v31 v32 v51 v53
	
	ren v16	candidate_CNPJ
	ren v19	candidate_seq
	ren v14	state_abbrev
	ren v25	party
	ren v20	candidate_number
	ren v18	office
	ren v21	candidate_name
	ren v22	CPF
	ren v31	donor
	ren v32	donor_name
	ren v51	rev_date
	ren v53	rev_value
	
	replace rev_date = substr(rev_date, 1, 10)
	
	replace rev_value = subinstr(rev_value, ",", ".", .)
	destring candidate_seq candidate_number rev_value, replace force
	
	foreach var of varlist office candidate_name donor_name {
		clean_string `var'
	}
	*
	
	gen year_election = 2018
	
	compress
	
	save "tmp/rev_candidate_2018_`estado'.dta", replace
	
}
*

local first: word 1 of `states'
use "tmp/rev_candidate_2018_`first'.dta", clear
foreach state in `states' {
	if "`estado'" != "`first'" {
		qui append using "tmp/rev_candidate_2018_`estado'.dta"
	}
}
*

save "tmp/rev_candidate_2018.dta", replace




//---------------------------------------------//
// append and save
//---------------------------------------------//

use "output/incumbency_1996-2018.dta", clear

keep id_politician CPF candidate_number candidate_name year_election party office // id_TSE

drop if year_election <= 2000

duplicates tag candidate_number candidate_name year_election party office, gen(dup)	// observations not identified with CPF.
drop if dup > 0																		// have no CPF for before 2008 below.
drop dup

save "tmp/data_id_politician.dta", replace


use "tmp/rev_candidate_2002.dta", replace
append using "tmp/rev_candidate_2004.dta"
append using "tmp/rev_candidate_2006.dta"
append using "tmp/rev_candidate_2008.dta"
append using "tmp/rev_candidate_2010.dta"
append using "tmp/rev_candidate_2012.dta"
append using "tmp/rev_candidate_2014.dta"
append using "tmp/rev_candidate_2016.dta"
append using "tmp/rev_candidate_2018.dta"

cap drop v34
cap drop v36

//---------------------//
// adjustments
//---------------------//

replace donor_name = "" if length(donor_name) > 100

foreach k in rev_type rev_source_type {
	
	foreach n of numlist 0(1)9 {
		replace `k' = usubinstr(`k', "`n'", "", .)
	}
	
	encode `k', gen(aux_`k')
	order aux_`k', a(`k')
	drop `k'
	ren aux_`k' `k'	
}
*


//---------------------//
// merge id_politician
//---------------------//

preserve
	
	keep if year <= 2006
	
	merge m:1 candidate_number candidate_name year_election party office using "tmp/data_id_politician.dta"
	drop if _merge != 3
	drop _merge
	
	save "tmp/merged_2008b.dta", replace
	
restore

preserve
	
	keep if year >= 2008
	
	merge m:1 CPF candidate_number year_election party using "tmp/data_id_politician.dta"
	drop if _merge != 3
	drop _merge
	
	save "tmp/merged_2008p.dta", replace
	
restore

use "tmp/merged_2008b.dta", clear
append using "tmp/merged_2008p.dta"

drop CPF electoral_id candidate_number candidate_seq candidate_name candidate_CNPJ id_TSE state_abbrev party office

la var year_election	"Year"
la var rev_date			"Revenue Date"
la var donor			"ID Donor"
la var donor_name		"Donor"
la var rev_value		"Revenue Value"
la var rev_type			"Revenue Type"
la var rev_source_type	"Revenue Source Type"

order id_politician year_election
sort  id_politician year_election

compress

save "output/donations_rev_candidate_2002-2018.dta", replace
















