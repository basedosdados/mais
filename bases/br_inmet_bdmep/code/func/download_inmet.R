download_inmet = function(year){
  temp = tempfile()
  url = paste0("https://portal.inmet.gov.br/uploads/dadoshistoricos/", year,".zip")
  download.file(url, temp)
  unzip(temp, exdir = "input")
  unlink(temp)
}

