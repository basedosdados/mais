library(janitor)
library(lubridate)
library(xlsx) # <Require java>
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(magrittr)
library(purrr)
library(readr)
library(stringdist)

source("code/download_frota.R")
source("code/download_frota_old.R")
source("code/utils.R")

PATH_TEMP <- paste0(getwd(), "/tmp")
PATH_DOWNLOAD_REG <- paste0(getwd(), "/input/frota_regiao_tipo")

PREFIX_FROTA_REG <- "frota_regiao_tipo"

# Download da frota por regiao de 2003 a 2012
2003:2012 %>% purrr::walk(
  ~download_frota_old(
    key = "regiao",
    prefix = PREFIX_FROTA_REG,
    year = .x,
    tempdir = PATH_TEMP,
    dir = PATH_DOWNLOAD_REG
  )
)

# Download da frota por regiao e tipo em 2013
## Demais meses de agosto a key é "Frota por Tipo"
2013 %>% 
  purrr::walk(~download_frota(
    key = "Frota por tipo",
    prefix = PREFIX_FROTA_REG,
    month = c(1:7, 10:12),
    year = .x,
    tempdir = PATH_TEMP,
    dir = PATH_DOWNLOAD_REG
  ))

## Agosto e setembro de 2013 a key é "Frota por Região"
2013 %>%
  purrr::walk(~download_frota(
    key = "Frota por Região",
    prefix = PREFIX_FROTA_REG,
    month = 8:9,
    year = .x,
    tempdir = PATH_TEMP,
    dir = PATH_DOWNLOAD_REG
  ))


# Download da frota de 2014 a 2020 por região e tipo veículo
2014:2020 %>% purrr::walk(~download_frota(
  key = "Frota por UF e Tipo",
  prefix = PREFIX_FROTA_REG,
  month = 1:12,
  year = .x,
  tempdir = PATH_TEMP,
  dir = PATH_DOWNLOAD_REG
))


2021 %>% purrr::walk(~download_frota(
  key = "Frota por UF e Tipo",
  prefix = PREFIX_FROTA_REG,
  month = 1:12,
  year = .x,
  tempdir = PATH_TEMP,
  dir = PATH_DOWNLOAD_REG
))

list.files(PATH_DOWNLOAD_REG, full.names = T) %>%
  purrr::map(
    ~read_xl(.x, type = "grandes reg|uf") %>%
      dplyr::rename("sigla_uf" = 1) %>%
      dplyr::filter(sigla_uf %in%  unname(siglas_uf)) %>%
      dplyr::select(sigla_uf, ano, mes, automovel:utilitario) %>%
      dplyr::rowwise() %>%
      dplyr::mutate(
        dplyr::across(!c(sigla_uf), as.numeric),
        sigla_uf = sigla_uf %>% stringr::str_trim() %>% get_sigla_uf(),
        total = rowSums(across(automovel:utilitario))
      )
  ) -> frota_regiao

# Cada tibble deve ter 25 colunas e 27 linhas
frota_regiao %>% purrr::map_lgl(~ncol(.x) == 25 & nrow(.x) == 27) %>% all(T)

frota_regiao %>% 
  purrr::map_dfr(~tidyr::unnest(.)) %>% 
  readr::write_csv(file = "output/uf_tipo.csv") %T>%
  readr::write_rds(file = "output/uf_tipo.rds")