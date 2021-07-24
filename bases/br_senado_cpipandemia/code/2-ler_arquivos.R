## Rodrigo Dornelles - Fri Jul 02 17:18:57 2021
##
## Objetivo: Ler os arquivos baixados da CPI


# Pacotes -----------------------------------------------------------

library(magrittr)
library(tibble)


# lista de arquivos -------------------------------------------------------

lista_html <- fs::dir_info("input/html/", regex = "\\.html$") %>%
  dplyr::pull(path)


# função dados da sessões -------------------------------------------------

ler_infos_sessao <- function(arquivo) {

  # ler o html do arquivo, com encoding correto
  html <- xml2::read_html(arquivo, encoding = "UTF-8")

  # ler as informações do cabeçalho da página
  infos_data_sessao <- html %>%
    xml2::xml_find_all(
      "//div[@class = 'escriba-jq']/*/div[@style = 'width:85%; float:left;']"
    ) %>%
    xml2::xml_text() %>%
    stringr::str_trim()

  # data da sessão
  data <- infos_data_sessao %>%
    stringr::str_extract("\\d{2,2}/\\d{2,2}/\\d{4,4}")


  # número da sessão
  sessao <- infos_data_sessao %>%
    stringr::str_extract("(?<= - )\\d{1,3}") %>%
    stringr::str_pad(width = 2, side = "left", pad = 0)

  # pegar os dados do rodapé

  # horário da abertura
  abertura <- xml2::read_html(arquivo, encoding = "UTF-8") %>%
    xml2::xml_find_all("//div[@class = 'anotacaoAberturaStyle']/span") %>%
    xml2::xml_text() %>%
    data.frame() %>%
    dplyr::filter(stringr::str_detect(., pattern = "^\\(Iniciada")) %>%
    as.character() %>%
    stringr::str_extract("(?<=Iniciada..s) .*") %>%
    stringr::str_extract_all("\\d+.*,") %>%
    stringr::str_extract_all("\\d+", simplify = T) %>%
    stringr::str_c(collapse = ":")

  # colocar em formato date
  abertura_completa <- paste(data, abertura) %>%
    lubridate::dmy_hm()

  # dados do encerramento
  encerramento <- xml2::read_html(arquivo, encoding = "UTF-8") %>%
    xml2::xml_find_all("//div[@class = 'anotacaoAberturaStyle']/span") %>%
    xml2::xml_text() %>%
    stringr::str_c(collapse = "") %>%
    stringr::str_extract("(?<=encerrada..s) .*") %>%
    stringr::str_extract_all("\\d+", simplify = T) %>%
    stringr::str_c(collapse = ":")

  # colocar no formato date
  encerramento_completo <- paste(data, encerramento) %>%
    lubridate::dmy_hm()

  # gerar saída
  tibble::tibble_row(
    numero_sessao = sessao,
    data_sessao = lubridate::dmy(data),
    horario_abertura_sessao = abertura_completa,
    horario_encerramento_sessao = encerramento_completo
  )

}


# função limpar a sessão --------------------------------------------------

limpar_discursos_sessao <- function(arquivo) {

  # ler o html do arquivo, com encoding correto
  html <- xml2::read_html(arquivo, encoding = "UTF-8")

  # ler as informações do cabeçalho da página
  infos_data_sessao <- html %>%
    xml2::xml_find_all(
      "//div[@class = 'escriba-jq']/*/div[@style = 'width:85%; float:left;']"
    ) %>%
    xml2::xml_text() %>%
    stringr::str_trim()

  # data da sessão
  data <- infos_data_sessao %>%
    stringr::str_extract("\\d{2,2}/\\d{2,2}/\\d{4,4}")


  # número da sessão
  sessao <- infos_data_sessao %>%
    stringr::str_extract("(?<= - )\\d{1,3}") %>%
    stringr::str_pad(width = 2, side = "left", pad = 0)

  # puxar a tabela que está na página
  discursos <- html %>%
    xml2::xml_find_all("//table[@id = 'tabelaQuartos']") %>%
    rvest::html_table() %>%
    purrr::pluck(1) %>%
    janitor::clean_names() %>%
    dplyr::rename(texto = texto_com_revisao)

  regex_falante <- "^[[:upper:]]{2,}.*?–"

  discursos_limpo <- discursos %>%
    # separar as linhas
    tidyr::separate_rows(texto, sep = "(O|A) (SR|SRA)\\.") %>%
    dplyr::mutate(
      # cortar espaços vazios
      texto = stringr::str_trim(texto),
      # regex para identificar quem tá falando
      falante = stringr::str_extract(texto, pattern = regex_falante),
      # remover do texto quem tá falando
      texto = stringr::str_remove(texto, regex_falante)
    ) %>%
    # preencher os NAs com a pessoa que falava imediatamente antes
    tidyr::fill(falante)

  discursos_limpo <- discursos_limpo %>%
    dplyr::filter(texto != "") %>%
    dplyr::mutate(
      data_sessao = data,
      numero_sessao = sessao,
      # registra se há tag de revisão e a retira da coluna de horário
      revisado = dplyr::if_else(stringr::str_detect(horario, "  R$"),
                                TRUE, FALSE,NA),
      horario = stringr::str_extract(horario, "\\d{2,2}\\:\\d{2,2}")
    )

  # arrumar data e horário
  discursos_limpo <- discursos_limpo %>%
    dplyr::mutate(
      horario_inicio = lubridate::dmy_hm(paste(data, horario)),
      horario_fim = dplyr::lead(horario),
      horario_fim = lubridate::dmy_hm(paste(data, horario_fim)),
      horario_duracao =  horario_fim - horario_inicio,
      data_sessao = lubridate::dmy(data)
    ) %>%
    dplyr::select(numero_sessao, falante, texto, data_sessao, horario_inicio,
                  horario_fim, horario_duracao)


}


# iterar e gerar base -----------------------------------------------------

base <- purrr::map_dfr(
  lista_html,
  limpar_discursos_sessao
) %>%
  dplyr::arrange(numero_sessao)


# exportar ----------------------------------------------------------------

usethis::use_directory("tmp/rds")

readr::write_rds(base, "tmp/rds/base_suja.rds", compress = "gz")


