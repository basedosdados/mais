# Pacote necessario para leitura e escrita dos arquivos .csv
#-------------------------------------------

install.packages("readr")
require(readr)

#-------------------------------------------

# Variavel do diretorio de trabalho, previsa ser modificado conforme o sistema
#-------------------------------------------

setwd ("~/br_bcb_estban/input")

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
