
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
clear programs
set more off
cap log close
set excelxlsxlargefile on

cd "path/to/MapBiomas"

do "src/fnc/clean_string.do"
do "src/fnc/limpa_nivel.do"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

do "src/sub/cobertura.do"
do "src/sub/transicao.do"
do "src/sub/particao.do"
