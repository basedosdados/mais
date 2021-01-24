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




download <- function(
  query,
  savepath = getwd(),
  billing_project_id) {









}
