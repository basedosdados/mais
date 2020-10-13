
// author: Ricardo Dahis
// last updated: 2020/10/11

cap program drop limpa_partido
program limpa_partido
	
	local ano = `1'
	
	if `ano' == 2016 {

		replace partido = "REPUBLICANOS"	if partido == "PRB"
		replace partido = "MDB"				if partido == "PMDB"
		replace partido = "PODE"			if partido == "PTN"
		replace partido = "PL"				if partido == "PR"
		replace partido = "CIDADANIA"		if partido == "PPS"
		replace partido = "DC"				if partido == "PSDC"
		replace partido = "PATRIOTA"		if partido == "PATRI"
		replace partido = "PATRIOTA"		if partido == "PEN"
		replace partido = "AVANTE"			if partido == "PT do B"
		replace partido = "SOLIDARIEDADE"	if partido == "SD"
	
	}
	*
	
end
