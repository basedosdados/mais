# Biblioteca
library(tidyverse)
library(rio)
library(DBI)
library(bigrquery)
library(reshape2)

# diretorio
setwd("~/Documentos/bdmais")

vetor_anos <- c("a2011", "a2012", "a2013", "a2014", "a2015", "a2016", "a2017")

# funcao geral para resolver os anos at? 2017
faztudo <- function(file,nivel){
  read.csv2(file = file, 
          header = T, 
          sep = ",")%>%
  as_tibble()%>%
  set_names("diretoria", vetor_anos)%>%
  pivot_longer(cols = vetor_anos,
               names_to = "ano",
               values_to = "nota_idesp")%>%
  mutate(ano = str_sub(ano, 2,5),
         nivel_ensino = nivel,
         nota_idesp = as.numeric(nota_idesp),
         ano = as.numeric(ano))
}

# base ate 2017
base_ate_2017<-faztudo("bases_cruas/seduc/idesp-diretoria/IDESP_Diretorias_2011_2017 - EF Anos Iniciais_0.csv", "EF ANOS INICIAIS")%>%
  bind_rows(faztudo("bases_cruas/seduc/idesp-diretoria/IDESP_Diretorias_2011_2017 - EF Anos Finais_0.csv", "EF ANOS FINAIS"))%>%
  bind_rows(faztudo("bases_cruas/seduc/idesp-diretoria/IDESP_Diretorias_2011_2017 - EM.csv", "ENSINO MEDIO"))

# base 2018 e 2019

base2018 <- read.csv2( file = "bases_cruas/seduc/idesp-diretoria/IDESP_Diretoria_2018.csv", 
                       header = T, 
                       sep = ";")%>%
  set_names("ano", "codigo_diretoria", "diretoria", "EF ANOS INICIAIS", "EF ANOS FINAIS", 
            "ENSINO MEDIO")%>%
  pivot_longer(cols = c("EF ANOS INICIAIS", "EF ANOS FINAIS", "ENSINO MEDIO"),
               names_to = "nivel_ensino",
               values_to = "nota_idesp")%>%
  mutate(nota_idesp = as.numeric(nota_idesp),
    nota_idesp = round(nota_idesp, digits = 4))


base2019 <- read.csv2( file = "bases_cruas/seduc/idesp-diretoria/IDESP_Diretoria_2019.csv", 
                       header = T, 
                       sep = ",")%>%
  set_names("ano", "codigo_diretoria", "diretoria", "EF ANOS INICIAIS", "EF ANOS FINAIS", 
            "ENSINO MEDIO")%>%
  pivot_longer(cols = c("EF ANOS INICIAIS", "EF ANOS FINAIS", "ENSINO MEDIO"),
               names_to = "nivel_ensino",
               values_to = "nota_idesp")%>%
  mutate(nota_idesp = as.numeric(nota_idesp),
         nota_idesp = round(nota_idesp, digits = 4))
#juntando em uma base só
basefinal <- base_ate_2017%>%
  bind_rows(base2018)%>%
  bind_rows(base2019)

#exportando

rio::export(basefinal, "bases_prontas/idesp-diretoria.csv")






