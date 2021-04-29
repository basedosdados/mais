library(rvest)
library(httr)
library(archive) # <https://github.com/jimhester/archive>
library(magrittr)
library(stringr)
library(tibble)
library(dplyr)
library(purrr)

download_frota <- function(key = NULL, prefix = NULL, month, year, tempdir = tempdir(), dir = getwd()) {
  
  months <- c(
    "janeiro" = 1,
    "fevereiro" = 2,
    "marco" = 3,
    "abril" = 4,
    "maio" = 5,
    "junho" = 6,
    "julho" = 7,
    "agosto" = 8,
    "setembro" = 9,
    "outubro" = 10,
    "novembro" = 11,
    "dezembro" = 12
  )

  if (year > 2012) {
    url <- paste0("https://www.gov.br/infraestrutura/pt-br/assuntos/transito/conteudo-denatran/frota-de-veiculos-", year)
  } else {
    # Antes de 2013 os dados vem em um arquivo unico zip
    stop("Utilize a função download_frota_old()")
  }

  if (!dir.exists(tempdir)) dir.create(tempdir, recursive = T)
  if (!dir.exists(dir)) dir.create(dir, recursive = T)

  download_file <- function(i) {
    if (i$filetype %in% c("rar", "zip")) handle_compact(i)
    if (i$filetype %in% c("xlsx", "xls")) handle_xl(i)
  }

  make_filename <- function(i, ext = TRUE) {
    stringi::stri_trans_general(i$txt, id = "Latin-ASCII; lower") %>% 
    stringr::str_replace_all("\\s+", "_") %>% 
    paste0(., "_", i$mes, "-", i$ano, ifelse(ext, paste0(".", i$filetype), as.character("")))
  }

  handle_xl <- function(i) {
    dest_path_file <- paste0(dir, "/", prefix, "_", i$mes, "-", i$ano, paste0(".", i$filetype))
    if (!file.exists(dest_path_file)) {
      utils::download.file(
        url = i$href,
        destfile = dest_path_file
      )
    }
  }
  
  handle_compact <- function(i) {
    path_file_zip <- paste0(tempdir, "/", make_filename(i))
    dir_file <- paste0(tempdir, "/", make_filename(i, ext = F))

    if (!file.exists(path_file_zip)) {
      utils::download.file(url = i$href, destfile = path_file_zip)
    }

    # archive package has a bug <https://github.com/jimhester/archive/issues/37>
    if (i$filetype == "rar") {
      if (!dir.exists(dir_file)) dir.create(dir_file)
      system(paste0("unrar -o+ -inul x ", path_file_zip, " ", dir_file))
    } else {
      archive::archive_extract(path_file_zip, dir = dir_file)
    }
    
    # Remove rar, zip files. Keep only xls or xlsx
    list.files(dir_file, full.names = T, pattern = "rar|zip") %>% purrr::walk(~file.remove(.x))

    file <- list.files(dir_file) %>% .[!is.na(.)]

    if (length(file) == 0) {
      stop(paste0("File not found on dir"))
    }

    file_ext <- stringr::str_extract(file, ".(xlsx|xls)")

    # String multibyte is invalid
    # file.rename(
    #   from = paste0(dir_file, "/", file),
    #   to = paste0(dir_file, "/", prefix, "_", month, "-", year, file_ext)
    # )

    if (!dir.exists(dir)) dir.create(dir)

    file.copy(
      overwrite = TRUE,
      from = paste0(dir_file, "/", file),
      to = paste0(dir, "/", prefix, "_", i$mes, "-", i$ano, file_ext)
    )

  }

  get_html <- xml2::read_html(httr::GET(url, httr::user_agent("httr")))
  nodes <- get_html %>% rvest::html_nodes("p > a")

  tibble::tibble(
    txt = nodes %>% rvest::html_text(),
    href = nodes %>% rvest::html_attr("href")
  ) %>%
  dplyr::filter(stringr::str_ends(href, "xls|xlsx|rar|zip")) %>%
  dplyr::mutate(
    mes_name = stringr::str_match(href, regex(stringr::str_c(names(months), collapse = "|"))) %>% as.vector(),
    ano = stringr::str_match(href, "\\d{4}") %>% as.vector() %>% as.numeric(),
    mes = months[mes_name],
    filetype = stringr::str_match(href, "[a-z]+$") %>% as.vector()
  ) %>%
  dplyr::filter(
    stringr::str_detect(txt, regex(key, ignore_case = TRUE)),
    mes %in% month
  ) %>% 
  purrr::transpose() %>% 
  purrr::walk(~download_file(.x))
}