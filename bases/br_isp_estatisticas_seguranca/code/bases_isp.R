############## ISP ESTATÍSTICAS SEGURANÇA #################
library(data.table)
library(dplyr)


                              ## Evolução mensal por CISP ##

dt <- fread("BaseDPEvolucaoMensalCisp.csv")

dt$munic <- arrumar(dt$munic)
dt$Regiao <- arrumar(dt$Regiao)

dt <- dt %>% rename(cisp = CISP, regiao = Regiao, aisp = AISP,municipio = munic, risp = RISP,
                    id_municipio = mcirc, regiao_rj = regiao)

fwrite(dt, "evolucao_mensal_aisp.csv", na = " ", row.names = FALSE)


                                  ## Mensal - Estado ##

dt <- fread("DOMensalEstadoDesde1991.csv")

fwrite(dt, "evolucao_mensal_uf.csv", na = " ", row.names = FALSE)


                                ## Mensal - estado - taxas ##

dt <- fread("BaseEstadoTaxaMes.csv")

dt[,4:51] <- lapply(dt[,4:51], as.numeric)

fwrite(dt, "taxas_evolucao_mensal_uf.csv", na = " ", row.names = FALSE)


                                 ## Anual - estado - taxas ##

dt <- fread("BaseEstadoTaxaAno.csv")

dt[,2:55] <- lapply(dt[,2:55], as.numeric)

fwrite(dt, "taxas_evolucao_anual_uf.csv", na = " ", row.names = FALSE)


                                  ## Mensal - municipio ##

dt <- fread("BaseMunicipioMensal.csv")

dt$fmun = arrumar(dt$fmun)
dt$regiao = arrumar(dt$regiao)

dt <- dt %>% rename(id_municipio = fmun_cod, municipio = fmun, regiao_rj = regiao)

fwrite(dt, "evolucao_mensal_municipio.csv", na = " ", row.names = FALSE)


                               ## Mensal - municipio - taxa ##

dt <- fread("BaseMunicipioMensalTaxa.csv")

dt$fmun = arrumar(dt$fmun)
dt$regiao = arrumar(dt$regiao)

dt <- dt %>% rename(id_municipio = fmun_cod, municipio = fmun, regiao_rj = regiao)

dt[dt=="-"] <- NA

dt[,7:60] = lapply(dt[,7:60], as.numeric)

fwrite(dt, "taxas_evolucao_mensal_municipio.csv", na = " ", row.names = FALSE)


                              ## Anual - municipio - taxa ##

dt <- fread("BaseMunicipioTaxaAno.csv")

dt$fmun = arrumar(dt$fmun)
dt$regiao = arrumar(dt$regiao)

dt <- dt %>% rename(id_municipio = fmun_cod, municipio = fmun, regiao_rj = regiao)
dt[dt=="-"] <- NA
dt[,5:57] = lapply(dt[,5:57],as.numeric)
fwrite(dt, "taxas_evolucao_anual_municipio.csv", na = " ", row.names = FALSE)



                                    ## Anual - upp ##

dt <- fread("UppEvolucaoMensalDeTitulos.csv")

dt$upp <- arrumar(dt$upp)
dt <- dt %>% rename(id_upp = cod_upp)

fwrite(dt, "evolucao_mensal_upp.csv", na = " ", row.names = FALSE)


                                  ## Policiais Mortos ##

dt <- fread("PoliciaisMortos.csv")

dt <- dt %>% rename(cisp = CISP, ano = vano, pm_mortos_serviso = pol_militares_mortos_serv, pc_mortos_servicos = pol_civis_mortos_serv)

fwrite(dt, "policiais_mortos_servico.csv", na = " ", row.names = FALSE)


                                   ## Feminicidio ##

dt <- fread("BaseFeminicidioEvolucaoMensalCisp.csv")

dt <- dt %>% rename(fase = FASE)

fwrite(dt, "feminicidio_mensal_cisp.csv", na = " ", row.names = FALSE)
