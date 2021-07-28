## NÍVEL SOCIOECONOMICO - ESCOLAS ##

remove(list = ls())
library(readxl)
library(plyr)
library(dplyr)
library(magrittr)
library(stringr)
library(readr)

setwd("C:\\Users\\Hevilyn\\Desktop\\inep_escolas\\inse")

#  2015   #
inse_2015 <- read_excel("INSE_2015.xlsx")

colnames(inse_2015) <- c("id_escola","nm_escola","id_uf","uf","id_municipio","nm_municipio","area","rede","localizacao","quantidade_alunos_inse","inse_valor_absoluto","inse_classificacao_2015")

inse_2015$inse_classificacao_2014 <- NA
inse_2015[2:4] <- NULL
inse_2015$nm_municipio <- NULL

inse_2015 <- inse_2015[-c(1:2),]

inse_2015$inse_classificacao_2015 <- arrumar(inse_2015$inse_classificacao_2015)
inse_2015$inse_classificacao_2015 <- arrumar_cons(inse_2015$inse_classificacao_2015)

inse_2015[7] <- lapply(inse_2015[7],as.numeric)


inse_2015$rede <- str_replace_all(inse_2015$rede,"1","federal")
inse_2015$rede <- str_replace_all(inse_2015$rede,"2","estadual")
inse_2015$rede <- str_replace_all(inse_2015$rede,"3","municipal")
inse_2015$rede <- str_replace_all(inse_2015$rede,"4","privada")

inse_2015$area <- str_replace_all(inse_2015$area,"1","capital")
inse_2015$area <- str_replace_all(inse_2015$area,"2","interior")

inse_2015$localizacao <- str_replace_all(inse_2015$localizacao,"1","urbana")
inse_2015$localizacao <- str_replace_all(inse_2015$localizacao,"2","rural")



#  2014   #
inse_2014 <- read_excel("INSE_2014.xlsx")

colnames(inse_2014) <- c("id_escola","nm_escola","id_uf","uf","id_municipio","nm_municipio","area","id_area","rede","id_rede","localizacao","id_localizacao","quantidade_alunos_inse","inse_valor_absoluto","inse_classificacao_2014")

inse_2014[2:4] <- NULL
inse_2014$nm_municipio <- NULL
inse_2014$id_area <- NULL
inse_2014$id_rede <- NULL
inse_2014$id_localizacao <- NULL
inse_2014$inse_classificacao_2015 <- NA

inse_2014 <- inse_2014[-c(1:2),]

inse_2014$inse_classificacao_2014 <- arrumar(inse_2014$inse_classificacao_2014)
inse_2014$inse_classificacao_2014 <- arrumar_cons(inse_2014$inse_classificacao_2014)

inse_2014[7] <- lapply(inse_2014[7],as.numeric)

inse_2014$rede <- str_replace_all(inse_2014$rede,"1","federal")
inse_2014$rede <- str_replace_all(inse_2014$rede,"2","estadual")
inse_2014$rede <- str_replace_all(inse_2014$rede,"3","municipal")
inse_2014$rede <- str_replace_all(inse_2014$rede,"4","privada")

inse_2014$area <- str_replace_all(inse_2014$area,"1","capital")
inse_2014$area <- str_replace_all(inse_2014$area,"2","interior")

inse_2014$localizacao <- str_replace_all(inse_2014$localizacao,"1","urbana")
inse_2014$localizacao <- str_replace_all(inse_2014$localizacao,"2","rural")

inse_2015$ano <- 2015
inse_2014$ano <- 2014

inse_2015 <- inse_2015 %>% relocate(inse_classificacao_2014, .before = inse_classificacao_2015)

inse <- rbind(inse_2015,inse_2014)
inse <- inse %>% relocate(ano, .before = id_escola)

inse <- inse %>% arrange(id_escola,id_municipio,area,rede,localizacao)


con <- file('escola_nivel_socioeconomico.csv', encoding = "UTF-8")
write.csv(inse, file = con, row.names = FALSE, na = " ")
