library(tidyverse)
library(fs)

fs::dir_create(c("input", "output"))

utils::download.file(
  url = "https://ftp.ibge.gov.br/Precos_Indices_de_Precos_ao_Consumidor/IPCA/Serie_Historica/ipca_SerieHist.zip",
  destfile = "input/ipcaserie.zip"
)

zipF<- "D:\\Users\\Lucas\\br_ibge_inflacao\\input\\ipcaserie.zip"
outDir<-"C:\\Users\\Lucas\\br_ibge_inflacao\\input\\"

utils::unzip(zipF, exdir=outDir)

list.files("input/ipcaserie", pattern = ".xls", full.names = TRUE) %>% 
  readxl::read_excel(., skip = 6) -> df

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
    variacao_mes = `MÊS`,
    variacao_tres_meses = `MESES...5`,
    variacao_semestral = MESES...6,
    variacao_anual = `ANO`,
    variacao_doze_meses = `MESES...8`
  ) %>% 
  dplyr::filter(mes %in% names(months_br)) %>% 
  tidyr::fill(ano) %>% 
  dplyr::mutate(
    mes = months_br[mes] %>% unname(),
    dplyr::across(dplyr::everything(), as.numeric)
  ) %>% 
  readr::write_csv(file = "output/ipca.csv")
  