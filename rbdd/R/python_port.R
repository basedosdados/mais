#'
#'
#' Write the results of a query locally to a comma-separated file.
#'
#' @param query a string containing a valid SQL query.
#' @param billing_project_id a string containing your billing project id. If you've run `set_billing_id` then feel free to leave this empty.
#' @param page_size `bigrquery` internal, how many rows per page should there be.
#' @param path String with the output file name. If running an R Project relative location can be provided. Passed to `readr::write_csv`'s `file` argument.
#' @return Invisibly returns the provided filename and triggers it's writing to disk as side-effect.
#' @details Currently there's only support for UTF-8 encoding. Users needing more control over writing should use `read_sql` to get the data in memory and use custom code from there.
#' @examples
#'
#' query <- "SELECT
#' pib.id_municipio,
#' pop.ano,
#' pib.PIB / pop.populacao * 1000 as pib_per_capita
#' FROM `basedosdados.br_ibge_pib.municipios` as pib
#' JOIN `basedosdados.br_ibge_populacao.municipios` as pop
#' ON pib.id_municipio = pop.id_municipio
#' LIMIT 5 "
#'
#' data <- download(query, "pip_per_capita_municipios.csv")
#'
#'
#'
#' @import bigrquery
#' @import readr
#' @import rlang
#' @import dplyr
#' @export
#'
#'


download <- function(
  query,
  path,
  billing_project_id = get_billing_id(),
  page_size = 1000) {

  if(!stringr::str_detect(path, ".csv")) {

    rlang::abort("Pass a valid file name to argument `path`.")

  }

  if(!rlang::is_character(query)) {

    rlang::abort("`query` argument must be a string.")

  }

  bigrquery::bq_project_query(
      billing_project_id,
      query = query) %>%
    bigrquery::bq_table_download(page_size = page_size, bigint = "integer64") %>%
    readr::write_csv(file = path)

  invisible(path)

}


#' Query out datalake and get results in a tibble
#'
#' @param query a string containing a valid SQL query.
#' @param billing_project_id a string containing your billing project id. If you've run `set_billing_id` then feel free to leave this empty.
#' @param page_size `bigrquery` internal, how many rows per page should there be.
#'
#' @result a tibble containing the query's result
#'
#' @examples
#'
#' query <- "SELECT
#' pib.id_municipio,
#' pop.ano,
#' pib.PIB / pop.populacao * 1000 as pib_per_capita
#' FROM `basedosdados.br_ibge_pib.municipios` as pib
#' JOIN `basedosdados.br_ibge_populacao.municipios` as pop
#' ON pib.id_municipio = pop.id_municipio
#' LIMIT 5 "
#'
#' data <- read_sql(query)
#'
#' # in case you want to write your data on disk as a .xlsx or .csv file
#' library(writexl)
#' library(readr)
#'
#' write_xlsx(data, "data.xlsx")
#' write_csv(data, "data.csv")
#'
#' @import bigrquery
#' @import rlang
#' @import magrittr
#' @export
#'


read_sql <- function(
  query,
  billing_project_id = get_billing_id(),
  page_size = 1000) {

  if(billing_project_id == FALSE) rlang::abort("You haven't set a Project Billing Id. Use the function `set_billing_id` to do so.")

  if(!rlang::is_character(query)) rlang::abort("`query` argument must contain valid SQL text")

  bigrquery::bq_project_query(
      billing_project_id,
      query = query) %>%
    bigrquery::bq_table_download(page_size = page_size, bigint = "integer64")

}


