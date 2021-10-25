
// author: Ricardo Dahis
// last updated: 2021-06-25

cap program drop limpa_partido
program limpa_partido
	
	local ano = `1'
	local var   `2'
	
	if `ano' == 2014 {
		
		replace `var' = "PODE"			if `var' == "PTN"
		replace `var' = "PODE"			if `var' == "Pode"
		replace `var' = "PATRIOTA"		if `var' == "PEN"
		replace `var' = "AVANTE"		if `var' == "PT do B"
	
	}
	
	if `ano' == 2016 {

		replace `var' = "REPUBLICANOS"	if `var' == "PRB"
		replace `var' = "MDB"			if `var' == "PMDB"
		replace `var' = "PODE"			if `var' == "PTN"
		replace `var' = "PODE"			if `var' == "Pode"
		replace `var' = "PL"			if `var' == "PR"
		replace `var' = "CIDADANIA"		if `var' == "PPS"
		replace `var' = "DC"			if `var' == "PSDC"
		replace `var' = "PATRIOTA"		if `var' == "PEN"
		replace `var' = "AVANTE"		if `var' == "PT do B"
	
	}
	
	if `ano' == 2018 {
		
		replace `var' = "REPUBLICANOS"	if `var' == "PRB"
		replace `var' = "CIDADANIA"		if `var' == "PPS"
		replace `var' = "PL"			if `var' == "PR"
		
	}
	*
	
	replace `var' = "PATRIOTA"			if `var' == "PATRI"
	replace `var' = "SOLIDARIEDADE"		if `var' == "SD"
	
end
