library(tidyverse)
library(fs)

fs::dir_create(c("input", "output"))

utils::download.file(
  url = "https://ftp.ibge.gov.br/Precos_Indices_de_Precos_ao_Consumidor/IPCA_15/Series_Historicas/ipca-15_SerieHist.zip",
  destfile = "input/ipca15serie.zip"
)

utils::unzip("input/ipca15serie.zip", exdir = "input")

df = list.files("input/", pattern = ".xls", full.names = TRUE) %>% 
  readxl::read_excel(., skip = 7)

months_br <- c(
  "JAN" = 1, 
  "FEV" = 2,
  "MAR" = 3,
  "ABR" = 4,
  "MAI" = 5,
  "JUN" = 6,
  "JUL" = 7,
  "AGO" = 8,
  "SET" = 9,
  "OUT" = 10,
  "NOV" = 11,
  "DEZ" = 12
)

df %>% 
  dplyr::rename(
    ano = ...1, 
    mes = ...2, 
    indice = ...3, 
    variacao_mes = `NO MÊS`,
    variacao_tres_meses = `3 MESES`,
    variacao_semestral = SEMESTRAL,
    variacao_anual = `NO ANO`,
    variacao_doze_meses = `12 MESES`
  ) %>% 
  dplyr::filter(mes %in% names(months_br)) %>% 
  tidyr::fill(ano) %>% 
  dplyr::mutate(
    mes = months_br[mes] %>% unname(),
    dplyr::across(dplyr::everything(), as.numeric)
  ) %>% 
  readr::write_csv(file = "output/ipca15.csv")