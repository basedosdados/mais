find_sheet <- function(x, date) {
  read_sheet <- tryCatch(
    readxl::excel_sheets(x),
    error = function(e) {
      xlsx::getSheets(xlsx::loadWorkbook(x)) %>% names()
    }
  )

  sheet_names <- read_sheet %>% 
    stringr::str_subset(., "^(?!.*Glossário).*$")

  if (length(sheet_names) == 1) {
    sheet_names[[1]]
  } else {
    month_name <- lubridate::month(date, label = T)

    query_sheet <- stringr::str_subset(
      sheet_names, 
      regex(paste0("\\d{2}(?=\\d{4}$)", "|", month_name), ignore_case = T) 
    )

    if (length(query_sheet) == 0) {
      return(sheet_names[[1]])
    }

    if (length(query_sheet) > 1) {
      # Exceções
      if (date == "01-04-2010") {
        return(query_sheet[[1]])
      }
      stop(paste(date, ", more than one sheet found"))
    }
    query_sheet
  }
}

row_of_header <- function(x, key_of_header) {
  # Return number of row than is the header of tibble
  # x is vector of first colunm
  # key_of_header is string
  match <- stringr::str_subset(x, stringr::regex(key_of_header, ignore_case = T))
  result <- which(x == match)

  if (length(result) == 0) {
    return(0)
  }
  
  if (length(result) > 1) {
    result[2]
  } else {
    result
  }
}

set_header <- function(x, key_of_header) {
  number_of_header <- row_of_header(x[[1]], key_of_header)
  if (number_of_header == 0) {
    return(x)
  }
  janitor::row_to_names(x, row_number = number_of_header)
}

# Some xls file can't be read by readxl package using read_xls() function, see this issue <https://github.com/tidyverse/readxl/issues/598>
read_old_xls <- function(x, date) {
  sheet_name <- find_sheet(x, date)
  start_row <- 1

  while (start_row <= 5) {
    result <- try(
      xlsx::read.xlsx2(
        x, 
        sheetName = sheet_name, 
        startRow = start_row,
        endRow = 10
      ),
      silent = T
    )
    # Number of column can be more than 23
    if (!is.null(result) && ncol(result) >= 23 && class(result) != "try-error") {
      break
    }
    start_row <- start_row + 1
  }
  xlsx::read.xlsx2(x, sheetName = sheet_name, startRow = start_row) %>% 
    tibble::as_tibble()
}

read_xl <- function(x, type) {
  date <- stringr::str_match(x, "\\d{1,2}-\\d{4}") %>% 
    paste0("01-", .) %>% 
    lubridate::dmy()
  
  read <- function(pl) {
    tryCatch(
      readxl::read_excel(pl, sheet = find_sheet(pl, date)),
      error = function(e) read_old_xls(x, date)
    )
  }

  read(x) %>% 
    set_header(., key_of_header = type) %>% 
    janitor::clean_names() %>% 
    dplyr::rename_with(.fn = function(x) stringr::str_replace(x, pattern = "_|\\.|-", replacement = "")) %>% 
    dplyr::select(!starts_with("na")) %>% 
    dplyr::mutate(
			ano = lubridate::year(date),
			mes = lubridate::month(date)
		)
}

# Tabela com os id dos estados e municipios
download_utils_files <- function() {
  if (!dir.exists("input")) dir.create("input/ibge_cods", recursive = T)
  utils::download.file(
    url = "ftp://geoftp.ibge.gov.br/organizacao_do_territorio/estrutura_territorial/divisao_territorial/2018/DTB_2018.zip",
    destfile = paste0("input/ibge_cods/ibge_cods.zip")
  )
  utils::unzip("input/ibge_cods/ibge_cods.zip", exdir = paste0("input/ibge_cods/"))
}

download_utils_files()

ibge_ids <- readxl::read_excel("input/ibge_cods/RELATORIO_DTB_BRASIL_DISTRITO.xls") %>% 
  janitor::clean_names()

ufs <- ibge_ids %>% 
    dplyr::group_by(nome_uf, uf) %>% 
    dplyr::summarise() %>% 
    dplyr::ungroup() %>% 
    dplyr::mutate(uf = as.numeric(uf)) %>% 
    dplyr::rename(id_uf = uf)

municipios <- ibge_ids %>% 
  dplyr::group_by(
    uf,
    nome_uf,
    codigo_municipio_completo, 
    nome_municipio
  ) %>% 
  dplyr::summarise() %>% 
  dplyr::mutate(
    name_upper = stringi::stri_trans_general(nome_municipio, id = "Latin-ASCII; upper"),
    codigo_municipio_completo = as.numeric(codigo_municipio_completo),
    uf = as.numeric(uf)
  ) %>% 
  dplyr::ungroup() %>% 
  dplyr::rename(
    id_uf = uf,
    uf = nome_uf,
    id_municipio = codigo_municipio_completo,
    municipio = nome_municipio
  )

siglas_uf <- c(
  "AC" = "Acre",
  "AL" = "Alagoas",
  "AP" = "Amapá",
  "AM" = "Amazonas",
  "BA" = "Bahia",
  "CE" = "Ceará",
  "DF" = "Distrito Federal",
  "ES" = "Espírito Santo",
  "GO" = "Goiás",
  "MA" = "Maranhão",
  "MT" = "Mato Grosso",
  "MS" = "Mato Grosso do Sul",
  "MG" = "Minas Gerais",
  "PA" = "Pará",
  "PB" = "Paraíba",
  "PR" = "Paraná",
  "PE" = "Pernambuco",
  "PI" = "Piauí",
  "RJ" = "Rio de Janeiro",
  "RN" = "Rio Grande do Norte",
  "RS" = "Rio Grande do Sul",
  "RO" = "Rondônia",
  "RR" = "Roraima",
  "SC" = "Santa Catarina",
  "SP" = "São Paulo",
  "SE" = "Sergipe",
  "TO" = "Tocantins"
)

get_ibge_info <- function(uf, name, tolerance = 0.60) {
  state <- siglas_uf[uf]
  result <- municipios %>%
    dplyr::filter(uf == state) %>%
    dplyr::mutate(dist = stringdist::stringsim(name_upper, name)) %>%
    dplyr::arrange(dplyr::desc(dist)) %>%
    dplyr::slice(1L) %>%
    as.list()

  if (length(result[[1]]) == 0 || result$dist < tolerance) {
    return(NA)
  }
  as.character(result$id_municipio)
}

get_uf_name <- function(x) {
  if (nchar(x) != 2) return(x)
  unname(siglas_uf[x])
}

get_sigla_uf <- function(uf_name) {
  purrr::keep(siglas_uf, ~.x == uf_name) %>%
		names()
}
