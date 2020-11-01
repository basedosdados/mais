
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
clear programs
cap log close
set more off

cd "path/to/IDEB"

do "code/fnc/clean_string.do"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

do "code/sub/escola.do"
do "code/sub/municipio.do"
do "code/sub/estado_regiao.do"
do "code/sub/brasil.do"

do "code/sub/normalizacao.do"
