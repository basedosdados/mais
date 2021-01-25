remove(list = ls())
library(readxl)
library(plyr)
library(dplyr)
library(magrittr)
library(stringr)
library(readr)

setwd("C:/Users/user/Desktop/bases/inep/media_horas")

med_2019 <- read_excel("HAD_MUNICIPIOS_2019.xlsx")
med_2019 <- med_2019[-c(1:8,65696,65697,65698),]

med_2018 <- read_excel("HAD_MUNICIPIOS_2018.xlsx")
med_2018 <- med_2018[-c(1:8,65781,65782,65783),]


med_2017 <- read_excel("HAD_MUNICIPIOS_2017.xlsx")
med_2017 <- med_2017[-c(1:8,65855,65856,65857),]

med_2016 <- read_excel("HAD_MUNICIPIOS_2016.xlsx")
med_2016 <- med_2016[-c(1:8,65821,65822,65823),]

## Base de 2015
# Veio com uma coluna a mais que as outras
med_2015 <- read_excel("HAD_MUNICIPIOS_2015.xlsx")
med_2015 <- med_2015[-c(1:8,66548,66549,66550),-c(3)]

colnames(med_2015) <- c("ano","regiao","uf","id_municipio","nm_municipio","situacao","rede","atu_educacao_infantil","atu_educacao_infantil_creche",
                                      "atu_educacao_infantil_pre_escola","atu_ensino_fund","atu_ensino_fund_anos_iniciais","atu_ensino_fund_anos_finais","atu_ensino_fund_1_ano",
                                      "atu_ensino_fund_2_ano","atu_ensino_fund_3_ano","atu_ensino_fund_4_ano","atu_ensino_fund_5_ano","atu_ensino_fund_6_ano","atu_ensino_fund_7_ano",
                                      "atu_ensino_fund_8_ano","atu_ensino_fund_9_ano","atu_ensino_medio","atu_ensino_medio_1_ano","atu_ensino_medio_2_ano",
                                      "atu_ensino_medio_3_ano","atu_ensino_medio_4_ano","atu_ensino_medio_nao_seriado")



med_2014 <- read_excel("MÉDIA HORAS-AULA MUNICÍPIOS  2014.xlsx")
med_2014 <- med_2014[-c(1:8,66706,66707),]

med_2013 <- read_excel("MÉDIA HORAS-AULA MUNICÍPIOS  2013.xlsx")
med_2013 <- med_2013[-c(1:8,66714,66715),]

med_2012 <- read_excel("horas_aula_municipios_2012.xlsx")
med_2012 <- med_2012[-c(1:7,66707,66708),]

med_2011_plan1 <- read_excel("horas_aula_municipios_2011.xls",sheet = 1)
med_2011_plan2 <- read_excel("horas_aula_municipios_2011.xls",sheet = 2)

med_2011_plan1 <- med_2011_plan1[-c(1:7,28296,28297),]    #Exclui linhas vazias
med_2011_plan2 <- med_2011_plan2[-c(1:7,38424,38425),]

med_2011 <- rbind(med_2011_plan1,med_2011_plan2)



med_2010_plan1 <- read_excel("MÉDIA HORAS-AULA MUNICÍPIOS  2010.xls",sheet = 1)
med_2010_plan2 <- read_excel("MÉDIA HORAS-AULA MUNICÍPIOS  2010.xls",sheet = 2)

med_2010_plan1 <- med_2010_plan1[-c(1:7,28194),]    #Exclui linhas vazias
med_2010_plan2 <- med_2010_plan2[-c(1:7,38399),]

med_2010 <- rbind(med_2010_plan1,med_2010_plan2)

#      JUNTANDO AS BASES E RENOMEANDO COLUNAS     #

media_horas_municipios01 <- rbind(med_2019,med_2018,med_2017,med_2016)

colnames(media_horas_municipios01) <- c("ano","regiao","uf","id_municipio","nm_municipio","situacao","rede","atu_educacao_infantil","atu_educacao_infantil_creche",
                                      "atu_educacao_infantil_pre_escola","atu_ensino_fund","atu_ensino_fund_anos_iniciais","atu_ensino_fund_anos_finais","atu_ensino_fund_1_ano",
                                      "atu_ensino_fund_2_ano","atu_ensino_fund_3_ano","atu_ensino_fund_4_ano","atu_ensino_fund_5_ano","atu_ensino_fund_6_ano","atu_ensino_fund_7_ano",
                                      "atu_ensino_fund_8_ano","atu_ensino_fund_9_ano","atu_ensino_medio","atu_ensino_medio_1_ano","atu_ensino_medio_2_ano",
                                      "atu_ensino_medio_3_ano","atu_ensino_medio_4_ano","atu_ensino_medio_nao_seriado")

media_horas_municipios01 <- rbind(media_horas_municipios01,med_2015)

media_horas_municipios02 <- rbind(med_2014,med_2013,med_2012,med_2011,med_2010)

colnames(media_horas_municipios02) <- c("ano","regiao","uf","nm_municipio","id_municipio","situacao","rede","atu_educacao_infantil","atu_educacao_infantil_creche",
                                      "atu_educacao_infantil_pre_escola","atu_ensino_fund","atu_ensino_fund_anos_iniciais","atu_ensino_fund_anos_finais","atu_ensino_fund_1_ano",
                                      "atu_ensino_fund_2_ano","atu_ensino_fund_3_ano","atu_ensino_fund_4_ano","atu_ensino_fund_5_ano","atu_ensino_fund_6_ano","atu_ensino_fund_7_ano",
                                      "atu_ensino_fund_8_ano","atu_ensino_fund_9_ano","atu_ensino_medio","atu_ensino_medio_1_ano","atu_ensino_medio_2_ano",
                                      "atu_ensino_medio_3_ano","atu_ensino_medio_4_ano","atu_ensino_medio_nao_seriado")

media_horas_municipios01 <- media_horas_municipios01[-c(2,3,5)]

media_horas_municipios02 <- media_horas_municipios02[-c(2,3,4)]

media_horas_municipios <- rbind(media_horas_municipios01,media_horas_municipios02)


arrumar <- function(vec){
  vec <- gsub("A","a",vec)
  vec <- gsub("Á","a",vec)
  vec <- gsub("Ã","a",vec)
  vec <- gsub("À","a",vec)
  vec <- gsub("Â","a",vec)
  vec <- gsub("E","e",vec)
  vec <- gsub("É","e",vec)
  vec <- gsub("È","e",vec)
  vec <- gsub("Ê","e",vec)
  vec <- gsub("I","i",vec)
  vec <- gsub("Í","i",vec)
  vec <- gsub("Ì","i",vec)
  vec <- gsub("O","o",vec)
  vec <- gsub("Ó","o",vec)
  vec <- gsub("Õ","o",vec)
  vec <- gsub("Ò","o",vec)
  vec <- gsub("Ô","o",vec)
  vec <- gsub("U","u",vec)
  vec <- gsub("Ú","u",vec)
  vec <- gsub("Ù","u",vec)
  vec <- gsub("Ç","c",vec)
  return(vec)
}

arrumar_min <- function(vec){
  vec <- gsub("á","a",vec)
  vec <- gsub("ã","a",vec)
  vec <- gsub("à","a",vec)
  vec <- gsub("â","a",vec)
  vec <- gsub("é","e",vec)
  vec <- gsub("è","e",vec)
  vec <- gsub("ê","e",vec)
  vec <- gsub("í","i",vec)
  vec <- gsub("ì","i",vec)
  vec <- gsub("ó","o",vec)
  vec <- gsub("õ","o",vec)
  vec <- gsub("ò","o",vec)
  vec <- gsub("ô","o",vec)
  vec <- gsub("ú","u",vec)
  vec <- gsub("ù","u",vec)
  vec <- gsub("ç","c",vec)
  return(vec)
}

arrumar_cons <- function(vec){
  vec <- gsub("B","b",vec)
  vec <- gsub("C","c",vec)
  vec <- gsub("D","d",vec)
  vec <- gsub("F","f",vec)
  vec <- gsub("G","g",vec)
  vec <- gsub("H","h",vec)
  vec <- gsub("J","j",vec)
  vec <- gsub("K","k",vec)
  vec <- gsub("L","l",vec)
  vec <- gsub("M","m",vec)
  vec <- gsub("N","n",vec)
  vec <- gsub("P","p",vec)
  vec <- gsub("Q","q",vec)
  vec <- gsub("R","r",vec)
  vec <- gsub("S","s",vec)
  vec <- gsub("T","t",vec)
  vec <- gsub("V","v",vec)
  vec <- gsub("X","x",vec)
  vec <- gsub("Y","y",vec)
  vec <- gsub("Z","z",vec)
  return(vec)
}



# TRANSFORMAR LETRAS EM MINÚSCULO E SEM ACENTO #

media_horas_municipios$situacao <- arrumar_min(media_horas_municipios$situacao)
media_horas_municipios$rede <- arrumar_min(media_horas_municipios$rede)


media_horas_municipios$situacao <- arrumar(media_horas_municipios$situacao)
media_horas_municipios$rede <- arrumar(media_horas_municipios$rede)


media_horas_municipios$situacao <- arrumar_cons(media_horas_municipios$situacao)
media_horas_municipios$rede <- arrumar_cons(media_horas_municipios$rede)

media_horas_municipios$rede <- str_replace_all(media_horas_municipios$rede,"publico","publica")
media_horas_municipios$rede <- str_replace_all(media_horas_municipios$rede,"particular","privada")

# ORDENAR POR ID_MUNICIPIO, SITUACAO, REDE E ANO

media_horas <- media_horas_municipios %>% arrange(id_municipio,situacao,rede,ano)

media_horas <- media_horas %>% relocate(ano, .after = rede)

# TRANSFORMA "--" EM NA

is.na(media_horas[5:25]) <- media_horas[5:25]=="--"

write.csv(media_horas,file = "media_horas_aula_diaria.csv", row.names = FALSE, na = " ")



