#SCRIPT PARA AS LAVOURAS TEMPORÁRIAS

#Bibliotecas que podem ter sido usadas
library(readxl)
library(lubridate)
library(stringr)
library(dplyr)
library(ggplot2)
library(plm)
library(haven)
library(tidyr)
library(reshape2)
library(geobr)
library(xlsx)
library(psych)
library(readr)
library(devtools)
library(sidrar)
library(reshape2)

#Todo produto tem 8 variaveis e 43 anos para nivel municipal
#Fonte:https://sidra.ibge.gov.br/tabela/1612#
#As bases foram baixadas usando csv (us)  
#o Sidra só permite pegar de em torno de doze em doze anos pela restrição de tamanho
#Para bases tão grandes não há como usar o get_sidra() pelo numero de valores ser muito elevado.

#LAVOURAS TEMPORÁRIAS

#AREA PLANTADA

################################
#QUINZE PRIMEIROS ANOS - 2019 A 2007
a_plantada1 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/aplantada/aplantada1.csv", header=FALSE, comment.char="#")
#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
a_plantada1<- a_plantada1%>%
  filter(!V1 != c("2019","2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009",
                  "2010", "2009", "2008", "2007"))




#PERIODO SEGUINTE - 2006 A 1992
a_plantada2 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/aplantada/aplantada2.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
a_plantada2<- a_plantada2%>%
  filter(!V1 != c("2006",  "2005",  "2004","2003", "2002", "2001", "2000", "1999", "1998",
                  "1997","1996","1995","1994","1993","1992"))



#PERIODO SEGUINTE - 1991 A 1977
a_plantada3 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/aplantada/aplantada3.csv", header=FALSE, comment.char="#")
#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
a_plantada3<- a_plantada3%>%
  filter(!V1 != c("1991","1990","1989", "1988","1987","1986","1985", "1984", "1983", "1982", "1981", "1980", "1979", 
                  "1978", "1977" ))




#PERIODO FINAL - 1976, 1975, 1974
a_plantada4 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/aplantada/aplantada4.csv", header=FALSE, comment.char="#")
#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
a_plantada4<-a_plantada4%>%
  filter(!V1 != c("1976", "1975", "1974" ))

#JUNTANDO TODAS AS VARIÁVEIS EM UMA ÚNICA BASE E RETIRANDO A COLUNA QUE SÓ IDENTIFICAVA A VARIÁVEL E 
#DIFICULTARIA O MELT
a_plantada_final <- a_plantada1%>%
  add_row(a_plantada2)%>%
  add_row(a_plantada3)%>%
  add_row(a_plantada4)%>%
  select(-3)


#RENOMEANDO AS COLUNAS COM OS NOMES DOS PRODUTOS E COM AS VARIÁVEIS DE IDENTIFICAÇÃO
colnames(a_plantada_final)<- c("ano","id_municipio","Abacaxi", "Alho", "Alfafa fenada","Amendoim (em casca)",
                                  "Arroz (em casca)", "Aveia (em grão)", "Batata-doce", "Cana-de-açúcar",
                                  "Cana para forragem", "Cebola", "Centeio (em grão)",
                                  "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                                  "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                                  "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                                  "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                                  "Sorgo (em grão)",
                                  "Tomate", "Trigo (em grão)", "Triticale (em grão)")

#CONDENSANDO TODOS OS VALORES DE PRODUTO EM DUAS COLUNAS: QUE IDENTIFICA O PRODUTO E QUE DA O VALOR DO MESMO
a_plantada_final<- melt(a_plantada_final, id.vars = c("id_municipio","ano"), 
                        measure.vars = c("Abacaxi", "Alho", "Alfafa fenada","Amendoim (em casca)",
                                         "Arroz (em casca)", "Aveia (em grão)", "Batata-doce", "Cana-de-açúcar",
                                         "Cana para forragem", "Cebola", "Centeio (em grão)",
                                         "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                                         "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                                         "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                                         "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                                         "Sorgo (em grão)",
                                         "Tomate", "Trigo (em grão)", "Triticale (em grão)"))%>%
  rename(area_plantada = value, produto = variable)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#PERCENTUAL DA AREA PLANTADA 

#QUINZE PRIMEIROS ANOS - 2019 A 2007
perca_plantada1 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/percaplantada/p1.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perca_plantada1<- perca_plantada1%>%
  filter(!V1 != c("2019","2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009",
                  "2010", "2009", "2008", "2007"))




#PERIODO SEGUINTE - 2006 A 1992
perca_plantada2 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/percaplantada/p2.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perca_plantada2<-perca_plantada2%>%
  filter(!V1 != c("2006",  "2005",  "2004","2003", "2002", "2001", "2000", "1999", "1998",
                  "1997","1996","1995","1994","1993","1992"))



#PERIODO SEGUINTE - 1991 A 1977
perca_plantada3 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/percaplantada/p3.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perca_plantada3<- perca_plantada3%>%
  filter(!V1 != c("1991","1990","1989", "1988","1987","1986","1985", "1984", "1983", "1982", "1981", "1980", "1979", 
                  "1978", "1977" ))




#PERÍODO FINAL - 1976 A 1974
perca_plantada4 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/percaplantada/p4.csv", header=FALSE, comment.char="#")
#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perca_plantada4<- perca_plantada4%>%
  filter(!V1 != c("1976", "1975", "1974" ))


#JUNTANDO TODAS AS VARIÁVEIS EM UMA ÚNICA BASE E RETIRANDO A COLUNA QUE SÓ IDENTIFICAVA A VARIÁVEL E 
#DIFICULTARIA O MELT
perca_plantada_final <- perca_plantada1%>%
  add_row(perca_plantada2)%>%
  add_row(perca_plantada3)%>%
  add_row(perca_plantada4)%>%
  select(-3)

#RENOMEANDO AS COLUNAS COM NOMES DOS PRODUTOS E NOME DAS COLUNAS IDENTIFICADORAS
colnames(perca_plantada_final)<- c("ano","id_municipio","Abacaxi", "Alho", "Alfafa fenada","Amendoim (em casca)",
                                  "Arroz (em casca)", "Aveia (em grão)", "Batata-doce", "Cana-de-açúcar",
                                  "Cana para forragem", "Cebola", "Centeio (em grão)",
                                  "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                                  "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                                  "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                                  "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                                  "Sorgo (em grão)",
                                  "Tomate", "Trigo (em grão)", "Triticale (em grão)")

#CONDENSANDO TODAS AS COLUNAS DE PRODUTO EM UMA COLUNA QUE O IDENTIFIQUE E OUTRA QUE DE O VALOR DA VARIAVEL
perca_plantada_final<- melt(perca_plantada_final, id.vars = c("ano","id_municipio"), 
                        measure.vars = c("Abacaxi", "Alho", "Alfafa fenada","Amendoim (em casca)",
                                         "Arroz (em casca)", "Aveia (em grão)", "Batata-doce", "Cana-de-açúcar",
                                         "Cana para forragem", "Cebola", "Centeio (em grão)",
                                         "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                                         "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                                         "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                                         "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                                         "Sorgo (em grão)",
                                         "Tomate", "Trigo (em grão)", "Triticale (em grão)"))%>%
  rename(perc_area_plantada = value, produto = variable)


#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#AREA COLHIDA

#QUINZE PRIMEIROS ANOS - 2019 A 2007
a_colhida1 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/acolhida/c1.csv", header=FALSE, comment.char="#")

#TIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
a_colhida1<- a_colhida1%>%
  filter(!V1 != c("2019","2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009",
                  "2010", "2009", "2008", "2007" ))



#PERIODO SEGUINTE - 2006 A 1992
a_colhida2 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/acolhida/c2.csv", header=FALSE, comment.char="#")

#TIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
a_colhida2<-a_colhida2%>%
  filter(!V1 != c( "2006",  "2005",  "2004","2003", "2002", "2001", "2000", "1999", "1998",
                  "1997","1996","1995","1994","1993","1992"))



#PERIODO SEGUINTE - 1991 A 1977
a_colhida3 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/acolhida/c3.csv", header=FALSE, comment.char="#")

#TIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
a_colhida3<- a_colhida3%>%
  filter(!V1 != c("1991","1990","1989", "1988","1987","1986","1985", "1984", "1983", "1982", "1981", 
                  "1980", "1979", "1978", "1977"))


#PERIODO FINAL - 1976 A 1974
a_colhida4 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/acolhida/c4.csv", header=FALSE, comment.char="#")

#TIRANDO VALORES QUE NÃO SÃ0 OBSERVAÇÕES DO CSV
a_colhida4<- a_colhida4%>%
  filter(!V1 != c("1976", "1975", "1974" ))


#JUNTANDO TODAS AS VARIÁVEIS EM UMA ÚNICA BASE E RETIRANDO A COLUNA QUE SÓ IDENTIFICAVA A VARIÁVEL E 
#DIFICULTARIA O MELT
a_colhida_final <- a_colhida1%>%
  add_row(a_colhida2)%>%
  add_row(a_colhida3)%>%
  add_row(a_colhida4)%>%
  select(-3)

#RENOMEANDO AS COLUNAS COM OS NOMES DOS PRODUTOS E COM OS NOMES DAS VARIÁVEIS IDENTIFICADORAS
colnames(a_colhida_final) <- c("ano", "id_municipio", "Abacaxi", "Alho", "Alfafa fenada","Amendoim (em casca)",
                                  "Arroz (em casca)", "Aveia (em grão)", "Batata-doce", "Cana-de-açúcar",
                                  "Cana para forragem", "Cebola", "Centeio (em grão)",
                                  "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                                  "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                                  "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                                  "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                                  "Sorgo (em grão)",
                                  "Tomate", "Trigo (em grão)", "Triticale (em grão)")

#CONDENSANDO TODOS OS PRODUTOS EM DUAS COLUNAS: UMA QUE IDENTIFIQUE O PRODUTO E OUTRA QUE INFORME O VALOR DO MESMO
a_colhida_final<- melt(a_colhida_final, id.vars = c("ano", "id_municipio"), 
                        measure.vars = c("Abacaxi", "Alho", "Alfafa fenada","Amendoim (em casca)",
                                         "Arroz (em casca)", "Aveia (em grão)", "Batata-doce", "Cana-de-açúcar",
                                         "Cana para forragem", "Cebola", "Centeio (em grão)",
                                         "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                                         "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                                         "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                                         "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                                         "Sorgo (em grão)",
                                         "Tomate", "Trigo (em grão)", "Triticale (em grão)"))%>%
  rename(a_colhida = value, produto = variable)


#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# PERC AREA COLHIDA


#QUINZE PRIMEIROS ANOS - 2019 A 2007
perca_colhida1 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/percacolhida/q1.csv", header=FALSE, comment.char="#")
#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perca_colhida1<- perca_colhida1%>%
  filter(!V1 != c("2019","2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009",
                  "2010", "2009", "2008", "2007"))




#PERIODO SEGUINTE - 2006 A 1992
perca_colhida2 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/percacolhida/q2.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perca_colhida2<-perca_colhida2%>%
  filter(!V1 != c("2006",  "2005",  "2004","2003", "2002", "2001", "2000", "1999", "1998",
                  "1997","1996","1995","1994","1993","1992"))



#PERIODO SEGUINTE - 1991 A 1977
perca_colhida3 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/percacolhida/q3.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perca_colhida3<- perca_colhida3%>%
  filter(!V1 != c("1991","1990","1989", "1988","1987","1986","1985", "1984", 
                  "1983", "1982", "1981", "1980", "1979", "1978", "1977" ))



#PERIODO FINAL - 1976 A 1974
perca_colhida4 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/percacolhida/q4.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perca_colhida4<- perca_colhida4%>%
  filter(!V1 != c("1976", "1975", "1974" ))


#JUNTANDO TODAS AS VARIÁVEIS EM UMA ÚNICA BASE E RETIRANDO A COLUNA QUE SÓ IDENTIFICAVA A VARIÁVEL E 
#DIFICULTARIA O MELT
perca_colhida_final <- perca_colhida1%>%
  add_row(perca_colhida2)%>%
  add_row(perca_colhida3)%>%
  add_row(perca_colhida4)%>%
  select(-3)

#RENOMEANDO AS COLUNAS COM OS NOMES DOS PRODUTOS E COM OS NOMES DAS VARIÁVEIS IDENTIFICADORAS
colnames(perca_colhida_final)<- c("ano", "id_municipio","Abacaxi", "Alho", "Alfafa fenada","Amendoim (em casca)",
                                  "Arroz (em casca)", "Aveia (em grão)", "Batata-doce", "Cana-de-açúcar",
                                  "Cana para forragem", "Cebola", "Centeio (em grão)",
                                  "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                                  "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                                  "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                                  "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                                  "Sorgo (em grão)",
                                  "Tomate", "Trigo (em grão)", "Triticale (em grão)")

#CONDENSANDO TODOS OS PRODUTOS EM DUAS COLUNAS: UMA QUE IDENTIFIQUE O PRODUTO E OUTRA QUE INFORME O VALOR DO MESMO
perca_colhida_final<- melt(perca_colhida_final, id.vars = c("ano", "id_municipio"), 
                        measure.vars = c("Abacaxi", "Alho", "Alfafa fenada","Amendoim (em casca)",
                                         "Arroz (em casca)", "Aveia (em grão)", "Batata-doce", "Cana-de-açúcar",
                                         "Cana para forragem", "Cebola", "Centeio (em grão)",
                                         "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                                         "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                                         "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                                         "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                                         "Sorgo (em grão)",
                                         "Tomate", "Trigo (em grão)", "Triticale (em grão)"))%>%
  rename(perca_colhida = value, produto = variable)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#QUANTIDADE PRODUZIDA


#QUINZE PRIMEIROS ANOS - 2019 A 2007
qtd_produzida1 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/qtd/t1.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
qtd_produzida1<- qtd_produzida1%>%
  filter(!V1 != c("2019","2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009",
                  "2010", "2009", "2008", "2007"))



#PERIODO SEGUINTE - 2006 A 1992
qtd_produzida2 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/qtd/t2.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
qtd_produzida2<-qtd_produzida2%>%
  filter(!V1 != c("2006",  "2005",  "2004","2003", "2002", "2001", "2000", "1999", "1998",
                  "1997","1996","1995","1994","1993","1992"))



#PERIODO SEGUINTE - 1991 A 1977
qtd_produzida3 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/qtd/t3.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
qtd_produzida3<- qtd_produzida3%>%
  filter(!V1 != c("1991","1990","1989", "1988","1987","1986","1985", "1984", 
                  "1983", "1982", "1981", "1980", "1979", "1978", "1977"))



#PERIODO FINAL - 1976 A 1974
qtd_produzida4 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/qtd/t4.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
qtd_produzida4<- qtd_produzida4%>%
  filter(!V1 != c("1976", "1975", "1974" ))


#JUNTANDO TODAS AS VARIÁVEIS EM UMA ÚNICA BASE E RETIRANDO A COLUNA QUE SÓ IDENTIFICAVA A VARIÁVEL E 
#DIFICULTARIA O MELT
qtd_produzida_final <- qtd_produzida1%>%
  add_row(qtd_produzida2)%>%
  add_row(qtd_produzida3)%>%
  add_row(qtd_produzida4)%>%
  select(-3)

#RENOMEANDO AS COLUNAS COM OS NOMES DOS PRODUTOS E COM OS NOMES DAS VARIÁVEIS IDENTIFICADORAS
colnames(qtd_produzida_final)<- c("ano", "id_municipio", "Abacaxi", "Alho", "Alfafa fenada","Amendoim (em casca)",
                                  "Arroz (em casca)", "Aveia (em grão)", "Batata-doce", "Cana-de-açúcar",
                                  "Cana para forragem", "Cebola", "Centeio (em grão)",
                                  "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                                  "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                                  "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                                  "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                                  "Sorgo (em grão)",
                                  "Tomate", "Trigo (em grão)", "Triticale (em grão)")

#CONDENSANDO TODOS OS PRODUTOS EM DUAS COLUNAS: UMA QUE IDENTIFIQUE O PRODUTO E OUTRA QUE INFORME O VALOR DO MESMO
qtd_produzida_final<- melt(qtd_produzida_final, id.vars = c("ano", "id_municipio"), 
                        measure.vars = c("Abacaxi", "Alho", "Alfafa fenada","Amendoim (em casca)",
                                         "Arroz (em casca)", "Aveia (em grão)", "Batata-doce", "Cana-de-açúcar",
                                         "Cana para forragem", "Cebola", "Centeio (em grão)",
                                         "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                                         "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                                         "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                                         "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                                         "Sorgo (em grão)",
                                         "Tomate", "Trigo (em grão)", "Triticale (em grão)"))%>%
  rename(qtd_produzida = value, produto = variable)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#RENDIMENTO MÉDIO DA PRODUÇÃO

#QUINZE PRIMEIROS ANOS - 2019 A 2007
rend_medio1 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/rend/r1.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
rend_medio1<- rend_medio1%>%
  filter(!V1 != c("2019","2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009",
                  "2010", "2009", "2008", "2007"))




#PERIODO SEGUINTE - 2006 a 1992
rend_medio2 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/rend/r2.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
rend_medio2<-rend_medio2%>%
  filter(!V1 != c("2006", "2005", "2004", "2003", "2002", "2001", "2000", "1999", "1998",
                  "1997","1996","1995","1994","1993","1992"))


#PERIODO SEGUINTE - 1991 a 1977
rend_medio3 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/rend/r3.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
rend_medio3<-rend_medio3%>%
  filter(!V1 != c("1991","1990","1989", "1988","1987","1986","1985", "1984", "1983", "1982", 
                  "1981", "1980", "1979", "1978", "1977" ))



#PERIODO FINAL - 1976 A 1974
rend_medio4 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/rend/r4.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
rend_medio4<- rend_medio4%>%
  filter(!V1 != c("1976", "1975", "1974" ))


#JUNTANDO TODAS OS PERÍODOS EM UMA ÚNICA BASE
rend_medio_final <- rend_medio1%>%
  add_row(rend_medio2)%>%
  add_row(rend_medio3)%>%
  add_row(rend_medio4)%>%
  select(-3)

#RENOMEANDO AS COLUNAS COM OS NOMES DOS PRODUTOS E COM OS NOMES DAS VARIÁVEIS IDENTIFICADORAS
colnames(rend_medio_final)<- c("ano", "id_municipio", "Abacaxi", "Alho", "Alfafa fenada","Amendoim (em casca)",
                                  "Arroz (em casca)", "Aveia (em grão)", "Batata-doce", "Cana-de-açúcar",
                                  "Cana para forragem", "Cebola", "Centeio (em grão)",
                                  "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                                  "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                                  "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                                  "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                                  "Sorgo (em grão)",
                                  "Tomate", "Trigo (em grão)", "Triticale (em grão)")

#CONDENSANDO TODOS OS PRODUTOS EM DUAS COLUNAS: UMA QUE IDENTIFIQUE O PRODUTO E OUTRA QUE INFORME O VALOR DO MESMO
rend_medio_final<- melt(rend_medio_final, id.vars = c("ano", "id_municipio"), 
                        measure.vars = c("Abacaxi", "Alho", "Alfafa fenada","Amendoim (em casca)",
                                         "Arroz (em casca)", "Aveia (em grão)", "Batata-doce", "Cana-de-açúcar",
                                         "Cana para forragem", "Cebola", "Centeio (em grão)",
                                         "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                                         "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                                         "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                                         "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                                         "Sorgo (em grão)",
                                         "Tomate", "Trigo (em grão)", "Triticale (em grão)"))%>%
  rename(rend_medio = value, produto = variable)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$
#VALOR DA PRODUÇÃO

#QUINZE PRIMEIROS ANOS - 2019 A 2007
valor_prod1 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/valorprod/v1.csv", header=FALSE, comment.char="#")
#TIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
valor_prod1 <- valor_prod1%>%
  filter(!V1 != c("2019","2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009",
                  "2010", "2009", "2008", "2007"))


#PERIODO SEGUINTE - 2006 A 1992
valor_prod2 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/valorprod/v2.csv", header=FALSE, comment.char="#")
#TIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
valor_prod2<-valor_prod2%>%
  filter(!V1 != c( "2006",  "2005",  "2004", "2003", "2002", "2001", "2000", "1999", "1998",
                  "1997","1996","1995","1994","1993","1992"))

#PERIODO SEGUINTE - 1991 A 1977
valor_prod3 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/valorprod/v3.csv", header=FALSE, comment.char="#")

valor_prod3<-valor_prod3%>%
  filter(!V1 != c("1991","1990","1989", "1988","1987","1986","1985", 
                  "1984", "1983", "1982", "1981", "1980", "1979", "1978", "1977" ))

#PERIODO FINAL - 1976 A 1974
valor_prod4 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/valorprod/v4.csv", header=FALSE, comment.char="#")

valor_prod4<- valor_prod4%>%
  filter(!V1 != c("1976", "1975", "1974" ))

#JUNTANDO TODOS OS PERÍODOS EM UMA ÚNICA BASE
valor_prod_final <- valor_prod1%>%
  add_row(valor_prod2)%>%
  add_row(valor_prod3)%>%
  add_row(valor_prod4)%>%
  select(-3)

#RENOMEANDO AS COLUNAS COM OS NOMES DOS PRODUTOS E COM OS NOMES DAS VARIÁVEIS IDENTIFICADORAS
colnames(valor_prod_final)<- c("ano", "id_municipio", "Abacaxi", "Alho", "Alfafa fenada","Amendoim (em casca)",
                                 "Arroz (em casca)", "Aveia (em grão)", "Batata-doce", "Cana-de-açúcar",
                                 "Cana para forragem", "Cebola", "Centeio (em grão)",
                                 "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                                 "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                                 "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                                 "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                                 "Sorgo (em grão)",
                                 "Tomate", "Trigo (em grão)", "Triticale (em grão)")

#CONDENSANDO TODOS OS PRODUTOS EM DUAS COLUNAS: UMA QUE IDENTIFIQUE O PRODUTO E OUTRA QUE INFORME O VALOR DO MESMO
valor_prod_final<- melt(valor_prod_final, id.vars = c("ano", "id_municipio"), 
                        measure.vars = c("Abacaxi", "Alho", "Alfafa fenada","Amendoim (em casca)",
                                         "Arroz (em casca)", "Aveia (em grão)", "Batata-doce", "Cana-de-açúcar",
                                         "Cana para forragem", "Cebola", "Centeio (em grão)",
                                         "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                                         "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                                         "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                                         "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                                         "Sorgo (em grão)",
                                         "Tomate", "Trigo (em grão)", "Triticale (em grão)"))%>%
  rename(valor_prod = value, produto = variable)

#$$$$$$$$$$$$$$$$$
#PORCENTAGEM DO VALOR DA PRODUÇÃO

#QUINZE PRIMEIROS ANOS - 2019 A 2007
perc_valor_prod1 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/percvalorprod/w1.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perc_valor_prod1 <- perc_valor_prod1%>%
  filter(!V1 != c("2019","2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009",
                  "2010", "2009", "2008", "2007"))




#PERIODO SEGUINTE - 2006 A 1992
perc_valor_prod2 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/percvalorprod/w2.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perc_valor_prod2<-perc_valor_prod2%>%
  filter(!V1 != c( "2006",  "2005",  "2004","2003", "2002", "2001", "2000", "1999", "1998",
                  "1997","1996","1995","1994","1993","1992"))



#PERIODO SEGUINTE - 1991 A 1977
perc_valor_prod3 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/percvalorprod/w3.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perc_valor_prod3<-perc_valor_prod3%>%
  filter(!V1 != c("1991","1990","1989", "1988","1987","1986","1985", "1984", "1983", "1982", "1981", "1980", "1979", "1978", "1977" ))



#PERIODO FINAL - 1976 A 1974
perc_valor_prod4 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro/percvalorprod/w4.csv", header=FALSE, comment.char="#")
#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perc_valor_prod4<- perc_valor_prod4%>%
  filter(!V1 != c("1976", "1975", "1974" ))



#JUNTANDO TODOS OS PERÍODOS EM UMA MESMA BASE
perc_valor_prod_final <- perc_valor_prod1%>%
  add_row(perc_valor_prod2)%>%
  add_row(perc_valor_prod3)%>%
  add_row(perc_valor_prod4)%>%
  select(-3)

#RENOMEANDO AS COLUNAS COM OS NOMES DOS PRODUTOS E COM OS NOMES DAS VARIÁVEIS IDENTIFICADORAS
colnames(perc_valor_prod_final)<- c("ano", "id_municipio", "Abacaxi", "Alho", "Alfafa fenada","Amendoim (em casca)",
                                 "Arroz (em casca)", "Aveia (em grão)", "Batata-doce", "Cana-de-açúcar",
                                 "Cana para forragem", "Cebola", "Centeio (em grão)",
                                 "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                                 "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                                 "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                                 "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                                 "Sorgo (em grão)",
                                 "Tomate", "Trigo (em grão)", "Triticale (em grão)")

#CONDENSANDO TODOS OS PRODUTOS EM DUAS COLUNAS: UMA QUE IDENTIFIQUE O PRODUTO E OUTRA QUE INFORME O VALOR DO MESMO
perc_valor_prod_final<- melt(perc_valor_prod_final, id.vars = c("ano", "id_municipio"), 
                        measure.vars = c("Abacaxi", "Alho", "Alfafa fenada","Amendoim (em casca)",
                                         "Arroz (em casca)", "Aveia (em grão)", "Batata-doce", "Cana-de-açúcar",
                                         "Cana para forragem", "Cebola", "Centeio (em grão)",
                                         "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                                         "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                                         "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                                         "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                                         "Sorgo (em grão)",
                                         "Tomate", "Trigo (em grão)", "Triticale (em grão)"))%>%
  rename(perc_valor_prod = value, produto = variable)








#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#AGLOMERANDO TODAS AS BASES
  agricola_temporaria_final<-a_plantada_final%>%
  inner_join(perca_plantada_final, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(a_colhida_final, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(perca_colhida_final, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(qtd_produzida_final, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(rend_medio_final, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(valor_prod_final, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(perc_valor_prod_final, by = c('ano', 'id_municipio', 'produto'))%>%
#CRIANDO SIGLA DA UF E REORDENANDO AS COLUNAS    
  mutate(sigla_uf = str_sub(id_municipio,1,2))%>%
  relocate(id_municipio, sigla_uf)%>%
#CRIANDO VARIÁVEL PARA IDENTIFICAR A MOEDA DE UM DADO ANO
    mutate(moeda_do_valor_da_prod = case_when(
      ano == "1974"| ano =="1975"| ano =="1976"| ano =="1977"| ano =="1978"| ano =="1979"| 
        ano =="1980"| ano =="1981"|ano =="1982"| ano =="1983"| 
        ano =="1984"|  ano =="1985" | ano == "1990"| ano == "1991" |ano == "1992" ~ "Mil Cruzeiros",
      ano == "1986"| ano == "1987"| ano == "1988" ~ "Mil Cruzados", 
      ano == "1989" ~ "Mil Cruzados Novos",
      ano == "1993" ~ "Mil Cruzeiros Reais",
      ano == "1994" | ano == "1995" | ano == "1996" | ano == "1997" | ano == "1998" |
        ano =="1999" | ano == "2000" | ano == "2001" | ano =="2002" | ano =="2003" |
        ano =="2004" | ano == "2005" | ano =="2006" | ano == "2007" | ano =="2008" | 
        ano == "2009" | ano =="2010" | ano == "2011" | ano == "2012" | ano =="2013" | ano =="2014"|
        ano == "2015" | ano =="2016" | ano == "2017" | ano =="2018" | ano =="2019" ~ "Mil Reais"
    ) )
  
  #SUBSTITUINDO "-" E "..." POR NA
  agricola_temporaria_final[agricola_temporaria_final== "-"] <- ""
  agricola_temporaria_final[agricola_temporaria_final== "..."] <- ""


#ESCREVENDO CSV DAS TEMPORARIAS
  
write.csv(agricola_temporaria_final ,"C:/Users/Matheus/Desktop/bdmais/agro2/temporaria_final.csv", 
           row.names = FALSE)











