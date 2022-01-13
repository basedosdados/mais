#'
#'
#' Open the data set's dictionary.
#'
#' @param dataset a string containing the name of a basedosdados' data set, the dictionary of which you are asking for.
#' @param billing_project_id a string containing your billing project id. If you've run `set_billing_id` then feel free to leave this empty.
#'
#' @return Returns a dictionary of the data set, allowing the user to check factors' meanings.
#'
#'
#'
#' @examples
#'
#' \dontrun{
#'
#'
#' dictionary("br_inep_censo_escolar")
#'
#' dictionary("br_me_rais")
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

dictionary <- function(
  dataset,
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
    query = glue::glue("SELECT *
                  FROM basedosdados.{dataset}.dicionario")) %>%
    bigrquery::bq_table_download(
      page_size = page_size,
      bigint = "integer64")

}
