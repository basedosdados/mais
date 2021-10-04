# Script para captura do estban

# Pacote necessario para download dos arquivos
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

#-------------------------------------------

# Variavel para extrair os arquivos .csv
#-------------------------------------------

lf_cs <- list.files(path = "." , pattern = ".ZIP" )

#------------------------------------------

# Laço para extração dos arquivos .csv  
#------------------------------------------
  
for (i in lf_cs){
  
  unzip(zipfile = i , exdir = "." )
  
}
  
#------------------------------------------- 

#Remoção dos arquivos .zip
#------------------------------------------- 

file.remove(lf_cs)
#-------------------------------------------

# Variaveis para auxilio de extração das informações .csv
#-------------------------------------------

lf_cs_ag <- list.files(path = ".", pattern = "_AG*")
lf_cs_mun <- list.files(path = ".", pattern = "ESTBAN.CSV")

#-------------------------------------------

#-------------------------------------------

# Laço para copias de celulas do .csv municipio para o novo data frame

#-------------------------------------------

for (i in lf_cs_mun){
  
  rad_mun_cs <- read_csv(i, guess_max = 999999)
  write_csv(rad_mun_cs, append = TRUE, file = "../output/br_bcb_estban.municipio.csv")
  
}


#-------------------------------------------


# Laço para copias de celulas do .csv municipio e agencia para o novo data frame

#-------------------------------------------

for (i in lf_cs_ag){
  
  rad_mun_cs <- read_csv(i, guess_max = 999999)
  write_csv(rad_mun_cs, append = TRUE, file = "../output/br_bcb_estban.agencia.csv")
  
}

