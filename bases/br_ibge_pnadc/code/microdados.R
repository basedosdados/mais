
#------------------------------------------------------------------------------#
# prefacio
#------------------------------------------------------------------------------#

rm(list = ls())

library(PNADcIBGE)
library(tibble)

setwd("atalho/para/Pesquisa Nacional de Amostra de Domicilios Continua (PNADC)")

#------------------------------------------------------------------------------#
# build
#------------------------------------------------------------------------------#

dir.create("output/microdados",
           showWarnings = FALSE)

for (ano in 2012:2020) {
  
  dir.create(paste0("output/microdados/ano=",ano),
             showWarnings = FALSE)
  
  for (trimestre in 1:4) {
    
    dir.create(paste0("output/microdados/ano=",ano,"/trimestre=",trimestre),
               showWarnings = FALSE)
    
    df = get_pnadc(ano,
                   quarter=trimestre,
                   labels = FALSE,
                   design = FALSE)
    
    names(df) = tolower(names(df))
    names(df)[names(df) == 'uf'] = 'id_uf'
    names(df)[names(df) == 'upa'] = 'id_upa'
    names(df)[names(df) == 'estrato'] = 'id_estrato'
    
    df = add_column(df, sigla_uf = "", .after = "id_uf")
    df$sigla_uf[df$id_uf == "11"] = "RO"
    df$sigla_uf[df$id_uf == "12"] = "AC"
    df$sigla_uf[df$id_uf == "13"] = "AM"
    df$sigla_uf[df$id_uf == "14"] = "RR"
    df$sigla_uf[df$id_uf == "15"] = "PA"
    df$sigla_uf[df$id_uf == "16"] = "AP"
    df$sigla_uf[df$id_uf == "17"] = "TO"
    df$sigla_uf[df$id_uf == "21"] = "MA"
    df$sigla_uf[df$id_uf == "22"] = "PI"
    df$sigla_uf[df$id_uf == "23"] = "CE"
    df$sigla_uf[df$id_uf == "24"] = "RN"
    df$sigla_uf[df$id_uf == "25"] = "PB"
    df$sigla_uf[df$id_uf == "26"] = "PE"
    df$sigla_uf[df$id_uf == "27"] = "AL"
    df$sigla_uf[df$id_uf == "28"] = "SE"
    df$sigla_uf[df$id_uf == "29"] = "BA"
    df$sigla_uf[df$id_uf == "31"] = "MG"
    df$sigla_uf[df$id_uf == "32"] = "ES"
    df$sigla_uf[df$id_uf == "33"] = "RJ"
    df$sigla_uf[df$id_uf == "35"] = "SP"
    df$sigla_uf[df$id_uf == "41"] = "PR"
    df$sigla_uf[df$id_uf == "42"] = "SC"
    df$sigla_uf[df$id_uf == "43"] = "RS"
    df$sigla_uf[df$id_uf == "50"] = "MS"
    df$sigla_uf[df$id_uf == "51"] = "MT"
    df$sigla_uf[df$id_uf == "52"] = "GO"
    df$sigla_uf[df$id_uf == "53"] = "DF"
    
    for (uf in unique(df$sigla_uf)) {
      
      dir.create(paste0("output/microdados/ano=",ano,"/trimestre=",trimestre,"/sigla_uf=",uf),
                 showWarnings = FALSE)
      
      df.particao = df[df$sigla_uf == uf,]
      df.particao = df.particao[,!(names(df.particao) %in% c("ano","trimestre","sigla_uf"))]
      
      write.table(df.particao,
                  paste0("output/microdados/ano=",ano,"/trimestre=",trimestre,"/sigla_uf=",uf,"/microdados.csv"),
                  na = "",
                  quote=FALSE,
                  row.names = FALSE,
                  sep = ",")
      
    }
  }
}
