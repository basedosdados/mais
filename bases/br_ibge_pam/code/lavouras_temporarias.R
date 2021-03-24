# ADENDOS -------------------
# A base criada está a nivel produto-municipio-ano. Todo produto tem 8 variáveis a seu respeito.
# A restrição de tamanho pela fonte dos dados, o sistema SIDRA (https://sidra.ibge.gov.br/pesquisa/pam/tabelas), 
# forçou a coleta em csvs quebrados.

#DIRETÓRIO

setwd("~/Documentos/bdmais")

# BIBLIOTECAS ---------------
library(readr)
library(reshape2)
library(dplyr) 
library(stringr)
library(glue)
library(purrr)

# VETORES ------------------------
# definindo vetores com o conjunto de anos que vamos usar de recorte
vetor_anos <-("2019" : "1974")

vetor_uf <- c("RO","AC","AM","RR", "PA", "AP", "TO","MA", "PI", "CE","RN","PB","PE","AL", "SE","BA","MG", 
              "ES", "RJ","SP","PR","SC","RS", "MS", "MT","GO", "DF")


anos_milcruzeiros<- c(vetor_anos[37:48], vetor_anos[30:32])
anos_milcruzados <- c("1986":"1988")
anos_real <-c("1994":"2019")

# definindo vetores de nomes de colunas e de produtos temporários

vetor_temp <- c("ano","id_municipio","variavel_disp", "Abacaxi","Alfafa fenada","Algodão herbáceo (em caroço)",
                "Alho","Amendoim (em casca)","Arroz (em casca)", "Aveia (em grão)", "Batata-doce", 
                "Batata Inglesa", "Cana-de-açúcar", "Cana para forragem", "Cebola", "Centeio (em grão)",
                "Cevada (em grão)", "Ervilha (em grão)", "Fava (em grão)", "Feijão (em grão)",
                "Fumo (em folha)", "Girassol (em grão)", "Juta (fibra)", "Linho (semente)",
                "Malva (fibra)", "Mamona (baga)", "Mandioca", "Melancia",
                "Melão", "Milho (em grão)", "Rami (fibra)", "Soja (em grão)",
                "Sorgo (em grão)", "Tomate", "Trigo (em grão)", "Triticale (em grão)")

vetor_produtos <- vetor_temp[4:35]

# FUNÇÕES -------------------------------
leitora<- function(x,y,w,z){
  read.csv(x, header=FALSE, comment.char="#")%>%
    add_row(read.csv(y, header=FALSE, comment.char="#"))%>%
    add_row(read.csv(w, header=FALSE, comment.char="#"))%>%
    add_row(read.csv(z, header=FALSE, comment.char="#"))%>%
    set_names(vetor_temp)%>%
    filter(ano %in% vetor_anos)%>%
    select(-variavel_disp)
}

finalizadora <- function(z, x){
  melt(z, id.vars = c("id_municipio","ano"), 
       measure.vars = vetor_produtos)%>%
    set_names(c("id_municipio", "ano", "produto", x))
} 

cria_estados <- function(x){
  x%>%
    mutate(sigla_uf = case_when(id_uf == "11" ~ "RO", id_uf == "12" ~ "AC", id_uf == "13" ~ "AM",
                                id_uf == "14" ~ "RR", id_uf == "15" ~ "PA", id_uf == "16" ~ "AP", id_uf == "17" ~ "TO",
                                id_uf == "21" ~ "MA", id_uf == "22" ~ "PI", id_uf == "23" ~ "CE", id_uf == "24" ~ "RN",
                                id_uf == "25" ~ "PB", id_uf == "26" ~ "PE", id_uf == "27" ~ "AL", id_uf == "28" ~ "SE", id_uf == "29" ~ "BA",
                                id_uf == "31" ~ "MG", id_uf == "32" ~ "ES", id_uf == "33" ~ "RJ", id_uf == "35" ~ "SP", 
                                id_uf == "41" ~ "PR", id_uf == "42" ~ "SC", id_uf == "43" ~ "RS",
                                id_uf == "50" ~ "MS", id_uf == "51" ~ "MT", id_uf == "52" ~ "GO", id_uf == "53" ~ "DF"))
}

zeradora <- function(x){
  ifelse(is.na(x), "", x)
}
# Funcao para particionar por ano e por estado -----------------------------
part_anos <- function(x, nomedabase){
  filter(nomedabase, ano == x)
}

part_estado <- function(x, y){
  x%>%
    filter(sigla_uf == y)
}

#APLICANDO --------------------------------

# Além da aplicação das funções muda-se as variáveis de área para km quadrado e as de valor para 
# uma unidade monetária, ao invés de unidade de milhar.

# AREA PLANTADA --------------------
areaplantada <- leitora(x = "bases_cruas/agro/aplantada/aplantada1.csv",
                        y = "bases_cruas/agro/aplantada/aplantada2.csv",
                        w = "bases_cruas/agro/aplantada/aplantada3.csv",
                        z = "bases_cruas/agro/aplantada/aplantada4.csv")

# condensando a coluna de produtos
areaplantadafinal <- finalizadora(areaplantada, "area_plantada")%>%
  # transformando em km quadrado
  mutate(area_plantada = as.numeric(area_plantada)/100)


# PERCENTUAL DA AREA PLANTADA ------
percareaplantada <- leitora(x = "bases_cruas/agro/percaplantada/p1.csv",
                            y = "bases_cruas/agro/percaplantada/p2.csv",
                            w = "bases_cruas/agro/percaplantada/p3.csv",
                            z = "bases_cruas/agro/percaplantada/p4.csv")

# condensando a coluna de produtos
percareaplantadafinal <- finalizadora(percareaplantada, "prop_area_plantada")


# AREA COLHIDA ------------
areacolhida <- leitora(x = "bases_cruas/agro/acolhida/c1.csv",
                       y = "bases_cruas/agro/acolhida/c2.csv",
                       w = "bases_cruas/agro/acolhida/c3.csv",
                       z = "bases_cruas/agro/acolhida/c4.csv")

# condensando a coluna de produtos
areacolhidafinal <- finalizadora(areacolhida, "area_colhida")%>%
  # transformando em km quadrado
  mutate(area_colhida = as.numeric(area_colhida)/100)

# PERCENTUAL DA AREA COLHIDA ------------
percareacolhida <- leitora(x = "bases_cruas/agro/percacolhida/q1.csv",
                           y = "bases_cruas/agro/percacolhida/q2.csv",
                           w = "bases_cruas/agro/percacolhida/q3.csv",
                           z = "bases_cruas/agro/percacolhida/q4.csv")

# condensando a coluna de produtos
percareacolhidafinal <- finalizadora(areacolhida, "prop_area_colhida")

# QUANTIDADE PRODUZIDA ------------
quantproduzida <- leitora(x = "bases_cruas/agro/qtd/t1.csv",
                          y = "bases_cruas/agro/qtd/t2.csv",
                          w = "bases_cruas/agro/qtd/t3.csv",
                          z = "bases_cruas/agro/qtd/t4.csv")

# condensando a coluna de produtos
quantproduzidafinal <- finalizadora(quantproduzida, "quantidade_produzida")

# RENDIMENTO MÉDIO ------------
rendmedio <- leitora(x = "bases_cruas/agro/rend/r1.csv",
                     y = "bases_cruas/agro/rend/r2.csv",
                     w = "bases_cruas/agro/rend/r3.csv",
                     z = "bases_cruas/agro/rend/r4.csv")

# condensando a coluna de produtos
rendmediofinal <- finalizadora(rendmedio, "rendimento_medio")

# VALOR DA PRODUÇÃO -----------
valorprod <- leitora(x = "bases_cruas/agro/valorprod/v1.csv",
                     y = "bases_cruas/agro/valorprod/v2.csv",
                     w = "bases_cruas/agro/valorprod/v3.csv",
                     z = "bases_cruas/agro/valorprod/v4.csv")

# condensando a coluna de produtos
valorprodfinal <- finalizadora(valorprod, "valor_producao")%>%
  # mudando de unidade de milhar para unidade somente
  mutate(valor_producao = as.numeric(valor_producao)*1000)

# PORCENTAGEM DO VALOR DE PRODUÇÃO  -----------------
percvalorprod <- leitora(x = "bases_cruas/agro/percvalorprod/w1.csv",
                         y = "bases_cruas/agro/percvalorprod/w2.csv",
                         w = "bases_cruas/agro/percvalorprod/w3.csv",
                         z = "bases_cruas/agro/percvalorprod/w4.csv")

# condensando a coluna de produtos
percvalorprodfinal <- finalizadora(percvalorprod, "prop_valor_producao")

# JUNTANDO TODAS AS BASES ----------------------

temporariafinal<-areaplantadafinal%>%
  inner_join(percareaplantadafinal, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(areacolhidafinal, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(percareacolhidafinal, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(quantproduzidafinal, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(rendmediofinal, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(valorprodfinal, by = c('ano', 'id_municipio', 'produto'))%>%
  inner_join(percvalorprodfinal, by = c('ano', 'id_municipio', 'produto'))%>%
  mutate(id_uf = str_sub(id_municipio,1,2),
         moeda_valor_producao = case_when(ano %in% anos_milcruzeiros ~ "Cruzeiros",
                                      ano %in% anos_milcruzados ~ "Cruzados",
                                      ano == "1989" ~ "Cruzados Novos",
                                      ano == "1993" ~ "Cruzeiros Reais",
                                      ano %in% anos_real ~ "Reais"),
         across(4:11, as.numeric))%>%
  relocate(id_municipio, id_uf)

# CRIANDO CSV ----------

write.csv(temporariafinal, "bases_prontas/temporaria_versaofinal.csv", 
          row.names = FALSE, na ="")


# LENDO E PARTICIONANDO O CSV ------------

# expand grid --------------------

possibilidades_x <- expand.grid(x = vetor_uf,
                                y = 1974:2019)%>%
  pull(x)

possibilidades_y <- expand.grid(x = vetor_uf,
                                y = 1974:2019)%>%
  mutate( y = as.character(y))%>%
  pull(y)

possibilidades_nomes <- expand.grid(x = vetor_uf,
                                    y = 1974:2019)%>%
  mutate(xy = str_c(y,"_",x))%>%
  pull(xy)


# criando diretorios - roda uma unica vez ------
walk2(.x = possibilidades_x, .y = possibilidades_y, 
      ~dir.create(path = glue('bases_prontas/particionadas/municipios_lavouras_temporarias/ano={.y}/sigla_uf={.x}'))
)

# lendo o csv --------------------------
junta <- rio::import("bases_prontas/temporaria_versaofinal.csv")%>%
  cria_estados()

junta <- temporariafinal%>%
  cria_estados()

# repartindo o csv por ano
lista_por_ano <- map(1974:2019, part_anos, nomedabase = junta)
names(lista_por_ano) <- 1974:2019


# criando a lista final de todos anos e ufs
alista <- map2(.x = possibilidades_x, .y = possibilidades_y, 
               .f = ~ lista_por_ano[[.y]]%>%
                 filter(sigla_uf == .x)%>%
                 select(-ano, -sigla_uf, -id_uf)%>%
                 mutate(across(everything(),as.character),
                        across(everything(),zeradora)))


#nomeando a lista

alista2 <-map(alista, as_tibble)%>%
  set_names(possibilidades_nomes)

# exportando as bases
walk2(.y = possibilidades_y, .x = possibilidades_x, 
      ~rio::export(alista2[[glue("{.y}_{.x}")]], 
                   file = glue("bases_prontas/particionadas/municipio_lavouras_temporarias/ano={.y}/sigla_uf={.x}/municipios_lavouras_temporarias.csv",
                               quote = TRUE, row.names = FALSE)
)
)






























