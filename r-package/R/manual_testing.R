# library(devtools)
# library(tidyverse)
# library(magrittr)
# library(dotenv)
#
# source("R/python_port.R")
# source("R/billing.R")
#
# load_dot_env('keys.env')
#
# set_billing_id(Sys.getenv('project_id'))
#
# query <- "SELECT
#     pib.id_municipio,
#     pop.ano,
#     pib.PIB / pop.populacao * 1000 as pib_per_capita
# FROM `basedosdados.br_ibge_pib.municipios` as pib
# JOIN `basedosdados.br_ibge_populacao.municipios` as pop
# ON pib.id_municipio = pop.id_municipio
#
# LIMIT 5
#
# "
#
# download(query, "pip_per_capita_municipios.csv")
# read_sql(query)



