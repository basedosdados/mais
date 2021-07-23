get_data <- function(chr){
  
  if(grepl("-", chr)){
    x= strsplit(chr, split = "-")[[1]][1]
  }
  
  if(grepl("/", chr)){
    x= strsplit(chr, split = "/")[[1]][1]
  }
  
  if(nchar(x)==4){
    y = lubridate::ymd(chr)
  }
  if(nchar(x)==2){
    y = lubridate::dmy(chr)
  }
  
  return(y)
}
