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

criadora_de_na <- function(x){ 
  x = ifelse(x == "", NA, x)
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
idesp_wide<-idesp_ef%>%
  bind_rows(idesp_em)%>%
  mutate(nivel_ensino = case_when(nivel_ensino == "EF ANOS INICIAIS" ~ "ef_iniciais",
                                  nivel_ensino == "EF ANOS FINAIS" ~ "ef_finais",
                                  nivel_ensino == "ENSINO MEDIO" ~ "em"))%>%
  pivot_wider(id_cols = c(id_escola_sp,id_escola, ano),
              names_from = nivel_ensino,
              values_from = nota_idesp)%>%
  rename( nota_idesp_ef_iniciais = ef_iniciais ,
         nota_idesp_ef_finais = ef_finais , nota_idesp_em = em)

# Mergindo com o diret?rio de escolas para termos id_municipio de onde esta cada escola

bq_auth(path = "chavebigquery/My Project 55562-2deeaad41d85.json")
id_projeto <- "double-voice-305816"

con <- dbConnect(
  bigrquery::bigquery(),
  billing = id_projeto,
  project = "basedosdados"
)

# Executando a query
query <- 'SELECT id_escola, id_municipio FROM `basedosdados.br_bd_diretorios_brasil.escola`'

diretorio_com_id <- dbGetQuery(con, query)

# Juntando com a base local

idesp_wide_identificado <- idesp_wide%>%
  left_join(diretorio_com_id, by = "id_escola")%>%
  select(ano, id_municipio, id_escola, id_escola_sp, nota_idesp_ef_iniciais,
         nota_idesp_ef_finais, nota_idesp_em)%>%
  distinct(.keep_all = TRUE)%>%
  arrange(ano)

# Exportando os dados
export(idesp_wide_identificado, "bases_prontas/idesp_escola.csv")
