
do "~/Dropbox/Coding/stata/clean_string.do"

import delimited "/Users/ricardodahis/Dropbox/Academic/Data/Brazil/Diretorio/municipio.csv", clear varn(1) encoding("utf-8")
keep id_municipio municipio sigla_uf
gen municipio_clean = municipio
clean_string municipio_clean

duplicates tag municipio_clean, gen(dup)	// cannot merge municipalities with non-unique names
drop if dup > 0
drop dup

tempfile diretorio
save `diretorio'

import delimited "~/Downloads/bquxjob_209cd534_17cb280d20f.csv", clear varn(1)
	// from running query
	// SELECT distinct(municipio) as municipio
	// FROM `basedosdados-dev.br_cgu_licitacoes.licitacao`
	// ORDER BY municipio ASC

gen municipio_clean = municipio
clean_string municipio_clean

merge m:1 municipio_clean using `diretorio'
drop if _merge == 2
drop _merge municipio_clean

export delimited "~/Downloads/aux_municipio.csv", replace
