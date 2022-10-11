
//----------------------------------------------------------------------------//
// build: perfil eleitorado - local votacao
//----------------------------------------------------------------------------//

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) case(preserve)
keep id_municipio id_municipio_tse
tempfile diretorio
save `diretorio'

//------------------------//
// loops
//------------------------//

foreach ano of numlist 2016(2)2022 {
	
	cap import delimited "input/perfil_eleitorado_local_votacao/eleitorado_local_votacao_`ano'/eleitorado_local_votacao_`ano'.txt", delim(";") stringcols(_all) varn(nonames) clear
	cap import delimited "input/perfil_eleitorado_local_votacao/eleitorado_local_votacao_`ano'/eleitorado_local_votacao_`ano'.csv", delim(";") stringcols(_all) varn(nonames) clear
	
	drop in 1
	
	drop v1 v2 v8 v11 v15 v23 v25 v27 v29
	
	ren v3	ano
	ren v4	data_eleicao
	ren v5	turno
	ren v6	sigla_uf
	ren v7	id_municipio_tse
	ren v9	zona
	ren v10	secao
	ren v12	tipo_secao_agregada
	ren v13	numero
	ren v14	nome
	ren v16	tipo
	ren v17	endereco
	ren v18	bairro
	ren v19	cep
	ren v20	telefone
	ren v21	latitude
	ren v22	longitude
	ren v24	situacao
	ren v26	situacao_zona
	ren v28	situacao_secao
	ren v30	situacao_localidade
	ren v31	quantidade_eleitores
	ren v32	quantidade_eleitores_eleicao
	
	replace data_eleicao = substr(data_eleicao, 7, 4) + "-" + substr(data_eleicao, 4, 2) + "-" + substr(data_eleicao, 1, 2)
	
	replace turno = "1" if turno == "1º Turno"
	replace turno = "2" if turno == "2º Turno"
	
	replace telefone = ""	if telefone == "-1"
	replace latitude = ""	if latitude == "-1"
	replace longitude = ""	if longitude == "-1"
	
	clean_string tipo_secao_agregada
	clean_string tipo
	clean_string situacao
	clean_string situacao_zona
	clean_string situacao_secao
	clean_string situacao_localidade
	
	destring ano turno id_municipio_tse zona secao numero latitude longitude ///
		quantidade_eleitores quantidade_eleitores_eleicao, replace
	
	merge m:1 id_municipio_tse using `diretorio'
	drop if _merge == 2
	drop _merge
	order id_municipio, b(id_municipio_tse)
	
	order ano data_eleicao turno sigla_uf id_municipio id_municipio_tse zona secao
	
	tempfile perfil`ano'
	save `perfil`ano''
	
}
*

use `perfil2016'
append using `perfil2018'
append using `perfil2020'

compress

save "output/perfil_eleitorado_local_votacao.dta", replace
