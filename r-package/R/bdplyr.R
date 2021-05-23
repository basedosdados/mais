#' Compatibility with {dplyr} verbs sem o uso de SQL
#'
#' @description
#'
#' Permite explorar e realizar operações com as tabelas do
#' Base dos Dados sem o uso de linguagem SQL. A função `bdplyr()` cria
#' variáveis `lazy` que serão conectadas diretamente às tabelas desejadas da
#' Base dos Dados no Google Big Query e poderão ser manuseadas com os verbos
#' do [dplyr::dplyr-package] como tradicionalmente feito
#' com bases locais. Veja também: [bigrquery::src_bigquery]
#'
#' Portanto, é possível (sem usar SQL) realizar, p. ex.,
#' seleção de colunas com [dplyr::select()], filtrar linhas com
#' [dplyr::filter()], operações com  [dplyr::mutate()] e joins com
#' [dplyr::left_join()] e outros verbos do pacote `{dply}`.
#'
#' Os dados serão automaticamente baixados do Google BigQuery à medida em que
#' se fizerem necessários, mas não serão carregados na memória virtual e nem
#' gravados em disco a menos que expressamente solicitados.
#'
#' Para isso, devem ser usadas as funções [bd_collect()] para carregar na
#' memória ou, para salvar em disco, [bd_write()] ou suas derivadas
#' [bd_write_csv()] e [bd_write_rds()]
#'
#'
#' @param table String no formato "(nome_do_dataset).(nome_da_tabela)". É
#' aconselhável checar na Base dos Dados o nome correto com atenção.
#'
#' @param billing_project_id Por padrão, tentará resgatar seu project billing
#' id por meio da função [get_billing_id()].
#'
#' @return Uma `lazy tibble`, que poderá ser manuseada como se fosse uma
#' base de dados local. Após satisfatoriamente manuseada, o resultado deverá
#' ser carregado na memória através da função [bd_collect()] ou salvo em disco
#' por meio de alguma da função [bd_write()] ou suas derivadas.
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

#TODO: colocar em inglês as docs
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

  tabela_full_name <- glue::glue("basedosdados.{table}")

  # checa se a tabela é reconhecida pelo google

  if(bigrquery::bq_table_exists(tabela_full_name) == FALSE) {

    rlang::abort(glue::glue("The table {table} doesn´t have a valid name or was not found at basedosdados."))

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
    message(glue::glue("The table {table} was successfully connected."))
    return (tibble_connection)

  } else {
    message(glue::glue("Error when trying to connect the table {table}"))
  }
}


# bdcollect ---------------------------------------------------------------


 # TODO documentar as duas juntamente na mesma página
 # nos exemplos mostrar como elas se combinam
 # o usuário pode gerar um lazy tbl, usar código típico de R para gerar uma query
 # e usar bd_collect() para coletar os resultados

#' Coleta os resultados de uma base remota para uso local
#'
#' @description
#'
#' Após [bdplyr()] ser utilizada para criar a conexão remota, essa função
#' permite coletar o resultado das manipulações realizadas com os verbos do
#' pacote `{dplyr}` e assim utilizá-lo na memória por completo.
#'
#' Você também pode salvar em disco diretamente através da função
#' [bd_write()] ou de suas derivadas: [bd_write_rds()] ou [bd_write_csv()].
#'
#'
#' @param .lazy_tbl Uma variável que foi coletada anteriormente por meio da
#' função [bdplyr()]. Recomenda-se o uso após realizadas as operações desejadas
#' com os verbos do pacote `{dplyr}`.
#'
#' @param billing_project_id Por padrão, tentará resgatar seu project billing
#' id por meio da função [get_billing_id()].
#'
#' @return A tibble.
#' @export
#'
#' @examples
#' \dontrun{
#'
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

#' Salva em disco o resultado de operações com bases remotas
#'
#' @description
#'
#' bla bla bla bla bla;
#' bla blabl bla.
#'
#' @param .lazy_tbl Uma variável que foi coletada anteriormente por meio da
#' função [bdplyr()]. Recomenda-se o uso após realizadas as operações desejadas
#' com os verbos do pacote `{dplyr}`.
#
#' @param .write_fn A função de escrita desejada sem os ()
#'
#' @param path String contendo o endereço para o arquivo a ser criado. As
#' pastas desejadas já devem existir e o arquivo deve terminar com a extensão
#' correspondente.
#'
#' @param overwrite Por padrão FALSE. Indica se o arquivo local deve ser
#' sobrescrito caso já existe. Use com cuidado.
#'
#' @param compress For [bd_write_rds()] only. A logical specifying whether
#' saving to a named file is to use "gzip" compression, or one of "gzip",
#' "bzip2" or "xz" to indicate the type of compression to be used. See also:
#' [saveRDS()].
#'
#' @param ... Outros parâmetros que possam ser desejados.
#'
#' @return String com o endereço do arquivo salvo.
#' @export
#'
#' @name bd_write
#' @examples
#' \dontrun{
#'
#' # exemplo com csv e rds na normal e depois na helper
#'
#' # pensar em exemplo json
#'
#'
#' }

bd_write <- function(.lazy_tbl, .write_fn = ? typed::Function(), ...) {


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
  rlang::call2(.write_fn, collected_table, ...) %>%
    rlang::eval_bare()

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
    file = path,
    version = 2,
    compress = compress,
    ...
  )

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
    file = path,
    ...
  )

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
