#base das lavouras permanentes
#biblios
library(readr)
library(reshape2)
library(tidyverse)
library(stringr)
library(glue)
library(sidrar)

#diretorio e criando diretorios
setwd("~/Documentos/bdmais")

#infos sobre a base
sidrar::info_sidra("1613")



teste<- sidrar::get_sidra("1613", period = "1985", geo = "City", 
                  geo.filter = list("City" = "3136702"))

#funcao de gerar estado
cria_estados <- function(x){
  x%>%
    mutate(sigla_uf = case_when(id_uf == "11" ~ "RO", id_uf == "12" ~ "AC", id_uf == "13" ~ "AM",
                                id_uf == "14" ~ "RR", id_uf == "15" ~ "PA", id_uf == "16" ~ "AP", id_uf == "17" ~ "TO",
                                id_uf == "21" ~ "MA", id_uf == "22" ~ "PI", id_uf == "23" ~ "CE", id_uf == "24" ~ "RN",
                                id_uf == "25" ~ "PB", id_uf == "26" ~ "PE", id_uf == "27" ~ "AL", id_uf == "28" ~ "SE", id_uf == "29" ~ "BA",
                                id_uf == "31" ~ "MG", id_uf == "32" ~ "ES", id_uf == "33" ~ "RJ", id_uf == "35" ~ "SP", 
                                id_uf == "41" ~ "PR", id_uf == "42" ~ "SC", id_uf == "43" ~ "RS",
                                id_uf == "50" ~ "MS", id_uf == "51" ~ "MT", id_uf == "52" ~ "GO", id_uf == "53" ~ "DF"))
}

anos_milcruzeiros1<- c('1974':'1985')
anos_milcruzeiros2 <- c('1989':'1992')
anos_milcruzados <- c('1986':'1988')
anos_real <-c('1994':'2019')

converte_valores <- function(x){
  x%>%
    mutate(valor_producao = case_when(ano %in% anos_milcruzeiros1 ~ valor_producao/(1000^4)*2.75,
                                      ano %in% anos_milcruzados ~ valor_producao/(1000^3) * 2.75,
                                      ano %in% anos_milcruzeiros2 ~ valor_producao/(1000^2)* 2.75,
                                      ano == "1993" ~ (valor_producao/1000)*2.75,
                                      ano %in% anos_real ~ valor_producao))
}


#pegando variaveis
pega_variavel <- function(estado,ano,cod,variavel){
  sidrar::get_sidra("1613", variable= cod, period = ano, geo = "City", 
                    geo.filter = list("State" = str_sub(estado,1,2)))%>%
    select(`Município (Código)`, `Ano`, `Produto das lavouras permanentes`, `Valor`)%>%
    set_names('id_municipio', 'ano', 'produto', variavel)%>%
    filter(!produto == "Total")
}

pega_base <- function(estado,ano){
  a = pega_variavel(estado, ano, '2313', 'area_plantada')
  b = pega_variavel(estado, ano, '216', 'area_colhida')
  c = pega_variavel(estado, ano, '214', 'quantidade_produzida')
  d = pega_variavel(estado, ano, '112', 'rendimento_medio')
  e = pega_variavel(estado, ano, '215', 'valor_producao')
  f = pega_variavel(estado, ano, '1002313', 'prop_area_plantada')
  g = pega_variavel(estado, ano, '1000216', 'prop_area_colhida')
  h = pega_variavel(estado, ano, '1000215', 'prop_valor_producao')
  z = list(a,b,c,d,e,f,g,h)
  m = reduce(z, inner_join, by = c('id_municipio', 'ano', 'produto'))%>%
    mutate(id_uf = substr(id_municipio,1,2))%>%
    cria_estados()%>%
    converte_valores()%>%
    select(-ano, -id_uf, -sigla_uf)%>%
    rio::export(
      file = glue("bases_prontas/particionadas/municipios_lavouras_permanentes/ano={ano}/sigla_uf={str_sub(estado,4,5)}/{ano}_{str_sub(estado,4,5)}.csv")
    )
}


unida_uf <- c("11_RO", "12_AC","13_AM","14_RR","15_PA","16_AP","17_TO","21_MA","22_PI","23_CE",
              "24_RN", "25_PB", "26_PE","27_AL","28_SE","29_BA","31_MG","32_ES","33_RJ","35_SP",
              "41_PR","42_SC","43_RS","50_MS", "51_MT","52_GO","53_DF")

anos <- 1974:2019

lista_anos <- expand_grid(anos,unida_uf)%>%pull(anos)%>%as.character
lista_ufs <- expand_grid(anos,unida_uf)%>%pull(unida_uf)

#diretorios para guardar as bases
#walk2(.x = lista_ufs, .y = lista_anos, 
#      ~dir.create(path = glue('bases_prontas/particionadas/municipios_lavouras_permanentes/ano={.y}/sigla_uf={str_sub(.x,4,5)}'))
#)

#loop
walk2(lista_ufs, lista_anos, pega_base)


