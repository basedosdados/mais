### Indicadores Educacionais - Brasil ####

atu_2020 <- read_excel("ATU_BRASIL_REGIOES_UFS_2020.xlsx")
atu_2020 <- atu_2020[-c(1:8,27:598),]
  
atu_2019 <- read_excel("ATU_BRASIL_REGIOES_UFS_2019.xlsx")
atu_2019 <- atu_2019[-c(1:8,27:598),]

atu_2018 <- read_excel("ATU_BRASIL_REGIOES_UFS_2018.xlsx")
atu_2018 <- atu_2018[-c(1:8,27:598),]

atu_2017 <- read_excel("ATU_BRASIL_REGIOES_UFS_2017.xlsx")
atu_2017 <- atu_2017[-c(1:8,27:598),]

atu_2016 <- read_excel("ATU_BRASIL_2016.xlsx")
atu_2016 <- atu_2016[-c(1:8,27:29),]

atu_2015 <- read_excel("ATU_BRASIL_2015.xlsx")
atu_2015 <- atu_2015[-c(1:9,28:30),]

atu_2014 <- read_excel("MÉDIA ALUNOS TURMA BRASIL 2014.xls")
atu_2014 <- atu_2014[-c(1:9,28:29),]   #Turmas unificadas em ensino_fund é o mesmo que multi_eta_cat (?)

atu_2013 <- read_excel("MÉDIA ALUNOS TURMA BRASIL 2013.xls")
atu_2013 <- atu_2013[-c(1:9,28:29),]

atu_2012 <- read_excel("media_alunos_turma_brasil_2012.xls")
atu_2012 <- atu_2012[-c(1:8,27:28),]

atu_2011 <- read_excel("alunos_turma_brasil_2011.xls")
atu_2011 <- atu_2011[-c(1:8,27:28),]

atu_2010 <- read_excel("media_alunos_turma_brasil_2010.xls")
atu_2010 <- atu_2010[-c(1:8,27:28),]

atu_2009 <- read_excel("media_alunos_turma_brasil_2009.xls")
atu_2009 <- atu_2009[-c(1:8,27:28),]

atu_2008 <- read_excel("media_alunos_turma_brasil_2008.xls")
atu_2008 <- atu_2008[-c(1:8,27:28),]

atu_2007 <- read_excel("media_alunos_turma_brasil_2007.xls")
atu_2007 <- atu_2007[-c(1:8,27:28),]

atu_01 <- rbind(atu_2020,atu_2019,atu_2018,atu_2017)


colnames(atu_01) <- c("ano","país","localizacao","rede","atu_educacao_infantil","atu_educacao_infantil_creche",
  "atu_educacao_infantil_pre_escola","atu_ensino_fund","atu_ensino_fund_anos_iniciais","atu_ensino_fund_anos_finais","atu_ensino_fund_1_ano",
  "atu_ensino_fund_2_ano","atu_ensino_fund_3_ano","atu_ensino_fund_4_ano","atu_ensino_fund_5_ano","atu_ensino_fund_6_ano","atu_ensino_fund_7_ano",
  "atu_ensino_fund_8_ano","atu_ensino_fund_9_ano","atu_ensino_fund_turmas_multi_eta_cat","atu_ensino_medio","atu_ensino_medio_1_ano","atu_ensino_medio_2_ano",
  "atu_ensino_medio_3_ano","atu_ensino_medio_4_ano","atu_ensino_medio_nao_seriado")

atu_02 <- rbind(atu_2016,atu_2015,atu_2014,atu_2013,atu_2012,atu_2011,atu_2010,atu_2009,atu_2008,atu_2007)

colnames(atu_02) <- c("ano","país","localizacao","rede","atu_educacao_infantil","atu_educacao_infantil_creche",
                      "atu_educacao_infantil_pre_escola","atu_ensino_fund","atu_ensino_fund_anos_iniciais","atu_ensino_fund_anos_finais","atu_ensino_fund_1_ano",
                      "atu_ensino_fund_2_ano","atu_ensino_fund_3_ano","atu_ensino_fund_4_ano","atu_ensino_fund_5_ano","atu_ensino_fund_6_ano","atu_ensino_fund_7_ano",
                      "atu_ensino_fund_8_ano","atu_ensino_fund_9_ano","atu_ensino_fund_turmas_multi_eta_cat","atu_ensino_medio","atu_ensino_medio_1_ano","atu_ensino_medio_2_ano",
                      "atu_ensino_medio_3_ano","atu_ensino_medio_4_ano","atu_ensino_medio_nao_seriado")

atu <- rbind(atu_01,atu_02)
atu$país <- NULL

# Palavras sem acento e minúsculas #
atu$rede <- arrumar(atu$rede)
atu$rede <- arrumar_cons(atu$rede)
atu$localizacao <- arrumar_cons(atu$localizacao)
atu$localizacao <- arrumar(atu$localizacao)

atu$rede <- str_replace_all(atu$rede,"publico","publica")
atu$rede <- str_replace_all(atu$rede,"particular","privada")


# Média Horas-Aula diária #

had_2020 <- read_excel("HAD_BRASIL_REGIOES_UFS_2020.xlsx")
had_2020 <- had_2020[-c(1:8,27:598),]

had_2019 <- read_excel("HAD_BRASIL_REGIOES_UFS_2019.xlsx")
had_2019 <- had_2019[-c(1:8,27:598),]

had_2018 <- read_excel("HAD_BRASIL_REGIOES_UFS_2018.xlsx")
had_2018 <- had_2018[-c(1:8,27:598),]

had_2017 <- read_excel("HAD_BRASIL_REGIOES_UFS_2017.xlsx")
had_2017 <- had_2017[-c(1:8,27:598),]

had_2016 <- read_excel("HAD_BRASIL_2016.xlsx")
had_2016 <- had_2016[-c(1:8,27:29),]

had_2015 <- read_excel("HAD_BRASIL_2015.xlsx")
had_2015 <- had_2015[-c(1:8,27:29),]

had_2014 <- read_excel("MÉDIA HORAS-AULA BRASIL 2014.xls")
had_2014 <- had_2014[-c(1:8,27:28),]

had_2013 <- read_excel("MÉDIA HORAS-AULA BRASIL 2013.xls")
had_2013 <- had_2013[-c(1:8,27:28),]

had_2012 <- read_excel("horas_aula_brasil_2012.xls")
had_2012 <- had_2012[-c(1:7,26:27),]

had_2011 <- read_excel("horas_aula_brasil_2011.xls")
had_2011 <- had_2011[-c(1:7,26:27),]

had_2010 <- read_excel("MÉDIA HORAS-AULA BRASIL 2010.xls")
had_2010 <- had_2010[-c(1:7,26),]

had_01 <- rbind(had_2020,had_2019,had_2018,had_2017)
                
had_02 <- rbind(had_2016,had_2015,had_2014,had_2013,had_2012,had_2011)

colnames(had_01) <- c("ano","país","localizacao","rede","had_educacao_infantil","had_educacao_infantil_creche",
                      "had_educacao_infantil_pre_escola","had_ensino_fund","had_ensino_fund_anos_iniciais","had_ensino_fund_anos_finais","had_ensino_fund_1_ano",
                      "had_ensino_fund_2_ano","had_ensino_fund_3_ano","had_ensino_fund_4_ano","had_ensino_fund_5_ano","had_ensino_fund_6_ano","had_ensino_fund_7_ano",
                      "had_ensino_fund_8_ano","had_ensino_fund_9_ano","had_ensino_medio","had_ensino_medio_1_ano","had_ensino_medio_2_ano",
                      "had_ensino_medio_3_ano","had_ensino_medio_4_ano","had_ensino_medio_nao_seriado")

colnames(had_02) <- c("ano","país","localizacao","rede","had_educacao_infantil","had_educacao_infantil_creche",
                      "had_educacao_infantil_pre_escola","had_ensino_fund","had_ensino_fund_anos_iniciais","had_ensino_fund_anos_finais","had_ensino_fund_1_ano",
                      "had_ensino_fund_2_ano","had_ensino_fund_3_ano","had_ensino_fund_4_ano","had_ensino_fund_5_ano","had_ensino_fund_6_ano","had_ensino_fund_7_ano",
                      "had_ensino_fund_8_ano","had_ensino_fund_9_ano","had_ensino_medio","had_ensino_medio_1_ano","had_ensino_medio_2_ano",
                      "had_ensino_medio_3_ano","had_ensino_medio_4_ano","had_ensino_medio_nao_seriado")

colnames(had_2010) <- c("ano","país","localizacao","rede","had_educacao_infantil_creche",
                        "had_educacao_infantil_pre_escola","had_educacao_infantil","had_ensino_fund_1_ano",
                        "had_ensino_fund_2_ano","had_ensino_fund_3_ano","had_ensino_fund_4_ano","had_ensino_fund_5_ano","had_ensino_fund_6_ano","had_ensino_fund_7_ano",
                        "had_ensino_fund_8_ano","had_ensino_fund_9_ano","had_ensino_fund_anos_iniciais","had_ensino_fund_anos_finais","had_ensino_fund","had_ensino_medio_1_ano","had_ensino_medio_2_ano",
                        "had_ensino_medio_3_ano","had_ensino_medio_4_ano","had_ensino_medio_nao_seriado","had_ensino_medio")

#Trocar ordem das colunas 

had_2010 <- had_2010 %>% relocate(had_educacao_infantil, .after = rede) %>% relocate(had_ensino_fund, .before = had_ensino_fund_1_ano) 
had_2010 <- had_2010 %>% relocate(had_ensino_fund_anos_iniciais, .after = had_ensino_fund) %>% relocate(had_ensino_fund_anos_finais, .after = had_ensino_fund_anos_iniciais) %>% relocate(had_ensino_medio, .after = had_ensino_fund_9_ano)


had <- rbind(had_01,had_02,had_2010)
had$país <- NULL

had$rede <- arrumar(had$rede)
had$rede <- arrumar_cons(had$rede)
had$localizacao <- arrumar_cons(had$localizacao)
had$localizacao <- arrumar(had$localizacao)

had$rede <- str_replace_all(had$rede,"publico","publica")
had$rede <- str_replace_all(had$rede,"particular","privada")


## Taxa de distorção idade - série ##

tdi_2020 <- read_excel("TDI_BRASIL_REGIOES_UFS_2020.xlsx")
tdi_2020 <- tdi_2020[-c(1:8,27:596),]

tdi_2019 <- read_excel("TDI_BRASIL_REGIOES_UFS_2019.xlsx")
tdi_2019 <- tdi_2019[-c(1:8,27:596),]

tdi_2018 <- read_excel("TDI_BRASIL_REGIOES_UFS_2018.xlsx")
tdi_2018 <- tdi_2018[-c(1:8,27:595),]

tdi_2017 <- read_excel("TDI_BRASIL_REGIOES_UFS_2017.xlsx")
tdi_2017 <- tdi_2017[-c(1:8,27:595),]

tdi_2016 <- read_excel("TDI_BRASIL_2016.xlsx")
tdi_2016 <- tdi_2016[-c(1:8,27:28),]

tdi_2015 <- read_excel("TDI_BRASIL_2015.xlsx")
tdi_2015 <- tdi_2015[-c(1:8,27:28),]

tdi_2014 <- read_excel("TDI BRASIL - 2014.xls")
tdi_2014 <- tdi_2014[-c(1:8,27),]

tdi_2013 <- read_excel("TDI BRASIL - 2013.xls")
tdi_2013 <- tdi_2013[-c(1:8,27),]

tdi_2012 <- read_excel("tdi_brasil_2012.xls")
tdi_2012 <- tdi_2012[-c(1:7,26),]

tdi_2011 <- read_excel("tdi_brasil_2011.xls")
tdi_2011 <- tdi_2011[-c(1:7,26:27),]

tdi_2010 <- read_excel("DADOS TDI BRASIL - 2010.xls")
tdi_2010 <- tdi_2010[-c(1:7,26:27),]

tdi_2009 <- read_excel("DADOS TDI BRASIL - 2009.xls")  #Não possui a coluna Brasil
tdi_2009 <- tdi_2009[-c(1:7,26:27),]

tdi_2008 <- read_excel("TDI BRASIL 2008.xls")
tdi_2008 <- tdi_2008[-c(1:7,26:27),]

tdi_2007 <- read_excel("TDI BRASIL 2007.xls")
tdi_2007 <- tdi_2007[-c(1:7,26:27),]

tdi_2006 <- read_excel("TDI06_BR_REG 2006.xls")    #Rede primeiro e depois localização, o resto certo
tdi_2006 <- tdi_2006[-c(1:9,28:118),]

#Juntando os dados
tdi_01 <- rbind(tdi_2020,tdi_2019,tdi_2018,tdi_2017,tdi_2016,tdi_2015,tdi_2014,tdi_2013,tdi_2012,tdi_2011)

colnames(tdi_01) <- c("ano","país","localizacao","rede","tdi_ensino_fund","tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais","tdi_ensino_fund_1_ano",
                        "tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano","tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano",
                        "tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_medio","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano",
                        "tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano")


tdi_02 <- rbind(tdi_2010,tdi_2009,tdi_2008,tdi_2007)

colnames(tdi_02) <- c("ano","país","localizacao","rede","tdi_ensino_fund_1_ano",
                        "tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano","tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano",
                        "tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais","tdi_ensino_fund","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano",
                        "tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano","tdi_ensino_medio")

tdi_02 <- tdi_02 %>% relocate(tdi_ensino_fund, .before = tdi_ensino_fund_1_ano) 
tdi_02 <- tdi_02 %>% relocate(tdi_ensino_fund_anos_iniciais, .after = tdi_ensino_fund) %>% relocate(tdi_ensino_fund_anos_finais, .after = tdi_ensino_fund_anos_iniciais) %>% relocate(tdi_ensino_medio, .after = tdi_ensino_fund_9_ano)

colnames(tdi_2006) <- c("ano","país","rede","localizacao","tdi_ensino_fund","tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais","tdi_ensino_fund_1_ano",
                        "tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano","tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano",
                        "tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_medio","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano",
                        "tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano")


tdi_2006 <- tdi_2006 %>% relocate(localizacao, .before = rede) 

tdi <- rbind(tdi_01,tdi_02,tdi_2006)
tdi$país <- NULL

tdi$rede <- arrumar(tdi$rede)
tdi$rede <- arrumar_cons(tdi$rede)
tdi$localizacao <- arrumar_cons(tdi$localizacao)
tdi$localizacao <- arrumar(tdi$localizacao)

tdi$rede <- str_replace_all(tdi$rede,"publico","publica")
tdi$rede <- str_replace_all(tdi$rede,"particular","privada")



######## TABELA TAXAS DE RENDIMENTO ########

tx_2019 <- read_excel("tx_rend_brasil_regioes_ufs_2019.xlsx")
tx_2019 <- tx_2019[-c(1:8,27:596),]

tx_2018 <- read_excel("TX_REND_BRASIL_REGIOES_UFS_2018.xlsx")
tx_2018 <- tx_2018[-c(1:8,27:596),]

tx_2017 <- read_excel("TX_REND_BRASIL_REGIOES_UFS_2017.xlsx")
tx_2017 <- tx_2017[-c(1:8,27:596),]

tx_2016 <- read_excel("TX_REND_BRASIL_2016.xlsx")
tx_2016 <- tx_2016[-c(1:8,27:28),]

tx_2015 <- read_excel("TX_REND_BRASIL_2015.xlsx")
tx_2015 <- tx_2015[-c(1:8,27:29),]

tx_2014 <- read_excel("TAXAS RENDIMENTOS BRASIL 2014.xlsx")  #A PARTIR DAQUI A REDE ESTA PRIMEIRO
tx_2014 <- tx_2014[-c(1:8,27:29),]

tx_2013 <- read_excel("TAXAS RENDIMENTOS BRASIL 2013.xlsx")
tx_2013 <- tx_2013[-c(1:8,27:29),]

tx_2012 <- read_excel("tx_rendimento_brasil_2012.xlsx")
tx_2012 <- tx_2012[-c(1:8,27:29),]

tx_2011 <- read_excel("tx_rendimento_brasil_2011.xls")
tx_2011 <- tx_2011[-c(1:8,27:30),]

tx_2010 <- read_excel("TAXAS RENDIMENTO BRASIL 2010.xls")  #Anos iniciais e finais no final
tx_2010 <- tx_2010[-c(1:8,27:29),]

tx_2009 <- read_excel("TAXAS RENDIMENTO BRASIL 2009.xls") #Rede primeiro
tx_2009 <- tx_2009[-c(1:9,28:30),]

tx_2008 <- read_excel("TX DE RENDIMENTO BRASIL 2008.xls")
tx_2008 <- tx_2008[-c(1:8,27:30),]

tx_2007 <- read_excel("TX RENDIMENTO BRASIL 2007.xls")
tx_2007 <- tx_2007[-c(1:8,27:30),]

#      JUNTANDO AS BASES E RENOMEANDO COLUNAS     #


tx_rend_01 <- rbind(tx_2019,tx_2018,tx_2017,tx_2016,tx_2015)

colnames(tx_rend_01) <- c("ano","pais","localizacao","rede","taxa_aprov_ensino_fund","taxa_aprov_ensino_fund_anos_iniciais","taxa_aprov_ensino_fund_anos_finais","taxa_aprov_ensino_fund_1_ano",
                          "taxa_aprov_ensino_fund_2_ano","taxa_aprov_ensino_fund_3_ano","taxa_aprov_ensino_fund_4_ano","taxa_aprov_ensino_fund_5_ano","taxa_aprov_ensino_fund_6_ano","taxa_aprov_ensino_fund_7_ano",
                          "taxa_aprov_ensino_fund_8_ano","taxa_aprov_ensino_fund_9_ano","taxa_aprov_ensino_medio","taxa_aprov_ensino_medio_1_ano","taxa_aprov_ensino_medio_2_ano",
                          "taxa_aprov_ensino_medio_3_ano","taxa_aprov_ensino_medio_4_ano","taxa_aprov_ensino_medio_nao_seriado","taxa_reprov_ensino_fund","taxa_reprov_ensino_fund_anos_iniciais","taxa_reprov_ensino_fund_anos_finais","taxa_reprov_ensino_fund_1_ano",
                          "taxa_reprov_ensino_fund_2_ano","taxa_reprov_ensino_fund_3_ano","taxa_reprov_ensino_fund_4_ano","taxa_reprov_ensino_fund_5_ano","taxa_reprov_ensino_fund_6_ano","taxa_reprov_ensino_fund_7_ano",
                          "taxa_reprov_ensino_fund_8_ano","taxa_reprov_ensino_fund_9_ano","taxa_reprov_ensino_medio","taxa_reprov_ensino_medio_1_ano","taxa_reprov_ensino_medio_2_ano",
                          "taxa_reprov_ensino_medio_3_ano","taxa_reprov_ensino_medio_4_ano","taxa_reprov_ensino_medio_nao_seriado","taxa_aband_ensino_fund","taxa_aband_ensino_fund_anos_iniciais","taxa_aband_ensino_fund_anos_finais","taxa_aband_ensino_fund_1_ano",
                          "taxa_aband_ensino_fund_2_ano","taxa_aband_ensino_fund_3_ano","taxa_aband_ensino_fund_4_ano","taxa_aband_ensino_fund_5_ano","taxa_aband_ensino_fund_6_ano","taxa_aband_ensino_fund_7_ano",
                          "taxa_aband_ensino_fund_8_ano","taxa_aband_ensino_fund_9_ano","taxa_aband_ensino_medio","taxa_aband_ensino_medio_1_ano","taxa_aband_ensino_medio_2_ano",
                          "taxa_aband_ensino_medio_3_ano","taxa_aband_ensino_medio_4_ano","taxa_aband_ensino_medio_nao_seriado")

tx_rend_02 <- rbind(tx_2014,tx_2013,tx_2012,tx_2011)

colnames(tx_rend_02) <- c("ano","pais","rede","localizacao","taxa_aprov_ensino_fund","taxa_aprov_ensino_fund_anos_iniciais","taxa_aprov_ensino_fund_anos_finais","taxa_aprov_ensino_fund_1_ano",
                          "taxa_aprov_ensino_fund_2_ano","taxa_aprov_ensino_fund_3_ano","taxa_aprov_ensino_fund_4_ano","taxa_aprov_ensino_fund_5_ano","taxa_aprov_ensino_fund_6_ano","taxa_aprov_ensino_fund_7_ano",
                          "taxa_aprov_ensino_fund_8_ano","taxa_aprov_ensino_fund_9_ano","taxa_aprov_ensino_medio","taxa_aprov_ensino_medio_1_ano","taxa_aprov_ensino_medio_2_ano",
                          "taxa_aprov_ensino_medio_3_ano","taxa_aprov_ensino_medio_4_ano","taxa_aprov_ensino_medio_nao_seriado","taxa_reprov_ensino_fund","taxa_reprov_ensino_fund_anos_iniciais","taxa_reprov_ensino_fund_anos_finais","taxa_reprov_ensino_fund_1_ano",
                          "taxa_reprov_ensino_fund_2_ano","taxa_reprov_ensino_fund_3_ano","taxa_reprov_ensino_fund_4_ano","taxa_reprov_ensino_fund_5_ano","taxa_reprov_ensino_fund_6_ano","taxa_reprov_ensino_fund_7_ano",
                          "taxa_reprov_ensino_fund_8_ano","taxa_reprov_ensino_fund_9_ano","taxa_reprov_ensino_medio","taxa_reprov_ensino_medio_1_ano","taxa_reprov_ensino_medio_2_ano",
                          "taxa_reprov_ensino_medio_3_ano","taxa_reprov_ensino_medio_4_ano","taxa_reprov_ensino_medio_nao_seriado","taxa_aband_ensino_fund","taxa_aband_ensino_fund_anos_iniciais","taxa_aband_ensino_fund_anos_finais","taxa_aband_ensino_fund_1_ano",
                          "taxa_aband_ensino_fund_2_ano","taxa_aband_ensino_fund_3_ano","taxa_aband_ensino_fund_4_ano","taxa_aband_ensino_fund_5_ano","taxa_aband_ensino_fund_6_ano","taxa_aband_ensino_fund_7_ano",
                          "taxa_aband_ensino_fund_8_ano","taxa_aband_ensino_fund_9_ano","taxa_aband_ensino_medio","taxa_aband_ensino_medio_1_ano","taxa_aband_ensino_medio_2_ano",
                          "taxa_aband_ensino_medio_3_ano","taxa_aband_ensino_medio_4_ano","taxa_aband_ensino_medio_nao_seriado")

tx_rend_02 <- tx_rend_02 %>% relocate(localizacao, .after = pais)
                    
tx_rend_03 <- rbind(tx_2010,tx_2009)

colnames(tx_rend_03) <- c("ano","pais","rede","localizacao","taxa_aprov_ensino_fund_1_ano",
                       "taxa_aprov_ensino_fund_2_ano","taxa_aprov_ensino_fund_3_ano","taxa_aprov_ensino_fund_4_ano","taxa_aprov_ensino_fund_5_ano","taxa_aprov_ensino_fund_6_ano","taxa_aprov_ensino_fund_7_ano",
                       "taxa_aprov_ensino_fund_8_ano","taxa_aprov_ensino_fund_9_ano","taxa_aprov_ensino_fund_anos_iniciais","taxa_aprov_ensino_fund_anos_finais","taxa_aprov_ensino_fund","taxa_aprov_ensino_medio_1_ano","taxa_aprov_ensino_medio_2_ano",
                       "taxa_aprov_ensino_medio_3_ano","taxa_aprov_ensino_medio_4_ano","taxa_aprov_ensino_medio_nao_seriado","taxa_aprov_ensino_medio","taxa_reprov_ensino_fund_1_ano",
                       "taxa_reprov_ensino_fund_2_ano","taxa_reprov_ensino_fund_3_ano","taxa_reprov_ensino_fund_4_ano","taxa_reprov_ensino_fund_5_ano","taxa_reprov_ensino_fund_6_ano","taxa_reprov_ensino_fund_7_ano",
                       "taxa_reprov_ensino_fund_8_ano","taxa_reprov_ensino_fund_9_ano","taxa_reprov_ensino_fund_anos_iniciais","taxa_reprov_ensino_fund_anos_finais","taxa_reprov_ensino_fund","taxa_reprov_ensino_medio_1_ano","taxa_reprov_ensino_medio_2_ano",
                       "taxa_reprov_ensino_medio_3_ano","taxa_reprov_ensino_medio_4_ano","taxa_reprov_ensino_medio_nao_seriado","taxa_reprov_ensino_medio","taxa_aband_ensino_fund_1_ano",
                       "taxa_aband_ensino_fund_2_ano","taxa_aband_ensino_fund_3_ano","taxa_aband_ensino_fund_4_ano","taxa_aband_ensino_fund_5_ano","taxa_aband_ensino_fund_6_ano","taxa_aband_ensino_fund_7_ano",
                       "taxa_aband_ensino_fund_8_ano","taxa_aband_ensino_fund_9_ano","taxa_aband_ensino_fund_anos_iniciais","taxa_aband_ensino_fund_anos_finais","taxa_aband_ensino_fund","taxa_aband_ensino_medio_1_ano","taxa_aband_ensino_medio_2_ano",
                       "taxa_aband_ensino_medio_3_ano","taxa_aband_ensino_medio_4_ano","taxa_aband_ensino_medio_nao_seriado","taxa_aband_ensino_medio")

tx_rend_03 <- tx_rend_03 %>% relocate(rede, .after = localizacao) 
tx_rend_03 <- tx_rend_03 %>% relocate(taxa_aprov_ensino_fund, .before = taxa_aprov_ensino_fund_1_ano) 
tx_rend_03 <- tx_rend_03 %>% relocate(taxa_aprov_ensino_fund_anos_iniciais, .after = taxa_aprov_ensino_fund) %>% relocate(taxa_aprov_ensino_fund_anos_finais, .after = taxa_aprov_ensino_fund_anos_iniciais) %>% relocate(taxa_aprov_ensino_medio, .after = taxa_aprov_ensino_fund_9_ano)
tx_rend_03 <- tx_rend_03 %>% relocate(taxa_reprov_ensino_fund, .before = taxa_reprov_ensino_fund_1_ano) 
tx_rend_03 <- tx_rend_03 %>% relocate(taxa_reprov_ensino_fund_anos_iniciais, .after = taxa_reprov_ensino_fund) %>% relocate(taxa_reprov_ensino_fund_anos_finais, .after = taxa_reprov_ensino_fund_anos_iniciais) %>% relocate(taxa_reprov_ensino_medio, .after = taxa_reprov_ensino_fund_9_ano)
tx_rend_03 <- tx_rend_03 %>% relocate(taxa_aband_ensino_fund, .before = taxa_aband_ensino_fund_1_ano) 
tx_rend_03 <- tx_rend_03 %>% relocate(taxa_aband_ensino_fund_anos_iniciais, .after = taxa_aband_ensino_fund) %>% relocate(taxa_aband_ensino_fund_anos_finais, .after = taxa_aband_ensino_fund_anos_iniciais) %>% relocate(taxa_aband_ensino_medio, .after = taxa_aband_ensino_fund_9_ano)


tx_rend_03 <- rbind(tx_2008,tx_2007)

colnames(tx_rend_03) <- c("ano","pais","localizacao","rede","taxa_aprov_ensino_fund_1_ano",
                       "taxa_aprov_ensino_fund_2_ano","taxa_aprov_ensino_fund_3_ano","taxa_aprov_ensino_fund_4_ano","taxa_aprov_ensino_fund_5_ano","taxa_aprov_ensino_fund_6_ano","taxa_aprov_ensino_fund_7_ano",
                       "taxa_aprov_ensino_fund_8_ano","taxa_aprov_ensino_fund_9_ano","taxa_aprov_ensino_fund_anos_iniciais","taxa_aprov_ensino_fund_anos_finais","taxa_aprov_ensino_fund","taxa_aprov_ensino_medio_1_ano","taxa_aprov_ensino_medio_2_ano",
                       "taxa_aprov_ensino_medio_3_ano","taxa_aprov_ensino_medio_4_ano","taxa_aprov_ensino_medio_nao_seriado","taxa_aprov_ensino_medio","taxa_reprov_ensino_fund_1_ano",
                       "taxa_reprov_ensino_fund_2_ano","taxa_reprov_ensino_fund_3_ano","taxa_reprov_ensino_fund_4_ano","taxa_reprov_ensino_fund_5_ano","taxa_reprov_ensino_fund_6_ano","taxa_reprov_ensino_fund_7_ano",
                       "taxa_reprov_ensino_fund_8_ano","taxa_reprov_ensino_fund_9_ano","taxa_reprov_ensino_fund_anos_iniciais","taxa_reprov_ensino_fund_anos_finais","taxa_reprov_ensino_fund","taxa_reprov_ensino_medio_1_ano","taxa_reprov_ensino_medio_2_ano",
                       "taxa_reprov_ensino_medio_3_ano","taxa_reprov_ensino_medio_4_ano","taxa_reprov_ensino_medio_nao_seriado","taxa_reprov_ensino_medio","taxa_aband_ensino_fund_1_ano",
                       "taxa_aband_ensino_fund_2_ano","taxa_aband_ensino_fund_3_ano","taxa_aband_ensino_fund_4_ano","taxa_aband_ensino_fund_5_ano","taxa_aband_ensino_fund_6_ano","taxa_aband_ensino_fund_7_ano",
                       "taxa_aband_ensino_fund_8_ano","taxa_aband_ensino_fund_9_ano","taxa_aband_ensino_fund_anos_iniciais","taxa_aband_ensino_fund_anos_finais","taxa_aband_ensino_fund","taxa_aband_ensino_medio_1_ano","taxa_aband_ensino_medio_2_ano",
                       "taxa_aband_ensino_medio_3_ano","taxa_aband_ensino_medio_4_ano","taxa_aband_ensino_medio_nao_seriado","taxa_aband_ensino_medio")

tx_rend_03 <- tx_rend_03 %>% relocate(taxa_aprov_ensino_fund, .before = taxa_aprov_ensino_fund_1_ano) 
tx_rend_03 <- tx_rend_03 %>% relocate(taxa_aprov_ensino_fund_anos_iniciais, .after = taxa_aprov_ensino_fund) %>% relocate(taxa_aprov_ensino_fund_anos_finais, .after = taxa_aprov_ensino_fund_anos_iniciais) %>% relocate(taxa_aprov_ensino_medio, .after = taxa_aprov_ensino_fund_9_ano)
tx_rend_03 <- tx_rend_03 %>% relocate(taxa_reprov_ensino_fund, .before = taxa_reprov_ensino_fund_1_ano) 
tx_rend_03 <- tx_rend_03 %>% relocate(taxa_reprov_ensino_fund_anos_iniciais, .after = taxa_reprov_ensino_fund) %>% relocate(taxa_reprov_ensino_fund_anos_finais, .after = taxa_reprov_ensino_fund_anos_iniciais) %>% relocate(taxa_reprov_ensino_medio, .after = taxa_reprov_ensino_fund_9_ano)
tx_rend_03 <- tx_rend_03 %>% relocate(taxa_aband_ensino_fund, .before = taxa_aband_ensino_fund_1_ano) 
tx_rend_03 <- tx_rend_03 %>% relocate(taxa_aband_ensino_fund_anos_iniciais, .after = taxa_aband_ensino_fund) %>% relocate(taxa_aband_ensino_fund_anos_finais, .after = taxa_aband_ensino_fund_anos_iniciais) %>% relocate(taxa_aband_ensino_medio, .after = taxa_aband_ensino_fund_9_ano)


tx_rendimentos <- rbind(tx_rend_01,tx_rend_02,tx_rend_03)

tx_rendimentos$pais <- NULL

# Padronização de palavras #
tx_rendimentos$rede <- arrumar(tx_rendimentos$rede)
tx_rendimentos$rede <- arrumar_cons(tx_rendimentos$rede)
tx_rendimentos$localizacao <- arrumar_cons(tx_rendimentos$localizacao)
tx_rendimentos$localizacao <- arrumar(tx_rendimentos$localizacao)

tx_rendimentos$rede <- str_replace_all(tx_rendimentos$rede,"publico","publica")
tx_rendimentos$rede <- str_replace_all(tx_rendimentos$rede,"particular","privada")


## Taxa Não Resposta ##


tnr_2019 <- read_excel("tnr_brasil_regioes_ufs_2019.xlsx")
tnr_2019 <- tnr_2019[-c(1:8,27:597),]

tnr_2018 <- read_excel("TNR_BRASIL_REGIOES_UFS_2018.xlsx")
tnr_2018 <- tnr_2018[-c(1:8,27:597),]

tnr_2017 <- read_excel("TNR_BRASIL_REGIOES_UFS_2017.xlsx")
tnr_2017 <- tnr_2017[-c(1:8,27:596),]

tnr_2016 <- read_excel("TNR_BRASIL_2016.xlsx")
tnr_2016 <- tnr_2016[-c(1:8,27),]

tnr_2015 <- read_excel("TNR_BRASIL_2015.xlsx")
tnr_2015 <- tnr_2015[-c(1:9,28),]

tnr_2014 <- read_excel("TAXA NÃO-RESPOSTA BRASIL 2014.xls")
tnr_2014 <- tnr_2014[-c(1:8,27),]

tnr_2013 <- read_excel("TAXA NÃO-RESPOSTA BRASIL 2013.xls")
tnr_2013 <- tnr_2013[-c(1:8,27),]

tnr_2012 <- read_excel("TAXA NÃO-RESPOSTA BRASIL 2012.xls")
tnr_2012 <- tnr_2012[-c(1:8,27),]

tnr_2011 <- read_excel("tx_nao_resposta_brasil_2011.xls")
tnr_2011 <- tnr_2011[-c(1:8,27),]

tnr_2010 <- read_excel("TAXAS NÃO-RESPOSTA BRASIL 2010.xls")
tnr_2010 <- tnr_2010[-c(1:8,27),]

tnr_01 <- rbind(tnr_2019,tnr_2018,tnr_2017,tnr_2016,tnr_2015,tnr_2014,tnr_2013,tnr_2012,tnr_2011)

colnames(tnr_01) <- c("ano","pais","localizacao","rede","tnr_ensino_fund","tnr_ensino_fund_anos_iniciais","tnr_ensino_fund_anos_finais","tnr_ensino_fund_1_ano",
                   "tnr_ensino_fund_2_ano","tnr_ensino_fund_3_ano","tnr_ensino_fund_4_ano","tnr_ensino_fund_5_ano","tnr_ensino_fund_6_ano","tnr_ensino_fund_7_ano",
                   "tnr_ensino_fund_8_ano","tnr_ensino_fund_9_ano","tnr_ensino_medio","tnr_ensino_medio_1_ano","tnr_ensino_medio_2_ano",
                   "tnr_ensino_medio_3_ano","tnr_ensino_medio_4_ano","tnr_ensino_medio_nao_seriado")

colnames(tnr_2010) <- c("ano","pais","rede","localizacao","tnr_ensino_fund_1_ano",
                        "tnr_ensino_fund_2_ano","tnr_ensino_fund_3_ano","tnr_ensino_fund_4_ano","tnr_ensino_fund_5_ano","tnr_ensino_fund_6_ano","tnr_ensino_fund_7_ano",
                        "tnr_ensino_fund_8_ano","tnr_ensino_fund_9_ano","tnr_ensino_fund_anos_iniciais","tnr_ensino_fund_anos_finais","tnr_ensino_fund","tnr_ensino_medio_1_ano","tnr_ensino_medio_2_ano",
                        "tnr_ensino_medio_3_ano","tnr_ensino_medio_4_ano","tnr_ensino_medio_nao_seriado","tnr_ensino_medio")

tnr_2010 <- tnr_2010 %>% relocate(localizacao, .before = rede)
tnr_2010 <- tnr_2010 %>% relocate(tnr_ensino_fund, .before = tnr_ensino_fund_1_ano) 
tnr_2010 <- tnr_2010 %>% relocate(tnr_ensino_fund_anos_iniciais, .after = tnr_ensino_fund) %>% relocate(tnr_ensino_fund_anos_finais, .after = tnr_ensino_fund_anos_iniciais) %>% relocate(tnr_ensino_medio, .after = tnr_ensino_fund_9_ano)

tnr <- rbind(tnr_01,tnr_2010)
tnr$pais <- NULL

#Padronização de palavras

tnr$rede <- arrumar(tnr$rede)
tnr$rede <- arrumar_cons(tnr$rede)
tnr$localizacao <- arrumar(tnr$localizacao)
tnr$localizacao <- arrumar_cons(tnr$localizacao)

tnr$rede <- str_replace_all(tnr$rede,"publico","publica")
tnr$rede <- str_replace_all(tnr$rede,"particular","privada")


#####  TABELA PERCENTUAL DE DOCENTES COM CURSO SUPERIOR    #######

dsu_2020 <- read_excel("DSU_BRASIL_REGIOES_UFS_2020.xlsx")
dsu_2020 <- dsu_2020[-c(1:9,28:598),]

dsu_2019 <- read_excel("DSU_BRASIL_REGIOES_UFS_2019.xlsx")
dsu_2019 <- dsu_2019[-c(1:9,28:598),]

dsu_2018 <- read_excel("DSU_BRASIL_REGIOES_UFS_2018_ATUALIZADO.xlsx")
dsu_2018 <- dsu_2018[-c(1:9,28:598),]

dsu_2017 <- read_excel("DSU_BRASIL_REGIOES_UFS_2017.xlsx")
dsu_2017 <- dsu_2017[-c(1:9,28:598),]

dsu_2016 <- read_excel("DSU_BRASIL_2016.xlsx")
dsu_2016 <- dsu_2016[-c(1:9,28:29),]

dsu_2015 <- read_excel("DSU_BRASIL_2015.xlsx")
dsu_2015 <- dsu_2015[-c(1:9,28:29),]

dsu_2014 <- read_excel("DSU - BRASIL 2014.xls")
dsu_2014 <- dsu_2014[-c(1:9,28),]

dsu_2013 <- read_excel("DSU - BRASIL 2013.xls")
dsu_2013 <- dsu_2013[-c(1:9,28),]

dsu_2012 <- read_excel("DSU - BRASIL 2012.xls")
dsu_2012 <- dsu_2012[-c(1:9,28),]

dsu_2011 <- read_excel("DSU - BRASIL 2011.xls")
dsu_2011 <- dsu_2011[-c(1:9,28),]

dsu_01 <- rbind(dsu_2020,dsu_2019,dsu_2018,dsu_2017)

colnames(dsu_01) <- c("ano","pais","localizacao","rede","dsu_educ_infantil","dsu_educ_infantil_creche","dsu_educ_infantil_pre_escola","dsu_ensino_fund","dsu_ensino_fund_anos_iniciais"
                      ,"dsu_ensino_fund_anos_finais","dsu_ensino_medio","dsu_educacao_profissional","dsu_educacao_jovens_adultos",
                      "dsu_educacao_especial")

dsu_02 <- rbind(dsu_2016,dsu_2015,dsu_2014,dsu_2013,dsu_2012,dsu_2011)

colnames(dsu_02) <- c("ano","pais","localizacao","rede","dsu_educ_infantil","dsu_educ_infantil_creche","dsu_educ_infantil_pre_escola","dsu_ensino_fund","dsu_ensino_fund_anos_iniciais"
                                          ,"dsu_ensino_fund_anos_finais","dsu_ensino_medio","dsu_educacao_profissional","dsu_educacao_jovens_adultos",
                                          "dsu_educacao_especial")

dsu <- rbind(dsu_01,dsu_02)

dsu$pais <- NULL

#Padronização de palavras

dsu$rede <- arrumar(dsu$rede)
dsu$rede <- arrumar_cons(dsu$rede)
dsu$localizacao <- arrumar(dsu$localizacao)
dsu$localizacao <- arrumar_cons(dsu$localizacao)

dsu$rede <- str_replace_all(dsu$rede,"publico","publica")
dsu$rede <- str_replace_all(dsu$rede,"particular","privada")


##### TABELA ADEQUAÇÃO DA FORMAÇÃO DOCENTE ######

afd_2020 <- read_excel("AFD_BRASIL_REGIOES_UFS_2020.xlsx")
afd_2020 <- afd_2020[-c(1:10,29:602),]

afd_2019 <- read_excel("AFD_BRASIL_REGIOES_UFS_2019.xlsx")
afd_2019 <- afd_2019[-c(1:10,29:602),]

afd_2018 <- read_excel("AFD_BRASIL_REGIOES_UFS_2018.xlsx")
afd_2018 <- afd_2018[-c(1:10,29:602),]

afd_2017 <- read_excel("AFD_BRASIL_REGIOES_UFS_2017.xlsx")
afd_2017 <- afd_2017[-c(1:10,29:602),]

afd_2016 <- read_excel("AFD_BRASIL_2016.xlsx")
afd_2016 <- afd_2016[-c(1:10,29:33),]

afd_2015 <- read_excel("AFD_BRASIL_2015.xlsx")
afd_2015 <- afd_2015[-c(1:10,29:33),]

afd_2014 <- read_excel("AFD_BRASIL_2014.xlsx")
afd_2014 <- afd_2014[-c(1:10,29:33),]

afd_2013 <- read_excel("AFD_BRASIL_2013.xlsx")
afd_2013 <- afd_2013[-c(1:10,29:33),]

afd <- rbind(afd_2020,afd_2019,afd_2018,afd_2017,afd_2016,afd_2015,afd_2014,afd_2013)

colnames(afd) <- c("ano","pais","localizacao","rede","afd_educacao_infantil_grupo_1","afd_educacao_infantil_grupo_2",
                   "afd_educacao_infantil_grupo_3","afd_educacao_infantil_grupo_4","afd_educacao_infantil_grupo_5","afd_ensino_fund_grupo_1","afd_ensino_fund_grupo_2","afd_ensino_fund_grupo_3",
                   "afd_ensino_fund_grupo_4","afd_ensino_fund_grupo_5","afd_ensino_fund_anos_iniciais_grupo_1","afd_ensino_fund_anos_iniciais_grupo_2","afd_ensino_fund_anos_iniciais_grupo_3","afd_ensino_fund_anos_iniciais_grupo_4",
                   "afd_ensino_fund_anos_iniciais_grupo_5","afd_ensino_fund_anos_finais_grupo_1","afd_ensino_fund_anos_finais_grupo_2","afd_ensino_fund_anos_finais_grupo_3","afd_ensino_fund_anos_finais_grupo_4",
                   "afd_ensino_fund_anos_finais_grupo_5","afd_ensino_medio_grupo_1","afd_ensino_medio_grupo_2","afd_ensino_medio_grupo_3","afd_ensino_medio_grupo_4","afd_ensino_medio_grupo_5","afd_eja_fundamental_grupo_1","afd_eja_fundamental_grupo_2",
                   "afd_eja_fundamental_grupo_3","afd_eja_fundamental_grupo_4","afd_eja_fundamental_grupo_5","afd_eja_medio_grupo_1","afd_eja_medio_grupo_2","afd_eja_medio_grupo_3","afd_eja_medio_grupo_4","afd_eja_medio_grupo_5")


afd$pais <- NULL

#Padronização de palavras

afd$rede <- arrumar(afd$rede)
afd$rede <- arrumar_cons(afd$rede)
afd$localizacao <- arrumar(afd$localizacao)
afd$localizacao <- arrumar_cons(afd$localizacao)

afd$rede <- str_replace_all(afd$rede,"publico","publica")
afd$rede <- str_replace_all(afd$rede,"particular","privada")


###### TABELA REGULARIDADE DO CORPO DOCENTE  ########

ird_2020 <- read_excel("IRD_BRASIL_REGIOES_UFS_2020.xlsx")
ird_2020 <- ird_2020[-c(1:9,28:601),]

ird_2019 <- read_excel("IRD_BRASIL_REGIOES_UFS_2019.xlsx")
ird_2019 <- ird_2019[-c(1:9,28:601),]

ird_2018 <- read_excel("IRD_BRASIL_REGIOES_UFS_2018.xlsx")
ird_2018 <- ird_2018[-c(1:9,28:600),]

ird_2017 <- read_excel("IRD_BRASIL_REGIOES_UFS_2017.xlsx")
ird_2017 <- ird_2017[-c(1:9,28:599),]

ird_2016 <- read_excel("IRD_BRASIL_2016.xlsx")
ird_2016 <- ird_2016[-c(1:9,28:32),]

ird_2015 <- read_excel("IRD_BRASIL_2015.xlsx")
ird_2015 <- ird_2015[-c(1:9,28:32),]

ird_2014 <- read_excel("IRD_BRASIL_2014.xlsx")
ird_2014 <- ird_2014[-c(1:9,28:32),]

ird_2013 <- read_excel("IRD_BRASIL_2013.xlsx")
ird_2013 <- ird_2013[-c(1:9,28:32),]

ird <- rbind(ird_2020,ird_2019,ird_2018,ird_2017,ird_2016,ird_2015,ird_2014,ird_2013)

colnames(ird) <- c("ano","pais","localizacao","rede","ird_baixa_regularidade","ird_media_baixa","ird_media_alta","ird_alta")

ird$pais <- NULL

#Padronização de palavras

ird$rede <- arrumar(ird$rede)
ird$rede <- arrumar_cons(ird$rede)
ird$localizacao <- arrumar(ird$localizacao)
ird$localizacao <- arrumar_cons(ird$localizacao)

ird$rede <- str_replace_all(ird$rede,"publico","publica")
ird$rede <- str_replace_all(ird$rede,"particular","privada")


####### TABELA ESFORÇO DOCENTE ########

ied_2020 <- read_excel("IED_BRASIL_REGIOES_UFS_2020.xlsx")
ied_2020 <- ied_2020[-c(1:10,29:601),]

ied_2019 <- read_excel("IED_BRASIL_REGIOES_UFS_2019.xlsx")
ied_2019 <- ied_2019[-c(1:10,29:601),]

ied_2018 <- read_excel("IED_BRASIL_REGIOES_UFS_2018.xlsx")
ied_2018 <- ied_2018[-c(1:10,29:601),]

ied_2017 <- read_excel("IED_BRASIL_REGIOES_UFS_2017.xlsx")
ied_2017 <- ied_2017[-c(1:10,29:601),]

ied_2016 <- read_excel("IED_BRASIL_2016.xlsx")
ied_2016 <- ied_2016[-c(1:10,29:32),]

ied_2015 <- read_excel("IED_BRASIL_2015.xlsx")
ied_2015 <- ied_2015[-c(1:10,29:32),]

ied_2014 <- read_excel("IED_BRASIL_2014.xlsx")
ied_2014 <- ied_2014[-c(1:10,29:32),]

ied_2013 <- read_excel("IED_BRASIL_2013.xlsx")
ied_2013 <- ied_2013[-c(1:10,29:33),]

ied <- rbind(ied_2020,ied_2019,ied_2018,ied_2017,ied_2016,ied_2015,ied_2014,ied_2013)

colnames(ied) <- c("ano","pais","localizacao","rede","ied_ensino_fund_nivel_1","ied_ensino_fund_nivel_2","ied_ensino_fund_nivel_3","ied_ensino_fund_nivel_4",
                   "ied_ensino_fund_nivel_5","ied_ensino_fund_nivel_6","ied_ensino_fund_anos_iniciais_nivel_1","ied_ensino_fund_anos_iniciais_nivel_2","ied_ensino_fund_anos_iniciais_nivel_3","ied_ensino_fund_anos_iniciais_nivel_4",
                   "ied_ensino_fund_anos_iniciais_nivel_5","ied_ensino_fund_anos_iniciais_nivel_6","ied_ensino_fund_anos_finais_nivel_1","ied_ensino_fund_anos_finais_nivel_2","ied_ensino_fund_anos_finais_nivel_3",
                   "ied_ensino_fund_anos_finais_nivel_4","ied_ensino_fund_anos_finais_nivel_5","ied_ensino_fund_anos_finais_nivel_6","ied_ensino_medio_nivel_1","ied_ensino_medio_nivel_2","ied_ensino_medio_nivel_3","ied_ensino_medio_nivel_4","ied_ensino_medio_nivel_5","ied_ensino_medio_nivel_6")


ied$pais <- NULL

ied$rede <- arrumar(ied$rede)
ied$rede <- arrumar_cons(ied$rede)
ied$localizacao <- arrumar(ied$localizacao)
ied$localizacao <- arrumar_cons(ied$localizacao)

ied$rede <- str_replace_all(ied$rede,"publico","publica")
ied$rede <- str_replace_all(ied$rede,"particular","privada")

###### TABELA COMPLEXIDADE DE GESTÃO DA ESCOLA ######

icg_2020 <- read_excel("ICG_BRASIL_REGIOES_UFS_2020.xlsx")
icg_2020 <- icg_2020[-c(1:8,27:600),]

icg_2019 <- read_excel("ICG_BRASIL_REGIOES_UFS_2019.xlsx")
icg_2019 <- icg_2019[-c(1:8,27:600),]

icg_2018 <- read_excel("ICG_BRASIL_REGIOES_UFS_2018.xlsx")
icg_2018 <- icg_2018[-c(1:8,27:600),]

icg_2017 <- read_excel("ICG_BRASIL_REGIOES_UFS_2017.xlsx")
icg_2017 <- icg_2017[-c(1:8,27:600),]

icg_2016 <- read_excel("ICG_BRASIL_2016.xlsx")
icg_2016 <- icg_2016[-c(1:8,27:31),]

icg_2015 <- read_excel("ICG_BRASIL_2015.xlsx")
icg_2015 <- icg_2015[-c(1:8,27:31),]

icg_2014 <- read_excel("ICG_BRASIL_2014.xlsx")
icg_2014 <- icg_2014[-c(1:8,27:31),]

icg_2013 <- read_excel("ICG_BRASIL_2013.xlsx")
icg_2013 <- icg_2013[-c(1:8,27:31),]

icg <- rbind(icg_2020,icg_2019,icg_2018,icg_2017,icg_2016,icg_2015,icg_2014,icg_2013)

colnames(icg) <- c("ano","pais","localizacao","rede","icg_nivel_1","icg_nivel_2","icg_nivel_3","icg_nivel_4","icg_nivel_5","icg_nivel_6")

icg$pais <- NULL

icg$rede <- arrumar(icg$rede)
icg$rede <- arrumar_cons(icg$rede)
icg$localizacao <- arrumar(icg$localizacao)
icg$localizacao <- arrumar_cons(icg$localizacao)

icg$rede <- str_replace_all(icg$rede,"publico","publica")
icg$rede <- str_replace_all(icg$rede,"particular","privada")


## Juntando e terminando o processo de limpeza das bases ##

indicadores_01 <- full_join(atu,had, by= c("localizacao","rede","ano"))

indicadores_02 <- full_join(indicadores_01,tdi, by= c("localizacao","rede","ano"))

indicadores_03 <- full_join(indicadores_02,tx_rendimentos, by= c("localizacao","rede","ano"))

indicadores_04 <- full_join(indicadores_03,tnr, by= c("localizacao","rede","ano"))

indicadores_05 <- full_join(indicadores_04,dsu, by= c("localizacao","rede","ano"))

indicadores_06 <- full_join(indicadores_05,afd, by= c("localizacao","rede","ano"))

indicadores_07 <- full_join(indicadores_06,ird, by= c("localizacao","rede","ano"))

indicadores_08 <- full_join(indicadores_07,ied, by= c("localizacao","rede","ano"))

indicadores_09 <- full_join(indicadores_08,icg, by= c("localizacao","rede","ano"))


indicadores <- indicadores_09 %>% arrange(localizacao,rede,ano)

is.na(indicadores[4:214]) <- indicadores[4:214]=="--"

indicadores[,4:214] <- lapply(indicadores[4:214],as.numeric)

con <- file('brasil.csv', encoding = "UTF-8")
write.csv(indicadores, file = con, row.names = FALSE, na = " ")


