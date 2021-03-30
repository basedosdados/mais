# Biblioteca
library(tidyverse)
library(rio)
library(DBI)
library(bigrquery)
library(reshape2)
library(data.table)

# diretorio
setwd("~/Documentos/bdmais")

vetor_anos <- c("a2011", "a2012", "a2013", "a2014", "a2015", "a2016", "a2017")

# funcao geral para resolver os anos at? 2017
faztudo <- function(file,nivel){
  fread(file = file, 
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

# base 2018 e 2019

base2018 <- fread( file = "bases_cruas/seduc/idesp-diretoria/IDESP_Diretoria_2018.csv", 
                       header = T, 
                       sep = ";")%>%
  set_names("ano", "codigo_diretoria", "diretoria", "EF ANOS INICIAIS", "EF ANOS FINAIS", 
            "ENSINO MEDIO")%>%
  pivot_longer(cols = c("EF ANOS INICIAIS", "EF ANOS FINAIS", "ENSINO MEDIO"),
               names_to = "nivel_ensino",
               values_to = "nota_idesp")%>%
  mutate(nota_idesp = as.numeric(nota_idesp),
    nota_idesp = round(nota_idesp, digits = 4))


base2019 <- fread( file = "bases_cruas/seduc/idesp-diretoria/IDESP_Diretoria_2019.csv", 
                       header = T, 
                       sep = ",")%>%
  set_names("ano", "codigo_diretoria", "diretoria", "EF ANOS INICIAIS", "EF ANOS FINAIS", 
            "ENSINO MEDIO")%>%
  pivot_longer(cols = c("EF ANOS INICIAIS", "EF ANOS FINAIS", "ENSINO MEDIO"),
               names_to = "nivel_ensino",
               values_to = "nota_idesp")%>%
  mutate(nota_idesp = as.numeric(nota_idesp),
         nota_idesp = round(nota_idesp, digits = 4))


# criando uma tabela de apoio para ids de diretorias

base_apoio<- base2019%>%
  group_by(codigo_diretoria, diretoria)%>%
  summarise()

# base ate 2017
base_ate_2017<-faztudo("bases_cruas/seduc/idesp-diretoria/IDESP_Diretorias_2011_2017 - EF Anos Iniciais_0.csv", "EF ANOS INICIAIS")%>%
  bind_rows(faztudo("bases_cruas/seduc/idesp-diretoria/IDESP_Diretorias_2011_2017 - EF Anos Finais_0.csv", "EF ANOS FINAIS"))%>%
  bind_rows(faztudo("bases_cruas/seduc/idesp-diretoria/IDESP_Diretorias_2011_2017 - EM.csv", "ENSINO MEDIO"))%>%
  left_join(base_apoio, by = 'diretoria')






#juntando em uma base só
basefinal <- base_ate_2017%>%
  bind_rows(base2018)%>%
  bind_rows(base2019)%>%
  mutate(nivel_ensino = case_when(nivel_ensino == "EF ANOS INICIAIS" ~ "ef_iniciais",
                                  nivel_ensino == "EF ANOS FINAIS" ~ "ef_finais",
                                  nivel_ensino == "ENSINO MEDIO" ~ "em"))%>%
  pivot_wider(id_cols = c(diretoria, ano, codigo_diretoria),
              names_from = nivel_ensino,
              values_from = nota_idesp)%>%
  rename(id_diretoria = codigo_diretoria, nota_idesp_ef_iniciais = ef_iniciais ,
          nota_idesp_ef_finais = ef_finais , nota_idesp_em = em)

#exportando

rio::export(basefinal, "bases_prontas/idesp-diretoria.csv")






