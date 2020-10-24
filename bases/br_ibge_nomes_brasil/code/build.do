
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
clear programs
set more off
cap log close

cd "path/to/Nomes no Brasil"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

import delimited "input/Quantidade de nomes por município 2010.csv", clear varn(nonames) case(preserve) encoding("utf-8") delim(";")

drop in 1

ren v1 id_municipio
ren v2 qtde_nascimentos_ate_2010
ren v3 nome

replace nome = proper(nome)

order id_municipio nome
sort  id_municipio nome

export delimited "output/quantidade_municipio_nome_2010.csv", replace
