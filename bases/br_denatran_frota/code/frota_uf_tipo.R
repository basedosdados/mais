library(janitor)
library(lubridate)
library(xlsx) # <Require java>
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(magrittr)
library(readr)
library(stringdist)

source("code/download_frota.R")
source("code/download_frota_old.R")
source("code/utils.R")

PATH_TEMP <- paste0(getwd(), "/tmp")
PATH_DOWNLOAD_REG <- paste0(getwd(), "/input/frota_regiao_tipo")

PREFIX_FROTA_REG <- "frota_regiao_tipo"

# Download da frota por regiao de 2014 a 2014
2009:2014 %>% purrr::walk(
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

list.files(PATH_DOWNLOAD_REG, full.names = T) %>% 
  purrr::map(
    ~read_xl(.x, type = "grandes reg") %>% 
    dplyr::rename("uf" = 1) %>% 
    dplyr::mutate(
      uf = stringr::str_trim(uf)
    ) %>% 
    dplyr::filter(
      uf %in% c(
        "Acre",
        "Amapá",
        "Amazonas",
        "Pará",
        "Rondônia",
        "Roraima",
        "Tocantins",
        "Alagoas",
        "Bahia",
        "Ceará",
        "Maranhão",
        "Paraíba",
        "Pernambuco",
        "Piauí",
        "Rio Grande do Norte",
        "Sergipe",
        "Espírito Santo",
        "Minas Gerais",
        "Rio de Janeiro",
        "São Paulo",
        "Paraná",
        "Rio Grande do Sul",
        "Santa Catarina",
        "Distrito Federal",
        "Goiás",
        "Mato Grosso",
        "Mato Grosso do Sul"
      )
    ) %>% 
    dplyr::select(uf, data, automovel:utilitario) %>% 
    dplyr::rowwise() %>% 
    dplyr::mutate(
      dplyr::across(!c(uf, data), as.numeric),
      total = rowSums(across(automovel:utilitario)),
      id_uf = ufs$uf_id[ufs$nome_uf == uf]
    ) %>% 
    dplyr::relocate(id_uf, .after = uf)
  ) -> frota_regiao

# Cada tibble deve ter 25 colunas e 27 linhas
frota_regiao %>% purrr::map_lgl(~ncol(.x) == 25 & nrow(.x) == 27) %>% all(T)

frota_regiao %>% 
  tibble::tibble() %>% 
  tidyr::unnest() %>% 
  readr::write_csv(file = "output/uf_tipo.csv") %T>%
  readr::write_rds(file = "output/uf_tipo.rds")