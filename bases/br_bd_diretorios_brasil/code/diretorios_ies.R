#####
library(tidyverse)
library(rio)

# funcoes

cria_estados <- function(x){
  x%>%
    mutate(sigla_uf = case_when(id_uf == "11" ~ "RO", id_uf == "12" ~ "AC", id_uf == "13" ~ "AM",
                                id_uf == "14" ~ "RR", id_uf == "15" ~ "PA", id_uf == "16" ~ "AP", id_uf == "17" ~ "TO",
                                id_uf == "21" ~ "MA", id_uf == "22" ~ "PI", id_uf == "23" ~ "CE", id_uf == "24" ~ "RN",
                                id_uf == "25" ~ "PB", id_uf == "26" ~ "PE", id_uf == "27" ~ "AL", id_uf == "28" ~ "SE", id_uf == "29" ~ "BA",
                                id_uf == "31" ~ "MG", id_uf == "32" ~ "ES", id_uf == "33" ~ "RJ", id_uf == "35" ~ "SP", 
                                id_uf == "41" ~ "PR", id_uf == "42" ~ "SC", id_uf == "43" ~ "RS",
                                id_uf == "50" ~ "MS", id_uf == "51" ~ "MT", id_uf == "52" ~ "GO", id_uf == "53" ~ "DF"))
}

# abrindo e rodando a base

setwd("/home/matheus/Documentos/bdmais")



rio::import("bases_cruas/DIRETORIO_ES.csv") %>% 
  purrr::set_names('id_ies', 'nome_ies', 'id_uf', 'id_municipio', 
            'id_rede_ies', 'rede_ies', 'tipo_instituicao', 'situacao_funcionamento') %>%
  cria_estados() %>% 
  mutate(rede_ies = 
           case_when(rede_ies == "FEDERAL" ~ "Federal",
                     rede_ies == "ESPECIAL" ~ "Especial",
                     rede_ies == "ESTADUAL" ~ "Estadual",
                     rede_ies == "MUNICIPAL" ~ "Municipal",
                     rede_ies == "PRIVADA" ~ "Privada"),
         
         situacao_funcionamento = 
           case_when(situacao_funcionamento == "ATIVA" ~ "Ativa",
                     situacao_funcionamento == "INATIVA" ~ "Inativa"),
         
         tipo_instituicao = 
           case_when(tipo_instituicao == "PUBLICA" ~ "Publica",
                     tipo_instituicao == "PRIVADA" ~ "Privada"))%>% 
  filter(id_municipio != is.na(id_municipio)) %>% 
  select(-id_uf) %>% 
  export("bases_prontas/diretorios/diretorio_ies.csv")
  

#######-----------------------
teste <-rio::import("bases_cruas/DIRETORIO_ES.csv")%>%
    set_names('id_ies', 'nome_ies', 'id_uf', 'id_municipio', 
              'id_dependencia_administrativa', 'rede_ies', 'tipo_instituicao', 'situacao_funcionamento') %>% 
    group_by(tipo_instituicao)



