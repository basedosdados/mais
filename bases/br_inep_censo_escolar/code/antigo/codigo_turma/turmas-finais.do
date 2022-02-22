***script para as bases de 2018 a 2020 que tem muita similaridade


**bases de apoio
import delimited "C:\Users\Matheus\Desktop\turmas\filtro_quinze.csv" delimiter(",") case(preserve) encoding(utf8) clear 
import delimited "C:\Users\Matheus\Desktop\turmas\filtro_definitivo.csv" delimiter(",") case(preserve) encoding(utf8) clear 

*criando diretorio
foreach ano in 2018 2019 2020{
mkdir "C:/Users/Matheus/Desktop/turmaspart/ano=`ano'"

foreach estado in AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO {


mkdir "C:/Users/Matheus/Desktop/turmaspart/ano=`ano'/sigla_uf=`estado'"
}
}


*loop em si
cd "C:\Users\Matheus\Desktop"

foreach i in 2019 2020{

import delimited "turmas\anos\a`i'\TURMAS.CSV", delimiter("|") case(preserve) encoding(utf8) clear 

di `i'

if `i' > 2018 {
gen TP_TIPO_TURMA = ""
gen IN_BRAILLE = ""
gen IN_RECURSOS_BAIXA_VISAO = ""
gen IN_PROCESSOS_MENTAIS = ""
gen IN_ORIENTACAO_MOBILIDADE = ""
gen IN_SINAIS = ""
gen IN_COMUNICACAO_ALT_AUMENT = ""
gen IN_ENRIQ_CURRICULAR = ""
gen IN_SOROBAN = ""
gen IN_INFORMATICA_ACESSIVEL = ""
gen IN_PORT_ESCRITA = ""
gen IN_AUTONOMIA_ESCOLAR = ""
gen IN_DISC_ATENDIMENTO_ESPECIAIS = ""
gen IN_DISC_DIVER_SOCIO_CULTURAL = ""
}

keep NU_ANO_CENSO ID_TURMA TX_HR_INICIAL TX_MI_INICIAL NU_DURACAO_TURMA QT_MATRICULAS TP_ETAPA_ENSINO CO_CURSO_EDUC_PROFISSIONAL TP_TIPO_TURMA ///
CO_TIPO_ATIVIDADE_1 CO_TIPO_ATIVIDADE_2 CO_TIPO_ATIVIDADE_3 CO_TIPO_ATIVIDADE_4 CO_TIPO_ATIVIDADE_5 CO_TIPO_ATIVIDADE_6 NU_DIAS_ATIVIDADE ///
IN_BRAILLE IN_RECURSOS_BAIXA_VISAO IN_PROCESSOS_MENTAIS IN_ORIENTACAO_MOBILIDADE IN_SINAIS IN_COMUNICACAO_ALT_AUMENT ///
IN_ENRIQ_CURRICULAR IN_SOROBAN IN_INFORMATICA_ACESSIVEL IN_PORT_ESCRITA IN_AUTONOMIA_ESCOLAR IN_DISC_QUIMICA IN_DISC_FISICA ///
IN_DISC_MATEMATICA IN_DISC_BIOLOGIA IN_DISC_CIENCIAS IN_DISC_LINGUA_PORTUGUESA IN_DISC_LINGUA_INGLES IN_DISC_LINGUA_ESPANHOL ///
IN_DISC_LINGUA_FRANCES IN_DISC_LINGUA_OUTRA IN_DISC_LINGUA_INDIGENA IN_DISC_ARTES IN_DISC_EDUCACAO_FISICA IN_DISC_HISTORIA IN_DISC_GEOGRAFIA ///
IN_DISC_FILOSOFIA IN_DISC_ENSINO_RELIGIOSO IN_DISC_ESTUDOS_SOCIAIS IN_DISC_SOCIOLOGIA IN_DISC_INFORMATICA_COMPUTACAO ///
IN_DISC_PROFISSIONALIZANTE IN_DISC_ATENDIMENTO_ESPECIAIS IN_DISC_DIVER_SOCIO_CULTURAL IN_DISC_LIBRAS IN_DISC_PEDAGOGICAS ///
IN_DISC_OUTRAS CO_ENTIDADE CO_UF CO_MUNICIPIO TP_LOCALIZACAO TP_DEPENDENCIA TP_CATEGORIA_ESCOLA_PRIVADA IN_CONVENIADA_PP ///
TP_CONVENIO_PODER_PUBLICO IN_MANT_ESCOLA_PRIVADA_EMP IN_MANT_ESCOLA_PRIVADA_ONG IN_MANT_ESCOLA_PRIVADA_SIND IN_MANT_ESCOLA_PRIVADA_SIST_S ///
IN_MANT_ESCOLA_PRIVADA_S_FINS TP_REGULAMENTACAO TP_LOCALIZACAO_DIFERENCIADA IN_EDUCACAO_INDIGENA IN_DIA_SEMANA_DOMINGO ///
IN_DIA_SEMANA_SEGUNDA IN_DIA_SEMANA_TERCA IN_DIA_SEMANA_QUARTA IN_DIA_SEMANA_QUINTA IN_DIA_SEMANA_SEXTA IN_DIA_SEMANA_SABADO


rename (NU_ANO_CENSO ID_TURMA TX_HR_INICIAL TX_MI_INICIAL NU_DURACAO_TURMA QT_MATRICULAS TP_ETAPA_ENSINO CO_CURSO_EDUC_PROFISSIONAL TP_TIPO_TURMA ///
CO_TIPO_ATIVIDADE_1 CO_TIPO_ATIVIDADE_2 CO_TIPO_ATIVIDADE_3 CO_TIPO_ATIVIDADE_4 CO_TIPO_ATIVIDADE_5 CO_TIPO_ATIVIDADE_6 NU_DIAS_ATIVIDADE ///
IN_BRAILLE IN_RECURSOS_BAIXA_VISAO IN_PROCESSOS_MENTAIS IN_ORIENTACAO_MOBILIDADE IN_SINAIS IN_COMUNICACAO_ALT_AUMENT ///
IN_ENRIQ_CURRICULAR IN_SOROBAN IN_INFORMATICA_ACESSIVEL IN_PORT_ESCRITA IN_AUTONOMIA_ESCOLAR IN_DISC_QUIMICA IN_DISC_FISICA ///
IN_DISC_MATEMATICA IN_DISC_BIOLOGIA IN_DISC_CIENCIAS IN_DISC_LINGUA_PORTUGUESA IN_DISC_LINGUA_INGLES IN_DISC_LINGUA_ESPANHOL ///
IN_DISC_LINGUA_FRANCES IN_DISC_LINGUA_OUTRA IN_DISC_LINGUA_INDIGENA IN_DISC_ARTES IN_DISC_EDUCACAO_FISICA IN_DISC_HISTORIA IN_DISC_GEOGRAFIA ///
IN_DISC_FILOSOFIA IN_DISC_ENSINO_RELIGIOSO IN_DISC_ESTUDOS_SOCIAIS IN_DISC_SOCIOLOGIA IN_DISC_INFORMATICA_COMPUTACAO ///
IN_DISC_PROFISSIONALIZANTE IN_DISC_ATENDIMENTO_ESPECIAIS IN_DISC_DIVER_SOCIO_CULTURAL IN_DISC_LIBRAS IN_DISC_PEDAGOGICAS ///
IN_DISC_OUTRAS CO_ENTIDADE CO_UF CO_MUNICIPIO TP_LOCALIZACAO TP_DEPENDENCIA TP_CATEGORIA_ESCOLA_PRIVADA IN_CONVENIADA_PP ///
TP_CONVENIO_PODER_PUBLICO IN_MANT_ESCOLA_PRIVADA_EMP IN_MANT_ESCOLA_PRIVADA_ONG IN_MANT_ESCOLA_PRIVADA_SIND IN_MANT_ESCOLA_PRIVADA_SIST_S ///
IN_MANT_ESCOLA_PRIVADA_S_FINS TP_REGULAMENTACAO TP_LOCALIZACAO_DIFERENCIADA IN_EDUCACAO_INDIGENA IN_DIA_SEMANA_DOMINGO ///
IN_DIA_SEMANA_SEGUNDA IN_DIA_SEMANA_TERCA IN_DIA_SEMANA_QUARTA IN_DIA_SEMANA_QUINTA IN_DIA_SEMANA_SEXTA IN_DIA_SEMANA_SABADO) (ano id_turma hora_inicial ///
minuto_inicial numero_duracao_turma quantidade_matriculas tipo_etapa_ensino id_curso_educ_profissional ///
tipo_turma id_tipo_atividade_1 id_tipo_atividade_2 id_tipo_atividade_3 id_tipo_atividade_4 id_tipo_atividade_5 id_tipo_atividade_6 ///
numero_dias_atividade braille recursos_baixa_visao processos_mentais orientacao_mobilidade sinais ///
comunicacao_alt_aument enriquecimento_curricular soroban informatica_acessivel port_escrita autonomia_escolar disciplina_quimica ///
disciplina_fisica disciplina_matematica disciplina_biologia disciplina_ciencias disciplina_lingua_portuguesa disciplina_lingua_ingles ///
disciplina_lingua_espanhol disciplina_lingua_frances disciplina_lingua_outra disciplina_lingua_indigena disciplina_artes ///
disciplina_educacao_fisica disciplina_historia disciplina_geografia disciplina_filosofia disciplina_ensino_religioso ///
disciplina_estudos_sociais disciplina_sociologia disciplina_informatica_comp disciplina_profissionalizante ///
disciplina_atendimento_especiais disciplina_diver_socio_cultural disciplina_libras disciplina_pedagogicas disciplina_outras ///
id_escola sigla_uf id_municipio tipo_localizacao rede tipo_categoria_escola_privada conveniada_poder_publico /// 
tipo_convenio_poder_publico mantenedora_privada_emp mantenedora_privada_ong mantenedora_privada_sind ///
mantenedora_privada_sist_s mantenedora_privada_s_fins tipo_regulamentacao tipo_localizacao_diferenciada educacao_indigena ///
dia_semana_domingo dia_semana_segunda dia_semana_terca dia_semana_quarta dia_semana_quinta dia_semana_sexta dia_semana_sabado )


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

*criando uma variavel de rede adequada
tostring rede, replace
replace rede = "federal" if rede == "1"
replace rede = "estadual" if rede == "2" 
replace rede = "municipal" if rede == "3"
replace rede = "privada" if rede == "4"


foreach estado in AC AM AP PA RO RR TO DF GO MS MT MG RJ ES SP PR RS SC AL BA CE MA PB PE PI RN SE {
	preserve
keep if sigla_uf == "`estado'"
drop ano sigla_uf sigla_uf
export delimited "turmaspart/ano=`i'/sigla_uf=`estado'/`i'_`estado'" , replace
	restore
	
	}

}









