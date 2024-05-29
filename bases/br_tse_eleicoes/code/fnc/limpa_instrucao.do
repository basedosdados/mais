
// author: Ricardo Dahis
// last updated: 2020/10/09

cap program drop limpa_instrucao
program limpa_instrucao
	
	replace instrucao = "ensino fundamental incompleto"		if instrucao == "1º grau incompleto"
	replace instrucao = "ensino fundamental incompleto"		if instrucao == "primeiro grau incompleto"
	replace instrucao = "ensino fundamental incompleto"		if instrucao == "fundamental incompleto"
	replace instrucao = "ensino fundamental completo"		if instrucao == "1º grau completo"
	replace instrucao = "ensino fundamental completo"		if instrucao == "primeiro grau completo"
	replace instrucao = "ensino fundamental completo"		if instrucao == "fundamental completo"
	replace instrucao = "ensino medio completo"				if instrucao == "2º grau completo"
	replace instrucao = "ensino medio incompleto"			if instrucao == "2º grau incompleto"
	replace instrucao = "ensino medio completo"				if instrucao == "segundo grau completo"
	replace instrucao = "ensino medio incompleto"			if instrucao == "segundo grau incompleto"
	replace instrucao = "ensino medio completo"				if instrucao == "medio completo"
	replace instrucao = "ensino medio incompleto"			if instrucao == "medio incompleto"
	replace instrucao = "ensino superior completo"			if instrucao == "superior completo"
	replace instrucao = "ensino superior incompleto"		if instrucao == "superior incompleto"
	replace instrucao = ""									if instrucao == "nao divulgavel"
	replace instrucao = ""									if instrucao == "nao informado"
	replace instrucao = ""									if instrucao == "informacao nao recuperada"
	
end
