#' @title View Metadata table
#' @param table, a character, table id
#' @param billing_project_id a string containing your billing project id. If you've run `set_billing_id` then feel free to leave this empty.
#' @examples 
#' \dotrun{
#' view_metadata_table("br_denatran_frota.municipio_tipo")
#' }
#' @import bigrquery
#' @import rlang
#' @import glue
#' @return \code{NULL}
#' @export

view_metadata_table <- function(table, billing_project_id = get_billing_id()) {
  
  if (billing_project_id == FALSE) {
    rlang::abort("You haven't set a Project Billing Id. Use the function `set_billing_id` to do so.")
  }
  
  table_name <- glue::glue("basedosdados.{table}")
  
  if (!bigrquery::bq_table_exists(table_name)) {
    rlang::abort(glue::glue("The table {table_name} doesn´t have a valid name or was not found at basedosdados."))
  }
  
  bigrquery::bq_table_meta(table_name) %>% 
    build_dom()
}

#' @title View Metadata Dataset
#' @param dataset, a character, dataset id
#' @param billing_project_id a string containing your billing project id. If you've run `set_billing_id` then feel free to leave this empty.
#' @examples 
#' \dotrun{
#' view_metadata_dataset("br_denatran_frota")
#' }
#' @import rlang
#' @import bigrquery
#' @import glue
#' @return \code{NULL}
#' @export
view_metadata_dataset <- function(dataset, billing_project_id = get_billing_id()) {
  
  if (billing_project_id == FALSE) {
    rlang::abort("You haven't set a Project Billing Id. Use the function `set_billing_id` to do so.")
  }
  
  dataset_name <- glue::glue("basedosdados.{dataset}")
  
  if (!bigrquery::bq_dataset_exists(dataset_name)) {
    rlang::abort(glue::glue("The dataset {dataset_name} doesn´t have a valid name or was not found at basedosdados."))
  }
  
  bigrquery::bq_dataset_meta(dataset_name) %>% 
    build_dom()
}

#' @title Build HTML DOM
#' @import stringr
#' @import purrr
#' @import rlang
#' @import rstudioapi
#' @import htmltools
#' @return \code{NULL}
build_dom <- function(metadata) {
  
  description <- metadata$description %>%
    stringr::str_split("\\n") %>% 
    purrr::flatten()
  
  dataset_id <- ifelse(
    !rlang::is_null(metadata$tableReference$datasetId),
    metadata$tableReference$datasetId,
    metadata$datasetReference$datasetId
  )
  
  htmltools::tags$html(
    htmltools::h1(description[[1]]),
    htmltools::h4("Dataset: ", dataset_id),
    if (!rlang::is_null(metadata$tableReference$tableId)) {
      htmltools::h4("Table: ", metadata$tableReference$tableId)
    },
    if (!rlang::is_null(metadata$schema$fields)) {
      htmltools::div(
        htmltools::span("Columns:"),
        metadata$schema$fields %>% 
          purrr::map(~
           htmltools::div(
             htmltools::br(),
             htmltools::code(.x$name),
             htmltools::br(),
             htmltools::span(paste0("description: ", .x$description)),
             htmltools::br(),
             htmltools::span(paste0("type: "), htmltools::code(.x$type)),
           )
          )
      )
    },
    description[2:length(description)] %>%
      purrr::map(function(i)
        if (nchar(i) == 0) {
          htmltools::br()
        } else {
          htmltools::p(i)
        }
      )
  ) -> dom
  
  temp_file <- fs::file_temp(ext = ".html")
  htmltools::save_html(dom, file = temp_file)
  
  if (rstudioapi::isAvailable()) {
    rstudioapi::viewer(temp_file)
    return(invisible(NULL))
  }
  
  browser <- getOption("browser")
  
  if (!rlang::is_atomic(browser) || browser == "") {
    rlang::abort("Set the browser path `options(browser = '/path/to/browser')`")
  }
  
  utils::browseURL(temp_file, browser = browser)
  return(invisible(NULL))
  
}