*censo turmas
cd "C:\Users\Matheus\Desktop\turmas"


**bases de apoio
import delimited "filtro_primeira_parte.csv" clear

*AUT_ESCOLAR é na verdade ID_AUTONOMA em 2009 e 2010

*criando diretorio
foreach ano in 2009 2010 2011 2012 2013 2014{
mkdir "C:/Users/Matheus/Desktop/turmaspart/ano=`ano'"

foreach estado in AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO {


mkdir "C:/Users/Matheus/Desktop/turmaspart/ano=`ano'/sigla_uf=`estado'"
}
}



**primeiros anos: 2009 a 2014

foreach i in 2009 2010 2011 2012 2013 2014{

import delimited "anos\a`i'\TURMAS.CSV", delimiter("|") case(preserve) encoding(utf8) clear 

if `i' <= 2010 {

di `i'
gen ID_LINGUA_LITERAT_FRANCES = ""
gen ID_SOCIOLOGIA = ""
gen ID_MANT_ESCOLA_PRIVADA_SIST_S = ""
ren ID_AUTONOMA ID_AUT_ESCOLAR

foreach p in DOMINGO SEGUNDA TERCA QUARTA QUINTA SEXTA SABADO {

gen ID_DIA_SEMANA_`p' = ""
}
}

*caso de 2011 
if `i' == 2011 {

di `i'
gen ID_LINGUA_LITERAT_FRANCES = ""
gen ID_SOCIOLOGIA = ""
gen ID_MANT_ESCOLA_PRIVADA_SIST_S = ""

foreach p in DOMINGO SEGUNDA TERCA QUARTA QUINTA SEXTA SABADO {

gen ID_DIA_SEMANA_`p' = ""
}

}

*caso de 2012 em diante
else if `i' > 2011 {

di `i'
gen ID_VEZ_ATIVIDADE_COMPLEMENTAR = ""

}

keep ANO_CENSO PK_COD_TURMA HR_INICIAL HR_INICIAL_MINUTO NU_DURACAO_TURMA NUM_MATRICULAS FK_COD_ETAPA_ENSINO ///
FK_COD_CURSO_PROF FK_COD_TIPO_TURMA FK_COD_TIPO_ATIVIDADE_1 FK_COD_TIPO_ATIVIDADE_2 /// 
FK_COD_TIPO_ATIVIDADE_3 FK_COD_TIPO_ATIVIDADE_4 FK_COD_TIPO_ATIVIDADE_5 FK_COD_TIPO_ATIVIDADE_6 ID_VEZ_ATIVIDADE_COMPLEMENTAR ///
ID_BRAILLE ID_RECURSOS_BAIXA_VISAO ID_PROCESSOS_MENTAIS ID_ORIENTACAO_MOBILIDADE ID_SINAIS ID_COM_ALT_AUMENT ID_ENRIQ_CURRICULAR ID_SOROBAN ///
ID_INF_ACESSIVEL ID_PORT_ESC ID_AUT_ESCOLAR ID_QUIMICA ID_FISICA ID_MATEMATICA ID_BIOLOGIA ID_CIENCIAS ID_LINGUA_LITERAT_PORTUGUESA ///
ID_LINGUA_LITERAT_INGLES ID_LINGUA_LITERAT_ESPANHOL ID_LINGUA_LITERAT_FRANCES ID_LINGUA_LITERAT_OUTRA ID_LINGUA_LITERAT_INDIGENA ID_ARTES ///
ID_EDUCACAO_FISICA ID_HISTORIA ID_GEOGRAFIA ID_FILOSOFIA ID_ENSINO_RELIGIOSO ID_ESTUDOS_SOCIAIS ID_SOCIOLOGIA ID_INFORMATICA_COMPUTACAO ///
ID_PROFISSIONALIZANTE ID_DISC_ATENDIMENTO_ESPECIAIS ID_DISC_DIVERSIDADE_SOCIO_CULT ID_LIBRAS ID_DISCIPLINAS_PEDAG ///
ID_OUTRAS_DISCIPLINAS PK_COD_ENTIDADE FK_COD_ESTADO FK_COD_MUNICIPIO ID_LOCALIZACAO ID_DEPENDENCIA_ADM ///
DESC_CATEGORIA_ESCOLA_PRIVADA ID_CONVENIADA_PP ID_TIPO_CONVENIO_PODER_PUBLICO ID_MANT_ESCOLA_PRIVADA_EMP ID_MANT_ESCOLA_PRIVADA_ONG ///
ID_MANT_ESCOLA_PRIVADA_SIND ID_MANT_ESCOLA_PRIVADA_SIST_S ID_MANT_ESCOLA_PRIVADA_S_FINS ID_DOCUMENTO_REGULAMENTACAO ID_LOCALIZACAO_DIFERENCIADA ID_EDUCACAO_INDIGENA /// 
ID_DIA_SEMANA_DOMINGO ID_DIA_SEMANA_SEGUNDA ID_DIA_SEMANA_TERCA ID_DIA_SEMANA_QUARTA ID_DIA_SEMANA_QUINTA ID_DIA_SEMANA_SEXTA ID_DIA_SEMANA_SABADO

rename ANO_CENSO ano
rename PK_COD_TURMA id_turma
rename HR_INICIAL hora_inicial 
rename HR_INICIAL_MINUTO minuto_inicial
rename NU_DURACAO_TURMA numero_duracao_turma
rename NUM_MATRICULAS quantidade_matriculas
rename FK_COD_ETAPA_ENSINO tipo_etapa_ensino 
rename FK_COD_CURSO_PROF id_curso_educ_profissional
rename FK_COD_TIPO_TURMA tipo_turma
rename FK_COD_TIPO_ATIVIDADE_1 id_tipo_atividade_1
rename FK_COD_TIPO_ATIVIDADE_2 id_tipo_atividade_2 
rename FK_COD_TIPO_ATIVIDADE_3 id_tipo_atividade_3
rename FK_COD_TIPO_ATIVIDADE_4 id_tipo_atividade_4
rename FK_COD_TIPO_ATIVIDADE_5 id_tipo_atividade_5
rename FK_COD_TIPO_ATIVIDADE_6 id_tipo_atividade_6
rename ID_VEZ_ATIVIDADE_COMPLEMENTAR numero_dias_atividade
rename ID_BRAILLE braille
rename ID_RECURSOS_BAIXA_VISAO recursos_baixa_visao
rename ID_PROCESSOS_MENTAIS processos_mentais
rename ID_ORIENTACAO_MOBILIDADE orientacao_mobilidade
rename ID_SINAIS sinais
rename ID_COM_ALT_AUMENT comunicacao_alt_aument 
rename ID_ENRIQ_CURRICULAR enriquecimento_curricular
rename ID_SOROBAN soroban
rename ID_INF_ACESSIVEL informatica_acessivel
rename ID_PORT_ESC port_escrita
rename ID_AUT_ESCOLAR autonomia_escolar
rename ID_QUIMICA disciplina_quimica
rename ID_FISICA disciplina_fisica
rename ID_MATEMATICA disciplina_matematica
rename ID_BIOLOGIA disciplina_biologia
rename ID_CIENCIAS disciplina_ciencias
rename ID_LINGUA_LITERAT_PORTUGUESA disciplina_lingua_portuguesa
rename ID_LINGUA_LITERAT_INGLES disciplina_lingua_ingles
rename ID_LINGUA_LITERAT_ESPANHOL disciplina_lingua_espanhol
rename ID_LINGUA_LITERAT_FRANCES disciplina_lingua_frances
rename ID_LINGUA_LITERAT_OUTRA disciplina_lingua_outra
rename ID_LINGUA_LITERAT_INDIGENA disciplina_lingua_indigena
rename ID_ARTES disciplina_artes
rename ID_EDUCACAO_FISICA disciplina_educacao_fisica
rename ID_HISTORIA disciplina_historia
rename ID_GEOGRAFIA disciplina_geografia
rename ID_FILOSOFIA disciplina_filosofia
rename ID_ENSINO_RELIGIOSO disciplina_ensino_religioso
rename ID_ESTUDOS_SOCIAIS disciplina_estudos_sociais
rename ID_SOCIOLOGIA disciplina_sociologia
rename ID_INFORMATICA_COMPUTACAO disciplina_informatica_comp
rename ID_PROFISSIONALIZANTE disciplina_profissionalizante
rename ID_DISC_ATENDIMENTO_ESPECIAIS disciplina_atendimento_especiais
rename ID_DISC_DIVERSIDADE_SOCIO_CULT disciplina_diver_socio_cultural
rename ID_LIBRAS disciplina_libras
rename ID_DISCIPLINAS_PEDAG disciplina_pedagogicas
rename ID_OUTRAS_DISCIPLINAS disciplina_outras
rename PK_COD_ENTIDADE id_escola 
rename FK_COD_ESTADO sigla_uf
rename FK_COD_MUNICIPIO id_municipio
rename ID_LOCALIZACAO tipo_localizacao
rename ID_DEPENDENCIA_ADM rede
rename DESC_CATEGORIA_ESCOLA_PRIVADA tipo_categoria_escola_privada
rename ID_CONVENIADA_PP conveniada_poder_publico
rename ID_TIPO_CONVENIO_PODER_PUBLICO tipo_convenio_poder_publico
rename ID_MANT_ESCOLA_PRIVADA_EMP mantenedora_privada_emp
rename ID_MANT_ESCOLA_PRIVADA_ONG mantenedora_privada_ong
rename ID_MANT_ESCOLA_PRIVADA_SIND mantenedora_privada_sind
rename ID_MANT_ESCOLA_PRIVADA_SIST_S mantenedora_privada_sist_s
rename ID_MANT_ESCOLA_PRIVADA_S_FINS mantenedora_privada_s_fins
rename ID_DOCUMENTO_REGULAMENTACAO tipo_regulamentacao
rename ID_LOCALIZACAO_DIFERENCIADA tipo_localizacao_diferenciada
rename ID_EDUCACAO_INDIGENA educacao_indigena
rename ID_DIA_SEMANA_DOMINGO dia_semana_domingo
rename ID_DIA_SEMANA_SEGUNDA dia_semana_segunda
rename ID_DIA_SEMANA_TERCA dia_semana_terca
rename ID_DIA_SEMANA_QUARTA dia_semana_quarta
rename ID_DIA_SEMANA_QUINTA dia_semana_quinta
rename ID_DIA_SEMANA_SEXTA dia_semana_sexta
rename ID_DIA_SEMANA_SABADO dia_semana_sabado

*criando sigla_uf
tostring sigla_uf, replace
replace sigla_uf = "AL" if sigla_uf == "27"
replace sigla_uf = "BA" if sigla_uf == "29"
replace sigla_uf = "CE" if sigla_uf == "23"
replace sigla_uf = "MA" if sigla_uf == "21"
replace sigla_uf = "PB" if sigla_uf == "25"
replace sigla_uf = "PE" if sigla_uf == "26"
replace sigla_uf = "PI" if sigla_uf == "22"
replace sigla_uf = "RN" if sigla_uf == "24"
replace sigla_uf = "SE" if sigla_uf == "28"
replace sigla_uf = "PR" if sigla_uf == "41"
replace sigla_uf = "RS" if sigla_uf == "43"
replace sigla_uf = "SC" if sigla_uf == "42"
replace sigla_uf = "ES" if sigla_uf == "32"
replace sigla_uf = "SP" if sigla_uf == "35"
replace sigla_uf = "MG" if sigla_uf == "31"
replace sigla_uf = "RJ" if sigla_uf == "33"
replace sigla_uf = "AC" if sigla_uf == "12"
replace sigla_uf = "AM" if sigla_uf == "13"
replace sigla_uf = "AP" if sigla_uf == "16"
replace sigla_uf = "PA" if sigla_uf == "15"
replace sigla_uf = "RO" if sigla_uf == "11"
replace sigla_uf = "RR" if sigla_uf == "14"
replace sigla_uf = "TO" if sigla_uf == "17"
replace sigla_uf = "DF" if sigla_uf == "53"
replace sigla_uf = "GO" if sigla_uf == "52"
replace sigla_uf = "MS" if sigla_uf == "50"
replace sigla_uf = "MT" if sigla_uf == "51"

tostring rede, replace
replace rede = "federal" if rede == "1"
replace rede = "estadual" if rede == "2" 
replace rede = "municipal" if rede == "3"
replace rede = "privada" if rede == "4"


foreach estado in AC AM AP PA RO RR TO DF GO MS MT MG RJ ES SP PR RS SC AL BA CE MA PB PE PI RN SE {
	preserve
keep if sigla_uf == "`estado'"
drop ano sigla_uf sigla_uf
export delimited "C:/Users/Matheus/Desktop/turmaspart/ano=`i'/sigla_uf=`estado'/`i'_`estado'" , replace
	restore
	
	}

}








