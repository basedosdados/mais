rm(list = ls())
setwd("~/basedosdados/br_ons_energia_armazenada/output")

# Instala pacote 'reservatoriosBR'
devtools::install_github('brunomioto/reservatoriosBR')

# Leitura
library(reservatoriosBR)
library(dplyr)
library(tidyverse)

# Baixar dados 

# Lista 
list_rename = c('data' = 'data',
                'energia_armazenada_maxima' = 'ear_max_subsistema_mwmes',
                'energia_armazenada_verificada' = 'ear_verif_subsistema_mwmes', 
                'proporcao_energia_armazenada_verificada' = 'ear_verif_subsistema_percentual',
                'subsistema' = 'subsistema')


#Limpa e salva dados

df = ONS_EAR_subsistemas(2000) %>% 
  as_tibble()%>%
  rename(list_rename)


write.csv(
  df,
  "~/output/microdados.csv",
  na = " ",
  row.names = F,
  fileEncoding = "UTF-8"
)
