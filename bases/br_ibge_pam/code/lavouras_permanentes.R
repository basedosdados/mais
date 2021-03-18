# ADENDOS -------------------
# A base criada está a nivel produto-municipio-ano. Todo produto tem 8 variáveis a seu respeito.
# A restrição de tamanho pela fonte dos dados, o sistema SIDRA (https://sidra.ibge.gov.br/pesquisa/pam/tabelas), 
# forçou a coleta em csvs quebrados.

#DIRETÓRIO----------

setwd("~/Documentos/bdmais")


# BIBLIOTECAS ---------------
library(readr)
library(reshape2)
library(dplyr)
library(stringr)
library(purrr)
library(glue)

# VETORES ------------------------
# definindo vetores com o conjunto de anos que vamos usar de recorte
vetor_anos <-c("2019":"1974")


anos_milcruzeiros<- c('1974':'1985', '1990':'1992')
anos_milcruzados <- c("1986":"1988")
anos_real <-c("1994":"2019")
vetor_uf <- c("RO","AC","AM","RR", "PA", "AP", "TO","MA", "PI", "CE","RN","PB","PE","AL", "SE","BA","MG", 
              "ES", "RJ","SP","PR","SC","RS", "MS", "MT","GO", "DF")

# definindo vetores de nomes de colunas e de produtos temporários

vetor_permanente <- c("id_municipio","ano","Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                      "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                      "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                      "Caju", "Caqui", "Castanha de caju", "Chá-da-Índia (folha verde)",
                      "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                      "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                      "Maçã", "Mamão", "Mangua", "Maracujá",
                      "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                      "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                      "Uva")

vetor_produtos <- vetor_permanente[3:40]

# FUNÇÕES -------------------------------

leitorinha <- function(local, nomedavar ){
  read.csv(local, header=FALSE, comment.char="#")%>%
    set_names(vetor_permanente)%>%
    filter(ano %in% vetor_anos)%>%
    as_tibble()%>%
    melt(id.vars = c("id_municipio","ano"), 
       measure.vars = vetor_produtos)%>%
    set_names(c("id_municipio", "ano", "produto", nomedavar))
} 

leitorinha_esp3 <- function(local, nomedavar ){
  read.csv(local, header=FALSE, comment.char="#")%>%
    set_names(vetor_permanente)%>%
    filter(substr(ano,1,4) %in% vetor_anos)%>%
    as_tibble()%>%
    melt(id.vars = c("id_municipio","ano"), 
         measure.vars = vetor_produtos)%>%
    set_names(c("id_municipio", "ano", "produto", nomedavar))
} 

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

part_anos <- function(x, nomedabase){
  filter(nomedabase, ano == x)
}

zeradora <- function(x){
  ifelse(is.na(x), "", x)
}

trespontos <- function(x){
  ifelse(x == "...", "", x)
  }

traco <- function(x){
  ifelse(x == "-", "", x)
}

toques_finais <- function(x){x%>%mutate(produto = as.character(produto),
                                   id_uf = str_sub(id_municipio,1,2),
                                   moeda_valor_prod = case_when(ano %in% anos_milcruzeiros ~ "Cruzeiros",
                                                                ano %in% anos_milcruzados ~ "Cruzados",
                                                                ano == "1989" ~ "Cruzados Novos",
                                                                ano == "1993" ~ "Cruzeiros Reais",
                                                                ano %in% anos_real ~ "Reais"),
                                   area_plantada = as.numeric(area_plantada)/100,
                                   area_colhida = as.numeric(area_colhida)/100,
                                   valor_producao = as.numeric(valor_producao)*1000,
                                   across(everything(),zeradora),
                                   across(everything(), trespontos),
                                   across(everything(), traco))
  }

listeira <- function(n){
      c(glue("bases_cruas/agro2/aplantada/aplantada{n}.csv"), glue("bases_cruas/agro2/percareaplantada/p{n}.csv"),
       glue("bases_cruas/agro2/acolhida/c{n}.csv"), glue("bases_cruas/agro2/percacolhida/q{n}.csv"),
       glue("bases_cruas/agro2/qtd/t{n}.csv"),glue("bases_cruas/agro2/rend/r{n}.csv"),
       glue("bases_cruas/agro2/valorprod/v{n}.csv"),glue("bases_cruas/agro2/percvalorprod/w{n}.csv"))
}

#APLICANDO --------------------------------

#LISTA DOS PRIMEIROS ANOS
anos_1 <- listeira(1)
anos_2 <- listeira(2)
anos_3 <- listeira(3)[-7] #situacao especifica
anos_4 <- listeira(4)

nomes_da_var <- c('area_plantada', 'prop_area_plantada','area_colhida', 'prop_area_colhida', 
                     'quantidade_produzida','rendimento_medio', 'valor_producao', 'prop_valor_producao')

nomes_da_var_esp3 <- nomes_da_var[-7]

lista1 <- map2(.x = anos_1, .y =nomes_da_var , .f = leitorinha)%>%
  reduce(inner_join, by = c('id_municipio', 'ano', 'produto'))%>%
  toques_finais()%>%
  cria_estados()

lista2 <- map2(.x = anos_2, .y=nomes_da_var, .f = leitorinha)%>%
  reduce(inner_join, by = c('id_municipio', 'ano', 'produto'))%>%
  toques_finais()%>%
  cria_estados()

lista4 <- map2(.x = anos_4, .y = nomes_da_var, .f = leitorinha)%>%
  reduce(inner_join, by = c('id_municipio', 'ano', 'produto'))%>%
  toques_finais()%>%
  cria_estados()

# caso da lista3

lista3_1 <- map2(.x = anos_3, .y = nomes_da_var_esp3, .f = leitorinha)%>%
  reduce(inner_join, by = c('id_municipio', 'ano', 'produto'))

lista3_2 <- leitorinha_esp3("bases_cruas/agro2/valorprod/v3.csv", "valor_producao")%>%
  mutate(ano = substr(ano,1,4),
         produto = as.character(produto))

lista3<- lista3_1%>%
  inner_join(lista3_2, by = c('id_municipio', 'ano', 'produto'))%>%
  toques_finais()%>%
  cria_estados()

# EXPAND GRID DE CADA PERÍODO --------------------
gera_grid<- function(anos){ expand.grid(x = vetor_uf,y = anos)}
gridtotal <- gera_grid("1974":"2019")
grid1 <- gera_grid("2007":'2019')
grid2 <- gera_grid("1994" : "2006")
grid3 <- gera_grid("1981" : "1993")
grid4 <- gera_grid("1974" : "1980")

uf_total <- pull(gridtotal,x)%>%as.character()
ano_total <- pull(gridtotal,y)%>%as.character()

uf_expand1 <- pull(grid1,x)%>%as.character()
ano_expand1 <- pull(grid1,y)%>%as.character()
nomes1 <- grid1%>%
  mutate(xy = str_c(y,"_",x))%>%
  pull(xy)

uf_expand2 <- pull(grid2,x)%>%as.character()
ano_expand2 <- pull(grid2,y)%>%as.character()
nomes2 <- grid2%>%
  mutate(xy = str_c(y,"_",x))%>%
  pull(xy)

uf_expand3 <- pull(grid3,x)%>%as.character()
ano_expand3 <- pull(grid3,y)%>%as.character()
nomes3 <- grid3%>%
  mutate(xy = str_c(y,"_",x))%>%
  pull(xy)

uf_expand4 <- pull(grid4,x)%>%as.character()
ano_expand4 <- pull(grid4,y)%>%as.character()
nomes4 <- grid4%>%
  mutate(xy = str_c(y,"_",x))%>%
  pull(xy)

# DIRETÓRIOS DE EXPORTAÇÃO

walk2(.x = uf_total, .y = ano_total, 
      ~dir.create(path = glue('bases_prontas/particionadas/municipio_lavouras_permanentes/ano={.y}/sigla_uf={.x}'))
)

# PERÍODO 2007:2019 --------------
lista_por_anos1 <- map(2007:2019, part_anos, nomedabase = lista1)
names(lista_por_anos1) <- '2007':'2019'

lista_por_estados1 <- map2(.x = uf_expand1, .y = ano_expand1 , 
                           .f = ~lista_por_anos1[[.y]]%>%
                           filter(sigla_uf == .x)%>%
                           select(-ano, -sigla_uf, -id_uf))%>%
                           set_names(nomes1)

walk2(.y = ano_expand1, .x = uf_expand1, 
      ~rio::export(lista_por_estados1[[glue("{.y}_{.x}")]], 
                  file = glue("bases_prontas/particionadas/municipio_lavouras_permanentes/ano={.y}/sigla_uf={.x}/{.y}_{.x}.csv"),
                  sep = ",", na = "", quote = TRUE, row.names = FALSE
      )
)

# PERÍODO DE 1994:2006
lista_por_anos2 <- map(1994:2006, part_anos, nomedabase = lista2)
names(lista_por_anos2) <- '1994':'2006'

lista_por_estados2 <- map2(.x = uf_expand2, .y = ano_expand2 , 
                           .f = ~lista_por_anos2[[.y]]%>%
                             filter(sigla_uf == .x)%>%
                             select(-ano, -sigla_uf, -id_uf))%>%
  set_names(nomes2)

walk2(.y = ano_expand2, .x = uf_expand2, 
      ~rio::export(lista_por_estados2[[glue("{.y}_{.x}")]], 
                   file = glue("bases_prontas/particionadas/municipio_lavouras_permanentes/ano={.y}/sigla_uf={.x}/{.y}_{.x}.csv"),
                   sep = ",", na = "", quote = TRUE, row.names = FALSE
      )
)

# PERÍODO DE 1981:1993
lista_por_anos3 <- map(1981:1993, part_anos, nomedabase = lista3)
names(lista_por_anos3) <- '1981':'1993'

lista_por_estados3 <- map2(.x = uf_expand3, .y = ano_expand3 , 
                           .f = ~lista_por_anos3[[.y]]%>%
                             filter(sigla_uf == .x)%>%
                             select(-ano, -sigla_uf, -id_uf))%>%
  set_names(nomes3)

walk2(.y = ano_expand3, .x = uf_expand3, 
      ~rio::export(lista_por_estados3[[glue("{.y}_{.x}")]], 
                   file = glue("bases_prontas/particionadas/municipio_lavouras_permanentes/ano={.y}/sigla_uf={.x}/{.y}_{.x}.csv"),
                   sep = ",", na = "", quote = TRUE, row.names = FALSE
      )
)

# PERÍODO DE 1974:1980
lista_por_anos4 <- map(1974:1980, part_anos, nomedabase = lista4)
names(lista_por_anos4) <- '1974':'1980'

lista_por_estados4 <- map2(.x = uf_expand4, .y = ano_expand4 , 
                           .f = ~lista_por_anos4[[.y]]%>%
                             filter(sigla_uf == .x)%>%
                             select(-ano, -sigla_uf, -id_uf))%>%
  set_names(nomes4)

walk2(.y = ano_expand4, .x = uf_expand4, 
      ~rio::export(lista_por_estados4[[glue("{.y}_{.x}")]], 
                   file = glue("bases_prontas/particionadas/municipio_lavouras_permanentes/ano={.y}/sigla_uf={.x}/{.y}_{.x}.csv"),
                   sep = ",", na = "", quote = TRUE, row.names = FALSE
      )
)






































