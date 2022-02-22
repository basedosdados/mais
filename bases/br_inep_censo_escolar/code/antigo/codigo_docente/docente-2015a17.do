
*foreach ano in 2015 2016 2017 2018 2019 2020 {
*mkdir "C:/Users/Matheus/Desktop/particionadastata/ano=`ano'"
*foreach estado in AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO {


*mkdir "C:/Users/Matheus/Desktop/particionadastata/ano=`ano'/sigla_uf=`estado'"
*}
*}




*rodando anos antigos 



*centro oeste
foreach t in  2019 2020 {

import delimited C:\Users\Matheus\Desktop\docente\a`t'\DOCENTES_CO.CSV, delimiter("|") encoding(utf8) clear

rename *, upper

if `t' == 2015{
rename IN_POSSUI_NEC_ESPECIAL IN_NECESSIDADE_ESPECIAL
}

if `t' == 2018{
rename ID_DOCENTE CO_PESSOA_FISICA
}

if `t' > 2018{
gen NU_DIA = ""
gen IN_COM_PEDAGOGICA_1 = ""
gen IN_COM_PEDAGOGICA_2 = ""
gen IN_COM_PEDAGOGICA_3 = ""
gen NU_ANO_INICIO_1 = ""
gen NU_ANO_INICIO_2 = ""
gen NU_ANO_INICIO_3 = ""
gen IN_DISC_ATENDIMENTO_ESPECIAIS = ""
gen  IN_DISC_DIVER_SOCIO_CULTURAL = ""
gen TP_TIPO_TURMA  = ""
rename ID_DOCENTE CO_PESSOA_FISICA

}

keep NU_ANO_CENSO CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE ///
NU_IDADE_REFERENCIA TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC CO_MUNICIPIO_NASC ///
CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL IN_NECESSIDADE_ESPECIAL ///
IN_CEGUEIRA IN_BAIXA_VISAO IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
TP_ESCOLARIDADE TP_SITUACAO_CURSO_1 CO_AREA_CURSO_1 CO_CURSO_1 IN_LICENCIATURA_1 IN_COM_PEDAGOGICA_1 ///
NU_ANO_INICIO_1 NU_ANO_CONCLUSAO_1 TP_TIPO_IES_1 CO_IES_1 TP_SITUACAO_CURSO_2 CO_AREA_CURSO_2 CO_CURSO_2 ///
IN_LICENCIATURA_2 IN_COM_PEDAGOGICA_2 NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 TP_TIPO_IES_2 CO_IES_2 ///
TP_SITUACAO_CURSO_3 CO_AREA_CURSO_3 CO_CURSO_3 IN_LICENCIATURA_3 IN_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 /// 
NU_ANO_CONCLUSAO_3 TP_TIPO_IES_3 CO_IES_3 IN_DISC_QUIMICA IN_DISC_FISICA IN_DISC_MATEMATICA ///
IN_DISC_BIOLOGIA IN_DISC_CIENCIAS IN_DISC_LINGUA_PORTUGUESA IN_DISC_LINGUA_INGLES ///
IN_DISC_LINGUA_ESPANHOL IN_DISC_LINGUA_FRANCES IN_DISC_LINGUA_OUTRA IN_DISC_LINGUA_INDIGENA IN_DISC_ARTES ///
IN_DISC_EDUCACAO_FISICA IN_DISC_HISTORIA IN_DISC_GEOGRAFIA ///
IN_DISC_FILOSOFIA IN_DISC_ENSINO_RELIGIOSO IN_DISC_ESTUDOS_SOCIAIS ///
IN_DISC_SOCIOLOGIA IN_DISC_INFORMATICA_COMPUTACAO IN_DISC_PROFISSIONALIZANTE ///
IN_DISC_ATENDIMENTO_ESPECIAIS IN_DISC_DIVER_SOCIO_CULTURAL IN_DISC_LIBRAS ///
IN_DISC_PEDAGOGICAS IN_DISC_OUTRAS IN_ESPECIALIZACAO IN_MESTRADO IN_DOUTORADO ///
IN_POS_NENHUM IN_ESPECIFICO_CRECHE ///
IN_ESPECIFICO_PRE_ESCOLA IN_ESPECIFICO_ANOS_INICIAIS IN_ESPECIFICO_ANOS_FINAIS IN_ESPECIFICO_ENS_MEDIO ///
IN_ESPECIFICO_EJA IN_ESPECIFICO_ED_ESPECIAL IN_ESPECIFICO_ED_INDIGENA IN_ESPECIFICO_CAMPO ///
IN_ESPECIFICO_AMBIENTAL IN_ESPECIFICO_DIR_HUMANOS IN_ESPECIFICO_DIV_SEXUAL IN_ESPECIFICO_DIR_ADOLESC IN_ESPECIFICO_AFRO ///
IN_ESPECIFICO_OUTROS IN_ESPECIFICO_NENHUM TP_TIPO_DOCENTE TP_TIPO_CONTRATACAO ID_TURMA TP_TIPO_TURMA /// 
TP_MEDIACAO_DIDATICO_PEDAGO IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE TP_ETAPA_ENSINO CO_CURSO_EDUC_PROFISSIONAL ///
CO_ENTIDADE CO_UF CO_MUNICIPIO TP_DEPENDENCIA TP_LOCALIZACAO TP_CATEGORIA_ESCOLA_PRIVADA ///
IN_CONVENIADA_PP TP_CONVENIO_PODER_PUBLICO IN_MANT_ESCOLA_PRIVADA_EMP IN_MANT_ESCOLA_PRIVADA_ONG IN_MANT_ESCOLA_PRIVADA_SIND ///
IN_MANT_ESCOLA_PRIVADA_SIST_S IN_MANT_ESCOLA_PRIVADA_S_FINS TP_REGULAMENTACAO TP_LOCALIZACAO_DIFERENCIADA IN_EDUCACAO_INDIGENA






*renomeando as variaveis

rename NU_ANO_CENSO ano 
rename CO_PESSOA_FISICA id_docente 
rename NU_MES mes_nascimento_docente 
rename NU_ANO ano_nascimento_docente 
rename NU_DIA dia_nascimento_docente 
rename NU_IDADE idade 
rename NU_IDADE_REFERENCIA idade_referencia 
rename TP_SEXO sexo 
rename TP_COR_RACA cor_raca 
rename TP_NACIONALIDADE nacionalidade 
rename CO_PAIS_ORIGEM id_pais_origem 
rename CO_UF_NASC id_uf_nascimento 
rename CO_MUNICIPIO_NASC id_municipio_nascimento 
rename CO_UF_END id_uf_endereco 
rename CO_MUNICIPIO_END id_municipio_endereco 
rename TP_ZONA_RESIDENCIAL zona_residencial 



rename (IN_NECESSIDADE_ESPECIAL ///
IN_CEGUEIRA IN_BAIXA_VISAO IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
TP_ESCOLARIDADE TP_SITUACAO_CURSO_1 CO_AREA_CURSO_1 CO_CURSO_1 IN_LICENCIATURA_1 IN_COM_PEDAGOGICA_1 ///
NU_ANO_INICIO_1 NU_ANO_CONCLUSAO_1 TP_TIPO_IES_1 CO_IES_1 TP_SITUACAO_CURSO_2 CO_AREA_CURSO_2 CO_CURSO_2 ///
IN_LICENCIATURA_2 IN_COM_PEDAGOGICA_2 NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 TP_TIPO_IES_2 CO_IES_2 ///
TP_SITUACAO_CURSO_3 CO_AREA_CURSO_3 CO_CURSO_3 IN_LICENCIATURA_3 IN_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 /// 
NU_ANO_CONCLUSAO_3 TP_TIPO_IES_3 CO_IES_3 IN_DISC_QUIMICA IN_DISC_FISICA IN_DISC_MATEMATICA ///
IN_DISC_BIOLOGIA IN_DISC_CIENCIAS IN_DISC_LINGUA_PORTUGUESA IN_DISC_LINGUA_INGLES ///
IN_DISC_LINGUA_ESPANHOL IN_DISC_LINGUA_FRANCES IN_DISC_LINGUA_OUTRA IN_DISC_LINGUA_INDIGENA IN_DISC_ARTES ///
IN_DISC_EDUCACAO_FISICA IN_DISC_HISTORIA IN_DISC_GEOGRAFIA ///
IN_DISC_FILOSOFIA IN_DISC_ENSINO_RELIGIOSO IN_DISC_ESTUDOS_SOCIAIS ///
IN_DISC_SOCIOLOGIA IN_DISC_INFORMATICA_COMPUTACAO IN_DISC_PROFISSIONALIZANTE ///
IN_DISC_ATENDIMENTO_ESPECIAIS IN_DISC_DIVER_SOCIO_CULTURAL IN_DISC_LIBRAS ///
IN_DISC_PEDAGOGICAS IN_DISC_OUTRAS IN_ESPECIALIZACAO IN_MESTRADO IN_DOUTORADO ///
IN_POS_NENHUM IN_ESPECIFICO_CRECHE ///
IN_ESPECIFICO_PRE_ESCOLA IN_ESPECIFICO_ANOS_INICIAIS IN_ESPECIFICO_ANOS_FINAIS IN_ESPECIFICO_ENS_MEDIO ///
IN_ESPECIFICO_EJA IN_ESPECIFICO_ED_ESPECIAL IN_ESPECIFICO_ED_INDIGENA IN_ESPECIFICO_CAMPO ///
IN_ESPECIFICO_AMBIENTAL IN_ESPECIFICO_DIR_HUMANOS IN_ESPECIFICO_DIV_SEXUAL IN_ESPECIFICO_DIR_ADOLESC IN_ESPECIFICO_AFRO ///
IN_ESPECIFICO_OUTROS IN_ESPECIFICO_NENHUM TP_TIPO_DOCENTE TP_TIPO_CONTRATACAO ID_TURMA TP_TIPO_TURMA /// 
TP_MEDIACAO_DIDATICO_PEDAGO IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE TP_ETAPA_ENSINO CO_CURSO_EDUC_PROFISSIONAL ///
CO_ENTIDADE CO_UF CO_MUNICIPIO TP_DEPENDENCIA TP_LOCALIZACAO TP_CATEGORIA_ESCOLA_PRIVADA ///
IN_CONVENIADA_PP TP_CONVENIO_PODER_PUBLICO IN_MANT_ESCOLA_PRIVADA_EMP IN_MANT_ESCOLA_PRIVADA_ONG IN_MANT_ESCOLA_PRIVADA_SIND ///
IN_MANT_ESCOLA_PRIVADA_SIST_S IN_MANT_ESCOLA_PRIVADA_S_FINS TP_REGULAMENTACAO ///
TP_LOCALIZACAO_DIFERENCIADA IN_EDUCACAO_INDIGENA) (necessidade_especial ///
cegueira baixa_visao surdez deficiencia_auditiva surdocegueira deficiencia_fisica deficiencia_intelectual deficiencia_multipla ///
escolaridade situacao_curso_1 id_area_curso_1 id_curso_1 licenciatura_1 formacao_pedagogica_comp_1 ano_inicio_curso_superior_1 ///
ano_conclusao_curso_superior_1 tipo_ies_1 id_ies_1 situacao_curso_2 ///
id_area_curso_2 id_curso_2 licenciatura_2 formacao_pedagogica_comp_2 ano_inicio_curso_superior_2 ///
ano_conclusao_curso_superior_2 tipo_ies_2 id_ies_2 situacao_curso_3 id_area_curso_3 id_curso_3 licenciatura_3 formacao_pedagogica_comp_3 ///
ano_inicio_curso_superior_3 ano_conclusao_curso_superior_3 tipo_ies_3 id_ies_3 disciplina_quimica disciplina_fisica disciplina_matematica ///
disciplina_biologia disciplina_ciencias disciplina_lingua_portuguesa disciplina_lingua_ingles disciplina_lingua_espanhol disciplina_lingua_frances ///
disciplina_lingua_outra disciplina_lingua_indigena disciplina_artes disciplina_educacao_fisica disciplina_historia disciplina_geografia ///
disciplina_filosofia disciplina_ensino_religioso disciplina_estudos_sociais disciplina_sociologia disciplina_informatica_comp ///
disciplina_profissionalizante disciplina_atend_especiais disciplina_diver_socio_cultural ///
disciplina_libras disciplina_pedagogicas disciplina_outras especializacao mestrado doutorado pos_nenhum ///
formacao_especif_creche formacao_especif_pre_escola formacao_especif_anos_iniciais formacao_especif_anos_finais ///
formacao_especif_ens_medio formacao_especif_eja formacao_especif_ed_especial formacao_especif_ed_indigena ///
formacao_especif_campo formacao_especif_ambiental formacao_especif_dir_humanos formacao_especif_div_sexual ///
formacao_especif_dir_adolesc formacao_especif_afro formacao_especif_outros formacao_especif_nenhum ///
tipo_docente tipo_contratacao id_turma tipo_turma mediacao_didatico_pedago especial_exclusiva regular eja profissionalizante ///
etapa_ensino id_curso_educ_profissional id_escola id_uf id_municipio rede localizacao categoria_escola_privada ///
conveniada_pp convenio_poder_publico mant_escola_privada_emp mant_escola_privada_ong mant_escola_privada_sind ///
mant_escola_privada_sist_s mant_escola_privada_s_fins regulamentacao localizacao_diferenciada educacao_indigena)









tostring id_uf, replace
gen sigla_uf = "MT" if id_uf == "51"
replace sigla_uf = "GO" if id_uf == "52"
replace sigla_uf = "MS" if id_uf == "50"
replace sigla_uf = "DF" if id_uf == "53"

tostring rede, replace
replace rede = "federal" if rede == "1"
replace rede = "estadual" if rede == "2" 
replace rede = "municipal" if rede == "3"
replace rede = "privada" if rede == "4"


order ano id_docente mes_nascimento_docente ano_nascimento_docente /// 
dia_nascimento_docente idade idade_referencia sexo cor_raca nacionalidade ///
id_pais_origem id_uf_nascimento id_municipio_nascimento id_uf_endereco id_municipio_endereco zona_residencial necessidade_especial ///
cegueira baixa_visao surdez deficiencia_auditiva surdocegueira deficiencia_fisica deficiencia_intelectual deficiencia_multipla ///
escolaridade situacao_curso_1 id_area_curso_1 id_curso_1 licenciatura_1 formacao_pedagogica_comp_1 ano_inicio_curso_superior_1 ///
ano_conclusao_curso_superior_1 tipo_ies_1 id_ies_1 situacao_curso_2 ///
id_area_curso_2 id_curso_2 licenciatura_2 formacao_pedagogica_comp_2 ano_inicio_curso_superior_2 ///
ano_conclusao_curso_superior_2 tipo_ies_2 id_ies_2 situacao_curso_3 id_area_curso_3 id_curso_3 licenciatura_3 formacao_pedagogica_comp_3 ///
ano_inicio_curso_superior_3 ano_conclusao_curso_superior_3 tipo_ies_3 id_ies_3 disciplina_quimica disciplina_fisica disciplina_matematica ///
disciplina_biologia disciplina_ciencias disciplina_lingua_portuguesa disciplina_lingua_ingles disciplina_lingua_espanhol disciplina_lingua_frances ///
disciplina_lingua_outra disciplina_lingua_indigena disciplina_artes disciplina_educacao_fisica disciplina_historia disciplina_geografia ///
disciplina_filosofia disciplina_ensino_religioso disciplina_estudos_sociais disciplina_sociologia disciplina_informatica_comp ///
disciplina_profissionalizante disciplina_atend_especiais disciplina_diver_socio_cultural ///
disciplina_libras disciplina_pedagogicas disciplina_outras especializacao mestrado doutorado pos_nenhum ///
formacao_especif_creche formacao_especif_pre_escola formacao_especif_anos_iniciais formacao_especif_anos_finais ///
formacao_especif_ens_medio formacao_especif_eja formacao_especif_ed_especial formacao_especif_ed_indigena ///
formacao_especif_campo formacao_especif_ambiental formacao_especif_dir_humanos formacao_especif_div_sexual ///
formacao_especif_dir_adolesc formacao_especif_afro formacao_especif_outros formacao_especif_nenhum ///
tipo_docente tipo_contratacao id_turma tipo_turma mediacao_didatico_pedago especial_exclusiva regular eja profissionalizante ///
etapa_ensino id_curso_educ_profissional id_escola id_uf id_municipio rede localizacao categoria_escola_privada ///
conveniada_pp convenio_poder_publico mant_escola_privada_emp mant_escola_privada_ong mant_escola_privada_sind ///
mant_escola_privada_sist_s mant_escola_privada_s_fins regulamentacao localizacao_diferenciada educacao_indigena


foreach estado in DF GO MS MT {
	preserve
keep if sigla_uf == "`estado'"
drop ano sigla_uf id_uf
export delimited "C:/Users/Matheus/Desktop/particionadastata/ano=`t'/sigla_uf=`estado'/microdados_`estado'.csv" , replace
	restore
	
	}
}

*norte

foreach t in  2015 2016 2017 2018 2019 2020{

import delimited C:\Users\Matheus\Desktop\docente\a`t'\DOCENTES_NORTE.CSV, delimiter("|") encoding(utf8) clear

rename *, upper

if `t' == 2015{
rename IN_POSSUI_NEC_ESPECIAL IN_NECESSIDADE_ESPECIAL
}

if `t' == 2018{
rename ID_DOCENTE CO_PESSOA_FISICA
}

if `t' > 2018{
gen NU_DIA = ""
gen IN_COM_PEDAGOGICA_1 = ""
gen IN_COM_PEDAGOGICA_2 = ""
gen IN_COM_PEDAGOGICA_3 = ""
gen NU_ANO_INICIO_1 = ""
gen NU_ANO_INICIO_2 = ""
gen NU_ANO_INICIO_3 = ""
gen IN_DISC_ATENDIMENTO_ESPECIAIS = ""
gen  IN_DISC_DIVER_SOCIO_CULTURAL = ""
gen TP_TIPO_TURMA  = ""
rename ID_DOCENTE CO_PESSOA_FISICA

}

keep NU_ANO_CENSO CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE ///
NU_IDADE_REFERENCIA TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC CO_MUNICIPIO_NASC ///
CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL IN_NECESSIDADE_ESPECIAL ///
IN_CEGUEIRA IN_BAIXA_VISAO IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
TP_ESCOLARIDADE TP_SITUACAO_CURSO_1 CO_AREA_CURSO_1 CO_CURSO_1 IN_LICENCIATURA_1 IN_COM_PEDAGOGICA_1 ///
NU_ANO_INICIO_1 NU_ANO_CONCLUSAO_1 TP_TIPO_IES_1 CO_IES_1 TP_SITUACAO_CURSO_2 CO_AREA_CURSO_2 CO_CURSO_2 ///
IN_LICENCIATURA_2 IN_COM_PEDAGOGICA_2 NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 TP_TIPO_IES_2 CO_IES_2 ///
TP_SITUACAO_CURSO_3 CO_AREA_CURSO_3 CO_CURSO_3 IN_LICENCIATURA_3 IN_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 /// 
NU_ANO_CONCLUSAO_3 TP_TIPO_IES_3 CO_IES_3 IN_DISC_QUIMICA IN_DISC_FISICA IN_DISC_MATEMATICA ///
IN_DISC_BIOLOGIA IN_DISC_CIENCIAS IN_DISC_LINGUA_PORTUGUESA IN_DISC_LINGUA_INGLES ///
IN_DISC_LINGUA_ESPANHOL IN_DISC_LINGUA_FRANCES IN_DISC_LINGUA_OUTRA IN_DISC_LINGUA_INDIGENA IN_DISC_ARTES ///
IN_DISC_EDUCACAO_FISICA IN_DISC_HISTORIA IN_DISC_GEOGRAFIA ///
IN_DISC_FILOSOFIA IN_DISC_ENSINO_RELIGIOSO IN_DISC_ESTUDOS_SOCIAIS ///
IN_DISC_SOCIOLOGIA IN_DISC_INFORMATICA_COMPUTACAO IN_DISC_PROFISSIONALIZANTE ///
IN_DISC_ATENDIMENTO_ESPECIAIS IN_DISC_DIVER_SOCIO_CULTURAL IN_DISC_LIBRAS ///
IN_DISC_PEDAGOGICAS IN_DISC_OUTRAS IN_ESPECIALIZACAO IN_MESTRADO IN_DOUTORADO ///
IN_POS_NENHUM IN_ESPECIFICO_CRECHE ///
IN_ESPECIFICO_PRE_ESCOLA IN_ESPECIFICO_ANOS_INICIAIS IN_ESPECIFICO_ANOS_FINAIS IN_ESPECIFICO_ENS_MEDIO ///
IN_ESPECIFICO_EJA IN_ESPECIFICO_ED_ESPECIAL IN_ESPECIFICO_ED_INDIGENA IN_ESPECIFICO_CAMPO ///
IN_ESPECIFICO_AMBIENTAL IN_ESPECIFICO_DIR_HUMANOS IN_ESPECIFICO_DIV_SEXUAL IN_ESPECIFICO_DIR_ADOLESC IN_ESPECIFICO_AFRO ///
IN_ESPECIFICO_OUTROS IN_ESPECIFICO_NENHUM TP_TIPO_DOCENTE TP_TIPO_CONTRATACAO ID_TURMA TP_TIPO_TURMA /// 
TP_MEDIACAO_DIDATICO_PEDAGO IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE TP_ETAPA_ENSINO CO_CURSO_EDUC_PROFISSIONAL ///
CO_ENTIDADE CO_UF CO_MUNICIPIO TP_DEPENDENCIA TP_LOCALIZACAO TP_CATEGORIA_ESCOLA_PRIVADA ///
IN_CONVENIADA_PP TP_CONVENIO_PODER_PUBLICO IN_MANT_ESCOLA_PRIVADA_EMP IN_MANT_ESCOLA_PRIVADA_ONG IN_MANT_ESCOLA_PRIVADA_SIND ///
IN_MANT_ESCOLA_PRIVADA_SIST_S IN_MANT_ESCOLA_PRIVADA_S_FINS TP_REGULAMENTACAO TP_LOCALIZACAO_DIFERENCIADA IN_EDUCACAO_INDIGENA






*renomeando as variaveis

rename NU_ANO_CENSO ano 
rename CO_PESSOA_FISICA id_docente 
rename NU_MES mes_nascimento_docente 
rename NU_ANO ano_nascimento_docente 
rename NU_DIA dia_nascimento_docente 
rename NU_IDADE idade 
rename NU_IDADE_REFERENCIA idade_referencia 
rename TP_SEXO sexo 
rename TP_COR_RACA cor_raca 
rename TP_NACIONALIDADE nacionalidade 
rename CO_PAIS_ORIGEM id_pais_origem 
rename CO_UF_NASC id_uf_nascimento 
rename CO_MUNICIPIO_NASC id_municipio_nascimento 
rename CO_UF_END id_uf_endereco 
rename CO_MUNICIPIO_END id_municipio_endereco 
rename TP_ZONA_RESIDENCIAL zona_residencial 



rename (IN_NECESSIDADE_ESPECIAL ///
IN_CEGUEIRA IN_BAIXA_VISAO IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
TP_ESCOLARIDADE TP_SITUACAO_CURSO_1 CO_AREA_CURSO_1 CO_CURSO_1 IN_LICENCIATURA_1 IN_COM_PEDAGOGICA_1 ///
NU_ANO_INICIO_1 NU_ANO_CONCLUSAO_1 TP_TIPO_IES_1 CO_IES_1 TP_SITUACAO_CURSO_2 CO_AREA_CURSO_2 CO_CURSO_2 ///
IN_LICENCIATURA_2 IN_COM_PEDAGOGICA_2 NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 TP_TIPO_IES_2 CO_IES_2 ///
TP_SITUACAO_CURSO_3 CO_AREA_CURSO_3 CO_CURSO_3 IN_LICENCIATURA_3 IN_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 /// 
NU_ANO_CONCLUSAO_3 TP_TIPO_IES_3 CO_IES_3 IN_DISC_QUIMICA IN_DISC_FISICA IN_DISC_MATEMATICA ///
IN_DISC_BIOLOGIA IN_DISC_CIENCIAS IN_DISC_LINGUA_PORTUGUESA IN_DISC_LINGUA_INGLES ///
IN_DISC_LINGUA_ESPANHOL IN_DISC_LINGUA_FRANCES IN_DISC_LINGUA_OUTRA IN_DISC_LINGUA_INDIGENA IN_DISC_ARTES ///
IN_DISC_EDUCACAO_FISICA IN_DISC_HISTORIA IN_DISC_GEOGRAFIA ///
IN_DISC_FILOSOFIA IN_DISC_ENSINO_RELIGIOSO IN_DISC_ESTUDOS_SOCIAIS ///
IN_DISC_SOCIOLOGIA IN_DISC_INFORMATICA_COMPUTACAO IN_DISC_PROFISSIONALIZANTE ///
IN_DISC_ATENDIMENTO_ESPECIAIS IN_DISC_DIVER_SOCIO_CULTURAL IN_DISC_LIBRAS ///
IN_DISC_PEDAGOGICAS IN_DISC_OUTRAS IN_ESPECIALIZACAO IN_MESTRADO IN_DOUTORADO ///
IN_POS_NENHUM IN_ESPECIFICO_CRECHE ///
IN_ESPECIFICO_PRE_ESCOLA IN_ESPECIFICO_ANOS_INICIAIS IN_ESPECIFICO_ANOS_FINAIS IN_ESPECIFICO_ENS_MEDIO ///
IN_ESPECIFICO_EJA IN_ESPECIFICO_ED_ESPECIAL IN_ESPECIFICO_ED_INDIGENA IN_ESPECIFICO_CAMPO ///
IN_ESPECIFICO_AMBIENTAL IN_ESPECIFICO_DIR_HUMANOS IN_ESPECIFICO_DIV_SEXUAL IN_ESPECIFICO_DIR_ADOLESC IN_ESPECIFICO_AFRO ///
IN_ESPECIFICO_OUTROS IN_ESPECIFICO_NENHUM TP_TIPO_DOCENTE TP_TIPO_CONTRATACAO ID_TURMA TP_TIPO_TURMA /// 
TP_MEDIACAO_DIDATICO_PEDAGO IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE TP_ETAPA_ENSINO CO_CURSO_EDUC_PROFISSIONAL ///
CO_ENTIDADE CO_UF CO_MUNICIPIO TP_DEPENDENCIA TP_LOCALIZACAO TP_CATEGORIA_ESCOLA_PRIVADA ///
IN_CONVENIADA_PP TP_CONVENIO_PODER_PUBLICO IN_MANT_ESCOLA_PRIVADA_EMP IN_MANT_ESCOLA_PRIVADA_ONG IN_MANT_ESCOLA_PRIVADA_SIND ///
IN_MANT_ESCOLA_PRIVADA_SIST_S IN_MANT_ESCOLA_PRIVADA_S_FINS TP_REGULAMENTACAO ///
TP_LOCALIZACAO_DIFERENCIADA IN_EDUCACAO_INDIGENA) (necessidade_especial ///
cegueira baixa_visao surdez deficiencia_auditiva surdocegueira deficiencia_fisica deficiencia_intelectual deficiencia_multipla ///
escolaridade situacao_curso_1 id_area_curso_1 id_curso_1 licenciatura_1 formacao_pedagogica_comp_1 ano_inicio_curso_superior_1 ///
ano_conclusao_curso_superior_1 tipo_ies_1 id_ies_1 situacao_curso_2 ///
id_area_curso_2 id_curso_2 licenciatura_2 formacao_pedagogica_comp_2 ano_inicio_curso_superior_2 ///
ano_conclusao_curso_superior_2 tipo_ies_2 id_ies_2 situacao_curso_3 id_area_curso_3 id_curso_3 licenciatura_3 formacao_pedagogica_comp_3 ///
ano_inicio_curso_superior_3 ano_conclusao_curso_superior_3 tipo_ies_3 id_ies_3 disciplina_quimica disciplina_fisica disciplina_matematica ///
disciplina_biologia disciplina_ciencias disciplina_lingua_portuguesa disciplina_lingua_ingles disciplina_lingua_espanhol disciplina_lingua_frances ///
disciplina_lingua_outra disciplina_lingua_indigena disciplina_artes disciplina_educacao_fisica disciplina_historia disciplina_geografia ///
disciplina_filosofia disciplina_ensino_religioso disciplina_estudos_sociais disciplina_sociologia disciplina_informatica_comp ///
disciplina_profissionalizante disciplina_atend_especiais disciplina_diver_socio_cultural ///
disciplina_libras disciplina_pedagogicas disciplina_outras especializacao mestrado doutorado pos_nenhum ///
formacao_especif_creche formacao_especif_pre_escola formacao_especif_anos_iniciais formacao_especif_anos_finais ///
formacao_especif_ens_medio formacao_especif_eja formacao_especif_ed_especial formacao_especif_ed_indigena ///
formacao_especif_campo formacao_especif_ambiental formacao_especif_dir_humanos formacao_especif_div_sexual ///
formacao_especif_dir_adolesc formacao_especif_afro formacao_especif_outros formacao_especif_nenhum ///
tipo_docente tipo_contratacao id_turma tipo_turma mediacao_didatico_pedago especial_exclusiva regular eja profissionalizante ///
etapa_ensino id_curso_educ_profissional id_escola id_uf id_municipio rede localizacao categoria_escola_privada ///
conveniada_pp convenio_poder_publico mant_escola_privada_emp mant_escola_privada_ong mant_escola_privada_sind ///
mant_escola_privada_sist_s mant_escola_privada_s_fins regulamentacao localizacao_diferenciada educacao_indigena)



tostring id_uf, replace
gen sigla_uf = "AM" if id_uf == "13"
replace sigla_uf = "AP" if id_uf == "16"
replace sigla_uf = "AC" if id_uf == "12"
replace sigla_uf = "RR" if id_uf == "14"
replace sigla_uf = "RO" if id_uf == "11"
replace sigla_uf = "PA" if id_uf == "15"
replace sigla_uf = "TO" if id_uf == "17"

tostring rede, replace
replace rede = "federal" if rede == "1"
replace rede = "estadual" if rede == "2" 
replace rede = "municipal" if rede == "3"
replace rede = "privada" if rede == "4"


order ano id_docente mes_nascimento_docente ano_nascimento_docente /// 
dia_nascimento_docente idade idade_referencia sexo cor_raca nacionalidade ///
id_pais_origem id_uf_nascimento id_municipio_nascimento id_uf_endereco id_municipio_endereco zona_residencial necessidade_especial ///
cegueira baixa_visao surdez deficiencia_auditiva surdocegueira deficiencia_fisica deficiencia_intelectual deficiencia_multipla ///
escolaridade situacao_curso_1 id_area_curso_1 id_curso_1 licenciatura_1 formacao_pedagogica_comp_1 ano_inicio_curso_superior_1 ///
ano_conclusao_curso_superior_1 tipo_ies_1 id_ies_1 situacao_curso_2 ///
id_area_curso_2 id_curso_2 licenciatura_2 formacao_pedagogica_comp_2 ano_inicio_curso_superior_2 ///
ano_conclusao_curso_superior_2 tipo_ies_2 id_ies_2 situacao_curso_3 id_area_curso_3 id_curso_3 licenciatura_3 formacao_pedagogica_comp_3 ///
ano_inicio_curso_superior_3 ano_conclusao_curso_superior_3 tipo_ies_3 id_ies_3 disciplina_quimica disciplina_fisica disciplina_matematica ///
disciplina_biologia disciplina_ciencias disciplina_lingua_portuguesa disciplina_lingua_ingles disciplina_lingua_espanhol disciplina_lingua_frances ///
disciplina_lingua_outra disciplina_lingua_indigena disciplina_artes disciplina_educacao_fisica disciplina_historia disciplina_geografia ///
disciplina_filosofia disciplina_ensino_religioso disciplina_estudos_sociais disciplina_sociologia disciplina_informatica_comp ///
disciplina_profissionalizante disciplina_atend_especiais disciplina_diver_socio_cultural ///
disciplina_libras disciplina_pedagogicas disciplina_outras especializacao mestrado doutorado pos_nenhum ///
formacao_especif_creche formacao_especif_pre_escola formacao_especif_anos_iniciais formacao_especif_anos_finais ///
formacao_especif_ens_medio formacao_especif_eja formacao_especif_ed_especial formacao_especif_ed_indigena ///
formacao_especif_campo formacao_especif_ambiental formacao_especif_dir_humanos formacao_especif_div_sexual ///
formacao_especif_dir_adolesc formacao_especif_afro formacao_especif_outros formacao_especif_nenhum ///
tipo_docente tipo_contratacao id_turma tipo_turma mediacao_didatico_pedago especial_exclusiva regular eja profissionalizante ///
etapa_ensino id_curso_educ_profissional id_escola id_uf id_municipio rede localizacao categoria_escola_privada ///
conveniada_pp convenio_poder_publico mant_escola_privada_emp mant_escola_privada_ong mant_escola_privada_sind ///
mant_escola_privada_sist_s mant_escola_privada_s_fins regulamentacao localizacao_diferenciada educacao_indigena


foreach estado in TO {
	preserve
keep if sigla_uf == "`estado'"
drop ano sigla_uf id_uf
export delimited "C:/Users/Matheus/Desktop/particionadastata/ano=`t'/sigla_uf=`estado'/microdados_`estado'.csv" , replace
	restore
	
	}
}



*nordestes

foreach t in  2015 2016 2017 2018 2019 2020{

import delimited C:\Users\Matheus\Desktop\docente\a`t'\DOCENTES_NORDESTE.CSV, delimiter("|") encoding(utf8) clear

rename *, upper

if `t' == 2015{
rename IN_POSSUI_NEC_ESPECIAL IN_NECESSIDADE_ESPECIAL
}

if `t' == 2018{
rename ID_DOCENTE CO_PESSOA_FISICA
}

if `t' > 2018{
gen NU_DIA = ""
gen IN_COM_PEDAGOGICA_1 = ""
gen IN_COM_PEDAGOGICA_2 = ""
gen IN_COM_PEDAGOGICA_3 = ""
gen NU_ANO_INICIO_1 = ""
gen NU_ANO_INICIO_2 = ""
gen NU_ANO_INICIO_3 = ""
gen IN_DISC_ATENDIMENTO_ESPECIAIS = ""
gen  IN_DISC_DIVER_SOCIO_CULTURAL = ""
gen TP_TIPO_TURMA  = ""
rename ID_DOCENTE CO_PESSOA_FISICA

}

keep NU_ANO_CENSO CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE ///
NU_IDADE_REFERENCIA TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC CO_MUNICIPIO_NASC ///
CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL IN_NECESSIDADE_ESPECIAL ///
IN_CEGUEIRA IN_BAIXA_VISAO IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
TP_ESCOLARIDADE TP_SITUACAO_CURSO_1 CO_AREA_CURSO_1 CO_CURSO_1 IN_LICENCIATURA_1 IN_COM_PEDAGOGICA_1 ///
NU_ANO_INICIO_1 NU_ANO_CONCLUSAO_1 TP_TIPO_IES_1 CO_IES_1 TP_SITUACAO_CURSO_2 CO_AREA_CURSO_2 CO_CURSO_2 ///
IN_LICENCIATURA_2 IN_COM_PEDAGOGICA_2 NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 TP_TIPO_IES_2 CO_IES_2 ///
TP_SITUACAO_CURSO_3 CO_AREA_CURSO_3 CO_CURSO_3 IN_LICENCIATURA_3 IN_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 /// 
NU_ANO_CONCLUSAO_3 TP_TIPO_IES_3 CO_IES_3 IN_DISC_QUIMICA IN_DISC_FISICA IN_DISC_MATEMATICA ///
IN_DISC_BIOLOGIA IN_DISC_CIENCIAS IN_DISC_LINGUA_PORTUGUESA IN_DISC_LINGUA_INGLES ///
IN_DISC_LINGUA_ESPANHOL IN_DISC_LINGUA_FRANCES IN_DISC_LINGUA_OUTRA IN_DISC_LINGUA_INDIGENA IN_DISC_ARTES ///
IN_DISC_EDUCACAO_FISICA IN_DISC_HISTORIA IN_DISC_GEOGRAFIA ///
IN_DISC_FILOSOFIA IN_DISC_ENSINO_RELIGIOSO IN_DISC_ESTUDOS_SOCIAIS ///
IN_DISC_SOCIOLOGIA IN_DISC_INFORMATICA_COMPUTACAO IN_DISC_PROFISSIONALIZANTE ///
IN_DISC_ATENDIMENTO_ESPECIAIS IN_DISC_DIVER_SOCIO_CULTURAL IN_DISC_LIBRAS ///
IN_DISC_PEDAGOGICAS IN_DISC_OUTRAS IN_ESPECIALIZACAO IN_MESTRADO IN_DOUTORADO ///
IN_POS_NENHUM IN_ESPECIFICO_CRECHE ///
IN_ESPECIFICO_PRE_ESCOLA IN_ESPECIFICO_ANOS_INICIAIS IN_ESPECIFICO_ANOS_FINAIS IN_ESPECIFICO_ENS_MEDIO ///
IN_ESPECIFICO_EJA IN_ESPECIFICO_ED_ESPECIAL IN_ESPECIFICO_ED_INDIGENA IN_ESPECIFICO_CAMPO ///
IN_ESPECIFICO_AMBIENTAL IN_ESPECIFICO_DIR_HUMANOS IN_ESPECIFICO_DIV_SEXUAL IN_ESPECIFICO_DIR_ADOLESC IN_ESPECIFICO_AFRO ///
IN_ESPECIFICO_OUTROS IN_ESPECIFICO_NENHUM TP_TIPO_DOCENTE TP_TIPO_CONTRATACAO ID_TURMA TP_TIPO_TURMA /// 
TP_MEDIACAO_DIDATICO_PEDAGO IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE TP_ETAPA_ENSINO CO_CURSO_EDUC_PROFISSIONAL ///
CO_ENTIDADE CO_UF CO_MUNICIPIO TP_DEPENDENCIA TP_LOCALIZACAO TP_CATEGORIA_ESCOLA_PRIVADA ///
IN_CONVENIADA_PP TP_CONVENIO_PODER_PUBLICO IN_MANT_ESCOLA_PRIVADA_EMP IN_MANT_ESCOLA_PRIVADA_ONG IN_MANT_ESCOLA_PRIVADA_SIND ///
IN_MANT_ESCOLA_PRIVADA_SIST_S IN_MANT_ESCOLA_PRIVADA_S_FINS TP_REGULAMENTACAO TP_LOCALIZACAO_DIFERENCIADA IN_EDUCACAO_INDIGENA






*renomeando as variaveis

rename NU_ANO_CENSO ano 
rename CO_PESSOA_FISICA id_docente 
rename NU_MES mes_nascimento_docente 
rename NU_ANO ano_nascimento_docente 
rename NU_DIA dia_nascimento_docente 
rename NU_IDADE idade 
rename NU_IDADE_REFERENCIA idade_referencia 
rename TP_SEXO sexo 
rename TP_COR_RACA cor_raca 
rename TP_NACIONALIDADE nacionalidade 
rename CO_PAIS_ORIGEM id_pais_origem 
rename CO_UF_NASC id_uf_nascimento 
rename CO_MUNICIPIO_NASC id_municipio_nascimento 
rename CO_UF_END id_uf_endereco 
rename CO_MUNICIPIO_END id_municipio_endereco 
rename TP_ZONA_RESIDENCIAL zona_residencial 



rename (IN_NECESSIDADE_ESPECIAL ///
IN_CEGUEIRA IN_BAIXA_VISAO IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
TP_ESCOLARIDADE TP_SITUACAO_CURSO_1 CO_AREA_CURSO_1 CO_CURSO_1 IN_LICENCIATURA_1 IN_COM_PEDAGOGICA_1 ///
NU_ANO_INICIO_1 NU_ANO_CONCLUSAO_1 TP_TIPO_IES_1 CO_IES_1 TP_SITUACAO_CURSO_2 CO_AREA_CURSO_2 CO_CURSO_2 ///
IN_LICENCIATURA_2 IN_COM_PEDAGOGICA_2 NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 TP_TIPO_IES_2 CO_IES_2 ///
TP_SITUACAO_CURSO_3 CO_AREA_CURSO_3 CO_CURSO_3 IN_LICENCIATURA_3 IN_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 /// 
NU_ANO_CONCLUSAO_3 TP_TIPO_IES_3 CO_IES_3 IN_DISC_QUIMICA IN_DISC_FISICA IN_DISC_MATEMATICA ///
IN_DISC_BIOLOGIA IN_DISC_CIENCIAS IN_DISC_LINGUA_PORTUGUESA IN_DISC_LINGUA_INGLES ///
IN_DISC_LINGUA_ESPANHOL IN_DISC_LINGUA_FRANCES IN_DISC_LINGUA_OUTRA IN_DISC_LINGUA_INDIGENA IN_DISC_ARTES ///
IN_DISC_EDUCACAO_FISICA IN_DISC_HISTORIA IN_DISC_GEOGRAFIA ///
IN_DISC_FILOSOFIA IN_DISC_ENSINO_RELIGIOSO IN_DISC_ESTUDOS_SOCIAIS ///
IN_DISC_SOCIOLOGIA IN_DISC_INFORMATICA_COMPUTACAO IN_DISC_PROFISSIONALIZANTE ///
IN_DISC_ATENDIMENTO_ESPECIAIS IN_DISC_DIVER_SOCIO_CULTURAL IN_DISC_LIBRAS ///
IN_DISC_PEDAGOGICAS IN_DISC_OUTRAS IN_ESPECIALIZACAO IN_MESTRADO IN_DOUTORADO ///
IN_POS_NENHUM IN_ESPECIFICO_CRECHE ///
IN_ESPECIFICO_PRE_ESCOLA IN_ESPECIFICO_ANOS_INICIAIS IN_ESPECIFICO_ANOS_FINAIS IN_ESPECIFICO_ENS_MEDIO ///
IN_ESPECIFICO_EJA IN_ESPECIFICO_ED_ESPECIAL IN_ESPECIFICO_ED_INDIGENA IN_ESPECIFICO_CAMPO ///
IN_ESPECIFICO_AMBIENTAL IN_ESPECIFICO_DIR_HUMANOS IN_ESPECIFICO_DIV_SEXUAL IN_ESPECIFICO_DIR_ADOLESC IN_ESPECIFICO_AFRO ///
IN_ESPECIFICO_OUTROS IN_ESPECIFICO_NENHUM TP_TIPO_DOCENTE TP_TIPO_CONTRATACAO ID_TURMA TP_TIPO_TURMA /// 
TP_MEDIACAO_DIDATICO_PEDAGO IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE TP_ETAPA_ENSINO CO_CURSO_EDUC_PROFISSIONAL ///
CO_ENTIDADE CO_UF CO_MUNICIPIO TP_DEPENDENCIA TP_LOCALIZACAO TP_CATEGORIA_ESCOLA_PRIVADA ///
IN_CONVENIADA_PP TP_CONVENIO_PODER_PUBLICO IN_MANT_ESCOLA_PRIVADA_EMP IN_MANT_ESCOLA_PRIVADA_ONG IN_MANT_ESCOLA_PRIVADA_SIND ///
IN_MANT_ESCOLA_PRIVADA_SIST_S IN_MANT_ESCOLA_PRIVADA_S_FINS TP_REGULAMENTACAO ///
TP_LOCALIZACAO_DIFERENCIADA IN_EDUCACAO_INDIGENA) (necessidade_especial ///
cegueira baixa_visao surdez deficiencia_auditiva surdocegueira deficiencia_fisica deficiencia_intelectual deficiencia_multipla ///
escolaridade situacao_curso_1 id_area_curso_1 id_curso_1 licenciatura_1 formacao_pedagogica_comp_1 ano_inicio_curso_superior_1 ///
ano_conclusao_curso_superior_1 tipo_ies_1 id_ies_1 situacao_curso_2 ///
id_area_curso_2 id_curso_2 licenciatura_2 formacao_pedagogica_comp_2 ano_inicio_curso_superior_2 ///
ano_conclusao_curso_superior_2 tipo_ies_2 id_ies_2 situacao_curso_3 id_area_curso_3 id_curso_3 licenciatura_3 formacao_pedagogica_comp_3 ///
ano_inicio_curso_superior_3 ano_conclusao_curso_superior_3 tipo_ies_3 id_ies_3 disciplina_quimica disciplina_fisica disciplina_matematica ///
disciplina_biologia disciplina_ciencias disciplina_lingua_portuguesa disciplina_lingua_ingles disciplina_lingua_espanhol disciplina_lingua_frances ///
disciplina_lingua_outra disciplina_lingua_indigena disciplina_artes disciplina_educacao_fisica disciplina_historia disciplina_geografia ///
disciplina_filosofia disciplina_ensino_religioso disciplina_estudos_sociais disciplina_sociologia disciplina_informatica_comp ///
disciplina_profissionalizante disciplina_atend_especiais disciplina_diver_socio_cultural ///
disciplina_libras disciplina_pedagogicas disciplina_outras especializacao mestrado doutorado pos_nenhum ///
formacao_especif_creche formacao_especif_pre_escola formacao_especif_anos_iniciais formacao_especif_anos_finais ///
formacao_especif_ens_medio formacao_especif_eja formacao_especif_ed_especial formacao_especif_ed_indigena ///
formacao_especif_campo formacao_especif_ambiental formacao_especif_dir_humanos formacao_especif_div_sexual ///
formacao_especif_dir_adolesc formacao_especif_afro formacao_especif_outros formacao_especif_nenhum ///
tipo_docente tipo_contratacao id_turma tipo_turma mediacao_didatico_pedago especial_exclusiva regular eja profissionalizante ///
etapa_ensino id_curso_educ_profissional id_escola id_uf id_municipio rede localizacao categoria_escola_privada ///
conveniada_pp convenio_poder_publico mant_escola_privada_emp mant_escola_privada_ong mant_escola_privada_sind ///
mant_escola_privada_sist_s mant_escola_privada_s_fins regulamentacao localizacao_diferenciada educacao_indigena)



tostring id_uf, replace
gen sigla_uf = "MA" if id_uf == "21"
replace sigla_uf = "PI" if id_uf == "22"
replace sigla_uf = "CE" if id_uf == "23"
replace sigla_uf = "RN" if id_uf == "24"
replace sigla_uf = "PB" if id_uf == "25"
replace sigla_uf = "PE" if id_uf == "26"
replace sigla_uf = "AL" if id_uf == "27"
replace sigla_uf = "SE" if id_uf == "28"
replace sigla_uf = "BA" if id_uf == "29"

tostring rede, replace
replace rede = "federal" if rede == "1"
replace rede = "estadual" if rede == "2" 
replace rede = "municipal" if rede == "3"
replace rede = "privada" if rede == "4"


order ano id_docente mes_nascimento_docente ano_nascimento_docente /// 
dia_nascimento_docente idade idade_referencia sexo cor_raca nacionalidade ///
id_pais_origem id_uf_nascimento id_municipio_nascimento id_uf_endereco id_municipio_endereco zona_residencial necessidade_especial ///
cegueira baixa_visao surdez deficiencia_auditiva surdocegueira deficiencia_fisica deficiencia_intelectual deficiencia_multipla ///
escolaridade situacao_curso_1 id_area_curso_1 id_curso_1 licenciatura_1 formacao_pedagogica_comp_1 ano_inicio_curso_superior_1 ///
ano_conclusao_curso_superior_1 tipo_ies_1 id_ies_1 situacao_curso_2 ///
id_area_curso_2 id_curso_2 licenciatura_2 formacao_pedagogica_comp_2 ano_inicio_curso_superior_2 ///
ano_conclusao_curso_superior_2 tipo_ies_2 id_ies_2 situacao_curso_3 id_area_curso_3 id_curso_3 licenciatura_3 formacao_pedagogica_comp_3 ///
ano_inicio_curso_superior_3 ano_conclusao_curso_superior_3 tipo_ies_3 id_ies_3 disciplina_quimica disciplina_fisica disciplina_matematica ///
disciplina_biologia disciplina_ciencias disciplina_lingua_portuguesa disciplina_lingua_ingles disciplina_lingua_espanhol disciplina_lingua_frances ///
disciplina_lingua_outra disciplina_lingua_indigena disciplina_artes disciplina_educacao_fisica disciplina_historia disciplina_geografia ///
disciplina_filosofia disciplina_ensino_religioso disciplina_estudos_sociais disciplina_sociologia disciplina_informatica_comp ///
disciplina_profissionalizante disciplina_atend_especiais disciplina_diver_socio_cultural ///
disciplina_libras disciplina_pedagogicas disciplina_outras especializacao mestrado doutorado pos_nenhum ///
formacao_especif_creche formacao_especif_pre_escola formacao_especif_anos_iniciais formacao_especif_anos_finais ///
formacao_especif_ens_medio formacao_especif_eja formacao_especif_ed_especial formacao_especif_ed_indigena ///
formacao_especif_campo formacao_especif_ambiental formacao_especif_dir_humanos formacao_especif_div_sexual ///
formacao_especif_dir_adolesc formacao_especif_afro formacao_especif_outros formacao_especif_nenhum ///
tipo_docente tipo_contratacao id_turma tipo_turma mediacao_didatico_pedago especial_exclusiva regular eja profissionalizante ///
etapa_ensino id_curso_educ_profissional id_escola id_uf id_municipio rede localizacao categoria_escola_privada ///
conveniada_pp convenio_poder_publico mant_escola_privada_emp mant_escola_privada_ong mant_escola_privada_sind ///
mant_escola_privada_sist_s mant_escola_privada_s_fins regulamentacao localizacao_diferenciada educacao_indigena


foreach estado in MA PI BA CE RN PB PE AL SE {
	preserve
keep if sigla_uf == "`estado'"
drop ano sigla_uf id_uf
export delimited "C:/Users/Matheus/Desktop/particionadastata/ano=`t'/sigla_uf=`estado'/microdados_`estado'.csv" , replace
	restore
	
	}
}

*SUDESTE

foreach t in  2015 2016 2017 2018 2019 2020{

import delimited C:\Users\Matheus\Desktop\docente\a`t'\DOCENTES_SUDESTE.CSV, delimiter("|") encoding(utf8) clear

rename *, upper

if `t' == 2015{
rename IN_POSSUI_NEC_ESPECIAL IN_NECESSIDADE_ESPECIAL
}

if `t' == 2018{
rename ID_DOCENTE CO_PESSOA_FISICA
}

if `t' > 2018{
gen NU_DIA = ""
gen IN_COM_PEDAGOGICA_1 = ""
gen IN_COM_PEDAGOGICA_2 = ""
gen IN_COM_PEDAGOGICA_3 = ""
gen NU_ANO_INICIO_1 = ""
gen NU_ANO_INICIO_2 = ""
gen NU_ANO_INICIO_3 = ""
gen IN_DISC_ATENDIMENTO_ESPECIAIS = ""
gen  IN_DISC_DIVER_SOCIO_CULTURAL = ""
gen TP_TIPO_TURMA  = ""
rename ID_DOCENTE CO_PESSOA_FISICA

}

keep NU_ANO_CENSO CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE ///
NU_IDADE_REFERENCIA TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC CO_MUNICIPIO_NASC ///
CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL IN_NECESSIDADE_ESPECIAL ///
IN_CEGUEIRA IN_BAIXA_VISAO IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
TP_ESCOLARIDADE TP_SITUACAO_CURSO_1 CO_AREA_CURSO_1 CO_CURSO_1 IN_LICENCIATURA_1 IN_COM_PEDAGOGICA_1 ///
NU_ANO_INICIO_1 NU_ANO_CONCLUSAO_1 TP_TIPO_IES_1 CO_IES_1 TP_SITUACAO_CURSO_2 CO_AREA_CURSO_2 CO_CURSO_2 ///
IN_LICENCIATURA_2 IN_COM_PEDAGOGICA_2 NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 TP_TIPO_IES_2 CO_IES_2 ///
TP_SITUACAO_CURSO_3 CO_AREA_CURSO_3 CO_CURSO_3 IN_LICENCIATURA_3 IN_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 /// 
NU_ANO_CONCLUSAO_3 TP_TIPO_IES_3 CO_IES_3 IN_DISC_QUIMICA IN_DISC_FISICA IN_DISC_MATEMATICA ///
IN_DISC_BIOLOGIA IN_DISC_CIENCIAS IN_DISC_LINGUA_PORTUGUESA IN_DISC_LINGUA_INGLES ///
IN_DISC_LINGUA_ESPANHOL IN_DISC_LINGUA_FRANCES IN_DISC_LINGUA_OUTRA IN_DISC_LINGUA_INDIGENA IN_DISC_ARTES ///
IN_DISC_EDUCACAO_FISICA IN_DISC_HISTORIA IN_DISC_GEOGRAFIA ///
IN_DISC_FILOSOFIA IN_DISC_ENSINO_RELIGIOSO IN_DISC_ESTUDOS_SOCIAIS ///
IN_DISC_SOCIOLOGIA IN_DISC_INFORMATICA_COMPUTACAO IN_DISC_PROFISSIONALIZANTE ///
IN_DISC_ATENDIMENTO_ESPECIAIS IN_DISC_DIVER_SOCIO_CULTURAL IN_DISC_LIBRAS ///
IN_DISC_PEDAGOGICAS IN_DISC_OUTRAS IN_ESPECIALIZACAO IN_MESTRADO IN_DOUTORADO ///
IN_POS_NENHUM IN_ESPECIFICO_CRECHE ///
IN_ESPECIFICO_PRE_ESCOLA IN_ESPECIFICO_ANOS_INICIAIS IN_ESPECIFICO_ANOS_FINAIS IN_ESPECIFICO_ENS_MEDIO ///
IN_ESPECIFICO_EJA IN_ESPECIFICO_ED_ESPECIAL IN_ESPECIFICO_ED_INDIGENA IN_ESPECIFICO_CAMPO ///
IN_ESPECIFICO_AMBIENTAL IN_ESPECIFICO_DIR_HUMANOS IN_ESPECIFICO_DIV_SEXUAL IN_ESPECIFICO_DIR_ADOLESC IN_ESPECIFICO_AFRO ///
IN_ESPECIFICO_OUTROS IN_ESPECIFICO_NENHUM TP_TIPO_DOCENTE TP_TIPO_CONTRATACAO ID_TURMA TP_TIPO_TURMA /// 
TP_MEDIACAO_DIDATICO_PEDAGO IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE TP_ETAPA_ENSINO CO_CURSO_EDUC_PROFISSIONAL ///
CO_ENTIDADE CO_UF CO_MUNICIPIO TP_DEPENDENCIA TP_LOCALIZACAO TP_CATEGORIA_ESCOLA_PRIVADA ///
IN_CONVENIADA_PP TP_CONVENIO_PODER_PUBLICO IN_MANT_ESCOLA_PRIVADA_EMP IN_MANT_ESCOLA_PRIVADA_ONG IN_MANT_ESCOLA_PRIVADA_SIND ///
IN_MANT_ESCOLA_PRIVADA_SIST_S IN_MANT_ESCOLA_PRIVADA_S_FINS TP_REGULAMENTACAO TP_LOCALIZACAO_DIFERENCIADA IN_EDUCACAO_INDIGENA






*renomeando as variaveis

rename NU_ANO_CENSO ano 
rename CO_PESSOA_FISICA id_docente 
rename NU_MES mes_nascimento_docente 
rename NU_ANO ano_nascimento_docente 
rename NU_DIA dia_nascimento_docente 
rename NU_IDADE idade 
rename NU_IDADE_REFERENCIA idade_referencia 
rename TP_SEXO sexo 
rename TP_COR_RACA cor_raca 
rename TP_NACIONALIDADE nacionalidade 
rename CO_PAIS_ORIGEM id_pais_origem 
rename CO_UF_NASC id_uf_nascimento 
rename CO_MUNICIPIO_NASC id_municipio_nascimento 
rename CO_UF_END id_uf_endereco 
rename CO_MUNICIPIO_END id_municipio_endereco 
rename TP_ZONA_RESIDENCIAL zona_residencial 



rename (IN_NECESSIDADE_ESPECIAL ///
IN_CEGUEIRA IN_BAIXA_VISAO IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
TP_ESCOLARIDADE TP_SITUACAO_CURSO_1 CO_AREA_CURSO_1 CO_CURSO_1 IN_LICENCIATURA_1 IN_COM_PEDAGOGICA_1 ///
NU_ANO_INICIO_1 NU_ANO_CONCLUSAO_1 TP_TIPO_IES_1 CO_IES_1 TP_SITUACAO_CURSO_2 CO_AREA_CURSO_2 CO_CURSO_2 ///
IN_LICENCIATURA_2 IN_COM_PEDAGOGICA_2 NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 TP_TIPO_IES_2 CO_IES_2 ///
TP_SITUACAO_CURSO_3 CO_AREA_CURSO_3 CO_CURSO_3 IN_LICENCIATURA_3 IN_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 /// 
NU_ANO_CONCLUSAO_3 TP_TIPO_IES_3 CO_IES_3 IN_DISC_QUIMICA IN_DISC_FISICA IN_DISC_MATEMATICA ///
IN_DISC_BIOLOGIA IN_DISC_CIENCIAS IN_DISC_LINGUA_PORTUGUESA IN_DISC_LINGUA_INGLES ///
IN_DISC_LINGUA_ESPANHOL IN_DISC_LINGUA_FRANCES IN_DISC_LINGUA_OUTRA IN_DISC_LINGUA_INDIGENA IN_DISC_ARTES ///
IN_DISC_EDUCACAO_FISICA IN_DISC_HISTORIA IN_DISC_GEOGRAFIA ///
IN_DISC_FILOSOFIA IN_DISC_ENSINO_RELIGIOSO IN_DISC_ESTUDOS_SOCIAIS ///
IN_DISC_SOCIOLOGIA IN_DISC_INFORMATICA_COMPUTACAO IN_DISC_PROFISSIONALIZANTE ///
IN_DISC_ATENDIMENTO_ESPECIAIS IN_DISC_DIVER_SOCIO_CULTURAL IN_DISC_LIBRAS ///
IN_DISC_PEDAGOGICAS IN_DISC_OUTRAS IN_ESPECIALIZACAO IN_MESTRADO IN_DOUTORADO ///
IN_POS_NENHUM IN_ESPECIFICO_CRECHE ///
IN_ESPECIFICO_PRE_ESCOLA IN_ESPECIFICO_ANOS_INICIAIS IN_ESPECIFICO_ANOS_FINAIS IN_ESPECIFICO_ENS_MEDIO ///
IN_ESPECIFICO_EJA IN_ESPECIFICO_ED_ESPECIAL IN_ESPECIFICO_ED_INDIGENA IN_ESPECIFICO_CAMPO ///
IN_ESPECIFICO_AMBIENTAL IN_ESPECIFICO_DIR_HUMANOS IN_ESPECIFICO_DIV_SEXUAL IN_ESPECIFICO_DIR_ADOLESC IN_ESPECIFICO_AFRO ///
IN_ESPECIFICO_OUTROS IN_ESPECIFICO_NENHUM TP_TIPO_DOCENTE TP_TIPO_CONTRATACAO ID_TURMA TP_TIPO_TURMA /// 
TP_MEDIACAO_DIDATICO_PEDAGO IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE TP_ETAPA_ENSINO CO_CURSO_EDUC_PROFISSIONAL ///
CO_ENTIDADE CO_UF CO_MUNICIPIO TP_DEPENDENCIA TP_LOCALIZACAO TP_CATEGORIA_ESCOLA_PRIVADA ///
IN_CONVENIADA_PP TP_CONVENIO_PODER_PUBLICO IN_MANT_ESCOLA_PRIVADA_EMP IN_MANT_ESCOLA_PRIVADA_ONG IN_MANT_ESCOLA_PRIVADA_SIND ///
IN_MANT_ESCOLA_PRIVADA_SIST_S IN_MANT_ESCOLA_PRIVADA_S_FINS TP_REGULAMENTACAO ///
TP_LOCALIZACAO_DIFERENCIADA IN_EDUCACAO_INDIGENA) (necessidade_especial ///
cegueira baixa_visao surdez deficiencia_auditiva surdocegueira deficiencia_fisica deficiencia_intelectual deficiencia_multipla ///
escolaridade situacao_curso_1 id_area_curso_1 id_curso_1 licenciatura_1 formacao_pedagogica_comp_1 ano_inicio_curso_superior_1 ///
ano_conclusao_curso_superior_1 tipo_ies_1 id_ies_1 situacao_curso_2 ///
id_area_curso_2 id_curso_2 licenciatura_2 formacao_pedagogica_comp_2 ano_inicio_curso_superior_2 ///
ano_conclusao_curso_superior_2 tipo_ies_2 id_ies_2 situacao_curso_3 id_area_curso_3 id_curso_3 licenciatura_3 formacao_pedagogica_comp_3 ///
ano_inicio_curso_superior_3 ano_conclusao_curso_superior_3 tipo_ies_3 id_ies_3 disciplina_quimica disciplina_fisica disciplina_matematica ///
disciplina_biologia disciplina_ciencias disciplina_lingua_portuguesa disciplina_lingua_ingles disciplina_lingua_espanhol disciplina_lingua_frances ///
disciplina_lingua_outra disciplina_lingua_indigena disciplina_artes disciplina_educacao_fisica disciplina_historia disciplina_geografia ///
disciplina_filosofia disciplina_ensino_religioso disciplina_estudos_sociais disciplina_sociologia disciplina_informatica_comp ///
disciplina_profissionalizante disciplina_atend_especiais disciplina_diver_socio_cultural ///
disciplina_libras disciplina_pedagogicas disciplina_outras especializacao mestrado doutorado pos_nenhum ///
formacao_especif_creche formacao_especif_pre_escola formacao_especif_anos_iniciais formacao_especif_anos_finais ///
formacao_especif_ens_medio formacao_especif_eja formacao_especif_ed_especial formacao_especif_ed_indigena ///
formacao_especif_campo formacao_especif_ambiental formacao_especif_dir_humanos formacao_especif_div_sexual ///
formacao_especif_dir_adolesc formacao_especif_afro formacao_especif_outros formacao_especif_nenhum ///
tipo_docente tipo_contratacao id_turma tipo_turma mediacao_didatico_pedago especial_exclusiva regular eja profissionalizante ///
etapa_ensino id_curso_educ_profissional id_escola id_uf id_municipio rede localizacao categoria_escola_privada ///
conveniada_pp convenio_poder_publico mant_escola_privada_emp mant_escola_privada_ong mant_escola_privada_sind ///
mant_escola_privada_sist_s mant_escola_privada_s_fins regulamentacao localizacao_diferenciada educacao_indigena)

tostring id_uf, replace
gen sigla_uf = "MG" if id_uf == "31"
replace sigla_uf = "SP" if id_uf == "35"
replace sigla_uf = "ES" if id_uf == "32"
replace sigla_uf = "RJ" if id_uf == "33"

tostring rede, replace
replace rede = "federal" if rede == "1"
replace rede = "estadual" if rede == "2" 
replace rede = "municipal" if rede == "3"
replace rede = "privada" if rede == "4"


order ano id_docente mes_nascimento_docente ano_nascimento_docente /// 
dia_nascimento_docente idade idade_referencia sexo cor_raca nacionalidade ///
id_pais_origem id_uf_nascimento id_municipio_nascimento id_uf_endereco id_municipio_endereco zona_residencial necessidade_especial ///
cegueira baixa_visao surdez deficiencia_auditiva surdocegueira deficiencia_fisica deficiencia_intelectual deficiencia_multipla ///
escolaridade situacao_curso_1 id_area_curso_1 id_curso_1 licenciatura_1 formacao_pedagogica_comp_1 ano_inicio_curso_superior_1 ///
ano_conclusao_curso_superior_1 tipo_ies_1 id_ies_1 situacao_curso_2 ///
id_area_curso_2 id_curso_2 licenciatura_2 formacao_pedagogica_comp_2 ano_inicio_curso_superior_2 ///
ano_conclusao_curso_superior_2 tipo_ies_2 id_ies_2 situacao_curso_3 id_area_curso_3 id_curso_3 licenciatura_3 formacao_pedagogica_comp_3 ///
ano_inicio_curso_superior_3 ano_conclusao_curso_superior_3 tipo_ies_3 id_ies_3 disciplina_quimica disciplina_fisica disciplina_matematica ///
disciplina_biologia disciplina_ciencias disciplina_lingua_portuguesa disciplina_lingua_ingles disciplina_lingua_espanhol disciplina_lingua_frances ///
disciplina_lingua_outra disciplina_lingua_indigena disciplina_artes disciplina_educacao_fisica disciplina_historia disciplina_geografia ///
disciplina_filosofia disciplina_ensino_religioso disciplina_estudos_sociais disciplina_sociologia disciplina_informatica_comp ///
disciplina_profissionalizante disciplina_atend_especiais disciplina_diver_socio_cultural ///
disciplina_libras disciplina_pedagogicas disciplina_outras especializacao mestrado doutorado pos_nenhum ///
formacao_especif_creche formacao_especif_pre_escola formacao_especif_anos_iniciais formacao_especif_anos_finais ///
formacao_especif_ens_medio formacao_especif_eja formacao_especif_ed_especial formacao_especif_ed_indigena ///
formacao_especif_campo formacao_especif_ambiental formacao_especif_dir_humanos formacao_especif_div_sexual ///
formacao_especif_dir_adolesc formacao_especif_afro formacao_especif_outros formacao_especif_nenhum ///
tipo_docente tipo_contratacao id_turma tipo_turma mediacao_didatico_pedago especial_exclusiva regular eja profissionalizante ///
etapa_ensino id_curso_educ_profissional id_escola id_uf id_municipio rede localizacao categoria_escola_privada ///
conveniada_pp convenio_poder_publico mant_escola_privada_emp mant_escola_privada_ong mant_escola_privada_sind ///
mant_escola_privada_sist_s mant_escola_privada_s_fins regulamentacao localizacao_diferenciada educacao_indigena


foreach estado in MG SP ES RJ {
	preserve
keep if sigla_uf == "`estado'"
drop ano sigla_uf id_uf
export delimited "C:/Users/Matheus/Desktop/particionadastata/ano=`t'/sigla_uf=`estado'/microdados_`estado'.csv" , replace
	restore
	
	}
}


*SUL


foreach t in  2015 2016 2017 2018 2019 2020{

import delimited C:\Users\Matheus\Desktop\docente\a`t'\DOCENTES_SUL.CSV, delimiter("|") encoding(utf8) clear

rename *, upper

if `t' == 2015{
rename IN_POSSUI_NEC_ESPECIAL IN_NECESSIDADE_ESPECIAL
}

if `t' == 2018{
rename ID_DOCENTE CO_PESSOA_FISICA
}

if `t' > 2018{
gen NU_DIA = ""
gen IN_COM_PEDAGOGICA_1 = ""
gen IN_COM_PEDAGOGICA_2 = ""
gen IN_COM_PEDAGOGICA_3 = ""
gen NU_ANO_INICIO_1 = ""
gen NU_ANO_INICIO_2 = ""
gen NU_ANO_INICIO_3 = ""
gen IN_DISC_ATENDIMENTO_ESPECIAIS = ""
gen  IN_DISC_DIVER_SOCIO_CULTURAL = ""
gen TP_TIPO_TURMA  = ""
rename ID_DOCENTE CO_PESSOA_FISICA

}

keep NU_ANO_CENSO CO_PESSOA_FISICA NU_DIA NU_MES NU_ANO NU_IDADE ///
NU_IDADE_REFERENCIA TP_SEXO TP_COR_RACA TP_NACIONALIDADE CO_PAIS_ORIGEM CO_UF_NASC CO_MUNICIPIO_NASC ///
CO_UF_END CO_MUNICIPIO_END TP_ZONA_RESIDENCIAL IN_NECESSIDADE_ESPECIAL ///
IN_CEGUEIRA IN_BAIXA_VISAO IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
TP_ESCOLARIDADE TP_SITUACAO_CURSO_1 CO_AREA_CURSO_1 CO_CURSO_1 IN_LICENCIATURA_1 IN_COM_PEDAGOGICA_1 ///
NU_ANO_INICIO_1 NU_ANO_CONCLUSAO_1 TP_TIPO_IES_1 CO_IES_1 TP_SITUACAO_CURSO_2 CO_AREA_CURSO_2 CO_CURSO_2 ///
IN_LICENCIATURA_2 IN_COM_PEDAGOGICA_2 NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 TP_TIPO_IES_2 CO_IES_2 ///
TP_SITUACAO_CURSO_3 CO_AREA_CURSO_3 CO_CURSO_3 IN_LICENCIATURA_3 IN_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 /// 
NU_ANO_CONCLUSAO_3 TP_TIPO_IES_3 CO_IES_3 IN_DISC_QUIMICA IN_DISC_FISICA IN_DISC_MATEMATICA ///
IN_DISC_BIOLOGIA IN_DISC_CIENCIAS IN_DISC_LINGUA_PORTUGUESA IN_DISC_LINGUA_INGLES ///
IN_DISC_LINGUA_ESPANHOL IN_DISC_LINGUA_FRANCES IN_DISC_LINGUA_OUTRA IN_DISC_LINGUA_INDIGENA IN_DISC_ARTES ///
IN_DISC_EDUCACAO_FISICA IN_DISC_HISTORIA IN_DISC_GEOGRAFIA ///
IN_DISC_FILOSOFIA IN_DISC_ENSINO_RELIGIOSO IN_DISC_ESTUDOS_SOCIAIS ///
IN_DISC_SOCIOLOGIA IN_DISC_INFORMATICA_COMPUTACAO IN_DISC_PROFISSIONALIZANTE ///
IN_DISC_ATENDIMENTO_ESPECIAIS IN_DISC_DIVER_SOCIO_CULTURAL IN_DISC_LIBRAS ///
IN_DISC_PEDAGOGICAS IN_DISC_OUTRAS IN_ESPECIALIZACAO IN_MESTRADO IN_DOUTORADO ///
IN_POS_NENHUM IN_ESPECIFICO_CRECHE ///
IN_ESPECIFICO_PRE_ESCOLA IN_ESPECIFICO_ANOS_INICIAIS IN_ESPECIFICO_ANOS_FINAIS IN_ESPECIFICO_ENS_MEDIO ///
IN_ESPECIFICO_EJA IN_ESPECIFICO_ED_ESPECIAL IN_ESPECIFICO_ED_INDIGENA IN_ESPECIFICO_CAMPO ///
IN_ESPECIFICO_AMBIENTAL IN_ESPECIFICO_DIR_HUMANOS IN_ESPECIFICO_DIV_SEXUAL IN_ESPECIFICO_DIR_ADOLESC IN_ESPECIFICO_AFRO ///
IN_ESPECIFICO_OUTROS IN_ESPECIFICO_NENHUM TP_TIPO_DOCENTE TP_TIPO_CONTRATACAO ID_TURMA TP_TIPO_TURMA /// 
TP_MEDIACAO_DIDATICO_PEDAGO IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE TP_ETAPA_ENSINO CO_CURSO_EDUC_PROFISSIONAL ///
CO_ENTIDADE CO_UF CO_MUNICIPIO TP_DEPENDENCIA TP_LOCALIZACAO TP_CATEGORIA_ESCOLA_PRIVADA ///
IN_CONVENIADA_PP TP_CONVENIO_PODER_PUBLICO IN_MANT_ESCOLA_PRIVADA_EMP IN_MANT_ESCOLA_PRIVADA_ONG IN_MANT_ESCOLA_PRIVADA_SIND ///
IN_MANT_ESCOLA_PRIVADA_SIST_S IN_MANT_ESCOLA_PRIVADA_S_FINS TP_REGULAMENTACAO TP_LOCALIZACAO_DIFERENCIADA IN_EDUCACAO_INDIGENA






*renomeando as variaveis

rename NU_ANO_CENSO ano 
rename CO_PESSOA_FISICA id_docente 
rename NU_MES mes_nascimento_docente 
rename NU_ANO ano_nascimento_docente 
rename NU_DIA dia_nascimento_docente 
rename NU_IDADE idade 
rename NU_IDADE_REFERENCIA idade_referencia 
rename TP_SEXO sexo 
rename TP_COR_RACA cor_raca 
rename TP_NACIONALIDADE nacionalidade 
rename CO_PAIS_ORIGEM id_pais_origem 
rename CO_UF_NASC id_uf_nascimento 
rename CO_MUNICIPIO_NASC id_municipio_nascimento 
rename CO_UF_END id_uf_endereco 
rename CO_MUNICIPIO_END id_municipio_endereco 
rename TP_ZONA_RESIDENCIAL zona_residencial 



rename (IN_NECESSIDADE_ESPECIAL ///
IN_CEGUEIRA IN_BAIXA_VISAO IN_SURDEZ IN_DEF_AUDITIVA IN_SURDOCEGUEIRA IN_DEF_FISICA IN_DEF_INTELECTUAL IN_DEF_MULTIPLA ///
TP_ESCOLARIDADE TP_SITUACAO_CURSO_1 CO_AREA_CURSO_1 CO_CURSO_1 IN_LICENCIATURA_1 IN_COM_PEDAGOGICA_1 ///
NU_ANO_INICIO_1 NU_ANO_CONCLUSAO_1 TP_TIPO_IES_1 CO_IES_1 TP_SITUACAO_CURSO_2 CO_AREA_CURSO_2 CO_CURSO_2 ///
IN_LICENCIATURA_2 IN_COM_PEDAGOGICA_2 NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 TP_TIPO_IES_2 CO_IES_2 ///
TP_SITUACAO_CURSO_3 CO_AREA_CURSO_3 CO_CURSO_3 IN_LICENCIATURA_3 IN_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 /// 
NU_ANO_CONCLUSAO_3 TP_TIPO_IES_3 CO_IES_3 IN_DISC_QUIMICA IN_DISC_FISICA IN_DISC_MATEMATICA ///
IN_DISC_BIOLOGIA IN_DISC_CIENCIAS IN_DISC_LINGUA_PORTUGUESA IN_DISC_LINGUA_INGLES ///
IN_DISC_LINGUA_ESPANHOL IN_DISC_LINGUA_FRANCES IN_DISC_LINGUA_OUTRA IN_DISC_LINGUA_INDIGENA IN_DISC_ARTES ///
IN_DISC_EDUCACAO_FISICA IN_DISC_HISTORIA IN_DISC_GEOGRAFIA ///
IN_DISC_FILOSOFIA IN_DISC_ENSINO_RELIGIOSO IN_DISC_ESTUDOS_SOCIAIS ///
IN_DISC_SOCIOLOGIA IN_DISC_INFORMATICA_COMPUTACAO IN_DISC_PROFISSIONALIZANTE ///
IN_DISC_ATENDIMENTO_ESPECIAIS IN_DISC_DIVER_SOCIO_CULTURAL IN_DISC_LIBRAS ///
IN_DISC_PEDAGOGICAS IN_DISC_OUTRAS IN_ESPECIALIZACAO IN_MESTRADO IN_DOUTORADO ///
IN_POS_NENHUM IN_ESPECIFICO_CRECHE ///
IN_ESPECIFICO_PRE_ESCOLA IN_ESPECIFICO_ANOS_INICIAIS IN_ESPECIFICO_ANOS_FINAIS IN_ESPECIFICO_ENS_MEDIO ///
IN_ESPECIFICO_EJA IN_ESPECIFICO_ED_ESPECIAL IN_ESPECIFICO_ED_INDIGENA IN_ESPECIFICO_CAMPO ///
IN_ESPECIFICO_AMBIENTAL IN_ESPECIFICO_DIR_HUMANOS IN_ESPECIFICO_DIV_SEXUAL IN_ESPECIFICO_DIR_ADOLESC IN_ESPECIFICO_AFRO ///
IN_ESPECIFICO_OUTROS IN_ESPECIFICO_NENHUM TP_TIPO_DOCENTE TP_TIPO_CONTRATACAO ID_TURMA TP_TIPO_TURMA /// 
TP_MEDIACAO_DIDATICO_PEDAGO IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE TP_ETAPA_ENSINO CO_CURSO_EDUC_PROFISSIONAL ///
CO_ENTIDADE CO_UF CO_MUNICIPIO TP_DEPENDENCIA TP_LOCALIZACAO TP_CATEGORIA_ESCOLA_PRIVADA ///
IN_CONVENIADA_PP TP_CONVENIO_PODER_PUBLICO IN_MANT_ESCOLA_PRIVADA_EMP IN_MANT_ESCOLA_PRIVADA_ONG IN_MANT_ESCOLA_PRIVADA_SIND ///
IN_MANT_ESCOLA_PRIVADA_SIST_S IN_MANT_ESCOLA_PRIVADA_S_FINS TP_REGULAMENTACAO ///
TP_LOCALIZACAO_DIFERENCIADA IN_EDUCACAO_INDIGENA) (necessidade_especial ///
cegueira baixa_visao surdez deficiencia_auditiva surdocegueira deficiencia_fisica deficiencia_intelectual deficiencia_multipla ///
escolaridade situacao_curso_1 id_area_curso_1 id_curso_1 licenciatura_1 formacao_pedagogica_comp_1 ano_inicio_curso_superior_1 ///
ano_conclusao_curso_superior_1 tipo_ies_1 id_ies_1 situacao_curso_2 ///
id_area_curso_2 id_curso_2 licenciatura_2 formacao_pedagogica_comp_2 ano_inicio_curso_superior_2 ///
ano_conclusao_curso_superior_2 tipo_ies_2 id_ies_2 situacao_curso_3 id_area_curso_3 id_curso_3 licenciatura_3 formacao_pedagogica_comp_3 ///
ano_inicio_curso_superior_3 ano_conclusao_curso_superior_3 tipo_ies_3 id_ies_3 disciplina_quimica disciplina_fisica disciplina_matematica ///
disciplina_biologia disciplina_ciencias disciplina_lingua_portuguesa disciplina_lingua_ingles disciplina_lingua_espanhol disciplina_lingua_frances ///
disciplina_lingua_outra disciplina_lingua_indigena disciplina_artes disciplina_educacao_fisica disciplina_historia disciplina_geografia ///
disciplina_filosofia disciplina_ensino_religioso disciplina_estudos_sociais disciplina_sociologia disciplina_informatica_comp ///
disciplina_profissionalizante disciplina_atend_especiais disciplina_diver_socio_cultural ///
disciplina_libras disciplina_pedagogicas disciplina_outras especializacao mestrado doutorado pos_nenhum ///
formacao_especif_creche formacao_especif_pre_escola formacao_especif_anos_iniciais formacao_especif_anos_finais ///
formacao_especif_ens_medio formacao_especif_eja formacao_especif_ed_especial formacao_especif_ed_indigena ///
formacao_especif_campo formacao_especif_ambiental formacao_especif_dir_humanos formacao_especif_div_sexual ///
formacao_especif_dir_adolesc formacao_especif_afro formacao_especif_outros formacao_especif_nenhum ///
tipo_docente tipo_contratacao id_turma tipo_turma mediacao_didatico_pedago especial_exclusiva regular eja profissionalizante ///
etapa_ensino id_curso_educ_profissional id_escola id_uf id_municipio rede localizacao categoria_escola_privada ///
conveniada_pp convenio_poder_publico mant_escola_privada_emp mant_escola_privada_ong mant_escola_privada_sind ///
mant_escola_privada_sist_s mant_escola_privada_s_fins regulamentacao localizacao_diferenciada educacao_indigena)

tostring id_uf, replace
gen sigla_uf = "PR" if id_uf == "41"
replace sigla_uf = "SC" if id_uf == "42"
replace sigla_uf = "RS" if id_uf == "43"

tostring rede, replace
replace rede = "federal" if rede == "1"
replace rede = "estadual" if rede == "2" 
replace rede = "municipal" if rede == "3"
replace rede = "privada" if rede == "4"


order ano id_docente mes_nascimento_docente ano_nascimento_docente /// 
dia_nascimento_docente idade idade_referencia sexo cor_raca nacionalidade ///
id_pais_origem id_uf_nascimento id_municipio_nascimento id_uf_endereco id_municipio_endereco zona_residencial necessidade_especial ///
cegueira baixa_visao surdez deficiencia_auditiva surdocegueira deficiencia_fisica deficiencia_intelectual deficiencia_multipla ///
escolaridade situacao_curso_1 id_area_curso_1 id_curso_1 licenciatura_1 formacao_pedagogica_comp_1 ano_inicio_curso_superior_1 ///
ano_conclusao_curso_superior_1 tipo_ies_1 id_ies_1 situacao_curso_2 ///
id_area_curso_2 id_curso_2 licenciatura_2 formacao_pedagogica_comp_2 ano_inicio_curso_superior_2 ///
ano_conclusao_curso_superior_2 tipo_ies_2 id_ies_2 situacao_curso_3 id_area_curso_3 id_curso_3 licenciatura_3 formacao_pedagogica_comp_3 ///
ano_inicio_curso_superior_3 ano_conclusao_curso_superior_3 tipo_ies_3 id_ies_3 disciplina_quimica disciplina_fisica disciplina_matematica ///
disciplina_biologia disciplina_ciencias disciplina_lingua_portuguesa disciplina_lingua_ingles disciplina_lingua_espanhol disciplina_lingua_frances ///
disciplina_lingua_outra disciplina_lingua_indigena disciplina_artes disciplina_educacao_fisica disciplina_historia disciplina_geografia ///
disciplina_filosofia disciplina_ensino_religioso disciplina_estudos_sociais disciplina_sociologia disciplina_informatica_comp ///
disciplina_profissionalizante disciplina_atend_especiais disciplina_diver_socio_cultural ///
disciplina_libras disciplina_pedagogicas disciplina_outras especializacao mestrado doutorado pos_nenhum ///
formacao_especif_creche formacao_especif_pre_escola formacao_especif_anos_iniciais formacao_especif_anos_finais ///
formacao_especif_ens_medio formacao_especif_eja formacao_especif_ed_especial formacao_especif_ed_indigena ///
formacao_especif_campo formacao_especif_ambiental formacao_especif_dir_humanos formacao_especif_div_sexual ///
formacao_especif_dir_adolesc formacao_especif_afro formacao_especif_outros formacao_especif_nenhum ///
tipo_docente tipo_contratacao id_turma tipo_turma mediacao_didatico_pedago especial_exclusiva regular eja profissionalizante ///
etapa_ensino id_curso_educ_profissional id_escola id_uf id_municipio rede localizacao categoria_escola_privada ///
conveniada_pp convenio_poder_publico mant_escola_privada_emp mant_escola_privada_ong mant_escola_privada_sind ///
mant_escola_privada_sist_s mant_escola_privada_s_fins regulamentacao localizacao_diferenciada educacao_indigena


foreach estado in PR SC RS {
	preserve
keep if sigla_uf == "`estado'"
drop ano sigla_uf id_uf
export delimited "C:/Users/Matheus/Desktop/particionadastata/ano=`t'/sigla_uf=`estado'/microdados_`estado'.csv" , replace
	restore
	
	}
}
