
*generating a folder where i could place these things
foreach ano in 2009 2010 2011 2012 2013 2014 {
mkdir "C:/Users/Matheus/Desktop/correcoespart/ano=`ano'"

foreach estado in AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO {


mkdir "C:/Users/Matheus/Desktop/correcoespart/ano=`ano'/sigla_uf=`estado'"
}
}



*actually corecting
foreach p in 2009 2010 2011 2012 2013 2014{
foreach i in SP RJ MG{
import delimited "C:\Users\Matheus\Downloads\staging_br_inep_censo_escolar_matricula_ano=`p'_sigla_uf=`i'_microdados_`i'.csv", encoding(utf8) clear

gen sigla_uf = "."
replace sigla_uf = "MG" if sigla_uf == "SP" //if id_uf == "31"
replace sigla_uf = "RJ" if sigla_uf == "MG" //if id_uf == "33"
*replace sigla_uf = "" if sigla_uf == "ES" if id_uf == "34"
replace sigla_uf = "SP" if sigla_uf == "RJ" //if id_uf == "35"

keep if sigla_uf == "`i'"
drop ano sigla_uf id_uf
export delimited "C:/Users/Matheus/Desktop/correcoespart/ano=`p'/sigla_uf=`i'/microdados_arrumados_sudeste_`i'.csv" , replace

}
}


import delimited "C:\Users\Matheus\Downloads\staging_br_inep_censo_escolar_matricula_ano=2009_sigla_uf=MG_microdados_MG.csv", encoding(utf8) clear

gen sigla_uf = "."
replace sigla_uf = "MG" if sigla_uf == "SP" if id_uf == "31"
replace sigla_uf = "RJ" if sigla_uf == "MG" if id_uf == "33"
*replace sigla_uf = "" if sigla_uf == "ES" if id_uf == "34"
replace sigla_uf = "SP" if sigla_uf == "RJ" if id_uf == "35"

keep if sigla_uf == "`i'"
drop ano sigla_uf id_uf
export delimited "C:/Users/Matheus/Desktop/correcoespart/ano=`p'/sigla_uf=`i'/microdados_arrumados_sudeste_`i'.csv" , replace









foreach estado in SP MG RJ ES {
	preserve
keep if sigla_uf == "`estado'"
drop ano sigla_uf id_uf
export delimited "C:/Users/Matheus/Desktop/particionadastata/ano=`t'/sigla_uf=`estado'/microdados_`estado'.csv" , replace
	restore
	
	}
