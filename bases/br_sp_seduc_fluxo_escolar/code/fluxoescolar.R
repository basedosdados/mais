# bibliotecas
library(tidyverse)
library(rio)
library(DBI)
library(bigrquery)
library(reshape2)

# diretorio
setwd("~/Documentos/bdmais")

# descobrindo onde as bases são iguais
nomedasvar <- function(ano){
  colnames(import(paste0("bases_cruas/seduc/fluxo-escolar-municipio/Fluxo_Escolar_por_Municipio_",ano,".csv"), 
                  setclass = "tbl"))
}

lista_var1 <- map(2015:2019, nomedasvar) # mesmas variaveis MAS 2018 tem uma situzinha

# vetor de nomes
vetor_nomes <- c("prop_aprovados_anos_inciais_ef","prop_reprovados_anos_iniciais_ef", 
"prop_abandono_anos_iniciais_ef", "prop_aprovados_anos_finais_ef","prop_reprovados_anos_finais_ef", 
"prop_abandono_anos_finais_ef", "prop_aprovados_em", "prop_reprovados_em",
"prop_abandono_em")

## importando dados do fluxo escolar

# abre de 15,16,17,19 
abre_15_19 <- function(ano){
  read.csv2(paste0("bases_cruas/seduc/fluxo-escolar-municipio/Fluxo_Escolar_por_Municipio_",ano,".csv"), 
            colClasses = rep("character", 13), sep = ",")%>%
    set_names(c("ano", "diretoria", "municipio", "codigo_rede_ensino", vetor_nomes))
}

list15_19 <- map(c(2015,2016,2017,2019) , abre_15_19)
bases15_19 <- reduce(list15_19, bind_rows)

# caso de 2018
base18<-  read.csv2("bases_cruas/seduc/fluxo-escolar-municipio/Fluxo_Escolar_por_Municipio_2018.csv", colClasses = rep("character", 13))%>%
  set_names(c("ano", "diretoria", "municipio", "codigo_rede_ensino", vetor_nomes))

# caso de 2014
base14 <- read.csv2("bases_cruas/seduc/fluxo-escolar-municipio/Fluxo_Escolar_por_Municipio_2014.csv", sep = ",",
                    colClasses = rep("character", 13))%>%
            select(-CODMUN)%>%
            set_names("ano", "codigo_rede_ensino", "municipio", vetor_nomes)

# caso de 2013
base13 <- read.csv2("bases_cruas/seduc/fluxo-escolar-municipio/Fluxo_Escolar_por_Municipio_2013.csv", sep = ",",
                    colClasses = rep("character", 13))%>%
            set_names("ano", "municipio", "diretoria", "codigo_rede_ensino", vetor_nomes)

# caso de 2012
base12 <- read.csv2("bases_cruas/seduc/fluxo-escolar-municipio/Fluxo_Escolar_por_Municipio_2012.csv", sep = ",",
                    colClasses = rep("character", 13))%>%
            select(-CODMUN, -MUN)%>%
            set_names( "municipio", "codigo_rede_ensino", "rede_ensino", vetor_nomes)%>%
            mutate(ano = "2012",
            across(everything(), ~recode(.x, "NULL" = NA_character_)))


# caso de 2011
base11 <- read.csv2("bases_cruas/seduc/fluxo-escolar-municipio/Fluxo_Escolar_por_Municipio_2011.csv", sep = ",",
                    colClasses = rep("character", 13))%>%
            select(-starts_with("TOT"), -ends_with('A'))%>%
            set_names("ano", "municipio", vetor_nomes)%>%
            mutate( across(everything(), ~recode(.x, "NULL" = NA_character_)))

# pondo numa lista

lista <- list(base11,base12,base13,base14,base18, bases15_19)
basefinal <- reduce(lista, bind_rows)

# pegando os nomes dos municípios

bq_auth(path = "chavebigquery/My Project 55562-2deeaad41d85.json")
id_projeto <- "double-voice-305816"

con <- dbConnect(
  bigrquery::bigquery(),
  billing = id_projeto,
  project = "basedosdados"
)

query <- 'SELECT id_municipio, municipio, sigla_uf 
FROM `basedosdados.br_bd_diretorios_brasil.municipio`'

diretorio_com_id <- dbGetQuery(con, query)

# mudando o nome do municipio para se encaixar
diretorio_com_id_alt <- diretorio_com_id%>%
  mutate(municipio = str_to_upper(municipio))%>%
  mutate(municipio = str_replace_all(municipio, "Á", "A" ))%>%
  mutate(municipio = str_replace_all(municipio, "É", "E" ))%>%
  mutate(municipio = str_replace_all(municipio, "Í", "I" ))%>%
  mutate(municipio = str_replace_all(municipio, "Ó", "O" ))%>%
  mutate(municipio = str_replace_all(municipio, "Ú", "U" ))%>%
  mutate(municipio = str_replace_all(municipio, "Â", "A" ))%>%
  mutate(municipio = str_replace_all(municipio, "Ê", "E" ))%>%
  mutate(municipio = str_replace_all(municipio, "Î", "I" ))%>%
  mutate(municipio = str_replace_all(municipio, "Ô", "O" ))%>%
  mutate(municipio = str_replace_all(municipio, "Û", "U" ))%>%
  mutate(municipio = str_replace_all(municipio, "Ã", "A" ))%>%
  mutate(municipio = str_replace_all(municipio, "Õ", "O" ))%>%
  mutate(municipio = str_replace_all(municipio, "Ç", "C" ))%>%
  mutate(chave = str_c(sigla_uf,municipio))%>%
  select(chave, id_municipio)

# juntando com a base final

basefinal_comid <- basefinal%>%
  mutate(sigla_uf = "SP",
         chave = str_c(sigla_uf,municipio))%>%
  inner_join(diretorio_com_id_alt, by = 'chave')%>%
  select(-chave, -sigla_uf)


# exportando a base

export(basefinal_comid, "bases_prontas/fluxoescolarmun.csv", na = "")

