

#' Internal functions for project billing management
#'
#' @description
#'
#' Retrieves the project's billing Id.
#'
#' @return a string with the project's billing id.
#'
#' @importFrom rlang inform
#' @export
#'
#'

get_billing_id <- function() {

  id <- Sys.getenv("billing_project_id")

  is_set <- Sys.getenv("billing_project_set")

  if(is_set == FALSE) {

    rlang::inform("No Billing Project Id set. You can set it as an enviroment variable under billing_project_id and restart the session or run basedosdados::set_billing_id.")

    return(FALSE)

  } else if (is_set == "user_has_set") {

    rlang::inform("Fecthing Billing Project Id from enviroment variables defined by user.")

    return(id)

  } else if(is_set) {

    return(id)

  }

}

#' Define your Project Id
#'
#' @description
#'
#' Define your project billing ids here so all your queries are authenticated and return data, not errors.
#' If using in production or leaving code available at public repositories, `dotenv` is highly recommended.
#'
#' @importFrom rlang abort is_string inform
#' @importFrom dotenv load_dot_env
#'
#' @export
#'
#' @return No return.
#'
#' @param billing_project_id a single character value containing the string. Vectors with longer lengths and non-vectors will trigger an error.
#'
#'
#' @examples
#'
#' \dontrun{
#' set_billing_id("my_billing_project_id")
#'
#' # or load from an .env file
#'
#' library(dotenv)
#'
#' load_dot_env("keys.env")
#' print(Sys.getenv("billing_project_id"))
#'
#' set_billing_id(Sys.getenv("billing_project_id"))
#'
#' }
#'

set_billing_id <- function(billing_project_id = NULL) {

  if(rlang::is_null(billing_project_id)) {

    billing_project_id <- readline("Please insert your billing project id: ")

  }  else if (!rlang::is_string(billing_project_id)) {

    rlang::abort("`billing_project_id` must be a string.")

  } else if(length(billing_project_id) > 1) {

    rlang::abort("`billing_project_id` must have length 1.")

  }

  Sys.setenv(billing_project_id = billing_project_id,
             billing_project_set = TRUE)

  rlang::inform('Project keys set successfully')

}


