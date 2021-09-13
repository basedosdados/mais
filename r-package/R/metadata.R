


#' Internal function to abstact away HTTP requests.

bd_request <- function(endpoint, body = ? List()) {

  base_url <- "http://www.basedosdados.org/api/3/action/bd_"
  target_endpoint <- paste0(base_url, endpoint)

  httr::POST(
    target_endpoint,
    body = body,
    encode = 'json')

}



