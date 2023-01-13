## @arthurfg
## 13/01/2023

## libs
library(tidyverse)
library(lubridate)

## etl
readr::read_csv2("https://www.gov.br/secretariageral/pt-br/acesso-a-informacao/informacoes-classificadas-e-desclassificadas/Planilha12003a2022.csv", locale = readr::locale(encoding = "IBM850")) %>%
  drop_na(`CPF SERVIDOR`) %>%
  mutate(
    DATA_PGTO = dmy(`DATA PGTO`),
    ANO_MES_DATA = floor_date(DATA_PGTO, unit = "1 month"),
    ANO = year(DATA_PGTO),
    PRESIDENTE = case_when(
      ANO <= 2010 ~ "Lula",
      ANO <= 2016 ~ "Dilma",
      ANO <= 2018 ~ "Temer",
      ANO <= 2022 ~ "Bolsonaro")) %>%
  mutate(
    VALOR = VALOR %>% str_remove("R\\$ ") %>% parse_number(locale = readr::locale(decimal_mark = ",")),
    VALOR_CORRIGIDO = deflateBR::deflate(VALOR, DATA_PGTO, "01/2003", "ipca")) %>% 
  rename(
    ano = ANO,
    presidente = PRESIDENTE,
    data_pagamento = DATA_PGTO,
    cpf_servidor = `CPF SERVIDOR`,
    cpf_cnpj_fornecedor = `CPF/CNPJ FORNECEDOR`,
    nome_fornecedor = `NOME FORNECEDOR`,
    valor = VALOR,
    tipo = TIPO ,
    subelemento_despesa = `SUBELEMENTO DE DESPESA`,
    cdic = CDIC) %>%
  select(ano,
         presidente,
         data_pagamento,
         cpf_servidor,
         cpf_cnpj_fornecedor,
         nome_fornecedor,
         tipo,
         subelemento_despesa,
         cdic,
         valor) %>%
  write.csv('./Desktop/despesas_cartao_corporativo.csv',  na = " ", 
            row.names = F)