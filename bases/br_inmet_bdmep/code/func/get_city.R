brasil_r <- geobr::read_municipality(year = 2020)
brasil_r <- as(brasil_r, 'Spatial')

get_city <- function(data){
  
  city_names = raster::extract(brasil_r, data[, c("longitude", "latitude")])
  
  data$municipio = city_names$name_muni
  data$id_municipio = city_names$code_muni
  
  return(data)
}
