# Biblioteca
library(tidyverse)
library(rio)
library(DBI)
library(bigrquery)
library(reshape2)

# diretorio
setwd("~/Documentos/bdmais")

# Abrindo a base
idesp_iniciais <- import("bases_cruas/seduc/idesp-escolas/IDESP_Escolas_2007_2019_AI.csv", setclass = "tibble")
idesp_finais <- import("bases_cruas/seduc/idesp-escolas/IDESP_Escolas_2007_2019_AF.csv", setclass= "tibble")
idesp_medio <-import("bases_cruas/seduc/idesp-escolas/IDESP_Escolas_2007_2019_EM.csv", setclass = "tibble")

vetor_anos <- c("2007","2008","2009","2010","2011","2012","2013","2014",
                "2015","2016","2017","2018","2019")

# Função que muda o formato dos dados
organizadora<- function(x){
  x%>%
  set_names("id_escola_sp", "id_escola", "diretoria", "nome_escola", "municipio", "nivel_ensino",
            vetor_anos)%>%
  melt(id.vars = c("id_escola_sp", "id_escola", "diretoria", "nome_escola", "municipio", "nivel_ensino"),
       variable.names = "nota_idesp")%>%
  rename(ano = variable, nota_idesp = value)%>%
  filter(! nome_escola == "")%>%
  mutate(nota_idesp = as.character(nota_idesp))
}

# Aplicando em anos iniciais e anos finais do ensino fundamental
idesp_ef<- organizadora(idesp_iniciais)%>%
        bind_rows(organizadora(idesp_finais))%>%
        mutate(nivel_ensino = ifelse(nivel_ensino == "ANOS INICIAIS", "EF ANOS INICIAIS", "EF ANOS FINAIS"))

idesp_em <- organizadora(idesp_medio)

# Mudando de virgula para ponto
idesp_ef$nota_idesp <- str_replace(idesp_ef$nota_idesp, ",", ".")
idesp_em$nota_idesp <- str_replace(idesp_em$nota_idesp, ",", ".")

# Juntando ensino fundamental com ensino m?dio
idesp_long <-idesp_ef%>%
  bind_rows(idesp_em)

# Mergindo com o diret?rio de escolas para termos id_municipio de onde esta cada escola

bq_auth(path = "chavebigquery/My Project 55562-2deeaad41d85.json")
id_projeto <- "double-voice-305816"

con <- dbConnect(
  bigrquery::bigquery(),
  billing = id_projeto,
  project = "basedosdados"
)

# Executando a query
query <- 'SELECT id_escola, id_municipio, rede
FROM `basedosdados.br_inep_ideb.escola`
WHERE ano = 2019
GROUP BY id_escola, id_municipio, rede'

diretorio_com_id <- dbGetQuery(con, query)

# Juntando com a base local

idesp_long_identificado <- idesp_long%>%
  inner_join(diretorio_com_id, by = "id_escola")

# Exportando os dados
export(idesp_long_identificado, "bases_prontas/idesp_fundamental_medio.csv")
