library(archive) # <https://github.com/jimhester/archive>
library(stringr)
library(stringi)

download_frota_old <- function(key = NULL, prefix = NULL, year, tempdir = tempdir(), dir = getwd()) {
  
  if (year > 2012) {
    stop("Utilize download_frota()")
  }

  mi_url <- paste0(
    "https://www.gov.br/infraestrutura/pt-br/assuntos/transito/arquivos-denatran/estatisticas/renavam/", 
    year, 
    "/frota",
    ifelse(year > 2008, "_", ""), 
    year, 
    ".zip"
  )

  if (!dir.exists(tempdir)) dir.create(tempdir, recursive = T)
  if (!dir.exists(dir)) dir.create(dir, recursive = T)

  dir_temp <- paste0(tempdir, "/", "frota__", year)
  path_file <- paste0(dir_temp, ".zip")

  if (!file.exists(path_file)) {
    tryCatch(
      utils::download.file(
        url = mi_url,
        destfile = path_file
      ),
      error = function(e) {
        if (file.exists(path_file)) {
          file.remove(path_file)
        }
      }
    )

    utils::unzip(
      path_file, 
      exdir = paste0(tempdir, "/", "frota__", year)
    )
  }
  
  months <- c(
    "jan" = 1, 
    "fev" = 2,
    "mar" = 3,
    "abr" = 4,
    "mai" = 5,
    "jun" = 6,
    "jul" = 7,
    "ago" = 8,
    "set" = 9,
    "out" = 10,
    "nov" = 11, 
    "dez" = 12
  )

  list.files(path = dir_temp, full.names = T, recursive = T) %>% 
    purrr::walk(function(i) {
      if (stringr::str_ends(i, ".zip")) {
        utils::unzip(i, exdir = paste0(dirname(i), "/"))
      }
    })

  list.files(path = dir_temp, full.names = T, recursive = T) %>% 
    purrr::walk(function(i) {

      get_by <- list(
        regiao = "(frota tipo uf)|(frota uf)|(frota regiao uf)|(frota regiao tipo uf)",
        municipio  = "(frota munic)|(frota mun)"
      )

      new_name <- basename(i) %>% 
        stringi::stri_trans_general(id = "Latin-ASCII; lower") %>% 
        stringr::str_replace("regi�es", "regiao") %>% 
        stringr::str_replace_all("\\s+", "_") %>% 
        stringr::str_replace_all("_|-", " ") %>% 
        stringr::str_replace("^(\\d\\_|\\d)+", "") %>% 
        stringr::str_replace_all("internet|^\\s", "")

      # Match jan|fev|... or number of month (two digits)
      get_month <- stringr::str_match(
        new_name, 
        regex(paste0(stringr::str_c(names(months), collapse = "|"), "|\\d{2}(?=\\d{4})"), ignore_case = T)
      )

      month_i <- ifelse(
        stringr::str_count(get_month) == 2, 
        as.numeric(get_month),
        months[get_month]
      )

      file_ext <- stringr::str_extract(new_name, ".[a-zA-Z0-9]+$")

      if (stringr::str_detect(new_name, regex(get_by[[key]], ignore_case = T)) &
      stringr::str_ends(new_name, "(xls|xlsx)$")) {
        # print(paste0(paste0(dir, "/", prefix, "-", month_i, "-", year, file_ext), "--", i))
        file.copy(
          from = i,
          to = paste0(dir, "/", prefix, "_", month_i, "-", year, file_ext)
        )
      }
    })
}