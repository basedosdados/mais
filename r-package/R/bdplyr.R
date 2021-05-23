#' Compatibilidade com {dplyr}
#'
#' @description
#' # TODO: colocar em inglês as docs
#' Realiza conexão com o Google BigQuery via {DBI} e torna a base
#' compatível com as operações básicas do {dplyr} tais como glimpse(),
#' filter(), select(), mutate(), _join(), etc.
#'
#' Após realizar as operações, usar dplyr::collect() para finalizar a
#' requisição.
#'
#' Ver também: https://rdrr.io/cran/bigrquery/man/src_bigquery.html
#'
#' @param tabela Caminho no formato basedosdados.<dataset>.<tabela>
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

bdplyr <- function(
  table,
  billing_project_id = basedosdados::get_billing_id()) {

  # checar se o billing foi informado

  if(billing_project_id == FALSE) {

    rlang::abort("O billing_id não foi informado.")

  }

  # criar o nome que o BQ vai entender
  # TODO: checagem se o nome é válido

  tabela_completa <- glue::glue("basedosdados.{table}")

  # checa se a tabela é reconhecida pelo google

  if(!bigrquery::bq_table_exists(tabela_completa)) {

    rlang::abort(glue::glue("A tabela {table} não foi localizada"))

  }

  # cria a conexão

  con <- DBI::dbConnect(
    drv = bigrquery::bigquery(),
    project = "basedosdados",
    billing = billing_project_id)

  # chama o dplyr e guarda em um objeto
  conexao_retorno <- dplyr::tbl(con, tabela_completa)

  # testa se funcionou
  if (dplyr::is.tbl(conexao_retorno) == TRUE) {
    message(paste("A tabela", tabela, "foi conectada com sucesso."))
    return (conexao_retorno)

  } else {
    message(paste0("Erro ao tentar conectar a tabela", tabela))
    return (FALSE)

  }
}

# criar uma funçao interna que aplica collect()

 # TODO documentar as duas juntamente na mesma página
 # nos exemplos mostrar como elas se combinam
 # o usuário pode gerar um lazy tbl, usar código típico de R para gerar uma query
 # e usar bd_collect() para coletar os resultados

bd_collect <- function(.lazy_tbl) {

  # TODO verificar se o argumento `.lazy_tbl` é coletável
  # retornar os resultados

}



bd_write <- function(.lazy_tbl, .write_fn = ? typed::Function(), ...) {

  #' @param .write_fn é uma função de escrita
  #'
  #' tipagem com o typed se possível: https://github.com/moodymudskipper/typed


  # TODO verificar se o argumento `.lazy_tbl` é coletável
  # escrever os resultados

  # esboço de como a escrita poderia ser parametrizada

  # dúvidas com evaluation provavelmente serão sanadas aqui: https://adv-r.hadley.nz/evaluation.html#evaluation

  data <- # resultado da coleção da query

  rlang::call2(.write_fn, data, ...) %>%
    rlang::eval_bare()

}


