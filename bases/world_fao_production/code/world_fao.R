#######################################
######script_r_world_fao_production####
#######################################

rm(list = ls())
options(scipen = 999)
library(FAOSTAT)
library(tidyverse)
library(RSelenium)
library(netstat)

#1. donwload data
data_folder <- "C:/Users/gabri/OneDrive/vida_profissional/Projetos/base_dos_dados/world_fao/Template Dados_production/input"
crop_livestock <- get_faostat_bulk('QCL', data_folder)
production_indices <- get_faostat_bulk('QI', data_folder)
value_agricultural_production <- get_faostat_bulk('QV', data_folder)

#2. wrang
#2.1 rename cols and drop cols
rename_drop_cols <- function(dataset){
  #this function takes a datafrane as input,
  #rename and drop cols according to the architecture table,
  #and gives the given dataframe as output.
  dataset <-  dataset %>%
    dplyr::select(fao_area_id  = area_code,
           fao_area = area,
           item_id = item_code,
           item,
           element_id = element_code,
           element,
           year,
           unit_id = unit,
           value,
           flag_id = flag)
  return(dataset)
}

crop_livestock <- rename_drop_cols(crop_livestock)
production_indices <- rename_drop_cols(production_indices)
value_agricultural_production <- rename_drop_cols(value_agricultural_production)

#2.2 donwload description tables
#set donwload folder
file_path <- getwd() %>%
  stringrr::str_replace_all("/", "\\\\\\")

eCaps <- list(
  chromeOptions =
    list(prefs = list(
      "profile.default_content_settings.popups" = 0L,
      "download.prompt_for_download" = FALSE,
      "download.default_directory" = file_path
    )
    )
)

chrome_version <- '108.0.5359.71'
#setar driver
driver <- rsDriver(
  browser = 'chrome',
  chromever = chrome_version,
  verbose = F,
  port = free_port(),
  extraCapabilities = eCaps)


#criar var driver
driver <- driver$client
#abrir driver
driver$open()
#carregar pg com tabelas do sicor bacen
driver$navigate("https://www.fao.org/faostat/en/#definitions")
Sys.sleep(14)
numbers <- c(2,3,4,5,6,7,9)

url_list_qv_qcl <- c('https://www.fao.org/faostat/en/#data/QCL','https://www.fao.org/faostat/en/#data/QV')
url_list_qi <- c('https://www.fao.org/faostat/en/#data/QI')


download_descriptions_qcl_qv <- function(url){
  #this function takes an url as input and
  #description datasets as output
  driver <- rsDriver(
    browser = 'chrome',
    chromever = chrome_version,
    verbose = F,
    port = free_port(),
    extraCapabilities = eCaps)

  #criar var driver
  driver <- driver$client
  #abrir driver
  driver$open()

  driver$navigate(url)
  Sys.sleep(14)
  #this fuction takes an url as input and
  #description datasets as output
  description_table <- driver$findElement(using = ('xpath'),
                                          value = paste0('//*[@id="main-container"]/div/div[4]/div[2]/div/div[2]/div[3]/a[1]'))

  description_table$clickElement()
  Sys.sleep(13)

  nums <- c(1,2,3,4,5,8,10)

  for(num in nums){
    description_table <- driver$findElement(using = ('xpath'),
                                            value = paste0('//*[@id="fs-modal"]/div/div/div[2]/div/div[1]/div/div/div/ul/li[',num,']/a'))

    description_table$clickElement()
    Sys.sleep(13)

    description_table <- driver$findElement(using = ('xpath'),
                                            value = '//*[@id="fs-modal"]/div/div/div[2]/div/div[2]/div/div/div/div/div/div[2]/div/div[1]/div[1]/div[1]/div/a')

    description_table$clickElement()
    Sys.sleep(13)
  }
  driver$quit()
}
download_descriptions_qi <- function(url){
  #this function takes an url as input and
  #description datasets as output
  driver <- rsDriver(
    browser = 'chrome',
    chromever = chrome_version,
    verbose = F,
    port = free_port(),
    extraCapabilities = eCaps)

  #criar var driver
  driver <- driver$client
  #abrir driver
  driver$open()

  driver$navigate(url)
  Sys.sleep(14)

  description_table <- driver$findElement(using = ('xpath'),
                                          value = paste0('//*[@id="main-container"]/div/div[4]/div[2]/div/div[2]/div[3]/a[1]'))

  description_table$clickElement()
  Sys.sleep(13)

  nums <- c(1,2,3,4,5,8,9)

  for(num in nums){
    description_table <- driver$findElement(using = ('xpath'),
                                            value = paste0('//*[@id="fs-modal"]/div/div/div[2]/div/div[1]/div/div/div/ul/li[',num,']/a'))

    description_table$clickElement()
    Sys.sleep(13)

    description_table <- driver$findElement(using = ('xpath'),
                                            value = '//*[@id="fs-modal"]/div/div/div[2]/div/div[2]/div/div/div/div/div/div[2]/div/div[1]/div[1]/div[1]/div/a')

    description_table$clickElement()
    Sys.sleep(13)
  }
  driver$quit()
}

for(url in url_list_qv_qcl){
  download_descriptions_qcl_qv(url = url)
}
for(url in url_list_qi){
  download_descriptions_qi(url = url)
}

#3. read description files
#path <- 'C:/Users/gabri/OneDrive/vida_profissional/Projetos/base_dos_dados/world_fao/Template Dados_production/input'
files <- list.files(path = getwd(),
                    pattern = '.csv',
                    full.names = T)

description_files <- lapply(files, function(x){
         read_csv(x)
       })
#3.1 build unit and flags dictionaries

#the country file will be left over, since all the country ids are present in
#the main datasets (crop_livestock, value_agricultural_production, production_indices)
#as well as in the country_group dataset

country <- bind_rows(description_files[[21]],
                     description_files[[6]],
                     description_files[[18]])

#so adicionar o end year
country_group <- bind_rows(description_files[[1]],
                           description_files[[7]],
                           description_files[[19]])  %>%
  select(fao_area_group_id = `Country Group Code`,
         fao_area_group = `Country Group`,
         fao_area_id  = `Country Code`,
         fao_area = Country)

#a same element name has different ids according to its unit.
#I'll then opt to leave it here in this dataset.
element <- bind_rows(description_files[[8]],
                           description_files[[12]],
                           description_files[[20]]) %>%
  select(element_id = `Element Code`,
         element = Element,
         element_description = Description,
         unit_id = Unit) %>%
  distinct(element_id, .keep_all = T)

#perhaps it makes sense just to maintain them all... cause all tibbles
#sono gia dei direttori
item <- bind_rows(description_files[[2]],
                  description_files[[9]],
                               description_files[[14]]) %>%
  select(item_id = `Item Code`,
         item = Item,
         item_description = Description,
         hs07_id = `HS07 Code`,
         hs12_id = `HS12 Code`,
         cpc_id = `CPC Code`)


#when binding item_groups there was a combine error of doubles and chars,
#the given function solves it mutating all cols to chars.
mutate_to_character <- function(x){
  x %>%
    mutate(across(everything(), as.character))
}
description_files <- sapply(description_files, mutate_to_character)
item_group <- bind_rows(description_files[[3]],
                        description_files[[10]],
                        description_files[[15]]) %>%
      select(item_group_id = `Item Group Code`,
             item_group = `Item Group`,
             item_id = `Item Code`,
             item = Item)

#dicionary
#the problem of lineage
flag <- bind_rows(description_files[[4]],
                  description_files[[11]],
                  description_files[[16]]) %>%
  select(flag_id = Flag,
         flag = Flags)

find_lineage <- function(x, lineage_name){
  #creates a column of the dataset name to identify unique values
  #of flags and units
  unique(x$flag_id) %>% as_tibble() %>%
    mutate(dataset_id =  lineage_name)

}

flag1 <- find_lineage(crop_livestock, lineage_name = 'crop_livestock')
flag2 <- find_lineage(production_indices,  'production_indices')
flag3 <- find_lineage(value_agricultural_production,  'value_agricultural_production')

flag_temp <- bind_rows(flag1, flag2, flag3)
rm(flag1, flag2, flag3)

flag <- flag %>%
  left_join(flag_temp,
             by = c('flag_id' = 'value')) %>%
  distinct(.keep_all = T) %>%
  mutate(table_id = dataset_id,
         column_name = 'flag_id',
         key = flag_id,
         temporal_coverage = '(1)',
         value = flag) %>%
  select(table_id, column_name, key,temporal_coverage,value)
rm(flag_temp)


find_lineage <- function(x, lineage_name){
  #creates a column of the dataset name to identify unique values
  #of flags and units
  unique(x$unit_id) %>% as_tibble() %>%
    mutate(dataset_id =  lineage_name)

}
unit <- bind_rows(description_files[[5]],
                  description_files[[13]],
                  description_files[[17]]) %>%
      select(unit_id  = `Unit Name`,
             unit = Description)

unit1 <- find_lineage(x = crop_livestock, lineage_name = 'crop_livestock')
unit2 <- find_lineage(production_indices, 'production_indices')
unit3 <- find_lineage(value_agricultural_production, 'value_agricultural_production')

unit_temp <- bind_rows(unit1, unit2, unit3)
rm(unit1, unit2, unit3)

unit <- unit %>%
  mutate(unit_id = as.character(unit_id)) %>%
  left_join(unit_temp,
            by = c('unit_id' = 'value')) %>%
  distinct(.keep_all = T) %>%
  na.omit() %>%
  mutate(table_id = dataset_id,
         column_name = 'unit_id',
         key = unit_id,
         temporal_coverage = '(1)',
         value = unit) %>%
  select(table_id, column_name, key,temporal_coverage,value)
rm(unit_temp)

#build dictionary
dictionary <- bind_rows(unit,flag)
rm(unit, flag)

#save data with partitions
for(year in unique(crop_livestock$year)){

  ano <- year

  dir.create(paste0("C:/Users/gabri/OneDrive/vida_profissional/Projetos/base_dos_dados/world_fao/Template Dados_production/output/crop_livestock/ano=",year),
             showWarnings = FALSE,
             recursive = T)

  crop_livestockt <- crop_livestock %>%
    filter(year == ano) %>%
    select(everything(),-year)

    write.csv(crop_livestockt,
              paste0("C:/Users/gabri/OneDrive/vida_profissional/Projetos/base_dos_dados/world_fao/Template Dados_production/output/crop_livestock/ano=",year,"/crop_livestock.csv"),
            na = '',
            row.names = F,
            fileEncoding = "UTF-8")
    print(paste0('dir','_',ano,'_','criado'))
}
for(year in unique(production_indices$year)){

  ano <- year

  dir.create(paste0("C:/Users/gabri/OneDrive/vida_profissional/Projetos/base_dos_dados/world_fao/Template Dados_production/output/production_indices/ano=",year),
             showWarnings = FALSE,
             recursive = T)

  production_indicest <- production_indices %>%
    filter(year == ano) %>%
    select(everything(),-year)

  write.csv(production_indicest,
            paste0("C:/Users/gabri/OneDrive/vida_profissional/Projetos/base_dos_dados/world_fao/Template Dados_production/output/production_indices/ano=",year,"/production_indices.csv"),
            na = '',
            row.names = F,
            fileEncoding = "UTF-8")
  print(paste0('dir','_',ano,'_','criado'))
}
for(year in unique(value_agricultural_production$year)){

  ano <- year

  dir.create(paste0("C:/Users/gabri/OneDrive/vida_profissional/Projetos/base_dos_dados/world_fao/Template Dados_production/output/value_agricultural_production/ano=",year),
             showWarnings = FALSE,
             recursive = T)

  value_agricultural_productiont <- value_agricultural_production %>%
    filter(year == ano) %>%
    select(everything(),-year)

  write.csv(value_agricultural_productiont,
            paste0("C:/Users/gabri/OneDrive/vida_profissional/Projetos/base_dos_dados/world_fao/Template Dados_production/output/value_agricultural_production/ano=",year,"/value_agricultural_production.csv"),
            na = '',
            row.names = F,
            fileEncoding = "UTF-8")
  print(paste0('dir','_',ano,'_','criado'))
}


#save dictionary
write.csv(dictionary,
          'C:/Users/gabri/OneDrive/vida_profissional/Projetos/base_dos_dados/world_fao/Template Dados_production/output/dictionary.csv',
            na = '',
            row.names = F,
            fileEncoding = "UTF-8")

#save descriptions
write.csv(country_group,
          'C:/Users/gabri/OneDrive/vida_profissional/Projetos/base_dos_dados/world_fao/Template Dados_production/output/country_group.csv',
          na = '',
          row.names = F,
          fileEncoding = "UTF-8")


write.csv(element,
          'C:/Users/gabri/OneDrive/vida_profissional/Projetos/base_dos_dados/world_fao/Template Dados_production/output/element.csv',
          na = '',
          row.names = F,
          fileEncoding = "UTF-8")

write.csv(item_group,
          'C:/Users/gabri/OneDrive/vida_profissional/Projetos/base_dos_dados/world_fao/Template Dados_production/output/item_group.csv',
          na = '',
          row.names = F,
          fileEncoding = "UTF-8")

write.csv(item,
          'C:/Users/gabri/OneDrive/vida_profissional/Projetos/base_dos_dados/world_fao/Template Dados_production/output/item.csv',
          na = '',
          row.names = F,
          fileEncoding = "UTF-8")


