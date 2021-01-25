#' Here are functions cloning the original python client's functionality


get_billing_id <- function() {

  if(Sys.getenv(billing_project_set) == FALSE) {

    return(NULL)

  } else {

    return(Sys.getenv(billing_project_id))

  }

}

set_billing_id <- function(billing_project_id) {

  if(!rlang::is_character(billing_project_id)) {

    rlang::abort("`billing_project_id` must be a 1-length character vector.")

  }

  if(length(billing_project_id) > 1) {

    rlang::abort("`billing_project_id` must have length 1.")

  }

  if(!rlang::is_vector(billing_project_id)) {

    rlang::abort("Invalid data for `billing_project_id`")

  }

  Sys.setenv(billing_project_id = billing_project_id,
             billing_project_set = TRUE)

}


#' Download a table locally
#'
#' @param query a string contaning valid a SQL query.
#' @param savepath a path describing where the table should be saved. Defaults to the current working directory.
#' @param billin_project_id a string containing your billing project id. If you've run `set_billing_id` then feel free to leave this empty.


download <- function(
  query,
  savepath = getwd(),
  billing_project_id,
  page_size = 500) {

  if(!rlang::is_character(query)) rlang::abort("`query` argument must contain valid SQL text")


  bigrquery::bq_project_query(
      get_billing_id(),
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


