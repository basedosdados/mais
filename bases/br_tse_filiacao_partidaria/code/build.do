
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
cap log close
set more off
set varabbrev off

cd "~/Downloads/dados_TSE"

do "code/fnc/clean_string.do"
do "code/fnc/limpa_tipo_eleicao.do"
do "code/fnc/limpa_instrucao.do"
do "code/fnc/limpa_estado_civil.do"
do "code/fnc/limpa_resultado.do"
do "code/fnc/limpa_partido.do"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

do "code/sub/filiacao_partidaria.do"
