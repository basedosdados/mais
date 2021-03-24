## Remuneração Média dos Docentes ###

#  UF #

rem_2017 <- read_excel("Remuneracao_docentes_UF_2017.xlsx")
rem_2017 <- rem_2017[-c(1:8,252:254),]

rem_2016 <- read_excel("Remuneracao_docentes_UF_2016.xlsx")
rem_2016 <- rem_2016[-c(1:8,252:254),]

rem_2015 <- read_excel("Remuneracao_docentes_UF_2015.xlsx")
rem_2015 <- rem_2015[-c(1:8,252:254),]

rem_2014 <- read_excel("Remuneracao_docentes_UF_2014.xlsx")
rem_2014 <- rem_2014[-c(1:8,252:254),]

remuneracao <- rbind(rem_2017,rem_2016,rem_2015,rem_2014)

colnames(remuneracao) <- c("ano","regiao","uf","rede","escolaridade","numero_docentes","prop_docentes_rais"
                           ,"rem_bruta_rais_1_quartil","rem_bruta_rais_mediana","rem_bruta_rais_media",
                           "rem_bruta_rais_3_quartil","rem_bruta_rais_desvio_padrao","carga_horaria_media_semanal","rem_media_40_horas_semanais")

remuneracao$rede <- arrumar(remuneracao$rede)
remuneracao$rede <- arrumar_cons(remuneracao$rede)
remuneracao$escolaridade <- arrumar_cons(remuneracao$escolaridade)
remuneracao$escolaridade <- arrumar(remuneracao$escolaridade)

remuneracao$rede <- str_replace_all(remuneracao$rede,"publico","publica")
remuneracao$rede <- str_replace_all(remuneracao$rede,"particular","privada")

remuneracao <- remuneracao %>% arrange(escolaridade,rede,ano,regiao,uf)

is.na(remuneracao[6:14]) <- remuneracao[6:14]=="--"

remuneracao[,6:14] <- lapply(remuneracao[6:14],as.numeric)

con <- file('UF.csv', encoding = "UTF-8")
write.csv(remuneracao, file = con, row.names = FALSE, na = " ")


