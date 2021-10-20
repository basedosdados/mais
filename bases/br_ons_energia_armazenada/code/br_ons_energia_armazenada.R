rm(list = ls())

#### Pacotes + Diretorios ####

# Leitura
library(dplyr)
library(tidyverse)
library(fs)

# Definir e criar pasta diretorios 
setwd('/content/br_ons_subsistemas')
fs::dir_create(c('input', 'output', 'code'))

#### Tratamento ####

# Lista 
list_rename = c('data' = 'data_medicao',
                'energia_armazenada_maxima' = 'ear_max_subsistema_mwmes',
                'energia_armazenada_verificada' = 'ear_verif_subsistema_mwmes', 
                'proporcao_energia_armazenada_verificada' = 'ear_verif_subsistema_percentual',
                'subsistema' = 'subsistema')

ons_subsistema <- function(ano_inicial=2000, ano_final=format(Sys.Date(), "%Y")){
  
  if(ano_inicial < 2000|
     ano_final > format(Sys.Date(), "%Y")){
    message("Escolha um ano inicial igual ou maior que 2000 e um ano final igual ou menor que ", format(Sys.Date(), "%Y"))
  }else{
    
    anos <- seq(ano_inicial,ano_final)
    
    message("Buscando dados diários de ", ano_inicial, " até ", ano_final, "...")
    
    historico <- list()
    
    for (i in anos) {
      dados_ons <- utils::read.csv(glue::glue("https://ons-dl-prod-opendata.s3.amazonaws.com/dataset/ear_subsistema_di/EAR_DIARIO_SUBSISTEMA_{i}.csv"),sep = ";")
      historico[[i]] <- dados_ons
    }
    
    historico_ear <- do.call(rbind, historico)
    
    message("Organizando os dados...")
    
    historico_ear_clean <- historico_ear %>%
      dplyr::mutate(subsistema = dplyr::recode(id_subsistema,
                                               N = "Norte",
                                               NE = "Nordeste",
                                               SE = "Sudeste / Centro-Oeste",
                                               S = "Sul")) %>%
      dplyr::select(-id_subsistema, -nom_subsistema) %>%
      dplyr::rename(data_medicao = ear_data,
                    ear_max_subsistema_mwmes = ear_max_subsistema) %>%
      dplyr::select(data_medicao, subsistema, ear_max_subsistema_mwmes, ear_verif_subsistema_mwmes, ear_verif_subsistema_percentual)
    
    historico_ear_clean$data_medicao <- as.Date(historico_ear_clean$data_medicao)
    
    return(historico_ear_clean)
    
  }
}

#### Limpa e salva dados ####

df = ons_subsistema(ano_inicial= 2000, ano_final= 2021) %>% 
  as_tibble()%>%
  rename(list_rename)%>%
  readr::write_csv(file = "output/microdados.csv")

