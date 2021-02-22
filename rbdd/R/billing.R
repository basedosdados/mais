

#' Internal functions for project billing management
#'
#' @description
#'
#' As of now it appeals to global state and _should_ work, but it's technical debt.
#' Memoisation is the way to go and shouldn't be too hard to implement.
#'
#' @import rlang
#'
#'
#'

get_billing_id <- function() {

  if(Sys.getenv("billing_project_set") == FALSE) {

    return(NULL)

  } else {

    return(Sys.getenv("billing_project_id"))

  }

}

#' Define your Project Id
#'
#' @description
#'
#' Define your project billing ids here so all your queries are authenticated and return data, not errors.
#' If using in production or leaving code available at public repositories, `dotenv` is highly recommended.
#'
#' @import rlang
#'
#' @export
#'
#' @param billing_project_id a single character value containing the string. Vectors with longer lengths and non-vectors will trigger an error.
#'
#'
#' @examples
#'
#'
#' set_billing_id("my_billing_project_id")
#' # or load from an .env file
#' library(dotenv)
#' load_dot_env("keys.env")
#' set_billing_id(Sys.getenv("name of the appropriate variable here"))
#'

set_billing_id <- function(billing_project_id) {

  if(!rlang::is_character(billing_project_id)) {

    rlang::abort("`billing_project_id` must be a 1-length character vector.")

  }

  if(length(billing_project_id) > 1) {

    rlang::abort("`billing_project_id` must have length 1.")

  }

  if(!rlang::is_vector(billing_project_id)) {

    rlang::abort("Invalid data for `billing_project_id`.")

  }

  Sys.setenv(billing_project_id = billing_project_id,
             billing_project_set = TRUE)

  rlang::inform('Project keys set successfully')

}

