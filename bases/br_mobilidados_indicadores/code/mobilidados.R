##### Limpar memoria e denifir diretorio #####

rm(list = ls())

setwd("~/basedosdados/tratamento/mobilidados/input")

##### Pacotes #####

library(xlsx)
library(tidyverse)
library(bigrquery)
library(beepr)

##### Funcoes #####

bd_clean = function(df, 
                    colms_drop = NULL, 
                    colms_order = NULL, 
                    rename_colms = NULL) 
{
        if (is.null(colms_drop)) 
                
        {df = df} 
        
        else{df[colms_drop] <- NULL }
        
        if(is.null(colms_order)) 
                
        {df = df} 
        
        else{ df <- df %>%
                select(colms_order) }
        
        if(is.null(rename_colms)) 
                
        {df = df} 
        
        else {names(df) <- rename_colms}
        
        df[df == "..."] <- NA
        df[df == "-"]   <- NA
        df[df == "X"]   <- NA
        
        return(df)
        
}

#------------------------------------------------------------------------------#
##### Comprometimento da renda com a tarifa de transporte publico (tp) #####
##### Tarifa nas capitais ####

tarifa_capitais = readxl::read_excel("1comprometimento_transporte_publico.xlsx",
                                     sheet = 2,
                                     skip = 2)

## Limpeza

tarifa_capitais = bd_clean(tarifa_capitais, 
                           colms_drop = c(1, 4, 5, 6, 20, 21),
                           rename_colms = c("sigla_uf", "id_municipio", "2005", 
                                            "2006", "2007", "2008", "2009", "2010", "2011", 
                                            "2012", "2013", "2014", "2015","2016", "2017"))
# inverter colunas

tarifa_capitais = gather(tarifa_capitais,
                         key = "ano", 
                         value = "tarifa_nas_capitais",
                         -id_municipio,
                         -sigla_uf)

##### Comprometimento do salario minimo ####

compr_salario = readxl::read_excel("1comprometimento_transporte_publico.xlsx",
                                   sheet = 4,
                                   skip = 2)

# Limpeza

compr_salario = bd_clean(compr_salario, 
                         colms_drop = c(1, 4, 5, 6, 20, 21, 22, 23),
                         rename_colms = c("sigla_uf", "id_municipio", "2005", 
                                          "2006", "2007", "2008", "2009", "2010", "2011",
                                          "2012", "2013", "2014", "2015", "2016", "2017"))
# inverter colunas

compr_salario = gather(compr_salario,
                       key = "ano", 
                       value = "comprometimento_salario_minimo",
                       -sigla_uf,
                       -id_municipio)


##### Comprometimento da renda para trabalhadoras domesticas negras ####

salario_domes_negras = readxl::read_excel("1comprometimento_transporte_publico.xlsx",
                                          sheet = 6,
                                          skip = 1)

# Limpeza

salario_domes_negras = bd_clean(salario_domes_negras,
                                colms_drop = c(1,2, 4, 5, 6, 7),
                                rename_colms = c("id_municipio", "2005", "2006", "2007", "2008", 
                                                 "2009", "2011", "2012", "2013", "2014", "2015"))
# inverter colunas

salario_domes_negras = gather(salario_domes_negras,
                              key = "ano", 
                              value = "comprometimento_renda_domesticas_negras",
                              -id_municipio)

##### Tabela 1 #####

tabela1 = tarifa_capitais

tabela1$comprotimento_salario_minimo = compr_salario$comprometimento_salario_minimo

tabela1 = full_join(salario_domes_negras, tabela1, by = c('id_municipio', 'ano'))

# modificar ordem das colunas

tabela1 = bd_clean(tabela1, colms_order = c(4,1,2,5,6,3))

write.csv(tabela1,
          "~/basedosdados/tratamento/mobilidados/output/compr_renda_tarifa_transp_publico.csv",
          na = " ",
          row.names = F)
#------------------------------------------------------------------------------#
##### Tempo de deslocamento casa-trabalho em minutos e percentual #####
##### Tempo medio de deslocamento casa-trabalho (municipios, ano 2010) ####

temp_medio_muni = readxl::read_excel("3.1_Tempo médio de deslocamento casa-trabalho.xlsx",
                                     sheet = 2)

# adicionar coluna "ano"

temp_medio_muni$ano = "2010"

## Limpeza

temp_medio_muni = bd_clean(temp_medio_muni,
                           colms_drop = c(1, 4, 5, 6),
                           rename_colms = c("sigla_uf", "id_municipio", 
                                            "tempo_medio_deslocamento", "ano"))

temp_medio_muni = bd_clean(temp_medio_muni, colms_order = c(1,2,4,3))

##### Percentual de pessoas que gastam mais de uma hora no deslocamento casa-trabalho ####

prop_des = readxl::read_excel("3.2_Percentual de pessoas que gastam mais de uma hora no deslocamento casa-trabalho.xlsx",
                              sheet = 2)

# adicionar coluna "ano"

prop_des$ano = '2010'

# Limpeza

prop_des = bd_clean(prop_des, 
                    colms_drop = c(1,4,5,6),
                    rename_colms = c("sigla_uf", "id_municipio",
                                     "prop_deslocamento", "ano"))

prop_des = bd_clean(prop_des,
                    colms_order = c(1,2,4,3))
## Proporcao 

prop_des$prop_deslocamento = prop_des$prop_deslocamento*100

##### Tabela 2 #####

tabela2 = temp_medio_muni

tabela2$prop_deslocamento_acima_1_hora = prop_des$prop_deslocamento

write.csv(tabela2,
          "~/basedosdados/tratamento/mobilidados/output/tempo_deslocamento_casa_trabalho.csv",
          na = " ",
          row.names = F)
#------------------------------------------------------------------------------#
##### Percentual de estacoes de transporte de media e alta capacidade na area de cobertura da infraestrutura cicloviaria #####

tma = readxl::read_excel("4_percentual_tma.xlsx",
                         sheet = 4, skip = 2)

# Limpeza

tma = bd_clean(tma, 
               colms_drop = c(1, 4, 5, 6, 7),
               rename_colms = c("sigla_uf", "id_municipio", "prop_tma"))

# adicionar a coluna e modificar proporcao

tma$ano = "2019"

# mudar ordem das colunas

tma = bd_clean(tma, 
               colms_order = c(1,2,4,3))

##### Tabela 3 ####

tabela3 = tma

write.csv(tabela3,
          "~/basedosdados/tratamento/mobilidados/output/transporte_media_alta_capacidade.csv",
          na = " ",
          row.names = F)
#------------------------------------------------------------------------------#
##### Divisao modal ####

modal = readxl::read_excel("5_divisao_modal.xlsx",
                           sheet = 2)

# Limpeza

modal= bd_clean(modal, 
                colms_drop = c(1,3,4, 5),
                rename_colms = c("sigla_uf", "1996", "1997", "2002","2003","2007", "2009", "2010", 
                                 "2012", "2017","2018"))

# inverter colunas

modal = gather(modal,
               key = "ano",
               value = "divisao_modal",
               -sigla_uf)

modal$divisao_modal = as.numeric(modal$divisao_modal)
modal$divisao_modal = modal$divisao_modal*100

##### Tabela 4  #####

tabela4 = modal

write.csv(tabela4,
          "~/basedosdados/tratamento/mobilidados/output/divisao_modal.csv",
          na = " ",
          row.names = F)

#------------------------------------------------------------------------------#
##### Percentual de domicilios que possuem infraestrutura urbana no seu entorno #####

prop_domi_infra = readxl::read_excel("6_percentual_de_domicilios.xlsx", 
                                     sheet = 2)
# Limpeza

prop_domi_infra = bd_clean(prop_domi_infra, 
                           colms_drop =  c(1,4,5,6),
                           rename_colms = c("sigla_uf", "id_municipio", "calcadas", "rampas"))

# adicionar coluna ano e mudar propocao

prop_domi_infra$ano = "2010"
prop_domi_infra$calcadas = prop_domi_infra$calcadas*100
prop_domi_infra$rampas = as.numeric(prop_domi_infra$rampas)
prop_domi_infra$rampas = prop_domi_infra$rampas*100

# mudar ordem das colunas

prop_domi_infra = bd_clean(prop_domi_infra, 
                           colms_order = c(1, 2, 5, 3, 4))

##### Tabela 5 #####

tabela5 = prop_domi_infra

write.csv(tabela5,
          "~/basedosdados/tratamento/mobilidados/output/prop_domicilios_infra_urbana.csv",
          na = " ",
          row.names = F)
#------------------------------------------------------------------------------#

##### Emissoes CO2 e material particulado (mp) por habitantes #####
##### Emissoes CO2 por habitante (Capitais) ####

co2_hab = readxl::read_excel("7_emissoes_co2.xlsx", 
                             sheet = 3,
                             skip = 2)

# Limpeza

co2_hab = bd_clean(co2_hab,
                   colms_drop = c(1,4, 17:58),
                   rename_colms = c("sigla_uf", "id_municipio", "2007", "2008", "2009", "2010", 
                                    "2011", "2012", "2013","2014", "2015", "2016", "2017", "2018"))

# inverter ordem das colunas

co2_hab = gather(co2_hab,
                 key = ano,
                 value = "emissao_co2_habitantes",
                 -sigla_uf,
                 -id_municipio)

##### Emissoes MP por habitante (Capitais) ####

mp_hab = readxl::read_excel("7_emissoes_co2.xlsx", 
                            sheet = 5,
                            skip = 2)
# Limpeza

mp_hab = bd_clean(mp_hab,
                  colms_drop =c(1, 4, 17:55),
                  rename_colms = c("sigla_uf", "id_municipio", "2007", "2008", "2009", "2010", 
                                   "2011", "2012", "2013","2014", "2015", "2016", "2017", "2018"))

# inverter ordem 

mp_hab = gather(mp_hab,
                key = ano,
                value = "emissoes_mp",
                -sigla_uf,
                -id_municipio)


##### Tabela 6 ##### 

tabela6 = co2_hab

tabela6$emissoes_mp = mp_hab$emissoes_mp

write.csv(tabela6,
          "~/basedosdados/tratamento/mobilidados/output/emissoes_CO2_material_particulado.csv",
          na = " ",
          row.names = F)

#------------------------------------------------------------------------------#
##### Percentual de pessoas próximas da rede de transporte de média e alta capacidade (PNT) ####

pnt_prop = readxl::read_excel("8_pnt.xlsx", sheet = 4, skip = 2)

# Limpeza

pnt_prop = bd_clean(pnt_prop, 
                    colms_drop = c(1,4,5,6,7),
                    rename_colms = c("sigla_uf", "id_municipio",
                                     "2010","2011","2012","2013","2014","2015","2016",
                                     "2017","2018","2019"))
# inverter colunas

pnt_prop = gather(pnt_prop,
                  key = ano,
                  value = "prop_pnt",
                  -id_municipio,
                  -sigla_uf)

# mudar proporcao

pnt_prop$prop_pnt = pnt_prop$prop_pnt*100 

##### Tabela 7 #####

tabela7 = pnt_prop

write.csv(tabela7,
          "~/basedosdados/tratamento/mobilidados/output/prop_pessoas_próximas_pnt.csv",
          na = " ",
          row.names = F)
#------------------------------------------------------------------------------#

##### Taxa de motorizacao #####

tm_capitais = readxl::read_excel("9_taxa_motorizacao.xlsx",
                                 sheet = 5,
                                 n_max = 27)

# Limpeza

tm_capitais = bd_clean(tm_capitais, 
                       colms_drop = c(1,4,5),
                       rename_colms = c("sigla_uf", "id_municipio",
                                        "2001","2002","2003","2004","2005","2006","2007",
                                        "2008","2009","2010","2011","2012","2013","2014",
                                        "2015","2016","2017","2018"))

# inverter colunas

tm_capitais = gather(tm_capitais,
                     key = ano,
                     value = "taxa_motorizacao_capitais",
                     -sigla_uf,
                     -id_municipio)

##### Tabela 8 #####

tabela8 = tm_capitais

write.csv(tabela8,
          "~/basedosdados/tratamento/mobilidados/output/tx_motorizacao.csv",
          na = " ",
          row.names = F)

#------------------------------------------------------------------------------#

##### Percentual de negros vitimas de acidente de transporte #####

prop_mortes_negras = readxl::read_excel("10.1_percentual_de_negros_vitimas_acidente_transporte.xlsx",
                                        sheet = 4, 
                                        skip = 2)

# Limpeza

# excluir e renomear colunas 

prop_mortes_negras = bd_clean(prop_mortes_negras, 
                              colms_drop = c(2,3,4),
                              rename_colms = c("id_municipio_6",
                                               "2000", "2001","2002","2003","2004","2005","2006","2007",
                                               "2008","2009","2010","2011","2012","2013","2014",
                                               "2015","2016","2017","2018"))


# excluir linha duplicadas

prop_mortes_negras = prop_mortes_negras[-1,]
prop_mortes_negras = prop_mortes_negras[-1711,]
prop_mortes_negras = prop_mortes_negras[-1712,]
prop_mortes_negras = prop_mortes_negras[-1713,]
prop_mortes_negras = prop_mortes_negras[-1752,]
prop_mortes_negras = prop_mortes_negras[-1753,]
prop_mortes_negras = prop_mortes_negras[-1754,]

# adicionar colunas Id Municipio 7 digitos Base dos Dados 

# Abaixo sequencia de (3) passos para baixar o Id Municipio direto do nosso repositório.

project_id = "projectrais" # (1) Selecionar o seu projeto

id_municipios = "SELECT 
SAFE_CAST(municipio AS STRING) municipio,
SAFE_CAST(id_municipio AS INT64) id_municipio
from basedosdados-staging.br_bd_diretorios_brasil_staging.municipio as t" # (2) Montar a Query

id_municipios = bq_table_download(bq_project_query(project_id, id_municipios)) # (3) Baixar direto para o seu Global Environment

# Adicionar coluna

prop_mortes_negras$id_municipio = id_municipios$id_municipio

prop_mortes_negras$id_municipio_6 = NULL

# inverter colunas 

prop_mortes_negras = gather(prop_mortes_negras,
                            key = ano,
                            value = "prop_mortes_negras_acidente_transporte",
                            -id_municipio)

##### Tabela 9 ####

tabela9 = prop_mortes_negras

write.csv(tabela9,
          "~/basedosdados/tratamento/mobilidados/output/prop_mortes_negras_acidente_transporte",
          na = " ",
          row.names = F)
#-------------------------------------------------------------------------------#
##### Percentual de pessoas proximas da infraestrutura cicloviaria (PNB) #####

prop_ciclovias = readxl::read_excel("11_percentual_ciclovias.xlsx",
                                    sheet = 4,
                                    skip = 2)
# Limpeza

prop_ciclovias = bd_clean(prop_ciclovias, 
                          colms_drop = c(1,4,5,6, 7),
                          rename_colms = c("sigla_uf", "id_municipio", "prop_pessoas_proximas_ciclovias"))

# criar coluna ano

prop_ciclovias$ano = "2019"

# mudar ordem 

prop_ciclovias = bd_clean(prop_ciclovias,
                          colms_order = c(1,2,4,3))

#proporcao 

prop_ciclovias$prop_pessoas_proximas_ciclovias = prop_ciclovias*100
##### Tabela 10 ####

tabela10 = prop_ciclovias

write.csv(tabela10,
          "~/basedosdados/tratamento/mobilidados/output/prop_pessoas_prox_infra_cicloviaria.csv",
          na = " ",
          row.names = F)

beep()