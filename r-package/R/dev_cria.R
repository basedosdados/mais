#' Transform Brazilian UF code to UF name
#'
#' @description
#'
#' Automatically change a column that contains brazillian UF codes (e.g. 11,31,41) 
#' into a colunm that contains brazillian UF reduced names (e.g. AM, MG, PR). Soon: automatically changes a column 
#' into the basedosdados aesthetics
#' 
#'
#'
#' @importFrom dplyr mutate case_when 
#' @importFrom magrittr %>% 
#' @import tibble
#' @export
#'
#' @return No return.
#'
#' @param base a tibble that contains a column that should be changed from id_uf to sigla_uf. Dataframes and other data formats will trigger an error.
#' @param coluna a tibble column that contains the actual values of id_uf to be converted in sigla_uf.
#'
#' @examples
#'
#' \dontrun{
#' tibble%>%dev_cria_estados(id_uf)
#'
#' # you can also not use the pipe
#' 
#' dev_cria_estados()
#'
#' 
#'
#'
#' }
#'


dev_cria <- function(base, coluna, oque=estado) {
  
  if(oque = estado){
  
  
  if(!tibble::is_tibble(base)) {
    
    rlang::abort("`base` must be a tibble. Consider using tibble::as_tibble to convert.")
    
  } else if(paste0("coluna") %in% columns(base)) {
    
    rlang::abort("Coluna is not a column in base")
    
  } else if(!rlang::is_vector(coluna)) {
    
    rlang::abort("Coluna is not a vector. You must insert a vector in this argument.")
    
  } 
  #falta informar caso algum valor na coluna original esteja errado
  # else if(!rlang::is_vector(coluna)) {
  #   
  #   rlang::inform("Coluna contains value")
  #   
  # } 
  # 
  base%>%
    mutate(sigla_uf = 
             case_when(coluna == "11" ~ "RO", coluna == "12" ~ "AC", coluna == "13" ~ "AM",
                       coluna == "14" ~ "RR", coluna == "15" ~ "PA", coluna == "16" ~ "AP", coluna == "17" ~ "TO",
                       coluna == "21" ~ "MA", coluna == "22" ~ "PI", coluna == "23" ~ "CE", coluna == "24" ~ "RN",
                       coluna == "25" ~ "PB", coluna == "26" ~ "PE", coluna == "27" ~ "AL", coluna == "28" ~ "SE", 
                       coluna == "29" ~ "BA", coluna == "31" ~ "MG", coluna == "32" ~ "ES", coluna == "33" ~ "RJ", 
                       coluna == "35" ~ "SP", coluna == "41" ~ "PR", coluna == "42" ~ "SC", coluna == "43" ~ "RS",
                       coluna == "50" ~ "MS", coluna == "51" ~ "MT", coluna == "52" ~ "GO", coluna == "53" ~ "DF",
                       coluna == 11 ~ "RO", coluna == 12 ~ "AC", coluna == 13 ~ "AM",
                       coluna == 14 ~ "RR", coluna == 15 ~ "PA", coluna == 16 ~ "AP", coluna == 17 ~ "TO",
                       coluna == 21 ~ "MA", coluna == 22 ~ "PI", coluna == 23 ~ "CE", coluna == 24 ~ "RN",
                       coluna == 25 ~ "PB", coluna == 26 ~ "PE", coluna == 27 ~ "AL", coluna == 28 ~ "SE", 
                       coluna == 29 ~ "BA", coluna == 31 ~ "MG", coluna == 32 ~ "ES", coluna == 33 ~ "RJ", 
                       coluna == 35 ~ "SP", coluna == 41 ~ "PR", coluna == 42 ~ "SC", coluna == 43 ~ "RS",
                       coluna == 50 ~ "MS", coluna == 51 ~ "MT", coluna == 52 ~ "GO", coluna == 53 ~ "DF"))

  
  rlang::inform('sigla_uf set successfully: all your values were adequate')
  
}
}
  
tibble::tibble( id_uf = 11)

