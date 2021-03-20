

#' Internal functions for project billing management
#'
#' @description
#'
#' Retrieves the project's billing Id.
#'
#' @import rlang
#' @export
#'
#'

get_billing_id <- function() {

  id <- Sys.getenv("billing_project_id")

  if(Sys.getenv("billing_project_set") == FALSE) {

    rlang::inform(
      "No Billing Project Id set. You can set it as an enviroment variable under ´billing_project_id´ and restart the session or run basedosdados::set_billing_id.")
    return(FALSE)

  } else if(Sys.getenv("billing_project_set") == "env") {

    rlang::inform("Fecthing Billing Project Id from enviroment variables.")
    return(id)

  } else if(Sys.getenv("billing_project_set") == TRUE) {

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

set_billing_id <- function(billing_project_id) {

  if(!rlang::is_character(billing_project_id)) {

    rlang::abort("`billing_project_id` must be a 1-length character vector.")

  } else if(length(billing_project_id) > 1) {

    rlang::abort("`billing_project_id` must have length 1.")

  } else if(!rlang::is_vector(billing_project_id)) {

    rlang::abort("Invalid data for `billing_project_id`.")

  }

  Sys.setenv(billing_project_id = billing_project_id,
             billing_project_set = TRUE)

  rlang::inform('Project keys set successfully')

}

