
#'
#'
#'
#'



bdd_auth <- function(email) {


  gar_auth(email = email,
           scopes = "https://www.googleapis.com/auth/bigquery")

}


list_datasets <- function() {


  request <- httr::GET(
    glue::glue(
      "https://bigquery.googleapis.com/bigquery/v2/projects/basedosdados/datasets"))

  content(request)


}
