
#------------------------------------------------------------------------------#
# prefacio
#------------------------------------------------------------------------------#

library(tidyr)
library(lubridate)

rm(list = ls())

#setwd("path/to/folder")
setwd("~/Downloads")

#------------------------------------------------------------------------------#
# build
#------------------------------------------------------------------------------#

#-----------------#
# data
#-----------------#

df.data = as.data.frame(seq(lubridate::ymd("0001-01-01"), lubridate::ymd("5000-12-31"), by=1))
colnames(df.data) = "data"

df.data$dia = as.numeric(substr(df.data$data, 9, 10))
df.data$mes = as.numeric(substr(df.data$data, 6, 7))

df.data$bimestre = 0
df.data[df.data$mes >= 1 & df.data$mes <= 2,]$bimestre = 1
df.data[df.data$mes >= 3 & df.data$mes <= 4,]$bimestre = 2
df.data[df.data$mes >= 5 & df.data$mes <= 6,]$bimestre = 3
df.data[df.data$mes >= 7 & df.data$mes <= 8,]$bimestre = 4
df.data[df.data$mes >= 9 & df.data$mes <= 10,]$bimestre = 5
df.data[df.data$mes >= 11 & df.data$mes <= 12,]$bimestre = 6

df.data$trimestre = 0
df.data[df.data$mes >= 1 & df.data$mes <= 3,]$trimestre = 1
df.data[df.data$mes >= 4 & df.data$mes <= 6,]$trimestre = 2
df.data[df.data$mes >= 7 & df.data$mes <= 9,]$trimestre = 3
df.data[df.data$mes >= 10 & df.data$mes <= 12,]$trimestre = 4

df.data$semestre = 0
df.data[df.data$mes >= 1 & df.data$mes <= 6,]$semestre = 1
df.data[df.data$mes >= 7 & df.data$mes <= 12,]$semestre = 2

df.data$ano = as.numeric(substr(df.data$data, 1, 4))

df.data$dia_semana <- lubridate::wday(as.Date(df.data$data))

write.csv(df.data, "data.csv", row.names = FALSE)

#-----------------#
# ano-mes
#-----------------#

#df = as.data.frame(seq(lubridate::ymd("0001-01-01"), lubridate::ymd("5000-12-31"), by=1))
#colnames(df) = "mes"
#df$mes = substr(df$mes, 1, 7)
#
#df = unique(df)
#
#write.csv(df, "ano_mes.csv", row.names = FALSE)

#-----------------#
# ano
#-----------------#

df = as.data.frame(seq(-5000, 5000, by=1))
colnames(df) = "ano"

df$bissexto = as.numeric(df$ano %% 4 == 0)

write.csv(df, "ano.csv", row.names = FALSE)

#-----------------#
# semestre
#-----------------#

df = as.data.frame(seq(1, 2, by=1))
colnames(df) = "semestre"

write.csv(df, "semestre.csv", row.names = FALSE)

#-----------------#
# trimestre
#-----------------#

df = as.data.frame(seq(1, 4, by=1))
colnames(df) = "trimestre"

df$semestre = 0
df[df$trimestre >= 1 & df$trimestre <= 2,]$semestre = 1
df[df$trimestre >= 3 & df$trimestre <= 4,]$semestre = 2

write.csv(df, "trimestre.csv", row.names = FALSE)

#-----------------#
# bimestre
#-----------------#

df = as.data.frame(seq(1, 6, by=1))
colnames(df) = "bimestre"

df$semestre = 0
df[df$bimestre >= 1 & df$bimestre <= 3,]$semestre = 1
df[df$bimestre >= 4 & df$bimestre <= 6,]$semestre = 2

write.csv(df, "bimestre.csv", row.names = FALSE)

#-----------------#
# mes
#-----------------#

df = as.data.frame(seq(1, 12, by=1))
colnames(df) = "mes"

df$nome = ""
df[df$mes == 1,]$nome = "Janeiro"
df[df$mes == 2,]$nome = "Fevereiro"
df[df$mes == 3,]$nome = "Março"
df[df$mes == 4,]$nome = "Abril"
df[df$mes == 5,]$nome = "Maio"
df[df$mes == 6,]$nome = "Junho"
df[df$mes == 7,]$nome = "Julho"
df[df$mes == 8,]$nome = "Agosto"
df[df$mes == 9,]$nome = "Setembro"
df[df$mes == 10,]$nome = "Outubro"
df[df$mes == 11,]$nome = "Novembro"
df[df$mes == 12,]$nome = "Dezembro"

df$bimestre = 0
df[df$mes >= 1 & df$mes <= 2,]$bimestre = 1
df[df$mes >= 3 & df$mes <= 4,]$bimestre = 2
df[df$mes >= 5 & df$mes <= 6,]$bimestre = 3
df[df$mes >= 7 & df$mes <= 8,]$bimestre = 4
df[df$mes >= 9 & df$mes <= 10,]$bimestre = 5
df[df$mes >= 11 & df$mes <= 12,]$bimestre = 6

df$trimestre = 0
df[df$mes >= 1 & df$mes <= 3,]$trimestre = 1
df[df$mes >= 4 & df$mes <= 6,]$trimestre = 2
df[df$mes >= 7 & df$mes <= 9,]$trimestre = 3
df[df$mes >= 10 & df$mes <= 12,]$trimestre = 4

df$semestre = 0
df[df$mes >= 1 & df$mes <= 6,]$semestre = 1
df[df$mes >= 7 & df$mes <= 12,]$semestre = 2

write.csv(df, "mes.csv", row.names = FALSE)

#-----------------#
# dia
#-----------------#

df = as.data.frame(seq(1, 31, by=1))
colnames(df) = "dia"

write.csv(df, "dia.csv", row.names = FALSE)


#-----------------#
# tempo
#-----------------#

hm <- merge(0:23, seq(0, 59, by = 1))

hms = crossing(hm, seq(0, 59, by = 1))
colnames(hms) = c("hora", "minuto", "segundo")

hms$hora    = as.character(hms$hora)
hms$minuto  = as.character(hms$minuto)
hms$segundo = as.character(hms$segundo)

hms[nchar(hms$hora)    == 1,]$hora    = paste0("0", hms[nchar(hms$hora)    == 1,]$hora)
hms[nchar(hms$minuto)  == 1,]$minuto  = paste0("0", hms[nchar(hms$minuto)  == 1,]$minuto)
hms[nchar(hms$segundo) == 1,]$segundo = paste0("0", hms[nchar(hms$segundo) == 1,]$segundo)

df.tempo = as.data.frame(paste0(hms$hora, ':', hms$minuto, ':', hms$segundo))
colnames(df.tempo) = "tempo"

df.tempo$hora = as.numeric(substr(df.tempo$tempo, 1, 2))
df.tempo$minuto = as.numeric(substr(df.tempo$tempo, 4, 5))
df.tempo$segundo = as.numeric(substr(df.tempo$tempo, 7, 8))

write.csv(df.tempo, "tempo.csv", row.names = FALSE)

#-----------------#
# hora
#-----------------#

df = as.data.frame(seq(1, 24, by=1))
colnames(df) = "hora"

write.csv(df, "hora.csv", row.names = FALSE)

#-----------------#
# minuto
#-----------------#

df = as.data.frame(seq(1, 60, by=1))
colnames(df) = "minuto"

write.csv(df, "minuto.csv", row.names = FALSE)

#-----------------#
# segundo
#-----------------#

df = as.data.frame(seq(1, 60, by=1))
colnames(df) = "segundo"

write.csv(df, "segundo.csv", row.names = FALSE)

#-----------------#
# data-tempo  # grande demais pois é combinatório
#-----------------#
#
#df.tempo$tempo = paste0("T", df.tempo$tempo)
#
#anos2000 = df.data[df.data$ano >= 2000 & df.data$ano <= 2001,]$data
#tempo = df.tempo$tempo
#
#df.data_tempo = crossing(df.data[df.data$ano >= 2000 & df.data$ano <= 2000,]$data,
#                         df.tempo$tempo)
#colnames(df.data_tempo) = c("data","tempo")
#
#df.data_tempo = paste0(df.data_tempo$data, df.data_tempo$tempo)
#
#write.csv(df.data_tempo, "data_tempo.csv", row.names = FALSE)
