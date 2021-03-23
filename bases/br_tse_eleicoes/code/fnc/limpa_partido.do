
// author: Ricardo Dahis
// last updated: 2020/10/11

cap program drop limpa_partido
program limpa_partido
	
	local ano = `1'
	
	if `ano' == 2016 {

		replace sigla_partido = "REPUBLICANOS"	if sigla_partido == "PRB"
		replace sigla_partido = "MDB"			if sigla_partido == "PMDB"
		replace sigla_partido = "PODE"			if sigla_partido == "PTN"
		replace sigla_partido = "PL"			if sigla_partido == "PR"
		replace sigla_partido = "CIDADANIA"		if sigla_partido == "PPS"
		replace sigla_partido = "DC"			if sigla_partido == "PSDC"
		replace sigla_partido = "PATRIOTA"		if sigla_partido == "PATRI"
		replace sigla_partido = "PATRIOTA"		if sigla_partido == "PEN"
		replace sigla_partido = "AVANTE"		if sigla_partido == "PT do B"
		replace sigla_partido = "SOLIDARIEDADE"	if sigla_partido == "SD"
	
	}
	*
	
end
