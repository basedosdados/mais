#### Escolas 2020 ####

# O mesmo código foi usado para todos os anos #

remove(list = ls())
library(readxl)
library(plyr)
library(dplyr)
library(magrittr)
library(stringr)
library(readr)

#MÉDIA ALUNOS TURMA#

setwd("C:\\Users\\Hevilyn\\Desktop\\inep_escolas\\atu")

atu_2020 = read.table("ATU_2020.txt")

atu_2020[,5:26] <- lapply(atu_2020[5:26],as.numeric)

colnames(atu_2020) <- c("id_municipio","id_escola","localizacao","rede","atu_educacao_infantil","atu_educacao_infantil_creche",
                        "atu_educacao_infantil_pre_escola","atu_ensino_fund","atu_ensino_fund_anos_iniciais","atu_ensino_fund_anos_finais","atu_ensino_fund_1_ano",
                        "atu_ensino_fund_2_ano","atu_ensino_fund_3_ano","atu_ensino_fund_4_ano","atu_ensino_fund_5_ano","atu_ensino_fund_6_ano","atu_ensino_fund_7_ano",
                        "atu_ensino_fund_8_ano","atu_ensino_fund_9_ano","atu_ensino_fund_turmas_unif_multi_fluxo","atu_ensino_medio","atu_ensino_medio_1_ano","atu_ensino_medio_2_ano",
                        "atu_ensino_medio_3_ano","atu_ensino_medio_4_ano","atu_ensino_medio_nao_seriado")



# Palavras sem acento e minúsculas #
atu_2020$rede <- arrumar(atu_2020$rede)
atu_2020$rede <- arrumar_cons(atu_2020$rede)
atu_2020$localizacao <- arrumar(atu_2020$localizacao)
atu_2020$localizacao <- arrumar_cons(atu_2020$localizacao)

atu_2020$rede <- str_replace_all(atu_2020$rede,"publico","publica")
atu_2020$rede <- str_replace_all(atu_2020$rede,"particular","privada")


#MÉDIA HORAS-AULA DIÁRIA

setwd("C:\\Users\\Hevilyn\\Desktop\\inep_escolas\\had")

had_2020 = read.table("HAD_2020.txt") 

colnames(had_2020) = c("id_municipio","id_escola","localizacao","rede","had_educacao_infantil","had_educacao_infantil_creche",
                       "had_educacao_infantil_pre_escola","had_ensino_fund","had_ensino_fund_anos_iniciais","had_ensino_fund_anos_finais","had_ensino_fund_1_ano",
                       "had_ensino_fund_2_ano","had_ensino_fund_3_ano","had_ensino_fund_4_ano","had_ensino_fund_5_ano","had_ensino_fund_6_ano","had_ensino_fund_7_ano",
                       "had_ensino_fund_8_ano","had_ensino_fund_9_ano","had_ensino_medio","had_ensino_medio_1_ano","had_ensino_medio_2_ano",
                       "had_ensino_medio_3_ano","had_ensino_medio_4_ano","had_ensino_medio_nao_seriado")

had_2020[,5:25] <- lapply(had_2020[5:25],as.numeric)

had_2020$rede <- arrumar(had_2020$rede)
had_2020$rede <- arrumar_cons(had_2020$rede)
had_2020$localizacao <- arrumar(had_2020$localizacao)
had_2020$localizacao <- arrumar_cons(had_2020$localizacao)

had_2020$rede <- str_replace_all(had_2020$rede,"publico","publica")
had_2020$rede <- str_replace_all(had_2020$rede,"particular","privada")

# TAXA DISTORCAO IDADE SÉRIE #

setwd("C:\\Users\\Hevilyn\\Desktop\\inep_escolas\\tdi")

tdi_2020 = read.table("TDI_2020.txt" )

colnames(tdi_2020) <- c("id_municipio","id_escola","localizacao","rede","tdi_ensino_fund",
                        "tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais",
                        "tdi_ensino_fund_1_ano","tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano",
                        "tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano","tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_medio","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano","tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano")

tdi_2020[,5:21] <- lapply(tdi_2020[5:21],as.numeric)

tdi_2020$rede <- arrumar(tdi_2020$rede)
tdi_2020$rede <- arrumar_cons(tdi_2020$rede)
tdi_2020$localizacao <- arrumar(tdi_2020$localizacao)
tdi_2020$localizacao <- arrumar_cons(tdi_2020$localizacao)

tdi_2020$rede <- str_replace_all(tdi_2020$rede,"publico","publica")
tdi_2020$rede <- str_replace_all(tdi_2020$rede,"particular","privada")

### Taxas de rendimento ###

setwd("C:\\Users\\Hevilyn\\Desktop\\inep_escolas\\tx_rend")

tx_2020 <- read.table("TX_2020.txt")

colnames(tx_2020) <- c("id_municipio","id_escola","localizacao","rede","taxa_aprov_ensino_fund","taxa_aprov_ensino_fund_anos_iniciais","taxa_aprov_ensino_fund_anos_finais","taxa_aprov_ensino_fund_1_ano",
                       "taxa_aprov_ensino_fund_2_ano","taxa_aprov_ensino_fund_3_ano","taxa_aprov_ensino_fund_4_ano","taxa_aprov_ensino_fund_5_ano","taxa_aprov_ensino_fund_6_ano","taxa_aprov_ensino_fund_7_ano",
                       "taxa_aprov_ensino_fund_8_ano","taxa_aprov_ensino_fund_9_ano","taxa_aprov_ensino_medio","taxa_aprov_ensino_medio_1_ano","taxa_aprov_ensino_medio_2_ano",
                       "taxa_aprov_ensino_medio_3_ano","taxa_aprov_ensino_medio_4_ano","taxa_aprov_ensino_medio_nao_seriado","taxa_reprov_ensino_fund","taxa_reprov_ensino_fund_anos_iniciais","taxa_reprov_ensino_fund_anos_finais","taxa_reprov_ensino_fund_1_ano",
                       "taxa_reprov_ensino_fund_2_ano","taxa_reprov_ensino_fund_3_ano","taxa_reprov_ensino_fund_4_ano","taxa_reprov_ensino_fund_5_ano","taxa_reprov_ensino_fund_6_ano","taxa_reprov_ensino_fund_7_ano",
                       "taxa_reprov_ensino_fund_8_ano","taxa_reprov_ensino_fund_9_ano","taxa_reprov_ensino_medio","taxa_reprov_ensino_medio_1_ano","taxa_reprov_ensino_medio_2_ano",
                       "taxa_reprov_ensino_medio_3_ano","taxa_reprov_ensino_medio_4_ano","taxa_reprov_ensino_medio_nao_seriado","taxa_aband_ensino_fund","taxa_aband_ensino_fund_anos_iniciais","taxa_aband_ensino_fund_anos_finais","taxa_aband_ensino_fund_1_ano",
                       "taxa_aband_ensino_fund_2_ano","taxa_aband_ensino_fund_3_ano","taxa_aband_ensino_fund_4_ano","taxa_aband_ensino_fund_5_ano","taxa_aband_ensino_fund_6_ano","taxa_aband_ensino_fund_7_ano",
                       "taxa_aband_ensino_fund_8_ano","taxa_aband_ensino_fund_9_ano","taxa_aband_ensino_medio","taxa_aband_ensino_medio_1_ano","taxa_aband_ensino_medio_2_ano",
                       "taxa_aband_ensino_medio_3_ano","taxa_aband_ensino_medio_4_ano","taxa_aband_ensino_medio_nao_seriado")

tx_2020[,5:58] <- lapply(tx_2020[5:58],as.numeric)

tx_2020$rede <- arrumar(tx_2020$rede)
tx_2020$rede <- arrumar_cons(tx_2020$rede)
tx_2020$localizacao <- arrumar(tx_2020$localizacao)
tx_2020$localizacao <- arrumar_cons(tx_2020$localizacao)

tx_2020$rede <- str_replace_all(tx_2020$rede,"publico","publica")
tx_2020$rede <- str_replace_all(tx_2020$rede,"particular","privada")

##### TABELA TAXA DE NAO RESPOSTA ######

setwd("C:\\Users\\Hevilyn\\Desktop\\inep_escolas\\tnr")

tnr_2020 <- read.table("TNR_2020.txt")

colnames(tnr_2020) = c("id_municipio","id_escola","localizacao","rede","tnr_ensino_fund","tnr_ensino_fund_anos_iniciais","tnr_ensino_fund_anos_finais","tnr_ensino_fund_1_ano",
                       "tnr_ensino_fund_2_ano","tnr_ensino_fund_3_ano","tnr_ensino_fund_4_ano","tnr_ensino_fund_5_ano","tnr_ensino_fund_6_ano","tnr_ensino_fund_7_ano",
                       "tnr_ensino_fund_8_ano","tnr_ensino_fund_9_ano","tnr_ensino_medio","tnr_ensino_medio_1_ano","tnr_ensino_medio_2_ano",
                       "tnr_ensino_medio_3_ano","tnr_ensino_medio_4_ano","tnr_ensino_medio_nao_seriado")

tnr_2020[,5:22] <- lapply(tnr_2020[5:22],as.numeric)

tnr_2020$rede <- arrumar(tnr_2020$rede)
tnr_2020$rede <- arrumar_cons(tnr_2020$rede)
tnr_2020$localizacao <- arrumar(tnr_2020$localizacao)
tnr_2020$localizacao <- arrumar_cons(tnr_2020$localizacao)

tnr_2020$rede <- str_replace_all(tnr_2020$rede,"publico","publica")
tnr_2020$rede <- str_replace_all(tnr_2020$rede,"particular","privada")


# DSU #
setwd("C:\\Users\\Hevilyn\\Desktop\\inep_escolas\\dsu")

dsu_2020 = read.table("DSU_2020.txt")

colnames(dsu_2020) =c("id_municipio","id_escola","localizacao","rede","dsu_educ_infantil","dsu_educ_infantil_creche","dsu_educ_infantil_pre_escola","dsu_ensino_fund","dsu_ensino_fund_anos_iniciais"
                      ,"dsu_ensino_fund_anos_finais","dsu_ensino_medio","dsu_educacao_profissional","dsu_educacao_jovens_adultos",
                      "dsu_educacao_especial")

dsu_2020[,5:14] <- lapply(dsu_2020[5:14],as.numeric)

dsu_2020$rede <- arrumar(dsu_2020$rede)
dsu_2020$rede <- arrumar_cons(dsu_2020$rede)
dsu_2020$localizacao <- arrumar(dsu_2020$localizacao)
dsu_2020$localizacao <- arrumar_cons(dsu_2020$localizacao)

dsu_2020$rede <- str_replace_all(dsu_2020$rede,"publico","publica")
dsu_2020$rede <- str_replace_all(dsu_2020$rede,"particular","privada")

# AFD #
setwd("C:\\Users\\Hevilyn\\Desktop\\inep_escolas\\afd")

afd_2020 <- read.table("AFD_2020.txt")

colnames(afd_2020) <- c("id_municipio","id_escola","localizacao","rede","afd_educacao_infantil_grupo_1","afd_educacao_infantil_grupo_2",
                        "afd_educacao_infantil_grupo_3","afd_educacao_infantil_grupo_4","afd_educacao_infantil_grupo_5","afd_ensino_fund_grupo_1","afd_ensino_fund_grupo_2","afd_ensino_fund_grupo_3",
                        "afd_ensino_fund_grupo_4","afd_ensino_fund_grupo_5","afd_ensino_fund_anos_iniciais_grupo_1","afd_ensino_fund_anos_iniciais_grupo_2","afd_ensino_fund_anos_iniciais_grupo_3","afd_ensino_fund_anos_iniciais_grupo_4",
                        "afd_ensino_fund_anos_iniciais_grupo_5","afd_ensino_fund_anos_finais_grupo_1","afd_ensino_fund_anos_finais_grupo_2","afd_ensino_fund_anos_finais_grupo_3","afd_ensino_fund_anos_finais_grupo_4",
                        "afd_ensino_fund_anos_finais_grupo_5","afd_ensino_medio_grupo_1","afd_ensino_medio_grupo_2","afd_ensino_medio_grupo_3","afd_ensino_medio_grupo_4","afd_ensino_medio_grupo_5","afd_eja_fundamental_grupo_1","afd_eja_fundamental_grupo_2",
                        "afd_eja_fundamental_grupo_3","afd_eja_fundamental_grupo_4","afd_eja_fundamental_grupo_5","afd_eja_medio_grupo_1","afd_eja_medio_grupo_2","afd_eja_medio_grupo_3","afd_eja_medio_grupo_4","afd_eja_medio_grupo_5")

afd_2020[,5:39] <- lapply(afd_2020[5:39],as.numeric)

afd_2020$rede <- arrumar(afd_2020$rede)
afd_2020$rede <- arrumar_cons(afd_2020$rede)
afd_2020$localizacao <- arrumar(afd_2020$localizacao)
afd_2020$localizacao <- arrumar_cons(afd_2020$localizacao)

afd_2020$rede <- str_replace_all(afd_2020$rede,"publico","publica")
afd_2020$rede <- str_replace_all(afd_2020$rede,"particular","privada")

## IRD ##

setwd("C:\\Users\\Hevilyn\\Desktop\\inep_escolas\\ird")

ird_2020 = read.table("IRD_2020.txt")

colnames(ird_2020) = c("id_municipio","id_escola","localizacao","rede","ird_media_regularidade_docente")

ird_2020[,5] <- lapply(ird_2020[5],as.numeric)

ird_2020$rede <- arrumar(ird_2020$rede)
ird_2020$rede <- arrumar_cons(ird_2020$rede)
ird_2020$localizacao <- arrumar(ird_2020$localizacao)
ird_2020$localizacao <- arrumar_cons(ird_2020$localizacao)

ird_2020$rede <- str_replace_all(ird_2020$rede,"publico","publica")
ird_2020$rede <- str_replace_all(ird_2020$rede,"particular","privada")

## IED ##
setwd("C:\\Users\\Hevilyn\\Desktop\\inep_escolas\\ied")

ied_2020 = read.table("IED_2020.txt")

colnames(ied_2020) = c("id_municipio","id_escola","localizacao","rede","ied_ensino_fund_nivel_1","ied_ensino_fund_nivel_2","ied_ensino_fund_nivel_3","ied_ensino_fund_nivel_4",
                       "ied_ensino_fund_nivel_5","ied_ensino_fund_nivel_6","ied_ensino_fund_anos_iniciais_nivel_1","ied_ensino_fund_anos_iniciais_nivel_2","ied_ensino_fund_anos_iniciais_nivel_3","ied_ensino_fund_anos_iniciais_nivel_4",
                       "ied_ensino_fund_anos_iniciais_nivel_5","ied_ensino_fund_anos_iniciais_nivel_6","ied_ensino_fund_anos_finais_nivel_1","ied_ensino_fund_anos_finais_nivel_2","ied_ensino_fund_anos_finais_nivel_3",
                       "ied_ensino_fund_anos_finais_nivel_4","ied_ensino_fund_anos_finais_nivel_5","ied_ensino_fund_anos_finais_nivel_6","ied_ensino_medio_nivel_1","ied_ensino_medio_nivel_2","ied_ensino_medio_nivel_3","ied_ensino_medio_nivel_4","ied_ensino_medio_nivel_5","ied_ensino_medio_nivel_6")


ied_2020[,5:28] <- lapply(ied_2020[5:28],as.numeric)

ied_2020$rede <- arrumar(ied_2020$rede)
ied_2020$rede <- arrumar_cons(ied_2020$rede)
ied_2020$localizacao <- arrumar(ied_2020$localizacao)
ied_2020$localizacao <- arrumar_cons(ied_2020$localizacao)

ied_2020$rede <- str_replace_all(ied_2020$rede,"publico","publica")
ied_2020$rede <- str_replace_all(ied_2020$rede,"particular","privada")


#ICG#

setwd("C:\\Users\\Hevilyn\\Desktop\\inep_escolas\\icg")

icg_2020 = read.table("ICG_2020.txt")

colnames(icg_2020) = c("id_municipio","id_escola","localizacao","rede","icg_nivel_complexidade_gestao_escola","nivel")

nivel01 <- icg_2020$icg_nivel_complexidade_gestao_escola
nivel02 <- icg_2020$nivel

icg_2020$icg_nivel_complexidade_gestao_escola <- paste(nivel01,nivel02)
icg_2020$nivel <- NULL

icg_2020$rede <- arrumar(icg_2020$rede)
icg_2020$rede <- arrumar_cons(icg_2020$rede)
icg_2020$localizacao <- arrumar(icg_2020$localizacao)
icg_2020$localizacao <- arrumar_cons(icg_2020$localizacao)
icg_2020$icg_nivel_complexidade_gestao_escola <- arrumar(icg_2020$icg_nivel_complexidade_gestao_escola)
icg_2020$icg_nivel_complexidade_gestao_escola <- arrumar_cons(icg_2020$icg_nivel_complexidade_gestao_escola)

icg_2020$rede <- str_replace_all(icg_2020$rede,"publico","publica")
icg_2020$rede <- str_replace_all(icg_2020$rede,"particular","privada")


indicadores_01 <- full_join(atu_2020,had_2020, by= c("id_municipio","id_escola","localizacao","rede"))

indicadores_02 <- full_join(indicadores_01,tdi_2020 , by= c("id_municipio","id_escola","localizacao","rede"))

indicadores_03 <- full_join(indicadores_02,tx_2020, by= c("id_municipio","id_escola","localizacao","rede"))

indicadores_04 <- full_join(indicadores_03,tnr_2020, by= c("id_municipio","id_escola","localizacao","rede"))

indicadores_05 <- full_join(indicadores_04,dsu_2020, by= c("id_municipio","id_escola","localizacao","rede"))

indicadores_06 <- full_join(indicadores_05,afd_2020, by= c("id_municipio","id_escola","localizacao","rede"))

indicadores_07 <- full_join(indicadores_06,ird_2020, by= c("id_municipio","id_escola","localizacao","rede"))

indicadores_08 <- full_join(indicadores_07,ied_2020, by= c("id_municipio","id_escola","localizacao","rede"))

indicadores_09 <- full_join(indicadores_08,icg_2020, by= c("id_municipio","id_escola","localizacao","rede"))


indicadores <- indicadores_09 %>% arrange(id_municipio,localizacao,rede,id_escola)

is.na(indicadores[5:207]) <- indicadores[5:207]=="--"

setwd("C:\\Users\\Hevilyn\\Desktop\\escola\\ano=2020")

con <- file('escola.csv', encoding = "UTF-8")
write.csv(indicadores, file = con, row.names = FALSE, na = " ")
