# BIBLIOTECAS ---------------------

library(readxl)
library(tidyverse)
library(lubridate)
library(stringr)
library(reshape2)
library(readr)
library(reshape2)
library(glue)

# DIRETORIO
setwd("~/Documentos/bdmais")

# VETORES E FUNÇOES ------------------
 
# vetores com as variáveis a serem compatibilizadas

# vetor que será filtro até 2015 --------------------

filtro_primeira_parte <-c("ANO_CENSO","PK_COD_ENTIDADE" ,"NO_ENTIDADE","COD_ORGAO_REGIONAL_INEP",
"DESC_SITUACAO_FUNCIONAMENTO","DT_ANO_LETIVO_INICIO","DT_ANO_LETIVO_TERMINO","FK_COD_ESTADO",
"FK_COD_MUNICIPIO","ID_DEPENDENCIA_ADM","ID_LOCALIZACAO","DESC_CATEGORIA_ESCOLA_PRIVADA","ID_CONVENIADA_PP",
"ID_TIPO_CONVENIO_PODER_PUBLICO","ID_MANT_ESCOLA_PRIVADA_EMP","ID_MANT_ESCOLA_PRIVADA_ONG",
"ID_MANT_ESCOLA_PRIVADA_SIND","ID_MANT_ESCOLA_PRIVADA_SIST_S","ID_MANT_ESCOLA_PRIVADA_S_FINS",
"ID_DOCUMENTO_REGULAMENTACAO","ID_LOCAL_FUNC_PREDIO_ESCOLAR","ID_LOCAL_FUNC_SALAS_EMPRESA",
"ID_LOCAL_FUNC_SOCIOEDUCATIVA","ID_ESCOLA_COMP_PREDIO","ID_LOCAL_FUNC_PRISIONAL",
"ID_LOCAL_FUNC_TEMPLO_IGREJA", "ID_LOCAL_FUNC_CASA_PROFESSOR",
"ID_LOCAL_FUNC_GALPAO","ID_LOCAL_FUNC_OUTROS","ID_LOCAL_FUNC_SALAS_OUTRA_ESC","ID_AGUA_FILTRADA",
"ID_AGUA_REDE_PUBLICA", "ID_AGUA_POCO_ARTESIANO","ID_AGUA_CACIMBA","ID_AGUA_FONTE_RIO",
"ID_AGUA_INEXISTENTE","ID_ENERGIA_REDE_PUBLICA","ID_ENERGIA_GERADOR","ID_ENERGIA_OUTROS",
"ID_ENERGIA_INEXISTENTE","ID_ESGOTO_REDE_PUBLICA","ID_ESGOTO_FOSSA","ID_ESGOTO_INEXISTENTE"
,"ID_LIXO_COLETA_PERIODICA","ID_LIXO_QUEIMA","ID_LIXO_JOGA_OUTRA_AREA","ID_LIXO_RECICLA"
,"ID_LIXO_ENTERRA","ID_LIXO_OUTROS","ID_SALA_DIRETORIA","ID_SALA_PROFESSOR"
,"ID_LABORATORIO_INFORMATICA","ID_LABORATORIO_CIENCIAS","ID_SALA_ATENDIMENTO_ESPECIAL",
"ID_QUADRA_ESPORTES","ID_QUADRA_ESPORTES_COBERTA","ID_QUADRA_ESPORTES_DESCOBERTA","ID_COZINHA","ID_BIBLIOTECA"
,"ID_SALA_LEITURA","ID_PARQUE_INFANTIL","ID_BERCARIO","ID_SANITARIO_FORA_PREDIO","ID_SANITARIO_DENTRO_PREDIO"
,"ID_SANITARIO_EI","ID_SANITARIO_PNE","ID_DEPENDENCIAS_PNE"
,"ID_SECRETARIA","ID_BANHEIRO_CHUVEIRO","ID_REFEITORIO","ID_DESPENSA","ID_ALMOXARIFADO","ID_AUDITORIO"
,"ID_PATIO_COBERTO","ID_PATIO_DESCOBERTO","ID_ALOJAM_ALUNO","ID_ALOJAM_PROFESSOR","ID_AREA_VERDE",
"ID_LAVANDERIA","ID_DEPENDENCIAS_OUTRAS","NUM_SALAS_UTILIZADAS","NUM_SALAS_EXISTENTES","ID_EQUIP_TV"
,"NUM_EQUIP_TV","ID_EQUIP_VIDEOCASSETE","NUM_EQUIP_VIDEOCASSETE"
,"ID_EQUIP_DVD","NUM_EQUIP_DVD","ID_EQUIP_PARABOLICA"
,"ID_EQUIP_COPIADORA","NUM_EQUIP_COPIADORA","ID_EQUIP_RETRO"
,"ID_EQUIP_IMPRESSORA","NUM_EQUIP_IMPRESSORA","ID_EQUIP_SOM","NUM_EQUIP_SOM"
,"ID_EQUIP_MULTIMIDIA","NUM_EQUIP_MULTIMIDIA","ID_EQUIP_FAX"
,"ID_EQUIP_FOTO","NUM_COMPUTADORES","NUM_COMP_ADMINISTRATIVOS"
,"NUM_COMP_ALUNOS","ID_INTERNET","ID_BANDA_LARGA","NUM_FUNCIONARIOS","ID_ALIMENTACAO","ID_AEE"
,"ID_MOD_ATIV_COMPLEMENTAR","ID_MOD_ENS_REGULAR","ID_REG_INFANTIL_CRECHE"
,"ID_REG_INFANTIL_PREESCOLA","ID_REG_FUND_8_ANOS","ID_REG_FUND_9_ANOS"
,"ID_REG_MEDIO_MEDIO","ID_REG_MEDIO_INTEGRADO","ID_REG_MEDIO_NORMAL"
,"ID_REG_MEDIO_PROF","ID_MOD_ENS_ESP","ID_ESP_INFANTIL_CRECHE"
,"ID_ESP_INFANTIL_PREESCOLA","ID_ESP_FUND_8_ANOS","ID_ESP_FUND_9_ANOS",
"ID_ESP_MEDIO_MEDIO","ID_ESP_MEDIO_INTEGRADO","ID_ESP_MEDIO_NORMAL",
"ID_ESP_MEDIO_PROFISSIONAL","ID_ESP_EJA_FUNDAMENTAL"
,"ID_ESP_EJA_MEDIO","ID_MOD_EJA","ID_EJA_FUNDAMENTAL","ID_EJA_MEDIO"
,"ID_EJA_PROJOVEM","ID_FUND_CICLOS","ID_LOCALIZACAO_DIFERENCIADA","ID_MATERIAL_ESP_NAO_UTILIZA"
,"ID_MATERIAL_ESP_QUILOMBOLA","ID_MATERIAL_ESP_INDIGENA","ID_EDUCACAO_INDIGENA","FK_COD_LINGUA_INDIGENA")

# vetor da segunda metade das bases ----------------------------------
filtro_segunda_parte <- 
  c("NU_ANO_CENSO","CO_ENTIDADE","NO_ENTIDADE","CO_ORGAO_REGIONAL",'TP_SITUACAO_FUNCIONAMENTO',
    "DT_ANO_LETIVO_INICIO","DT_ANO_LETIVO_TERMINO","CO_UF","CO_MUNICIPIO"
    ,"TP_DEPENDENCIA","TP_LOCALIZACAO","TP_CATEGORIA_ESCOLA_PRIVADA","IN_CONVENIADA_PP"
    ,"TP_CONVENIO_PODER_PUBLICO","IN_MANT_ESCOLA_PRIVADA_EMP","IN_MANT_ESCOLA_PRIVADA_ONG"
    ,"IN_MANT_ESCOLA_PRIVADA_SIND","IN_MANT_ESCOLA_PRIVADA_SIST_S","IN_MANT_ESCOLA_PRIVADA_S_FINS"
    ,"TP_REGULAMENTACAO","TP_OCUPACAO_PREDIO_ESCOLAR","IN_LOCAL_FUNC_SALAS_EMPRESA"
    ,"IN_LOCAL_FUNC_SOCIOEDUCATIVO","IN_PREDIO_COMPARTILHADO","IN_LOCAL_FUNC_UNID_PRISIONAL",
    "IN_LOCAL_FUNC_TEMPLO_IGREJA","IN_LOCAL_FUNC_CASA_PROFESSOR"
    ,"TP_OCUPACAO_GALPAO","IN_LOCAL_FUNC_OUTROS","IN_LOCAL_FUNC_SALAS_OUTRA_ESC","IN_AGUA_POTAVEL"
    ,"IN_AGUA_REDE_PUBLICA","IN_AGUA_POCO_ARTESIANO","IN_AGUA_CACIMBA"
    ,"IN_AGUA_FONTE_RIO","IN_AGUA_INEXISTENTE","IN_ENERGIA_REDE_PUBLICA","IN_ENERGIA_GERADOR"
    ,"IN_ENERGIA_OUTROS","IN_ENERGIA_INEXISTENTE" ,"IN_ESGOTO_REDE_PUBLICA","IN_ESGOTO_FOSSA",
    "IN_ESGOTO_INEXISTENTE","IN_LIXO_SERVICO_COLETA","IN_LIXO_QUEIMA","IN_LIXO_DESCARTA_OUTRA_AREA",
    "IN_TRATAMENTO_LIXO_RECICLAGEM","IN_LIXO_ENTERRA","IN_LIXO_OUTROS","IN_SALA_DIRETORIA","IN_SALA_PROFESSOR"
    ,"IN_LABORATORIO_INFORMATICA","IN_LABORATORIO_CIENCIAS","IN_SALA_ATENDIMENTO_ESPECIAL"
    ,"IN_QUADRA_ESPORTES","IN_QUADRA_ESPORTES_COBERTA","IN_QUADRA_ESPORTES_DESCOBERTA"
    ,"IN_COZINHA","IN_BIBLIOTECA","IN_SALA_LEITURA","IN_PARQUE_INFANTIL","IN_BERCARIO"
    ,"IN_BANHEIRO_FORA_PREDIO","IN_BANHEIRO_DENTRO_PREDIO","IN_BANHEIRO_EI"
    ,"IN_BANHEIRO_PNE","IN_DEPENDENCIAS_PNE","IN_SECRETARIA","IN_BANHEIRO_CHUVEIRO"
    ,"IN_REFEITORIO","IN_DESPENSA","IN_ALMOXARIFADO","IN_AUDITORIO","IN_PATIO_COBERTO"
    ,"IN_PATIO_DESCOBERTO","IN_ALOJAM_ALUNO","IN_ALOJAM_PROFESSOR","IN_AREA_VERDE"
    ,"IN_LAVANDERIA","IN_DEPENDENCIAS_OUTRAS","QT_SALAS_UTILIZADAS","QT_SALAS_EXISTENTES","IN_EQUIP_TV"
    ,"QT_EQUIP_TV","IN_EQUIP_VIDEOCASSETE","QT_EQUIP_VIDEOCASSETE","IN_EQUIP_DVD"
    ,"QT_EQUIP_DVD","IN_EQUIP_PARABOLICA","IN_EQUIP_COPIADORA","QT_EQUIP_COPIADORA",
    "IN_EQUIP_RETROPROJETOR","IN_EQUIP_IMPRESSORA","QT_EQUIP_IMPRESSORA"
    ,"IN_EQUIP_SOM","QT_EQUIP_SOM","IN_EQUIP_MULTIMIDIA","QT_EQUIP_MULTIMIDIA"
    ,"IN_EQUIP_FAX","IN_EQUIP_FOTO","QT_COMPUTADOR","QT_COMP_ADMINISTRATIVO", "QT_COMP_ALUNO"
    ,"IN_INTERNET","IN_BANDA_LARGA","QT_FUNCIONARIOS", 
    "IN_ALIMENTACAO","TP_AEE","TP_ATIVIDADE_COMPLEMENTAR","IN_REGULAR"
    ,"IN_COMUM_CRECHE","IN_COMUM_PRE","IN_COMUM_FUND_AI","IN_COMUM_FUND_AF"
    ,"IN_COMUM_MEDIO_MEDIO","IN_COMUM_MEDIO_INTEGRADO" ,"IN_COMUM_MEDIO_NORMAL"
    ,"IN_COMUM_PROF","IN_ESPECIAL_EXCLUSIVA","IN_ESP_EXCLUSIVA_CRECHE"
    ,"IN_ESP_EXCLUSIVA_PRE","IN_ESP_EXCLUSIVA_FUND_AI","IN_ESP_EXCLUSIVA_FUND_AF","IN_ESP_EXCLUSIVA_MEDIO_MEDIO"
    ,"IN_ESP_EXCLUSIVA_MEDIO_INTEGR","IN_ESP_EXCLUSIVA_MEDIO_NORMAL","IN_ESP_EXCLUSIVA_PROF"
    ,"IN_ESP_EXCLUSIVA_EJA_FUND","IN_ESP_EXCLUSIVA_EJA_MEDIO","IN_EJA","IN_COMUM_EJA_FUND"
    ,"IN_COMUM_EJA_MEDIO","IN_COMUM_EJA_PROF","IN_FUNDAMENTAL_CICLOS"
    ,"TP_LOCALIZACAO_DIFERENCIADA","IN_MATERIAL_ESP_NAO_UTILIZA","IN_MATERIAL_ESP_QUILOMBOLA"
    ,"IN_MATERIAL_PED_INDIGENA" ,"IN_EDUCACAO_INDIGENA","CO_LINGUA_INDIGENA")

# como ficarão nomeados

nomes_para_bases <- c("ano", "id_escola", "nome_escola", tolower(filtro_segunda_parte)[-1:-3])

#criando vetor de codigos das ufs

vetor_uf <- c("RO","AC","AM","RR", "PA", "AP", "TO","MA", "PI", "CE","RN","PB","PE","AL", "SE","BA","MG", 
              "ES", "RJ","SP","PR","SC","RS", "MS", "MT","GO", "DF")

# expand grid nos anos e nas ufs
expansor <- function(anos){ expand_grid(uf = vetor_uf,
            ano = anos)
}

# anos iniciais
ano_expand <-expansor("2009":"2014")%>%
pull(ano)%>%
map_chr(as.character)

uf_expand <- expansor(2009:2014)%>%
  pull(uf)

nomes_expand <- expansor(2009:2014)%>%
  mutate(nomes = str_c(ano,"_",uf))%>%
  pull(nomes)

# anos finais

ano_expand2 <- expansor(2015:2020)%>%
  pull(ano)%>%
  map_chr(as.character)

uf_expand2 <- expansor(2015:2020)%>%
  pull(uf)

nomes_expand2 <- expansor(2015:2020)%>%
  mutate(nome = str_c(ano,"_",uf))%>%
  pull(nome)

# fun??es de adequa??o ----------------------------------

# gera valores para quadra esportiva --------------------
quadra_esportiva <- function (q) {
  q%>%
    mutate(ID_QUADRA_ESPORTES =
             case_when(ID_QUADRA_ESPORTES_COBERTA == "1" |
                         ID_QUADRA_ESPORTES_DESCOBERTA == "1" ~ "1"))%>%
    replace_na(list(ID_QUADRA_ESPORTES= "0"))
  }

# renomeia valores para anos especificos --------------------
renomeia15a17<- function(n,y){
  n%>%
    rename_with( .fn= ~str_replace_all( .x, "^NU_EQUIP", "QT_EQUIP"), 
                 .cols= starts_with("NU_EQUIP"))%>%
    rename(QT_COMPUTADOR = NU_COMPUTADOR,
           QT_COMP_ADMINISTRATIVO = NU_COMP_ADMINISTRATIVO ,
           QT_COMP_ALUNO = NU_COMP_ALUNO,
           QT_FUNCIONARIOS = NU_FUNCIONARIOS,
           QT_SALAS_EXISTENTES = NU_SALAS_EXISTENTES,
           QT_SALAS_UTILIZADAS = NU_SALAS_UTILIZADAS,
           IN_AGUA_POTAVEL = IN_AGUA_FILTRADA,
           IN_MATERIAL_PED_INDIGENA = IN_MATERIAL_ESP_INDIGENA)
}

# cria siglas dos estados com base no código
cria_estados <- function(x){
  x%>%
  mutate(CO_UF = case_when(CO_UF == "11" ~ "RO", CO_UF == "12" ~ "AC", CO_UF == "13" ~ "AM",
                              CO_UF == "14" ~ "RR", CO_UF == "15" ~ "PA", CO_UF == "16" ~ "AP", CO_UF == "17" ~ "TO",
                              CO_UF == "21" ~ "MA", CO_UF == "22" ~ "PI", CO_UF == "23" ~ "CE", CO_UF == "24" ~ "RN",
                              CO_UF == "25" ~ "PB", CO_UF == "26" ~ "PE", CO_UF == "27" ~ "AL", CO_UF == "28" ~ "SE",CO_UF == "29" ~ "BA",
                              CO_UF == "31" ~ "MG", CO_UF == "32" ~ "ES", CO_UF == "33" ~ "RJ", CO_UF == "35" ~ "SP", 
                              CO_UF == "41" ~ "PR", CO_UF == "42" ~ "SC", CO_UF == "43" ~ "RS",
                              CO_UF == "50" ~ "MS", CO_UF == "51" ~ "MT", CO_UF == "52" ~ "GO", CO_UF == "53" ~ "DF"))
}
  # CRIANDO FILTROS --------------------------------
filtro <- function(base, vetor){
  base%>%
    select(vetor)
}

# FUN??ES QUE ABREM BASES ---------------------------
abrebases_iniciais<- function(ano){
            assign(x = paste0("escolas{ano}"), 
                   value = read_delim(glue("bases_cruas/censo-escolas/a{ano}/ESCOLAS.CSV"), 
                                             "|", escape_double = FALSE, trim_ws = TRUE,
                                      col_types = cols(.default = "c")))%>%
            mutate(dia_i = str_sub(DT_ANO_LETIVO_INICIO,1,2),
                   mes_i = str_sub(DT_ANO_LETIVO_INICIO,3,5),
                   dia_f = str_sub(DT_ANO_LETIVO_TERMINO,1,2),
                   mes_f = str_sub(DT_ANO_LETIVO_TERMINO,3,5),
                   ano_c = str_sub(DT_ANO_LETIVO_TERMINO,6,9),
                   mes_ic = case_when(mes_i == "JAN" ~ "01",
                                      mes_i == "FEV" ~ "02",
                                      mes_i == "MAR" ~ "03",
                                      mes_i == "ABR" ~ "04",
                                      mes_i == "MAI" ~ "05",
                                      mes_i == "JUN" ~ "06",
                                      mes_i == "JUL" ~ "07",
                                      mes_i == "AGO" ~ "08",
                                      mes_i == "SET" ~ "09",
                                      mes_i == "OUT" ~ "10",
                                      mes_i == "NOV" ~ "11",
                                      mes_i == "DEZ" ~ "12"),
                   
                   mes_fc = case_when(mes_f == "JAN" ~ "01",
                                      mes_f == "FEV" ~ "02",
                                      mes_f == "MAR" ~ "03",
                                      mes_f == "ABR" ~ "04",
                                      mes_f == "MAI" ~ "05",
                                      mes_f == "JUN" ~ "06",
                                      mes_f == "JUL" ~ "07",
                                      mes_f == "AGO" ~ "08",
                                      mes_f == "SET" ~ "09",
                                      mes_f == "OUT" ~ "10",
                                      mes_f == "NOV" ~ "11",
                                      mes_f == "DEZ" ~ "12"),
                   DT_ANO_LETIVO_INICIO = str_c(dia_i,"/",mes_ic,"/",ano_c),
                   DT_ANO_LETIVO_TERMINO = str_c(dia_f,"/",mes_fc,"/",ano_c))%>%
    slice(1:100)
}

abrebases_finais<- function(ano){
  assign(x = glue("escolas{ano}"), 
         value = read_delim(glue("bases_cruas/censo-escolas/a{ano}/ESCOLAS.CSV"), 
                            "|", escape_double = FALSE, trim_ws = TRUE,
                            col_types = cols(.default = "c")
                            ))%>%
    slice(1:100)
}

# Primeiro conjunto de bases: 2009 a 2014 ---------------------------------------- 
  
# CONFECÇÃO ---------------------------------------------

lista_inicial <- map(2009:2014, abrebases_iniciais)

bases_iniciais <- reduce(lista_inicial, bind_rows)%>%
  filtro(filtro_primeira_parte)%>%
  set_names(filtro_segunda_parte)%>%
  cria_estados()%>%
  set_names(nomes_para_bases)%>%
  rename(sigla_uf = co_uf,
         id_municipio = co_municipio)

# PARTICIONAMENTO ---------------------------------------

#diretorio
walk2(.x = uf_expand, .y = ano_expand, 
      ~dir.create(path = glue('bases_prontas/particionadas/censo-escolas/ano={.y}/sigla_uf={.x}'))
)
walk2(.x = uf_expand2, .y = ano_expand2, 
      ~dir.create(path = glue('bases_prontas/particionadas/censo-escolas/ano={.y}/sigla_uf={.x}'))
)

#construindo uma lista
lista_inicial_pronta <- map2(.x = uf_expand, .y = ano_expand, 
                             .f = ~bases_iniciais%>%
                               filter(ano == .y)%>%
                               filter(sigla_uf == .x)%>%
                               select(-ano, -sigla_uf))
names(lista_inicial_pronta)<- nomes_expand

walk2(.x = uf_expand, .y=ano_expand,
      .f = ~rio::export(lista_inicial_pronta[[glue("{.y}_{.x}")]], 
                       file = glue("bases_prontas/particionadas/censo-escolas/ano={.y}/sigla_uf={.x}/{.y}_{.x}.csv"),
                       quote = TRUE, sep = ",", na=""))

# 2015 A 2018 -------------------------

escolas15a17<- abrebases_finais(2015)%>%
                bind_rows(abrebases_finais(2016))%>%
                bind_rows(abrebases_finais(2017))%>%
                renomeia15a17()%>%
                slice(1:100)

# 2018, 2019 E 2020 ------------------

escolas2018 <- abrebases_finais(2018)%>%
          rename(IN_AGUA_POTAVEL = IN_AGUA_FILTRADA,
                 IN_MATERIAL_PED_INDIGENA = IN_MATERIAL_ESP_INDIGENA)%>%
          slice(1:100)

escolas2019<- abrebases_finais(2019)%>%
          mutate(QT_COMP_ALUNO = as.numeric(QT_DESKTOP_ALUNO) + as.numeric(QT_COMP_PORTATIL_ALUNO))%>%
          mutate(QT_COMP_ALUNO = as.character(QT_COMP_ALUNO))%>%
          slice(1:100)
                      
escolas2020<- abrebases_finais(2020)%>%
          mutate(QT_COMP_ALUNO = as.numeric(QT_DESKTOP_ALUNO) + as.numeric(QT_COMP_PORTATIL_ALUNO))%>%
          mutate(QT_COMP_ALUNO = as.character(QT_COMP_ALUNO))%>%
          slice(1:100)

bases_finais<- escolas2018%>%
                      bind_rows(escolas2019)%>%  
                      bind_rows(escolas2020)%>%
                      bind_rows(escolas15a17)%>%
                      filtro(filtro_segunda_parte)%>%
                      cria_estados()%>%
                      set_names(nomes_para_bases)%>%
                      rename(sigla_uf = co_uf,
                             id_municipio = co_municipio)





#construindo uma lista
lista_final_pronta <- map2(.x = uf_expand2, .y = ano_expand2, 
                             .f = ~bases_finais%>%
                               filter(ano == .y)%>%
                               filter(sigla_uf == .x)%>%
                               select(-ano,-sigla_uf))
names(lista_final_pronta) <- nomes_expand2

# a lista deve estar nomeada antes de us?-la
walk2(.x = uf_expand2, .y=ano_expand2,
      .f = ~rio::export(lista_final_pronta[[glue("{.y}_{.x}")]], 
                       file = glue("bases_prontas/particionadas/censo-escolas/ano={.y}/sigla_uf={.x}/{.y}_{.x}.csv"),
                       na= "", sep = ",", quote = TRUE))


# JUNTANDO TODA A BASE EM UMA S? E EXPORTANDO

escolas09a20 <- escolas09a14%>%
  bind_rows(escolas15a17)%>%
  bind_rows(escolas18a20)

write.csv(escolas09a20, "escolas09a20unificada.csv", na = "")



 
 
 
 

