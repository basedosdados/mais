rm(list = ls())

library(readxl)
library(readr)
library(dplyr)

#---------------------------------------------------------------------#

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

# excluir coluna

dados94$excluir = NULL
dados94$excluir2 = NULL


# limpar variaveis 

is.na(dados94[3]) <- dados94[3] == "..."
is.na(dados94[3]) <- dados94[3] == "-"
is.na(dados94[3]) <- dados94[3] == "X"

# mudar ordem das colunas

dados94 <- dados94 %>%
  select(id_municipio, ano, vacas_ordenhadas)
dados94

# exportar 

write.csv(dados94, 
          file = "94_vacas_ordenhadas.csv",
          na = " ",
          row.names = F)

#---------------------------------------------------------------------#

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

# tirar colunas 

dados95$excluir = NULL
dados95$excluir2 = NULL


# limpar variaveis 

is.na(dados95[3]) <- dados95[3] == "..."
is.na(dados95[3]) <- dados95[3] == "-"
is.na(dados95[3]) <- dados95[3] == "X"

# mudar ordem das colunas

dados95 <- dados95 %>%
  select(id_municipio, ano, ovinos_tosquiados)
dados95

# exportar

write.csv(dados95,
          file = "95_ovinos_tosquiados.csv",
          na = " ",
          row.names = F)

#---------------------------------------------------------------------#

### 3939: efetivo dos rebanhos, por tipo de rebanho ###

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

# excluir colunas

dados3939$excluir = NULL 


# limpar variaveis 

is.na(dados3939[4]) <- dados3939[4] == "..."
is.na(dados3939[4]) <- dados3939[4] == "-"
is.na(dados3939[4]) <- dados3939[4] == "X"

# mudar ordem das colunas

dados3939 <- dados3939 %>%
  select(id_municipio, ano, tipo_de_rebanho, quantidade_de_animais)
dados3939

# exportar 


write.csv(dados3939,
          file = "3939_efetivo_rebanhos.csv",
          na = " ",
          row.names = F)

#---------------------------------------------------------------------#


### 74: Producao de origem animal, por tipo de produto ###

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
                    header = F
                    
)
# excluir coluna

dados74$excluir = NULL

# limpar variaveis 

is.na(dados74[4]) <- dados74[4] == "..."
is.na(dados74[4]) <- dados74[4] == "-"
is.na(dados74[4]) <- dados74[4] == "X"

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

# excluir coluna

dados74_vpercentual$excluir = NULL

# limpar variaveis 

is.na(dados74_vpercentual[4]) <- dados74_vpercentual[4] == "..."
is.na(dados74_vpercentual[4]) <- dados74_vpercentual[4] == "-"
is.na(dados74_vpercentual[4]) <- dados74_vpercentual[4] == "X"

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

# excluir coluna

dados74_producao$excluir = NULL

# limpar variaveis 

is.na(dados74_producao[4]) <- dados74_producao[4] == "..."
is.na(dados74_producao[4]) <- dados74_producao[4] == "-"
is.na(dados74_producao[4]) <- dados74_producao[4] == "X"

# adicionar coluna -moeda

for ( i in 1:1537044) {
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
dados74


# exportar 


write.csv(dados74,
          file = "74_producao_origem_animal.csv",
          na = " ",
          row.names = F)


#---------------------------------------------------------------------#

### 3940: Producao da aquicultura, por tipo de produto ###

## Producao aquicultura

dados3940 = read.csv2(
  "tabela3940_aquicultura.csv",
  sep = ";", 
  skip = 2, 
  col.names = c("ano", "id_municipio", 
                "excluir", "tipo_de_produto", 
                "excluir2", "producao_aquicultura_quilogramas"), 
  nrows = 644280,
  encoding = "UTF-8",
  header = F
)

# excluir colunas

dados3940$excluir = NULL
dados3940$excluir2= NULL

# limpar variaveis 

is.na(dados3940[4]) <- dados3940[4] == "..."
is.na(dados3940[4]) <- dados3940[4] == "-"
is.na(dados3940[4]) <- dados3940[4] == "X"


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

# excluir coluna

dados3940_vpercentual$excluir = NULL
dados3940_vpercentual$excluir2 = NULL

# limpar variaveis 

is.na(dados3940_vpercentual[4]) <- dados3940_vpercentual[4] == "..."
is.na(dados3940_vpercentual[4]) <- dados3940_vpercentual[4] == "-"
is.na(dados3940_vpercentual[4]) <- dados3940_vpercentual[4] == "X"

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

# excluir coluna

dados3940_producao$excluir = NULL
dados3940_producao$excluir2 = NULL

# limpar variaveis 

is.na(dados3940_producao[4]) <- dados3940_producao[4] == "..."
is.na(dados3940_producao[4]) <- dados3940_producao[4] == "-"
is.na(dados3940_producao[4]) <- dados3940_producao[4] == "X"


# tabelas finais 

tabela3940_final = dados3940

tabela3940_final$valor_producao_mil_reais = dados3940_producao$valor_producao_mil_reais

tabela3940_final$valor_producao_percentual_total_geral = dados3940_vpercentual$valor_producao_percentual_total_geral

# mudar ordem das colunas

tabela3940_final <- tabela3940_final %>%
  select(id_municipio, ano, tipo_de_produto, 
         producao_aquicultura_quilogramas,valor_producao_mil_reais, 
         valor_producao_percentual_total_geral
  )
tabela3940_final

# exportar

write.csv(tabela3940_final,
          file = "3940_producao_da_aquicultura.csv",
          na = " ",
          row.names = F)
