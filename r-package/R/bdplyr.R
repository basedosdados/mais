#' Compatibility with {dplyr} verbs without using SQL language
#'
#' @description
#'
#' Allow you to explore and perform operation with Base dos Dados' datasets
#' without using SQL language. The [bdplyr()] function creates `lazy` variables
#' that will be connected directly to the desired table from Base dos Dados at
#' Google BigQuery and can be handled with the [dplyr::dplyr-package]´s verbs
#' as traditionally done as local bases. See also: [bigrquery::src_bigquery].
#'
#' Therefore, it is possible (without using `SQL`) to perform, for example,
#' column selection with [dplyr::select()], filter rows with [dplyr::filter()],
#' operations with [dplyr::mutate()], joins with [dplyr::left_join()] and
#' other vebs from `{dplyr}` package.
#'
#' The data will be automacically be downloaded from Google BigQuery in the
#' background as it if necessary, but will not be loaded into your virtual
#' memory nor recorded on disk unless expressly requuested.
#'
#' For this, the functions such as [bd_collect()] ou [bd_write()] should be
#' used. To load the data handled locally in your virtual memory, use
#' [bd_collect()]. To save the result in disk use the broader function
#' [bd_write()] or its derivates [bd_write_csv()] or [bd_write_rds()] to save,
#' respectively in `.csv` or `.rds` format.
#'
#'
#' @param table String in the format "basedosdados.(dataset_name)*.*(specific_table_name)".
#' It´s advisable to chack the Base dos Dados datalake for the correct names.
#'
#' @param billing_project_id a string containing your billing project id.
#' If you've run [set_billing_id()] then feel free to leave this empty.
#'
#' @return A `lazy tibble`, which can be handled (almost) as if were a local
#' database. Affter satisfactorily handled, the result must be loaded into
#' memory using [bd_collect()] or written to disk using [bd_write()] or its
#' derivates.
#'
#' @seealso bd_collect
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # set project billing id
#' basedosdados::set_billing_id("avalidprojectbillingid")
#'
#' # connects to the remote table I want
#' base_sim <- bdplyr("br_ms_sim.municipio_causa_idade")
#'
#' # connects to another remote table
#' municipios <- bdplyr("br_bd_diretorios_brasil.municipio")
#'
#' # explore data
#' base_sim %>%
#'   dplyr::glimpse()
#'
#' # use normal `{dplyr}` operations
#' municipios %>%
#'   dplyr::select(dplyr::everything()) %>%
#'   head()
#'
#' # filter
#' base_sim_acre <- base_sim %>%
#'  dplyr::mutate(ano = as.numeric(ano)) %>%
#'   dplyr::filter(sigla_uf == "AC", ano >= 2018)
#'
#' municipios_acre <- municipios %>%
#'   dplyr::filter(sigla_uf == "AC") %>%
#'   dplyr::select(id_municipio, municipio, regiao)
#'
#'
#' # join
#' base_junta <- base_sim_acre %>%
#'   dplyr::left_join(municipios_acre,
#'                    by = "id_municipio")
#'
#' # tests whether the result is satisfactory
#' base_junta
#'
#' # collect the result
#' base_final <- base_junta %>%
#'   basedosdados::bd_collect()
#'
#' # alternatively, write in disk the result
#'
#' base_final %>%
#'   basedosdados::bd_write_rds(path = "data-raw/data.rds")
#'
#'}

#TODO: usar bigrquery::bq_has_token() para checar se atenticou no Google
#TODO: tentar autenticar em silêncio com bigrquery::bq_auth(email = <email>)
# conferir: https://github.com/r-dbi/bigrquery/blob/main/R/bq-auth.R
#TODO: usar uma vignette pra explicar a compatibilidade

# bdplyr ------------------------------------------------------------------

bdplyr <- function(
  table,
  billing_project_id = basedosdados::get_billing_id()) {

  # checa se o billing id foi informado

  if(billing_project_id == FALSE) {

    rlang::abort("You haven't set a Project Billing Id. Use the function `set_billing_id` to do so.")

  }

  # criar o nome que o BQ vai entender
  # aceitar tambem o formato ja com "basedosdados.[....]" pq e assim
  # que tá no site
  #TODO: avaliar se colocamos o parametro project livre
  if (stringr::str_detect(table, pattern = "^basedosdados\\.") == TRUE) {

    tabela_full_name <- table

  } else {

    tabela_full_name <- glue::glue("basedosdados.{table}")
  }


  # checa se a tabela é reconhecida pelo google

  if(bigrquery::bq_table_exists(tabela_full_name) == FALSE) {

    rlang::abort(glue::glue("The table {tabela_full_name} doesn´t have a valid name or was not found at basedosdados."))

  }

  # cria a conexão

    con <- DBI::dbConnect(
    drv = bigrquery::bigquery(),
    project = "basedosdados",
    billing = billing_project_id)

  # chama o dplyr e guarda em um objeto
  tibble_connection <- dplyr::tbl(con, tabela_full_name)


  # testa se funcionou
  if (is_tbl_lazy(tibble_connection) == TRUE) {
    message(glue::glue("The table {tabela_full_name} was successfully connected."))
    return (tibble_connection)

  } else {
    message(glue::glue("Error when trying to connect the table {tabela_full_name}"))
  }
}


# bdcollect ---------------------------------------------------------------

#' Collects the results of a remote base called via `bdplyr()`
#'
#' @description
#'
#' After [bdplyr()] is used to create the remote connection, this function
#' allows you to collect the result of the manipulations carried out with
#' the {dplyr}´s verbs and thus use it in local memory completely.
#'
#' Alternatively, you can also save to disk directly using [bd_write()]
#' function or its derivates: [bd_write_csv()] or [bd_write_rds()].
#'
#' @param .lazy_tbl A variable that contains a database that was previously
#' connected through the [bdplyr()] function. Tipically, it will be called
#' after performing the desired operations with the `{dplyr}` verbs.
#'
#' @param billing_project_id a string containing your billing project id.
#' If you've run [set_billing_id()] then feel free to leave this empty.
#'
#' @return A tibble.
#' @export
#'
#' @examples
#' \dontrun{
#'
#' # setup billing
#'  basedosdados::set_billing_id("billing-project-id")
#'
#'  # select a cool database at Base dos Dados
#' bd_table <- basedosdados::bdplyr(
#'   "basedosdados.br_sp_gov_ssp.ocorrencias_registradas")
#'
#' # quick look
#' bd_table %>%
#'   dplyr::glimpse()
#'
#'  # filter, select and group the remote data
#' bd_ssp <-  bd_table %>%
#'   dplyr::filter(ano >= 2019) %>%
#'   dplyr::select(ano, mes, homicidio_doloso) %>%
#'   dplyr::group_by(ano, mes)
#'
#'  # make some plots
#' library(ggplot2)
#'
#' bbd_ssp %>%
#'  # collect the data to continue the analisis
#'  basedosdados::bd_collect() %>%
#'   dplyr::summarise(homicidios_sum = sum(homicidio_doloso,
#'                                          na.rm = TRUE)) %>%
#'   ggplot(aes(x = mes, y = homicidios_sum, fill = ano)) +
#'   geom_col(position = "dodge")
#'
#'
#' }
bd_collect <- function(.lazy_tbl,
                       billing_project_id = basedosdados::get_billing_id()) {

  # checar se o billing foi informado

  if(billing_project_id == FALSE) {

    rlang::abort("You haven't set a Project Billing Id. Use the function `set_billing_id` to do so.")

  }

  # checar se o argumento .lazy_tbl é coletável

  if(is_tbl_lazy(.lazy_tbl) == FALSE) {

    rlang::abort("The table could not be collected.")
  }

  # coletar
  collected_table <- dplyr::collect(.lazy_tbl)

  # checar se teve êxito
  if (inherits(collected_table, "tbl_df") == FALSE) {

    rlang::warn("It seems to have been a failure to collect the tibble.")

  }

  # retornar os resultados
  message(glue::glue("Base successfully collected on a {nrow(collected_table)}-row, {ncol(collected_table)}-column tibble."))
  return(collected_table)

}


# bd_write ----------------------------------------------------------------

#' Writes the result of operations with [bdplyr()] to disk
#'
#' @description
#'
#' Writes a remote table to disk that was called via {bdplyr}.
#' It will collect the data and write to disk in the chosen format. Y
#' ou will only need this function if you have not yet collected the data
#' using the [bd_collect()].
#'
#' The comprehensive function [bd_write()] takes as a parameter `.write_fn`,
#' which will be the name of some function (without parentheses) capable of
#' writing a tibble to disk.
#'
#' As helpers, the [bd_write_rds()] and [bd_write_csv()] functions make it
#'  easier to write in these formats, more common in everyday life.
#'
#' @param .lazy_tbl A variable that contains a database that was previously
#' connected through the [bdplyr()] function. Tipically, it will be called
#' after performing the desired operations with the `{dplyr}` verbs.
#'
#' @param .write_fn A function capable of writing the result of a tibble to
#' disk. Do not use () afther the function's name. For example: [writexl::write_xlsx],
#' [arrow::write_feather], [readr::write_tsv], etc.
#'
#'#' @param path String containing the path for the file to be created.
#'The desired folders must already exist and the file should normallt end with
#'the corresponding extension.
#'
#' @param overwrite For derivates function only. FALSE by default.
#' Indicates whether the local file should be
#' overwritten if it already exists. Use with care.
#'
#' @param compress For [bd_write_rds()] only. A logical specifying whether
#' saving to a named file is to use "gzip" compression, or one of "gzip",
#' "bzip2" or "xz" to indicate the type of compression to be used. See also:
#' [saveRDS()].
#'
#' @param ... Other parameters passed to the `.write_fn` function.
#'
#' @return String containing the path to the created file.
#' @export
#'
#' @name bd_write
#' @examples
#' \dontrun{
#'
#'  cool_db <- basedosdados::
#'
#' # setup billing
#'basedosdados::set_billing_id("MY-BILLING-ID")
#'
#'# connect with a Base dos Dados db
#'
#'cool_db_ssp <- basedosdados::bdplyr(
#'  "basedosdados.br_sp_gov_ssp.ocorrencias_registradas")
#'
#'# subset the data
#'my_subset <- cool_db_ssp %>%
#'  dplyr::filter(ano == 2021, mes == 04)
#'
#'# write it in csv - generic function
#'
#'basedosdados::bd_write(.lazy_tbl = my_subset,
#'                       .write_fn = write.csv,
#'                       "data-raw/ssp_subset.csv"
#')
#'
#'# write in .xlsx
#'basedosdados::bd_write(.lazy_tbl = my_subset,
#'                       .write_fn = writexl::write_xlsx,
#'                       "data-raw/ssp_subset.xlsx"
#')
#'
#'# using the derivates functions
#'# to csv
#'basedosdados::bd_write_csv(.lazy_tbl = my_subset,
#'                           "data-raw/ssp_subset2.csv"
#')
#'
#'# to rds
#'basedosdados::bd_write_rds(.lazy_tbl = my_subset,
#'                           "data-raw/ssp_subset.rds"
#')
#'
#'# to rds - with compression
#'::bd_write_rds(.lazy_tbl = my_subset,
#'                           "data-raw/ssp_subset2.rds",
#'                           compress = TRUE, overwrite = TRUE
#')
#'
#'
#' }

bd_write <- function(.lazy_tbl, .write_fn = ? typed::Function(),
                     path,
                     ...) {


  # tipagem com o typed se possível: https://github.com/moodymudskipper/typed

  # checa se é coletável
  if (is_tbl_lazy(.lazy_tbl) == FALSE) {

    # se não for coletável mas for tbl, indicar que a função é desnecessária
    if (tibble::is_tibble(.lazy_tbl)) {
      rlang::abort(
        "The table does not seem to need to be collected. Save using traditional writing functions like `write.csv´."
      )

      # se não for tibble, é erro mesmo
    } else {
      rlang::abort("It was not possible to collect the remote table.")
    }
  }

  # coletar
  # collected_table <- dplyr::collect(.lazy_tbl)
  collected_table <- bd_collect(.lazy_tbl)
# Duvida: eu poderia simplesmente chamar a bd_collect aqui?

   # escrever os resultados
  # esboço de como a escrita poderia ser parametrizada
  # dúvidas com evaluation provavelmente serão sanadas aqui: https://adv-r.hadley.nz/evaluation.html#evaluation

  rlang::call2(.write_fn, collected_table, path, ...) %>%
    rlang::eval_bare()

  # verificar se a gravação ocorreu corretamente e avisar

  if (file.exists(path)) {
    message(glue::glue(
      "The file was successfully saved ({file.info(path)$size} B)"
    ))
    return(path)
  } else {
    rlang::abort("Failed to save the file.")
  }

}


# bd_write_rds e bd_write_csv ---------------------------------------------

#' @rdname bd_write
#' @export
bd_write_rds <- function(.lazy_tbl,
                         path,
                         overwrite = FALSE,
                         compress = FALSE,
                         ...) {

  # checar se file é válido
  if (stringr::str_detect(path, pattern = "(\\.rds)$") == FALSE) {
    rlang::abort("Pass a valid file name to argument `path`, include the '.rds' suffix.")
  }

  # checar se arquivo já existe e se overwrite = TRUE
  if (file.exists(path) & overwrite == FALSE) {
    rlang::abort("The file already exists. Use overwrite = TRUE if you want to overwrite it.")
  }

  # chamar bd_write com saveRDS
  # estou copiando os parâmetros que readr::write_rds usa
  # a ideia é não precisar de outra dependência... se isso não for um problema
  # bora usar readr::write_rds mesmo
  bd_write(
    .lazy_tbl = .lazy_tbl,
    .write_fn = saveRDS,
    path = path,
    version = 2,
    compress = compress,
    ...
  )

  # # verificar se a gravação ocorreu corretamente e avisar
  #
  # if (file.exists(path)) {
  #   message(glue::glue(
  #     "The file was successfully saved ({file.info(path)$size} B)"
  #   ))
  #   return(path)
  # } else {
  #   rlang::abort("Failed to save the file.")
  # }

}

#' @rdname bd_write
#' @export
bd_write_csv <- function(.lazy_tbl, path, overwrite = FALSE, ...) {

  # checar se file é válido
  if (stringr::str_detect(path, pattern = "(\\.csv)$") == FALSE) {
    rlang::abort("Pass a valid file name to argument `path`, include the '.csv' suffix.")
  }

  # checar se arquivo já existe e se overwrite = TRUE
  if (file.exists(path) & overwrite == FALSE) {
    rlang::abort("The file already exists. Use overwrite = TRUE if you want to overwrite it.")
  }

  # chamar bd_write com write.csv
  bd_write(
    .lazy_tbl = .lazy_tbl,
    .write_fn = write.csv,
    path = path,
    ...
  )

  # verificar se a gravação ocorreu corretamente e avisar
  # if (file.exists(path)) {
  #   message(glue::glue(
  #     "The file was successfully saved ({file.info(path)$size} B)"
  #   ))
  #   return(path)
  # } else {
  #   rlang::abort("Failed to save the file.")
  # }


}

# is_tbl_lazy -------------------------------------------------------------
# internal function to check if is a valid connection to use

is_tbl_lazy <- function(tibble_connection) {
  rlang::inherits_any(
    x = tibble_connection,
    class =  c("tbl_BigQueryConnection",
               "tbl_dbi",
               "tbl_sql",
               "tbl_lazy")
  )

}
