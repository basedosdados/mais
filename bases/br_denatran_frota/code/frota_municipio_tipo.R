library(janitor)
library(lubridate)
library(xlsx) # <Require java>
library(readxl)
library(dplyr)
library(tidyr)
library(magrittr)
library(purrr)
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
2003:2012 %>% purrr::walk(
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

2021 %>% purrr::walk(
  ~download_frota(
    key = "Frota por Munic", 
    prefix = PREFIX_FROTA_MUN,
    month = 1:3,
    year = .x,
    tempdir = PATH_TEMP,
    dir = PATH_DOWNLOAD_MUN
  )
)

list.files(PATH_DOWNLOAD_MUN, full.names = T) %>%
  purrr::map(
    ~read_xl(.x, type = "uf") %>%
      dplyr::select(!total) %>%
      dplyr::rename(sigla_uf = uf, municipio_original = municipio) %>%
      dplyr::filter(sigla_uf %in% names(siglas_uf)) %>%
      dplyr::mutate(
        dplyr::across(!c(sigla_uf, municipio_original), as.numeric),
        id_municipio = purrr::map2_chr(sigla_uf, municipio_original, ~get_ibge_info(.x, .y))
      ) %>%
      dplyr::relocate(c(id_municipio, ano, mes), .after = municipio_original)
  ) -> frota_municipios


# Cada tibble deve ter 28 colunas
frota_municipios %>% purrr::map_lgl(~ncol(.x) == 26) %>% all(T)

# Unnest a lista de tibbles, padroniza as colunas, soma e salva como csv e rds
frota_municipios %>%
  purrr::map_dfr(~tidyr::unnest(.)) %>%
  dplyr::mutate(
    chassiplataforma = na.omit(
      dplyr::c_across(dplyr::any_of(c("chassiplataforma", "chassiplatafaforma", "chassiplataf")))
    )[1],
    tratoresteira = na.omit(
      dplyr::c_across(dplyr::any_of(c("tratoresteira", "tratorestei")))
    )[1]
  ) %>%
  dplyr::select(-dplyr::any_of(c("chassiplatafaforma", "chassiplataf", "tratorestei"))) %>%
  dplyr::mutate(
    total = rowSums(dplyr::across(automovel:chassiplataforma))
  ) -> df_municipios

# Filter municipios que não foram encontrados na tabela do IBGE
df_municipios %>%
  filter(is.na(id_municipio)) %>%
  group_by(municipio_original, sigla_uf) %>%
  summarise()

## Fix nome dos municipios
# ASSU, RN -> AÇU, 2400208
# BOA SAUDE, RN -> Januário Cicco, 2405306
# BOM JESUS, GO -> Bom Jesus de Goiás, 5203500
# EMBU, SP -> Embu das Artes, "3515004"
# ITABIRINHA DE MANTENA, MG -> Itabirinha, 3131802
# ITAMARACA, PE -> Ilha de Itamaracá, "2607604"
# JAMARI, RO -> Candeias do Jamari, "1100809"
# LIVRAMENTO DO BRUMADO, BA -> Livramento de Nossa Senhora, "2919504"
# SANTA ROSA, AC -> Santa Rosa do Purus, "1200435"
# SAO BENTO DE POMBAL, PB -> São Bentinho, "2513927"
# VILA ALTA, PR -> Alto Paraíso, "4128625"
# VILA NOVA DO MAMORE, RO -> Nova Mamoré, "1100338"

df_municipios %>%
  dplyr::mutate(
    id_municipio =
      dplyr::case_when(
        municipio_original == "ASSU" & sigla_uf == "RN" ~ "2400208",
        municipio_original == "BOA SAUDE" & sigla_uf == "RN" ~ "2405306",
        municipio_original == "BOM JESUS" & sigla_uf == "GO" ~ "5203500",
        municipio_original == "EMBU" & sigla_uf == "SP" ~ "3515004",
        municipio_original == "ITABIRINHA DE MANTENA" & sigla_uf == "MG" ~ "3131802",
        municipio_original == "ITAMARACA" & sigla_uf == "PE" ~ "2607604",
        municipio_original == "JAMARI" & sigla_uf == "RO" ~ "1100809",
        municipio_original == "LIVRAMENTO DO BRUMADO" & sigla_uf == "BA" ~ "2919504",
        municipio_original == "SANTA ROSA" & sigla_uf == "AC" ~ "1200435",
        municipio_original == "SAO BENTO DE POMBAL" & sigla_uf == "PB" ~ "2513927",
        municipio_original == "VILA ALTA" & sigla_uf == "PR" ~ "4128625",
        municipio_original == "VILA NOVA DO MAMORE" & sigla_uf == "RO" ~ "1100338",
        TRUE ~ id_municipio
      )
  ) -> frota_municipios_dist


frota_municipios_dist %>% 
  filter(is.na(id_municipio)) %>%
  group_by(municipio_original, sigla_uf) %>%
  summarise()

frota_municipios_dist %>% 
  dplyr::filter(!is.na(id_municipio)) %>%
  dplyr::select(!municipio_original) %>% 
  readr::write_rds(file = "output/municipio_tipo.rds") %T>%
  readr::write_csv(file = "output/municipio_tipo.csv")