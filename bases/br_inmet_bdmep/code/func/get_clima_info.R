get_clima_info <- function(file){
  
  clima <- data.table::fread(
    file = file,
    sep = ";",
    skip = 7, 
    dec = ",",
    #nrow = 50 - only for testing purposes
    )
  
  caract <- data.table::fread(
    file = file,
    nrows = 8, 
    header = FALSE,
    col.names= c("caract","value"))
  
  clima = clima[,-"V20"]
  
  names(clima) <- change_names(clima)
  
  #clima$regiao <- caract[1,2]
  #clima$uf <- caract[2,2]
  #clima$estacao <- caract[3,2]
  #clima$estacao <- stringr::str_to_title(as.character(clima$estacao))
  clima$id_estacao <- caract[4,2]
  #clima$latitude <- readr::parse_number(gsub(",","\\.",caract[5,2]))
  #clima$longitude <- readr::parse_number(gsub(",","\\.",caract[6,2]))
  #clima$altitude <- readr::parse_number(gsub(",","\\.",caract[7,2]))
  #clima$data_fundacao <- get_data(as.character(caract[8,2]))
  
  clima[clima == -9999] <- NA
  clima <- dplyr::mutate(clima, data = get_data(as.character(data)))
  clima[,3:19] <- clima[,3:19] %>% lapply(as.numeric)
  clima$hora <- as.numeric(substr(clima$hora, 1,2)) %>% 
    stringr::str_pad(2, pad =0) %>% paste0(., ":00:00")
  
  # if(include_city == TRUE){
  # data <- data.frame(latitude = readr::parse_number(gsub(",","\\.",caract[5,2])),
  #                    longitude = readr::parse_number(gsub(",","\\.",caract[6,2])))
  # city <- get_city(data)
  # clima$municipio <- city$municipio
  # clima$id_municipio <- city$id_municipio
  # }
  
  return(clima)
}

get_base_inmet <- function(year){
  
  year = year 
  
  files = fs::dir_ls(glue::glue("input/{year}"))
  
  base = purrr::map_dfr(files, get_clima_info)

  fs::dir_create(glue::glue("output/microdados/ano={year}"))
  name = paste0("output/microdados/ano=",year,"/microdados_", year,".csv")
  data.table::fwrite(base, name)
}
