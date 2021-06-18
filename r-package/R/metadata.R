#' @title Get Metadata Table
#' @param dataset_id dataset id available in `query_project_id`
#' @param table_id table id available in `dataset_id`
#' @param query_project_id which project the table lives. You can change this you want to query different projects. Default is \code{"basedosdados"}
#' @param billing_project_id your billing project id. If you've run `set_billing_id` then feel free to leave this empty.
#' @examples
#' \dontrun{
#' get_table_metadata("br_ibge_pib", "municipios")
#' }
#' @importFrom bigrquery bq_table_exists bq_table_meta
#' @importFrom rlang abort
#' @importFrom glue glue
#' @importFrom htmltools div h2 code h4 span
#' @importFrom purrr map
#' @return \code{invisible(NULL)}
#' @export

get_table_metadata <- function(dataset_id,
                               table_id,
                               query_project_id = "basedosdados",
                               billing_project_id = get_billing_id()
                               ) {
  
  if (billing_project_id == FALSE) {
    rlang::abort("You haven't set a Project Billing Id. Use the function `set_billing_id` to do so.")
  }
  
  table_name <- glue::glue("{query_project_id}.{dataset_id}.{table_id}")
  
  if (!bigrquery::bq_table_exists(table_name)) {
    rlang::abort(glue::glue("The table {table_name} doesn´t have a valid name or was not found at {query_project_id}"))
  }
  
  bigrquery::bq_table_meta(table_name) %>% 
    {htmltools::div(
      htmltools::code(.$id),
      htmltools::p(get_header(.$description)),
      htmltools::div(
        htmltools::h4("Columns:"),
        .$schema$fields %>% 
          purrr::map(
            ~htmltools::div(
              class = "item_column",
              htmltools::code(glue::glue("{.x$name} <{tolower(.x$type)}>: ")),
              htmltools::span(.x$description)
            )
          )
      ),
      get_body(.$description) %>% 
        purrr::map(~htmltools::p(.x))
    )} %>% 
    render_dom()
}

#' @title Get Metadata Dataset
#' @param dataset_id dataset id available in `query_project_id`
#' @param query_project_id which project the table lives. You can change this you want to query different projects. Default is \code{"basedosdados"}
#' @param billing_project_id your billing project id. If you've run `set_billing_id` then feel free to leave this empty.
#' @importFrom rlang abort
#' @importFrom bigrquery bq_dataset_exists bq_dataset_meta
#' @importFrom glue glue
#' @importFrom htmltools div h2 code p
#' @examples
#' \dontrun{
#' get_dataset_metadata("br_ibge_pib")
#' }
#' @return \code{invisible(NULL)}
#' @export

get_dataset_metadata <- function(dataset_id,
                                 query_project_id = "basedosdados",
                                 billing_project_id = get_billing_id()
                                 ) {
  
  if (billing_project_id == FALSE) {
    rlang::abort("You haven't set a Project Billing Id. Use the function `set_billing_id` to do so.")
  }
  
  dataset_name <- glue::glue("{query_project_id}.{dataset_id}")
  
  if (!bigrquery::bq_dataset_exists(dataset_name)) {
    rlang::abort(glue::glue("The dataset {dataset_name} doesn´t have a valid name or was not found at {query_project_id}."))
  }
  
  
  bigrquery::bq_dataset_meta(dataset_name) %>% 
    {htmltools::div(
      htmltools::code(.$id),
      htmltools::p(get_header(.$description)),
      get_body(.$description) %>% 
        purrr::map(~htmltools::p(.x))
    )} %>% 
    render_dom()
}

#' @title List Datasets
#' @param query_project_id, Which project the table lives. You can change this you want to query different projects. Default is \code{"basedosdados"}
#' @param filter_by, optional character to be matched in dataset_id. Default is \code{NULL}
#' @param with_description, optional, if \code{TRUE}, fetch short dataset description for each dataset. Defalut is \code{FALSE}
#' @param page_size, Number of items per page. Default is \code{99999}.
#' @param ..., other parameters for passing in the bigrquery
#' @importFrom bigrquery bq_project_datasets bq_dataset_meta
#' @importFrom purrr map keep
#' @importFrom stringr str_detect
#' @importFrom rlang is_null is_character
#' @importFrom glue glue
#' @importFrom htmltools div h2 h4 p
#' @examples
#' \dontrun{
#' list_datasets()
#' }
#' @return \code{invisible(NULL)}
#' @export

list_datasets <- function(query_project_id = "basedosdados",
                          filter_by = NULL,
                          with_description = FALSE,
                          page_size = 99999,
                          ...) {
  
  datasets <- bigrquery::bq_project_datasets(
    query_project_id,
    page_size = page_size,
    ...
  )
  
  if (!rlang::is_null(filter_by) && rlang::is_character(filter_by)) {
    datasets %>% purrr::keep(~stringr::str_detect(.x$dataset, pattern = filter_by)) -> datasets
  }
  
  if (with_description) {
    datasets %>% 
      purrr::map(
        ~bigrquery::bq_dataset_meta(
          glue::glue("{.x$project}.{.x$dataset}"),
          fields = "description, datasetReference(datasetId)"
        ) %>% 
          {list(
            dataset = .$datasetReference$datasetId,
            description = get_header(.$description)
          )}
      ) -> datasets
  }

  htmltools::div(
    htmltools::h2("Datasets:"),
    datasets %>%
      purrr::map(
        ~htmltools::div(
          htmltools::h4(.x$dataset),
          htmltools::p(.x$description)
        )
      )
  ) %>%
    render_dom()
}


#' @title List Dataset Tables
#' @param dataset_id dataset id available in `query_project_id`
#' @param query_project_id, which project the table lives. You can change this you want to query different projects. Default is \code{"basedosdados"}
#' @param filter_by, optional character to be matched in dataset_id. Default is \code{NULL}
#' @param with_description, optional, if \code{TRUE}, fetch short dataset description for each dataset. Defalut is \code{FALSE}
#' @param page_size, Number of items per page. Default is \code{99999}.
#' @param ..., other parameters for passing in the bigrquery
#' @importFrom bigrquery bq_dataset_tables bq_table_meta
#' @importFrom glue glue
#' @importFrom purrr keep map
#' @importFrom rlang abort
#' @importFrom htmltools div h2 h4 p
#' @examples
#' \dontrun{
#' list_dataset_tables("br_ibge_pib")
#' }
#' @return \code{invisible(NULL)}
#' @export

list_dataset_tables <- function(dataset_id,
                                query_project_id = "basedosdados",
                                filter_by = NULL,
                                with_description = FALSE,
                                page_size = 99999,
                                ...) {

  tables <- bigrquery::bq_dataset_tables(
    glue::glue("{query_project_id}.{dataset_id}"),
    page_size = page_size,
    ...
   )
  
  if (!rlang::is_null(filter_by) && rlang::is_character(filter_by)) {
    tables %>% purrr::keep(~stringr::str_detect(.x$table, pattern = filter_by)) -> tables
  }
  
  if (with_description) {
    tables %>% 
      purrr::map(
        ~bigrquery::bq_table_meta(
          glue::glue("{.x$project}.{.x$dataset}.{.x$table}"),
          fields = "description, tableReference(tableId)"
        ) %>% 
          {list(
            table = .$tableReference$tableId,
            description = get_header(.$description)
          )}
      ) -> tables
  }
  
  htmltools::div(
    htmltools::h2("Tables:"),
    tables %>%
      purrr::map(
        ~htmltools::div(
          htmltools::h4(.x$table),
          htmltools::p(.x$description)
        )
      )
  ) %>%
    render_dom()
}


#' @title Build HTML DOM
#' @description Create an html document, save it in the session folder `tempdir()`
#' and open in the viewer
#' @param body html tree
#' @importFrom rstudioapi isAvailable getThemeInfo viewer
#' @importFrom rlang is_atomic abort
#' @importFrom htmltools tags save_html
#' @importFrom fs file_temp
#' @return \code{invisible(NULL)}

render_dom <- function(body) {
  
  # Check if rstudio is runnning
  rstudio_api_available <- rstudioapi::isAvailable()
  
  # Get rstudio theme colors to customize html
  theme_info <- if (rstudio_api_available) {
    get_theme_info <- rstudioapi::getThemeInfo()
    c("background" = get_theme_info$background, "foreground" = get_theme_info$foreground)
  } else {
    c("background" = "#fff", "foreground" = "#000")
  }
  
  # Create inline stylesheet (css)
  css <- sprintf("
      :root {
        --bg-color: %s;
        --text-color: %s;
      }
      body {
        font-family: sans-serif; 
        background: var(--bg-color);
        color: var(--text-color);
      }
      h2 {
        margin-bottom: 0px;
      }
      p {
        word-break: break-all;
      }
      a {
        color: var(--text-color);
        text-decoration: none;
      }
      header {
        text-align: center;
        margin-bottom: 10px;
      }
      h2 + code {
        display: inline-block;
        margin-bottom: 1em;
      }
      .item_column {
        margin: 10px 0;
      }
    ",
    theme_info["background"], theme_info["foreground"]
  )
  
  # Create html document, append elements
  # <html>
  #   <head>
  #     <meta>
  #     <title>Base dos Dados</title>
  #   </head>
  # <body>
  #   <header><h1></h1></header>
  #   body `param`
  # </body>
  # <html>
  htmltools::tags$html(
    htmltools::tags$head(
      htmltools::tags$meta(name = "viewport", content = "width=device-width,initial-scale=1"),
      htmltools::tags$title("Base dos Dados"),
      htmltools::tags$style(css)
    ),
    htmltools::tags$body(
      htmltools::tags$header(
        htmltools::h1("Base dos Dados: Universalizando o acesso a dados no Brasil"),
        htmltools::a(
          href = "https://basedosdados.org/",
          target = "_blank",
          "basedosdados.org"
        )
      ),
      body 
    )
  ) -> dom
  
  temp_file <- fs::file_temp(ext = ".html")
  htmltools::save_html(dom, file = temp_file)
  
  if (rstudio_api_available) {
    # open viewer on rstudio
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

#' @title Get first line of description
#' @param description, a character
#' @importFrom stringr str_split
#' @importFrom purrr pluck
#' @return \code{character}
get_header <- function(description) {
  description %>% stringr::str_split("\\n") %>% purrr::pluck(1, 1)
}

#' @title Get body of description
#' @param description, a character
#' @importFrom stringr str_split
#' @return list of character
get_body <- function(description) {
  description %>% stringr::str_split("\\n") %>% unlist() %>% .[2:length(.)]
}