
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
do "code/fnc/limpa_candidato.do"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

do "code/sub/candidatos.do"
do "code/sub/partidos.do"
do "code/sub/detalhes_votacao_municipio_zona.do"
do "code/sub/detalhes_votacao_secao.do"
do "code/sub/perfil_eleitorado_municipio_zona.do"
do "code/sub/perfil_eleitorado_secao.do"
do "code/sub/perfil_eleitorado_local_votacao.do"
do "code/sub/vagas.do"
do "code/sub/resultados_municipio_zona.do"
do "code/sub/resultados_secao.do"
do "code/sub/prestacao_contas.do"

do "code/sub/cria_id_candidato.do"
do "code/sub/normalizacao_particao.do"
do "code/sub/agregacao.do"
