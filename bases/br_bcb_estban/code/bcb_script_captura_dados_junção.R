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

# Variaveis para o download dos dados 
#-------------------------------------------
  
bcb_url <- read_html("https://www4.bcb.gov.br/fis/cosif/estban.asp?frame=1")
bcb_wrapper <- html_elements(bcb_url, "option") %>% html_attr("value")  
bcb_extrc_str_agen_mun <- substr(bcb_wrapper, start = 32, stop = 51)
bcb_extrc_str_mun <- substr(bcb_wrapper, start = 34, stop = 51)

#-------------------------------------------

# Laço para download dos arquivos .ZIP municipio
#-------------------------------------------

for (i in bcb_extrc_str_mun){
  
  
  bcb_down_fi <- paste0("https://www4.bcb.gov.br/fis/cosif/cont/estban/municipio/", i)
  download.file(url = bcb_down_fi, destfile = i ,cacheOK = TRUE)
  
}

#-------------------------------------------

# Laço para download dos arquivos .ZIP municipio e agencia
#-------------------------------------------

for (i in bcb_extrc_str_agen_mun){

  
  bcb_down_fi <- paste0("https://www4.bcb.gov.br/fis/cosif/cont/estban/agencia/", i)
  download.file(url = bcb_down_fi, destfile = i ,cacheOK = TRUE)
  
}

# Variaveis para auxilio de extração das informações .csv
#-------------------------------------------

lf_zcs_mun <- list.files(path = "." , pattern = "ESTBAN.ZIP")
lf_zcs_ag <- list.files(path = "." , pattern = "ESTBAN_AG.ZIP")
lf_zi_all <- list.files(path = "." , pattern = "*.ZIP")

#-------------------------------------------

#-------------------------------------------

# Laço para copias de celulas do .csv municipio para o novo data frame

#-------------------------------------------

for (i in lf_zcs_mun){
  
  rad_mun_cs <- read_csv(i, skip = 2)
  write_csv(rad_mun_cs, append = TRUE, file = "dat_cons_mun.csv")
  
}


#-------------------------------------------


# Laço para copias de celulas do .csv municipio e agencia para o novo data frame

#-------------------------------------------

for (i in lf_zcs_ag){
  
  rad_mun_cs <- read_csv(i, skip = 2)
  write_csv(rad_mun_cs, append = TRUE , file = "dat_cons_ag.csv")
  
}


#-------------------------------------------

#Remoção dos arquivos .zip
#------------------------------------------- 

file.remove(lf_zi_all)

#-------------------------------------------
