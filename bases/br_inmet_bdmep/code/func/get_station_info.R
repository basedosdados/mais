get_stations <- function(file, include_city = TRUE){
  
  caract = data.table::fread(
    file = file,
    nrows = 8, 
    header = FALSE,
    col.names= c("caract","value"))
  
  regiao <- caract[1,2]
  uf <- caract[2,2]
  estacao <- caract[3,2]
  codigo <- caract[4,2]
  latitude <- caract[5,2]
  longitude <- caract[6,2]
  altitude <- caract[7,2]
  datafundacao <- as.character(caract[8,2])
  
  stations = data.frame(
    estacao = stringr::str_to_title(as.character(estacao)), 
    codigo = as.character(codigo), 
    #regiao = as.character(regiao), 
    #uf = as.character(uf), 
    latitude = readr::parse_number(gsub(",","\\.",latitude)), 
    longitude = readr::parse_number(gsub(",","\\.",longitude)),
    altitude = readr::parse_number(gsub(",","\\.", altitude)),
    data_fundacao = get_data(datafundacao))
  
  if(include_city == TRUE){
  stations = get_city(stations) 
  }
  
  return(stations)
}

get_stations_inmet <- function(year, include_city = TRUE){
  year = year 
  files = fs::dir_ls(glue::glue("input/{year}"))
  base = furrr::future_map_dfr(files, get_stations, include_city = include_city)
  base = dplyr::mutate(base, ano = year)
  
  #name = paste0("Bases/stations/station", year,".csv")
  #data.table::fwrite(base, name)
  
  return(base)
}
