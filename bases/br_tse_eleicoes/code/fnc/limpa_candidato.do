	
cap program drop limpa_candidato
program limpa_candidato
	
	replace cpf = "30964261987"					if ano == 2000 & id_municipio == 4202909 & nome == "Paulo Peixer"
	replace titulo_eleitoral = "001954260914"	if ano == 2000 & id_municipio == 4202909 & nome == "Paulo Peixer"
	
	replace titulo_eleitoral = "086136320116"	if ano == 2006 & sigla_uf == "SP" & nome == "José Carlos Selbach Eymael"
	
end
