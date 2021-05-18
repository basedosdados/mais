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

bdplyr <- function(tabela,
                   billing_project_id = basedosdados::get_billing_id()) {

  # checar se o billing foi informado
  if(billing_project_id == FALSE) {
    rlang::abort("O billing_id não foi informado.")
    return(FALSE)
  }

  # criar o nome que o BQ vai entender
  # TODO: checagem se o nome é válido
  tabela_completa <- paste0("basedosdados.", tabela)

  # checa se a tabela é reconhecida pelo google
  if(!bigrquery::bq_table_exists(tabela_completa)) {
    rlang::abort(paste("A tabela", tabela, "não foi localizada"))
    return(FALSE)
  }

  # cria a conexão
  con <- DBI::dbConnect(
    drv = bigrquery::bigquery(),
    project = "basedosdados",
    billing = billing_project_id
  )

  # chama o dplyr e retorna
  dplyr::tbl(con, tabela_completa)

}
