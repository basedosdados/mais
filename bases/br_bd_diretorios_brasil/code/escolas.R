# criando um diretório master para todas as escolas que se tem notícia no país

# Biblioteca
library(DBI)
library(bigrquery)
library(tidyverse)

setwd("C://Users/Matheus/Desktop/bdmais")


# Conectando a BigQuery
bq_auth(path = "chavebigquery/My Project 71749-87ac5d5aee91.json")
id_projeto <- "polar-plate-302114"

con <- dbConnect(
  bigrquery::bigquery(),
  billing = id_projeto,
  project = "basedosdados"
)

# Executando a query

query <- 'SELECT id_escola, escola, id_municipio, municipio, estado_abrev, rede
FROM `basedosdados.br_inep_ideb.escola`
WHERE ano = 2019
GROUP BY id_escola, escola, id_municipio, municipio, estado_abrev, rede'


base_brasil <- dbGetQuery(con, query)%>%
  rename(sigla_uf = estado_abrev)%>%
  select(-municipio)

base_sp <- rio::import("seduc/seduc/idesp_fundamental_medio.csv")%>%
  group_by(id_escola_sp, id_escola, nome_escola)%>%
  summarise()

diretorio<- base_brasil%>%
  left_join(base_sp, by = "id_escola")%>%
  select(- escola)%>%
  select(id_escola, id_escola_sp, nome_escola, rede, id_municipio, sigla_uf)
  
rio::export(diretorio, "diretorio.csv")











