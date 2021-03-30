### Indicadores Educacionais - UF ####

atu_2020 <- read_excel("ATU_BRASIL_REGIOES_UFS_2020.xlsx")
atu_2020 <- atu_2020[-c(1:116,596:598),]

atu_2019 <- read_excel("ATU_BRASIL_REGIOES_UFS_2019.xlsx")
atu_2019 <- atu_2019[-c(1:116,596:598),]

atu_2018 <- read_excel("ATU_BRASIL_REGIOES_UFS_2018.xlsx")
atu_2018 <- atu_2018[-c(1:116,596:598),]

atu_2017 <- read_excel("ATU_BRASIL_REGIOES_UFS_2017.xlsx")
atu_2017 <- atu_2017[-c(1:44,168:185,347:364,437:454,509:526,596:598),]

atu_2016 <- read_excel("ATU_UFS_2016.xlsx")  #A partir daqui a coluna região existe
atu_2016 <- atu_2016[-c(1:8,488:490),]

atu_2015 <- read_excel("ATU_UF_2015.xlsx") #Coluna sigla UF
atu_2015 <- atu_2015[-c(1:9,488:490),]

atu_2014 <- read_excel("MÉDIA ALUNOS TURMA UFS 2014.xls") 
atu_2014 <- atu_2014[-c(1:9,487:488),]  

atu_2013 <- read_excel("MÉDIA ALUNOS TURMA UFS 2013.xls")
atu_2013 <- atu_2013[-c(1:9,488:489),]

atu_2012 <- read_excel("media_alunos_turma_ufs_2012.xls")
atu_2012 <- atu_2012[-c(1:8,487:488),]

atu_2011 <- read_excel("alunos_turma_ufs_2011.xls")
atu_2011 <- atu_2011[-c(1:8,487:488),]

atu_2010 <- read_excel("media_alunos_turma_ufs_2010.xls")
atu_2010 <- atu_2010[-c(1:8,483:484),]

atu_2009 <- read_excel("media_alunos_turma_ufs_2009.xls")
atu_2009 <- atu_2009[-c(1:8,482:483),]

atu_2008 <- read_excel("media_alunos_turma_ufs_2008.xls")
atu_2008 <- atu_2008[-c(1:8,480:481),]

atu_2007 <- read_excel("media_alunos_turma_ufs_2007.xls")
atu_2007 <- atu_2007[-c(1:8,478:479),]

atu_01 <- rbind(atu_2020,atu_2019,atu_2018,atu_2017)

colnames(atu_01) <- c("ano","sigla_uf","localizacao","rede","atu_educacao_infantil","atu_educacao_infantil_creche",
                      "atu_educacao_infantil_pre_escola","atu_ensino_fund","atu_ensino_fund_anos_iniciais","atu_ensino_fund_anos_finais","atu_ensino_fund_1_ano",
                      "atu_ensino_fund_2_ano","atu_ensino_fund_3_ano","atu_ensino_fund_4_ano","atu_ensino_fund_5_ano","atu_ensino_fund_6_ano","atu_ensino_fund_7_ano",
                      "atu_ensino_fund_8_ano","atu_ensino_fund_9_ano","atu_ensino_fund_turmas_multi_eta_cat","atu_ensino_medio","atu_ensino_medio_1_ano","atu_ensino_medio_2_ano",
                      "atu_ensino_medio_3_ano","atu_ensino_medio_4_ano","atu_ensino_medio_nao_seriado")

atu_02 <- rbind(atu_2016,atu_2015,atu_2014,atu_2013,atu_2012,atu_2011,atu_2010,atu_2009,atu_2008,atu_2007)

colnames(atu_02) <- c("ano","regiao","sigla_uf","localizacao","rede","atu_educacao_infantil","atu_educacao_infantil_creche",
                      "atu_educacao_infantil_pre_escola","atu_ensino_fund","atu_ensino_fund_anos_iniciais","atu_ensino_fund_anos_finais","atu_ensino_fund_1_ano",
                      "atu_ensino_fund_2_ano","atu_ensino_fund_3_ano","atu_ensino_fund_4_ano","atu_ensino_fund_5_ano","atu_ensino_fund_6_ano","atu_ensino_fund_7_ano",
                      "atu_ensino_fund_8_ano","atu_ensino_fund_9_ano","atu_ensino_fund_turmas_multi_eta_cat","atu_ensino_medio","atu_ensino_medio_1_ano","atu_ensino_medio_2_ano",
                      "atu_ensino_medio_3_ano","atu_ensino_medio_4_ano","atu_ensino_medio_nao_seriado")
atu_02$regiao <- NULL

atu <- rbind(atu_01,atu_02)

# Palavras sem acento e minúsculas #
atu$rede <- arrumar(atu$rede)
atu$rede <- arrumar_cons(atu$rede)
atu$localizacao <- arrumar_cons(atu$localizacao)
atu$localizacao <- arrumar(atu$localizacao)
atu$sigla_uf <- sigla_uf(atu$sigla_uf)

atu$rede <- str_replace_all(atu$rede,"publico","publica")
atu$rede <- str_replace_all(atu$rede,"particular","privada")
atu$regiao <- str_replace_all(atu$regiao,"Centro - Oeste","Centro-Oeste")


# Média Horas-Aula diária #

had_2020 <- read_excel("HAD_BRASIL_REGIOES_UFS_2020.xlsx")
had_2020 <- had_2020[-c(1:116,596:598),]

had_2019 <- read_excel("HAD_BRASIL_REGIOES_UFS_2019.xlsx")
had_2019 <- had_2019[-c(1:116,596:598),]

had_2018 <- read_excel("HAD_BRASIL_REGIOES_UFS_2018.xlsx")
had_2018 <- had_2018[-c(1:116,596:598),]

had_2017 <- read_excel("HAD_BRASIL_REGIOES_UFS_2017.xlsx")
had_2017 <- had_2017[-c(1:44,168:185,347:364,437:454,509:526,596:598),]

had_2016 <- read_excel("HAD_UFS_2016.xlsx") #Coluna a mais de regiao
had_2016 <- had_2016[-c(1:8,488:490),]

had_2015 <- read_excel("HAD_UF_2015.xlsx")   #Coluna código da uf
had_2015 <- had_2015[-c(1:8,487:489),]

had_2014 <- read_excel("MÉDIA HORAS-AULA UFS 2014.xls")
had_2014 <- had_2014[-c(1:8,486:487),]

had_2013 <- read_excel("MÉDIA HORAS-AULA UFS 2013.xls")
had_2013 <- had_2013[-c(1:8,487:488),]

had_2012 <- read_excel("horas_aula_ufs_2012.xls")
had_2012 <- had_2012[-c(1:7,486:487),]

had_2011 <- read_excel("horas_aula_ufs_2011.xls")
had_2011 <- had_2011[-c(1:7,486:487),]

had_2010 <- read_excel("MÉDIA HORAS-AULA UFS 2010.xls") #Colunas Total, Anos Finais e Iniciais no fim
had_2010 <- had_2010[-c(1:7,482),]

had_01 <- rbind(had_2020,had_2019,had_2018,had_2017)

had_02 <- rbind(had_2015,had_2014,had_2013,had_2012,had_2011)

colnames(had_01) <- c("ano","sigla_uf","localizacao","rede","had_educacao_infantil","had_educacao_infantil_creche",
                      "had_educacao_infantil_pre_escola","had_ensino_fund","had_ensino_fund_anos_iniciais","had_ensino_fund_anos_finais","had_ensino_fund_1_ano",
                      "had_ensino_fund_2_ano","had_ensino_fund_3_ano","had_ensino_fund_4_ano","had_ensino_fund_5_ano","had_ensino_fund_6_ano","had_ensino_fund_7_ano",
                      "had_ensino_fund_8_ano","had_ensino_fund_9_ano","had_ensino_medio","had_ensino_medio_1_ano","had_ensino_medio_2_ano",
                      "had_ensino_medio_3_ano","had_ensino_medio_4_ano","had_ensino_medio_nao_seriado")

colnames(had_2016) <- c("ano","regiao","sigla_uf","localizacao","rede","had_educacao_infantil","had_educacao_infantil_creche",
                      "had_educacao_infantil_pre_escola","had_ensino_fund","had_ensino_fund_anos_iniciais","had_ensino_fund_anos_finais","had_ensino_fund_1_ano",
                      "had_ensino_fund_2_ano","had_ensino_fund_3_ano","had_ensino_fund_4_ano","had_ensino_fund_5_ano","had_ensino_fund_6_ano","had_ensino_fund_7_ano",
                      "had_ensino_fund_8_ano","had_ensino_fund_9_ano","had_ensino_medio","had_ensino_medio_1_ano","had_ensino_medio_2_ano",
                      "had_ensino_medio_3_ano","had_ensino_medio_4_ano","had_ensino_medio_nao_seriado")
had_2016$regiao <- NULL

colnames(had_02) <- c("ano","regiao","sigla_uf","cod_uf","localizacao","rede","had_educacao_infantil","had_educacao_infantil_creche",
                      "had_educacao_infantil_pre_escola","had_ensino_fund","had_ensino_fund_anos_iniciais","had_ensino_fund_anos_finais","had_ensino_fund_1_ano",
                      "had_ensino_fund_2_ano","had_ensino_fund_3_ano","had_ensino_fund_4_ano","had_ensino_fund_5_ano","had_ensino_fund_6_ano","had_ensino_fund_7_ano",
                      "had_ensino_fund_8_ano","had_ensino_fund_9_ano","had_ensino_medio","had_ensino_medio_1_ano","had_ensino_medio_2_ano",
                      "had_ensino_medio_3_ano","had_ensino_medio_4_ano","had_ensino_medio_nao_seriado")

had_02$regiao <- NULL
had_02$cod_uf <- NULL

colnames(had_2010) <- c("ano","regiao","sigla_uf","cod_uf","localizacao","rede","had_educacao_infantil_creche",
                        "had_educacao_infantil_pre_escola","had_educacao_infantil","had_ensino_fund_1_ano",
                        "had_ensino_fund_2_ano","had_ensino_fund_3_ano","had_ensino_fund_4_ano","had_ensino_fund_5_ano","had_ensino_fund_6_ano","had_ensino_fund_7_ano",
                        "had_ensino_fund_8_ano","had_ensino_fund_9_ano","had_ensino_fund_anos_iniciais","had_ensino_fund_anos_finais","had_ensino_fund","had_ensino_medio_1_ano","had_ensino_medio_2_ano",
                        "had_ensino_medio_3_ano","had_ensino_medio_4_ano","had_ensino_medio_nao_seriado","had_ensino_medio")

had_2010$regiao <- NULL
had_2010$cod_uf <- NULL
#Trocar ordem das colunas 

had_2010 <- had_2010 %>% relocate(had_educacao_infantil, .after = rede) %>% relocate(had_ensino_fund, .before = had_ensino_fund_1_ano) 
had_2010 <- had_2010 %>% relocate(had_ensino_fund_anos_iniciais, .after = had_ensino_fund) %>% relocate(had_ensino_fund_anos_finais, .after = had_ensino_fund_anos_iniciais) %>% relocate(had_ensino_medio, .after = had_ensino_fund_9_ano)

had <- rbind(had_01,had_2016,had_02,had_2010)

had$rede <- arrumar(had$rede)
had$rede <- arrumar_cons(had$rede)
had$localizacao <- arrumar_cons(had$localizacao)
had$localizacao <- arrumar(had$localizacao)
had$sigla_uf <- sigla_uf(had$sigla_uf)

had$rede <- str_replace_all(had$rede,"publico","publica")
had$rede <- str_replace_all(had$rede,"particular","privada")

## Taxa de distorção idade - série ##

tdi_2020 <- read_excel("TDI_BRASIL_REGIOES_UFS_2020.xlsx")
tdi_2020 <- tdi_2020[-c(1:116,595:596),]

tdi_2019 <- read_excel("TDI_BRASIL_REGIOES_UFS_2019.xlsx")
tdi_2019 <- tdi_2019[-c(1:116,595:596),]

tdi_2018 <- read_excel("TDI_BRASIL_REGIOES_UFS_2018.xlsx")
tdi_2018 <- tdi_2018[-c(1:116,594:595),]

tdi_2017 <- read_excel("TDI_BRASIL_REGIOES_UFS_2017.xlsx")
tdi_2017 <- tdi_2017[-c(1:44,168:185,347:364,436:453,508:525,594:595),]

tdi_2016 <- read_excel("TDI_UFS_2016.xlsx") #Coluna regiao a partir daqui
tdi_2016 <- tdi_2016[-c(1:8,485:486),]

tdi_2015 <- read_excel("TDI_UFS_2015.xlsx") #Coluna cod_uf e depois sigla_uf 
tdi_2015 <- tdi_2015[-c(1:8,487:488),]

tdi_2014 <- read_excel("TDI UF - 2014.xls") #sem a coluna cod_uf a partir daqui
tdi_2014 <- tdi_2014[-c(1:8,486),]

tdi_2013 <- read_excel("TDI UF - 2013.xls")
tdi_2013 <- tdi_2013[-c(1:8,487),]

tdi_2012 <- read_excel("tdi_ufs_2012.xls")
tdi_2012 <- tdi_2012[-c(1:7),]

tdi_2011 <- read_excel("tdi_ufs_2011.xls")
tdi_2011 <- tdi_2011[-c(1:7,486:487),]

tdi_2010 <- read_excel("DADOS TDI UF - 2010.xls") # Colunas Total Fundamental, Anos Iniciais e Finais diferentes
tdi_2010 <- tdi_2010[-c(1:7,482),]

tdi_2009 <- read_excel("DADOS TDI UF - 2009.xls")  
tdi_2009 <- tdi_2009[-c(1:7,481:482),]

tdi_2008 <- read_excel("TDI UFS 2008.xls")
tdi_2008 <- tdi_2008[-c(1:7,479:480),]

tdi_2007 <- read_excel("TDI UFS 2007.xls")
tdi_2007 <- tdi_2007[-c(1:7,477:478),]

tdi_2006 <- read_excel("TDI06_UF 2006.xls")    #Coluna Rede primeiro e depois localização
tdi_2006 <- tdi_2006[-c(1:9,480),]

#Juntando os dados
tdi_01 <- rbind(tdi_2020,tdi_2019,tdi_2018,tdi_2017)

colnames(tdi_01) <- c("ano","sigla_uf","localizacao","rede","tdi_ensino_fund","tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais","tdi_ensino_fund_1_ano",
                      "tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano","tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano",
                      "tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_medio","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano",
                      "tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano")

colnames(tdi_2016) <- c("ano","regiao","sigla_uf","localizacao","rede","tdi_ensino_fund","tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais","tdi_ensino_fund_1_ano",
                      "tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano","tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano",
                      "tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_medio","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano",
                      "tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano")

tdi_2016$regiao <- NULL

colnames(tdi_2015) <- c("ano","regiao","cod_uf","sigla_uf","localizacao","rede","tdi_ensino_fund","tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais","tdi_ensino_fund_1_ano",
                        "tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano","tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano",
                        "tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_medio","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano",
                        "tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano")
tdi_2015$regiao <- NULL
tdi_2015$cod_uf <- NULL

tdi_02 <- rbind(tdi_2014,tdi_2013,tdi_2012,tdi_2011)

colnames(tdi_02) <- c("ano","regiao","sigla_uf","localizacao","rede","tdi_ensino_fund","tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais","tdi_ensino_fund_1_ano",
                        "tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano","tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano",
                        "tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_medio","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano",
                        "tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano")

tdi_02$regiao <- NULL

tdi_03 <- rbind(tdi_2010,tdi_2009,tdi_2008,tdi_2007)

colnames(tdi_03) <- c("ano","regiao","sigla_uf","localizacao","rede","tdi_ensino_fund_1_ano",
                        "tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano","tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano",
                        "tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais","tdi_ensino_fund","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano",
                        "tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano","tdi_ensino_medio")
tdi_03$regiao <- NULL
tdi_03 <- tdi_03 %>% relocate(tdi_ensino_fund, .before = tdi_ensino_fund_1_ano) 
tdi_03 <- tdi_03 %>% relocate(tdi_ensino_fund_anos_iniciais, .after = tdi_ensino_fund) %>% relocate(tdi_ensino_fund_anos_finais, .after = tdi_ensino_fund_anos_iniciais) %>% relocate(tdi_ensino_medio, .after = tdi_ensino_fund_9_ano)

colnames(tdi_2006) <- c("ano","regiao","sigla_uf","rede","localizacao","tdi_ensino_fund","tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais","tdi_ensino_fund_1_ano",
                        "tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano","tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano",
                        "tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_medio","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano",
                        "tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano")

tdi_2006$regiao <- NULL
tdi_2006 <- tdi_2006 %>% relocate(localizacao, .before = rede) 

tdi <- rbind(tdi_01,tdi_2016,tdi_2015,tdi_02,tdi_03,tdi_2006)

tdi$rede <- arrumar(tdi$rede)
tdi$rede <- arrumar_cons(tdi$rede)
tdi$localizacao <- arrumar_cons(tdi$localizacao)
tdi$localizacao <- arrumar(tdi$localizacao)
tdi$sigla_uf <- sigla_uf(tdi$sigla_uf)

tdi$rede <- str_replace_all(tdi$rede,"publico","publica")
tdi$rede <- str_replace_all(tdi$rede,"particular","privada")

######## TABELA TAXAS DE RENDIMENTO ########

tx_2019 <- read_excel("tx_rend_brasil_regioes_ufs_2019.xlsx")
tx_2019 <- tx_2019[-c(1:116,595:596),]

tx_2018 <- read_excel("TX_REND_BRASIL_REGIOES_UFS_2018.xlsx")
tx_2018 <- tx_2018[-c(1:44,168:185,347:364,436:453,508:525,595:596),]

tx_2017 <- read_excel("TX_REND_BRASIL_REGIOES_UFS_2017.xlsx")
tx_2017 <- tx_2017[-c(1:44,168:185,347:364,436:453,508:525,595:596),]

tx_2016 <- read_excel("TX_REND_UFS_2016.xlsx") 
tx_2016 <- tx_2016[-c(1:8,487:488),]
tx_2016$...2 <- NULL

tx_2015 <- read_excel("TX_REND_UFS_2015.xlsx") 
tx_2015 <- tx_2015[-c(1:9,487:490),]

tx_2014 <- read_excel("TAXAS RENDIMENTOS UF 2014.xlsx") 
tx_2014 <- tx_2014[-c(1:8,484:487),]

tx_2013 <- read_excel("TAXAS RENDIMENTOS UF 2013.xlsx")
tx_2013 <- tx_2013[-c(1:8,484:487),]

tx_2012 <- read_excel("tx_rendimento_UFs_2012.xlsx")
tx_2012 <- tx_2012[-c(1:8,484:487),]

tx_2011 <- read_excel("tx_rendimento_uf_2011.xls")
tx_2011 <- tx_2011[-c(1:8,484:487),]

tx_2010 <- read_excel("TAXAS RENDIMENTO UF 2010.xls")  #Anos iniciais e finais no final
tx_2010 <- tx_2010[-c(1:9,482:485),]

tx_2009 <- read_excel("TAXAS RENDIMENTO UF 2009.xls") 
tx_2009 <- tx_2009[-c(1:8,482:485),]

tx_2008 <- read_excel("TAXAS RENDIMENTO UF 2008.xls")
tx_2008 <- tx_2008[-c(1:8,479:482),]

tx_2007 <- read_excel("TX RENDIMENTO UFS 2007.xls")
tx_2007 <- tx_2007[-c(1:9,479:482),]
tx_2007$`Ministério da Educação` <- NULL


#      JUNTANDO AS BASES E RENOMEANDO COLUNAS     #

tx_rend_01 <- rbind(tx_2019,tx_2018,tx_2017)

colnames(tx_rend_01) <- c("ano","sigla_uf","localizacao","rede","taxa_aprov_ensino_fund","taxa_aprov_ensino_fund_anos_iniciais","taxa_aprov_ensino_fund_anos_finais","taxa_aprov_ensino_fund_1_ano",
                          "taxa_aprov_ensino_fund_2_ano","taxa_aprov_ensino_fund_3_ano","taxa_aprov_ensino_fund_4_ano","taxa_aprov_ensino_fund_5_ano","taxa_aprov_ensino_fund_6_ano","taxa_aprov_ensino_fund_7_ano",
                          "taxa_aprov_ensino_fund_8_ano","taxa_aprov_ensino_fund_9_ano","taxa_aprov_ensino_medio","taxa_aprov_ensino_medio_1_ano","taxa_aprov_ensino_medio_2_ano",
                          "taxa_aprov_ensino_medio_3_ano","taxa_aprov_ensino_medio_4_ano","taxa_aprov_ensino_medio_nao_seriado","taxa_reprov_ensino_fund","taxa_reprov_ensino_fund_anos_iniciais","taxa_reprov_ensino_fund_anos_finais","taxa_reprov_ensino_fund_1_ano",
                          "taxa_reprov_ensino_fund_2_ano","taxa_reprov_ensino_fund_3_ano","taxa_reprov_ensino_fund_4_ano","taxa_reprov_ensino_fund_5_ano","taxa_reprov_ensino_fund_6_ano","taxa_reprov_ensino_fund_7_ano",
                          "taxa_reprov_ensino_fund_8_ano","taxa_reprov_ensino_fund_9_ano","taxa_reprov_ensino_medio","taxa_reprov_ensino_medio_1_ano","taxa_reprov_ensino_medio_2_ano",
                          "taxa_reprov_ensino_medio_3_ano","taxa_reprov_ensino_medio_4_ano","taxa_reprov_ensino_medio_nao_seriado","taxa_aband_ensino_fund","taxa_aband_ensino_fund_anos_iniciais","taxa_aband_ensino_fund_anos_finais","taxa_aband_ensino_fund_1_ano",
                          "taxa_aband_ensino_fund_2_ano","taxa_aband_ensino_fund_3_ano","taxa_aband_ensino_fund_4_ano","taxa_aband_ensino_fund_5_ano","taxa_aband_ensino_fund_6_ano","taxa_aband_ensino_fund_7_ano",
                          "taxa_aband_ensino_fund_8_ano","taxa_aband_ensino_fund_9_ano","taxa_aband_ensino_medio","taxa_aband_ensino_medio_1_ano","taxa_aband_ensino_medio_2_ano",
                          "taxa_aband_ensino_medio_3_ano","taxa_aband_ensino_medio_4_ano","taxa_aband_ensino_medio_nao_seriado")

colnames(tx_2016) <- c("ano","sigla_uf","localizacao","rede","taxa_aprov_ensino_fund","taxa_aprov_ensino_fund_anos_iniciais","taxa_aprov_ensino_fund_anos_finais","taxa_aprov_ensino_fund_1_ano",
                          "taxa_aprov_ensino_fund_2_ano","taxa_aprov_ensino_fund_3_ano","taxa_aprov_ensino_fund_4_ano","taxa_aprov_ensino_fund_5_ano","taxa_aprov_ensino_fund_6_ano","taxa_aprov_ensino_fund_7_ano",
                          "taxa_aprov_ensino_fund_8_ano","taxa_aprov_ensino_fund_9_ano","taxa_aprov_ensino_medio","taxa_aprov_ensino_medio_1_ano","taxa_aprov_ensino_medio_2_ano",
                          "taxa_aprov_ensino_medio_3_ano","taxa_aprov_ensino_medio_4_ano","taxa_aprov_ensino_medio_nao_seriado","taxa_reprov_ensino_fund","taxa_reprov_ensino_fund_anos_iniciais","taxa_reprov_ensino_fund_anos_finais","taxa_reprov_ensino_fund_1_ano",
                          "taxa_reprov_ensino_fund_2_ano","taxa_reprov_ensino_fund_3_ano","taxa_reprov_ensino_fund_4_ano","taxa_reprov_ensino_fund_5_ano","taxa_reprov_ensino_fund_6_ano","taxa_reprov_ensino_fund_7_ano",
                          "taxa_reprov_ensino_fund_8_ano","taxa_reprov_ensino_fund_9_ano","taxa_reprov_ensino_medio","taxa_reprov_ensino_medio_1_ano","taxa_reprov_ensino_medio_2_ano",
                          "taxa_reprov_ensino_medio_3_ano","taxa_reprov_ensino_medio_4_ano","taxa_reprov_ensino_medio_nao_seriado","taxa_aband_ensino_fund","taxa_aband_ensino_fund_anos_iniciais","taxa_aband_ensino_fund_anos_finais","taxa_aband_ensino_fund_1_ano",
                          "taxa_aband_ensino_fund_2_ano","taxa_aband_ensino_fund_3_ano","taxa_aband_ensino_fund_4_ano","taxa_aband_ensino_fund_5_ano","taxa_aband_ensino_fund_6_ano","taxa_aband_ensino_fund_7_ano",
                          "taxa_aband_ensino_fund_8_ano","taxa_aband_ensino_fund_9_ano","taxa_aband_ensino_medio","taxa_aband_ensino_medio_1_ano","taxa_aband_ensino_medio_2_ano",
                          "taxa_aband_ensino_medio_3_ano","taxa_aband_ensino_medio_4_ano","taxa_aband_ensino_medio_nao_seriado")

tx_rend_02 <- rbind(tx_2015,tx_2014,tx_2013,tx_2012,tx_2011)

colnames(tx_rend_02) <- c("ano","sigla_uf","localizacao","rede","taxa_aprov_ensino_fund","taxa_aprov_ensino_fund_anos_iniciais","taxa_aprov_ensino_fund_anos_finais","taxa_aprov_ensino_fund_1_ano",
                          "taxa_aprov_ensino_fund_2_ano","taxa_aprov_ensino_fund_3_ano","taxa_aprov_ensino_fund_4_ano","taxa_aprov_ensino_fund_5_ano","taxa_aprov_ensino_fund_6_ano","taxa_aprov_ensino_fund_7_ano",
                          "taxa_aprov_ensino_fund_8_ano","taxa_aprov_ensino_fund_9_ano","taxa_aprov_ensino_medio","taxa_aprov_ensino_medio_1_ano","taxa_aprov_ensino_medio_2_ano",
                          "taxa_aprov_ensino_medio_3_ano","taxa_aprov_ensino_medio_4_ano","taxa_aprov_ensino_medio_nao_seriado","taxa_reprov_ensino_fund","taxa_reprov_ensino_fund_anos_iniciais","taxa_reprov_ensino_fund_anos_finais","taxa_reprov_ensino_fund_1_ano",
                          "taxa_reprov_ensino_fund_2_ano","taxa_reprov_ensino_fund_3_ano","taxa_reprov_ensino_fund_4_ano","taxa_reprov_ensino_fund_5_ano","taxa_reprov_ensino_fund_6_ano","taxa_reprov_ensino_fund_7_ano",
                          "taxa_reprov_ensino_fund_8_ano","taxa_reprov_ensino_fund_9_ano","taxa_reprov_ensino_medio","taxa_reprov_ensino_medio_1_ano","taxa_reprov_ensino_medio_2_ano",
                          "taxa_reprov_ensino_medio_3_ano","taxa_reprov_ensino_medio_4_ano","taxa_reprov_ensino_medio_nao_seriado","taxa_aband_ensino_fund","taxa_aband_ensino_fund_anos_iniciais","taxa_aband_ensino_fund_anos_finais","taxa_aband_ensino_fund_1_ano",
                          "taxa_aband_ensino_fund_2_ano","taxa_aband_ensino_fund_3_ano","taxa_aband_ensino_fund_4_ano","taxa_aband_ensino_fund_5_ano","taxa_aband_ensino_fund_6_ano","taxa_aband_ensino_fund_7_ano",
                          "taxa_aband_ensino_fund_8_ano","taxa_aband_ensino_fund_9_ano","taxa_aband_ensino_medio","taxa_aband_ensino_medio_1_ano","taxa_aband_ensino_medio_2_ano",
                          "taxa_aband_ensino_medio_3_ano","taxa_aband_ensino_medio_4_ano","taxa_aband_ensino_medio_nao_seriado")

tx_rend_03 <- rbind(tx_2010,tx_2009,tx_2008)

colnames(tx_rend_03) <- c("ano","sigla_uf","localizacao","rede","taxa_aprov_ensino_fund_1_ano",
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

colnames(tx_2007) <- c("ano","sigla_uf","localizacao","rede","taxa_aprov_ensino_fund_1_ano",
                          "taxa_aprov_ensino_fund_2_ano","taxa_aprov_ensino_fund_3_ano","taxa_aprov_ensino_fund_4_ano","taxa_aprov_ensino_fund_5_ano","taxa_aprov_ensino_fund_6_ano","taxa_aprov_ensino_fund_7_ano",
                          "taxa_aprov_ensino_fund_8_ano","taxa_aprov_ensino_fund_9_ano","taxa_aprov_ensino_fund_anos_iniciais","taxa_aprov_ensino_fund_anos_finais","taxa_aprov_ensino_fund","taxa_aprov_ensino_medio_1_ano","taxa_aprov_ensino_medio_2_ano",
                          "taxa_aprov_ensino_medio_3_ano","taxa_aprov_ensino_medio_4_ano","taxa_aprov_ensino_medio_nao_seriado","taxa_aprov_ensino_medio","taxa_reprov_ensino_fund_1_ano",
                          "taxa_reprov_ensino_fund_2_ano","taxa_reprov_ensino_fund_3_ano","taxa_reprov_ensino_fund_4_ano","taxa_reprov_ensino_fund_5_ano","taxa_reprov_ensino_fund_6_ano","taxa_reprov_ensino_fund_7_ano",
                          "taxa_reprov_ensino_fund_8_ano","taxa_reprov_ensino_fund_9_ano","taxa_reprov_ensino_fund_anos_iniciais","taxa_reprov_ensino_fund_anos_finais","taxa_reprov_ensino_fund","taxa_reprov_ensino_medio_1_ano","taxa_reprov_ensino_medio_2_ano",
                          "taxa_reprov_ensino_medio_3_ano","taxa_reprov_ensino_medio_4_ano","taxa_reprov_ensino_medio_nao_seriado","taxa_reprov_ensino_medio","taxa_aband_ensino_fund_1_ano",
                          "taxa_aband_ensino_fund_2_ano","taxa_aband_ensino_fund_3_ano","taxa_aband_ensino_fund_4_ano","taxa_aband_ensino_fund_5_ano","taxa_aband_ensino_fund_6_ano","taxa_aband_ensino_fund_7_ano",
                          "taxa_aband_ensino_fund_8_ano","taxa_aband_ensino_fund_9_ano","taxa_aband_ensino_fund_anos_iniciais","taxa_aband_ensino_fund_anos_finais","taxa_aband_ensino_fund","taxa_aband_ensino_medio_1_ano","taxa_aband_ensino_medio_2_ano",
                          "taxa_aband_ensino_medio_3_ano","taxa_aband_ensino_medio_4_ano","taxa_aband_ensino_medio_nao_seriado","taxa_aband_ensino_medio")

tx_2007 <- tx_2007 %>% relocate(taxa_aprov_ensino_fund, .before = taxa_aprov_ensino_fund_1_ano) 
tx_2007 <- tx_2007 %>% relocate(taxa_aprov_ensino_fund_anos_iniciais, .after = taxa_aprov_ensino_fund) %>% relocate(taxa_aprov_ensino_fund_anos_finais, .after = taxa_aprov_ensino_fund_anos_iniciais) %>% relocate(taxa_aprov_ensino_medio, .after = taxa_aprov_ensino_fund_9_ano)
tx_2007 <- tx_2007 %>% relocate(taxa_reprov_ensino_fund, .before = taxa_reprov_ensino_fund_1_ano) 
tx_2007 <- tx_2007 %>% relocate(taxa_reprov_ensino_fund_anos_iniciais, .after = taxa_reprov_ensino_fund) %>% relocate(taxa_reprov_ensino_fund_anos_finais, .after = taxa_reprov_ensino_fund_anos_iniciais) %>% relocate(taxa_reprov_ensino_medio, .after = taxa_reprov_ensino_fund_9_ano)
tx_2007 <- tx_2007 %>% relocate(taxa_aband_ensino_fund, .before = taxa_aband_ensino_fund_1_ano) 
tx_2007 <- tx_2007 %>% relocate(taxa_aband_ensino_fund_anos_iniciais, .after = taxa_aband_ensino_fund) %>% relocate(taxa_aband_ensino_fund_anos_finais, .after = taxa_aband_ensino_fund_anos_iniciais) %>% relocate(taxa_aband_ensino_medio, .after = taxa_aband_ensino_fund_9_ano)


tx_rendimentos <- rbind(tx_rend_01,tx_2016,tx_rend_02,tx_rend_03,tx_2007)

# Padronização de palavras #
tx_rendimentos$rede <- arrumar(tx_rendimentos$rede)
tx_rendimentos$rede <- arrumar_cons(tx_rendimentos$rede)
tx_rendimentos$localizacao <- arrumar_cons(tx_rendimentos$localizacao)
tx_rendimentos$localizacao <- arrumar(tx_rendimentos$localizacao)
tx_rendimentos$sigla_uf <- sigla_uf(tx_rendimentos$sigla_uf)

tx_rendimentos$rede <- str_replace_all(tx_rendimentos$rede,"publico","publica")
tx_rendimentos$rede <- str_replace_all(tx_rendimentos$rede,"particular","privada")

## Taxa Não Resposta ##

tnr_2019 <- read_excel("tnr_brasil_regioes_ufs_2019.xlsx")
tnr_2019 <- tnr_2019[-c(1:116,595:597),]

tnr_2018 <- read_excel("TNR_BRASIL_REGIOES_UFS_2018.xlsx")
tnr_2018 <- tnr_2018[-c(1:44,168:185,347:364,436:453,508:525,595:597),]

tnr_2017 <- read_excel("TNR_BRASIL_REGIOES_UFS_2017.xlsx")
tnr_2017 <- tnr_2017[-c(1:44,168:185,347:364,436:453,508:525,595:596),]

tnr_2016 <- read_excel("TNR_UFS_2016.xlsx") #Coluna regiao
tnr_2016 <- tnr_2016[-c(1:8,487),]

tnr_2015 <- read_excel("TNR_UFS_2015.xlsx")
tnr_2015 <- tnr_2015[-c(1:9,487),]

tnr_2014 <- read_excel("TAXA NÃO-RESPOSTA UF 2014.xls")
tnr_2014 <- tnr_2014[-c(1:8,484),]

tnr_2013 <- read_excel("TAXA NÃO-RESPOSTA UF 2013.xls")
tnr_2013 <- tnr_2013[-c(1:8,484),]

tnr_2012 <- read_excel("TAXA NÃO-RESPOSTA UF 2012.xls")
tnr_2012 <- tnr_2012[-c(1:8,484),]

tnr_2011 <- read_excel("tx_nao_resposta_uf_2011.xls")
tnr_2011 <- tnr_2011[-c(1:8,484),]

tnr_2010 <- read_excel("TAXAS NÃO-RESPOSTA UF 2010.xls") #Anos iniciais e finais errados
tnr_2010 <- tnr_2010[-c(1:8,481),]

tnr_01 <- rbind(tnr_2019,tnr_2018,tnr_2017)

colnames(tnr_01) <- c("ano","sigla_uf","localizacao","rede","tnr_ensino_fund","tnr_ensino_fund_anos_iniciais","tnr_ensino_fund_anos_finais","tnr_ensino_fund_1_ano",
                      "tnr_ensino_fund_2_ano","tnr_ensino_fund_3_ano","tnr_ensino_fund_4_ano","tnr_ensino_fund_5_ano","tnr_ensino_fund_6_ano","tnr_ensino_fund_7_ano",
                      "tnr_ensino_fund_8_ano","tnr_ensino_fund_9_ano","tnr_ensino_medio","tnr_ensino_medio_1_ano","tnr_ensino_medio_2_ano",
                      "tnr_ensino_medio_3_ano","tnr_ensino_medio_4_ano","tnr_ensino_medio_nao_seriado")

colnames(tnr_2016) <- c("ano","regiao","sigla_uf","localizacao","rede","tnr_ensino_fund","tnr_ensino_fund_anos_iniciais","tnr_ensino_fund_anos_finais","tnr_ensino_fund_1_ano",
                      "tnr_ensino_fund_2_ano","tnr_ensino_fund_3_ano","tnr_ensino_fund_4_ano","tnr_ensino_fund_5_ano","tnr_ensino_fund_6_ano","tnr_ensino_fund_7_ano",
                      "tnr_ensino_fund_8_ano","tnr_ensino_fund_9_ano","tnr_ensino_medio","tnr_ensino_medio_1_ano","tnr_ensino_medio_2_ano",
                      "tnr_ensino_medio_3_ano","tnr_ensino_medio_4_ano","tnr_ensino_medio_nao_seriado")
tnr_2016$regiao <- NULL

tnr_02 <- rbind(tnr_2015,tnr_2014,tnr_2013,tnr_2012,tnr_2011)

colnames(tnr_02) <- c("ano","sigla_uf","localizacao","rede","tnr_ensino_fund","tnr_ensino_fund_anos_iniciais","tnr_ensino_fund_anos_finais","tnr_ensino_fund_1_ano",
                        "tnr_ensino_fund_2_ano","tnr_ensino_fund_3_ano","tnr_ensino_fund_4_ano","tnr_ensino_fund_5_ano","tnr_ensino_fund_6_ano","tnr_ensino_fund_7_ano",
                        "tnr_ensino_fund_8_ano","tnr_ensino_fund_9_ano","tnr_ensino_medio","tnr_ensino_medio_1_ano","tnr_ensino_medio_2_ano",
                        "tnr_ensino_medio_3_ano","tnr_ensino_medio_4_ano","tnr_ensino_medio_nao_seriado")

colnames(tnr_2010) <- c("ano","sigla_uf","localizacao","rede","tnr_ensino_fund_1_ano",
                        "tnr_ensino_fund_2_ano","tnr_ensino_fund_3_ano","tnr_ensino_fund_4_ano","tnr_ensino_fund_5_ano","tnr_ensino_fund_6_ano","tnr_ensino_fund_7_ano",
                        "tnr_ensino_fund_8_ano","tnr_ensino_fund_9_ano","tnr_ensino_fund_anos_iniciais","tnr_ensino_fund_anos_finais","tnr_ensino_fund","tnr_ensino_medio_1_ano","tnr_ensino_medio_2_ano",
                        "tnr_ensino_medio_3_ano","tnr_ensino_medio_4_ano","tnr_ensino_medio_nao_seriado","tnr_ensino_medio")

tnr_2010 <- tnr_2010 %>% relocate(tnr_ensino_fund, .before = tnr_ensino_fund_1_ano) 
tnr_2010 <- tnr_2010 %>% relocate(tnr_ensino_fund_anos_iniciais, .after = tnr_ensino_fund) %>% relocate(tnr_ensino_fund_anos_finais, .after = tnr_ensino_fund_anos_iniciais) %>% relocate(tnr_ensino_medio, .after = tnr_ensino_fund_9_ano)

tnr <- rbind(tnr_01,tnr_2016,tnr_02,tnr_2010)

#Padronização de palavras

tnr$rede <- arrumar(tnr$rede)
tnr$rede <- arrumar_cons(tnr$rede)
tnr$localizacao <- arrumar(tnr$localizacao)
tnr$localizacao <- arrumar_cons(tnr$localizacao)
tnr$sigla_uf <- sigla_uf(tnr$sigla_uf)

tnr$rede <- str_replace_all(tnr$rede,"publico","publica")
tnr$rede <- str_replace_all(tnr$rede,"particular","privada")

#####  TABELA PERCENTUAL DE DOCENTES COM CURSO SUPERIOR    #######

dsu_2020 <- read_excel("DSU_BRASIL_REGIOES_UFS_2020.xlsx")
dsu_2020 <- dsu_2020[-c(1:117,597:598),]

dsu_2019 <- read_excel("DSU_BRASIL_REGIOES_UFS_2019.xlsx")
dsu_2019 <- dsu_2019[-c(1:117,597:598),]

dsu_2018 <- read_excel("DSU_BRASIL_REGIOES_UFS_2018_ATUALIZADO.xlsx")
dsu_2018 <- dsu_2018[-c(1:117,597:598),]

dsu_2017 <- read_excel("DSU_BRASIL_REGIOES_UFS_2017.xlsx")
dsu_2017 <- dsu_2017[-c(1:45,169:186,348:365,438:455,510:527,597:598),]

dsu_2016 <- read_excel("DSU_UFS_2016.xlsx") #Coluna regiao
dsu_2016 <- dsu_2016[-c(1:9,489:490),]

dsu_2015 <- read_excel("DSU_UF_2015.xlsx") #Regiao, nome uf, cod uf daqui em diante
dsu_2015 <- dsu_2015[-c(1:9,488:489),]

dsu_2014 <- read_excel("DSU - UFS 2014.xls") 
dsu_2014 <- dsu_2014[-c(1:9,487),]

dsu_2013 <- read_excel("DSU - ESTADOS 2013.xls")
dsu_2013 <- dsu_2013[-c(1:9,488),]

dsu_2012 <- read_excel("DSU - ESTADOS 2012.xls")
dsu_2012 <- dsu_2012[-c(1:9,488),]

dsu_2011 <- read_excel("DSU - ESTADOS 2011.xls")
dsu_2011 <- dsu_2011[-c(1:9,488),]

dsu_01 <- rbind(dsu_2020,dsu_2019,dsu_2018,dsu_2017)

colnames(dsu_01) <- c("ano","sigla_uf","localizacao","rede","dsu_educ_infantil","dsu_educ_infantil_creche","dsu_educ_infantil_pre_escola","dsu_ensino_fund","dsu_ensino_fund_anos_iniciais"
                      ,"dsu_ensino_fund_anos_finais","dsu_ensino_medio","dsu_educacao_profissional","dsu_educacao_jovens_adultos",
                      "dsu_educacao_especial")

colnames(dsu_2016) <- c("ano","regiao","sigla_uf","localizacao","rede","dsu_educ_infantil","dsu_educ_infantil_creche","dsu_educ_infantil_pre_escola","dsu_ensino_fund","dsu_ensino_fund_anos_iniciais"
                      ,"dsu_ensino_fund_anos_finais","dsu_ensino_medio","dsu_educacao_profissional","dsu_educacao_jovens_adultos",
                      "dsu_educacao_especial")

dsu_2016$regiao <- NULL

dsu_02 <- rbind(dsu_2015,dsu_2014,dsu_2013,dsu_2012,dsu_2011)

colnames(dsu_02) <- c("ano","regiao","sigla_uf","cod_uf","localizacao","rede","dsu_educ_infantil","dsu_educ_infantil_creche","dsu_educ_infantil_pre_escola","dsu_ensino_fund","dsu_ensino_fund_anos_iniciais"
                      ,"dsu_ensino_fund_anos_finais","dsu_ensino_medio","dsu_educacao_profissional","dsu_educacao_jovens_adultos",
                      "dsu_educacao_especial")

dsu_02$regiao <- NULL
dsu_02$cod_uf <- NULL

dsu <- rbind(dsu_01,dsu_2016,dsu_02)

#Padronização de palavras

dsu$rede <- arrumar(dsu$rede)
dsu$rede <- arrumar_cons(dsu$rede)
dsu$localizacao <- arrumar(dsu$localizacao)
dsu$localizacao <- arrumar_cons(dsu$localizacao)
dsu$sigla_uf <- sigla_uf(dsu$sigla_uf)

dsu$rede <- str_replace_all(dsu$rede,"publico","publica")
dsu$rede <- str_replace_all(dsu$rede,"particular","privada")


##### TABELA ADEQUAÇÃO DA FORMAÇÃO DOCENTE ######

afd_2020 <- read_excel("AFD_BRASIL_REGIOES_UFS_2020.xlsx")
afd_2020 <- afd_2020[-c(1:118,598:602),]

afd_2019 <- read_excel("AFD_BRASIL_REGIOES_UFS_2019.xlsx")
afd_2019 <- afd_2019[-c(1:118,598:602),]

afd_2018 <- read_excel("AFD_BRASIL_REGIOES_UFS_2018.xlsx")
afd_2018 <- afd_2018[-c(1:118,598:602),]

afd_2017 <- read_excel("AFD_BRASIL_REGIOES_UFS_2017.xlsx")
afd_2017 <- afd_2017[-c(1:46,170:187,349:366,439:456,511:528,598:602),]

afd_2016 <- read_excel("AFD_UFS_2016.xlsx") #Coluna Regiao a partir daqui
afd_2016 <- afd_2016[-c(1:10,490:494),]

afd_2015 <- read_excel("AFD_UFS_2015.xlsx")
afd_2015 <- afd_2015[-c(1:10,489:493),]

afd_2014 <- read_excel("AFD_UFS_2014.xlsx")
afd_2014 <- afd_2014[-c(1:10,486:490),]

afd_2013 <- read_excel("AFD_UFS_2013.xlsx")
afd_2013 <- afd_2013[-c(1:10,487:491),]

afd_01 <- rbind(afd_2020,afd_2019,afd_2018,afd_2017)

afd_02 <- rbind(afd_2016,afd_2015,afd_2014,afd_2013)

colnames(afd_01) <- c("ano","sigla_uf","localizacao","rede","afd_educacao_infantil_grupo_1","afd_educacao_infantil_grupo_2",
                   "afd_educacao_infantil_grupo_3","afd_educacao_infantil_grupo_4","afd_educacao_infantil_grupo_5","afd_ensino_fund_grupo_1","afd_ensino_fund_grupo_2","afd_ensino_fund_grupo_3",
                   "afd_ensino_fund_grupo_4","afd_ensino_fund_grupo_5","afd_ensino_fund_anos_iniciais_grupo_1","afd_ensino_fund_anos_iniciais_grupo_2","afd_ensino_fund_anos_iniciais_grupo_3","afd_ensino_fund_anos_iniciais_grupo_4",
                   "afd_ensino_fund_anos_iniciais_grupo_5","afd_ensino_fund_anos_finais_grupo_1","afd_ensino_fund_anos_finais_grupo_2","afd_ensino_fund_anos_finais_grupo_3","afd_ensino_fund_anos_finais_grupo_4",
                   "afd_ensino_fund_anos_finais_grupo_5","afd_ensino_medio_grupo_1","afd_ensino_medio_grupo_2","afd_ensino_medio_grupo_3","afd_ensino_medio_grupo_4","afd_ensino_medio_grupo_5","afd_eja_fundamental_grupo_1","afd_eja_fundamental_grupo_2",
                   "afd_eja_fundamental_grupo_3","afd_eja_fundamental_grupo_4","afd_eja_fundamental_grupo_5","afd_eja_medio_grupo_1","afd_eja_medio_grupo_2","afd_eja_medio_grupo_3","afd_eja_medio_grupo_4","afd_eja_medio_grupo_5")

colnames(afd_02) <- c("ano","regiao","sigla_uf","localizacao","rede","afd_educacao_infantil_grupo_1","afd_educacao_infantil_grupo_2",
                      "afd_educacao_infantil_grupo_3","afd_educacao_infantil_grupo_4","afd_educacao_infantil_grupo_5","afd_ensino_fund_grupo_1","afd_ensino_fund_grupo_2","afd_ensino_fund_grupo_3",
                      "afd_ensino_fund_grupo_4","afd_ensino_fund_grupo_5","afd_ensino_fund_anos_iniciais_grupo_1","afd_ensino_fund_anos_iniciais_grupo_2","afd_ensino_fund_anos_iniciais_grupo_3","afd_ensino_fund_anos_iniciais_grupo_4",
                      "afd_ensino_fund_anos_iniciais_grupo_5","afd_ensino_fund_anos_finais_grupo_1","afd_ensino_fund_anos_finais_grupo_2","afd_ensino_fund_anos_finais_grupo_3","afd_ensino_fund_anos_finais_grupo_4",
                      "afd_ensino_fund_anos_finais_grupo_5","afd_ensino_medio_grupo_1","afd_ensino_medio_grupo_2","afd_ensino_medio_grupo_3","afd_ensino_medio_grupo_4","afd_ensino_medio_grupo_5","afd_eja_fundamental_grupo_1","afd_eja_fundamental_grupo_2",
                      "afd_eja_fundamental_grupo_3","afd_eja_fundamental_grupo_4","afd_eja_fundamental_grupo_5","afd_eja_medio_grupo_1","afd_eja_medio_grupo_2","afd_eja_medio_grupo_3","afd_eja_medio_grupo_4","afd_eja_medio_grupo_5")

afd_02$regiao <- NULL

afd <- rbind(afd_01,afd_02)

#Padronização de palavras

afd$rede <- arrumar(afd$rede)
afd$rede <- arrumar_cons(afd$rede)
afd$localizacao <- arrumar(afd$localizacao)
afd$localizacao <- arrumar_cons(afd$localizacao)
afd$sigla_uf <- sigla_uf(afd$sigla_uf)

afd$rede <- str_replace_all(afd$rede,"publico","publica")
afd$rede <- str_replace_all(afd$rede,"particular","privada")

###### TABELA REGULARIDADE DO CORPO DOCENTE  ########

ird_2020 <- read_excel("IRD_BRASIL_REGIOES_UFS_2020.xlsx")
ird_2020 <- ird_2020[-c(1:117,597:601),]

ird_2019 <- read_excel("IRD_BRASIL_REGIOES_UFS_2019.xlsx")
ird_2019 <- ird_2019[-c(1:117,597:601),]

ird_2018 <- read_excel("IRD_BRASIL_REGIOES_UFS_2018.xlsx")
ird_2018 <- ird_2018[-c(1:117,596:600),]

ird_2017 <- read_excel("IRD_BRASIL_REGIOES_UFS_2017.xlsx")
ird_2017 <- ird_2017[-c(1:45,168:185,347:364,437:454,508:525,595:599),]

ird_2016 <- read_excel("IRD_UFS_2016.xlsx") #Coluna região a partir daqui
ird_2016 <- ird_2016[-c(1:9,487:491),]

ird_2015 <- read_excel("IRD_UFS_2015.xlsx")
ird_2015 <- ird_2015[-c(1:9,487:491),]

ird_2014 <- read_excel("IRD_UFS_2014.xlsx")
ird_2014 <- ird_2014[-c(1:9,485:489),]

ird_2013 <- read_excel("IRD_UFS_2013.xlsx")
ird_2013 <- ird_2013[-c(1:9,483:487),]

ird_01 <- rbind(ird_2020,ird_2019,ird_2018,ird_2017)
ird_02 <- rbind(ird_2016,ird_2015,ird_2014,ird_2013)

colnames(ird_01) <- c("ano","sigla_uf","localizacao","rede","ird_baixa_regularidade","ird_media_baixa","ird_media_alta","ird_alta")
colnames(ird_02) <- c("ano","regiao","sigla_uf","localizacao","rede","ird_baixa_regularidade","ird_media_baixa","ird_media_alta","ird_alta")
ird_02$regiao <- NULL

ird <- rbind(ird_01,ird_02)
#Padronização de palavras

ird$rede <- arrumar(ird$rede)
ird$rede <- arrumar_cons(ird$rede)
ird$localizacao <- arrumar(ird$localizacao)
ird$localizacao <- arrumar_cons(ird$localizacao)
ird$sigla_uf <- sigla_uf(ird$sigla_uf)

ird$rede <- str_replace_all(ird$rede,"publico","publica")
ird$rede <- str_replace_all(ird$rede,"particular","privada")

####### TABELA ESFORÇO DOCENTE ########

ied_2020 <- read_excel("IED_BRASIL_REGIOES_UFS_2020.xlsx")
ied_2020 <- ied_2020[-c(1:118,597:601),]

ied_2019 <- read_excel("IED_BRASIL_REGIOES_UFS_2019.xlsx")
ied_2019 <- ied_2019[-c(1:118,597:601),]

ied_2018 <- read_excel("IED_BRASIL_REGIOES_UFS_2018.xlsx")
ied_2018 <- ied_2018[-c(1:118,597:601),]

ied_2017 <- read_excel("IED_BRASIL_REGIOES_UFS_2017.xlsx")
ied_2017 <- ied_2017[-c(1:46,170:187,349:366,438:455,510:527,597:601),]

ied_2016 <- read_excel("IED_UFS_2016.xlsx") #Coluna Região a partir daqui
ied_2016 <- ied_2016[-c(1:10,489:493),]

ied_2015 <- read_excel("IED_UFS_2015.xlsx")
ied_2015 <- ied_2015[-c(1:10,488:492),]

ied_2014 <- read_excel("IED_UFS_2014.xlsx")
ied_2014 <- ied_2014[-c(1:10,486:490),]

ied_2013 <- read_excel("IED_UFS_2013.xlsx")
ied_2013 <- ied_2013[-c(1:10,486:490),]

ied_01 <- rbind(ied_2020,ied_2019,ied_2018,ied_2017)
ied_02 <- rbind(ied_2016,ied_2015,ied_2014,ied_2013)

colnames(ied_01) <- c("ano","sigla_uf","localizacao","rede","ied_ensino_fund_nivel_1","ied_ensino_fund_nivel_2","ied_ensino_fund_nivel_3","ied_ensino_fund_nivel_4",
                   "ied_ensino_fund_nivel_5","ied_ensino_fund_nivel_6","ied_ensino_fund_anos_iniciais_nivel_1","ied_ensino_fund_anos_iniciais_nivel_2","ied_ensino_fund_anos_iniciais_nivel_3","ied_ensino_fund_anos_iniciais_nivel_4",
                   "ied_ensino_fund_anos_iniciais_nivel_5","ied_ensino_fund_anos_iniciais_nivel_6","ied_ensino_fund_anos_finais_nivel_1","ied_ensino_fund_anos_finais_nivel_2","ied_ensino_fund_anos_finais_nivel_3",
                   "ied_ensino_fund_anos_finais_nivel_4","ied_ensino_fund_anos_finais_nivel_5","ied_ensino_fund_anos_finais_nivel_6","ied_ensino_medio_nivel_1","ied_ensino_medio_nivel_2","ied_ensino_medio_nivel_3","ied_ensino_medio_nivel_4","ied_ensino_medio_nivel_5","ied_ensino_medio_nivel_6")

colnames(ied_02) <- c("ano","regiao","sigla_uf","localizacao","rede","ied_ensino_fund_nivel_1","ied_ensino_fund_nivel_2","ied_ensino_fund_nivel_3","ied_ensino_fund_nivel_4",
                      "ied_ensino_fund_nivel_5","ied_ensino_fund_nivel_6","ied_ensino_fund_anos_iniciais_nivel_1","ied_ensino_fund_anos_iniciais_nivel_2","ied_ensino_fund_anos_iniciais_nivel_3","ied_ensino_fund_anos_iniciais_nivel_4",
                      "ied_ensino_fund_anos_iniciais_nivel_5","ied_ensino_fund_anos_iniciais_nivel_6","ied_ensino_fund_anos_finais_nivel_1","ied_ensino_fund_anos_finais_nivel_2","ied_ensino_fund_anos_finais_nivel_3",
                      "ied_ensino_fund_anos_finais_nivel_4","ied_ensino_fund_anos_finais_nivel_5","ied_ensino_fund_anos_finais_nivel_6","ied_ensino_medio_nivel_1","ied_ensino_medio_nivel_2","ied_ensino_medio_nivel_3","ied_ensino_medio_nivel_4","ied_ensino_medio_nivel_5","ied_ensino_medio_nivel_6")

ied_02$regiao <- NULL
ied <- rbind(ied_01,ied_02)


ied$rede <- arrumar(ied$rede)
ied$rede <- arrumar_cons(ied$rede)
ied$localizacao <- arrumar(ied$localizacao)
ied$localizacao <- arrumar_cons(ied$localizacao)
ied$sigla_uf <- sigla_uf(ied$sigla_uf)

ied$rede <- str_replace_all(ied$rede,"publico","publica")
ied$rede <- str_replace_all(ied$rede,"particular","privada")

###### TABELA COMPLEXIDADE DE GESTÃO DA ESCOLA ######

icg_2020 <- read_excel("ICG_BRASIL_REGIOES_UFS_2020.xlsx")
icg_2020 <- icg_2020[-c(1:116,596:600),]

icg_2019 <- read_excel("ICG_BRASIL_REGIOES_UFS_2019.xlsx")
icg_2019 <- icg_2019[-c(1:116,596:600),]

icg_2018 <- read_excel("ICG_BRASIL_REGIOES_UFS_2018.xlsx")
icg_2018 <- icg_2018[-c(1:116,596:600),]

icg_2017 <- read_excel("ICG_BRASIL_REGIOES_UFS_2017.xlsx")
icg_2017 <- icg_2017[-c(1:44,168:185,347:364,437:454,509:526,596:600),]

icg_2016 <- read_excel("ICG_UFS_2016.xlsx") #Coluna região a partir daqui
icg_2016 <- icg_2016[-c(1:8,488:492),]

icg_2015 <- read_excel("ICG_UFS_2015.xlsx")
icg_2015 <- icg_2015[-c(1:8,487:491),]

icg_2014 <- read_excel("ICG_UFS_2014.xlsx")
icg_2014 <- icg_2014[-c(1:8,486:490),]

icg_2013 <- read_excel("ICG_UFS_2013.xlsx")
icg_2013 <- icg_2013[-c(1:8,487:491),]

icg_01 <- rbind(icg_2020,icg_2019,icg_2018,icg_2017)
icg_02 <- rbind(icg_2016,icg_2015,icg_2014,icg_2013)

colnames(icg_01) <- c("ano","sigla_uf","localizacao","rede","icg_nivel_1","icg_nivel_2","icg_nivel_3","icg_nivel_4","icg_nivel_5","icg_nivel_6")

colnames(icg_02) <- c("ano","regiao","sigla_uf","localizacao","rede","icg_nivel_1","icg_nivel_2","icg_nivel_3","icg_nivel_4","icg_nivel_5","icg_nivel_6")

icg_02$regiao <- NULL
icg <- rbind(icg_01,icg_02)

icg$rede <- arrumar(icg$rede)
icg$rede <- arrumar_cons(icg$rede)
icg$localizacao <- arrumar(icg$localizacao)
icg$localizacao <- arrumar_cons(icg$localizacao)
icg$sigla_uf <- sigla_uf(icg$sigla_uf)

icg$rede <- str_replace_all(icg$rede,"publico","publica")
icg$rede <- str_replace_all(icg$rede,"particular","privada")


## Juntando e terminando o processo de limpeza das bases ##

indicadores_01 <- full_join(atu,had, by= c("localizacao","rede","ano","sigla_uf"))

indicadores_02 <- full_join(indicadores_01,tdi, by= c("localizacao","rede","ano","sigla_uf"))

indicadores_03 <- full_join(indicadores_02,tx_rendimentos, by= c("localizacao","rede","ano","sigla_uf"))

indicadores_04 <- full_join(indicadores_03,tnr, by= c("localizacao","rede","ano","sigla_uf"))

indicadores_05 <- full_join(indicadores_04,dsu, by= c("localizacao","rede","ano","sigla_uf"))

indicadores_06 <- full_join(indicadores_05,afd, by= c("localizacao","rede","ano","sigla_uf"))

indicadores_07 <- full_join(indicadores_06,ird, by= c("localizacao","rede","ano","sigla_uf"))

indicadores_08 <- full_join(indicadores_07,ied, by= c("localizacao","rede","ano","sigla_uf"))

indicadores_09 <- full_join(indicadores_08,icg, by= c("localizacao","rede","ano","sigla_uf"))


indicadores <- indicadores_09 %>% arrange(sigla_uf,localizacao,rede,ano)
indicadores <- indicadores[-c(7142:7143),]
is.na(indicadores[5:215]) <- indicadores[5:215]=="--"

indicadores[,5:215] <- lapply(indicadores[5:215],as.numeric)

con <- file('UF.csv', encoding = "UTF-8")
write.csv(indicadores, file = con, row.names = FALSE, na = " ")


