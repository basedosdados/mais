#' Compatibilidade com {dplyr}
#'
#' @description
#'
#' Realiza conexão com o Google BigQuery via {DBI} e torna a base
#' compatível com as operações básicas do {dplyr} tais como glimpse(),
#' filter(), select(), mutate(), _join(), etc.
#'
#' Após realizar as operações, usar dplyr::collect() para finalizar a
#' requisição.
#'
#' Ver também: https://rdrr.io/cran/bigrquery/man/src_bigquery.html
#'
#' @param tabela Caminho no formato basedosdados.\<dataset\>.\<tabela\>
#' @param billing_project_id billing_id.
#'
#' @return Tabela em formato manipulável
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # definir billing
#' basedosdados::set_billing_id("nimble-root-312115")
#'
#' # carregar a base que quero
#' base_sim <- bdplyr("br_ms_sim.municipio_causa_idade")
#'
#' # carregar outra base
#' municipios <- bdplyr("br_bd_diretorios_brasil.municipio")
#'
#' # explorar
#' base_sim %>%
#'   dplyr::glimpse()
#'
#'
#' municipios %>%
#'   dplyr::select(dplyr::everything()) %>%
#'   head()
#'
#' # filtrar
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
#' # testar se deu certo
#' base_junta
#'
#' # coletar reusltado
#' base_final <- base_junta %>%
#'   dplyr::collect()
#'
#' base_final
#'
#'}

#TODO: colocar em inglês as docs
#TODO: usar bigrquery::bq_has_token() para checar se atenticou no Google
#TODO: tentar autenticar em silêncio com bigrquery::bq_auth(email = <email>)
# conferir: https://github.com/r-dbi/bigrquery/blob/main/R/bq-auth.R


# is_tbl_lazy -------------------------------------------------------------
# internal function to check is a valid connection to use

is_tbl_lazy <- function(tibble_connection) {
  rlang::inherits_any(
    x = tibble_connection,
    class =  c("tbl_BigQueryConnection",
               "tbl_dbi",
               "tbl_sql",
               "tbl_lazy")
  )

}


# bdplyr ------------------------------------------------------------------

bdplyr <- function(
  table,
  billing_project_id = basedosdados::get_billing_id()) {

  # checar se o billing foi informado

  if(billing_project_id == FALSE) {

    rlang::abort("You haven't set a Project Billing Id. Use the function `set_billing_id` to do so.")

  }

  # criar o nome que o BQ vai entender

  tabela_completa <- glue::glue("basedosdados.{table}")

  # checa se a tabela é reconhecida pelo google

  if(bigrquery::bq_table_exists(tabela_completa) == FALSE) {

    rlang::abort(glue::glue("A tabela {table} não foi localizada"))

  }

  # cria a conexão

    con <- DBI::dbConnect(
    drv = bigrquery::bigquery(),
    project = "basedosdados",
    billing = billing_project_id)

  # chama o dplyr e guarda em um objeto
  tibble_connection <- dplyr::tbl(con, tabela_completa)


  # testa se funcionou
  if (is_tbl_lazy(tibble_connection) == TRUE) {
    message(glue::glue("A tabela {table} foi conectada com sucesso."))
    return (tibble_connection)

  } else {
    message(glue::glue("Erro ao tentar conectar a tabela {table}"))
  }
}


# bdcollect ---------------------------------------------------------------

# criar uma funçao interna que aplica collect()

 # TODO documentar as duas juntamente na mesma página
 # nos exemplos mostrar como elas se combinam
 # o usuário pode gerar um lazy tbl, usar código típico de R para gerar uma query
 # e usar bd_collect() para coletar os resultados

#' @rdname bdplyr()
#' @export

bd_collect <- function(.lazy_tbl,
                       billing_project_id = basedosdados::get_billing_id()) {

  # checar se o billing foi informado

  if(billing_project_id == FALSE) {

    rlang::abort("You haven't set a Project Billing Id. Use the function `set_billing_id` to do so.")

  }

  # checar se o argumento .lazy_tbl é coletável

  if(is_tbl_lazy(.lazy_tbl) == FALSE) {

    rlang::abort("Não foi possível coletar")
  }

  # coletar
  collected_table <- dplyr::collect(.lazy_tbl)

  # checar se teve êxito
  if (inherits(collected_table, "tbl_df") == FALSE) {

    rlang::warn("Parece não ter retornado uma tibble.")

  }

  # retornar os resultados
  message(glue::glue("Base coletada em uma tibble {nrow(collected_table)} x {ncol(collected_table)}"))
  return(collected_table)

}


# bd_write ----------------------------------------------------------------

#' @rdname bdplyr()
#' @export

bd_write <- function(.lazy_tbl, .write_fn = ? typed::Function(), ...) {

  #' @param .write_fn é uma função de escrita
  #'
  #' tipagem com o typed se possível: https://github.com/moodymudskipper/typed

  # checa se é coletável
  if (is_tbl_lazy(.lazy_tbl) == FALSE) {

    # se não for coletável mas for tbl, indicar que a função é desnecessária
    if (tibble::is_tibble(.lazy_tbl)) {
      rlang::abort(
        "A tabela não parece precisar ser coletada. Salve utilizando as funções tradicionais de escrita."
      )

      # se não for tibble, é erro mesmo
    } else {
      rlang::abort("Não foi possível coletar .lazy_tbl")
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


bd_write_rds <- function(.lazy_tbl,
                         path,
                         compress = FALSE,
                         version = 2,
                         ...) {
  # checar se file é válido
  if (stringr::str_detect(path, pattern = "(\\.rds)$") == FALSE) {
    rlang::abort("Pass a valid file name to argument `path`, include the '.rds' suffix.")
  }

  # chamar bd_write com saveRDS
  # estou copiando os parâmetros que readr::write_rds usa
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
      "O arquivo foi salvo corretamente com {file.info(path)$size} B"
    ))
    return(path)
  } else {
    rlang::abort("Erro ao salvar o arquivo")
  }

}



bd_write_csv <- function(.lazy_tbl, file, ...) {

 # chamar bd_write com write_csv

}
