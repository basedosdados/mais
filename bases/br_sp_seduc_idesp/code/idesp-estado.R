# Biblioteca
library(tidyverse)
library(rio)
library(DBI)
library(bigrquery)
library(reshape2)

# diretorio
setwd("~/Documentos/bdmais")

vetor_nomes <- c("ano", "nota_idesp_ef_iniciais", "nota_idesp_ef_finais", "nota_idesp_em")

# de 2011 a 2017
base1 <- import("bases_cruas/seduc/idesp-estado/IDESP_Estado_2011_2017.csv")%>%
  set_names(vetor_nomes)

# 2018 e 2019
base2018e2019 <- bind_rows(import("bases_cruas/seduc/idesp-estado/IDESP_ESTADO_2018.csv"))%>%
  bind_rows(import("bases_cruas/seduc/idesp-estado//IDESP_ESTADO_2019.csv"))%>%
  set_names(vetor_nomes)

# juntando tudo
basefinal <- base1%>%
  bind_rows(base2018e2019)%>%
  mutate(sigla_uf = "SP")%>%
  select(ano, sigla_uf, nota_idesp_ef_iniciais, nota_idesp_ef_finais, nota_idesp_em)

export(basefinal, "bases_prontas/idesp_estado.csv")








