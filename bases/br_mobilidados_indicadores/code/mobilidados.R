#### Limpar memoria e denifir diretorio #### 

rm(list = ls())

setwd("~/basedosdados/tratamento/2_mobilidados/input") 

#### Pacotes #### 
library(tidyverse)
library(xlsx)
library(beepr)
library(bigrquery)
#### Funcoes #### 

bd_clean = function(path, sheet, skip = 0, colms_drop = NULL, colms_order = NULL, rename_colms = NULL) 
{ df <- readxl::read_excel(path, sheet=sheet, skip=skip)
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
return(df)}

bd_output = function(df, name) {write.csv(df, paste("~/basedosdados/tratamento/2_mobilidados/output", 
                                                    name, sep = "/"), na = " ", row.names = F)}
bd_order = function (df, colms){
        df = df %>% 
                select(colms)}

#### Tabela 1 ####
## Tarifa nas capitais

# Leitura e limpeza dos dados
tarifas = bd_clean("compr_trans_publico.xlsx", sheet = 2, skip = 2, 
                   colms_drop = c(1, 4, 5, 6, 20, 21),rename_colms = c("sigla_uf", "id_municipio", "2005", 
                                                                       "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015","2016", "2017"))

# Inverter colunas
tarifas = gather(tarifas, key = "ano", value = "tarifas",
                 -id_municipio, -sigla_uf)

### Comprometimento do salario minimo ### 
compr_salario = bd_clean("compr_trans_publico.xlsx", sheet = 4, skip = 2,
                         colms_drop = c(1, 4, 5, 6, 20, 21, 22, 23), rename_colms = c("sigla_uf", "id_municipio", "2005", 
                                                                                      "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017"))

# Inverter colunas
compr_salario = gather(compr_salario, key = "ano",  value = "comprometimento_salario_minimo",
                       -sigla_uf, -id_municipio)

### Comprometimento da renda para trabalhadoras domesticas negras ###
salario_domes_negras = bd_clean("compr_trans_publico.xlsx", sheet = 6, skip = 1, 
                                colms_drop = c(1,2, 4, 5, 6, 7), rename_colms = c("id_municipio", "2005", "2006", "2007", "2008", 
                                                                                  "2009", "2011", "2012", "2013", "2014", "2015"))
# Inverter colunas
salario_domes_negras = gather(salario_domes_negras, key = "ano", value = "comprometimento_renda_domesticas_negras",
                              -id_municipio)

# Unificar tabelas e/ou reorganizar colunas
tabela1 = tarifas
tabela1$comprotimento_salario_minimo = compr_salario$comprometimento_salario_minimo
tabela1 = full_join(salario_domes_negras, tabela1, by = c('id_municipio', 'ano'))
tabela1 = bd_order(tabela1, colms = c(4,1,2,5,6,3))

#### Tabela 2 ####
### Tempo medio de deslocamento casa-trabalho ### 

# Leitura e limpeza dos dados
temp_medio = bd_clean("tempo_medio.xlsx", sheet = 2, colms_drop = c(1, 4, 5, 6), 
                      rename_colms = c("sigla_uf", "id_municipio", "tempo_medio_deslocamento"))

# Adicionar coluna "ano"
temp_medio$ano = "2010"

### Percentual de pessoas que gastam mais de uma hora no deslocamento casa-trabalho ###

# Leitura e limpeza dos dados
prop_des = bd_clean("prop_pessoas_gastam1_deslocamento.xlsx", sheet = 2, colms_drop = c(1,4,5,6),
                    rename_colms = c("sigla_uf", "id_municipio", "prop_deslocamento_acima_1_hora"))

# Adicionar coluna "ano"
prop_des$ano = "2010"

# Proporcao 
prop_des$prop_deslocamento = prop_des$prop_deslocamento_acima_1_hora*100

# Unificar tabelas e/ou reorganizar colunas
tabela2 = temp_medio
tabela2$prop_deslocamento_acima_1_hora = prop_des$prop_deslocamento
tabela2 = bd_order(tabela2, colms = c(1,2,4,3,5))

#### Tabela 3 ####
## Percentual de estacoes de transporte de media e alta capacidade na area de cobertura da infraestrutura cicloviaria

# Leitura e limpeza dos dados
tma = bd_clean("prop_tma.xlsx", sheet = 4, skip = 2, colms_drop = c(1, 4, 5, 6, 7),
               rename_colms = c("sigla_uf", "id_municipio", "prop_tma"))

# Adicionar coluna "ano"
tma$ano = "2019"

# Unificar tabelas e/ou reorganizar colunas
tabela3 = tma
tabela3 = bd_order(tabela3, c(1,2,4,3))

#### Tabela 4 #### 
## Divisao modal

# Leitura e limpeza dos dados
modal = bd_clean("divisao_modal.xlsx", sheet = 2, colms_drop = c(1,3,4, 5),
                 rename_colms = c("sigla_uf", "1996", "1997", "2002","2003","2007", "2009", "2010", "2012", "2017","2018"))

# Inverter colunas
modal = gather(modal, key = "ano", value = "divisao_modal",
               -sigla_uf)
# Proporcao 
modal$divisao_modal = as.numeric(modal$divisao_modal)
modal$divisao_modal = modal$divisao_modal*100
tabela4 = modal

#### Tabela 5 ####
## Percentual de domicilios que possuem infraestrutura urbana no seu entorno

# Leitura e limpeza dos dados
prop_domi_infra = bd_clean("percentual_domicilios.xlsx", sheet = 2, colms_drop =  c(1,4,5,6),
                           rename_colms = c("sigla_uf", "id_municipio", "calcadas", "rampas"))

# Adicionar coluna "ano" e proporcao 
prop_domi_infra$ano = "2010"
prop_domi_infra$calcadas = prop_domi_infra$calcadas*100
prop_domi_infra$rampas = as.numeric(prop_domi_infra$rampas)
prop_domi_infra$rampas = prop_domi_infra$rampas*100

# Unificar tabelas e/ou reorganizar colunas
tabela5 = prop_domi_infra
tabela5 = bd_order(tabela5, c(1,2,5,3,4))

#### Tabela 6 #### 
### Emissao CO2 por habitante (Capitais) ###

# Leitura e limpeza dos dados
co2_hab = bd_clean("emissao_co2_mp.xlsx", sheet = 3, skip = 2, colms_drop = c(1,4, 17:58),
                   rename_colms = c("sigla_uf", "id_municipio", "2007", "2008", "2009", "2010", "2011", 
                                    "2012", "2013","2014", "2015", "2016", "2017", "2018"))

# Inverter colunas
co2_hab = gather(co2_hab, key = ano, value = "emissao_co2",
                 -sigla_uf, -id_municipio)

### Emissao MP por habitante (Capitais) ###

# Leitura e limpeza dos dados
mp_hab = bd_clean("emissao_co2_mp.xlsx", sheet = 5, skip = 2, colms_drop =c(1, 4, 17:55), 
                  rename_colms = c("sigla_uf", "id_municipio", "2007", "2008", "2009", "2010", "2011", "2012", 
                                   "2013","2014", "2015", "2016", "2017", "2018"))

# Inverter colunas
mp_hab = gather(mp_hab, key = ano, value = "emissao_mp",
                -sigla_uf, -id_municipio)

# Unificar tabelas e/ou reorganizar colunas
tabela6 = co2_hab
tabela6$emissao_mp = mp_hab$emissao_mp

#### Tabela 7 #### 
## Percentual de pessoas proximas da rede de transporte de media e alta capacidade

# Leitura e limpeza dos dados
pnt_prop = bd_clean("pnt.xlsx", sheet = 4, skip = 2, colms_drop = c(1,4,5,6,7),
                    rename_colms = c("sigla_uf", "id_municipio", "2010","2011","2012","2013","2014","2015","2016", "2017","2018","2019"))

# Inverter colunas
pnt_prop = gather(pnt_prop, key = ano, value = "prop_pnt", -id_municipio, -sigla_uf)

# Proporcao 
pnt_prop$prop_pnt = pnt_prop$prop_pnt*100 

# Unificar tabelas e/ou reorganizar colunas
tabela7 = pnt_prop

#### Tabela 8 ####
## Taxa de motorizacao

# Leitura e limpeza dos dados
tx_motorizacao = bd_clean("taxa_motorizacao.xlsx", sheet = 5, colms_drop = c(1,4,5), 
                          rename_colms = c("sigla_uf", "id_municipio", "2001","2002","2003","2004","2005","2006","2007",
                                           "2008","2009","2010","2011","2012","2013","2014", "2015","2016","2017","2018"))

# Inverter colunas
tx_motorizacao = gather(tx_motorizacao, key = ano, value = "taxa_motorizacao",
                        -sigla_uf, -id_municipio)

# Unificar tabelas e/ou reorganizar colunas
tabela8 = tx_motorizacao

#### Tabela 9 ####
### Percentual de negros vitimas de acidente de transporte

# Leitura e limpeza dos dados
prop_mortes = bd_clean("prop_mortes_negros.xlsx", sheet = 4, skip = 2, colms_drop = c(2,3,4),
                       rename_colms = c("id_municipio_6", "2000", "2001","2002","2003","2004","2005","2006","2007","2008",
                                        "2009","2010","2011","2012","2013","2014", "2015","2016","2017","2018"))

# Adicionar coluna 'Id Municipio' com 7 digitos [Repositorio BD+] 
# Abaixo sequencia dos tres passos necessarios para baixar o Id Municipio direto do repositorio BD+ no Big Query.

project_id = "projectrais"  # (1) Adicionar o seu projeto 

id_municipio = "SELECT 
SAFE_CAST(municipio AS STRING) municipio,
SAFE_CAST(id_municipio AS INT64) id_municipio
from basedosdados-staging.br_bd_diretorios_brasil_staging.municipio as t" # (2) Montar a Query

id_municipio = bq_table_download(bq_project_query(project_id, id_municipio)) # (3) Baixar direto para o seu Global Environment

# Fazer merge e excluir coluna 'ID Municipio' com 6 digitos
prop_mortes$id_municipio = id_municipio$id_municipio
prop_mortes$id_municipio_6 = NULL

# Inverter colunas
prop_mortes = gather(prop_mortes, key = ano, value = "prop_mortes_negras_acidente_transporte",
                     -id_municipio)

# Unificar tabelas e/ou reorganizar colunas
tabela9 = prop_mortes

#### Tabela 10 ####
## Percentual de pessoas proximas da infraestrutura cicloviaria

# Leitura e limpeza dos dados
prop_ciclovias = bd_clean("prop_ciclo.xlsx", sheet = 4, skip = 2, colms_drop = c(1,4,5,6, 7),
                          rename_colms = c("sigla_uf", "id_municipio", "prop_pessoas_proximas_ciclovias"))

# Adicionar coluna "ano"
prop_ciclovias$ano = "2019"

# Proporcao 
prop_ciclovias$prop_pessoas_proximas_ciclovias = as.numeric(prop_ciclovias$prop_pessoas_proximas_ciclovias)
prop_ciclovias$prop_pessoas_proximas_ciclovias = prop_ciclovias$prop_pessoas_proximas_ciclovias*100

# Unificar tabelas e/ou reorganizar colunas
tabela10 = prop_ciclovias
tabela10 = bd_order(tabela10, c(1,2,4,3))

#### Output #### 
bd_output(tabela1, "compr_renda_tarifa_transp_publico.csv")
bd_output(tabela2, "tempo_deslocamento_casa_trabalho.csv")
bd_output(tabela3, "transporte_media_alta_capacidade.csv")
bd_output(tabela4, "divisao_modal.csv")
bd_output(tabela5, "prop_domicilios_infra_urbana.csv")
bd_output(tabela6, "emissao_co2_material_particulado.csv")
bd_output(tabela7, "prop_pessoas_proximas_pnt.csv")
bd_output(tabela8, "taxa_motorizacao.csv")
bd_output(tabela9, "prop_mortes_negras_acidente_transporte.csv")
bd_output(tabela10, "prop_pessoas_prox_infra_cicloviaria.csv")

beep()

