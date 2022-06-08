*corrigindo ultimos anos

foreach t in 2019 2020{

foreach p in AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO{
import delimited "C:\Users\Matheus\Desktop\particionadastata\ano=`t'\sigla_uf=`p'\microdados_`p'.csv", delimiter(",") encoding(utf8) clear

tostring rede, replace
replace rede = "federal" if rede == "1"
replace rede = "estadual" if rede == "2" 
replace rede = "municipal" if rede == "3"
replace rede = "privada" if rede == "4"

rename id_entidade id_escola
export delimited "C:/Users/Matheus/Desktop/particionadastata/ano=`t'/sigla_uf=`p'/microdados_`p'.csv", replace
}
}



*PRA FICAR CERTINHO AQUI EM BAIXO TEM QUE POR 2019 E 2020
foreach t in 2018 {

foreach p in AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO{
import delimited "C:\Users\Matheus\Desktop\particionadastata\ano=`t'\sigla_uf=`p'\microdados_`p'.csv", delimiter(",") encoding(utf8) clear

order id_matricula id_pessoa_fisica dia_nascimento mes_nascimento ano_nascimento idade_referencia idade duracao_ativ_comp_mesma_rede duracao_ativ_comp_outras_redes sexo cor_raca nacionalidade id_pais_origem id_uf_nascimento id_municipio_nascimento id_uf_endereco id_municipio_endereco zona_residencial outro_local_aula transporte_publico responsavel_transporte transporte_vans_kombi transporte_micro_onibus transporte_onibus transporte_bicicleta transporte_tr_animal transporte_outro_veiculo transporte_embarcacao_ate5 transporte_embarcacao_5a15 transporte_embarcacao_15a35 transporte_embarcacao_35 transporte_trem_metro necessidade_especial cegueira baixa_visao surdez deficiencia_auditiva surdocegueira deficiencia_fisica deficiencia_intelectual deficiencia_multipla autismo sindrome_asperger sindrome_rett transtorno_di superdotacao recurso_ledor recurso_transcricao recurso_interprete recurso_libras recurso_labial recurso_braille recurso_ampliada_16 recurso_ampliada_20 recurso_ampliada_24 recurso_nenhum ingresso_federais etapa_ensino id_turma id_curso_educ_profissional unificada tipo_turma id_escola id_municipio rede

export delimited "C:/Users/Matheus/Desktop/particionadastata/ano=`t'/sigla_uf=`p'/microdados_`p'.csv", replace
}
}
