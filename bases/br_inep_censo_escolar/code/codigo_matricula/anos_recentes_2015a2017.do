*DO FILE PARA OS ANOS 2018 A 2015

*diretorios

foreach ano in 2015 2016 2017 {
mkdir "C:/Users/Matheus/Desktop/particionadastata/ano=`ano'"

foreach estado in AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO {


mkdir "C:/Users/Matheus/Desktop/particionadastata/ano=`ano'/sigla_uf=`estado'"
}
}

import delimited "C:\Users\Matheus\Desktop\particionadastata\ano=2018\sigla_uf=DF\microdados_DF.CSV", delimiter(",") encoding(utf8) clear


*CENTRO OESTE - FOI

foreach t in 2015 2016 2017 {

import delimited C:\Users\Matheus\Desktop\matriculas\a`t'\matricula_CO.CSV, delimiter("|") encoding(utf8) clear

rename *, upper

keep NU_ANO_CENSO ID_MATRICULA CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE_REFERENCIA NU_IDADE ///
NU_DUR_ATIV_COMP_MESMA_REDE NU_DUR_ATIV_COMP_OUTRAS_REDES TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC ///
CO_MUNICIPIO_NASC CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL ///
TP_OUTRO_LOCAL_AULA IN_TRANSPORTE_PUBLICO TP_RESPONSAVEL_TRANSPORTE ///
IN_TRANSP_VANS_KOMBI IN_TRANSP_MICRO_ONIBUS IN_TRANSP_ONIBUS ///
IN_TRANSP_BICICLETA IN_TRANSP_TR_ANIMAL IN_TRANSP_OUTRO_VEICULO ///
IN_TRANSP_EMBAR_ATE5 IN_TRANSP_EMBAR_5A15 ///
IN_TRANSP_EMBAR_15A35 IN_TRANSP_EMBAR_35 IN_TRANSP_TREM_METRO ///
IN_NECESSIDADE_ESPECIAL IN_CEGUEIRA IN_BAIXA_VISAO ///
IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA ///
IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
IN_AUTISMO IN_SINDROME_ASPERGER IN_SINDROME_RETT ///
IN_TRANSTORNO_DI IN_SUPERDOTACAO IN_RECURSO_LEDOR ///
IN_RECURSO_TRANSCRICAO IN_RECURSO_INTERPRETE IN_RECURSO_LIBRAS ///
IN_RECURSO_LABIAL IN_RECURSO_BRAILLE IN_RECURSO_AMPLIADA_16 IN_RECURSO_AMPLIADA_20 ///
IN_RECURSO_AMPLIADA_24 IN_RECURSO_NENHUM TP_INGRESSO_FEDERAIS TP_ETAPA_ENSINO ID_TURMA CO_CURSO_EDUC_PROFISSIONAL ///
TP_UNIFICADA TP_TIPO_TURMA CO_ENTIDADE CO_MUNICIPIO CO_UF TP_DEPENDENCIA

rename (NU_ANO_CENSO ID_MATRICULA CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE_REFERENCIA NU_IDADE ///
NU_DUR_ATIV_COMP_MESMA_REDE NU_DUR_ATIV_COMP_OUTRAS_REDES TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC ///
CO_MUNICIPIO_NASC CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL ///
TP_OUTRO_LOCAL_AULA IN_TRANSPORTE_PUBLICO TP_RESPONSAVEL_TRANSPORTE ///
IN_TRANSP_VANS_KOMBI IN_TRANSP_MICRO_ONIBUS IN_TRANSP_ONIBUS ///
IN_TRANSP_BICICLETA IN_TRANSP_TR_ANIMAL IN_TRANSP_OUTRO_VEICULO ///
IN_TRANSP_EMBAR_ATE5 IN_TRANSP_EMBAR_5A15 ///
IN_TRANSP_EMBAR_15A35 IN_TRANSP_EMBAR_35 IN_TRANSP_TREM_METRO ///
IN_NECESSIDADE_ESPECIAL IN_CEGUEIRA IN_BAIXA_VISAO ///
IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA ///
IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
IN_AUTISMO IN_SINDROME_ASPERGER IN_SINDROME_RETT ///
IN_TRANSTORNO_DI IN_SUPERDOTACAO IN_RECURSO_LEDOR ///
IN_RECURSO_TRANSCRICAO IN_RECURSO_INTERPRETE IN_RECURSO_LIBRAS ///
IN_RECURSO_LABIAL IN_RECURSO_BRAILLE IN_RECURSO_AMPLIADA_16 IN_RECURSO_AMPLIADA_20 ///
IN_RECURSO_AMPLIADA_24 IN_RECURSO_NENHUM TP_INGRESSO_FEDERAIS TP_ETAPA_ENSINO ID_TURMA CO_CURSO_EDUC_PROFISSIONAL ///
TP_UNIFICADA TP_TIPO_TURMA CO_ENTIDADE CO_MUNICIPIO CO_UF TP_DEPENDENCIA) (ano id_matricula id_pessoa_fisica dia_nascimento ///
mes_nascimento ano_nascimento idade_referencia idade ///
duracao_ativ_comp_mesma_rede duracao_ativ_comp_outras_redes ///
sexo cor_raca nacionalidade id_pais_origem ///
id_uf_nascimento id_municipio_nascimento id_uf_endereco ///
id_municipio_endereco zona_residencial outro_local_aula ///
transporte_publico responsavel_transporte ///
transporte_vans_kombi transporte_micro_onibus ///
transporte_onibus transporte_bicicleta ///
transporte_tr_animal transporte_outro_veiculo ///
transporte_embarcacao_ate5 transporte_embarcacao_5a15 ///
transporte_embarcacao_15a35 transporte_embarcacao_35 ///
transporte_trem_metro necessidade_especial cegueira ///
baixa_visao surdez deficiencia_auditiva surdocegueira ///
deficiencia_fisica deficiencia_intelectual ///
deficiencia_multipla autismo sindrome_asperger ///
sindrome_rett transtorno_di superdotacao recurso_ledor /// 
recurso_transcricao recurso_interprete recurso_libras ///
recurso_labial recurso_braille recurso_ampliada_16 ///
recurso_ampliada_20 recurso_ampliada_24 recurso_nenhum ///
ingresso_federais etapa_ensino id_turma ///
id_curso_educ_profissional unificada tipo_turma ///
id_escola id_municipio id_uf rede)

gen sigla_uf = "DF" if id_uf == 53
replace sigla_uf = "GO" if id_uf == 52
replace sigla_uf = "MS" if id_uf == 50
replace sigla_uf = "MT" if id_uf == 51

tostring rede, replace
replace rede = "federal" if rede == "1"
replace rede = "estadual" if rede == "2" 
replace rede = "municipal" if rede == "3"
replace rede = "privada" if rede == "4"



foreach estado in DF GO MS MT {
	preserve
keep if sigla_uf == "`estado'"
drop ano sigla_uf id_uf
export delimited "C:/Users/Matheus/Desktop/particionadastata/ano=`t'/sigla_uf=`estado'/microdados_`estado'.csv" , replace
	restore
	
	}
}

*NORTE

foreach t in 2015 2016 2017 { 


import delimited C:\Users\Matheus\Desktop\matriculas\a`t'\MATRICULA_NORTE.CSV, delimiter("|") encoding(utf8) clear

rename *, upper


keep NU_ANO_CENSO ID_MATRICULA CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE_REFERENCIA NU_IDADE ///
NU_DUR_ATIV_COMP_MESMA_REDE NU_DUR_ATIV_COMP_OUTRAS_REDES TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC ///
CO_MUNICIPIO_NASC CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL ///
TP_OUTRO_LOCAL_AULA IN_TRANSPORTE_PUBLICO TP_RESPONSAVEL_TRANSPORTE ///
IN_TRANSP_VANS_KOMBI IN_TRANSP_MICRO_ONIBUS IN_TRANSP_ONIBUS ///
IN_TRANSP_BICICLETA IN_TRANSP_TR_ANIMAL IN_TRANSP_OUTRO_VEICULO ///
IN_TRANSP_EMBAR_ATE5 IN_TRANSP_EMBAR_5A15 ///
IN_TRANSP_EMBAR_15A35 IN_TRANSP_EMBAR_35 IN_TRANSP_TREM_METRO ///
IN_NECESSIDADE_ESPECIAL IN_CEGUEIRA IN_BAIXA_VISAO ///
IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA ///
IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
IN_AUTISMO IN_SINDROME_ASPERGER IN_SINDROME_RETT ///
IN_TRANSTORNO_DI IN_SUPERDOTACAO IN_RECURSO_LEDOR ///
IN_RECURSO_TRANSCRICAO IN_RECURSO_INTERPRETE IN_RECURSO_LIBRAS ///
IN_RECURSO_LABIAL IN_RECURSO_BRAILLE IN_RECURSO_AMPLIADA_16 IN_RECURSO_AMPLIADA_20 ///
IN_RECURSO_AMPLIADA_24 IN_RECURSO_NENHUM TP_INGRESSO_FEDERAIS TP_ETAPA_ENSINO ID_TURMA CO_CURSO_EDUC_PROFISSIONAL ///
TP_UNIFICADA TP_TIPO_TURMA CO_ENTIDADE CO_MUNICIPIO CO_UF TP_DEPENDENCIA

rename (NU_ANO_CENSO ID_MATRICULA CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE_REFERENCIA NU_IDADE ///
NU_DUR_ATIV_COMP_MESMA_REDE NU_DUR_ATIV_COMP_OUTRAS_REDES TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC ///
CO_MUNICIPIO_NASC CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL ///
TP_OUTRO_LOCAL_AULA IN_TRANSPORTE_PUBLICO TP_RESPONSAVEL_TRANSPORTE ///
IN_TRANSP_VANS_KOMBI IN_TRANSP_MICRO_ONIBUS IN_TRANSP_ONIBUS ///
IN_TRANSP_BICICLETA IN_TRANSP_TR_ANIMAL IN_TRANSP_OUTRO_VEICULO ///
IN_TRANSP_EMBAR_ATE5 IN_TRANSP_EMBAR_5A15 ///
IN_TRANSP_EMBAR_15A35 IN_TRANSP_EMBAR_35 IN_TRANSP_TREM_METRO ///
IN_NECESSIDADE_ESPECIAL IN_CEGUEIRA IN_BAIXA_VISAO ///
IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA ///
IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
IN_AUTISMO IN_SINDROME_ASPERGER IN_SINDROME_RETT ///
IN_TRANSTORNO_DI IN_SUPERDOTACAO IN_RECURSO_LEDOR ///
IN_RECURSO_TRANSCRICAO IN_RECURSO_INTERPRETE IN_RECURSO_LIBRAS ///
IN_RECURSO_LABIAL IN_RECURSO_BRAILLE IN_RECURSO_AMPLIADA_16 IN_RECURSO_AMPLIADA_20 ///
IN_RECURSO_AMPLIADA_24 IN_RECURSO_NENHUM TP_INGRESSO_FEDERAIS TP_ETAPA_ENSINO ID_TURMA CO_CURSO_EDUC_PROFISSIONAL ///
TP_UNIFICADA TP_TIPO_TURMA CO_ENTIDADE CO_MUNICIPIO CO_UF TP_DEPENDENCIA) (ano id_matricula id_pessoa_fisica dia_nascimento ///
mes_nascimento ano_nascimento idade_referencia idade ///
duracao_ativ_comp_mesma_rede duracao_ativ_comp_outras_redes ///
sexo cor_raca nacionalidade id_pais_origem ///
id_uf_nascimento id_municipio_nascimento id_uf_endereco ///
id_municipio_endereco zona_residencial outro_local_aula ///
transporte_publico responsavel_transporte ///
transporte_vans_kombi transporte_micro_onibus ///
transporte_onibus transporte_bicicleta ///
transporte_tr_animal transporte_outro_veiculo ///
transporte_embarcacao_ate5 transporte_embarcacao_5a15 ///
transporte_embarcacao_15a35 transporte_embarcacao_35 ///
transporte_trem_metro necessidade_especial cegueira ///
baixa_visao surdez deficiencia_auditiva surdocegueira ///
deficiencia_fisica deficiencia_intelectual ///
deficiencia_multipla autismo sindrome_asperger ///
sindrome_rett transtorno_di superdotacao recurso_ledor /// 
recurso_transcricao recurso_interprete recurso_libras ///
recurso_labial recurso_braille recurso_ampliada_16 ///
recurso_ampliada_20 recurso_ampliada_24 recurso_nenhum ///
ingresso_federais etapa_ensino id_turma ///
id_curso_educ_profissional unificada tipo_turma ///
id_escola id_municipio id_uf rede)

gen sigla_uf = "AC" if id_uf == 12
replace sigla_uf = "AM" if id_uf == 13
replace sigla_uf = "AP" if id_uf == 16
replace sigla_uf = "PA" if id_uf == 15
replace sigla_uf = "RO" if id_uf == 11
replace sigla_uf = "RR" if id_uf == 14
replace sigla_uf = "TO" if id_uf == 17

tostring rede, replace
replace rede = "federal" if rede == "1"
replace rede = "estadual" if rede == "2" 
replace rede = "municipal" if rede == "3"
replace rede = "privada" if rede == "4"

foreach estado in AC AM AP PA RO RR TO {
 	preserve
keep if sigla_uf == "`estado'"
drop ano sigla_uf id_uf
export delimited "C:/Users/Matheus/Desktop/particionadastata/ano=`t'/sigla_uf=`estado'/microdados_`estado'.csv", replace
	restore
	
	}
}


*SUDESTE PARTE 1

foreach t in 2015 2016 2017 { 


import delimited C:\Users\Matheus\Desktop\matriculas\a`t'\MATRICULA_SUDESTE.CSV, delimiter("|") encoding(utf8) clear

rename *, upper


keep NU_ANO_CENSO ID_MATRICULA CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE_REFERENCIA NU_IDADE ///
NU_DUR_ATIV_COMP_MESMA_REDE NU_DUR_ATIV_COMP_OUTRAS_REDES TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC ///
CO_MUNICIPIO_NASC CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL ///
TP_OUTRO_LOCAL_AULA IN_TRANSPORTE_PUBLICO TP_RESPONSAVEL_TRANSPORTE ///
IN_TRANSP_VANS_KOMBI IN_TRANSP_MICRO_ONIBUS IN_TRANSP_ONIBUS ///
IN_TRANSP_BICICLETA IN_TRANSP_TR_ANIMAL IN_TRANSP_OUTRO_VEICULO ///
IN_TRANSP_EMBAR_ATE5 IN_TRANSP_EMBAR_5A15 ///
IN_TRANSP_EMBAR_15A35 IN_TRANSP_EMBAR_35 IN_TRANSP_TREM_METRO ///
IN_NECESSIDADE_ESPECIAL IN_CEGUEIRA IN_BAIXA_VISAO ///
IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA ///
IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
IN_AUTISMO IN_SINDROME_ASPERGER IN_SINDROME_RETT ///
IN_TRANSTORNO_DI IN_SUPERDOTACAO IN_RECURSO_LEDOR ///
IN_RECURSO_TRANSCRICAO IN_RECURSO_INTERPRETE IN_RECURSO_LIBRAS ///
IN_RECURSO_LABIAL IN_RECURSO_BRAILLE IN_RECURSO_AMPLIADA_16 IN_RECURSO_AMPLIADA_20 ///
IN_RECURSO_AMPLIADA_24 IN_RECURSO_NENHUM TP_INGRESSO_FEDERAIS TP_ETAPA_ENSINO ID_TURMA CO_CURSO_EDUC_PROFISSIONAL ///
TP_UNIFICADA TP_TIPO_TURMA CO_ENTIDADE CO_MUNICIPIO CO_UF TP_DEPENDENCIA

rename (NU_ANO_CENSO ID_MATRICULA CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE_REFERENCIA NU_IDADE ///
NU_DUR_ATIV_COMP_MESMA_REDE NU_DUR_ATIV_COMP_OUTRAS_REDES TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC ///
CO_MUNICIPIO_NASC CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL ///
TP_OUTRO_LOCAL_AULA IN_TRANSPORTE_PUBLICO TP_RESPONSAVEL_TRANSPORTE ///
IN_TRANSP_VANS_KOMBI IN_TRANSP_MICRO_ONIBUS IN_TRANSP_ONIBUS ///
IN_TRANSP_BICICLETA IN_TRANSP_TR_ANIMAL IN_TRANSP_OUTRO_VEICULO ///
IN_TRANSP_EMBAR_ATE5 IN_TRANSP_EMBAR_5A15 ///
IN_TRANSP_EMBAR_15A35 IN_TRANSP_EMBAR_35 IN_TRANSP_TREM_METRO ///
IN_NECESSIDADE_ESPECIAL IN_CEGUEIRA IN_BAIXA_VISAO ///
IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA ///
IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
IN_AUTISMO IN_SINDROME_ASPERGER IN_SINDROME_RETT ///
IN_TRANSTORNO_DI IN_SUPERDOTACAO IN_RECURSO_LEDOR ///
IN_RECURSO_TRANSCRICAO IN_RECURSO_INTERPRETE IN_RECURSO_LIBRAS ///
IN_RECURSO_LABIAL IN_RECURSO_BRAILLE IN_RECURSO_AMPLIADA_16 IN_RECURSO_AMPLIADA_20 ///
IN_RECURSO_AMPLIADA_24 IN_RECURSO_NENHUM TP_INGRESSO_FEDERAIS TP_ETAPA_ENSINO ID_TURMA CO_CURSO_EDUC_PROFISSIONAL ///
TP_UNIFICADA TP_TIPO_TURMA CO_ENTIDADE CO_MUNICIPIO CO_UF TP_DEPENDENCIA) (ano id_matricula id_pessoa_fisica dia_nascimento ///
mes_nascimento ano_nascimento idade_referencia idade ///
duracao_ativ_comp_mesma_rede duracao_ativ_comp_outras_redes ///
sexo cor_raca nacionalidade id_pais_origem ///
id_uf_nascimento id_municipio_nascimento id_uf_endereco ///
id_municipio_endereco zona_residencial outro_local_aula ///
transporte_publico responsavel_transporte ///
transporte_vans_kombi transporte_micro_onibus ///
transporte_onibus transporte_bicicleta ///
transporte_tr_animal transporte_outro_veiculo ///
transporte_embarcacao_ate5 transporte_embarcacao_5a15 ///
transporte_embarcacao_15a35 transporte_embarcacao_35 ///
transporte_trem_metro necessidade_especial cegueira ///
baixa_visao surdez deficiencia_auditiva surdocegueira ///
deficiencia_fisica deficiencia_intelectual ///
deficiencia_multipla autismo sindrome_asperger ///
sindrome_rett transtorno_di superdotacao recurso_ledor /// 
recurso_transcricao recurso_interprete recurso_libras ///
recurso_labial recurso_braille recurso_ampliada_16 ///
recurso_ampliada_20 recurso_ampliada_24 recurso_nenhum ///
ingresso_federais etapa_ensino id_turma ///
id_curso_educ_profissional unificada tipo_turma ///
id_escola id_municipio id_uf rede)


gen sigla_uf = "MG" if id_uf == 31
replace sigla_uf = "RJ" if id_uf == 33

tostring rede, replace
replace rede = "federal" if rede == "1"
replace rede = "estadual" if rede == "2" 
replace rede = "municipal" if rede == "3"
replace rede = "privada" if rede == "4"




foreach estado in MG RJ {
	preserve	
keep if sigla_uf == "`estado'"
drop ano sigla_uf id_uf
export delimited "C:/Users/Matheus/Desktop/particionadastata/ano=`t'/sigla_uf=`estado'/microdados_`estado'.csv", replace
	restore
	
	}
}


* SUDESTE PARTE 2
foreach t in 2015 2016 2017 { 


import delimited C:\Users\Matheus\Desktop\matriculas\a`t'\MATRICULA_SUDESTE.CSV, delimiter("|") encoding(utf8) clear

rename *, upper


keep NU_ANO_CENSO ID_MATRICULA CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE_REFERENCIA NU_IDADE ///
NU_DUR_ATIV_COMP_MESMA_REDE NU_DUR_ATIV_COMP_OUTRAS_REDES TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC ///
CO_MUNICIPIO_NASC CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL ///
TP_OUTRO_LOCAL_AULA IN_TRANSPORTE_PUBLICO TP_RESPONSAVEL_TRANSPORTE ///
IN_TRANSP_VANS_KOMBI IN_TRANSP_MICRO_ONIBUS IN_TRANSP_ONIBUS ///
IN_TRANSP_BICICLETA IN_TRANSP_TR_ANIMAL IN_TRANSP_OUTRO_VEICULO ///
IN_TRANSP_EMBAR_ATE5 IN_TRANSP_EMBAR_5A15 ///
IN_TRANSP_EMBAR_15A35 IN_TRANSP_EMBAR_35 IN_TRANSP_TREM_METRO ///
IN_NECESSIDADE_ESPECIAL IN_CEGUEIRA IN_BAIXA_VISAO ///
IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA ///
IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
IN_AUTISMO IN_SINDROME_ASPERGER IN_SINDROME_RETT ///
IN_TRANSTORNO_DI IN_SUPERDOTACAO IN_RECURSO_LEDOR ///
IN_RECURSO_TRANSCRICAO IN_RECURSO_INTERPRETE IN_RECURSO_LIBRAS ///
IN_RECURSO_LABIAL IN_RECURSO_BRAILLE IN_RECURSO_AMPLIADA_16 IN_RECURSO_AMPLIADA_20 ///
IN_RECURSO_AMPLIADA_24 IN_RECURSO_NENHUM TP_INGRESSO_FEDERAIS TP_ETAPA_ENSINO ID_TURMA CO_CURSO_EDUC_PROFISSIONAL ///
TP_UNIFICADA TP_TIPO_TURMA CO_ENTIDADE CO_MUNICIPIO CO_UF TP_DEPENDENCIA

rename (NU_ANO_CENSO ID_MATRICULA CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE_REFERENCIA NU_IDADE ///
NU_DUR_ATIV_COMP_MESMA_REDE NU_DUR_ATIV_COMP_OUTRAS_REDES TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC ///
CO_MUNICIPIO_NASC CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL ///
TP_OUTRO_LOCAL_AULA IN_TRANSPORTE_PUBLICO TP_RESPONSAVEL_TRANSPORTE ///
IN_TRANSP_VANS_KOMBI IN_TRANSP_MICRO_ONIBUS IN_TRANSP_ONIBUS ///
IN_TRANSP_BICICLETA IN_TRANSP_TR_ANIMAL IN_TRANSP_OUTRO_VEICULO ///
IN_TRANSP_EMBAR_ATE5 IN_TRANSP_EMBAR_5A15 ///
IN_TRANSP_EMBAR_15A35 IN_TRANSP_EMBAR_35 IN_TRANSP_TREM_METRO ///
IN_NECESSIDADE_ESPECIAL IN_CEGUEIRA IN_BAIXA_VISAO ///
IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA ///
IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
IN_AUTISMO IN_SINDROME_ASPERGER IN_SINDROME_RETT ///
IN_TRANSTORNO_DI IN_SUPERDOTACAO IN_RECURSO_LEDOR ///
IN_RECURSO_TRANSCRICAO IN_RECURSO_INTERPRETE IN_RECURSO_LIBRAS ///
IN_RECURSO_LABIAL IN_RECURSO_BRAILLE IN_RECURSO_AMPLIADA_16 IN_RECURSO_AMPLIADA_20 ///
IN_RECURSO_AMPLIADA_24 IN_RECURSO_NENHUM TP_INGRESSO_FEDERAIS TP_ETAPA_ENSINO ID_TURMA CO_CURSO_EDUC_PROFISSIONAL ///
TP_UNIFICADA TP_TIPO_TURMA CO_ENTIDADE CO_MUNICIPIO CO_UF TP_DEPENDENCIA) (ano id_matricula id_pessoa_fisica dia_nascimento ///
mes_nascimento ano_nascimento idade_referencia idade ///
duracao_ativ_comp_mesma_rede duracao_ativ_comp_outras_redes ///
sexo cor_raca nacionalidade id_pais_origem ///
id_uf_nascimento id_municipio_nascimento id_uf_endereco ///
id_municipio_endereco zona_residencial outro_local_aula ///
transporte_publico responsavel_transporte ///
transporte_vans_kombi transporte_micro_onibus ///
transporte_onibus transporte_bicicleta ///
transporte_tr_animal transporte_outro_veiculo ///
transporte_embarcacao_ate5 transporte_embarcacao_5a15 ///
transporte_embarcacao_15a35 transporte_embarcacao_35 ///
transporte_trem_metro necessidade_especial cegueira ///
baixa_visao surdez deficiencia_auditiva surdocegueira ///
deficiencia_fisica deficiencia_intelectual ///
deficiencia_multipla autismo sindrome_asperger ///
sindrome_rett transtorno_di superdotacao recurso_ledor /// 
recurso_transcricao recurso_interprete recurso_libras ///
recurso_labial recurso_braille recurso_ampliada_16 ///
recurso_ampliada_20 recurso_ampliada_24 recurso_nenhum ///
ingresso_federais etapa_ensino id_turma ///
id_curso_educ_profissional unificada tipo_turma ///
id_escola id_municipio id_uf rede)

gen sigla_uf = "ES" if id_uf == 32
replace sigla_uf = "SP" if id_uf == 35

tostring rede, replace
replace rede = "federal" if rede == "1"
replace rede = "estadual" if rede == "2" 
replace rede = "municipal" if rede == "3"
replace rede = "privada" if rede == "4"


foreach estado in ES SP {
	preserve	
keep if sigla_uf == "`estado'"
drop ano sigla_uf id_uf
export delimited "C:/Users/Matheus/Desktop/particionadastata/ano=`t'/sigla_uf=`estado'/microdados_`estado'.csv", replace
	restore
	
	}
}

*SUL
foreach t in 2015 2016 2017{ 


import delimited C:\Users\Matheus\Desktop\matriculas\a`t'\MATRICULA_SUL.CSV, delimiter("|") encoding(utf8) clear

rename *, upper


keep NU_ANO_CENSO ID_MATRICULA CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE_REFERENCIA NU_IDADE ///
NU_DUR_ATIV_COMP_MESMA_REDE NU_DUR_ATIV_COMP_OUTRAS_REDES TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC ///
CO_MUNICIPIO_NASC CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL ///
TP_OUTRO_LOCAL_AULA IN_TRANSPORTE_PUBLICO TP_RESPONSAVEL_TRANSPORTE ///
IN_TRANSP_VANS_KOMBI IN_TRANSP_MICRO_ONIBUS IN_TRANSP_ONIBUS ///
IN_TRANSP_BICICLETA IN_TRANSP_TR_ANIMAL IN_TRANSP_OUTRO_VEICULO ///
IN_TRANSP_EMBAR_ATE5 IN_TRANSP_EMBAR_5A15 ///
IN_TRANSP_EMBAR_15A35 IN_TRANSP_EMBAR_35 IN_TRANSP_TREM_METRO ///
IN_NECESSIDADE_ESPECIAL IN_CEGUEIRA IN_BAIXA_VISAO ///
IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA ///
IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
IN_AUTISMO IN_SINDROME_ASPERGER IN_SINDROME_RETT ///
IN_TRANSTORNO_DI IN_SUPERDOTACAO IN_RECURSO_LEDOR ///
IN_RECURSO_TRANSCRICAO IN_RECURSO_INTERPRETE IN_RECURSO_LIBRAS ///
IN_RECURSO_LABIAL IN_RECURSO_BRAILLE IN_RECURSO_AMPLIADA_16 IN_RECURSO_AMPLIADA_20 ///
IN_RECURSO_AMPLIADA_24 IN_RECURSO_NENHUM TP_INGRESSO_FEDERAIS TP_ETAPA_ENSINO ID_TURMA CO_CURSO_EDUC_PROFISSIONAL ///
TP_UNIFICADA TP_TIPO_TURMA CO_ENTIDADE CO_MUNICIPIO CO_UF TP_DEPENDENCIA

rename (NU_ANO_CENSO ID_MATRICULA CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE_REFERENCIA NU_IDADE ///
NU_DUR_ATIV_COMP_MESMA_REDE NU_DUR_ATIV_COMP_OUTRAS_REDES TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC ///
CO_MUNICIPIO_NASC CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL ///
TP_OUTRO_LOCAL_AULA IN_TRANSPORTE_PUBLICO TP_RESPONSAVEL_TRANSPORTE ///
IN_TRANSP_VANS_KOMBI IN_TRANSP_MICRO_ONIBUS IN_TRANSP_ONIBUS ///
IN_TRANSP_BICICLETA IN_TRANSP_TR_ANIMAL IN_TRANSP_OUTRO_VEICULO ///
IN_TRANSP_EMBAR_ATE5 IN_TRANSP_EMBAR_5A15 ///
IN_TRANSP_EMBAR_15A35 IN_TRANSP_EMBAR_35 IN_TRANSP_TREM_METRO ///
IN_NECESSIDADE_ESPECIAL IN_CEGUEIRA IN_BAIXA_VISAO ///
IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA ///
IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
IN_AUTISMO IN_SINDROME_ASPERGER IN_SINDROME_RETT ///
IN_TRANSTORNO_DI IN_SUPERDOTACAO IN_RECURSO_LEDOR ///
IN_RECURSO_TRANSCRICAO IN_RECURSO_INTERPRETE IN_RECURSO_LIBRAS ///
IN_RECURSO_LABIAL IN_RECURSO_BRAILLE IN_RECURSO_AMPLIADA_16 IN_RECURSO_AMPLIADA_20 ///
IN_RECURSO_AMPLIADA_24 IN_RECURSO_NENHUM TP_INGRESSO_FEDERAIS TP_ETAPA_ENSINO ID_TURMA CO_CURSO_EDUC_PROFISSIONAL ///
TP_UNIFICADA TP_TIPO_TURMA CO_ENTIDADE CO_MUNICIPIO CO_UF TP_DEPENDENCIA) (ano id_matricula id_pessoa_fisica dia_nascimento ///
mes_nascimento ano_nascimento idade_referencia idade ///
duracao_ativ_comp_mesma_rede duracao_ativ_comp_outras_redes ///
sexo cor_raca nacionalidade id_pais_origem ///
id_uf_nascimento id_municipio_nascimento id_uf_endereco ///
id_municipio_endereco zona_residencial outro_local_aula ///
transporte_publico responsavel_transporte ///
transporte_vans_kombi transporte_micro_onibus ///
transporte_onibus transporte_bicicleta ///
transporte_tr_animal transporte_outro_veiculo ///
transporte_embarcacao_ate5 transporte_embarcacao_5a15 ///
transporte_embarcacao_15a35 transporte_embarcacao_35 ///
transporte_trem_metro necessidade_especial cegueira ///
baixa_visao surdez deficiencia_auditiva surdocegueira ///
deficiencia_fisica deficiencia_intelectual ///
deficiencia_multipla autismo sindrome_asperger ///
sindrome_rett transtorno_di superdotacao recurso_ledor /// 
recurso_transcricao recurso_interprete recurso_libras ///
recurso_labial recurso_braille recurso_ampliada_16 ///
recurso_ampliada_20 recurso_ampliada_24 recurso_nenhum ///
ingresso_federais etapa_ensino id_turma ///
id_curso_educ_profissional unificada tipo_turma ///
id_escola id_municipio id_uf rede)

gen sigla_uf = "PR" if id_uf == 41
replace sigla_uf = "RS" if id_uf == 43
replace sigla_uf = "SC" if id_uf == 42

tostring rede, replace
replace rede = "federal" if rede == "1"
replace rede = "estadual" if rede == "2" 
replace rede = "municipal" if rede == "3"
replace rede = "privada" if rede == "4"



foreach estado in PR RS SC {
	preserve	
keep if sigla_uf == "`estado'"
drop ano sigla_uf id_uf
export delimited "C:/Users/Matheus/Desktop/particionadastata/ano=`t'/sigla_uf=`estado'/microdados_`estado'.csv", replace
	restore
	
	}
}

*NORDESTE

foreach t in 2015 2016 2017 { 


import delimited C:\Users\Matheus\Desktop\matriculas\a`t'\MATRICULA_NORDESTE.CSV, delimiter("|") encoding(utf8) clear

rename *, upper


keep NU_ANO_CENSO ID_MATRICULA CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE_REFERENCIA NU_IDADE ///
NU_DUR_ATIV_COMP_MESMA_REDE NU_DUR_ATIV_COMP_OUTRAS_REDES TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC ///
CO_MUNICIPIO_NASC CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL ///
TP_OUTRO_LOCAL_AULA IN_TRANSPORTE_PUBLICO TP_RESPONSAVEL_TRANSPORTE ///
IN_TRANSP_VANS_KOMBI IN_TRANSP_MICRO_ONIBUS IN_TRANSP_ONIBUS ///
IN_TRANSP_BICICLETA IN_TRANSP_TR_ANIMAL IN_TRANSP_OUTRO_VEICULO ///
IN_TRANSP_EMBAR_ATE5 IN_TRANSP_EMBAR_5A15 ///
IN_TRANSP_EMBAR_15A35 IN_TRANSP_EMBAR_35 IN_TRANSP_TREM_METRO ///
IN_NECESSIDADE_ESPECIAL IN_CEGUEIRA IN_BAIXA_VISAO ///
IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA ///
IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
IN_AUTISMO IN_SINDROME_ASPERGER IN_SINDROME_RETT ///
IN_TRANSTORNO_DI IN_SUPERDOTACAO IN_RECURSO_LEDOR ///
IN_RECURSO_TRANSCRICAO IN_RECURSO_INTERPRETE IN_RECURSO_LIBRAS ///
IN_RECURSO_LABIAL IN_RECURSO_BRAILLE IN_RECURSO_AMPLIADA_16 IN_RECURSO_AMPLIADA_20 ///
IN_RECURSO_AMPLIADA_24 IN_RECURSO_NENHUM TP_INGRESSO_FEDERAIS TP_ETAPA_ENSINO ID_TURMA CO_CURSO_EDUC_PROFISSIONAL ///
TP_UNIFICADA TP_TIPO_TURMA CO_ENTIDADE CO_MUNICIPIO CO_UF TP_DEPENDENCIA

rename (NU_ANO_CENSO ID_MATRICULA CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE_REFERENCIA NU_IDADE ///
NU_DUR_ATIV_COMP_MESMA_REDE NU_DUR_ATIV_COMP_OUTRAS_REDES TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC ///
CO_MUNICIPIO_NASC CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL ///
TP_OUTRO_LOCAL_AULA IN_TRANSPORTE_PUBLICO TP_RESPONSAVEL_TRANSPORTE ///
IN_TRANSP_VANS_KOMBI IN_TRANSP_MICRO_ONIBUS IN_TRANSP_ONIBUS ///
IN_TRANSP_BICICLETA IN_TRANSP_TR_ANIMAL IN_TRANSP_OUTRO_VEICULO ///
IN_TRANSP_EMBAR_ATE5 IN_TRANSP_EMBAR_5A15 ///
IN_TRANSP_EMBAR_15A35 IN_TRANSP_EMBAR_35 IN_TRANSP_TREM_METRO ///
IN_NECESSIDADE_ESPECIAL IN_CEGUEIRA IN_BAIXA_VISAO ///
IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA ///
IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
IN_AUTISMO IN_SINDROME_ASPERGER IN_SINDROME_RETT ///
IN_TRANSTORNO_DI IN_SUPERDOTACAO IN_RECURSO_LEDOR ///
IN_RECURSO_TRANSCRICAO IN_RECURSO_INTERPRETE IN_RECURSO_LIBRAS ///
IN_RECURSO_LABIAL IN_RECURSO_BRAILLE IN_RECURSO_AMPLIADA_16 IN_RECURSO_AMPLIADA_20 ///
IN_RECURSO_AMPLIADA_24 IN_RECURSO_NENHUM TP_INGRESSO_FEDERAIS TP_ETAPA_ENSINO ID_TURMA CO_CURSO_EDUC_PROFISSIONAL ///
TP_UNIFICADA TP_TIPO_TURMA CO_ENTIDADE CO_MUNICIPIO CO_UF TP_DEPENDENCIA) (ano id_matricula id_pessoa_fisica dia_nascimento ///
mes_nascimento ano_nascimento idade_referencia idade ///
duracao_ativ_comp_mesma_rede duracao_ativ_comp_outras_redes ///
sexo cor_raca nacionalidade id_pais_origem ///
id_uf_nascimento id_municipio_nascimento id_uf_endereco ///
id_municipio_endereco zona_residencial outro_local_aula ///
transporte_publico responsavel_transporte ///
transporte_vans_kombi transporte_micro_onibus ///
transporte_onibus transporte_bicicleta ///
transporte_tr_animal transporte_outro_veiculo ///
transporte_embarcacao_ate5 transporte_embarcacao_5a15 ///
transporte_embarcacao_15a35 transporte_embarcacao_35 ///
transporte_trem_metro necessidade_especial cegueira ///
baixa_visao surdez deficiencia_auditiva surdocegueira ///
deficiencia_fisica deficiencia_intelectual ///
deficiencia_multipla autismo sindrome_asperger ///
sindrome_rett transtorno_di superdotacao recurso_ledor /// 
recurso_transcricao recurso_interprete recurso_libras ///
recurso_labial recurso_braille recurso_ampliada_16 ///
recurso_ampliada_20 recurso_ampliada_24 recurso_nenhum ///
ingresso_federais etapa_ensino id_turma ///
id_curso_educ_profissional unificada tipo_turma ///
id_escola id_municipio id_uf rede)

gen sigla_uf = "AL" if id_uf == 27
replace sigla_uf = "BA" if id_uf == 29
replace sigla_uf = "CE" if id_uf == 23
replace sigla_uf = "MA" if id_uf == 21
replace sigla_uf = "PB" if id_uf == 25
replace sigla_uf = "PE" if id_uf == 26
replace sigla_uf = "PI" if id_uf == 22
replace sigla_uf = "RN" if id_uf == 24
replace sigla_uf = "SE" if id_uf == 28

tostring rede, replace
replace rede = "federal" if rede == "1"
replace rede = "estadual" if rede == "2" 
replace rede = "municipal" if rede == "3"
replace rede = "privada" if rede == "4"

foreach estado in AL BA CE MA PB PE PI RN SE {
	preserve	
keep if sigla_uf == "`estado'"
drop ano sigla_uf id_uf
export delimited "C:/Users/Matheus/Desktop/particionadastata/ano=`t'/sigla_uf=`estado'/microdados_`estado'.csv", replace
	restore
	
	}
}







