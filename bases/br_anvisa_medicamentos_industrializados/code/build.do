
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all

cd "path/dados_EDA_industrializados"

do "code/clean_string.do"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) encoding("utf-8")
keep id_municipio municipio sigla_uf
clean_string municipio
tempfile munic
save `munic'

! mkdir "output/microdados"

foreach ano of numlist 2014(1)2020 {
	
	! mkdir "output/microdados/ano=`ano'"
	
	foreach mes of numlist 1(1)12 {
		
		if `mes' <= 9	local mes_dois_digitos 0`mes'
		if `mes' >= 10	local mes_dois_digitos  `mes'
		
		! mkdir "output/microdados/ano=`ano'/mes=`mes'"
		
		import delimited "input/EDA_Industrializados_`ano'`mes_dois_digitos'.csv", clear varn(1) delim(";") case(preserve)
		
		ren ANO_VENDA				ano
		ren MES_VENDA				mes
		ren UF_VENDA				sigla_uf
		ren MUNICIPIO_VENDA			municipio
		ren PRINCIPIO_ATIVO			principio_ativo
		ren DESCRICAO_APRESENTACAO	descricao_apresentacao
		ren QTD_VENDIDA				qtde_vendida
		ren UNIDADE_MEDIDA			unidade_medida
		ren CONSELHO_PRESCRITOR		conselho_prescritor
		ren UF_CONSELHO_PRESCRITOR	sigla_uf_conselho_prescritor
		ren TIPO_RECEITUARIO		tipo_receituario
		ren CID10					cid10
		ren SEXO					sexo
		ren IDADE					idade
		ren UNIDADE_IDADE			unidade_idade
		
		replace unidade_medida = lower(unidade_medida)
		
		clean_string municipio
		
		replace municipio = "brasilia"					if sigla_uf == "DF"
		replace municipio = "brazopolis"				if sigla_uf == "MG" & municipio == "brasopolis"
		replace municipio = "sao vicente do serido"		if sigla_uf == "PB" & municipio == "serido"
		replace municipio = "tacima"					if sigla_uf == "PB" & municipio == "campo de santana"
		replace municipio = "joca claudino"				if sigla_uf == "PB" & municipio == "santarem"
		replace municipio = "belem do sao francisco"	if sigla_uf == "PE" & municipio == "belem de sao francisco"
		replace municipio = "lagoa de itaenga"			if sigla_uf == "PE" & municipio == "lagoa do itaenga"
		replace municipio = "presidente juscelino"		if sigla_uf == "RN" & municipio == "serra caiada"
		
		merge m:1 municipio sigla_uf using `munic'
		drop if _merge == 2
		drop _merge
		
		order id_municipio sigla_uf
		drop ano mes municipio
		
		export delimited "output/microdados/ano=`ano'/mes=`mes'/microdados.csv", replace
		
	}
}
*
