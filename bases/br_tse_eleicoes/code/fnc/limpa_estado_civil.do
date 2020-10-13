	
// author: Ricardo Dahis
// last updated: 2020/10/09

cap program drop limpa_estado_civil
program limpa_estado_civil
	
	replace estado_civil = "solteiro(a)"	if estado_civil == "solteiro"
	replace estado_civil = "casado(a)"		if estado_civil == "casado"
	replace estado_civil = "divorciado(a)"	if estado_civil == "divorciado"
	replace estado_civil = "divorciado(a)"	if estado_civil == "separado(a) judicialmente"
	replace estado_civil = "divorciado(a)"	if estado_civil == "separado judicialmente"
	replace estado_civil = "viuvo(a)"		if estado_civil == "viuvo"
	replace estado_civil = ""				if estado_civil == "nao divulgavel"
	replace estado_civil = ""				if estado_civil == "nao informado"
	
end
