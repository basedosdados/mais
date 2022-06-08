# Internal function to abstact away HTTP requests.

bd_request <- function(
  endpoint = ? typed::Character(length = 1),
  query = list() ? typed::List()) {

  base_url <- "https://basedosdados.org/api/3/action/bd_"
  target_endpoint <- paste0(base_url, endpoint)

  httr::GET(
    target_endpoint,
    encode = 'json',
    query = query) %>%
    httr::content() %>%
    purrr::pluck("result")

}
