
cap program drop limpa_resultado
program limpa_resultado
	
	replace resultado = "eleito por media"				if resultado == "media"
	replace resultado = "eleito por qp"					if resultado == "eleito por quociente partidario"
	replace resultado = "renuncia/falecimento/cassacao"	if resultado == "renuncia/falecimento com substituicao"
	replace resultado = "renuncia/falecimento/cassacao"	if resultado == "renuncia/falecimento/cassacao antes da eleicao"
	replace resultado = "renuncia/falecimento/cassacao"	if resultado == "renuncia;falecimento;cassacao antes da eleicao"
	replace resultado = "renuncia/falecimento/cassacao"	if resultado == "renuncia;falecimento;cassacao apos a eleicao"
	
	replace resultado = "2º turno"						if resultado == "2o turno"
	
end
