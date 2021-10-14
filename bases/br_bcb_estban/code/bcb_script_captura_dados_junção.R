# Script para captura do estban

# Pacote necessario para download dos arquivos e junção
#-------------------------------------------

  install.packages("readr")
  install.packages("rvest")
  require(readr)
  require(rvest)

#-------------------------------------------

# Variavel do diretorio de trabalho, previsa ser modificado conforme o S.O
#-------------------------------------------

setwd ("~/br_bcb_estban/input")

#-------------------------------------------

# Variaveis para o auxilio da transferencia dos dados 
#-------------------------------------------
  
bcb_url <- read_html("https://www4.bcb.gov.br/fis/cosif/estban.asp?frame=1")
bcb_wrapper <- html_elements(bcb_url, "option") %>% html_attr("value")  
bcb_extrc_str_agen_mun <- substr(bcb_wrapper, start = 32, stop = 51)
bcb_extrc_str_mun <- substr(bcb_wrapper, start = 34, stop = 51)


# Laço para download dos arquivos .zip consolidação dos dados municipio para o novo dataframe
#-------------------------------------------

for (i in bcb_extrc_str_mun) {
  
  lf_zcs_mun <- list.files(path = ".", pattern = "ESTBAN.ZIP")
  bcb_down_fi_mun <- paste0("https://www4.bcb.gov.br/fis/cosif/cont/estban/municipio/", i)
  download.file(url = bcb_down_fi_mun, destfile = i ,cacheOK = TRUE)
  write_csv(read_csv(lf_zcs_mun, skip = 2, name_repair = "universal"), append = TRUE, "dat_cons_mun.csv")
  file.remove(lf_zcs_mun)
  
}

#-------------------------------------------

# Laço para download dos arquivos .zip e consolidação dos dados municipio e agencia para o novo dataframe
#-------------------------------------------

for (i in bcb_extrc_str_agen_mun) {
  
  lf_zcs_ag <- list.files(path = ".", pattern = "ESTBAN_AG.ZIP" )
  bcb_down_fi_mun_ag <- paste0("https://www4.bcb.gov.br/fis/cosif/cont/estban/agencia/", i)
  download.file(url = bcb_down_fi_mun_ag, destfile = i ,cacheOK = TRUE)
  write_csv(read_csv(lf_zcs_ag, skip = 2, name_repair = "universal"), append = TRUE, "dat_cons_ag.csv")
  file.remove(lf_zcs_ag)
  
}

#-------------------------------------------
