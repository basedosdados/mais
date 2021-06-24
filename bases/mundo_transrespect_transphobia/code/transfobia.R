#transphobia

#biblio
library(tabulizer)
library(tidyverse)

#link:

#opening document: countries-----------------------------

paises <- tabulizer::extract_tables("TvT_TMM_TDoR2018_Tables_EN.pdf")


#general use function---------------------
organize_table<- function(index){
  data.frame(paises[index]) %>% 
    slice(-1) %>% 
    set_names(c("pais_ingles", 2008:2018, "total")) %>% 
    select(-total) %>% 
    pivot_longer(cols = "2008":"2018",
                 names_to = "ano",
                 values_to = "homicidios")
}

#countries table
paises_tabela <- map(1:10, organize_table) %>% 
   reduce(bind_rows) %>% 
  select(ano,pais_ingles,homicidios) %>% 
  filter(!pais_ingles == "",
         !pais_ingles == "America")

#exporting countries table

write_csv(paises_tabela, "transfobia-pais.csv")


#for using the flourish graphics
paises_tabela %>% 
  pivot_wider(id_cols = c("ano", "pais_ingles"),
              names_from = "pais_ingles",
              values_from = "homicidios") %>% 
  write_csv("transfobia-pais-flourish.csv")


paises_tabela %>% 
  arrange(desc(homicidios))
#other tables --------------------------------------------------
#occupations table -------
data.frame(paises[11]) %>% 
  bind_rows(data.frame(paises[12])) %>% 
  slice(-1:-2) %>% 
  set_names(c('ocupacao', 2008:2018, 'total')) %>% 
  select(-total) %>% 
  pivot_longer(cols = "2008":"2018",
               names_to = "ano",
               values_to = "homicidios")

#causa mortis table ----------
data.frame(paises[13]) %>% 
  slice(-1:-2) %>% 
  set_names(c('causa_obito', 2008:2018, 'total')) %>% 
  select(-total) %>% 
  pivot_longer(cols = "2008":"2018",
               names_to = "ano",
               values_to = "homicidios") %>% 
  filter(causa_obito != "Asphyxiated/smoke",
         causa_obito!= "Decapitated/dismem") %>% 
  mutate(causa_obito = 
           case_when(causa_obito == 'bered' ~"Decapitated/dismembered",
                     causa_obito == "inhalation/suffocated" ~ "Asphyxiated/smoke inhalation/suffocated",
                     TRUE ~ causa_obito)
  ) %>% 
  filter(causa_obito != "") %>% 
  write_csv("transfobia-causamortis.csv")

#location table ------------------
data.frame(paises[14]) %>% 
  bind_rows(data.frame(paises[15])) %>% 
  slice(-1:-2) %>% 
  set_names(c('local', 2008:2018, 'total')) %>% 
  select(-total) %>% 
  pivot_longer(cols = "2008":"2018",
               names_to = "ano",
               values_to = "homicidios") %>% 
  filter(homicidios != "") %>% 
  mutate(local = case_when(local =="under bridge" ~ "Beach/shore/river/under bridge",
                   local == "grassland/rural" ~ "Brushwood/field/grassland/rural area/grove/forest",
                   local == "square/space/" ~ "Park/public square/space/market",
                   local == "lot/abandoned" ~ "Construction site/empty lot/abandoned building",
                   local == "nightclub" ~ "Bar/restaurant/nightclub",
                   local == "beauty salon" ~ "Hairdresser’s shop/beauty salon",
                   local == "metro station" ~ "Railroad/station/metro station/railway tracks",
                   local == "clientâ€™s apartment/" ~ "Relative’s/friend’s/client’s apartment/family house",
                   TRUE ~ local)) %>% 
  filter(local != "") %>% 
  write_csv("transfobia-local.csv")



