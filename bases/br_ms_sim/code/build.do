
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
clear programs
cap log close
set more off, perm
set rmsg off

cd "atalho/para/Sistema de Informacoes sobre Mortalidade (SIM)"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

do "src/sub/microdados.do"
do "src/sub/agregacao.do"
