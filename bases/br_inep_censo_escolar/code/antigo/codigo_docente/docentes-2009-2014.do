
*foreach ano in 2009 2010 2011 2012 2013 2014 {
*mkdir "C:/Users/Matheus/Desktop/particionadastata/ano=`ano'"
*foreach estado in AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO {


*mkdir "C:/Users/Matheus/Desktop/particionadastata/ano=`ano'/sigla_uf=`estado'"
*}
*}




*rodando anos antigos 



*centro oeste
foreach t in  2009 2010 2011 2012 2013 2014 {

import delimited C:\Users\Matheus\Desktop\docente\a`t'\DOCENTES_CO.CSV, delimiter("|") encoding(utf8) clear

rename *, upper

if `t' < 2011{
*pondo as que nao existem
gen ID_LINGUA_LITERAT_FRANCES = ""
gen ID_SITUACAO_CURSO_1 = ""
gen ID_SITUACAO_CURSO_2 = ""
gen ID_SITUACAO_CURSO_3 = ""
gen NU_ANO_INICIO_1 = ""
gen NU_ANO_INICIO_2 = ""
gen NU_ANO_INICIO_3 = ""
gen ID_PEDAGOGICA_1 = ""
gen ID_PEDAGOGICA_2 = ""
gen ID_PEDAGOGICA_3 = ""
gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
gen NUM_IDADE_REF_DOCENTE = ""
gen ID_ZONA_RESIDENCIAL = ""
gen ID_POSSUI_NEC_ESPECIAL = ""
gen ID_CEGUEIRA = ""
gen ID_BAIXA_VISAO = ""
gen ID_SURDEZ = ""
gen ID_DEF_AUDITIVA = ""
gen ID_SURDOCEGUEIRA = ""
gen ID_DEF_FISICA = ""
gen ID_DEF_INTELECTUAL = "" 
gen ID_DEF_MULTIPLA = ""
*gen FK_COD_ESCOLARIDADE = ""
*gen ID_SITUACAO_CURSO_1 = ""
*gen ID_SITUACAO_CURSO_2 = ""
*gen ID_SITUACAO_CURSO_3 = ""
gen ID_COM_PEDAGOGICA_1 = ""
gen ID_COM_PEDAGOGICA_2 = ""
gen ID_COM_PEDAGOGICA_3 = ""
gen ID_ESPECIFICO_CAMPO = ""
gen ID_ESPECIFICO_AMBIENTAL = ""
gen ID_ESPECIFICO_DIR_HUMANOS = ""
gen ID_ESPECIFICO_DIV_SEXUAL = ""
gen ID_ESPECIFICO_DIR_ADOLESC = ""
gen ID_ESPECIFICO_AFRO = ""
gen ID_ESPECIFICO_OUTROS = ""
gen ID_SOCIOLOGIA = ""
gen ID_ESPECIFICO_ANOS_INICIAIS = ""
gen ID_ESPECIFICO_ANOS_FINAIS = ""
gen ID_ESPECIFICO_ENS_MEDIO = ""
gen ID_ESPECIFICO_EJA = ""
gen ID_TIPO_CONTRATACAO = ""
gen ID_MANT_ESCOLA_PRIVADA_SIST_S = ""
replace TP_SEXO = "1" if TP_SEXO == "M"
replace TP_SEXO = "2" if TP_SEXO == "F"


}

if `t' == 2011 {

gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
gen NUM_IDADE_REF_DOCENTE = ""
gen ID_ZONA_RESIDENCIAL = ""
gen ID_POSSUI_NEC_ESPECIAL = ""
gen ID_CEGUEIRA = ""
gen ID_BAIXA_VISAO = ""
gen ID_SURDEZ = ""
gen ID_DEF_AUDITIVA = ""
gen ID_SURDOCEGUEIRA = ""
gen ID_DEF_FISICA = ""
gen ID_DEF_INTELECTUAL = "" 
gen ID_DEF_MULTIPLA = ""
*gen FK_COD_ESCOLARIDADE = ""
*gen ID_SITUACAO_CURSO_1 = ""
*gen ID_SITUACAO_CURSO_2 = ""
*gen ID_SITUACAO_CURSO_3 = ""
gen ID_ESPECIFICO_CAMPO = ""
gen ID_ESPECIFICO_AMBIENTAL = ""
gen ID_ESPECIFICO_DIR_HUMANOS = ""
gen ID_ESPECIFICO_DIV_SEXUAL = ""
gen ID_ESPECIFICO_DIR_ADOLESC = ""
gen ID_ESPECIFICO_AFRO = ""
*gen ID_ESPECIFICO_OUTROS = ""
gen ID_LINGUA_LITERAT_FRANCES = ""
gen ID_SOCIOLOGIA = ""
*gen ID_ESPECIFICO_ANOS_INICIAIS = ""
*gen ID_ESPECIFICO_ANOS_FINAIS = ""
*gen ID_ESPECIFICO_ENS_MEDIO = ""
*gen ID_ESPECIFICO_EJA = ""
gen ID_MANT_ESCOLA_PRIVADA_SIST_S = ""
replace TP_SEXO = "1" if TP_SEXO == "M"
replace TP_SEXO = "2" if TP_SEXO == "F"


}


if `t' > 2011 & `t' < 2014{

gen NUM_IDADE_REF_DOCENTE = ""
gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""

replace TP_SEXO = "1" if TP_SEXO == "M"
replace TP_SEXO = "2" if TP_SEXO == "F"
}


if `t' == 2014 {

gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
}

keep ANO_CENSO FK_COD_DOCENTE NU_MES NU_ANO NU_DIA NUM_IDADE NUM_IDADE_REF_DOCENTE ///
TP_SEXO TP_COR_RACA TP_NACIONALIDADE FK_COD_PAIS_ORIGEM FK_COD_ESTADO_DNASC FK_COD_MUNICIPIO_DNASC FK_COD_ESTADO_DEND ///
FK_COD_MUNICIPIO_DEND ID_ZONA_RESIDENCIAL ID_POSSUI_NEC_ESPECIAL ID_CEGUEIRA ///
ID_BAIXA_VISAO ID_SURDEZ ID_DEF_AUDITIVA ID_SURDOCEGUEIRA ID_DEF_FISICA ID_DEF_INTELECTUAL ///
ID_DEF_MULTIPLA FK_COD_ESCOLARIDADE ID_SITUACAO_CURSO_1 FK_CLASSE_CURSO_1 ///
FK_COD_AREA_OCDE_1 ID_LICENCIATURA_1 ID_COM_PEDAGOGICA_1 NU_ANO_INICIO_1 ///
NU_ANO_CONCLUSAO_1 ID_TIPO_INSTITUICAO_1 FK_COD_IES_1 ID_SITUACAO_CURSO_2 ///
FK_CLASSE_CURSO_2 FK_COD_AREA_OCDE_2 ID_LICENCIATURA_2 ID_COM_PEDAGOGICA_2 ///
NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 ID_TIPO_INSTITUICAO_2 FK_COD_IES_2 ///
ID_SITUACAO_CURSO_3 FK_CLASSE_CURSO_3 FK_COD_AREA_OCDE_3 ID_LICENCIATURA_3 ///
ID_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 NU_ANO_CONCLUSAO_3 ID_TIPO_INSTITUICAO_3 ///
FK_COD_IES_3 ID_QUIMICA ID_FISICA ID_MATEMATICA ID_BIOLOGIA ///
ID_CIENCIAS ID_LINGUA_LITERAT_PORTUGUESA ID_LINGUA_LITERAT_INGLES ///
ID_LINGUA_LITERAT_ESPANHOL ID_LINGUA_LITERAT_FRANCES ID_LINGUA_LITERAT_OUTRA ///
ID_LINGUA_LITERAT_INDIGENA ID_ARTES ID_EDUCACAO_FISICA ID_HISTORIA ID_GEOGRAFIA ///
ID_FILOSOFIA ID_ENSINO_RELIGIOSO ID_ESTUDOS_SOCIAIS ID_SOCIOLOGIA ///
ID_INFORMATICA_COMPUTACAO ID_PROFISSIONALIZANTE ID_DISC_ATENDIMENTO_ESPECIAIS ///
ID_DISC_DIVERSIDADE_SOCIO_CULT ID_LIBRAS ID_DISCIPLINAS_PEDAG ///
ID_OUTRAS_DISCIPLINAS ID_ESPECIALIZACAO ID_MESTRADO ID_DOUTORADO ///
ID_POS_GRADUACAO_NENHUM ID_ESPECIFICO_CRECHE ID_ESPECIFICO_PRE_ESCOLA ID_ESPECIFICO_ANOS_INICIAIS ///
ID_ESPECIFICO_ANOS_FINAIS ID_ESPECIFICO_ENS_MEDIO ID_ESPECIFICO_EJA ID_ESPECIFICO_NEC_ESP ///
ID_ESPECIFICO_ED_INDIGENA ID_ESPECIFICO_CAMPO ID_ESPECIFICO_AMBIENTAL ///
ID_ESPECIFICO_DIR_HUMANOS ID_ESPECIFICO_DIV_SEXUAL ID_ESPECIFICO_DIR_ADOLESC ///
ID_ESPECIFICO_AFRO ID_ESPECIFICO_OUTROS ID_ESPECIFICO_NENHUM ///
ID_TIPO_DOCENTE ID_TIPO_CONTRATACAO PK_COD_TURMA FK_COD_TIPO_TURMA TP_MEDIACAO_DIDATICO_PEDAGO ///
IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE ///
FK_COD_ETAPA_ENSINO FK_COD_CURSO_PROF PK_COD_ENTIDADE FK_COD_ESTADO ///
FK_COD_MUNICIPIO ID_DEPENDENCIA_ADM ID_LOCALIZACAO ///
DESC_CATEGORIA_ESCOLA_PRIVADA ID_CONVENIADA_PP ///
ID_TIPO_CONVENIO_PODER_PUBLICO ID_MANT_ESCOLA_PRIVADA_EMP ///
ID_MANT_ESCOLA_PRIVADA_ONG ID_MANT_ESCOLA_PRIVADA_SIND ///
ID_MANT_ESCOLA_PRIVADA_SIST_S ID_MANT_ESCOLA_PRIVADA_S_FINS ///
ID_DOCUMENTO_REGULAMENTACAO ID_LOCALIZACAO_DIFERENCIADA ID_EDUCACAO_INDIGENA




*renomeando as variaveis

rename (ANO_CENSO FK_COD_DOCENTE NU_MES NU_ANO NU_DIA NUM_IDADE NUM_IDADE_REF_DOCENTE ///
TP_SEXO TP_COR_RACA TP_NACIONALIDADE FK_COD_PAIS_ORIGEM FK_COD_ESTADO_DNASC FK_COD_MUNICIPIO_DNASC FK_COD_ESTADO_DEND ///
FK_COD_MUNICIPIO_DEND ID_ZONA_RESIDENCIAL ID_POSSUI_NEC_ESPECIAL ID_CEGUEIRA ///
ID_BAIXA_VISAO ID_SURDEZ ID_DEF_AUDITIVA ID_SURDOCEGUEIRA ID_DEF_FISICA ID_DEF_INTELECTUAL ///
ID_DEF_MULTIPLA FK_COD_ESCOLARIDADE ID_SITUACAO_CURSO_1 FK_CLASSE_CURSO_1 ///
FK_COD_AREA_OCDE_1 ID_LICENCIATURA_1 ID_COM_PEDAGOGICA_1 NU_ANO_INICIO_1 ///
NU_ANO_CONCLUSAO_1 ID_TIPO_INSTITUICAO_1 FK_COD_IES_1 ID_SITUACAO_CURSO_2 ///
FK_CLASSE_CURSO_2 FK_COD_AREA_OCDE_2 ID_LICENCIATURA_2 ID_COM_PEDAGOGICA_2 ///
NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 ID_TIPO_INSTITUICAO_2 FK_COD_IES_2 ///
ID_SITUACAO_CURSO_3 FK_CLASSE_CURSO_3 FK_COD_AREA_OCDE_3 ID_LICENCIATURA_3 ///
ID_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 NU_ANO_CONCLUSAO_3 ID_TIPO_INSTITUICAO_3 ///
FK_COD_IES_3 ID_QUIMICA ID_FISICA ID_MATEMATICA ID_BIOLOGIA ///
ID_CIENCIAS ID_LINGUA_LITERAT_PORTUGUESA ID_LINGUA_LITERAT_INGLES ///
ID_LINGUA_LITERAT_ESPANHOL ID_LINGUA_LITERAT_FRANCES ID_LINGUA_LITERAT_OUTRA ///
ID_LINGUA_LITERAT_INDIGENA ID_ARTES ID_EDUCACAO_FISICA ID_HISTORIA ID_GEOGRAFIA ///
ID_FILOSOFIA ID_ENSINO_RELIGIOSO ID_ESTUDOS_SOCIAIS ID_SOCIOLOGIA ///
ID_INFORMATICA_COMPUTACAO ID_PROFISSIONALIZANTE ID_DISC_ATENDIMENTO_ESPECIAIS ///
ID_DISC_DIVERSIDADE_SOCIO_CULT ID_LIBRAS ID_DISCIPLINAS_PEDAG ///
ID_OUTRAS_DISCIPLINAS ID_ESPECIALIZACAO ID_MESTRADO ID_DOUTORADO ///
ID_POS_GRADUACAO_NENHUM ID_ESPECIFICO_CRECHE ID_ESPECIFICO_PRE_ESCOLA ID_ESPECIFICO_ANOS_INICIAIS ///
ID_ESPECIFICO_ANOS_FINAIS ID_ESPECIFICO_ENS_MEDIO ID_ESPECIFICO_EJA ID_ESPECIFICO_NEC_ESP ///
ID_ESPECIFICO_ED_INDIGENA ID_ESPECIFICO_CAMPO ID_ESPECIFICO_AMBIENTAL ///
ID_ESPECIFICO_DIR_HUMANOS ID_ESPECIFICO_DIV_SEXUAL ID_ESPECIFICO_DIR_ADOLESC ///
ID_ESPECIFICO_AFRO ID_ESPECIFICO_OUTROS ID_ESPECIFICO_NENHUM ///
ID_TIPO_DOCENTE ID_TIPO_CONTRATACAO PK_COD_TURMA FK_COD_TIPO_TURMA TP_MEDIACAO_DIDATICO_PEDAGO ///
IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE ///
FK_COD_ETAPA_ENSINO FK_COD_CURSO_PROF PK_COD_ENTIDADE FK_COD_ESTADO ///
FK_COD_MUNICIPIO ID_DEPENDENCIA_ADM ID_LOCALIZACAO ///
DESC_CATEGORIA_ESCOLA_PRIVADA ID_CONVENIADA_PP ///
ID_TIPO_CONVENIO_PODER_PUBLICO ID_MANT_ESCOLA_PRIVADA_EMP ///
ID_MANT_ESCOLA_PRIVADA_ONG ID_MANT_ESCOLA_PRIVADA_SIND ///
ID_MANT_ESCOLA_PRIVADA_SIST_S ID_MANT_ESCOLA_PRIVADA_S_FINS ///
ID_DOCUMENTO_REGULAMENTACAO ID_LOCALIZACAO_DIFERENCIADA ID_EDUCACAO_INDIGENA)(ano id_docente mes_nascimento_docente ano_nascimento_docente /// 
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

foreach t in  2009 2010 2011 2012 2013 2014 {

import delimited C:\Users\Matheus\Desktop\docente\a`t'\DOCENTES_NORTE.CSV, delimiter("|") encoding(utf8) clear

rename *, upper

if `t' < 2011{
*pondo as que nao existem
gen ID_LINGUA_LITERAT_FRANCES = ""
gen ID_SITUACAO_CURSO_1 = ""
gen ID_SITUACAO_CURSO_2 = ""
gen ID_SITUACAO_CURSO_3 = ""
gen NU_ANO_INICIO_1 = ""
gen NU_ANO_INICIO_2 = ""
gen NU_ANO_INICIO_3 = ""
gen ID_PEDAGOGICA_1 = ""
gen ID_PEDAGOGICA_2 = ""
gen ID_PEDAGOGICA_3 = ""
gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
gen NUM_IDADE_REF_DOCENTE = ""
gen ID_ZONA_RESIDENCIAL = ""
gen ID_POSSUI_NEC_ESPECIAL = ""
gen ID_CEGUEIRA = ""
gen ID_BAIXA_VISAO = ""
gen ID_SURDEZ = ""
gen ID_DEF_AUDITIVA = ""
gen ID_SURDOCEGUEIRA = ""
gen ID_DEF_FISICA = ""
gen ID_DEF_INTELECTUAL = "" 
gen ID_DEF_MULTIPLA = ""
*gen FK_COD_ESCOLARIDADE = ""
*gen ID_SITUACAO_CURSO_1 = ""
*gen ID_SITUACAO_CURSO_2 = ""
*gen ID_SITUACAO_CURSO_3 = ""
gen ID_COM_PEDAGOGICA_1 = ""
gen ID_COM_PEDAGOGICA_2 = ""
gen ID_COM_PEDAGOGICA_3 = ""
gen ID_ESPECIFICO_CAMPO = ""
gen ID_ESPECIFICO_AMBIENTAL = ""
gen ID_ESPECIFICO_DIR_HUMANOS = ""
gen ID_ESPECIFICO_DIV_SEXUAL = ""
gen ID_ESPECIFICO_DIR_ADOLESC = ""
gen ID_ESPECIFICO_AFRO = ""
gen ID_ESPECIFICO_OUTROS = ""
gen ID_SOCIOLOGIA = ""
gen ID_ESPECIFICO_ANOS_INICIAIS = ""
gen ID_ESPECIFICO_ANOS_FINAIS = ""
gen ID_ESPECIFICO_ENS_MEDIO = ""
gen ID_ESPECIFICO_EJA = ""
gen ID_TIPO_CONTRATACAO = ""
gen ID_MANT_ESCOLA_PRIVADA_SIST_S = ""
replace TP_SEXO = "1" if TP_SEXO == "M"
replace TP_SEXO = "2" if TP_SEXO == "F"

}

if `t' == 2011 {

gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
gen NUM_IDADE_REF_DOCENTE = ""
gen ID_ZONA_RESIDENCIAL = ""
gen ID_POSSUI_NEC_ESPECIAL = ""
gen ID_CEGUEIRA = ""
gen ID_BAIXA_VISAO = ""
gen ID_SURDEZ = ""
gen ID_DEF_AUDITIVA = ""
gen ID_SURDOCEGUEIRA = ""
gen ID_DEF_FISICA = ""
gen ID_DEF_INTELECTUAL = "" 
gen ID_DEF_MULTIPLA = ""
*gen FK_COD_ESCOLARIDADE = ""
*gen ID_SITUACAO_CURSO_1 = ""
*gen ID_SITUACAO_CURSO_2 = ""
*gen ID_SITUACAO_CURSO_3 = ""
gen ID_ESPECIFICO_CAMPO = ""
gen ID_ESPECIFICO_AMBIENTAL = ""
gen ID_ESPECIFICO_DIR_HUMANOS = ""
gen ID_ESPECIFICO_DIV_SEXUAL = ""
gen ID_ESPECIFICO_DIR_ADOLESC = ""
gen ID_ESPECIFICO_AFRO = ""
*gen ID_ESPECIFICO_OUTROS = ""
gen ID_LINGUA_LITERAT_FRANCES = ""
gen ID_SOCIOLOGIA = ""
*gen ID_ESPECIFICO_ANOS_INICIAIS = ""
*gen ID_ESPECIFICO_ANOS_FINAIS = ""
*gen ID_ESPECIFICO_ENS_MEDIO = ""
*gen ID_ESPECIFICO_EJA = ""
gen ID_MANT_ESCOLA_PRIVADA_SIST_S = ""
replace TP_SEXO = "1" if TP_SEXO == "M"
replace TP_SEXO = "2" if TP_SEXO == "F"
}


if `t' > 2011 & `t' < 2014{

gen NUM_IDADE_REF_DOCENTE = ""
gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
replace TP_SEXO = "1" if TP_SEXO == "M"
replace TP_SEXO = "2" if TP_SEXO == "F"
}


if `t' == 2014 {

gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
}

keep ANO_CENSO FK_COD_DOCENTE NU_MES NU_ANO NU_DIA NUM_IDADE NUM_IDADE_REF_DOCENTE ///
TP_SEXO TP_COR_RACA TP_NACIONALIDADE FK_COD_PAIS_ORIGEM FK_COD_ESTADO_DNASC FK_COD_MUNICIPIO_DNASC FK_COD_ESTADO_DEND ///
FK_COD_MUNICIPIO_DEND ID_ZONA_RESIDENCIAL ID_POSSUI_NEC_ESPECIAL ID_CEGUEIRA ///
ID_BAIXA_VISAO ID_SURDEZ ID_DEF_AUDITIVA ID_SURDOCEGUEIRA ID_DEF_FISICA ID_DEF_INTELECTUAL ///
ID_DEF_MULTIPLA FK_COD_ESCOLARIDADE ID_SITUACAO_CURSO_1 FK_CLASSE_CURSO_1 ///
FK_COD_AREA_OCDE_1 ID_LICENCIATURA_1 ID_COM_PEDAGOGICA_1 NU_ANO_INICIO_1 ///
NU_ANO_CONCLUSAO_1 ID_TIPO_INSTITUICAO_1 FK_COD_IES_1 ID_SITUACAO_CURSO_2 ///
FK_CLASSE_CURSO_2 FK_COD_AREA_OCDE_2 ID_LICENCIATURA_2 ID_COM_PEDAGOGICA_2 ///
NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 ID_TIPO_INSTITUICAO_2 FK_COD_IES_2 ///
ID_SITUACAO_CURSO_3 FK_CLASSE_CURSO_3 FK_COD_AREA_OCDE_3 ID_LICENCIATURA_3 ///
ID_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 NU_ANO_CONCLUSAO_3 ID_TIPO_INSTITUICAO_3 ///
FK_COD_IES_3 ID_QUIMICA ID_FISICA ID_MATEMATICA ID_BIOLOGIA ///
ID_CIENCIAS ID_LINGUA_LITERAT_PORTUGUESA ID_LINGUA_LITERAT_INGLES ///
ID_LINGUA_LITERAT_ESPANHOL ID_LINGUA_LITERAT_FRANCES ID_LINGUA_LITERAT_OUTRA ///
ID_LINGUA_LITERAT_INDIGENA ID_ARTES ID_EDUCACAO_FISICA ID_HISTORIA ID_GEOGRAFIA ///
ID_FILOSOFIA ID_ENSINO_RELIGIOSO ID_ESTUDOS_SOCIAIS ID_SOCIOLOGIA ///
ID_INFORMATICA_COMPUTACAO ID_PROFISSIONALIZANTE ID_DISC_ATENDIMENTO_ESPECIAIS ///
ID_DISC_DIVERSIDADE_SOCIO_CULT ID_LIBRAS ID_DISCIPLINAS_PEDAG ///
ID_OUTRAS_DISCIPLINAS ID_ESPECIALIZACAO ID_MESTRADO ID_DOUTORADO ///
ID_POS_GRADUACAO_NENHUM ID_ESPECIFICO_CRECHE ID_ESPECIFICO_PRE_ESCOLA ID_ESPECIFICO_ANOS_INICIAIS ///
ID_ESPECIFICO_ANOS_FINAIS ID_ESPECIFICO_ENS_MEDIO ID_ESPECIFICO_EJA ID_ESPECIFICO_NEC_ESP ///
ID_ESPECIFICO_ED_INDIGENA ID_ESPECIFICO_CAMPO ID_ESPECIFICO_AMBIENTAL ///
ID_ESPECIFICO_DIR_HUMANOS ID_ESPECIFICO_DIV_SEXUAL ID_ESPECIFICO_DIR_ADOLESC ///
ID_ESPECIFICO_AFRO ID_ESPECIFICO_OUTROS ID_ESPECIFICO_NENHUM ///
ID_TIPO_DOCENTE ID_TIPO_CONTRATACAO PK_COD_TURMA FK_COD_TIPO_TURMA TP_MEDIACAO_DIDATICO_PEDAGO ///
IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE ///
FK_COD_ETAPA_ENSINO FK_COD_CURSO_PROF PK_COD_ENTIDADE FK_COD_ESTADO ///
FK_COD_MUNICIPIO ID_DEPENDENCIA_ADM ID_LOCALIZACAO ///
DESC_CATEGORIA_ESCOLA_PRIVADA ID_CONVENIADA_PP ///
ID_TIPO_CONVENIO_PODER_PUBLICO ID_MANT_ESCOLA_PRIVADA_EMP ///
ID_MANT_ESCOLA_PRIVADA_ONG ID_MANT_ESCOLA_PRIVADA_SIND ///
ID_MANT_ESCOLA_PRIVADA_SIST_S ID_MANT_ESCOLA_PRIVADA_S_FINS ///
ID_DOCUMENTO_REGULAMENTACAO ID_LOCALIZACAO_DIFERENCIADA ID_EDUCACAO_INDIGENA




*renomeando as variaveis

rename (ANO_CENSO FK_COD_DOCENTE NU_MES NU_ANO NU_DIA NUM_IDADE NUM_IDADE_REF_DOCENTE ///
TP_SEXO TP_COR_RACA TP_NACIONALIDADE FK_COD_PAIS_ORIGEM FK_COD_ESTADO_DNASC FK_COD_MUNICIPIO_DNASC FK_COD_ESTADO_DEND ///
FK_COD_MUNICIPIO_DEND ID_ZONA_RESIDENCIAL ID_POSSUI_NEC_ESPECIAL ID_CEGUEIRA ///
ID_BAIXA_VISAO ID_SURDEZ ID_DEF_AUDITIVA ID_SURDOCEGUEIRA ID_DEF_FISICA ID_DEF_INTELECTUAL ///
ID_DEF_MULTIPLA FK_COD_ESCOLARIDADE ID_SITUACAO_CURSO_1 FK_CLASSE_CURSO_1 ///
FK_COD_AREA_OCDE_1 ID_LICENCIATURA_1 ID_COM_PEDAGOGICA_1 NU_ANO_INICIO_1 ///
NU_ANO_CONCLUSAO_1 ID_TIPO_INSTITUICAO_1 FK_COD_IES_1 ID_SITUACAO_CURSO_2 ///
FK_CLASSE_CURSO_2 FK_COD_AREA_OCDE_2 ID_LICENCIATURA_2 ID_COM_PEDAGOGICA_2 ///
NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 ID_TIPO_INSTITUICAO_2 FK_COD_IES_2 ///
ID_SITUACAO_CURSO_3 FK_CLASSE_CURSO_3 FK_COD_AREA_OCDE_3 ID_LICENCIATURA_3 ///
ID_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 NU_ANO_CONCLUSAO_3 ID_TIPO_INSTITUICAO_3 ///
FK_COD_IES_3 ID_QUIMICA ID_FISICA ID_MATEMATICA ID_BIOLOGIA ///
ID_CIENCIAS ID_LINGUA_LITERAT_PORTUGUESA ID_LINGUA_LITERAT_INGLES ///
ID_LINGUA_LITERAT_ESPANHOL ID_LINGUA_LITERAT_FRANCES ID_LINGUA_LITERAT_OUTRA ///
ID_LINGUA_LITERAT_INDIGENA ID_ARTES ID_EDUCACAO_FISICA ID_HISTORIA ID_GEOGRAFIA ///
ID_FILOSOFIA ID_ENSINO_RELIGIOSO ID_ESTUDOS_SOCIAIS ID_SOCIOLOGIA ///
ID_INFORMATICA_COMPUTACAO ID_PROFISSIONALIZANTE ID_DISC_ATENDIMENTO_ESPECIAIS ///
ID_DISC_DIVERSIDADE_SOCIO_CULT ID_LIBRAS ID_DISCIPLINAS_PEDAG ///
ID_OUTRAS_DISCIPLINAS ID_ESPECIALIZACAO ID_MESTRADO ID_DOUTORADO ///
ID_POS_GRADUACAO_NENHUM ID_ESPECIFICO_CRECHE ID_ESPECIFICO_PRE_ESCOLA ID_ESPECIFICO_ANOS_INICIAIS ///
ID_ESPECIFICO_ANOS_FINAIS ID_ESPECIFICO_ENS_MEDIO ID_ESPECIFICO_EJA ID_ESPECIFICO_NEC_ESP ///
ID_ESPECIFICO_ED_INDIGENA ID_ESPECIFICO_CAMPO ID_ESPECIFICO_AMBIENTAL ///
ID_ESPECIFICO_DIR_HUMANOS ID_ESPECIFICO_DIV_SEXUAL ID_ESPECIFICO_DIR_ADOLESC ///
ID_ESPECIFICO_AFRO ID_ESPECIFICO_OUTROS ID_ESPECIFICO_NENHUM ///
ID_TIPO_DOCENTE ID_TIPO_CONTRATACAO PK_COD_TURMA FK_COD_TIPO_TURMA TP_MEDIACAO_DIDATICO_PEDAGO ///
IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE ///
FK_COD_ETAPA_ENSINO FK_COD_CURSO_PROF PK_COD_ENTIDADE FK_COD_ESTADO ///
FK_COD_MUNICIPIO ID_DEPENDENCIA_ADM ID_LOCALIZACAO ///
DESC_CATEGORIA_ESCOLA_PRIVADA ID_CONVENIADA_PP ///
ID_TIPO_CONVENIO_PODER_PUBLICO ID_MANT_ESCOLA_PRIVADA_EMP ///
ID_MANT_ESCOLA_PRIVADA_ONG ID_MANT_ESCOLA_PRIVADA_SIND ///
ID_MANT_ESCOLA_PRIVADA_SIST_S ID_MANT_ESCOLA_PRIVADA_S_FINS ///
ID_DOCUMENTO_REGULAMENTACAO ID_LOCALIZACAO_DIFERENCIADA ID_EDUCACAO_INDIGENA)(ano id_docente mes_nascimento_docente ano_nascimento_docente /// 
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

foreach t in  2009 2010 2011 2012 2013 2014 {

import delimited C:\Users\Matheus\Desktop\docente\a`t'\DOCENTES_NORDESTE.CSV, delimiter("|") encoding(utf8) clear

rename *, upper

if `t' < 2011{
*pondo as que nao existem
gen ID_LINGUA_LITERAT_FRANCES = ""
gen ID_SITUACAO_CURSO_1 = ""
gen ID_SITUACAO_CURSO_2 = ""
gen ID_SITUACAO_CURSO_3 = ""
gen NU_ANO_INICIO_1 = ""
gen NU_ANO_INICIO_2 = ""
gen NU_ANO_INICIO_3 = ""
gen ID_PEDAGOGICA_1 = ""
gen ID_PEDAGOGICA_2 = ""
gen ID_PEDAGOGICA_3 = ""
gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
gen NUM_IDADE_REF_DOCENTE = ""
gen ID_ZONA_RESIDENCIAL = ""
gen ID_POSSUI_NEC_ESPECIAL = ""
gen ID_CEGUEIRA = ""
gen ID_BAIXA_VISAO = ""
gen ID_SURDEZ = ""
gen ID_DEF_AUDITIVA = ""
gen ID_SURDOCEGUEIRA = ""
gen ID_DEF_FISICA = ""
gen ID_DEF_INTELECTUAL = "" 
gen ID_DEF_MULTIPLA = ""
*gen FK_COD_ESCOLARIDADE = ""
*gen ID_SITUACAO_CURSO_1 = ""
*gen ID_SITUACAO_CURSO_2 = ""
*gen ID_SITUACAO_CURSO_3 = ""
gen ID_COM_PEDAGOGICA_1 = ""
gen ID_COM_PEDAGOGICA_2 = ""
gen ID_COM_PEDAGOGICA_3 = ""
gen ID_ESPECIFICO_CAMPO = ""
gen ID_ESPECIFICO_AMBIENTAL = ""
gen ID_ESPECIFICO_DIR_HUMANOS = ""
gen ID_ESPECIFICO_DIV_SEXUAL = ""
gen ID_ESPECIFICO_DIR_ADOLESC = ""
gen ID_ESPECIFICO_AFRO = ""
gen ID_ESPECIFICO_OUTROS = ""
gen ID_SOCIOLOGIA = ""
gen ID_ESPECIFICO_ANOS_INICIAIS = ""
gen ID_ESPECIFICO_ANOS_FINAIS = ""
gen ID_ESPECIFICO_ENS_MEDIO = ""
gen ID_ESPECIFICO_EJA = ""
gen ID_TIPO_CONTRATACAO = ""
gen ID_MANT_ESCOLA_PRIVADA_SIST_S = ""
replace TP_SEXO = "1" if TP_SEXO == "M"
replace TP_SEXO = "2" if TP_SEXO == "F"

}

if `t' == 2011 {

gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
gen NUM_IDADE_REF_DOCENTE = ""
gen ID_ZONA_RESIDENCIAL = ""
gen ID_POSSUI_NEC_ESPECIAL = ""
gen ID_CEGUEIRA = ""
gen ID_BAIXA_VISAO = ""
gen ID_SURDEZ = ""
gen ID_DEF_AUDITIVA = ""
gen ID_SURDOCEGUEIRA = ""
gen ID_DEF_FISICA = ""
gen ID_DEF_INTELECTUAL = "" 
gen ID_DEF_MULTIPLA = ""
*gen FK_COD_ESCOLARIDADE = ""
*gen ID_SITUACAO_CURSO_1 = ""
*gen ID_SITUACAO_CURSO_2 = ""
*gen ID_SITUACAO_CURSO_3 = ""
gen ID_ESPECIFICO_CAMPO = ""
gen ID_ESPECIFICO_AMBIENTAL = ""
gen ID_ESPECIFICO_DIR_HUMANOS = ""
gen ID_ESPECIFICO_DIV_SEXUAL = ""
gen ID_ESPECIFICO_DIR_ADOLESC = ""
gen ID_ESPECIFICO_AFRO = ""
*gen ID_ESPECIFICO_OUTROS = ""
gen ID_LINGUA_LITERAT_FRANCES = ""
gen ID_SOCIOLOGIA = ""
*gen ID_ESPECIFICO_ANOS_INICIAIS = ""
*gen ID_ESPECIFICO_ANOS_FINAIS = ""
*gen ID_ESPECIFICO_ENS_MEDIO = ""
*gen ID_ESPECIFICO_EJA = ""
gen ID_MANT_ESCOLA_PRIVADA_SIST_S = ""
replace TP_SEXO = "1" if TP_SEXO == "M"
replace TP_SEXO = "2" if TP_SEXO == "F"
}


if `t' > 2011 & `t' < 2014{

gen NUM_IDADE_REF_DOCENTE = ""
gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
replace TP_SEXO = "1" if TP_SEXO == "M"
replace TP_SEXO = "2" if TP_SEXO == "F"
}


if `t' == 2014 {

gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
}

keep ANO_CENSO FK_COD_DOCENTE NU_MES NU_ANO NU_DIA NUM_IDADE NUM_IDADE_REF_DOCENTE ///
TP_SEXO TP_COR_RACA TP_NACIONALIDADE FK_COD_PAIS_ORIGEM FK_COD_ESTADO_DNASC FK_COD_MUNICIPIO_DNASC FK_COD_ESTADO_DEND ///
FK_COD_MUNICIPIO_DEND ID_ZONA_RESIDENCIAL ID_POSSUI_NEC_ESPECIAL ID_CEGUEIRA ///
ID_BAIXA_VISAO ID_SURDEZ ID_DEF_AUDITIVA ID_SURDOCEGUEIRA ID_DEF_FISICA ID_DEF_INTELECTUAL ///
ID_DEF_MULTIPLA FK_COD_ESCOLARIDADE ID_SITUACAO_CURSO_1 FK_CLASSE_CURSO_1 ///
FK_COD_AREA_OCDE_1 ID_LICENCIATURA_1 ID_COM_PEDAGOGICA_1 NU_ANO_INICIO_1 ///
NU_ANO_CONCLUSAO_1 ID_TIPO_INSTITUICAO_1 FK_COD_IES_1 ID_SITUACAO_CURSO_2 ///
FK_CLASSE_CURSO_2 FK_COD_AREA_OCDE_2 ID_LICENCIATURA_2 ID_COM_PEDAGOGICA_2 ///
NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 ID_TIPO_INSTITUICAO_2 FK_COD_IES_2 ///
ID_SITUACAO_CURSO_3 FK_CLASSE_CURSO_3 FK_COD_AREA_OCDE_3 ID_LICENCIATURA_3 ///
ID_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 NU_ANO_CONCLUSAO_3 ID_TIPO_INSTITUICAO_3 ///
FK_COD_IES_3 ID_QUIMICA ID_FISICA ID_MATEMATICA ID_BIOLOGIA ///
ID_CIENCIAS ID_LINGUA_LITERAT_PORTUGUESA ID_LINGUA_LITERAT_INGLES ///
ID_LINGUA_LITERAT_ESPANHOL ID_LINGUA_LITERAT_FRANCES ID_LINGUA_LITERAT_OUTRA ///
ID_LINGUA_LITERAT_INDIGENA ID_ARTES ID_EDUCACAO_FISICA ID_HISTORIA ID_GEOGRAFIA ///
ID_FILOSOFIA ID_ENSINO_RELIGIOSO ID_ESTUDOS_SOCIAIS ID_SOCIOLOGIA ///
ID_INFORMATICA_COMPUTACAO ID_PROFISSIONALIZANTE ID_DISC_ATENDIMENTO_ESPECIAIS ///
ID_DISC_DIVERSIDADE_SOCIO_CULT ID_LIBRAS ID_DISCIPLINAS_PEDAG ///
ID_OUTRAS_DISCIPLINAS ID_ESPECIALIZACAO ID_MESTRADO ID_DOUTORADO ///
ID_POS_GRADUACAO_NENHUM ID_ESPECIFICO_CRECHE ID_ESPECIFICO_PRE_ESCOLA ID_ESPECIFICO_ANOS_INICIAIS ///
ID_ESPECIFICO_ANOS_FINAIS ID_ESPECIFICO_ENS_MEDIO ID_ESPECIFICO_EJA ID_ESPECIFICO_NEC_ESP ///
ID_ESPECIFICO_ED_INDIGENA ID_ESPECIFICO_CAMPO ID_ESPECIFICO_AMBIENTAL ///
ID_ESPECIFICO_DIR_HUMANOS ID_ESPECIFICO_DIV_SEXUAL ID_ESPECIFICO_DIR_ADOLESC ///
ID_ESPECIFICO_AFRO ID_ESPECIFICO_OUTROS ID_ESPECIFICO_NENHUM ///
ID_TIPO_DOCENTE ID_TIPO_CONTRATACAO PK_COD_TURMA FK_COD_TIPO_TURMA TP_MEDIACAO_DIDATICO_PEDAGO ///
IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE ///
FK_COD_ETAPA_ENSINO FK_COD_CURSO_PROF PK_COD_ENTIDADE FK_COD_ESTADO ///
FK_COD_MUNICIPIO ID_DEPENDENCIA_ADM ID_LOCALIZACAO ///
DESC_CATEGORIA_ESCOLA_PRIVADA ID_CONVENIADA_PP ///
ID_TIPO_CONVENIO_PODER_PUBLICO ID_MANT_ESCOLA_PRIVADA_EMP ///
ID_MANT_ESCOLA_PRIVADA_ONG ID_MANT_ESCOLA_PRIVADA_SIND ///
ID_MANT_ESCOLA_PRIVADA_SIST_S ID_MANT_ESCOLA_PRIVADA_S_FINS ///
ID_DOCUMENTO_REGULAMENTACAO ID_LOCALIZACAO_DIFERENCIADA ID_EDUCACAO_INDIGENA




*renomeando as variaveis

rename (ANO_CENSO FK_COD_DOCENTE NU_MES NU_ANO NU_DIA NUM_IDADE NUM_IDADE_REF_DOCENTE ///
TP_SEXO TP_COR_RACA TP_NACIONALIDADE FK_COD_PAIS_ORIGEM FK_COD_ESTADO_DNASC FK_COD_MUNICIPIO_DNASC FK_COD_ESTADO_DEND ///
FK_COD_MUNICIPIO_DEND ID_ZONA_RESIDENCIAL ID_POSSUI_NEC_ESPECIAL ID_CEGUEIRA ///
ID_BAIXA_VISAO ID_SURDEZ ID_DEF_AUDITIVA ID_SURDOCEGUEIRA ID_DEF_FISICA ID_DEF_INTELECTUAL ///
ID_DEF_MULTIPLA FK_COD_ESCOLARIDADE ID_SITUACAO_CURSO_1 FK_CLASSE_CURSO_1 ///
FK_COD_AREA_OCDE_1 ID_LICENCIATURA_1 ID_COM_PEDAGOGICA_1 NU_ANO_INICIO_1 ///
NU_ANO_CONCLUSAO_1 ID_TIPO_INSTITUICAO_1 FK_COD_IES_1 ID_SITUACAO_CURSO_2 ///
FK_CLASSE_CURSO_2 FK_COD_AREA_OCDE_2 ID_LICENCIATURA_2 ID_COM_PEDAGOGICA_2 ///
NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 ID_TIPO_INSTITUICAO_2 FK_COD_IES_2 ///
ID_SITUACAO_CURSO_3 FK_CLASSE_CURSO_3 FK_COD_AREA_OCDE_3 ID_LICENCIATURA_3 ///
ID_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 NU_ANO_CONCLUSAO_3 ID_TIPO_INSTITUICAO_3 ///
FK_COD_IES_3 ID_QUIMICA ID_FISICA ID_MATEMATICA ID_BIOLOGIA ///
ID_CIENCIAS ID_LINGUA_LITERAT_PORTUGUESA ID_LINGUA_LITERAT_INGLES ///
ID_LINGUA_LITERAT_ESPANHOL ID_LINGUA_LITERAT_FRANCES ID_LINGUA_LITERAT_OUTRA ///
ID_LINGUA_LITERAT_INDIGENA ID_ARTES ID_EDUCACAO_FISICA ID_HISTORIA ID_GEOGRAFIA ///
ID_FILOSOFIA ID_ENSINO_RELIGIOSO ID_ESTUDOS_SOCIAIS ID_SOCIOLOGIA ///
ID_INFORMATICA_COMPUTACAO ID_PROFISSIONALIZANTE ID_DISC_ATENDIMENTO_ESPECIAIS ///
ID_DISC_DIVERSIDADE_SOCIO_CULT ID_LIBRAS ID_DISCIPLINAS_PEDAG ///
ID_OUTRAS_DISCIPLINAS ID_ESPECIALIZACAO ID_MESTRADO ID_DOUTORADO ///
ID_POS_GRADUACAO_NENHUM ID_ESPECIFICO_CRECHE ID_ESPECIFICO_PRE_ESCOLA ID_ESPECIFICO_ANOS_INICIAIS ///
ID_ESPECIFICO_ANOS_FINAIS ID_ESPECIFICO_ENS_MEDIO ID_ESPECIFICO_EJA ID_ESPECIFICO_NEC_ESP ///
ID_ESPECIFICO_ED_INDIGENA ID_ESPECIFICO_CAMPO ID_ESPECIFICO_AMBIENTAL ///
ID_ESPECIFICO_DIR_HUMANOS ID_ESPECIFICO_DIV_SEXUAL ID_ESPECIFICO_DIR_ADOLESC ///
ID_ESPECIFICO_AFRO ID_ESPECIFICO_OUTROS ID_ESPECIFICO_NENHUM ///
ID_TIPO_DOCENTE ID_TIPO_CONTRATACAO PK_COD_TURMA FK_COD_TIPO_TURMA TP_MEDIACAO_DIDATICO_PEDAGO ///
IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE ///
FK_COD_ETAPA_ENSINO FK_COD_CURSO_PROF PK_COD_ENTIDADE FK_COD_ESTADO ///
FK_COD_MUNICIPIO ID_DEPENDENCIA_ADM ID_LOCALIZACAO ///
DESC_CATEGORIA_ESCOLA_PRIVADA ID_CONVENIADA_PP ///
ID_TIPO_CONVENIO_PODER_PUBLICO ID_MANT_ESCOLA_PRIVADA_EMP ///
ID_MANT_ESCOLA_PRIVADA_ONG ID_MANT_ESCOLA_PRIVADA_SIND ///
ID_MANT_ESCOLA_PRIVADA_SIST_S ID_MANT_ESCOLA_PRIVADA_S_FINS ///
ID_DOCUMENTO_REGULAMENTACAO ID_LOCALIZACAO_DIFERENCIADA ID_EDUCACAO_INDIGENA)(ano id_docente mes_nascimento_docente ano_nascimento_docente /// 
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

foreach t in  2009 2010 2011 2012 2013 2014 {

import delimited C:\Users\Matheus\Desktop\docente\a`t'\DOCENTES_SUDESTE.CSV, delimiter("|") encoding(utf8) clear

rename *, upper

if `t' < 2011{
*pondo as que nao existem
gen ID_LINGUA_LITERAT_FRANCES = ""
gen ID_SITUACAO_CURSO_1 = ""
gen ID_SITUACAO_CURSO_2 = ""
gen ID_SITUACAO_CURSO_3 = ""
gen NU_ANO_INICIO_1 = ""
gen NU_ANO_INICIO_2 = ""
gen NU_ANO_INICIO_3 = ""
gen ID_PEDAGOGICA_1 = ""
gen ID_PEDAGOGICA_2 = ""
gen ID_PEDAGOGICA_3 = ""
gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
gen NUM_IDADE_REF_DOCENTE = ""
gen ID_ZONA_RESIDENCIAL = ""
gen ID_POSSUI_NEC_ESPECIAL = ""
gen ID_CEGUEIRA = ""
gen ID_BAIXA_VISAO = ""
gen ID_SURDEZ = ""
gen ID_DEF_AUDITIVA = ""
gen ID_SURDOCEGUEIRA = ""
gen ID_DEF_FISICA = ""
gen ID_DEF_INTELECTUAL = "" 
gen ID_DEF_MULTIPLA = ""
*gen FK_COD_ESCOLARIDADE = ""
*gen ID_SITUACAO_CURSO_1 = ""
*gen ID_SITUACAO_CURSO_2 = ""
*gen ID_SITUACAO_CURSO_3 = ""
gen ID_COM_PEDAGOGICA_1 = ""
gen ID_COM_PEDAGOGICA_2 = ""
gen ID_COM_PEDAGOGICA_3 = ""
gen ID_ESPECIFICO_CAMPO = ""
gen ID_ESPECIFICO_AMBIENTAL = ""
gen ID_ESPECIFICO_DIR_HUMANOS = ""
gen ID_ESPECIFICO_DIV_SEXUAL = ""
gen ID_ESPECIFICO_DIR_ADOLESC = ""
gen ID_ESPECIFICO_AFRO = ""
gen ID_ESPECIFICO_OUTROS = ""
gen ID_SOCIOLOGIA = ""
gen ID_ESPECIFICO_ANOS_INICIAIS = ""
gen ID_ESPECIFICO_ANOS_FINAIS = ""
gen ID_ESPECIFICO_ENS_MEDIO = ""
gen ID_ESPECIFICO_EJA = ""
gen ID_TIPO_CONTRATACAO = ""
gen ID_MANT_ESCOLA_PRIVADA_SIST_S = ""
replace TP_SEXO = "1" if TP_SEXO == "M"
replace TP_SEXO = "2" if TP_SEXO == "F"

}

if `t' == 2011 {

gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
gen NUM_IDADE_REF_DOCENTE = ""
gen ID_ZONA_RESIDENCIAL = ""
gen ID_POSSUI_NEC_ESPECIAL = ""
gen ID_CEGUEIRA = ""
gen ID_BAIXA_VISAO = ""
gen ID_SURDEZ = ""
gen ID_DEF_AUDITIVA = ""
gen ID_SURDOCEGUEIRA = ""
gen ID_DEF_FISICA = ""
gen ID_DEF_INTELECTUAL = "" 
gen ID_DEF_MULTIPLA = ""
*gen FK_COD_ESCOLARIDADE = ""
*gen ID_SITUACAO_CURSO_1 = ""
*gen ID_SITUACAO_CURSO_2 = ""
*gen ID_SITUACAO_CURSO_3 = ""
gen ID_ESPECIFICO_CAMPO = ""
gen ID_ESPECIFICO_AMBIENTAL = ""
gen ID_ESPECIFICO_DIR_HUMANOS = ""
gen ID_ESPECIFICO_DIV_SEXUAL = ""
gen ID_ESPECIFICO_DIR_ADOLESC = ""
gen ID_ESPECIFICO_AFRO = ""
*gen ID_ESPECIFICO_OUTROS = ""
gen ID_LINGUA_LITERAT_FRANCES = ""
gen ID_SOCIOLOGIA = ""
*gen ID_ESPECIFICO_ANOS_INICIAIS = ""
*gen ID_ESPECIFICO_ANOS_FINAIS = ""
*gen ID_ESPECIFICO_ENS_MEDIO = ""
*gen ID_ESPECIFICO_EJA = ""
gen ID_MANT_ESCOLA_PRIVADA_SIST_S = ""
replace TP_SEXO = "1" if TP_SEXO == "M"
replace TP_SEXO = "2" if TP_SEXO == "F"
}


if `t' > 2011 & `t' < 2014{

gen NUM_IDADE_REF_DOCENTE = ""
gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
replace TP_SEXO = "1" if TP_SEXO == "M"
replace TP_SEXO = "2" if TP_SEXO == "F"
}


if `t' == 2014 {

gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
}

keep ANO_CENSO FK_COD_DOCENTE NU_MES NU_ANO NU_DIA NUM_IDADE NUM_IDADE_REF_DOCENTE ///
TP_SEXO TP_COR_RACA TP_NACIONALIDADE FK_COD_PAIS_ORIGEM FK_COD_ESTADO_DNASC FK_COD_MUNICIPIO_DNASC FK_COD_ESTADO_DEND ///
FK_COD_MUNICIPIO_DEND ID_ZONA_RESIDENCIAL ID_POSSUI_NEC_ESPECIAL ID_CEGUEIRA ///
ID_BAIXA_VISAO ID_SURDEZ ID_DEF_AUDITIVA ID_SURDOCEGUEIRA ID_DEF_FISICA ID_DEF_INTELECTUAL ///
ID_DEF_MULTIPLA FK_COD_ESCOLARIDADE ID_SITUACAO_CURSO_1 FK_CLASSE_CURSO_1 ///
FK_COD_AREA_OCDE_1 ID_LICENCIATURA_1 ID_COM_PEDAGOGICA_1 NU_ANO_INICIO_1 ///
NU_ANO_CONCLUSAO_1 ID_TIPO_INSTITUICAO_1 FK_COD_IES_1 ID_SITUACAO_CURSO_2 ///
FK_CLASSE_CURSO_2 FK_COD_AREA_OCDE_2 ID_LICENCIATURA_2 ID_COM_PEDAGOGICA_2 ///
NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 ID_TIPO_INSTITUICAO_2 FK_COD_IES_2 ///
ID_SITUACAO_CURSO_3 FK_CLASSE_CURSO_3 FK_COD_AREA_OCDE_3 ID_LICENCIATURA_3 ///
ID_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 NU_ANO_CONCLUSAO_3 ID_TIPO_INSTITUICAO_3 ///
FK_COD_IES_3 ID_QUIMICA ID_FISICA ID_MATEMATICA ID_BIOLOGIA ///
ID_CIENCIAS ID_LINGUA_LITERAT_PORTUGUESA ID_LINGUA_LITERAT_INGLES ///
ID_LINGUA_LITERAT_ESPANHOL ID_LINGUA_LITERAT_FRANCES ID_LINGUA_LITERAT_OUTRA ///
ID_LINGUA_LITERAT_INDIGENA ID_ARTES ID_EDUCACAO_FISICA ID_HISTORIA ID_GEOGRAFIA ///
ID_FILOSOFIA ID_ENSINO_RELIGIOSO ID_ESTUDOS_SOCIAIS ID_SOCIOLOGIA ///
ID_INFORMATICA_COMPUTACAO ID_PROFISSIONALIZANTE ID_DISC_ATENDIMENTO_ESPECIAIS ///
ID_DISC_DIVERSIDADE_SOCIO_CULT ID_LIBRAS ID_DISCIPLINAS_PEDAG ///
ID_OUTRAS_DISCIPLINAS ID_ESPECIALIZACAO ID_MESTRADO ID_DOUTORADO ///
ID_POS_GRADUACAO_NENHUM ID_ESPECIFICO_CRECHE ID_ESPECIFICO_PRE_ESCOLA ID_ESPECIFICO_ANOS_INICIAIS ///
ID_ESPECIFICO_ANOS_FINAIS ID_ESPECIFICO_ENS_MEDIO ID_ESPECIFICO_EJA ID_ESPECIFICO_NEC_ESP ///
ID_ESPECIFICO_ED_INDIGENA ID_ESPECIFICO_CAMPO ID_ESPECIFICO_AMBIENTAL ///
ID_ESPECIFICO_DIR_HUMANOS ID_ESPECIFICO_DIV_SEXUAL ID_ESPECIFICO_DIR_ADOLESC ///
ID_ESPECIFICO_AFRO ID_ESPECIFICO_OUTROS ID_ESPECIFICO_NENHUM ///
ID_TIPO_DOCENTE ID_TIPO_CONTRATACAO PK_COD_TURMA FK_COD_TIPO_TURMA TP_MEDIACAO_DIDATICO_PEDAGO ///
IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE ///
FK_COD_ETAPA_ENSINO FK_COD_CURSO_PROF PK_COD_ENTIDADE FK_COD_ESTADO ///
FK_COD_MUNICIPIO ID_DEPENDENCIA_ADM ID_LOCALIZACAO ///
DESC_CATEGORIA_ESCOLA_PRIVADA ID_CONVENIADA_PP ///
ID_TIPO_CONVENIO_PODER_PUBLICO ID_MANT_ESCOLA_PRIVADA_EMP ///
ID_MANT_ESCOLA_PRIVADA_ONG ID_MANT_ESCOLA_PRIVADA_SIND ///
ID_MANT_ESCOLA_PRIVADA_SIST_S ID_MANT_ESCOLA_PRIVADA_S_FINS ///
ID_DOCUMENTO_REGULAMENTACAO ID_LOCALIZACAO_DIFERENCIADA ID_EDUCACAO_INDIGENA




*renomeando as variaveis

rename (ANO_CENSO FK_COD_DOCENTE NU_MES NU_ANO NU_DIA NUM_IDADE NUM_IDADE_REF_DOCENTE ///
TP_SEXO TP_COR_RACA TP_NACIONALIDADE FK_COD_PAIS_ORIGEM FK_COD_ESTADO_DNASC FK_COD_MUNICIPIO_DNASC FK_COD_ESTADO_DEND ///
FK_COD_MUNICIPIO_DEND ID_ZONA_RESIDENCIAL ID_POSSUI_NEC_ESPECIAL ID_CEGUEIRA ///
ID_BAIXA_VISAO ID_SURDEZ ID_DEF_AUDITIVA ID_SURDOCEGUEIRA ID_DEF_FISICA ID_DEF_INTELECTUAL ///
ID_DEF_MULTIPLA FK_COD_ESCOLARIDADE ID_SITUACAO_CURSO_1 FK_CLASSE_CURSO_1 ///
FK_COD_AREA_OCDE_1 ID_LICENCIATURA_1 ID_COM_PEDAGOGICA_1 NU_ANO_INICIO_1 ///
NU_ANO_CONCLUSAO_1 ID_TIPO_INSTITUICAO_1 FK_COD_IES_1 ID_SITUACAO_CURSO_2 ///
FK_CLASSE_CURSO_2 FK_COD_AREA_OCDE_2 ID_LICENCIATURA_2 ID_COM_PEDAGOGICA_2 ///
NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 ID_TIPO_INSTITUICAO_2 FK_COD_IES_2 ///
ID_SITUACAO_CURSO_3 FK_CLASSE_CURSO_3 FK_COD_AREA_OCDE_3 ID_LICENCIATURA_3 ///
ID_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 NU_ANO_CONCLUSAO_3 ID_TIPO_INSTITUICAO_3 ///
FK_COD_IES_3 ID_QUIMICA ID_FISICA ID_MATEMATICA ID_BIOLOGIA ///
ID_CIENCIAS ID_LINGUA_LITERAT_PORTUGUESA ID_LINGUA_LITERAT_INGLES ///
ID_LINGUA_LITERAT_ESPANHOL ID_LINGUA_LITERAT_FRANCES ID_LINGUA_LITERAT_OUTRA ///
ID_LINGUA_LITERAT_INDIGENA ID_ARTES ID_EDUCACAO_FISICA ID_HISTORIA ID_GEOGRAFIA ///
ID_FILOSOFIA ID_ENSINO_RELIGIOSO ID_ESTUDOS_SOCIAIS ID_SOCIOLOGIA ///
ID_INFORMATICA_COMPUTACAO ID_PROFISSIONALIZANTE ID_DISC_ATENDIMENTO_ESPECIAIS ///
ID_DISC_DIVERSIDADE_SOCIO_CULT ID_LIBRAS ID_DISCIPLINAS_PEDAG ///
ID_OUTRAS_DISCIPLINAS ID_ESPECIALIZACAO ID_MESTRADO ID_DOUTORADO ///
ID_POS_GRADUACAO_NENHUM ID_ESPECIFICO_CRECHE ID_ESPECIFICO_PRE_ESCOLA ID_ESPECIFICO_ANOS_INICIAIS ///
ID_ESPECIFICO_ANOS_FINAIS ID_ESPECIFICO_ENS_MEDIO ID_ESPECIFICO_EJA ID_ESPECIFICO_NEC_ESP ///
ID_ESPECIFICO_ED_INDIGENA ID_ESPECIFICO_CAMPO ID_ESPECIFICO_AMBIENTAL ///
ID_ESPECIFICO_DIR_HUMANOS ID_ESPECIFICO_DIV_SEXUAL ID_ESPECIFICO_DIR_ADOLESC ///
ID_ESPECIFICO_AFRO ID_ESPECIFICO_OUTROS ID_ESPECIFICO_NENHUM ///
ID_TIPO_DOCENTE ID_TIPO_CONTRATACAO PK_COD_TURMA FK_COD_TIPO_TURMA TP_MEDIACAO_DIDATICO_PEDAGO ///
IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE ///
FK_COD_ETAPA_ENSINO FK_COD_CURSO_PROF PK_COD_ENTIDADE FK_COD_ESTADO ///
FK_COD_MUNICIPIO ID_DEPENDENCIA_ADM ID_LOCALIZACAO ///
DESC_CATEGORIA_ESCOLA_PRIVADA ID_CONVENIADA_PP ///
ID_TIPO_CONVENIO_PODER_PUBLICO ID_MANT_ESCOLA_PRIVADA_EMP ///
ID_MANT_ESCOLA_PRIVADA_ONG ID_MANT_ESCOLA_PRIVADA_SIND ///
ID_MANT_ESCOLA_PRIVADA_SIST_S ID_MANT_ESCOLA_PRIVADA_S_FINS ///
ID_DOCUMENTO_REGULAMENTACAO ID_LOCALIZACAO_DIFERENCIADA ID_EDUCACAO_INDIGENA)(ano id_docente mes_nascimento_docente ano_nascimento_docente /// 
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
mant_escola_privada_sist_s mant_escola_privada_s_fins regulamentacao localizacao_diferenciada educacao_indigena)

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





foreach estado in MG RJ ES SP {
	preserve
keep if sigla_uf == "`estado'"
drop ano sigla_uf id_uf
export delimited "C:/Users/Matheus/Desktop/particionadastata/ano=`t'/sigla_uf=`estado'/microdados_`estado'.csv" , replace
	restore
	
	}
}



*SUL


foreach t in  2009 2010 2011 2012 2013 2014 {

import delimited C:\Users\Matheus\Desktop\docente\a`t'\DOCENTES_SUL.CSV, delimiter("|") encoding(utf8) clear

rename *, upper

if `t' < 2011{
*pondo as que nao existem
gen ID_LINGUA_LITERAT_FRANCES = ""
gen ID_SITUACAO_CURSO_1 = ""
gen ID_SITUACAO_CURSO_2 = ""
gen ID_SITUACAO_CURSO_3 = ""
gen NU_ANO_INICIO_1 = ""
gen NU_ANO_INICIO_2 = ""
gen NU_ANO_INICIO_3 = ""
gen ID_PEDAGOGICA_1 = ""
gen ID_PEDAGOGICA_2 = ""
gen ID_PEDAGOGICA_3 = ""
gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
gen NUM_IDADE_REF_DOCENTE = ""
gen ID_ZONA_RESIDENCIAL = ""
gen ID_POSSUI_NEC_ESPECIAL = ""
gen ID_CEGUEIRA = ""
gen ID_BAIXA_VISAO = ""
gen ID_SURDEZ = ""
gen ID_DEF_AUDITIVA = ""
gen ID_SURDOCEGUEIRA = ""
gen ID_DEF_FISICA = ""
gen ID_DEF_INTELECTUAL = "" 
gen ID_DEF_MULTIPLA = ""
*gen FK_COD_ESCOLARIDADE = ""
*gen ID_SITUACAO_CURSO_1 = ""
*gen ID_SITUACAO_CURSO_2 = ""
*gen ID_SITUACAO_CURSO_3 = ""
gen ID_COM_PEDAGOGICA_1 = ""
gen ID_COM_PEDAGOGICA_2 = ""
gen ID_COM_PEDAGOGICA_3 = ""
gen ID_ESPECIFICO_CAMPO = ""
gen ID_ESPECIFICO_AMBIENTAL = ""
gen ID_ESPECIFICO_DIR_HUMANOS = ""
gen ID_ESPECIFICO_DIV_SEXUAL = ""
gen ID_ESPECIFICO_DIR_ADOLESC = ""
gen ID_ESPECIFICO_AFRO = ""
gen ID_ESPECIFICO_OUTROS = ""
gen ID_SOCIOLOGIA = ""
gen ID_ESPECIFICO_ANOS_INICIAIS = ""
gen ID_ESPECIFICO_ANOS_FINAIS = ""
gen ID_ESPECIFICO_ENS_MEDIO = ""
gen ID_ESPECIFICO_EJA = ""
gen ID_TIPO_CONTRATACAO = ""
gen ID_MANT_ESCOLA_PRIVADA_SIST_S = ""
replace TP_SEXO = "1" if TP_SEXO == "M"
replace TP_SEXO = "2" if TP_SEXO == "F"

}

if `t' == 2011 {

gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
gen NUM_IDADE_REF_DOCENTE = ""
gen ID_ZONA_RESIDENCIAL = ""
gen ID_POSSUI_NEC_ESPECIAL = ""
gen ID_CEGUEIRA = ""
gen ID_BAIXA_VISAO = ""
gen ID_SURDEZ = ""
gen ID_DEF_AUDITIVA = ""
gen ID_SURDOCEGUEIRA = ""
gen ID_DEF_FISICA = ""
gen ID_DEF_INTELECTUAL = "" 
gen ID_DEF_MULTIPLA = ""
*gen FK_COD_ESCOLARIDADE = ""
*gen ID_SITUACAO_CURSO_1 = ""
*gen ID_SITUACAO_CURSO_2 = ""
*gen ID_SITUACAO_CURSO_3 = ""
gen ID_ESPECIFICO_CAMPO = ""
gen ID_ESPECIFICO_AMBIENTAL = ""
gen ID_ESPECIFICO_DIR_HUMANOS = ""
gen ID_ESPECIFICO_DIV_SEXUAL = ""
gen ID_ESPECIFICO_DIR_ADOLESC = ""
gen ID_ESPECIFICO_AFRO = ""
*gen ID_ESPECIFICO_OUTROS = ""
gen ID_LINGUA_LITERAT_FRANCES = ""
gen ID_SOCIOLOGIA = ""
*gen ID_ESPECIFICO_ANOS_INICIAIS = ""
*gen ID_ESPECIFICO_ANOS_FINAIS = ""
*gen ID_ESPECIFICO_ENS_MEDIO = ""
*gen ID_ESPECIFICO_EJA = ""
gen ID_MANT_ESCOLA_PRIVADA_SIST_S = ""
replace TP_SEXO = "1" if TP_SEXO == "M"
replace TP_SEXO = "2" if TP_SEXO == "F"

}


if `t' > 2011 & `t' < 2014{

gen NUM_IDADE_REF_DOCENTE = ""
gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
replace TP_SEXO = "1" if TP_SEXO == "M"
replace TP_SEXO = "2" if TP_SEXO == "F"
}


if `t' == 2014 {

gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
gen IN_ESPECIAL_EXCLUSIVA = ""
gen IN_REGULAR = ""
gen IN_EJA = ""
gen IN_PROFISSIONALIZANTE = ""
}

keep ANO_CENSO FK_COD_DOCENTE NU_MES NU_ANO NU_DIA NUM_IDADE NUM_IDADE_REF_DOCENTE ///
TP_SEXO TP_COR_RACA TP_NACIONALIDADE FK_COD_PAIS_ORIGEM FK_COD_ESTADO_DNASC FK_COD_MUNICIPIO_DNASC FK_COD_ESTADO_DEND ///
FK_COD_MUNICIPIO_DEND ID_ZONA_RESIDENCIAL ID_POSSUI_NEC_ESPECIAL ID_CEGUEIRA ///
ID_BAIXA_VISAO ID_SURDEZ ID_DEF_AUDITIVA ID_SURDOCEGUEIRA ID_DEF_FISICA ID_DEF_INTELECTUAL ///
ID_DEF_MULTIPLA FK_COD_ESCOLARIDADE ID_SITUACAO_CURSO_1 FK_CLASSE_CURSO_1 ///
FK_COD_AREA_OCDE_1 ID_LICENCIATURA_1 ID_COM_PEDAGOGICA_1 NU_ANO_INICIO_1 ///
NU_ANO_CONCLUSAO_1 ID_TIPO_INSTITUICAO_1 FK_COD_IES_1 ID_SITUACAO_CURSO_2 ///
FK_CLASSE_CURSO_2 FK_COD_AREA_OCDE_2 ID_LICENCIATURA_2 ID_COM_PEDAGOGICA_2 ///
NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 ID_TIPO_INSTITUICAO_2 FK_COD_IES_2 ///
ID_SITUACAO_CURSO_3 FK_CLASSE_CURSO_3 FK_COD_AREA_OCDE_3 ID_LICENCIATURA_3 ///
ID_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 NU_ANO_CONCLUSAO_3 ID_TIPO_INSTITUICAO_3 ///
FK_COD_IES_3 ID_QUIMICA ID_FISICA ID_MATEMATICA ID_BIOLOGIA ///
ID_CIENCIAS ID_LINGUA_LITERAT_PORTUGUESA ID_LINGUA_LITERAT_INGLES ///
ID_LINGUA_LITERAT_ESPANHOL ID_LINGUA_LITERAT_FRANCES ID_LINGUA_LITERAT_OUTRA ///
ID_LINGUA_LITERAT_INDIGENA ID_ARTES ID_EDUCACAO_FISICA ID_HISTORIA ID_GEOGRAFIA ///
ID_FILOSOFIA ID_ENSINO_RELIGIOSO ID_ESTUDOS_SOCIAIS ID_SOCIOLOGIA ///
ID_INFORMATICA_COMPUTACAO ID_PROFISSIONALIZANTE ID_DISC_ATENDIMENTO_ESPECIAIS ///
ID_DISC_DIVERSIDADE_SOCIO_CULT ID_LIBRAS ID_DISCIPLINAS_PEDAG ///
ID_OUTRAS_DISCIPLINAS ID_ESPECIALIZACAO ID_MESTRADO ID_DOUTORADO ///
ID_POS_GRADUACAO_NENHUM ID_ESPECIFICO_CRECHE ID_ESPECIFICO_PRE_ESCOLA ID_ESPECIFICO_ANOS_INICIAIS ///
ID_ESPECIFICO_ANOS_FINAIS ID_ESPECIFICO_ENS_MEDIO ID_ESPECIFICO_EJA ID_ESPECIFICO_NEC_ESP ///
ID_ESPECIFICO_ED_INDIGENA ID_ESPECIFICO_CAMPO ID_ESPECIFICO_AMBIENTAL ///
ID_ESPECIFICO_DIR_HUMANOS ID_ESPECIFICO_DIV_SEXUAL ID_ESPECIFICO_DIR_ADOLESC ///
ID_ESPECIFICO_AFRO ID_ESPECIFICO_OUTROS ID_ESPECIFICO_NENHUM ///
ID_TIPO_DOCENTE ID_TIPO_CONTRATACAO PK_COD_TURMA FK_COD_TIPO_TURMA TP_MEDIACAO_DIDATICO_PEDAGO ///
IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE ///
FK_COD_ETAPA_ENSINO FK_COD_CURSO_PROF PK_COD_ENTIDADE FK_COD_ESTADO ///
FK_COD_MUNICIPIO ID_DEPENDENCIA_ADM ID_LOCALIZACAO ///
DESC_CATEGORIA_ESCOLA_PRIVADA ID_CONVENIADA_PP ///
ID_TIPO_CONVENIO_PODER_PUBLICO ID_MANT_ESCOLA_PRIVADA_EMP ///
ID_MANT_ESCOLA_PRIVADA_ONG ID_MANT_ESCOLA_PRIVADA_SIND ///
ID_MANT_ESCOLA_PRIVADA_SIST_S ID_MANT_ESCOLA_PRIVADA_S_FINS ///
ID_DOCUMENTO_REGULAMENTACAO ID_LOCALIZACAO_DIFERENCIADA ID_EDUCACAO_INDIGENA




*renomeando as variaveis

rename (ANO_CENSO FK_COD_DOCENTE NU_MES NU_ANO NU_DIA NUM_IDADE NUM_IDADE_REF_DOCENTE ///
TP_SEXO TP_COR_RACA TP_NACIONALIDADE FK_COD_PAIS_ORIGEM FK_COD_ESTADO_DNASC FK_COD_MUNICIPIO_DNASC FK_COD_ESTADO_DEND ///
FK_COD_MUNICIPIO_DEND ID_ZONA_RESIDENCIAL ID_POSSUI_NEC_ESPECIAL ID_CEGUEIRA ///
ID_BAIXA_VISAO ID_SURDEZ ID_DEF_AUDITIVA ID_SURDOCEGUEIRA ID_DEF_FISICA ID_DEF_INTELECTUAL ///
ID_DEF_MULTIPLA FK_COD_ESCOLARIDADE ID_SITUACAO_CURSO_1 FK_CLASSE_CURSO_1 ///
FK_COD_AREA_OCDE_1 ID_LICENCIATURA_1 ID_COM_PEDAGOGICA_1 NU_ANO_INICIO_1 ///
NU_ANO_CONCLUSAO_1 ID_TIPO_INSTITUICAO_1 FK_COD_IES_1 ID_SITUACAO_CURSO_2 ///
FK_CLASSE_CURSO_2 FK_COD_AREA_OCDE_2 ID_LICENCIATURA_2 ID_COM_PEDAGOGICA_2 ///
NU_ANO_INICIO_2 NU_ANO_CONCLUSAO_2 ID_TIPO_INSTITUICAO_2 FK_COD_IES_2 ///
ID_SITUACAO_CURSO_3 FK_CLASSE_CURSO_3 FK_COD_AREA_OCDE_3 ID_LICENCIATURA_3 ///
ID_COM_PEDAGOGICA_3 NU_ANO_INICIO_3 NU_ANO_CONCLUSAO_3 ID_TIPO_INSTITUICAO_3 ///
FK_COD_IES_3 ID_QUIMICA ID_FISICA ID_MATEMATICA ID_BIOLOGIA ///
ID_CIENCIAS ID_LINGUA_LITERAT_PORTUGUESA ID_LINGUA_LITERAT_INGLES ///
ID_LINGUA_LITERAT_ESPANHOL ID_LINGUA_LITERAT_FRANCES ID_LINGUA_LITERAT_OUTRA ///
ID_LINGUA_LITERAT_INDIGENA ID_ARTES ID_EDUCACAO_FISICA ID_HISTORIA ID_GEOGRAFIA ///
ID_FILOSOFIA ID_ENSINO_RELIGIOSO ID_ESTUDOS_SOCIAIS ID_SOCIOLOGIA ///
ID_INFORMATICA_COMPUTACAO ID_PROFISSIONALIZANTE ID_DISC_ATENDIMENTO_ESPECIAIS ///
ID_DISC_DIVERSIDADE_SOCIO_CULT ID_LIBRAS ID_DISCIPLINAS_PEDAG ///
ID_OUTRAS_DISCIPLINAS ID_ESPECIALIZACAO ID_MESTRADO ID_DOUTORADO ///
ID_POS_GRADUACAO_NENHUM ID_ESPECIFICO_CRECHE ID_ESPECIFICO_PRE_ESCOLA ID_ESPECIFICO_ANOS_INICIAIS ///
ID_ESPECIFICO_ANOS_FINAIS ID_ESPECIFICO_ENS_MEDIO ID_ESPECIFICO_EJA ID_ESPECIFICO_NEC_ESP ///
ID_ESPECIFICO_ED_INDIGENA ID_ESPECIFICO_CAMPO ID_ESPECIFICO_AMBIENTAL ///
ID_ESPECIFICO_DIR_HUMANOS ID_ESPECIFICO_DIV_SEXUAL ID_ESPECIFICO_DIR_ADOLESC ///
ID_ESPECIFICO_AFRO ID_ESPECIFICO_OUTROS ID_ESPECIFICO_NENHUM ///
ID_TIPO_DOCENTE ID_TIPO_CONTRATACAO PK_COD_TURMA FK_COD_TIPO_TURMA TP_MEDIACAO_DIDATICO_PEDAGO ///
IN_ESPECIAL_EXCLUSIVA IN_REGULAR IN_EJA IN_PROFISSIONALIZANTE ///
FK_COD_ETAPA_ENSINO FK_COD_CURSO_PROF PK_COD_ENTIDADE FK_COD_ESTADO ///
FK_COD_MUNICIPIO ID_DEPENDENCIA_ADM ID_LOCALIZACAO ///
DESC_CATEGORIA_ESCOLA_PRIVADA ID_CONVENIADA_PP ///
ID_TIPO_CONVENIO_PODER_PUBLICO ID_MANT_ESCOLA_PRIVADA_EMP ///
ID_MANT_ESCOLA_PRIVADA_ONG ID_MANT_ESCOLA_PRIVADA_SIND ///
ID_MANT_ESCOLA_PRIVADA_SIST_S ID_MANT_ESCOLA_PRIVADA_S_FINS ///
ID_DOCUMENTO_REGULAMENTACAO ID_LOCALIZACAO_DIFERENCIADA ID_EDUCACAO_INDIGENA)(ano id_docente mes_nascimento_docente ano_nascimento_docente /// 
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
