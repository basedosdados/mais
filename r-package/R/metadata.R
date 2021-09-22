# Internal function to abstact away HTTP requests.

bd_request <- function(
  endpoint = ? Character(length = 1),
  query = list() ? List()) {

  base_url <- "https://basedosdados.org/api/3/action/bd_"
  target_endpoint <- paste0(base_url, endpoint)

  httr::GET(
    target_endpoint,
    encode = 'json',
    query = query)

}


#' Search for a dataset
#'
#'
#' @name dataset_search
#' @param search_term customize searches based on a given keyword
#' @param temporal_coverage customize search by temporal coverage
#'
#' @return
#'
#' @importFrom purrr map_chr pluck
#' @importFrom httr content
#'
#' @export
#' @examples
#'
#' dataset_search("agua")
#'  dataset_search("educação")
#'
#'


dataset_search <-
  Data.frame() ? function(
  search_term = NULL ? Character(length = 1, null_ok = TRUE),
  temporal_coverage = NULL ? Character(length = 1, null_ok = TRUE)) {

  bd_request(
    endpoint = "dataset_search",
    query = list(
      resource_type = "bdm_table",
      q = search_term,
      temporal_coverage = temporal_coverage,
      page_size = 100)) %>%
    httr::content() %>%
    purrr::pluck("result") ->
    search

  tibble::tibble(
    name = purrr::map_chr(
      .x = search$datasets,
      .f = ~ purrr::pluck(.x, "name")),
    id = purrr::map_chr(
      .x = search$datasets,
      .f = ~ purrr::pluck(.x, "id")),
    notes = purrr::map_chr(
      .x = search$datasets,
      .f = ~ purrr::pluck(.x, "notes")))

}


#' Describe a table
#'
#'
#' @param table_id a table name e.g. if addressing table "br_sp_alesp.deputado" then table_id is `deputado`
#' @param dataset_id a dataset name e.g. if addressing table "br_sp_alesp.deputado" then table_id is `br_sp_alesp`
#'
#'
#' @export
#' @examples
#'
#' get_table_columns("br_sp_alesp", "deputado")
#' @importFrom httr content
#' @importFrom purrr pluck map reduce
#' @importFrom dplyr bind_rows
#'
#'


get_table_columns <-
  Data.frame() ? function(
  dataset_id = ? Character(length = 1),
  table_id = ? Character(length = 1)) {

  bd_request(
    endpoint = "bdm_table_show",
    query = list(
      table_id = table_id,
      dataset_id = dataset_id)) %>%
    httr::content() %>%
    purrr::pluck("result") %>%
    purrr::pluck("columns") %>%
    purrr::map(tibble::as_tibble) %>%
    purrr::reduce(dplyr::bind_rows)

}




