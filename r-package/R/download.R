#'
#'
#' Write the results of a query locally to a comma-separated file.
#'
#' @param query a string containing a valid SQL query.
#' @param billing_project_id a string containing your billing project id. If you've run `set_billing_id` then feel free to leave this empty.
#' @param page_size `bigrquery` internal, how many rows per page should there be.
#' @param path String with the output file's name. If running an R Project relative location can be provided. Passed to `readr::write_csv`'s `file` argument.
#'
#' @return Invisibly returns the query's output in a tibble. Intended to be used for side-effects. If you simply want to load a query's result in memory, use `read_sql`.
#'
#' @details Currently there's only support for UTF-8 encoding. Users requiring more control over writing should use `read_sql` to get the data in memory and custom code from there.
#'
#'
#' @examples
#'
#' \dontrun{
#'
#' dir <- tempdir()
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
#' data <- download(query, file.path(dir, "pib_per_capita.csv"))
#' }
#'
#'
#' @importFrom bigrquery bq_project_query bq_table_download
#' @importFrom readr write_csv
#' @importFrom rlang abort
#' @importFrom magrittr %>%
#' @importFrom stringr str_detect
#' @importFrom fs is_file
#' @export
#'
#'


download <- function(
  query,
  path,
  billing_project_id = get_billing_id(),
  page_size = 1000) {

  if(!stringr::str_detect(path, ".csv") | !fs::is_file(path)) {

    rlang::abort("Pass a valid file path to argument `path`, make sure to include the '.csv' suffix.")

  }

  if(!rlang::is_character(query)) {

    rlang::abort("`query` argument must be a string.")

  }

  bigrquery::bq_project_query(
    billing_project_id,
    query = query) %>%
    bigrquery::bq_table_download(
      page_size = page_size,
      bigint = "integer64") %>%
    readr::write_csv(file = path)

  invisible(path)

}


#' Query our datalake and get results in a tibble
#'
#' @param query a string containing a valid SQL query.
#' @param billing_project_id a string containing your billing project id. If you've run `set_billing_id` then feel free to leave this empty.
#' @param page_size `bigrquery` internal, how many rows per page should there be. Defaults to 10000, consider increasing if running into performance issues or big queries.
#'
#' @return A tibble containing the query's output.
#'
#' @examples
#'
#' \dontrun{
#'
#' set_billing_id("<your id here>")
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
#' # in case you want to write your data on disk as a .xlsx, .csv or .Rds file.
#'
#' library(writexl)
#' library(readr)
#'
#' dir <- tempdir()
#'
#' write_xlsx(data, file.path(dir, "data.xlsx"))
#' write_csv(data, file.path(dir, "data.csv"))
#' saveRDS(data, file.path(dir, "data.Rds"))
#'
#'}
#'
#' @import bigrquery
#' @importFrom rlang abort is_character
#' @importFrom magrittr %>%
#' @export
#'


read_sql <- function(
  query,
  billing_project_id = get_billing_id(),
  page_size = 10000) {

  if(billing_project_id == FALSE) {

    rlang::abort("You haven't set a Project Billing Id. Use the function `set_billing_id` to do so.")

  }

  if(!rlang::is_character(query)) {

    rlang::abort("`query` argument must contain valid SQL text")

  }

  bigrquery::bq_project_query(
    billing_project_id,
    query = query) %>%
    bigrquery::bq_table_download(
      page_size = page_size,
      bigint = "integer64")

}


#' Read a table by name
#'
#'
#'
#'
#' @param table a table name
#' @param page_size a page_size parameter
#'
#' @return The table's content in a tibble
#'
#'
#'
#'

read_table <- function(table, page_size = 10000, billing_id = ) {




  bigrquery::as_bq_table(table) %>%
    bigrquery::bq_table_download(
      page_size = page_size,
      bigint = "integer64")



}


#'
#' @param
#'
#'
#' @return
#'
#'
#' @importFrom
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'

dictionary <- function(dict, billing_ig = get_billing_id()) {


  # TODO: adicionar uma validação do nome do dicionário
  # se não estiver entre os válidos, retornar uma exceção com rlang::abort()
  # TODO: documentar a função

  bigrquery::bq_project_query(
    billing_project_id,
    query =
      glue::glue(
        "
        SELECT *

        FROM basedosdados.br_bd_diretorios_brasil.diretorio.{dict}
        ")) %>%
    bigrquery::bq_table_download(
      page_size = 10000,
      bigint = "integer64")





}




