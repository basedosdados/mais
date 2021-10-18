### Pacotes ####
library(tidyverse)
library(readxl)
library(basedosdados)
library(Rcpp)
library(dplyr)
source("cleanup1.R")
source("cleanup2.R")
setwd("~/basedosdados/tratamento/4_br_epe/input")

uf = readxl::read_excel("uf.xlsx")

linhas = c(1, 4, 32)

meses <- c(
  "JAN" = 1, 
  "FEV" = 2,
  "MAR" = 3,
  "ABR" = 4,
  "MAI" = 5,
  "JUN" = 6,
  "JUL" = 7,
  "AGO" = 8,
  "SET" = 9,
  "OUT" = 10,
  "NOV" = 11,
  "DEZ" = 12) 

anos = c(
  '2004' = 2004,
  '2005' = 2005,
  '2006' = 2006,
  '2007' = 2007,
  '2008' = 2008,
  '2009' = 2009,
  '2010' = 2010,
  '2011' = 2011,
  '2012' = 2012,
  '2013' = 2013,
  '2014' = 2014,
  '2015' = 2015,
  '2016' = 2016,
  '2017' = 2017,
  '2018' = 2018,
  '2019' = 2019,
  '2020' = 2020,
  '2021*' = 2021)

lista_cols = c(ano = 'V1',
                 mes = 'V2',
                 Rondônia = 'V3',
                 Acre = 'V4',
                 Amazonas = 'V5',
                 Roraima = 'V6',
                 Pará = 'V7',
                 Amapá = 'V8',
                 Tocantins = 'V9',
                 Maranhão = 'V10',
                 Piauí = 'V11',
                 Ceará = 'V12',
                 `Rio Grande do Norte` = 'V13',
                 Paraíba = 'V14',
                 Pernambuco = 'V15',
                 Alagoas = 'V16',
                 Sergipe = 'V17',
                 Bahia = 'V18',
                 `Minas Gerais` = 'V19',
                 `Espírito Santo` = 'V20',
                 `Rio de Janeiro` = 'V21',
                 `São Paulo` = 'V22',
                 Paraná = 'V23',
                 `Santa Catarina` = 'V24',
                 `Rio Grande do Sul` = 'V25',
                 `Mato Grosso do Sul` = 'V26',
                 `Mato Grosso` = 'V27',
                 Goiás = 'V28',
                 `Distrito Federal` = 'V29') 

#### Tratar 
df1 = cleanup1("dados.xls", 10) %>% mutate(tipo_consumo = "Total") 
df2 = cleanup1("dados.xls", 11) %>% mutate(tipo_consumo = "Cativo")
df3 = cleanup1("dados.xls", 12) %>% mutate(tipo_consumo = "Residencial")
df4 = cleanup1("dados.xls", 13) %>% mutate(tipo_consumo = "Industrial")
df5 = cleanup1("dados.xls", 14) %>% mutate(tipo_consumo = "Comercial")
df6 = cleanup1("dados.xls", 15) %>% mutate(tipo_consumo = "Outros")
df7 = cleanup2("dados.xls", 16) %>% mutate(tipo_consumo = "Residencial")
df8 = cleanup2("dados.xls", 17) %>% mutate(tipo_consumo = "Industrial")
df9 = cleanup2("dados.xls", 18) %>% mutate(tipo_consumo = "Comercial")
df10 = cleanup2("dados.xls", 19) %>% mutate(tipo_consumo = "Outros")

#### Finalizar  
df_consumo = list(df1, df2, df3, df4, df5, df6)
df_consumidores = list(df7, df8, df9, df10)
df_consumo1 = Reduce(rbind, df_consumo)
df_consumidores1 = Reduce(rbind, df_consumidores)

df_total = left_join(df_consumo1, df_consumidores1, 
                     by = c("ano", "mes", "sigla_uf", "tipo_consumo"))

write.csv(df_total, "~/basedosdados/tratamento/4_br_epe/output/consumo_energia.csv",  na = " ", 
          row.names = F, fileEncoding = "UTF-8")


