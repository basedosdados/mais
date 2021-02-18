
#INDICADORES DE TRAJETÓRIA DE CURSO
install.packages("xlsx",dependencies = TRUE)
install.packages("rJava")
library(xlsx)

setwd("C:/Users/Hevilyn/Desktop/inep_curso/")

tjes_15_19 <- read.csv2("curso_de_para_anual.csv")
tjes_15_19 <- tjes_15_19[-c(1:8,140704),]

tjes_15_19 <- as.data.frame(tjes_15_19)

tjes_15_19$tada <- as.numeric(tjes_15_19$tada)
tjes_15_19$tap <- as.numeric(tjes_15_19$tap)
tjes_15_19$tca <- as.numeric(tjes_15_19$tca)
tjes_15_19$tda <- as.numeric(tjes_15_19$tda)
tjes_15_19$tcan <- as.numeric(tjes_15_19$tcan)

colnames(tjes_15_19) <- c("id_ies","nome_ies","tipo_categoria_administrativa","tipo_organizacao","id_curso","nome_curso","id_regiao"
                ,"id_uf","id_municipio","tipo_grau_academico","tipo_modalidade","id_cine_area_geral"
                ,"nome_cine_area_geral","id_cine_rotulo","nome_cine_rotulo","ano_ingresso","ano_referencia"
                ,"prazo_integralizacao","ano_integralizacao","prazo_acompanhamento","ano_max_acompanhamento"
                ,"quantidade_ingressante","quantidade_permanencia","quantidade_concluinte","quantidade_desistencia","quantidade_falecido","tap","tca"
                ,"tda","tcan","tada")

tjes_15_19$nome_ies <- arrumar(tjes_15_19$nome_ies)
tjes_15_19$nome_ies <- arrumar_cons(tjes_15_19$nome_ies)
tjes_15_19$nome_curso <- arrumar(tjes_15_19$nome_curso)
tjes_15_19$nome_curso <- arrumar_cons(tjes_15_19$nome_curso)
tjes_15_19$nome_cine_area_geral <- arrumar(tjes_15_19$nome_cine_area_geral)
tjes_15_19$nome_cine_area_geral <- arrumar_cons(tjes_15_19$nome_cine_area_geral)
tjes_15_19$nome_cine_rotulo <- arrumar(tjes_15_19$nome_cine_rotulo)
tjes_15_19$nome_cine_rotulo <- arrumar_cons(tjes_15_19$nome_cine_rotulo)

tjes_15_19[25:31] <- options(digits = 2)


tjes_14_19 <- read_excel("indicadores_trajetoria_educacao_superior_2014_2019.xlsx")
tjes_14_19 <- tjes_14_19[-c(1:8,164361),]


tjes_13_19 <- read_excel("indicadores_trajetoria_educacao_superior_2013_2019.xlsx")
tjes_13_19 <- tjes_13_19[-c(1:8,186860),]

tjes_12_19 <- read_excel("indicadores_trajetoria_educacao_superior_2012_2019.xlsx")
tjes_12_19 <- tjes_12_19[-c(1:8,214657),]

tjes_11_19 <- read_excel("indicadores_trajetoria_educacao_superior_2011_2019.xlsx")
tjes_11_19 <- tjes_11_19[-c(1:8,233703),]

tjes_10_19 <- read_excel("indicadores_trajetoria_educacao_superior_2010_2019.xlsx")
tjes_10_19 <- tjes_10_19[-c(1:8,233703),]

tjes <- rbind(tjes_14_19,tjes_13_19,tjes_12_19,tjes_11_19,tjes_10_19)


colnames(tjes) <- c("id_ies","nome_ies","tipo_categoria_administrativa","tipo_organizacao","id_curso","nome_curso","id_regiao"
                    ,"id_uf","id_municipio","tipo_grau_academico","tipo_modalidade","id_cine_rotulo","nome_cine_rotulo","id_cine_area_geral"
                    ,"nome_cine_area_geral","ano_ingresso","ano_referencia"
                    ,"prazo_integralizacao","ano_integralizacao","prazo_acompanhamento","ano_max_acompanhamento"
                    ,"quantidade_ingressante","quantidade_permanencia","quantidade_concluinte","quantidade_desistencia","quantidade_falecido","tap","tca"
                    ,"tda","tcan","tada")

tjes_15_19 <- tjes_15_19 %>% relocate(id_cine_rotulo, .after = tp_modalidade)
tjes_15_19 <- tjes_15_19 %>% relocate(nome_cine_rotulo, .after = id_cine_rotulo)

tjes_01 <- rbind(tjes_15_19,tjes)

tjes_01 <- arrumar(tjes_01)
tjes_01<- arrumar_cons(tjes_01)


tjes_01$tada <- as.numeric(tjes_01$tada)
tjes_01$tap <- as.numeric(tjes_01$tap)
tjes_01$tca <- as.numeric(tjes_01$tca)
tjes_01$tda <- as.numeric(tjes_01$tda)
tjes_01$tcan <- as.numeric(tjes_01$tcan)


con <- file('curso_de_para_anual.csv', encoding = "UTF-8")
write.csv(tjes_01, file = con, row.names = FALSE)
