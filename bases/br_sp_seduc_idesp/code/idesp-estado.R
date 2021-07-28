# Biblioteca
library(tidyverse)
library(rio)
library(DBI)
library(bigrquery)
library(reshape2)

# diretorio
setwd("~/Documentos/bdmais")

vetor_nomes <- c("EF ANOS INICIAIS", "EF ANOS FINAIS", "ENSINO MEDIO")

# de 2011 a 2017
base1 <- import("bases_cruas/seduc/idesp-estado/IDESP_Estado_2011_2017.csv")%>%
  set_names("ano", vetor_nomes)%>%
  pivot_longer(cols =  vetor_nomes,
               names_to = "nivel_ensino",
               values_to = "nota_idesp")

# 2018 e 2019
base2018 <- bind_rows(import("bases_cruas/seduc/idesp-estado/IDESP_ESTADO_2018.csv"))%>%
  bind_rows(import("bases_cruas/seduc/idesp-estado//IDESP_ESTADO_2019.csv"))%>%
  set_names("ano", vetor_nomes)%>%
  pivot_longer(cols =  vetor_nomes,
               names_to = "nivel_ensino",
               values_to = "nota_idesp")

# juntando tudo
basefinal <- base1%>%
  bind_rows(base2018)

export(basefinal, "bases_prontas/idesp_estado.csv")








