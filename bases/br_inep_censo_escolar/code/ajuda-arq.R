library(tidyverse)
library(glue)
library(rio)

#DOCENTES -----------------------------------------
#arquitetura 
arq <- import("arquitetura - docente.csv")%>%
  select(- descricao)

#dicionario de 2020 para pegar as descrições
dic <- import("dicionarios/dicionario_2020.xlsx", sheet = "BAS_DOCENTE")%>%
  rename(nome_original_2020 = `Alteração de nomenclatura`)%>%
  select(nome_original_2020, `...3`)%>%
  set_names("nome_original_2020", "descricao")%>%
  filter(nome_original_2020 != is.na(nome_original_2020))


nomeado1v<- arq%>%
  full_join(dic, by = "nome_original_2020")%>%
  mutate(tipo = "INT64")%>%
  select(tipo,descricao,cobertura_temporal,coluna_diretorio,
         dicionario,unidade_medida,nome_original_2020,nome_original_2019,
         nome_original_2018,nome_original_2017,nome_original_2016,nome_original_2015,
         nome_original_2014,nome_original_2013,nome_original_2012,nome_original_2011,
         nome_original_2010,nome_original_2009)


#juntando com a tabela de variáveis que vão ser usadas


nomes <- rio::import("guia_variaveis_docente.csv")%>%
  filter(variaveis_2018 != "") %>% 
  pull(variaveis_2018)


mudança <-  map(nomes, tolower)%>%
  map(str_remove, "in_")%>%
  map(str_remove, "tp_")%>% 
  map(str_replace, "nu_ano_inicio", "ano_inicio_curso_superior")%>%
  map(str_replace, "nu_ano_conclusao", "ano_conclusao_curso_superior")%>%
  map(str_replace, "nu_ano_censo", "ano")%>%
  map(str_replace, "nu_ano", "ano_nascimento_docente")%>%
  map(str_replace, "nu_mes", "mes_nascimento_docente") %>%
  map(str_remove, "nu_")%>%
  map(str_replace, "co_", "id_")%>%
  map(str_replace, "transp_", "transporte_")%>%
  map(str_replace, "_embar_", "_embarcacao_")%>%
  map(str_replace, "def_", "deficiencia_")%>%
  map(str_replace, "dur_", "duracao_") %>% 
  map(str_replace, "com_pedagogica", "formacao_pedagogica_complementar") %>% 
  map(str_replace, "_nasc", "_nascimento") %>% 
  map(str_replace, "_end", "_endereco") %>% 
  map(str_replace, "disc_", "disciplina_") %>% 
  map(str_replace, "especifiid_", "formacao_especifica_") %>% 
  map(str_replace, "dependencia", "rede") %>% 
  unlist()


antes_e_depois <- tibble(nome_original_2020 = nomes, coluna =mudança)


#nova versao da planilha de arquitetura ja com nome que coloquei

nomeado2v <- nomeado1v%>%
  left_join(antes_e_depois, by = "nome_original_2020")%>%
  select(coluna,tipo,descricao,cobertura_temporal,coluna_diretorio,
         dicionario,unidade_medida,nome_original_2020,nome_original_2019,
         nome_original_2018,nome_original_2017,nome_original_2016,nome_original_2015,
         nome_original_2014,nome_original_2013,nome_original_2012,nome_original_2011,
         nome_original_2010,nome_original_2009)%>%
  mutate(coluna = replace_na(coluna, "(deletado)"),
         cobertura_temporal = 
           case_when(nome_original_2009 != "" & nome_original_2020 != "" ~ "2009(1)2020",
                     nome_original_2011 == "" & nome_original_2012 != "" & nome_original_2020 != "" ~ "2012(1)2020",
                     nome_original_2020 != "" & nome_original_2019 != "" & nome_original_2018 == "" ~"2019(1)2020"),
         coluna_diretorio = case_when(str_detect(nomeado2v$coluna, "municipio") ~ "br_bd_diretorios_brasil.municipio:id_municipio",
                                      str_detect(nomeado2v$coluna, "uf") ~ "br_bd_diretorios_brasil.uf:id_uf"))


export(nomeado2v, "nova-arq-docentes.xlsx")


#TURMAS ------------------------------------------------

#arquitetura 
arqt <- import("arquitetura - turma.csv")%>%
  select(- descricao, - coluna)

#dicionario de 2020 para pegar as descrições
dict <- import("dicionarios/dicionario_2020.xlsx", sheet = "BAS_TURMA")%>%
  rename(nome_original_2020 = `Alteração de nomenclatura`)%>%
  select(nome_original_2020, `...3`)%>%
  set_names("nome_original_2020", "descricao")%>%
  filter(nome_original_2020 != is.na(nome_original_2020))



#nome atualizado da turma

guiaturma <- import("guia_variaveis_turma.csv")%>%
  filter(duracao>8)%>%
  pull(nome_novo)


nomes_definitivo <- map(.x = guiaturma, tolower)%>%
  map(str_replace, "^co_", "id_")%>%
  map(str_remove_all, "^in")%>%
  map(str_remove, "^_")%>%
  map(str_replace, "^tp_", "tipo_")%>%
  map(str_replace, "^equip", "equipamento")%>%
  map(str_replace, "^qt", "quantidade")%>%
  map(str_replace, "^quantidade_equip", "quantidade_equipamento")%>%
  map(str_replace, "^dt", "data")%>%
  map(str_replace, "^alojam", "alojamento")%>%  
  map(str_replace, "pp", "poder_publico")%>%
  map(str_replace, "aee", "atendimento_educacional_especial")%>%
  map(str_replace, "^mant", "mantenedora")%>%
  map(str_replace, "^esp_", "especial_")%>%
  map(str_replace, "id_uf", "sigla_uf")%>%
  map(str_replace, "nu_ano_censo", "ano")%>%
  map(str_replace, "^tx", "taxa")%>%
  map(str_replace, "^nu", "numero")%>%
  map(str_replace, "tipo_tipo", "tipo")%>%
  map(str_replace, "^disc", "disciplina")%>%
  map(str_replace, '^enriq', 'enriquecimento')%>%
  map(str_replace, "_hr_", "_hora_")%>%
  map(str_replace, "_mi_", "_minuto_")%>%
  map(str_replace, "id_entidade", "id_escola")%>%
  map(str_replace, "tipo_dependencia", "rede")%>%
  map(str_replace, "taxa_hora", "hora")%>%
  map(str_replace, "taxa_minuto", "minuto")%>%
  unlist()

#tibble nomes antigos e novos de turma

ant_depois<- tibble(coluna = nomes_definitivo, nome_original_2020 = guiaturma)


#junta tudo na nova planilha de arquitetura

novaarqturma <- arqt%>%
  left_join(ant_depois, by = 'nome_original_2020')%>%
  left_join(dict, by = 'nome_original_2020') %>% 
  select(coluna,tipo,descricao,cobertura_temporal,coluna_diretorio,
         dicionario,unidade_medida,nome_original_2020,nome_original_2019,
         nome_original_2018,nome_original_2017,nome_original_2016,nome_original_2015,
         nome_original_2014,nome_original_2013,nome_original_2012,nome_original_2011,
         nome_original_2010,nome_original_2009)%>%
  mutate(coluna = replace_na(coluna, "(deletado)"),
         cobertura_temporal = 
           case_when(nome_original_2009 != "" & nome_original_2020 != "" ~ "2009(1)2020",
                     nome_original_2011 == "" & nome_original_2012 != "" & nome_original_2020 != "" ~ "2012(1)2020",
                     nome_original_2020 != "" & nome_original_2019 != "" & nome_original_2018 == "" ~"2019(1)2020"),
         coluna_diretorio = case_when(str_detect(novaarqturma$coluna, "municipio") ~ "br_bd_diretorios_brasil.municipio:id_municipio",
                                      str_detect(novaarqturma$coluna, "uf") ~ "br_bd_diretorios_brasil.uf:id_uf"),
         tipo = "INT64")




export(novaarqturma, "nova-arq-turma.xlsx")

## MATRICULAS -------------------------------------------------------------------
#arquitetura 
arqm <- import("arquitetura - matricula.csv")%>%
  select(- descricao, - coluna, -cobertura_temporal)

#dicionario de 2020 para pegar as descrições
dicm <- import("dicionarios/dicionario_2020.xlsx", sheet = "BAS_MATRICULA")%>%
  rename(nome_original_2020 = `Alteração de nomenclatura`)%>%
  select(nome_original_2020, `...3`)%>%
  set_names("nome_original_2020", "descricao")%>%
  filter(nome_original_2020 != is.na(nome_original_2020))


#pegando o guia das variaveis da matricula
guiam <- import("guia_variaveis_matriculas.csv")%>%
  mutate(cobertura_temporal = glue::glue("{surge}(1){fim}"))%>%
  select(novo_nome, cobertura_temporal) %>% 
  rename(nome_original_2020 = novo_nome)

nome <- guiam%>%
  pull(nome_original_2020)

#ajustando esses nomes para os nomes que temos de fato na base

nomes_final <- map(nome, tolower)%>%
  map(str_remove, "in_")%>%
  map(str_replace, "nu_ano_censo", "ano")%>%
  map(str_replace, "nu_ano", "ano_nascimento_aluno")%>%
  map(str_remove, "nu_")%>%
  map(str_replace, "co_", "id_")%>%
  map(str_replace, "mes", "mes_nascimento_aluno")%>%
  map(str_replace, "dia", "dia_nascimento_aluno")%>%
  map(str_replace, "transp_", "transporte_")%>%
  map(str_replace, "_embar_", "_embarcacao_")%>%
  map(str_replace, "ano_censo", "ano")%>%
  map(str_replace, "def_", "deficiencia_")%>%
  map(str_replace, "dur_", "duracao_")%>%
  map(str_remove, "tp_") %>% 
  unlist()


cobertura <- guiam %>% 
  pull(cobertura_temporal)

tibblematricula <- tibble(cobertura_temporal = cobertura, nome_original_2020 = nome, coluna = nomes_final)

#juntando tudo

novarqmatricula <- arqm%>%
  left_join(tibblematricula,by = "nome_original_2020") %>% 
  left_join(dicm, by = 'nome_original_2020')%>% 
  select(coluna,tipo,descricao,cobertura_temporal,coluna_diretorio,
         dicionario,unidade_medida,nome_original_2020,nome_original_2019,
         nome_original_2018,nome_original_2017,nome_original_2016,nome_original_2015,
         nome_original_2014,nome_original_2013,nome_original_2012,nome_original_2011,
         nome_original_2010,nome_original_2009)%>%
  mutate(coluna = case_when(coluna == "" ~"(deletado)", 
                            TRUE ~ coluna),
         cobertura_temporal = 
           case_when(nome_original_2009 != "" & nome_original_2020 != "" ~ "2009(1)2020",
                     nome_original_2011 == "" & nome_original_2012 != "" & nome_original_2020 != "" ~ "2012(1)2020",
                     nome_original_2020 != "" & nome_original_2019 != "" & nome_original_2018 == "" ~"2019(1)2020"),
         coluna_diretorio = case_when(str_detect(novarqmatricula$coluna, "municipio") ~ "br_bd_diretorios_brasil.municipio:id_municipio",
                                      str_detect(novarqmatricula$coluna, "uf") ~ "br_bd_diretorios_brasil.uf:id_uf"),
         tipo = "INT64")



export(novarqmatricula, "nova-arq-matricula.xlsx")




## ESCOLAS ---------------------------------------------------------


#arquitetura 
arq <- import("arquitetura - escola.csv")%>%
  select(- descricao, - coluna)

#dicionario de 2020 para pegar as descrições
dic <- import("dicionarios/dicionario_2020.xlsx", sheet = "BAS_ESCOLA")%>%
  rename(nome_original_2020 = `Alteração de nomenclatura`)%>%
  select(nome_original_2020, `...3`)%>%
  set_names("nome_original_2020", "descricao")%>%
  filter(nome_original_2020 != is.na(nome_original_2020))


#guia de escola para ter os nomes faceis

guia <- import("arquitetura - escola.csv")#%>%
  select()

















#----------------------------------------------------------
#importando a base
guia<-rio::import('guia_variaveis_matriculas.csv')


%>%
  mutate(periodo = glue("{surge}(1){fim}"))%>%
  select(periodo)%>%
  rio::export("colunaperiodo.xlsx")


#importando e vendo o que da pra fazer com dicionarios

#pra pegar descri??o
teste<- import("dicionarios/dicionario_2009.xls")%>%
  set_names('numero_var', 'nome_original_2009', 'descricao', 'tipo_caracter',
            'tamanho','valores')%>%
  filter(nome_original_2009 != is.na(nome_original_2009))%>%
  select(nome_original_2009,descricao)


#juntando com a base que ja existe 

tabela_original <- import("arquitetura - escola.csv")%>%
  select(nome_original_2009)%>%
  left_join(teste, by = 'nome_original_2009')%>%
  filter(!nome_original_2009 == "")%>%
  export("descricao_feita.xlsx")

#BASE DE MATRICULA --------------------------------------


#importando a base
guia<-rio::import('guia_variaveis_matriculas.csv')#%>%
  mutate(periodo = glue("{surge}(1){fim}"))%>%
  select(periodo)%>%
  rio::export("colunaperiodo.xlsx")






