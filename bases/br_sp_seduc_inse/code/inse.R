# Biblioteca
library(tidyverse)
library(reshape2)
library(rio)
library(DBI)
library(bigrquery)

setwd("~/Documentos/bdmais")
# Definindo alguns vetores

vetor_nome_colunas <- c("id_escola_sp", "nome_escola", "diretoria", "municipio", "nivel_socio_economico")


# Importando e mexendo na base
base<- rio::import("bases_cruas/seduc/inse/INSE_Geral_2018_1_0.csv", setclass = "tibble")%>%
  set_names(vetor_nome_colunas)%>%
  mutate(nivel_socio_economico = as.character(nivel_socio_economico))

base$nivel_socio_economico <- str_replace(base$nivel_socio_economico , ",", ".")

# Pegando coisas do diretório para complementar a base com id_escola do INEP e id_municipio

bq_auth(path = "chavebigquery/My Project 55562-2deeaad41d85.json")
id_projeto <- "double-voice-305816"

con <- dbConnect(
  bigrquery::bigquery(),
  billing = id_projeto,
  project = "basedosdados"
)

# Executando a query
query <- 'SELECT id_escola, id_municipio, id_escola_sp, rede
FROM `basedosdados-dev.br_bd_diretorios_brasil.escola` 
GROUP BY id_escola, id_municipio, id_escola_sp, rede'

diretorio_com_id <- dbGetQuery(con, query)


# juntando as bases
inse <- base%>%
  inner_join(diretorio_com_id, by = "id_escola_sp")

#exportando

rio::export(inse, "bases_prontas/inse.csv")







