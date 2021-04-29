library(janitor)
library(lubridate)
library(xlsx) # <Require java>
library(readxl)
library(dplyr)
library(tidyr)
library(readr)
library(stringr)
library(stringdist)

source("code/download_frota.R")
source("code/download_frota_old.R")
source("code/utils.R")

PATH_TEMP <- paste0(getwd(), "/tmp")
PATH_DOWNLOAD_MUN <- paste0(getwd(), "/input/frota_municipio_tipo")
PREFIX_FROTA_MUN <- "frota_mun_tipo"

# Download da frota de 2004 a 2012 por municipio
2004:2012 %>% purrr::walk(
  ~download_frota_old(
    key = "municipio",
    prefix = PREFIX_FROTA_MUN,
    year = .x,
    tempdir = PATH_TEMP,
    dir = PATH_DOWNLOAD_MUN
  )
)

2014:2020 %>% purrr::walk(
  ~download_frota(
    key = "Frota por Munic", 
    prefix = PREFIX_FROTA_MUN,
    month = 1:12, 
    year = .x,
    tempdir = PATH_TEMP,
    dir = PATH_DOWNLOAD_MUN
  )
)

list.files(PATH_DOWNLOAD_MUN, full.names = T)[1] %>% 
  purrr::map(
    ~read_xl(.x, type = "uf") %>%
    dplyr::select(!total) %>% 
    dplyr::rename(uf_original = uf, municipio_original = municipio) %>% 
    dplyr::rowwise() %>% 
    dplyr::mutate(
      dplyr::across(!c(uf_original, municipio_original, data), as.numeric),
      ibge_info = list(get_ibge_info(uf_original, municipio_original))
    ) %>% 
    tidyr::unnest_wider(col = "ibge_info") %>% 
    dplyr::relocate(c(data, uf_id, uf, municipio_id, municipio), .after = municipio_original)
  ) -> frota_municipios


# Cada tibble deve ter 28 colunas
frota_municipios %>% purrr::map_lgl(~ncol(.x) == 28) %>% all(T)

# Unnest a lista de tibbles, padroniza as colunas, soma e salva como csv e rds
frota_municipios %>% 
  tibble::tibble() %>% 
  tidyr::unnest() %>% 
  dplyr::rename(chassiplataforma = chassiplatafaforma) %>% 
  dplyr::rowwise() %>% 
  dplyr::mutate(
    chassiplataforma = tidyr::replace_na(chassiplataforma, chassiplataf),
    tratoresteira = tidyr::replace_na(tratoresteira, tratorestei)
  ) %>% 
  dplyr::select(!c(chassiplataf, tratorestei)) %>% 
  dplyr::mutate(
    total = rowSums(across(automovel:utilitario))
  ) %>% 
  readr::write_rds(file = "output/municipio_tipo.rds") %T>%
  readr::write_csv(file = "output/municipio_tipo.csv")