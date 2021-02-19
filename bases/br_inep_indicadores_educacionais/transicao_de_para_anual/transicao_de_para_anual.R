remove(list = ls())

library(readxl)
library(plyr)
library(dplyr)
library(magrittr)
library(stringr)
library(readr)
library(readxl)
#baixando dados

setwd("C:/Users/Hevilyn/Desktop/tx_transição")

tx_17_18 <- read_excel("TX_TRANSICAO_MUNICIPIOS_2017_2018.xlsx")
tx_17_18 <- tx_17_18[-c(1:8,23827,23828,23829),]
tx_17_18$ano_de <- "2017"
tx_17_18$ano_para <- "2018"
tx_17_18 <- tx_17_18[-c(1,2,3,5)]

tx_16_17 <- read_excel("TX_TRANSICAO_MUNICIPIOS_2016_2017.xlsx")
tx_16_17 <- tx_16_17[-c(1:8,23854,23855,23856),]
tx_16_17$ano_de <- "2016"
tx_16_17$ano_para <- "2017"
tx_16_17 <- tx_16_17[-c(1,2,3,5)]

tx_15_16 <- read_excel("TX_TRANSICAO_MUNICIPIOS_2015_2016.xlsx")
tx_15_16 <- tx_15_16[-c(1:8,23857,23858,23859),]
tx_15_16$ano_de <- "2015"
tx_15_16$ano_para <- "2016"
tx_15_16 <- tx_15_16[-c(1,2,3,5)]


tx_14_15 <- read_excel("TX_TRANSICAO_MUNICIPIOS_2014_2015.xlsx")
tx_14_15 <- tx_14_15[-c(1:8,23861,23862,23863),]
tx_14_15$ano_de <- "2014"
tx_14_15$ano_para <- "2015"
tx_14_15 <- tx_14_15[-c(1,2,3,5)]


tx_13_14 <- read_excel("TX_TRANSICAO_MUNICIPIOS_2013_2014.xlsx")
tx_13_14 <- tx_13_14[-c(1:8,23885,23886,23887),]
tx_13_14$ano_de <- "2013"
tx_13_14$ano_para <- "2014"
tx_13_14 <- tx_13_14[-c(1,2,3,5)]


tx_12_13 <- read_excel("TX_TRANSICAO_MUNICIPIOS_2012_2013.xlsx")
tx_12_13 <- tx_12_13[-c(1:8,23884,23885,23886),]
tx_12_13$ano_de <- "2012"
tx_12_13$ano_para <- "2013"
tx_12_13 <- tx_12_13[-c(1,2,3,5)]

tx_11_12 <- read_excel("TX_TRANSICAO_MUNICIPIOS_2011_2012.xlsx")
tx_11_12 <- tx_11_12[-c(1:8,23881,23882,23883),]
tx_11_12$ano_de <- "2011"
tx_11_12$ano_para <- "2012"
tx_11_12 <- tx_11_12[-c(1,2,3,5)]

tx_10_11 <- read_excel("TX_TRANSICAO_MUNICIPIOS_2010_2011.xlsx")
tx_10_11 <- tx_10_11[-c(1:8,23883,23884,23885),]
tx_10_11$ano_de <- "2010"
tx_10_11$ano_para <- "2011"
tx_10_11 <- tx_10_11[-c(1,2,3,5)]

tx_09_10 <- read_excel("TX_TRANSICAO_MUNICIPIOS_2009_2010.xlsx")
tx_09_10 <- tx_09_10[-c(1:8,23922,23923,23924),]
tx_09_10$ano_de <- "2009"
tx_09_10$ano_para <- "2010"
tx_09_10 <- tx_09_10[-c(1,2,3,5)]


tx_08_09 <- read_excel("TX_TRANSICAO_MUNICIPIOS_2008_2009.xlsx")
tx_08_09 <- tx_08_09[-c(1:8,23972,23973,23974),]
tx_08_09$ano_de <- "2008"
tx_08_09$ano_para <- "2009"
tx_08_09 <- tx_08_09[-c(1,2,3,5)]

tx_07_08 <- read_excel("TX_TRANSICAO_MUNICIPIOS_2007_2008.xlsx")
tx_07_08 <- tx_07_08[-c(1:8,23970,23971,23972),]
tx_07_08$ano_de <- "2007"
tx_07_08$ano_para <- "2008"
tx_07_08 <- tx_07_08[-c(1,2,3,5)]

tx_transicao_01 <- rbind(tx_17_18,tx_16_17,tx_15_16,tx_14_15,tx_13_14,tx_12_13,tx_11_12,tx_10_11,tx_09_10,tx_08_09,tx_07_08)

colnames(tx_transicao_01) <- c("id_municipio","situacao","rede","taxa_promocao_ensino_fund","taxa_promocao_ensino_fund_anos_iniciais","taxa_promocao_ensino_fund_anos_finais","taxa_promocao_ensino_fund_1_ano"
                        ,"taxa_promocao_ensino_fund_2_ano","taxa_promocao_ensino_fund_3_ano","taxa_promocao_ensino_fund_4_ano","taxa_promocao_ensino_fund_5_ano","taxa_promocao_ensino_fund_6_ano","taxa_promocao_ensino_fund_7_ano","taxa_promocao_ensino_fund_8_ano","taxa_promocao_ensino_fund_9_ano","taxa_promocao_ensino_medio","taxa_promocao_ensino_medio_1_ano","taxa_promocao_ensino_medio_2_ano","taxa_promocao_ensino_medio_3_ano","taxa_repetencia_ensino_fund","taxa_repetencia_ensino_fund_anos_iniciais","taxa_repetencia_ensino_fund_anos_finais","taxa_repetencia_ensino_fund_1_ano"
                        ,"taxa_repetencia_ensino_fund_2_ano","taxa_repetencia_ensino_fund_3_ano","taxa_repetencia_ensino_fund_4_ano","taxa_repetencia_ensino_fund_5_ano","taxa_repetencia_ensino_fund_6_ano","taxa_repetencia_ensino_fund_7_ano","taxa_repetencia_ensino_fund_8_ano","taxa_repetencia_ensino_fund_9_ano","taxa_repetencia_ensino_medio","taxa_repetencia_ensino_medio_1_ano","taxa_repetencia_ensino_medio_2_ano","taxa_repetencia_ensino_medio_3_ano","taxa_evasao_ensino_fund","taxa_evasao_ensino_fund_anos_iniciais","taxa_evasao_ensino_fund_anos_finais","taxa_evasao_ensino_fund_1_ano"
                        ,"taxa_evasao_ensino_fund_2_ano","taxa_evasao_ensino_fund_3_ano","taxa_evasao_ensino_fund_4_ano","taxa_evasao_ensino_fund_5_ano","taxa_evasao_ensino_fund_6_ano","taxa_evasao_ensino_fund_7_ano","taxa_evasao_ensino_fund_8_ano","taxa_evasao_ensino_fund_9_ano","taxa_evasao_ensino_medio","taxa_evasao_ensino_medio_1_ano","taxa_evasao_ensino_medio_2_ano","taxa_evasao_ensino_medio_3_ano","taxa_evasao_eja_ensino_fund","taxa_evasao_eja_ensino_fund_anos_iniciais","taxa_evasao_eja_ensino_fund_anos_finais","taxa_evasao_eja_ensino_fund_1_ano"
                        ,"taxa_evasao_eja_ensino_fund_2_ano","taxa_evasao_eja_ensino_fund_3_ano","taxa_evasao_eja_ensino_fund_4_ano","taxa_evasao_eja_ensino_fund_5_ano","taxa_evasao_eja_ensino_fund_6_ano","taxa_evasao_eja_ensino_fund_7_ano","taxa_evasao_eja_ensino_fund_8_ano","taxa_evasao_eja_ensino_fund_9_ano","taxa_evasao_eja_ensino_medio","taxa_evasao_eja_ensino_medio_1_ano","taxa_evasao_eja_ensino_medio_2_ano","taxa_evasao_eja_ensino_medio_3_ano","ano_de","ano_para")

#Palavras sem acento e minúsculas
tx_transicao_01$situacao <- arrumar(tx_transicao_01$situacao)
tx_transicao_01$rede <- arrumar(tx_transicao_01$rede)
tx_transicao_01$situacao <- arrumar_cons(tx_transicao_01$situacao)
tx_transicao_01$rede <- arrumar_cons(tx_transicao_01$rede)

tx_transicao_01$rede <- str_replace_all(tx_transicao_01$rede,"publico","publica")
tx_transicao_01$rede <- str_replace_all(tx_transicao_01$rede,"particular","privada")


tx_transicao <- tx_transicao_01 %>% arrange(id_municipio,situacao,rede)

tx_transicao <- tx_transicao %>% relocate(ano_de, .after = rede)
tx_transicao <- tx_transicao %>% relocate(ano_para, .after = ano_de)

tx_transicao$id_municipio <- as.integer(tx_transicao$id_municipio)
tx_transicao$ano_de <- as.integer(tx_transicao$ano_de)
tx_transicao$ano_para <- as.integer(tx_transicao$ano_para)

is.na(tx_transicao[6:69]) <- tx_transicao[6:69]=="--"

tx_transicao[,6:69] <- lapply(tx_transicao[6:69],as.numeric)

con <- file('transicao_de_para.csv', encoding = "UTF-8")
write.csv(teste, file = con, row.names = FALSE, na = " ")
