
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
clear programs
cap log close
set more off, perm
set rmsg off

cd "path/to/SIM"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

do "code/sub/microdados.do"

do "code/sub/normalizacao_particao.do"
do "code/sub/agregacao.do"
