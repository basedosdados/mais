
//----------------------------------------------------------------------------//
// preface
//----------------------------------------------------------------------------//

clear all
clear programs
set more off
cap log close

cd "/Users/rdahis/Dropbox/Academic/Data/Brazil/CGU/Auditorias Corrupcao"

do "/Users/rdahis/Dropbox/Coding/stata/clean_string.do"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

//------------------------------//
// resumo auditorias
// fonte: CGU no e-SIC
// protocolo: 00075001681201978
//------------------------------//

import delimited "input/Base_FEF_16_8_no_last_column.txt", clear varn(1) stringcols(_all)

drop municipio

ren ÿþetapa_sorteio_ou_ciclo_fef sorteio_ciclo_fef
ren ano_evento                   ano_evento
ren cod_mun_ibge                 id_municipio
ren uf                           sigla_uf
ren nr_os                        numero_ordem_servico
ren montante_fiscalizado         montante_fiscalizado
ren exercicio_repasse            exercicio_repasse
ren unidade_examinada            unidade_examinada
ren unid_jurisdicionada_tcu      unidade_jurisdicionada_tcu
ren orgao_superior               orgao_superior
ren funcao                       funcao
ren subfuncao                    subfuncao
ren programa                     programa
ren acao                         acao
ren programacao                  programacao
ren tipo_constatacao             tipo_constatacao

order sigla_uf, b(id_municipio)

export delimited "output/microdados.csv", replace datafmt
