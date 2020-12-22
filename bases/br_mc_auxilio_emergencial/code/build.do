
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
cap log close
set more off

cd "path/to/Auxilio Emergencial"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

local ufs AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

!mkdir "output/microdados"

foreach mes in 04 05 06 07 08 {
	
	!mkdir "output/microdados/mes=2020-`mes'"
	
	import delimited "input/2020`mes'_AuxilioEmergencial.csv", clear varn(nonames) delim(";") stringcols(_all)
	
	drop in 1
	drop v4
	
	ren v1	mes
	ren v2	sigla_uf
	ren v3	id_municipio
	ren v5	nis_beneficiario
	ren v6	cpf_beneficiario
	ren v7	nome_beneficiario
	ren v8	nis_responsavel
	ren v9	cpf_responsavel
	ren v10	nome_responsavel
	ren v11	enquadramento
	ren v12	parcela
	ren v13	observacao
	ren v14	valor_beneficio
	
	tempfile temp
	save `temp'
	
	foreach uf in `""' `ufs' {
		
		!mkdir "output/microdados/mes=2020-`mes'/sigla_uf=`uf'"
		
		//---------------//
		// limpa
		//---------------//
		
		use `temp' if inlist(sigla_uf, "`uf'"), clear
		
		replace mes = substr(mes, 1, 4) + "-" + substr(mes, 5, 2)
		
		replace nis_beneficiario = ""	if nis_beneficiario == "00000000000"
		replace nis_responsabel = ""	if nis_responsabel == "-2"
		replace nome_responsavel = ""	if nome_responsavel == "Não se aplica"
		replace observacao = ""			if observacao == "Não há"
		
		destring valor_beneficio, replace dpcomma
		
		drop mes sigla_uf
		export delimited "output/microdados/mes=2020-`mes'/sigla_uf=`uf'/microdados.csv", replace
		
	}
	*
	
}
*


