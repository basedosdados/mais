library(dplyr)

estados <- c("RO", "AC", "AM", "RR", "PA", "AP", "TO", "MA", "PI", "CE", "RN",
             "PB", "PE", "AL", "SE", "BA", "MG", "ES", "RJ", "SP", "PR", "SC",
             "RS", "MS", "MT", "GO", "DF")

anos <- c("09", "10", "11","12","13", "14", "15","16","17","18","19")

links = merge(estados, anos, all=TRUE) %>%
  mutate(links = glue::glue("ftp://ftp.datasus.gov.br/dissemin/publicos/SINAN/DADOS/FINAIS//VIOL{x}{y}.dbc")) %>%
  pull(links)

download_sinan = function(link){
  temp <- tempfile()
  name = fs::path_file(link) %>% paste0("input/",.) %>% gsub(".dbc", ".csv",.)
  download.file(link, temp, mode = "wb")
  partial <- read.dbc::read.dbc(temp)
  write.csv(partial, name)
  file.remove(temp)
}

purrr::walk(links, download_sinan)
