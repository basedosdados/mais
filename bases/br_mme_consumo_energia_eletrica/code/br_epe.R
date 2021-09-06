### Pacotes ####
library(tidyverse)
library(readxl)
library(basedosdados)
source("cleanup.R")


basedosdados::set_billing_id("mahallla")

uf = basedosdados::read_sql("SELECT sigla as sigla_uf, nome as uf 
                            FROM `basedosdados.br_bd_diretorios_brasil.uf`")


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
df1 = cleanup("input/dados.xls", 10) %>% mutate(tipo_consumo = "Consumo Total") 
df2 = cleanup("input/dados.xls", 11) %>% mutate(tipo_consumo = "Consumo Cativo")
df3 = cleanup("input/dados.xls", 12) %>% mutate(tipo_consumo = "Consumo Residencial")
df4 = cleanup("input/dados.xls", 13) %>% mutate(tipo_consumo = "Consumo Industrial")
df5 = cleanup("input/dados.xls", 14) %>% mutate(tipo_consumo = "Consumo Comercial")
df6 = cleanup("input/dados.xls", 15) %>% mutate(tipo_consumo = "Consumo Outros")

#### Finalizar  
df7 = list(df1, df2, df3, df4, df5, df6) 
df_total = Reduce(rbind, df7)

write.csv(df_total, "output/consumo_energia.csv",  na = " ", 
          row.names = F, fileEncoding = "UTF-8")
