
rm(list = ls())

library(reshape2)
library(geobr)
library(spdep)

mainDir = "~/Downloads/br_bd_vizinhanca"

dir.create(mainDir, showWarnings = FALSE)
dir.create(file.path(mainDir, 'setor_censitario'), showWarnings = FALSE)
setwd(mainDir)

years = c(2000, 2010, 2017, 2019, 2020)
for (year in years) {
  
  sp = geobr::read_census_tract(code_tract="all", year=year)
  IDs = data.frame(sp$code_tract)
  IDs$n = seq.int(nrow(IDs))
  
  nb = poly2nb(pl = sp,
               row.names = sp$code_tract)
  mat <- nb2mat(nb,
                style = "B",
                zero.policy=TRUE)
  
  df = melt(mat)
  df = df[df$value == 1,]
  df = merge(df, IDs, by.x='Var1', by.y='n')
  df = merge(df, IDs, by.x='Var2', by.y='n')
  colnames(df) = c('n1', 'n2', 'vizinho', 'id_setor_censitario_1', 'id_setor_censitario_2')
  df = df[ , c("id_setor_censitario_1","id_setor_censitario_2")]
  
  dir.create(file.path(mainDir, paste0('setor_censitario/ano=',year)), showWarnings = FALSE)
  
  write.csv(df,
            paste0('setor_censitario/ano=',year,'/setor_censitario.csv'),
            row.names = FALSE)
  
}
