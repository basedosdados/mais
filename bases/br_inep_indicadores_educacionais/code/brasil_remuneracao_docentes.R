## Remuneração Média dos Docentes ###

#  Brasil #

rem_2017 <- read_excel("Remuneracao_docentes_Brasil_2017.xlsx")
rem_2017 <- rem_2017[-c(1:8,24:26),]

rem_2016 <- read_excel("Remuneracao_docentes_Brasil_2016.xlsx")
rem_2016 <- rem_2016[-c(1:8,24:26),]

rem_2015 <- read_excel("Remuneracao_docentes_Brasil_2015.xlsx")
rem_2015 <- rem_2015[-c(1:8,24:26),]

rem_2014 <- read_excel("Remuneracao_docentes_Brasil_2014.xlsx")
rem_2014 <- rem_2014[-c(1:8,24:26),]

remuneracao <- rbind(rem_2017,rem_2016,rem_2015,rem_2014)

colnames(remuneracao) <- c("ano","pais","rede","escolaridade","numero_docentes","prop_docentes_rais"
                        ,"rem_bruta_rais_1_quartil","rem_bruta_rais_mediana","rem_bruta_rais_media",
                        "rem_bruta_rais_3_quartil","rem_bruta_rais_desvio_padrao","carga_horaria_media_semanal","rem_media_40_horas_semanais")

remuneracao$pais <- NULL

remuneracao$rede <- arrumar(remuneracao$rede)
remuneracao$rede <- arrumar_cons(remuneracao$rede)
remuneracao$escolaridade <- arrumar_cons(remuneracao$escolaridade)
remuneracao$escolaridade <- arrumar(remuneracao$escolaridade)

remuneracao$rede <- str_replace_all(remuneracao$rede,"publico","publica")
remuneracao$rede <- str_replace_all(remuneracao$rede,"particular","privada")

remuneracao <- remuneracao %>% arrange(escolaridade,rede,ano)

is.na(remuneracao[4:12]) <- remuneracao[4:12]=="--"

remuneracao[,4:12] <- lapply(remuneracao[4:12],as.numeric)

con <- file('brasil.csv', encoding = "UTF-8")
write.csv(remuneracao, file = con, row.names = FALSE, na = " ")


