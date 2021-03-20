
#---------------------------------------------------------#
# preface
#---------------------------------------------------------#

library(foreign)
library(read.dbc)

setwd("~/Dropbox/Academic/Data/Brazil/DataSUS/Sistema de Informacoes sobre Mortalidade (SIM)")

#---------------------------------------------------------#
# build 
#---------------------------------------------------------#

file.names <- grep("DO", dir("input/dbc", pattern=".dbc"), value=TRUE)

dir.create("input/csv")

for(file in file.names){
  
  df.file <- read.dbc(paste0("input/dbc/",file))
  write.csv(df.file, paste0("input/csv/",substr(file,1,8),".csv"))
  
}
