#' Here are functions cloning the original python client's functionality


#' Download a table locally
#'
#' @param query a string contaning valid a SQL query.
#' @param savepath a path describing where the table should be saved. Defaults to the current working directory.
#' @param billin_project_id a string containing your billing project id. If you've run `set_billing_id` then feel free to leave this empty.


download <- function(
  query,
  savepath = getwd(),
  billing_project_id = get_billing_id(),
  page_size = 10000) {

  if(!rlang::is_character(query)) rlang::abort("`query` argument must be a string")


  bigrquery::bq_project_query(
      billing_project_id,
      query = query) %>%
    bigrquery::bq_table_download(page_size = page_size, bigint = "integer64") %>%
    readr::write_csv(path = savepath)

}





read_sql <- function(
  query,
  savepath = getwd(),
  billing_project_id,
  page_size = 500) {


  if(!rlang::is_character(query)) rlang::abort("`query` argument must contain valid SQL text")

  bigrquery::bq_project_query(
    get_billing_id(),
    query = query) %>%
    bigrquery::bq_table_download(page_size = page_size, bigint = "integer64")

}


