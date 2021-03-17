####### TABELA MEDIA DE ALUNOS POR TURMA #########

#Baixando os dados

atu_2020 <- read_excel("ATU_MUNICIPIOS_2020.xlsx")
atu_2020 <- atu_2020[-c(1:8,66643:66645),]

atu_2019 <- read_excel("ATU_MUNICIPIOS_2019.xlsx")
atu_2019 <- atu_2019[-c(1:8,66690,66691,66692),] #Exclui linhas vazias

atu_2018 <- read_excel("ATU_MUNICIPIOS_2018.xlsx")
atu_2018 <- atu_2018[-c(1:8,66756,66757,66758),]

atu_2017 <- read_excel("ATU_MUNICIPIOS_2017.xlsx")
atu_2017 <- atu_2017[-c(1:8,66606,66607,66608),]

atu_2016 <- read_excel("ATU_MUNICIPIOS_2016.xlsx")
atu_2016 <- atu_2016[-c(1:8,66632,66633,66634),]

atu_2015 <- read_excel("ATU_MUNICIPIOS_2015.xlsx")
atu_2015 <- atu_2015[-c(1:9,66650,66651,66652),]

atu_2014 <- read_excel("MEDIA ALUNOS TURMA MUNICIPIOS 2014.xlsx")
atu_2014 <- atu_2014[-c(1:9,66707,66708),]

atu_2013 <- read_excel("MEDIA ALUNOS TURMA MUNICIPIOS 2013.xlsx")
atu_2013 <- atu_2013[-c(1:9,66715,66716),]

atu_2012 <- read_excel("media_alunos_turma_municipios_2012.xlsx")
atu_2012 <- atu_2012[-c(1:8,66708,66709),]

#Bases a partir de 2011 possuem duas planilhas em um mesmo arquivo excel 

atu_2011_plan1 <- read_excel("alunos_turma_municipios_2011.xls",sheet = 1)
atu_2011_plan2 <- read_excel("alunos_turma_municipios_2011.xls",sheet = 2)

atu_2011_plan1 <- atu_2011_plan1[-c(1:8,28297,28298),]    #Exclui linhas vazias
atu_2011_plan2 <- atu_2011_plan2[-c(1:8,38425,38426),]

atu_2011 <- rbind(atu_2011_plan1,atu_2011_plan2)


atu_2010_plan1 <- read_excel("media_alunos_turma_municipios_2010.xls",sheet = 1)
atu_2010_plan2 <- read_excel("media_alunos_turma_municipios_2010.xls",sheet = 2)

atu_2010_plan1 <- atu_2010_plan1[-c(1:8,28195,28196),]    #Exclui linhas vazias
atu_2010_plan2 <- atu_2010_plan2[-c(1:8,38400,38401),]

atu_2010 <- rbind(atu_2010_plan1,atu_2010_plan2)



atu_2009_plan1 <- read_excel("media_alunos_turma_municipios_2009.xls",sheet = 1)
atu_2009_plan2 <- read_excel("media_alunos_turma_municipios_2009.xls",sheet = 2)

atu_2009_plan1 <- atu_2009_plan1[-c(1:8,28138,28139),]    #Exclui linhas vazias
atu_2009_plan2 <- atu_2009_plan2[-c(1:8,38496,38497),]

atu_2009 <- rbind(atu_2009_plan1,atu_2009_plan2)


atu_2008_plan1 <- read_excel("media_alunos_turma_municipios_2008.xls",sheet = 1)
atu_2008_plan2 <- read_excel("media_alunos_turma_municipios_2008.xls",sheet = 2)

atu_2008_plan1 <- atu_2008_plan1[-c(1:8,28068,28069),]    #Exclui linhas vazias
atu_2008_plan2 <- atu_2008_plan2[-c(1:8,38632,38633),]

atu_2008 <- rbind(atu_2008_plan1,atu_2008_plan2)


atu_2007_plan1 <- read_excel("media_alunos_turma_municipios_2007.xls",sheet = 1)
atu_2007_plan2 <- read_excel("media_alunos_turma_municipios_2007.xls",sheet = 2)

atu_2007_plan1 <- atu_2007_plan1[-c(1:8,27970,27971),]    #Exclui linhas vazias
atu_2007_plan2 <- atu_2007_plan2[-c(1:8,38658,38659),]

atu_2007 <- rbind(atu_2007_plan1,atu_2007_plan2)


atu <- rbind(atu_2019,atu_2018,atu_2017,atu_2016,atu_2015,atu_2014,atu_2013,atu_2012,atu_2011,atu_2010,atu_2009,atu_2008,atu_2007)

colnames(atu) <- c("ano","regiao","uf","id_municipio","nm_municipio","localizacao","rede","atu_educacao_infantil","atu_educacao_infantil_creche",
                                      "atu_educacao_infantil_pre_escola","atu_ensino_fund","atu_ensino_fund_anos_iniciais","atu_ensino_fund_anos_finais","atu_ensino_fund_1_ano",
                                      "atu_ensino_fund_2_ano","atu_ensino_fund_3_ano","atu_ensino_fund_4_ano","atu_ensino_fund_5_ano","atu_ensino_fund_6_ano","atu_ensino_fund_7_ano",
                                      "atu_ensino_fund_8_ano","atu_ensino_fund_9_ano","atu_ensino_fund_turmas_unif","atu_ensino_medio","atu_ensino_medio_1_ano","atu_ensino_medio_2_ano",
                                      "atu_ensino_medio_3_ano","atu_ensino_medio_4_ano","atu_ensino_medio_nao_seriado")


atu <- atu[-c(2,3,5)] #Exclui regiao, uf e nm_municipio

# Palavras sem acento e minúsculas #
atu$rede <- arrumar(atu$rede)
atu$localizacao <- arrumar_cons(atu$localizacao)

atu$rede <- str_replace_all(atu$rede,"publico","publica")
atu$rede <- str_replace_all(atu$rede,"particular","privada")


####### TABELA MÉDIA HORAS-AULA DIARIA ########

setwd("C:/Users/user/Desktop/bases/inep/media_horas")

had_2020 <- read_excel("HAD_MUNICIPIOS_2020.xlsx")
had_2020 <- had_2020[-c(1:8,65640:65642),]

had_2019 <- read_excel("HAD_MUNICIPIOS_2019.xlsx")
had_2019 <- had_2019[-c(1:8,65696,65697,65698),]

had_2018 <- read_excel("HAD_MUNICIPIOS_2018.xlsx")
had_2018 <- had_2018[-c(1:8,65781,65782,65783),]


had_2017 <- read_excel("HAD_MUNICIPIOS_2017.xlsx")
had_2017 <- had_2017[-c(1:8,65855,65856,65857),]

had_2016 <- read_excel("HAD_MUNICIPIOS_2016.xlsx")
had_2016 <- had_2016[-c(1:8,65821,65822,65823),]

## Base de 2015
# Veio com uma coluna a mais que as outras
had_2015 <- read_excel("HAD_MUNICIPIOS_2015.xlsx")
had_2015 <- had_2015[-c(1:8,66548,66549,66550),-c(3)]

colnames(had_2015) <- c("ano","regiao","uf","id_municipio","nm_municipio","localizacao","rede","had_educacao_infantil","had_educacao_infantil_creche",
                        "had_educacao_infantil_pre_escola","had_ensino_fund","had_ensino_fund_anos_iniciais","had_ensino_fund_anos_finais","had_ensino_fund_1_ano",
                        "had_ensino_fund_2_ano","had_ensino_fund_3_ano","had_ensino_fund_4_ano","had_ensino_fund_5_ano","had_ensino_fund_6_ano","had_ensino_fund_7_ano",
                        "had_ensino_fund_8_ano","had_ensino_fund_9_ano","had_ensino_medio","had_ensino_medio_1_ano","had_ensino_medio_2_ano",
                        "had_ensino_medio_3_ano","had_ensino_medio_4_ano","had_ensino_medio_nao_seriado")



had_2014 <- read_excel("MÉDIA HORAS-AULA MUNICÍPIOS  2014.xlsx")
had_2014 <- had_2014[-c(1:8,66706,66707),]

had_2013 <- read_excel("MÉDIA HORAS-AULA MUNICÍPIOS  2013.xlsx")
had_2013 <- had_2013[-c(1:8,66714,66715),]

had_2012 <- read_excel("horas_aula_municipios_2012.xlsx")
had_2012 <- had_2012[-c(1:7,66707,66708),]

had_2011_plan1 <- read_excel("horas_aula_municipios_2011.xls",sheet = 1)
had_2011_plan2 <- read_excel("horas_aula_municipios_2011.xls",sheet = 2)

had_2011_plan1 <- had_2011_plan1[-c(1:7,28296,28297),]    #Exclui linhas vazias
had_2011_plan2 <- had_2011_plan2[-c(1:7,38424,38425),]

had_2011 <- rbind(had_2011_plan1,had_2011_plan2)



had_2010_plan1 <- read_excel("MÉDIA HORAS-AULA MUNICÍPIOS  2010.xls",sheet = 1)
had_2010_plan2 <- read_excel("MÉDIA HORAS-AULA MUNICÍPIOS  2010.xls",sheet = 2)

had_2010_plan1 <- had_2010_plan1[-c(1:7,28194),]    #Exclui linhas vazias
had_2010_plan2 <- had_2010_plan2[-c(1:7,38399),]

had_2010 <- rbind(had_2010_plan1,had_2010_plan2)

#      JUNTANDO AS BASES E RENOMEANDO COLUNAS     #

had_01 <- rbind(had_2019,had_2018,had_2017,had_2016)

colnames(had_01) <- c("ano","regiao","uf","id_municipio","nm_municipio","localizacao","rede","had_educacao_infantil","had_educacao_infantil_creche",
                      "had_educacao_infantil_pre_escola","had_ensino_fund","had_ensino_fund_anos_iniciais","had_ensino_fund_anos_finais","had_ensino_fund_1_ano",
                      "had_ensino_fund_2_ano","had_ensino_fund_3_ano","had_ensino_fund_4_ano","had_ensino_fund_5_ano","had_ensino_fund_6_ano","had_ensino_fund_7_ano",
                      "had_ensino_fund_8_ano","had_ensino_fund_9_ano","had_ensino_medio","had_ensino_medio_1_ano","had_ensino_medio_2_ano",
                      "had_ensino_medio_3_ano","had_ensino_medio_4_ano","had_ensino_medio_nao_seriado")

had_01 <- rbind(had_01,had_2015)

had_02 <- rbind(had_2014,had_2013,had_2012,had_2011,had_2010)

colnames(had_02) <- c("ano","regiao","uf","id_municipio","nm_municipio","localizacao","rede","had_educacao_infantil","had_educacao_infantil_creche",
                      "had_educacao_infantil_pre_escola","had_ensino_fund","had_ensino_fund_anos_iniciais","had_ensino_fund_anos_finais","had_ensino_fund_1_ano",
                      "had_ensino_fund_2_ano","had_ensino_fund_3_ano","had_ensino_fund_4_ano","had_ensino_fund_5_ano","had_ensino_fund_6_ano","had_ensino_fund_7_ano",
                      "had_ensino_fund_8_ano","had_ensino_fund_9_ano","had_ensino_medio","had_ensino_medio_1_ano","had_ensino_medio_2_ano",
                      "had_ensino_medio_3_ano","had_ensino_medio_4_ano","had_ensino_medio_nao_seriado")


had <- rbind(had_01,had_02)

had <- had[-c(2,3,5)]

had$rede <- arrumar(had$rede)
had$localizacao <- arrumar_cons(had$localizacao)

had$rede <- str_replace_all(had$rede,"publico","publica")
had$rede <- str_replace_all(had$rede,"particular","privada")

####### TABELA TAXAS DE DISTORÇÃO IDADE SÉRIE ########

tdi_2020 <- read_excel("TDI_MUNICIPIOS_2020.xlsx")
tdi_2020 <- tdi[-c(1:8,65637:65638),]

tdi_2019 <- read_excel("TDI_MUNICIPIOS_2019.xlsx")
tdi_2019 <- tdi_2019[-c(1:8,65657,65658),]

tdi_2018 <- read_excel("TDI_MUNICIPIOS_2018.xlsx")
tdi_2018 <- tdi_2018[-c(1:8,65688,65689),]


tdi_2017 <- read_excel("TDI_MUNICIPIOS_2017.xlsx")
tdi_2017 <- tdi_2017[-c(1:8,65743,65744),]

tdi_2016 <- read_excel("TDI_MUNICIPIOS_2016.xlsx")
tdi_2016 <- tdi_2016[-c(1:8,65780,65781),]

## Base de 2015
# Veio com uma coluna a mais que as outras
tdi_2015 <- read_excel("TDI_MUNICIPIOS_2015.xlsx")
tdi_2015 <- tdi_2015[-c(1:8,66549,66550),-c(3)]

colnames(tdi_2015) <- c("ano","regiao","uf","id_municipio","nm_municipio","localizacao","rede","tdi_ensino_fund","tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais","tdi_ensino_fund_1_ano",
                        "tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano","tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano",
                        "tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_medio","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano",
                        "tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano")



tdi_2014 <- read_excel("TDI_MUNICIPIOS_2014.xlsx")
tdi_2014 <- tdi_2014[-c(1:8,66706),]

tdi_2013 <- read_excel("TDI_MUNICIPIOS_2013.xlsx")
tdi_2013 <- tdi_2013[-c(1:8,66714),]

tdi_2012 <- read_excel("tdi_municipios_2012.xlsx")
tdi_2012 <- tdi_2012[-c(1:7,66707),]

#ARQUIVOS EXCEL  COM DUAS PLANILHAS

tdi_2011_01 <- read_excel("tdi_municipios_2011.xls",sheet = 1)
tdi_2011_01 <- tdi_2011_01[-c(1:7,5506,5507),]

tdi_2011_02 <- read_excel("tdi_municipios_2011.xls",sheet = 2)
tdi_2011_02 <- tdi_2011_02[-c(1:7,22798,22799),]

tdi_2011_03 <- read_excel("tdi_municipios_2011.xls",sheet = 3)
tdi_2011_03 <- tdi_2011_03[-c(1:7,19156,19157),]

tdi_2011_04 <- read_excel("tdi_municipios_2011.xls",sheet = 4)
tdi_2011_04 <- tdi_2011_04[-c(1:7,13895,13896),]

tdi_2011_05 <- read_excel("tdi_municipios_2011.xls",sheet = 5)
tdi_2011_05 <- tdi_2011_05[-c(1:7,5389,5390),]

tdi_2011 <- rbind(tdi_2011_01,tdi_2011_02,tdi_2011_03,tdi_2011_04,tdi_2011_05)


tdi_2010_01 <- read_excel("DADOS TDI MUNICIPIOS  - 2010.xls",sheet = 1)
tdi_2010_01 <- tdi_2010_01[-c(1:6,5482),]

tdi_2010_02 <- read_excel("DADOS TDI MUNICIPIOS  - 2010.xls",sheet = 2)
tdi_2010_02 <- tdi_2010_02[-c(1:7,22719),]

tdi_2010_03 <- read_excel("DADOS TDI MUNICIPIOS  - 2010.xls",sheet = 3)
tdi_2010_03 <- tdi_2010_03[-c(1:7,19138),]

tdi_2010_04 <- read_excel("DADOS TDI MUNICIPIOS  - 2010.xls",sheet = 4)
tdi_2010_04 <- tdi_2010_04[-c(1:7,13907),]

tdi_2010_05 <- read_excel("DADOS TDI MUNICIPIOS  - 2010.xls",sheet = 5)
tdi_2010_05 <- tdi_2010_05[-c(1:7,5370),]

tdi_2010 <- rbind(tdi_2010_01,tdi_2010_02,tdi_2010_03,tdi_2010_04,tdi_2010_05)


tdi_2009_01 <- read_excel("DADOS TDI MUNICIPIOS - 2009.xls",sheet = 1)
tdi_2009_01 <- tdi_2009_01[-c(1:7,5469,5470),]

tdi_2009_02 <- read_excel("DADOS TDI MUNICIPIOS - 2009.xls",sheet = 2)
tdi_2009_02 <- tdi_2009_02[-c(1:7,22676,22677),]

tdi_2009_03 <- read_excel("DADOS TDI MUNICIPIOS - 2009.xls",sheet = 3)
tdi_2009_03 <- tdi_2009_03[-c(1:7,19207,19208),]

tdi_2009_04 <- read_excel("DADOS TDI MUNICIPIOS - 2009.xls",sheet = 4)
tdi_2009_04 <- tdi_2009_04[-c(1:7,13924,13925),]

tdi_2009_05 <- read_excel("DADOS TDI MUNICIPIOS - 2009.xls",sheet = 5)
tdi_2009_05 <- tdi_2009_05[-c(1:7,5380,5381),]

tdi_2009 <- rbind(tdi_2009_01,tdi_2009_02,tdi_2009_03,tdi_2009_04,tdi_2009_05)

# Trocar colunar nm_municipio e id_municipio de posição
colnames(tdi_2009) <- c("ano","regiao","uf","nm_municipio","id_municipio","localizacao","rede","tdi_ensino_fund","tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais","tdi_ensino_fund_1_ano",
                        "tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano","tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano",
                        "tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_medio","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano",
                        "tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano")



tdi_2009 <- tdi_2009 %>% relocate(id_municipio, .after = uf)


tdi_2008_01 <- read_excel("TDI MUNICIPIOS 2008.xls",sheet = 1)
tdi_2008_01 <- tdi_2008_01[-c(1:7,5438,5439),]

tdi_2008_02 <- read_excel("TDI MUNICIPIOS 2008.xls",sheet = 2)
tdi_2008_02 <- tdi_2008_02[-c(1:7,22637,22638),]

tdi_2008_03 <- read_excel("TDI MUNICIPIOS 2008.xls",sheet = 3)
tdi_2008_03 <- tdi_2008_03[-c(1:7),]

tdi_2008_04 <- read_excel("TDI MUNICIPIOS 2008.xls",sheet = 4)
tdi_2008_04 <- tdi_2008_04[-c(1:7,13955,13956),]

tdi_2008_05 <- read_excel("TDI MUNICIPIOS 2008.xls",sheet = 5)
tdi_2008_05 <- tdi_2008_05[-c(1:7,5397,5398),]

tdi_2008 <- rbind(tdi_2008_01,tdi_2008_02,tdi_2008_03,tdi_2008_04,tdi_2008_05)

# Trocar colunar nm_municipio e id_municipio de posição
colnames(tdi_2008) <- c("ano","regiao","uf","nm_municipio","id_municipio","localizacao","rede","tdi_ensino_fund","tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais","tdi_ensino_fund_1_ano",
                        "tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano","tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano",
                        "tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_medio","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano",
                        "tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano")


tdi_2008 <- tdi_2008 %>% relocate(id_municipio, .after = uf)


tdi_2007_01 <- read_excel("TDI MUNICÍPIOS 2007.xls",sheet = 1)
tdi_2007_01 <- tdi_2007_01[-c(1:7,5443,5444),]

tdi_2007_02 <- read_excel("TDI MUNICÍPIOS 2007.xls",sheet = 2)
tdi_2007_02 <- tdi_2007_02[-c(1:7,22534,22535),]

tdi_2007_03 <- read_excel("TDI MUNICÍPIOS 2007.xls",sheet = 3)
tdi_2007_03 <- tdi_2007_03[-c(1:7,19328,19329),]

tdi_2007_04 <- read_excel("TDI MUNICÍPIOS 2007.xls",sheet = 4)
tdi_2007_04 <- tdi_2007_04[-c(1:7,13969,13970),]

tdi_2007_05 <- read_excel("TDI MUNICÍPIOS 2007.xls",sheet = 5)
tdi_2007_05 <- tdi_2007_05[-c(1:7,5376,5377),]

tdi_2007 <- rbind(tdi_2007_01,tdi_2007_02,tdi_2007_03,tdi_2007_04,tdi_2007_05)

# Trocar colunar nm_municipio e id_municipio de posição
colnames(tdi_2007) <- c("ano","regiao","uf","nm_municipio","id_municipio","localizacao","rede","tdi_ensino_fund","tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais","tdi_ensino_fund_1_ano",
                        "tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano","tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano",
                        "tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_medio","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano",
                        "tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano")


tdi_2007 <- tdi_2007 %>% relocate(id_municipio, .after = uf)



tdi_2006_01 <- read_excel("TDI06_MUNIC NORTE NORDESTE COESTE 2006.xls",sheet = 1)
tdi_2006_01 <- tdi_2006_01[-c(1:8,32964),]

tdi_2006_02 <- read_excel("TDI06_MUNIC SUDESTE SUL 2006.xls",sheet = 1)
tdi_2006_02 <- tdi_2006_02[-c(1:8,32294),]

tdi_2006 <- rbind(tdi_2006_01,tdi_2006_02)

# Trocar colunar rede e localizacao de posição
colnames(tdi_2006) <- c("ano","regiao","uf","nm_municipio","id_municipio","localizacao","rede","tdi_ensino_fund","tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais","tdi_ensino_fund_1_ano",
                        "tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano","tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano",
                        "tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_medio","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano",
                        "tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano")


tdi_2006 <- tdi_2006 %>% relocate(localizacao, .after = nm_municipio)


#      JUNTANDO AS BASES E RENOMEANDO COLUNAS     #

tdi_municipios_01 <- rbind(tdi_2019,tdi_2018,tdi_2017,tdi_2016)


colnames(tdi_municipios_01) <- c("ano","regiao","uf","id_municipio","nm_municipio","localizacao","rede","tdi_ensino_fund","tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais","tdi_ensino_fund_1_ano",
                                 "tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano","tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano",
                                 "tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_medio","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano",
                                 "tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano")


tdi_municipios_02 <- rbind(tdi_2014,tdi_2013,tdi_2012,tdi_2011,tdi_2010)

colnames(tdi_municipios_02) <- c("ano","regiao","uf","id_municipio","nm_municipio","localizacao","rede","tdi_ensino_fund","tdi_ensino_fund_anos_iniciais","tdi_ensino_fund_anos_finais","tdi_ensino_fund_1_ano",
                                 "tdi_ensino_fund_2_ano","tdi_ensino_fund_3_ano","tdi_ensino_fund_4_ano","tdi_ensino_fund_5_ano","tdi_ensino_fund_6_ano","tdi_ensino_fund_7_ano",
                                 "tdi_ensino_fund_8_ano","tdi_ensino_fund_9_ano","tdi_ensino_medio","tdi_ensino_medio_1_ano","tdi_ensino_medio_2_ano",
                                 "tdi_ensino_medio_3_ano","tdi_ensino_medio_4_ano")


tdi_municipios_03 <- rbind(tdi_2009,tdi_2008,tdi_2007,tdi_2006)

tdi_municipios <- rbind(tdi_municipios_01,tdi_2015,tdi_municipios_02,tdi_municipios_03)

tdi_municipios <- tdi_municipios[-c(2,3,5)]

tdi_municipios$rede <- arrumar(tdi_municipios$rede)
tdi_municipios$localizacao <- arrumar_cons(tdi_municipios$localizacao)

tdi_municipios$rede <- str_replace_all(tdi_municipios$rede,"publico","publica")
tdi_municipios$rede <- str_replace_all(tdi_municipios$rede,"particular","privada")

######## TABELA TAXAS DE RENDIMENTO ########

tx_2019 <- read_excel("tx_rend_municipios_2019.xlsx")
tx_2019 <- tx_2019[-c(1:8,65706,65707),]

tx_2018 <- read_excel("TX_REND_MUNICIPIOS_2018.xlsx")
tx_2018 <- tx_2018[-c(1:8,65749,65750),]


tx_2017 <- read_excel("TX_REND_MUNICIPIOS_2017.xlsx")
tx_2017 <- tx_2017[-c(1:8,65786,65787),]

tx_2016 <- read_excel("TX_REND_MUNICIPIOS_2016.xlsx")
tx_2016 <- tx_2016[-c(1:8,65832,65833),]


tx_2015 <- read_excel("TX_REND_MUN_2015.xlsx")
tx_2015 <- tx_2015[-c(1:9,66750,66751,66752,66753),]

tx_2014 <- read_excel("TAXAS RENDIMENTOS MUNICIPIOS 2014.xlsx")
tx_2014 <- tx_2014[-c(1:8,65634,65635,65636,65637),]

tx_2013 <- read_excel("TAXAS RENDIMENTOS MUNICIPIOS 2013.xlsx")
tx_2013 <- tx_2013[-c(1:8,65662,65663,65664,65665),]

tx_2012 <- read_excel("tx_rendimento_municipios_2012.xlsx")
tx_2012 <- tx_2012[-c(1:8,65641,65642,65643,65644),]



#Base 2011 com 2 planilhas
tx_2011_plan1 <- read_excel("tx_rendimento_municipios_2011.xls", sheet = 1)
tx_2011_plan1 <- tx_2011_plan1[-c(1:8,33398,33399,33400,33401),]

tx_2011_plan2 <- read_excel("tx_rendimento_municipios_2011.xls", sheet = 2)
tx_2011_plan2 <- tx_2011_plan2[-c(1:8,32205,32206,32207,32208),]

tx_2011 <- rbind(tx_2011_plan1,tx_2011_plan2)



tx_2010_plan1 <- read_excel("TX RENDIMENTO MUNICIPIOS 2010.xls", sheet = 1)
tx_2010 <- tx_2010_plan1[-c(1:8,65469,65470,65471,65472),]


tx_2009_plan1 <- read_excel("TX RENDIMENTOS MUNICIPIOS 2009.xls", sheet = 1)
tx_2009 <- tx_2009_plan1[-c(1:8,65513,65514,65515,65516),]


tx_2008_plan1 <- read_excel("TX RENDIMENTOS MUNICIPIOS 2008.xls", sheet = 1)
tx_2008 <- tx_2008_plan1[-c(1:8,65473,65474,65475,65476),]


#Base 2007 com duas planilhas
tx_2007_plan1 <- read_excel("TX RENDIMENTO MUNICÍPIOS 2007.xls", sheet = 1)
tx_2007_plan1 <- tx_2007_plan1[-c(1:8,33340,33341,33342,33343),]

tx_2007_plan2 <- read_excel("TX RENDIMENTO MUNICÍPIOS 2007.xls", sheet = 2)
tx_2007_plan2 <- tx_2007_plan2[-c(1:8,33322,33323,33324,33325),]

tx_2007 <- rbind(tx_2007_plan1,tx_2007_plan2)


#      JUNTANDO AS BASES E RENOMEANDO COLUNAS     #

tx_rendimentos_01 <- rbind(tx_2018,tx_2017,tx_2016,tx_2015,tx_2014,tx_2013,tx_2012,tx_2011,tx_2010,tx_2009,tx_2008,tx_2007)


colnames(taxa_rendimentos_01) <- c("ano","regiao","uf","id_municipio","nm_municipio","localizacao","rede","taxa_aprov_ensino_fund","taxa_aprov_ensino_fund_anos_iniciais","taxa_aprov_ensino_fund_anos_finais","taxa_aprov_ensino_fund_1_ano",
                                 "taxa_aprov_ensino_fund_2_ano","taxa_aprov_ensino_fund_3_ano","taxa_aprov_ensino_fund_4_ano","taxa_aprov_ensino_fund_5_ano","taxa_aprov_ensino_fund_6_ano","taxa_aprov_ensino_fund_7_ano",
                                 "taxa_aprov_ensino_fund_8_ano","taxa_aprov_nsino_fund_9_ano","taxa_aprov_ensino_medio","taxa_aprov_ensino_medio_1_ano","taxa_aprov_ensino_medio_2_ano",
                                 "taxa_aprov_ensino_medio_3_ano","taxa_aprov_ensino_medio_4_ano","taxa_aprov_ensino_medio_nao_seriado","taxa_reprov_ensino_fund","taxa_reprov_ensino_fund_anos_iniciais","taxa_reprov_ensino_fund_anos_finais","taxa_reprov_ensino_fund_1_ano",
                                 "taxa_reprov_ensino_fund_2_ano","taxa_reprov_ensino_fund_3_ano","taxa_reprov_ensino_fund_4_ano","taxa_reprov_ensino_fund_5_ano","taxa_reprov_ensino_fund_6_ano","taxa_reprov_ensino_fund_7_ano",
                                 "taxa_reprov_ensino_fund_8_ano","taxa_reprov_nsino_fund_9_ano","taxa_reprov_ensino_medio","taxa_reprov_ensino_medio_1_ano","taxa_reprov_ensino_medio_2_ano",
                                 "taxa_reprov_ensino_medio_3_ano","taxa_reprov_ensino_medio_4_ano","taxa_reprov_ensino_medio_nao_seriado","taxa_aband_ensino_fund","taxa_aband_ensino_fund_anos_iniciais","taxa_aband_ensino_fund_anos_finais","taxa_aband_ensino_fund_1_ano",
                                 "taxa_aband_ensino_fund_2_ano","taxa_aband_ensino_fund_3_ano","taxa_aband_ensino_fund_4_ano","taxa_aband_ensino_fund_5_ano","taxa_aband_ensino_fund_6_ano","taxa_aband_ensino_fund_7_ano",
                                 "taxa_aband_ensino_fund_8_ano","taxa_aband_ensino_fund_9_ano","taxa_aband_ensino_medio","taxa_aband_ensino_medio_1_ano","taxa_aband_ensino_medio_2_ano",
                                 "taxa_aband_ensino_medio_3_ano","taxa_aband_ensino_medio_4_ano","taxa_aband_ensino_medio_nao_seriado")

colnames(taxa_2019) <- c("ano","regiao","uf","id_municipio","nm_municipio","localizacao","rede","taxa_aprov_ensino_fund","taxa_aprov_ensino_fund_anos_iniciais","taxa_aprov_ensino_fund_anos_finais","taxa_aprov_ensino_fund_1_ano",
                       "taxa_aprov_ensino_fund_2_ano","taxa_aprov_ensino_fund_3_ano","taxa_aprov_ensino_fund_4_ano","taxa_aprov_ensino_fund_5_ano","taxa_aprov_ensino_fund_6_ano","taxa_aprov_ensino_fund_7_ano",
                       "taxa_aprov_ensino_fund_8_ano","taxa_aprov_nsino_fund_9_ano","taxa_aprov_ensino_medio","taxa_aprov_ensino_medio_1_ano","taxa_aprov_ensino_medio_2_ano",
                       "taxa_aprov_ensino_medio_3_ano","taxa_aprov_ensino_medio_4_ano","taxa_aprov_ensino_medio_nao_seriado","taxa_reprov_ensino_fund","taxa_reprov_ensino_fund_anos_iniciais","taxa_reprov_ensino_fund_anos_finais","taxa_reprov_ensino_fund_1_ano",
                       "taxa_reprov_ensino_fund_2_ano","taxa_reprov_ensino_fund_3_ano","taxa_reprov_ensino_fund_4_ano","taxa_reprov_ensino_fund_5_ano","taxa_reprov_ensino_fund_6_ano","taxa_reprov_ensino_fund_7_ano",
                       "taxa_reprov_ensino_fund_8_ano","taxa_reprov_nsino_fund_9_ano","taxa_reprov_ensino_medio","taxa_reprov_ensino_medio_1_ano","taxa_reprov_ensino_medio_2_ano",
                       "taxa_reprov_ensino_medio_3_ano","taxa_reprov_ensino_medio_4_ano","taxa_reprov_ensino_medio_nao_seriado","taxa_aband_ensino_fund","taxa_aband_ensino_fund_anos_iniciais","taxa_aband_ensino_fund_anos_finais","taxa_aband_ensino_fund_1_ano",
                       "taxa_aband_ensino_fund_2_ano","taxa_aband_ensino_fund_3_ano","taxa_aband_ensino_fund_4_ano","taxa_aband_ensino_fund_5_ano","taxa_aband_ensino_fund_6_ano","taxa_aband_ensino_fund_7_ano",
                       "taxa_aband_ensino_fund_8_ano","taxa_aband_ensino_fund_9_ano","taxa_aband_ensino_medio","taxa_aband_ensino_medio_1_ano","taxa_aband_ensino_medio_2_ano",
                       "taxa_aband_ensino_medio_3_ano","taxa_aband_ensino_medio_4_ano","taxa_aband_ensino_medio_nao_seriado")

tx_rendimentos <- rbind(tx_2019,tx_rendimentos_01)

tx_rendimentos <- tx_rendimentos[-c(2,3,5)]

tx_rendimentos$rede <- arrumar(tx_rendimentos$rede)
tx_rendimentos$localizacao <- arrumar_cons(tx_rendimentos$localizacao)

tx_rendimentos$rede <- str_replace_all(tx_rendimentos$rede,"publico","publica")
tx_rendimentos$rede <- str_replace_all(tx_rendimentos$rede,"particular","privada")

##### TABELA TAXA DE NAO RESPOSTA ######

tnr_2019 <- read_excel("tnr_municipios_2019.xlsx")
tnr_2019 <- tnr_2019[-c(1:8,65706,65707,65708),]

tnr_2018 <- read_excel("TNR_MUNICIPIOS_2018.xlsx")
tnr_2018 <- tnr_2018[-c(1:8,65749,65750,65751),]

tnr_2017 <- read_excel("TNR_MUNICIPIOS_2017.xlsx")
tnr_2017 <- tnr_2017[-c(1:8,65786,65787),]

tnr_2016 <- read_excel("TNR_MUNICIPIOS_2016.xlsx")
tnr_2016 <- tnr_2016[-c(1:8,65832),]

tnr_2015 <- read_excel("TNR_MUNICIPIOS_2015.xlsx")
tnr_2015 <- tnr_2015[-c(1:9,65750),]

tnr_2014 <- read_excel("TAXA NÃO-RESPOSTA MUNICIPIOS  2014.xlsx")
tnr_2014 <- tnr_2014[-c(1:8,65634),]

tnr_2013 <- read_excel("TAXA NÃO-RESPOSTA MUNICIPIOS  2013.xlsx")
tnr_2013 <- tnr_2013[-c(1:8,65662),]

tnr_2012 <- read_excel("TAXA NÃO-RESPOSTA MUNICIPIOS  2012.xlsx")
tnr_2012 <- tnr_2012[-c(1:8,65641),]

tnr_2011_01 <- read_excel("tx_nao_resposta_municipios_2011.xls", sheet = 1)
tnr_2011_01 <- tnr_2011_01[-c(1:8,33398),]

tnr_2011_02 <- read_excel("tx_nao_resposta_municipios_2011.xls", sheet = 2)
tnr_2011_02 <- tnr_2011_02[-c(1:8,32205),]

tnr_2011 <- rbind(tnr_2011_01,tnr_2011_02)

tnr_2010 <- read_excel("TAXAS NÃO-RESPOSTA MUNICIPIOS 2010.xls", sheet = 1)
tnr_2010 <- tnr_2010[-c(1:8,65469),]


tnr <- rbind(tnr_2019,tnr_2018,tnr_2017,tnr_2016,tnr_2015,tnr_2014,tnr_2013,tnr_2012
             ,tnr_2011,tnr_2010)


colnames(tnr) <- c("ano","regiao","uf","id_municipio","nm_municipio","localizacao","rede","tnr_ensino_fund","tnr_ensino_fund_anos_iniciais","tnr_ensino_fund_anos_finais","tnr_ensino_fund_1_ano",
                                 "tnr_ensino_fund_2_ano","tnr_ensino_fund_3_ano","tnr_ensino_fund_4_ano","tnr_ensino_fund_5_ano","tnr_ensino_fund_6_ano","tnr_ensino_fund_7_ano",
                                 "tnr_ensino_fund_8_ano","tnr_ensino_fund_9_ano","tnr_ensino_medio","tnr_ensino_medio_1_ano","tnr_ensino_medio_2_ano",
                                 "tnr_ensino_medio_3_ano","tnr_ensino_medio_4_ano,tnr_ensino_medio_nao_seriado")

tnr <- tnr[-c(2,3,5)]

tnr$rede <- arrumar(tnr$rede)
tnr$localizacao <- arrumar_cons(tnr$localizacao)

tnr$rede <- str_replace_all(tnr$rede,"publico","publica")
tnr$rede <- str_replace_all(tnr$rede,"particular","privada")

#####  TABELA PERCENTUAL DE DOCENTES COM CURSO SUPERIOR    #######

dsu_2020 <- read_excel("DSU_MUNICIPIOS_2020.xlsx")
dsu_2020 <- dsu_2020[-c(1:9,67457:67458),]

dsu_2019 <- read_excel("DSU_MUNICIPIOS_2019.xlsx")
dsu_2019 <- dsu_2019[-c(1:9,67519,67520),]

dsu_2018 <- read_excel("DSU_MUNICIPIOS_2018.xlsx")
dsu_2018 <- dsu_2018[-c(1:9,67662,67663),]

dsu_2017 <- read_excel("DSU_MUNICIPIOS_2017.xlsx")
dsu_2017 <- dsu_2017[-c(1:9,67695,67696),]

dsu_2016 <- read_excel("DSU_MUNICIPIOS_2016.xlsx")
dsu_2016 <- dsu_2016[-c(1:9,67828,67829),]

dsu_2015 <- read_excel("DSU_MUNICIPIOS_2015.xlsx")
dsu_2015 <- dsu_2015[-c(1:9,67751,67752),]

dsu_2014 <- read_excel("DSU - MUNICIPIOS 2014.xlsx")
dsu_2014 <- dsu_2014[-c(1:9,67602),]

dsu_2013 <- read_excel("DSU - MUNICIPIOS 2013.xlsx")
dsu_2013 <- dsu_2013[-c(1:9,67589),]

dsu_2012 <- read_excel("DSU - MUNICIPIOS 2012.xlsx")
dsu_2012 <- dsu_2012[-c(1:9,67571),]

dsu_2011 <- read_excel("DSU - MUNICIPIOS 2011.xlsx")
dsu_2011 <- dsu_2011[-c(1:9,67572),]

dsu_01 <- rbind(dsu_2019,dsu_2018,dsu_2017,dsu_2016)

colnames(dsu_01) <- c("ano","regiao","uf","id_municipio","nm_municipio","localizacao","rede","dsu_educ_infantil","dsu_educ_infantil_creche","dsu_educ_infantil_pre_escola","dsu_ensino_fund","dsu_ensino_fund_anos_iniciais"
                      ,"dsu_ensino_fund_anos_finais","dsu_ensino_medio","dsu_educacao_profissional","dsu_educacao_jovens_adultos",
                      "dsu_educacao_especial")

dsu_02 <- rbind(dsu_2015,dsu_2014,dsu_2013,dsu_2012,dsu_2011)

colnames(dsu_02) <- c("ano","regiao","uf","id_uf","nm_municipio","id_municipio","localizacao","rede","dsu_educ_infantil","dsu_educ_infantil_creche","dsu_educ_infantil_pre_escola","dsu_ensino_fund","dsu_ensino_fund_anos_iniciais"
                        ,"dsu_ensino_fund_anos_finais","dsu_ensino_medio","dsu_educacao_profissional","dsu_educacao_jovens_adultos",
                        "dsu_educacao_especial")

dsu_02$id_uf <- NULL

dsu_02 <- dsu_02 %>% relocate(id_municipio, after= uf)

dsu <- rbind(dsu_01,dsu_02)

dsu <- dsu[-c(2,3,5)]

dsu$rede <- arrumar(dsu$rede)
dsu$localizacao <- arrumar_cons(dsu$localizacao)

dsu$rede <- str_replace_all(dsu$rede,"publico","publica")
dsu$rede <- str_replace_all(dsu$rede,"particular","privada")

##### TABELA ADEQUAÇÃO DA FORMAÇÃO DOCENTE ######

afd_2020 <- read_excel("AFD_MUNICIPIOS_2020.xlsx")
afd_2020 <- afd_2020[-c(1:10,67304:67308),]

afd_2019 <- read_excel("AFD_MUNICIPIOS_2019.xlsx")
afd_2019 <- afd_2019[-c(1:10,67323,67324,67325,67326,67327),]

afd_2018 <- read_excel("AFD_MUNICIPIOS_2018.xlsx")
afd_2018 <- afd_2018[-c(1:10,67455,67456,67457,67458,67459),]

afd_2017 <- read_excel("AFD_MUNICIPIOS_2017.xlsx")
afd_2017 <- afd_2017[-c(1:10,67478,67479,67480,67481,67482),]

afd_2016 <- read_excel("AFD_MUNICIPIOS_2016.xlsx")
afd_2016 <- afd_2016[-c(1:10,67540,67541,67542,67543,67544),]

afd_2015 <- read_excel("AFD_MUNICIPIOS_2015.xlsx")
afd_2015 <- afd_2015[-c(1:10,67455,67456,67457,67458,67459),]

afd_2014 <- read_excel("AFD_MUNICIPIOS_2014.xlsx")
afd_2014 <- afd_2014[-c(1:10,67343,67344,67345,67346,67347),]

afd_2013 <- read_excel("AFD_MUNICIPIOS_2013.xlsx")
afd_2013 <- afd_2013[-c(1:10,67342,67343,67344,67345,67346),]

afd <- rbind(afd_2019,afd_2018,afd_2017,afd_2016,afd_2015,afd_2014,afd_2013)

colnames(afd) <- c("ano","regiao","uf","id_municipio","nm_municipio","localizacao","rede","afd_educacao_infantil_grupo_1","afd_educacao_infantil_grupo_2",
                                         "afd_educacao_infantil_grupo_3","afd_educacao_infantil_grupo_4","afd_educacao_infantil_grupo_5","afd_ensino_fund_grupo_1","afd_ensino_fund_grupo_2","afd_ensino_fund_grupo_3",
                                         "afd_ensino_fund_grupo_4","afd_ensino_fund_grupo_5","afd_ensino_fund_anos_iniciais_grupo_1","afd_ensino_fund_anos_iniciais_grupo_2","afd_ensino_fund_anos_iniciais_grupo_3","afd_ensino_fund_anos_iniciais_grupo_4",
                                         "afd_ensino_fund_anos_iniciais_grupo_5","afd_ensino_fund_anos_finais_grupo_1","afd_ensino_fund_anos_finais_grupo_2","afd_ensino_fund_anos_finais_grupo_3","afd_ensino_fund_anos_finais_grupo_4",
                                         "afd_ensino_fund_anos_finais_grupo_5","afd_ensino_medio_grupo_1","afd_ensino_medio_grupo_2","afd_ensino_medio_grupo_3","afd_ensino_medio_grupo_4","afd_ensino_medio_grupo_5","afd_eja_fundamental_grupo_1","afd_eja_fundamental_grupo_2",
                   "afd_eja_fundamental_grupo_3","afd_eja_fundamental_grupo_4","afd_eja_fundamental_grupo_5","afd_eja_medio_grupo_1","afd_eja_medio_grupo_2","afd_eja_medio_grupo_3","afd_eja_medio_grupo_4","afd_eja_medio_grupo_5")

afd <- afd[-c(2,3,5)]

afd$rede <- arrumar(afd$rede)
afd$localizacao <- arrumar_cons(afd$localizacao)

afd$rede <- str_replace_all(afd$rede,"publico","publica")
afd$rede <- str_replace_all(afd$rede,"particular","privada")

###### TABELA REGULARIDADE DO CORPO DOCENTE  ########

ird_2020 <- read_excel("IRD_MUNICIPIOS_2020.xlsx")
ird_2020 <- ird_2020[-c(1:9,66975:66979),]

ird_2019 <- read_excel("IRD_MUNICIPIOS_2019.xlsx")
ird_2019 <- ird_2019[-c(1:9,66939,66940,66941,66942,66943),]

ird_2018 <- read_excel("IRD_MUNICIPIOS_2018.xlsx")
ird_2018 <- ird_2018[-c(1:8,66838,66839,66840,66841,66842),]

ird_2017 <- read_excel("IRD_MUNICIPIOS_2017.xlsx")
ird_2017 <- ird_2017[-c(1:8,66816,66817,66818,66819,66820),]

ird_2016 <- read_excel("IRD_MUNICIPIOS_2016.xlsx")
ird_2016 <- ird_2016[-c(1:8,66878,66879,66880,66881,66882),]

ird_2015 <- read_excel("IRD_MUNICIPIOS_2015.xlsx")
ird_2015 <- ird_2015[-c(1:8,66735,66736,66737,66738,66739),]

ird_2014 <- read_excel("IRD_MUNICIPIOS_2014.xlsx")
ird_2014 <- ird_2014[-c(1:8,66526,66527,66528,66529,66530),]

ird_2013 <- read_excel("IRD_MUNICIPIOS_2013.xlsx")
ird_2013 <- ird_2013[-c(1:9,66528,66529,66530,66531,66532),]

ird <- rbind(ird_2019,ird_2018,ird_2017,ird_2016,ird_2015,ird_2014,ird_2013)

colnames(ird) <- c("ano","regiao","uf","id_municipio","nm_municipio","localizacao","rede","ird_baixa_regularidade","ird_media_baixa","ird_media_alta","ird_alta")

ird <- ird[-c(2,3,5)]

ird$rede <- arrumar(ird$rede)
ird$localizacao <- arrumar_cons(ird$localizacao)

ird$rede <- str_replace_all(ird$rede,"publico","publica")
ird$rede <- str_replace_all(ird$rede,"particular","privada")

####### TABELA ESFORÇO DOCENTE ########

ied_2020 <- read_excel("IED_MUNICIPIOS_2020.xlsx")
ied_2020 <- ied_2020[-c(1:10,66396:66400),]

ied_2019 <- read_excel("IED_MUNICIPIOS_2019.xlsx")
ied_2019 <- ied_2019[-c(1:10,66422,66423,66424,66425,66426),]

ied_2018 <- read_excel("IED_MUNICIPIOS_2018.xlsx")
ied_2018 <- ied_2018[-c(1:10,66503,66504,66505,66506,66507),]

ied_2017 <- read_excel("IED_MUNICIPIOS_2017.xlsx")
ied_2017 <- ied_2017[-c(1:10,66561,66562,66563,66564,66565),]

ied_2016 <- read_excel("IED_MUNICIPIOS_2016.xlsx")
ied_2016 <- ied_2016[-c(1:10,66625,66626,66627,66628,66629),]

ied_2015 <- read_excel("IED_MUNICIPIOS_2015.xlsx")
ied_2015 <- ied_2015[-c(1:10,66556,66557,66558,66559,66560),]

ied_2014 <- read_excel("IED_MUNICIPIOS_2014.xlsx")
ied_2014 <- ied_2014[-c(1:10,66448,66449,66450,66451,66452),]

ied_2013 <- read_excel("IED_MUNICIPIOS_2013.xlsx")
ied_2013 <- ied_2013[-c(1:10,66479,66480,66481,66482),]

ied <- rbind(ied_2019,ied_2018,ied_2017,ied_2016,ied_2015,ied_2014,ied_2013)

colnames(ied) <- c("ano","regiao","uf","nm_municipio","id_municipio","localizacao","rede","ied_ensino_fund_nivel_1","ied_ensino_fund_nivel_2","ied_ensino_fund_nivel_3","ied_ensino_fund_nivel_4",
                        "ied_ensino_fund_nivel_5","ied_ensino_fund_nivel_6","ied_ensino_fund_anos_iniciais_nivel_1","ied_ensino_fund_anos_iniciais_nivel_2","ied_ensino_fund_anos_iniciais_nivel_3","ied_ensino_fund_anos_iniciais_nivel_4",
                        "ied_ensino_fund_anos_iniciais_nivel_5","ied_ensino_fund_anos_iniciais_nivel_6","ied_ensino_fund_anos_finais_nivel_1","ied_ensino_fund_anos_finais_nivel_2","ied_ensino_fund_anos_finais_nivel_3",
                        "ied_ensino_fund_anos_finais_nivel_4","ied_ensino_fund_anos_finais_nivel_5","ied_ensino_fund_anos_finais_nivel_6","ied_ensino_medio_nivel_1","ied_ensino_medio_nivel_2","ied_ensino_medio_nivel_3","ied_ensino_medio_nivel_4","ied_ensino_medio_nivel_5","ied_ensino_medio_nivel_6")

ied <- ied[-c(2,3,5)]

ied$rede <- arrumar(ied$rede)
ied$localizacao <- arrumar_cons(ied$localizacao)

ied$rede <- str_replace_all(ied$rede,"publico","publica")
ied$rede <- str_replace_all(ied$rede,"particular","privada")

###### TABELA COMPLEXIDADE DE GESTÃO DA ESCOLA ######

icg_2020 <- read_excel("ICG_MUNICIPIOS_2020.xlsx")
icg_2020 <- icg_2020[-c(1:8,67463:67467),]

icg_2019 <- read_excel("ICG_MUNICIPIOS_2019.xlsx")
icg_2019 <- icg_2019[-c(1:8,67525,67526,67527,67528,67529),]

icg_2018 <- read_excel("ICG_MUNICIPIOS_2018.xlsx")
icg_2018 <- icg_2018[-c(1:8,67665,67666,67667,67668,67669),]

icg_2017 <- read_excel("ICG_MUNICIPIOS_2017.xlsx")
icg_2017 <- icg_2017[-c(1:8,67715,67716,67717,67718,67719),]

icg_2016 <- read_excel("ICG_MUNICIPIOS_2016.xlsx")
icg_2016 <- icg_2016[-c(1:8,67847,67848,67849,67850,67851),]

icg_2015 <- read_excel("ICG_MUNICIPIOS_2015.xlsx")
icg_2015 <- icg_2015[-c(1:8,67767,67768,67769,67770,67771),]

icg_2014 <- read_excel("ICG_MUNICIPIOS_2014.xlsx")
icg_2014 <- icg_2014[-c(1:8,67712,67713,67714,67715,67716),]

icg_2013 <- read_excel("ICG_MUNICIPIOS_2013.xlsx")
icg_2013 <- icg_2013[-c(1:8,67602,67603,67604,67605,67606),]

icg <- rbind(icg_2019,icg_2018,icg_2017,icg_2016,icg_2015,icg_2014,icg_2013)

colnames(icg) <- c("ano","regiao","uf","id_municipio","nm_municipio","localizacao","rede","icg_nivel_1","icg_nivel_2","icg_nivel_3","icg_nivel_4","icg_nivel_5","icg_nivel_6")

icg <- icg[-c(2,3,5)]

icg$rede <- arrumar(icg$rede)
icg$localizacao <- arrumar_cons(icg$localizacao)

icg$rede <- str_replace_all(icg$rede,"publico","publica")
icg$rede <- str_replace_all(icg$rede,"particular","privada")

## Juntando e terminando o processo de limpeza das bases ##

indicadores_01 <- full_join(atu,had, by= c("id_municipio","ano","localizacao","rede"))

indicadores_02 <- full_join(indicadores_01,tdi_municipios , by= c("id_municipio","ano","localizacao","rede"))

indicadores_03 <- full_join(indicadores_02,tx_rendimentos, by= c("id_municipio","ano","localizacao","rede"))

indicadores_04 <- full_join(indicadores_03,tnr, by= c("id_municipio","ano","localizacao","rede"))

indicadores_05 <- full_join(indicadores_04,dsu, by= c("id_municipio","ano","localizacao","rede"))

indicadores_06 <- full_join(indicadores_05,afd, by= c("id_municipio","ano","localizacao","rede"))

indicadores_07 <- full_join(indicadores_06,ird, by= c("id_municipio","ano","localizacao","rede"))

indicadores_08 <- full_join(indicadores_07,ied, by= c("id_municipio","ano","localizacao","rede"))

indicadores_09 <- full_join(indicadores_08,icg, by= c("id_municipio","ano","localizacao","rede"))

indicadores <- indicadores_09 %>% arrange(id_municipio,localizacao,rede,ano)

is.na(indicadores[5:215]) <- indicadores[5:215]=="--"

indicadores[,5:215] <- lapply(indicadores[5:215],as.numeric)

con <- file('municipio.csv', encoding = "UTF-8")
write.csv(indicadores, file = con, row.names = FALSE, na = " ")

