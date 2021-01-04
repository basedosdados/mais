


query_table <- function(
  ...,
  table1 = NULL,
  table2 = NULL,
  join = NULL,
  keys = NULL,
  page_size = 500) {

  if(rlang::is_null(table1)) {

    rlang::abort(
      glue::glue('Provide a valid `table1` argument.')
    )

  }


  if(!rlang::is_null(table2) & rlang::is_null(join)) {

    rlang::abort('Provide a join specification to argument `join`. \n
                 Possible values include: `left`,`inner`,`full`,`right`.')

  }


  columns <- rlang::ensyms(...) %>%
    purrr::map(rlang::as_string) %>%
    reduce(paste, sep = ", ")


  single_table_query <- glue::glue(
    "
    SELECT
    {columns}
    FROM
    {table1}
  ")


  if(!rlang::is_null(table2)) {


    second_table_query <- glue::glue(
      "
      {toupper(join)} ON
      {purrr::pluck(keys, 1)} = {purrr::pluck(keys, 2)}
      ")

  } else {

    second_table_query <- ""

  }


  query <- paste0(single_table_query, second_table_query)

  bigrquery::bq_table_download(
    x = bigrquery::bq_project_query("basedosdados", query),
    page_size = page_size)

}

query_table(
  pib.id_municipio,
  pib.PIB,
  table1 = "basedosdados.br_ibge_pib.municipios as pib")


