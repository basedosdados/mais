
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
	replace `var' = "PC do B"			if `var' == "PCdoB"
	replace `var' = "PC do B"			if `var' == "PC DO B"
	replace `var' = "PT do B"			if `var' == "PTdoB"
	replace `var' = "PT do B"			if `var' == "PT DO B"
	
end
