#SCRIPT PARA AS LAVOURAS PERMANENTES

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
library(assertive)

#Todo produto tem 8 variaveis e 43 anos para nivel municipal
#Fonte:https://sidra.ibge.gov.br/tabela/1612#
#As bases foram baixadas usando csv (us)  
#o Sidra só permite pegar de em torno de doze em doze anos pela restrição de tamanho
#Para bases tão grandes não há como usar o get_sidra() pelo numero de valores ser muito elevado.




#CULTURAS PERMANENTES




#AREA DEDICADA A COLHEITA

#QUINZE PRIMEIROS ANOS - 2019 A 2007
a_dedcolheita1 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/dedcol/dedcol1.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES
a_dedcolheita1<- a_dedcolheita1%>%
  filter(!V2 != c("2019","2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009",
                  "2010", "2009", "2008", "2007"))



#PERIODO SEGUINTE - 2006 A 1994 
a_dedcolheita2 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/dedcol/dedcol2.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES
a_dedcolheita2<- a_dedcolheita2%>%
  filter(!V2 != c("2006",  "2005",  "2004","2003", "2002", "2001", "2000", "1999", "1998",
                  "1997","1996","1995","1994"))



#PERIODO SEGUINTE - 1993 A 1981
a_dedcolheita3 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/dedcol/dedcol3.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES
a_dedcolheita3<- a_dedcolheita3%>%
  filter(!V2 != c("1993","1992","1991","1990","1989", "1988","1987","1986","1985", "1984", "1983", "1982", "1981" ))




#PERIODO FINAL - 1980 A 1974
a_dedcolheita4 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/dedcol/dedcol4.csv", header=FALSE, comment.char="#")

a_dedcolheita4<-a_dedcolheita4%>%
  filter(!V2 != c("1980","1979", "1978", "1977","1976", "1975", "1974" ))


#JUNTANDO TODOS OS ANOS EM UMA ÚNICA BASE
a_dedcolheitaf <- a_dedcolheita1%>%
  add_row(a_dedcolheita2)%>%
  add_row(a_dedcolheita3)%>%
  add_row(a_dedcolheita4)


#RENOMEANDO AS COLUNAS COM O NOME DE DAS VARIAVEIS DE IDENTIFICACAO E COM OS NOMES DOS PRODUTOS
colnames(a_dedcolheitaf)<- c("id_municipio","ano","Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                               "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                               "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                               "Caju", "Caqui", "Castanha de caju", "Chá-da-índia (folha verde)",
                               "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                               "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                               "Maçã", "Mamão", "Mangua", "Maracujá",
                               "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                               "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                                "Uva")

#CONDENSANDO AS VARIAS COLUNAS EM UMA SÓ VARIÁVEL QUE IDENTIFIQUE DE QUAL PRODUTO SE TRATA
a_dedcolheitaf<- melt(a_dedcolheitaf, id.vars = c("id_municipio","ano"), 
                        measure.vars = c("Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                                         "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                                         "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                                         "Caju", "Caqui", "Castanha de caju", "Chá-da-índia (folha verde)",
                                         "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                                         "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                                         "Maçã", "Mamão", "Mangua", "Maracujá",
                                         "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                                         "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                                         "Uva"))%>%
  rename(area_ded_colheita = value, produto = variable)




#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#PERCENTUAL DA AREA DEDICADA A COLHEITA

#QUINZE PRIMEIROS ANOS - 2019 A 2007
perca_dedcolheita1 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/percdedcol/percdedcol1.csv", header=FALSE, comment.char="#")
#TIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perca_dedcolheita1<- perca_dedcolheita1%>%
  filter(!V2 != c("2019","2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009",
                  "2010", "2009", "2008", "2007"))


#PERIODO SEGUINTE - 2006 A 1994
perca_dedcolheita2 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/percdedcol/percdedcol2.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES
perca_dedcolheita2<-perca_dedcolheita2%>%
  filter(!V2 != c("2006",  "2005",  "2004","2003", "2002", "2001", "2000", "1999", "1998",
                  "1997","1996","1995","1994"))



#PERIODO SEGUINTE - 1993 A 1981
perca_dedcolheita3 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/percdedcol/percdedcol3.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES
perca_dedcolheita3<- perca_dedcolheita3%>%
  filter(!V2 != c("1993","1992", "1991","1990","1989", "1988","1987","1986","1985", "1984", "1983", "1982", "1981"))




#PERÍODO FINAL - 1980 A 1974
perca_dedcolheita4 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/percdedcol/percdedcol4.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES
perca_dedcolheita4<- perca_dedcolheita4%>%
  filter(!V2 != c( "1980", "1979", 
                   "1978", "1977","1976", "1975", "1974" ))


#JUNTANDO TODOS OS PERÍODOS DESTA VARIÁVEL EM UMA ÚNICA BASE
perca_dedcolheita_final <- perca_dedcolheita1%>%
  add_row(perca_dedcolheita2)%>%
  add_row(perca_dedcolheita3)%>%
  add_row(perca_dedcolheita4)

#RENOMEANDO AS COLUNAS COM NOMES DAS VARIAVEIS DE IDENTIFICACAO E COM O NOME DOS PRODUTOS
colnames(perca_dedcolheita_final)<- c("id_municipio","ano","Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                                      "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                                      "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                                      "Caju", "Caqui", "Castanha de caju", "Chá-da-índia (folha verde)",
                                      "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                                      "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                                      "Maçã", "Mamão", "Mangua", "Maracujá",
                                      "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                                      "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                                      "Uva")


#CONDENSANDO AS VARIAS VARIÁVEIS DE PRODUTOS EM UMA ÚNICA QUE IDENTIFIQUE QUAL PRODUTO É QUAL
perca_dedcolheita_final<- melt(perca_dedcolheita_final, id.vars = c("ano","id_municipio"), 
                            measure.vars = c("Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                                             "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                                             "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                                             "Caju", "Caqui", "Castanha de caju", "Chá-da-índia (folha verde)",
                                             "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                                             "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                                             "Maçã", "Mamão", "Mangua", "Maracujá",
                                             "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                                             "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                                             "Uva"))%>%
  rename(perc_a_dedcolheita = value, produto = variable)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


#AREA COLHIDA

#QUINZE PRIMEIROS ANOS - 2019 A 2007
a_colhida1 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/acolhida/c1.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES
a_colhida1<- a_colhida1%>%
  filter(!V2 != c("2019","2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009",
                  "2010", "2009", "2008", "2007" ))


#PERIODO SEGUINTE - 2006 A 1994
a_colhida2 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/acolhida/c2.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕESa_colhida2<-a_colhida2%>%
  filter(!V2 != c( "2006",  "2005",  "2004","2003", "2002", "2001", "2000", "1999", "1998",
                   "1997","1996","1995","1994"))



#PERIODO SEGUINTE - 1993 A 1981
a_colhida3 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/acolhida/c3.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES
a_colhida3<- a_colhida3%>%
  filter(!V2 != c("1993","1992","1991","1990","1989", "1988","1987","1986","1985", "1984", "1983", "1982", "1981"))




#PERIODO FINAL - 1980 A 1974
a_colhida4 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/acolhida/c4.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES
a_colhida4<- a_colhida4%>%
  filter(!V2 != c("1980", "1979", "1978", "1977","1976", "1975", "1974" ))


#JUNTANDO TODOS OS PERIODOS PARA ESSA VARIÁVEL
a_colhida_final <- a_colhida1%>%
  add_row(a_colhida2)%>%
  add_row(a_colhida3)%>%
  add_row(a_colhida4)

#RENOMEANDO AS COLUNAS COM OS NOMES DOS PRODUTOS E RENOMEANDO AS VARIAVEIS DE IDENTIFICACAO
colnames(a_colhida_final) <- c("id_municipio","ano","Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                               "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                               "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                               "Caju", "Caqui", "Castanha de caju", "Chá-da-índia (folha verde)",
                               "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                               "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                               "Maçã", "Mamão", "Mangua", "Maracujá",
                               "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                               "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                               "Uva")

#CONDENSANDO AS COLUNAS DE CADA PRODUTO EM UMA UNICA COLUNA QUE IDENTIFIQUE O PRODUTO
a_colhida_final<- melt(a_colhida_final, id.vars = c("ano","id_municipio"), 
                       measure.vars = c("Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                                        "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                                        "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                                        "Caju", "Caqui", "Castanha de caju", "Chá-da-índia (folha verde)",
                                        "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                                        "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                                        "Maçã", "Mamão", "Mangua", "Maracujá",
                                        "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                                        "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                                        "Uva"))%>%
  rename(a_colhida = value, produto = variable)


#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# PERC AREA COLHIDA


#DOZE PRIMEIROS ANOS - 2019 A 2007
perca_colhida1 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/percacolhida/q1.csv", header=FALSE, comment.char="#")
#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perca_colhida1<- perca_colhida1%>%
  filter(!V2 != c("2019","2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009",
                  "2010", "2009", "2008", "2007"))



#PERIODO SEGUINTE - 2006 A 1994
perca_colhida2 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/percacolhida/q2.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perca_colhida2<-perca_colhida2%>%
  filter(!V2 != c("2006",  "2005",  "2004","2003", "2002", "2001", "2000", "1999", "1998",
                    "1997","1996","1995","1994"))



#PERIODO SEGUINTE - 1993 A 1981
perca_colhida3 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/percacolhida/q3.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perca_colhida3<- perca_colhida3%>%
  filter(!V2 != c("1993","1992","1991","1990","1989", "1988","1987","1986","1985", "1984", 
                  "1983", "1982", "1981"))




#PERIODO FINAL - 1980 A 1974
perca_colhida4 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/percacolhida/q4.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perca_colhida4<- perca_colhida4%>%
  filter(!V2 != c("1980", "1979", "1978", "1977", "1976", "1975", "1974" ))



#JUNTANDO TODOS OS PERIODOS DA VARIAVEL 
perca_colhida_final <- perca_colhida1%>%
  add_row(perca_colhida2)%>%
  add_row(perca_colhida3)%>%
  add_row(perca_colhida4)

#RENOMEANDO AS COLUNAS COM NOMES DOS PRODUTOS E NOME DAS VARIÁVEIS DE IDENTIFICAÇÃO
colnames(perca_colhida_final)<- c("id_municipio","ano","Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                                  "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                                  "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                                  "Caju", "Caqui", "Castanha de caju", "Chá-da-índia (folha verde)",
                                  "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                                  "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                                  "Maçã", "Mamão", "Mangua", "Maracujá",
                                  "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                                  "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                                  "Uva")

#CONDENSANDO AS DIFERENTES COLUNAS EM UMA ÚNICA QUE IDENTIFICA O NOME DO PRODUTO
perca_colhida_final<- melt(perca_colhida_final, id.vars = c("ano","id_municipio"), 
                           measure.vars = c("Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                                            "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                                            "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                                            "Caju", "Caqui", "Castanha de caju", "Chá-da-índia (folha verde)",
                                            "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                                            "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                                            "Maçã", "Mamão", "Mangua", "Maracujá",
                                            "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                                            "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                                            "Uva"))%>%
  rename(perca_colhida = value, produto = variable)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#QUANTIDADE PRODUZIDA


#QUINZE PRIMEIROS ANOS - 2019 A 2007
qtd_produzida1 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/qtd/t1.csv", header=FALSE, comment.char="#")
#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
qtd_produzida1<- qtd_produzida1%>%
  filter(!V2 != c("2019","2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009",
                  "2010", "2009", "2008", "2007"))


#PERIODO SEGUINTE - 2006 A 1994
qtd_produzida2 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/qtd/t2.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
qtd_produzida2<-qtd_produzida2%>%
  filter(!V2 != c("2006",  "2005",  "2004","2003", "2002", "2001", "2000", "1999", "1998",
                  "1997","1996","1995","1994"))



#PERIODO SEGUINTE - 1993 A 1981
qtd_produzida3 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/qtd/t3.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
qtd_produzida3<- qtd_produzida3%>%
  filter(!V2 != c("1993","1992", "1991","1990","1989", "1988","1987","1986","1985", "1984", 
                  "1983", "1982", "1981" ))



#PERIODO FINAL - 1980 A 1974
qtd_produzida4 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/qtd/t4.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
qtd_produzida4<- qtd_produzida4%>%
  filter(!V2 != c("1980", "1979", "1978", "1977", "1976", "1975", "1974" ))



#JUNTANDO OS DIFERENTES PERÍODOS
qtd_produzida_final <- qtd_produzida1%>%
  add_row(qtd_produzida2)%>%
  add_row(qtd_produzida3)%>%
  add_row(qtd_produzida4)

#RENOMEANDO AS COLUNAS COM IDENTIFICAÇÃO E DOS NOMES DOS PRODUTOS
colnames(qtd_produzida_final)<- c("id_municipio","ano","Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                                  "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                                  "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                                  "Caju", "Caqui", "Castanha de caju", "Chá-da-índia (folha verde)",
                                  "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                                  "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                                  "Maçã", "Mamão", "Mangua", "Maracujá",
                                  "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                                  "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                                  "Uva")

#CONDENSANDO OS PRODUTOS EM UMA ÚNICA VARIÁVEL QUE OS IDENTIFIQUE
qtd_produzida_final<- melt(qtd_produzida_final, id.vars = c("ano","id_municipio"), 
                           measure.vars = c("Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                                            "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                                            "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                                            "Caju", "Caqui", "Castanha de caju", "Chá-da-índia (folha verde)",
                                            "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                                            "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                                            "Maçã", "Mamão", "Mangua", "Maracujá",
                                            "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                                            "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                                            "Uva"))%>%
  rename(qtd_produzida = value, produto = variable)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#RENDIMENTO MÉDIO DA PRODUÇÃO

#QUINZE PRIMEIROS ANOS - 2019 A 2007
rend_medio1 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/rend/r1.csv", header=FALSE, comment.char="#")
#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
rend_medio1<- rend_medio1%>%
  filter(!V2 != c("2019","2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009",
                  "2010", "2009", "2008", "2007"))




#PERIODO SEGUINTE - 2006 a 1994
rend_medio2 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/rend/r2.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
rend_medio2<-rend_medio2%>%
  filter(!V2 != c("2006", "2005", "2004", "2003", "2002", "2001", "2000", "1999", "1998",
                  "1997","1996","1995","1994"))




#PERIODO SEGUINTE - 1993 a 1981
rend_medio3 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/rend/r3.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
rend_medio3<-rend_medio3%>%
  filter(!V2 != c("1993","1992", "1991","1990","1989", "1988","1987","1986","1985", "1984", "1983", "1982", 
                  "1981" ))




#PERIODO FINAL - 1980 A 1974
rend_medio4 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/rend/r4.csv", header=FALSE, comment.char="#")
#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
rend_medio4<- rend_medio4%>%
  filter(!V2 != c("1980", "1979", "1978", "1977","1976", "1975", "1974" ))


#JUNTANDO OS DIFERENTES PERÍODOS
rend_medio_final <- rend_medio1%>%
  add_row(rend_medio2)%>%
  add_row(rend_medio3)%>%
  add_row(rend_medio4)

#RENOMEANDO COLUNAS COM NOMES DOS PRODUTOS E COM AS VARIÁVEIS IDENTIFICADORAS
colnames(rend_medio_final)<- c("id_municipio","ano","Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                               "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                               "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                               "Caju", "Caqui", "Castanha de caju", "Chá-da-índia (folha verde)",
                               "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                               "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                               "Maçã", "Mamão", "Mangua", "Maracujá",
                               "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                               "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                               "Uva")

#CONDENSANDO TODAS AS VARIÁVEIS DE PRODUTOS EM UMA ÚNICA QUE IDENTIFICA OS PRODUTOS
rend_medio_final<- melt(rend_medio_final, id.vars = c("ano","id_municipio"), 
                        measure.vars = c("Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                                         "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                                         "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                                         "Caju", "Caqui", "Castanha de caju", "Chá-da-índia (folha verde)",
                                         "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                                         "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                                         "Maçã", "Mamão", "Mangua", "Maracujá",
                                         "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                                         "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                                         "Uva"))%>%
  rename(rend_medio = value, produto = variable)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$
#VALOR DA PRODUÇÃO

#QUINZE PRIMEIROS ANOS - 2019 A 2007
valor_prod1 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/valorprod/v1.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
valor_prod1 <- valor_prod1%>%
  filter(!V2 != c("2019","2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009",
                  "2010", "2009", "2008", "2007"))




#PERIODO SEGUINTE - 2006 A 1994
valor_prod2 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/valorprod/v2.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
valor_prod2<-valor_prod2%>%
  filter(!V2 != c( "2006",  "2005",  "2004", "2003", "2002", "2001", "2000", "1999", "1998",
                   "1997","1996","1995","1994"))



#PERIODO SEGUINTE - 1993 A 1981
valor_prod3 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/valorprod/v3.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
valor_prod3<-valor_prod3%>%
  filter(!V2 != c("1993","1992", "1991","1990","1989", "1988","1987","1986","1985", 
                  "1984", "1983", "1982", "1981"))



#PERIODO FINAL - 1980 A 1974
valor_prod4 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/valorprod/v4.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
valor_prod4<- valor_prod4%>%
  filter(!V2 != c("1980", "1979", "1978", "1977", "1976", "1975", "1974"))




#JUNTANDO TODOS OS PERÍODOS EM UMA ÚNICA BASE
valor_prod_final <- valor_prod1%>%
  add_row(valor_prod2)%>%
  add_row(valor_prod3)%>%
  add_row(valor_prod4)

#RENOMEANDO AS COLUNAS COM VARIÁVEIS DE INDETIFICAÇÃO E NOME DOS PRODUTOS
colnames(valor_prod_final)<- c("id_municipio","ano","Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                               "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                               "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                               "Caju", "Caqui", "Castanha de caju", "Chá-da-índia (folha verde)",
                               "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                               "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                               "Maçã", "Mamão", "Mangua", "Maracujá",
                               "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                               "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                               "Uva")

#CONDENSANDO AS VARIÁVEIS DOS PRODUTOS EM UMA ÚNICA VARIÁVEL QUE IDENTIFIQUE O PRODUTO
valor_prod_final<- melt(valor_prod_final, id.vars = c("ano","id_municipio"), 
                        measure.vars = c("Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                                         "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                                         "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                                         "Caju", "Caqui", "Castanha de caju", "Chá-da-índia (folha verde)",
                                         "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                                         "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                                         "Maçã", "Mamão", "Mangua", "Maracujá",
                                         "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                                         "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                                         "Uva"))%>%
  rename(valor_prod = value, produto = variable)

#$$$$$$$$$$$$$$$$$
#PORCENTAGEM DO VALOR DA PRODUÇÃO

#QUINZE PRIMEIROS ANOS - 2019 A 2007
perc_valor_prod1 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/percvalorprod/w1.csv", header=FALSE, comment.char="#")
#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perc_valor_prod1 <- perc_valor_prod1%>%
  filter(!V2 != c("2019","2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009",
                  "2010", "2009", "2008", "2007"))




#PERIODO SEGUINTE - 2006 A 1994
perc_valor_prod2 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/percvalorprod/w2.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perc_valor_prod2<-perc_valor_prod2%>%
  filter(!V2 != c( "2006",  "2005",  "2004","2003", "2002", "2001", "2000", "1999", "1998",
                   "1997","1996","1995","1994"))




#PERIODO SEGUINTE - 1993 A 1981
perc_valor_prod3 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/percvalorprod/w3.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perc_valor_prod3<-perc_valor_prod3%>%
  filter(!V2 != c("1993","1992","1991","1990","1989", "1988","1987","1986","1985", "1984", "1983", "1982", "1981"))



#PERIODO FINAL - 1980 A 1974
perc_valor_prod4 <- read.csv("C:/Users/Matheus/Desktop/bdmais/agro2/percvalorprod/w4.csv", header=FALSE, comment.char="#")

#RETIRANDO VALORES QUE NÃO SÃO OBSERVAÇÕES DO CSV
perc_valor_prod4<- perc_valor_prod4%>%
  filter(!V2 != c("1980", "1979", "1978", "1977","1976", "1975", "1974" ))



#JUNTANDO TODOS OS PERÍODOS EM UMA ÚNICA BASE
perc_valor_prod_final <- perc_valor_prod1%>%
  add_row(perc_valor_prod2)%>%
  add_row(perc_valor_prod3)%>%
  add_row(perc_valor_prod4)

#RENOMEANDO AS COLUNAS COM NOME DAS VARIÁVEIS IDENTIFICADORAS E COM OS NOMES DOS PRODUTOS
colnames(perc_valor_prod_final)<- c("id_municipio","ano","Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                                    "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                                    "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                                    "Caju", "Caqui", "Castanha de caju", "Chá-da-índia (folha verde)",
                                    "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                                    "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                                    "Maçã", "Mamão", "Mangua", "Maracujá",
                                    "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                                    "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                                    "Uva")

#CRIANDO UMA VARIÁVEL PARA IDENTIFICAR O PRODUTO
perc_valor_prod_final<- melt(perc_valor_prod_final, id.vars = c("ano","id_municipio"), 
                             measure.vars = c("Abacate", "Algodão arbóreo (em caroço)", "Açaí","Azeitona",
                                              "Banana (cacho)", "Borracha (látex coagulado)", "Borracha (látex líquido)", "Cacau (em amêndoa)",
                                              "Café (em grão) Total", "Café (em grão) Arábica", "Café (em grão) Canephora",
                                              "Caju", "Caqui", "Castanha de caju", "Chá-da-índia (folha verde)",
                                              "Coco-da-baía", "Dendê (cacho de coco)", "Erva-mate (folha verde)", "Figo",
                                              "Goiaba", "Guaraná (semente)", "Laranja", "Limão",
                                              "Maçã", "Mamão", "Mangua", "Maracujá",
                                              "Marmelo", "Noz (fruto seco)", "Palmito", "Pera", "Pêssego", "Pimenta-do-reino",
                                              "Sisal ou agave (fibra)", "Tangerina", "Tungue (fruto seco)", "Urucum (semente)",
                                              "Uva"))%>%
  rename(perc_valor_prod = value, produto = variable)








#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#AGLOMERANDO TODAS AS BASES
agricola_permanente_final<-a_dedcolheitaf%>%
  inner_join(perca_dedcolheita_final, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(a_colhida_final, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(perca_colhida_final, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(qtd_produzida_final, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(rend_medio_final, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(valor_prod_final, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(perc_valor_prod_final, by = c('ano', 'id_municipio', 'produto'))%>%
  #CRIANDO SIGLA_UF E REORDENANDO AS COLUNAS
  mutate(sigla_uf = str_sub(id_municipio,1,2))%>%
  relocate(id_municipio, sigla_uf)%>%
#CRIANDO UMA VARIÁVEL PARA IDENTIFICAR A MOEDA DE DADO ANO
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
agricola_permanente_final[agricola_permanente_final== "-"] <- ""
agricola_permanente_final[agricola_permanente_final== "..."] <- ""


#ESCREVENDO CSV FINAL DAS LAVOURAS PERMANENTES

write.csv(agricola_permanente_final,"C:/Users/Matheus/Desktop/bdmais/agro2/permanente_final.csv", 
           row.names = FALSE)





