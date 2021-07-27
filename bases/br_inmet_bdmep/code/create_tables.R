library(dplyr)

fs::dir_ls("code/func") %>%
  lapply(source)

# Download dos dados
purrr::walk(2000:2021, download_inmet)
purrr::walk(fs::dir_ls("tmp"), ~unzip(.x,exdir = "input"))
fs::dir_create("input/2020/")
unzip("tmp/2020.zip", exdir = "input/2020")
fs::dir_create("input/2021")
unzip("tmp/2021.zip", exdir = "input/2021")

# Parseando dados
purrr::walk(2000:2021, get_base_inmet)

# Criando tabela de estações
estacoes = purrr::map_dfr(2000:2021, get_stations_inmet)

table_estacoes = estacoes %>%
  rename(id_estacao=codigo) %>%
  arrange(desc(ano)) %>% 
  distinct(id_estacao, .keep_all=TRUE) %>%
  relocate(id_estacao,estacao, latitude, longitude, altitude, data_fundacao, id_municipio) %>%
  select(-ano, - municipio)

fs::dir_create("output/estacoes/")
data.table::fwrite(table_estacoes, 'output/estacoes/estacoes.csv')
