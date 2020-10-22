
#install.packages("read.dbc") You need this package
library("read.dbc")

dbc2dbf <- function(rawDir, convertedDir, file) {
  
  x <- read.dbc(paste(rawDir, "/", file, sep=""))
  write.csv(x, file=paste(convertedDir, "/", substr(file,1,nchar(file)-4), ".csv", sep=""))
  
}

args = commandArgs(trailingOnly=TRUE)
try(dbc2dbf(args[1], args[2], args[3]), TRUE)
