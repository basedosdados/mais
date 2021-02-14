##### Limpar memoria e denifir diretorio #####

rm(list = ls())

setwd("~/basedosdados/tratamento/pesquisa_pecuaria_municipal/input")

##### Pacotes ##### 

library(readxl)

library(readr)

library(dplyr)

library(beepr)

### Funcao ### 

bd_clean = function(df, colms_null, colms_order){
  
  df[colms_null] <- NULL
  
  df[df == "..."] <- NA
  df[df == "-"]   <- NA
  df[df == "X"]   <- NA
  
  df <- df %>%
    select(colms_order)
  
  return(df)
} 

#------------------------------------------------------------------------------#

##### Producao pecuaria (Cabecas) #####

### 94: Vacas Ordenhadas ###

dados94 = read.csv2(
  "tabela94.csv", 
  sep = ";", 
  skip = 2, 
  col.names = c("ano", "id_municipio", 
                "excluir", "excluir2", 
                "vacas_ordenhadas"),
  nrows = 256174,
  encoding = "UTF-8",
  header = F
)


# limpar valores inconsistentes, excluir colunas e ordenar variaveis

dados94 = bd_clean(dados94, c(3,4), c(2,1,3))

### 95: Ovinos tosquiados ###  

dados95 = read.csv2(
  "tabela95.csv", 
  skip = 2, 
  sep = ";", 
  col.names = c("ano", "id_municipio", 
                "excluir", "excluir2", 
                "ovinos_tosquiados"),
  header = F
)

# limpar valores inconsistentes, excluir colunas e ordenar variaveis

dados95 = bd_clean(dados95, c(3,4), c(2,1,3))

# juntar colunas 

dados_pecuaria = full_join(dados94, dados95,
                           by = c("id_municipio", "ano"))

# exportar

write.csv(dados_pecuaria,
          "~/basedosdados/tratamento/pesquisa_pecuaria_municipal/output/producao_pecuaria.csv",
          na = " ",
          row.names = F)

#------------------------------------------------------------------------------#

##### 3940: Producao da aquicultura, por tipo de produto  #####

## Producao aquicultura

dados3940 = read.csv2(
  "tabela3940_aquicultura.csv",
  sep = ";", 
  skip = 2, 
  col.names = c("ano", "id_municipio", 
                "excluir", "tipo_produto", 
                "excluir2", "producao"), 
  nrows = 644280,
  encoding = "UTF-8",
  header = F)


# limpar valores inconsistentes, excluir colunas e ordenar variaveis

dados3940 = bd_clean(dados3940, c(3,5), c(2,1,3,4))

## Valor da producao (percentual) 

tabela3940_prop_producao <- read_delim("tabela3940_prop_producao.csv", 
                                       ";", escape_double = FALSE, col_names = FALSE, 
                                       col_types = cols(X6 = col_number()), 
                                       locale = locale(grouping_mark = "."), 
                                       trim_ws = TRUE, skip = 2, n_max = 644280)

# limpar valores inconsistentes, excluir colunas e ordenar variaveis

tabela3940_prop_producao = bd_clean(tabela3940_prop_producao, c(3,5), c(2,1,3,4))

names(tabela3940_prop_producao) = c("id_municipio", "ano", 
                                    "tipo_produto", "prop_valor_producao")

## Valor da producao  

dados3940_producao = read.csv2(
  "tabela3940_valor_producao.csv",
  sep = ";", 
  skip = 2, 
  col.names = c("ano", "id_municipio", 
                "excluir", "tipo_produto", 
                "excluir2", "valor_producao"), 
  nrows = 644280,
  encoding = "UTF-8",
  header = F
)

# limpar valores inconsistentes, excluir colunas e ordenar variaveis

dados3940_producao = bd_clean(dados3940_producao, c(3,5), c(2,1,3,4))


# tabelas finais 

tabela3940_final = dados3940

tabela3940_final$valor_producao = dados3940_producao$valor_producao

tabela3940_final$prop_valor_producao = tabela3940_prop_producao$prop_valor_producao

# multiplicar valor da producao por 1000 

tabela3940_final$valor_producao = as.numeric(tabela3940_final$valor_producao)
tabela3940_final$valor_producao = tabela3940_final$valor_producao*1000

# criar variavel 'moeda' 

tabela3940_final$moeda = 'Mil Reais'
 
# exportar

write.csv(tabela3940_final,
          "~/basedosdados/tratamento/pesquisa_pecuaria_municipal/output/producao_aquicultura.csv",
          na = " ",
          row.names = F)

##### 3939: efetivo dos rebanhos, por tipo de rebanho #####

dados3939 = read.csv2(
  "tabela3939.csv", 
  sep = ";", 
  skip = 3, 
  col.names = c("ano", "id_municipio", 
                "excluir", "tipo_rebanho", 
                "quantidade_animais"),
  encoding = "UTF-8",
  nrows = 2560820,
  header = F
)

# limpar valores inconsistentes, excluir colunas e ordenar variaveis

dados3939 = bd_clean(dados3939, c(3), c(2,1,3,4))

# exportar 

write.csv(dados3939,
          "~/basedosdados/tratamento/pesquisa_pecuaria_municipal/output/efetivo_rebanhos.csv",
          na = " ",
          row.names = F)

#------------------------------------------------------------------------------#


##### 74: Producao de origem animal, por tipo de produto #####

## Producao origem animal ##

dados74 = read.csv2("tabela74_producao_origem_animal.csv",
                    sep = ";", 
                    skip = 3, 
                    col.names = c("ano", "id_municipio", 
                                  "excluir", 
                                  "tipo_produto", 
                                  "producao"), 
                    nrows = 1537044,
                    encoding = "UTF-8",
                    header = F)


# limpar valores inconsistentes, excluir colunas e ordenar variaveis

dados74 = bd_clean(dados74, c(3), c(2,1,3,4))

## Valor da producao (percentual) 

dados74_prop = read_delim("tabela74_prop_producao.csv", 
                          ";", escape_double = FALSE, col_names = FALSE, 
                          col_types = cols(X5 = col_number()), 
                          locale = locale(grouping_mark = "."),
                          trim_ws = TRUE, skip = 3, n_max = 1537044)

# limpar valores inconsistentes, excluir colunas e ordenar variaveis

dados74_prop = bd_clean(dados74_prop, c(3), c(2,1,3,4))

names(dados74_prop) = c("ano", "id_municipio", "tipo_produto", "prop_valor_producao")


## Valor da producao 

dados74_producao = read.csv2(
  "tabela74_valor_producao.csv",
  sep = ";", 
  skip = 3, 
  col.names = c("ano", "id_municipio", 
                "excluir", "tipo_de_produto_origem_animal", 
                "valor_producao_mil_reais"),
  nrows = 1537044,
  encoding = "UTF-8",
  header = F
)

# limpar valores inconsistentes, excluir colunas e ordenar variaveis

dados74_producao = bd_clean(dados74_producao, c(3), c(2,1,3,4))

# adicionar coluna (moeda) 

## Este procedimento pode demorar 03h30 para rodar

for ( i in 1:length(dados74$moeda)) {
  if(dados74$ano[i] <= 1985) {
    dados74$moeda[i] = "Mil Cruzeiros"  
  } 
  else if(dados74$ano[i] == 1990) {
    dados74$moeda[i] = "Mil Cruzeiros"  
  }
  else if(dados74$ano[i] == 1991) {
    dados74$moeda[i] = "Mil Cruzeiros"  
  }
  else if(dados74$ano[i] == 1986) {
    dados74$moeda[i] = "Mil Cruzados"  
  }
  else if(dados74$ano[i] == 1987) {
    dados74$moeda[i] = "Mil Cruzados"  
  }
  else if(dados74$ano[i] == 1988) {
    dados74$moeda[i] = "Mil Cruzados"  
  }
  else if(dados74$ano[i] == 1989){
    dados74$moeda[i] = "Mil Cruzados Novos"  
  }
  else if (dados74$ano[i] == 1993){
    dados74$moeda[i] = "Mil Cruzeiros Reais"  
  }
  else {
    dados74$moeda[i] = "Mil Reais"
  }
  
}

beep()

# tabelas finais

dados74$prop_valor_producao = dados74_prop$prop_valor_producao

dados74$valor_producao = dados74_producao$valor_producao_mil_reais

# mudar ordem das colunas


dados74 <- dados74 %>%
  select(id_municipio, ano, 
         tipo_produto, producao,
         valor_producao, prop_valor_producao, moeda)

# exportar 

write.csv(dados74,
          "~/basedosdados/tratamento/pesquisa_pecuaria_municipal/output/producao_origem_animal.csv",
          na = " ",
          row.names = F)
