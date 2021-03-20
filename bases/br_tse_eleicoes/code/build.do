
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
cap log close
set more off

cd "/path/to/dados_TSE"

do "code/lib/clean_string.do"
do "code/lib/limpa_tipo_eleicao.do"
do "code/lib/limpa_instrucao.do"
do "code/lib/limpa_estado_civil.do"
do "code/lib/limpa_resultado.do"
do "code/lib/limpa_partido.do"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

do "code/sub/candidatos.do"
do "code/sub/coligacoes.do"
do "code/sub/detalhes_votacao_municipio_zona.do"
do "code/sub/detalhes_votacao_secao.do"
do "code/sub/perfil_eleitorado.do"
do "code/sub/perfil_eleitorado_secao.do"
do "code/sub/perfil_eleitorado_local_votacao.do"
do "code/sub/vagas.do"
do "code/sub/resultados_municipio_zona.do"
do "code/sub/resultados_secao.do"
do "code/sub/prestacao_contas.do"

do "code/sub/filiacao_partidaria.do"

do "code/sub/cria_id_candidato.do"
do "code/sub/normalizacao_particao.do"
do "code/sub/agregacao.do"
