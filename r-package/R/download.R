#'
#'
#' Write the results of a query locally to a comma-separated file.
#'
#' @param query a string containing a valid SQL query.
#' @param table defaults to `NULL`. If a table name is provided then it'll be concatenated with "basedosdados." and the whole table will be returned.
#' @param billing_project_id a string containing your billing project id. If you've run `set_billing_id` then feel free to leave this empty.
#' @param page_size `bigrquery` internal, how many rows per page should there be.
#' @param path String with the output file's name. If running an R Project relative location can be provided. Passed to `readr::write_csv`'s `file` argument.
#' @param .na how should missing values be written in the resulting file? Value passed to `na` argument of `readr::write_csv`. Defaults to a whitespace.
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
#' path <- file.path(tempdir(), "pib_per_capita.csv")
#'
#' bare_query <- "SELECT *
#' FROM basedosdados.br_tse_eleicoes.bens_candidato
#' WHERE ano = 2020
#' AND sigla_uf = \'TO\'"
#'
#' download(query = bare_query, path = path)
#'
#' # or download the entire table
#' download(table = "br_tse_eleicoes.bens_candidato", path = path)
#'
#' }
#'
#'
#' @importFrom bigrquery bq_project_query bq_table_download
#' @importFrom readr write_csv
#' @importFrom rlang abort
#' @importFrom magrittr %>%
#' @importFrom stringr str_detect
#' @importFrom fs is_file dir_exists
#' @export
#'
#'


download <- function(
  query = NULL,
  table = NULL,
  path,
  billing_project_id = get_billing_id(),
  page_size = 100000,
  .na = " ") {

  if(!stringr::str_detect(path, ".csv")) {

    rlang::abort("Pass a valid file path to argument `path`, make sure to include the '.csv' suffix.")

  }

  if(rlang::is_null(table) & rlang::is_null(query)) { # none was supplied

    rlang::abort("No value was passed to `table` and `query`.")

  } else if (!rlang::is_null(table) == !rlang::is_null(query)) { # both were supplied

    rlang::abort("Both `table` and `query` arguments were supplied values. Choose one.")

  }

  if(!rlang::is_null(table) & rlang::is_null(query)) {

    query <- glue::glue("SELECT * FROM basedosdados.{table}")

    msg <- glue::glue("`{table}` was passed to argument `table`. The following query will be executed: {query}")
    rlang::inform(msg)

  }

  bigrquery::bq_project_query(
    billing_project_id,
    query = query) %>%
    bigrquery::bq_table_download(
      page_size = page_size,
      bigint = "integer64") %>%
    readr::write_csv(
      file = path,
      na = .na)

  invisible(path)

}


#' Query our datalake and get results in a tibble
#'
#' `read_sql` is given either a fully-written SQL query through the `query` argument or a valid table name through the `table` argument.
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
#' FROM `basedosdados.br_ibge_pib.municipio` as pib
#' JOIN `basedosdados.br_ibge_populacao.municipio` as pop
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
  page_size = 100000) {

  if(billing_project_id == FALSE) {

    rlang::abort("You haven't set a Project Billing Id. Use the function `set_billing_id` to do so.")

  }

  if(!rlang::is_string(query)) {

    rlang::abort("`query` argument must be a string.")

  }

  bigrquery::bq_project_query(
    billing_project_id,
    query = query) %>%
    bigrquery::bq_table_download(
      page_size = page_size,
      bigint = "integer64")

}


#'
#' Query a table by its name, without SQL code
#'
#' `read_sql` takes in SQL code and runs the query for you. `read_table("table")` will return the entire table or an error in case it doesn't exist.
#'
#' @param table defaults to `NULL`. If a table name is provided then it'll be concatenated with "basedosdados." and the whole table will be returned.
#' @param billing_project_id a string containing your billing project id. If you've run `set_billing_id` then feel free to leave this empty.
#' @param page_size `bigrquery` internal, how many rows per page should there be. Defaults to 10000, consider increasing if running into performance issues or big queries.
#' @param project which project should be consulted. Defaults to "basedosdados", but can be used to query custom versions of the datalake.
#'
#'
#' @examples
#'
#' \dontrun{
#'
#' # instead of a SQL query use a table name directly
#'
#' data <- read_table(table = "br_ibge_pib.municipio")
#' data <- read_table(table = "br_ibge_populacao.municipio")
#'
#' }
#'
#' @importFrom rlang abort is_string
#' @importFrom glue glue
#' @importFrom bigrquery as_bq_table bq_table_download

# read_table <- function(
#   table,
#   billing_project_id = get_billing_id(),
#   page_size = 100000,
#   project = "basedosdados") {
#
#   if(billing_project_id == FALSE) {
#
#     rlang::abort("You haven't set a Project Billing Id. Use the function `set_billing_id` to do so.")
#
#   }
#
#   if(!rlang::is_string(table)) {
#
#     rlang::abort("`query` argument must be a string.")
#
#   } else {
#
#     stringr::str_split(table, "\\.") %>%
#       purrr::pluck(1) %>%
#       purrr::set_names(c("dataset", "table")) ->
#       target
#
#   }
#
#   bigrquery::bq_table_download(
#     glue::glue("{project}.{purrr::pluck(target, 'dataset')}.{purrr::pluck(target, 'table')}"),
#     page_size = page_size,
#     bigint = "integer64",
#     max_results = Inf)
#
# }



#' Access a data sets' most relevant information
#'
#' @param dataset String, name of a data set.
#' @param option Binary. "Dictionary" will output the dataset's dictionary in tibble format. "Browse" will launch the data set's webpage.
#' @param billing_project_id a string containing your billing project id. If you've run `set_billing_id` then feel free to leave this empty.
#'
#' @return Returns information on a data set. If you want to check for factors' and variables' meanings, set `option` to "Dictionary".
#' If you prefer to check the data set's full webpage, where you can access the data sets' geographic and chronological range,
#' available data tables and Base dos Dados' members who are in charge of this data set, set `option` to "Browse".
#'
#'
#'
#'
#' @examples
#'
#' \dontrun{
#'
#' #Checking factors
#' dictionary("br_inep_censo_escolar")
#'
#' dictionary("br_me_rais")
#'
#' #Checking for was responsible for uploading this dataset
#'
#'
#' }
#'
#'
#' @import bigrquery
#' @import glue
#' @importFrom rlang abort is_character
#' @importFrom magrittr %>%
#' @export
#'
#'

# dictionary <- function(
#   dataset,
#   billing_project_id = get_billing_id(),
#   page_size = 100000) {
#
#   if(billing_project_id == FALSE) {
#
#     rlang::abort("You haven't set a Project Billing Id. Use the function `set_billing_id` to do so.")
#
#   }
#
#   if(!rlang::is_string(query)) {
#
#     rlang::abort("`query` argument must be a string.")
#
#   }
#
#   bigrquery::bq_project_query(
#     billing_project_id,
#     query = glue::glue("SELECT *
#                   FROM basedosdados.{dataset}.dicionario")) %>%
#     bigrquery::bq_table_download(bigint = "integer64")
#
# }



dataset_help <- function(dataset,
                         option = "dictionary",
                         billing_project_id = get_billing_id()){

  #first, throw an error if dataset is not a string
  if(!rlang::is_string(dataset)){
    rlang::abort(" 'dataset' must be a string")
  }

  #second, throw an error if the billing_project_id is not correct
  if(billing_project_id == FALSE) {

    rlang::abort("You haven't set a Project Billing Id. Use the function `set_billing_id` to do so.")

  }

  #Now the actual function

  #Option 1 : open the datasets' dictionary
  if(option == "dictionary"){

    #else, open the dict baby
    bigrquery::bq_project_query(
      billing_project_id,
      query = glue::glue("SELECT *
                  FROM basedosdados.{dataset}.dicionario")) %>%
      bigrquery::bq_table_download(bigint = "integer64")


  }

  #Option 2: browse the web for more info on the dataset
  else if(option == 'browse'){
    base_url <- "https://basedosdados.org/dataset/"
    endpoint <- stringr::str_replace_all(dataset,"_","-")
    browseURL(paste0(base_url,endpoint))
  }
}


