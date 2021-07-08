#pride month -- (all born superstars, etc)
library(tidyverse)
library(rio)
library(glue)

#We picked up data from many different sources so that our datalake was filled with info
#about the LGBTQI+ community and the issues around us

#1) Fundamental Rights Agency online survey
#https://fra.europa.eu/sites/default/files/eu-lgbt-survey-technical-report_en.pdf
#fonte: https://www.kaggle.com/ruslankl/european-union-lgbt-survey-2012

#vetor

arquivos <- c("LGBT_Survey_Discrimination.csv",
              "LGBT_Survey_TransgenderSpecificQuestions.csv",
              "LGBT_Survey_ViolenceAndHarassment.csv",
              "LGBT_Survey_DailyLife.csv",
              "LGBT_Survey_RightsAwareness.csv")


clean_data <- function(arquivo){
  import(glue("bases_cruas/lgbt/fra/{arquivo}")) %>% 
  select(-notes) %>% 
  set_names("id_pais", "grupo", "id_pergunta", "pergunta", "resposta", "porcentagem") %>% 
  write_csv(glue("bases_prontas/lgbt/fra/{str_sub(arquivo,start=13)}"))
}
  
walk(arquivos, clean_data)


