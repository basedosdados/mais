
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
cap log close
set more off

//cd "path/to/RAIS"
cd "~/Downloads/dados_RAIS"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

do "sub/vinculos.do"
do "sub/estabelecimentos.do"
