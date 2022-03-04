rm(list = ls())

setwd("~/br_ana_reservatorios/code")


library(reservatoriosBR)
library(dplyr)
library(magrittr)
library(purrr)
library(readr)


data_csv <- read_csv("https://raw.githubusercontent.com/brunomioto/reservatorios_data/master/dados/reservatorios.csv",
                     col_types =  cols(
                       data = col_date()
                     ))


reservatorios_dif <- reservatoriosBR::tabela_reservatorios() %>% 
  filter(sistema == "sin") %>%
  distinct(codigo)

busca_res <- function(codigo_reservatorio){
  
  reservatoriosBR::reservatorio_sin(codigo_reservatorio, data_inicial = Sys.Date()-2, data_final = Sys.Date())
  
}

dados_reservatorios <- purrr::map_dfr(reservatorios_dif$codigo,
                                      busca_res)

new_data <- rbind(data_csv, dados_reservatorios)

new_data2 <- new_data %>% 
  distinct() %>% 
  arrange(codigo_reservatorio, data)

new_data2$data <- as.Date(new_data2$data)


list_rename = c(
  'data'                  = 'data',                   
  'codigo_reservatorio'   = 'codigo_reservatorio',    
  'reservatorio'          = 'reservatorio',          
  'cota'                  = 'cota_m',                 
  'afluencia'             = 'afluencia_m3_s',         
  'defluencia'            = 'defluencia_m3_s',       
  'vazao_vertida'         = 'vazao_vertida_m3_s',
  'vazao_turbinada'       = 'vazao_turbinada_m3_s',   
  'vazao_natural'         = 'vazao_natural_m3_s',    
  'proporcao_volume_util' = 'volume_util_percentual', 
  'vazao_incremental'     = 'vazao_incremental_m3_s')

new_data2 = new_data2 %>% 
  rename(list_rename)


write.csv(
  new_data2,
  "C:/Users/Crislane/Desktop/br_ana_reservatorios/output/microdados_sin",
  na = " ",
  row.names = F,
  fileEncoding = "UTF-8"
)


