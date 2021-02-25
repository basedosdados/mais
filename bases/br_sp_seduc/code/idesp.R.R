# Biblioteca
library(tidyverse)
library(rio)
library(reshape2)

# Abrindo a base
idesp_iniciais <- import("IDESP_Escolas_2007_2019_AI.csv", setclass = "tibble")
idesp_finais <- import("IDESP_Escolas_2007_2019_AF.csv", setclass= "tibble")
idesp_medio <-import("IDESP_Escolas_2007_2019_EM.csv", setclass = "tibble")

vetor_anos <- c("2007","2008","2009","2010","2011","2012","2013","2014",
                "2015","2016","2017","2018","2019")

# Função que muda o formato dos dados
organizadora<- function(x){
  x%>%
  set_names("id_escola_sp", "id_inep", "diretoria", "nom_escola", "municipio", "nivel_ensino",
            vetor_anos)%>%
  melt(id.vars = c("id_escola_sp", "id_inep", "diretoria", "nom_escola", "municipio", "nivel_ensino"),
       variable.names = "nota_idesp")%>%
  rename(ano = variable, nota_idesp = value)%>%
  filter(! nom_escola == "")
    
}

# Aplicando em anos iniciais e anos finais do ensino fundamental
idesp_ef<- organizadora(idesp_iniciais)%>%
        bind_rows(organizadora(idesp_finais))%>%
        mutate(nivel_ensino = ifelse(nivel_ensino == "ANOS INICIAIS", "EF ANOS INICIAIS", "EF ANOS FINAIS"))

idesp_long <-idesp_ef%>%
  bind_rows(organizadora(idesp_medio))


# Exportando os dados
export(idesp_long, "idesp_fundamental_medio.csv")
