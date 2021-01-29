##### Limpar memoria e denifir diretorio #####

rm(list = ls())

setwd("~/basedosdados/tratamento/ppm/input")

##### Pacotes ##### 

library(readxl)

library(readr)

library(dplyr)

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

##### Dados de pecuaria (Cabecas) #####

### 94: Vacas Ordenhadas ###

dados94 = read.csv2(
  "tabela94.csv", 
  sep = ";", 
  skip = 2, 
  col.names = c("ano", "id_municipio", 
                "excluir", "excluir2", 
                "vacas_ordenhadas"),
  nrows = 256174,
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
          "~/basedosdados/tratamento/pesquisa_pecuaria_municipal/output/dados_pecuaria.csv",
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
                "excluir", "tipo_de_produto", 
                "excluir2", "producao_aquicultura"), 
  nrows = 644280,
  encoding = "UTF-8",
  header = F)


# limpar valores inconsistentes, excluir colunas e ordenar variaveis

dados3940 = bd_clean(dados3940, c(3,5), c(2,1,3,4))

## Valor da producao (percentual) 

dados3940_vpercentual = read.csv2(
  "tabela3940_valor_percentual_producao.csv",
  sep = ";", 
  skip = 2, 
  col.names = c("ano", "id_municipio", 
                "excluir", "tipo_de_produto", 
                "excluir2", "valor_producao_percentual_total_geral"), 
  nrows = 644280,
  encoding = "UTF-8",
  header = F
)

# limpar valores inconsistentes, excluir colunas e ordenar variaveis

dados3940_vpercentual = bd_clean(dados3940_vpercentual, c(3,5), c(2,1,3,4))

## Valor da producao  

dados3940_producao = read.csv2(
  "tabela3940_valor_producao.csv",
  sep = ";", 
  skip = 2, 
  col.names = c("ano", "id_municipio", 
                "excluir", "tipo_de_produto", 
                "excluir2", "valor_producao_mil_reais"), 
  nrows = 644280,
  encoding = "UTF-8",
  header = F
)

# limpar valores inconsistentes, excluir colunas e ordenar variaveis

dados3940_producao = bd_clean(dados3940_producao, c(3,5), c(2,1,3,4))


# tabelas finais 

tabela3940_final = dados3940

tabela3940_final$valor_producao_mil_reais = dados3940_producao$valor_producao_mil_reais

tabela3940_final$valor_producao_percentual_total_geral = dados3940_vpercentual$valor_producao_percentual_total_geral


# exportar

write.csv(tabela3940_final,
          "~/basedosdados/tratamento/pesquisa_pecuaria_municipal/output/producao_da_aquicultura.csv",
          na = " ",
          row.names = F)

##### 3939: efetivo dos rebanhos, por tipo de rebanho #####

dados3939 = read.csv2(
  "tabela3939.csv", 
  sep = ";", 
  skip = 3, 
  col.names = c("ano", "id_municipio", 
                "excluir", "tipo_de_rebanho", 
                "quantidade_de_animais"),
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
                                  "tipo_de_produto_origem_animal", 
                                  "producao"), 
                    nrows = 1537044,
                    encoding = "UTF-8",
                    header = F)


# limpar valores inconsistentes, excluir colunas e ordenar variaveis

dados74 = bd_clean(dados74, c(3), c(2,1,3,4))

## Valor da producao (percentual) 

dados74_vpercentual = read.csv2(
  "tabela74_valor_percentual_producao.csv",
  sep = ";", 
  skip = 3, 
  col.names = c("ano", "id_municipio", 
                "excluir", "tipo_de_produto_origem_animal", 
                "valor_producao_percentual_total_geral"), 
  nrows = 1537044,
  encoding = "UTF-8",
  header = F
)

# limpar valores inconsistentes, excluir colunas e ordenar variaveis

dados74_vpercentual = bd_clean(dados74_vpercentual, c(3), c(2,1,3,4))

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

# tabelas finais

dados74$valor_producao_percentual_total_geral = dados74_vpercentual$valor_producao_percentual_total_geral

dados74$valor_producao = dados74_producao$valor_producao_mil_reais

# mudar ordem das colunas


dados74 <- dados74 %>%
  select(id_municipio, ano, 
         tipo_de_produto_origem_animal, producao,
         valor_producao, valor_producao_percentual_total_geral, moeda)



# exportar 

write.csv(dados74,
          "~/basedosdados/tratamento/pesquisa_pecuaria_municipal/output/producao_origem_animal.csv",
          na = " ",
          row.names = F)
