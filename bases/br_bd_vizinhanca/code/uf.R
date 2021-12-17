
rm(list = ls())

library(reshape2)
library(geobr)
library(spdep)

mainDir = "~/Downloads/br_bd_vizinhanca"

dir.create(mainDir, showWarnings = FALSE)
dir.create(file.path(mainDir, 'uf'), showWarnings = FALSE)
setwd(mainDir)

years = c(2000, 2001, 2010, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020) # 1872, 1900, 1911, 1920, 1933, 1940, 1950, 1960, 1970, 1980, 1991, 
for (year in years) {
  
  sp = geobr::read_state(year=year)
  IDs = data.frame(sp$abbrev_state)
  IDs$n = seq.int(nrow(IDs))
  
  nb = poly2nb(pl = sp,
               row.names = sp$abbrev_state)
  mat <- nb2mat(nb,
                style = "B",
                zero.policy=TRUE)
  
  df = melt(mat)
  df = df[df$value == 1,]
  df = merge(df, IDs, by.x='Var1', by.y='n')
  df = merge(df, IDs, by.x='Var2', by.y='n')
  colnames(df) = c('n1', 'n2', 'vizinho', 'sigla_uf_1', 'sigla_uf_2')
  df = df[ , c("sigla_uf_1","sigla_uf_2")]
  
  dir.create(file.path(mainDir, paste0('uf/ano=',year)), showWarnings = FALSE)
  
  write.csv(df,
            paste0('uf/ano=',year,'/uf.csv'),
            row.names = FALSE)
  
}
