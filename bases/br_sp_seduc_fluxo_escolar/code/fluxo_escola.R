# bibliotecas
library(tidyverse)
library(rio)
library(DBI)
library(bigrquery)
library(reshape2)
library(glue)
library(data.table)

# diretorio
setwd("~/Documentos/bdmais")

vetor_nomes <- c("prop_aprovados_anos_inciais_ef","prop_reprovados_anos_iniciais_ef", 
  "prop_abandono_anos_iniciais_ef", "prop_aprovados_anos_finais_ef","prop_reprovados_anos_finais_ef", 
  "prop_abandono_anos_finais_ef", "prop_aprovados_em", "prop_reprovados_em","prop_abandono_em")

# importando os dados
coladora<- function(i) {glue("bases_cruas/seduc/fluxo-escolar-escola/Fluxo_Escolar_por_Escola_", i ,".csv")}

lista_nomes <- map(2011:2019, coladora)
lista_tibbles <- map(lista_nomes, data.table::fread, colClass = "character")

# tibbles que já estão com a mesma estrutura
lista_tibbles_iguais <- lista_tibbles[3:9]

binded_tibbles_iguais <-reduce(lista_tibbles_iguais, bind_rows)%>%
  mutate(ano = case_when(ANO == "2019" ~ "2019",
                         ANO == "2018" ~ "2018",
                         Ano == "2017" ~ "2017",
                         Ano == "2016" ~ "2016",
                         Ano == "2015" ~ "2015",
                         Ano == "2014" ~ "2014",
                         Ano == "2013" ~ "2013"))%>%
  select(-ANO, -Ano)%>%
  set_names("diretoria", "municipio", "codigo_rede_ensino", 'id_escola_sp', 'nome_escola', 
             vetor_nomes,'codigo_tipo_escola', 'ano')%>%
  filter(id_escola_sp != "")

# tibbles diferentes
tibble2 <- lista_tibbles[[2]]%>%
  select(-1,-2,-3,-4,-5, -CODMUN)%>%
  set_names("diretoria", "municipio", "id_escola_sp", "nome_escola", vetor_nomes)%>%
  mutate(ano = "2012")

tibble1 <- lista_tibbles[[1]]%>%
  select(-1,-ends_with('1A'), -ends_with('2A'))%>%
  set_names("ano", "diretoria", "municipio", "codigo_rede_ensino", "id_escola_sp", "nome_escola", vetor_nomes)

#juntando tudo

lista_arrumada <- list(tibble1, tibble2, binded_tibbles_iguais)

basefinal <- reduce(lista_arrumada, bind_rows)%>%
  mutate(id_escola_sp = str_remove(id_escola_sp, "^0+"),
         id_escola = case_when(nchar(id_escola_sp) == 1 ~ str_c("3500000", id_escola_sp),
                               nchar(id_escola_sp) == 2 ~ str_c("350000", id_escola_sp),
                               nchar(id_escola_sp) == 3 ~ str_c("35000", id_escola_sp),
                               nchar(id_escola_sp) == 4 ~ str_c("3500", id_escola_sp),
                               nchar(id_escola_sp) == 5 ~ str_c("350", id_escola_sp),
                               nchar(id_escola_sp) == 6 ~ str_c("35", id_escola_sp)))



# pegando os ids dos municípios

bq_auth(path = "chavebigquery/My Project 55562-2deeaad41d85.json")
id_projeto <- "double-voice-305816"

con <- dbConnect(
  bigrquery::bigquery(),
  billing = id_projeto,
  project = "basedosdados"
)

query <- 'SELECT id_escola, id_municipio FROM `basedosdados.br_bd_diretorios_brasil.escola`'

diretorio_com_id <- dbGetQuery(con, query)%>%
  mutate(id_escola = as.character(id_escola))

# mudando o nome do municipio para se encaixar
# diretorio_com_id_alt <- diretorio_com_id%>%
#   mutate(municipio = str_to_upper(municipio))%>%
#   mutate(municipio = str_replace_all(municipio, "Á", "A" ))%>%
#   mutate(municipio = str_replace_all(municipio, "É", "E" ))%>%
#   mutate(municipio = str_replace_all(municipio, "Í", "I" ))%>%
#   mutate(municipio = str_replace_all(municipio, "Ó", "O" ))%>%
#   mutate(municipio = str_replace_all(municipio, "Ú", "U" ))%>%
#   mutate(municipio = str_replace_all(municipio, "Â", "A" ))%>%
#   mutate(municipio = str_replace_all(municipio, "Ê", "E" ))%>%
#   mutate(municipio = str_replace_all(municipio, "Î", "I" ))%>%
#   mutate(municipio = str_replace_all(municipio, "Ô", "O" ))%>%
#   mutate(municipio = str_replace_all(municipio, "Û", "U" ))%>%
#   mutate(municipio = str_replace_all(municipio, "Ã", "A" ))%>%
#   mutate(municipio = str_replace_all(municipio, "Õ", "O" ))%>%
#   mutate(municipio = str_replace_all(municipio, "Ç", "C" ))%>%
#   mutate(chave = str_c(sigla_uf,municipio))%>%
#   select(chave, id_municipio)

basefinal_comidmunicipio <- basefinal%>%
  mutate(sigla_uf = "SP",
         rede = case_when(codigo_rede_ensino == 1 ~ "estadual"))%>%
  left_join(diretorio_com_id, by = "id_escola")%>%
  filter(!id_escola_sp == "")%>%
  select(-nome_escola, -municipio, -codigo_rede_ensino)%>%
  distinct(.keep_all = TRUE)

# exportando
export(basefinal_comidmunicipio, "bases_prontas/fluxoescolarescola1.csv", sep = ",")
         

