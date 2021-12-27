
rm(list = ls())

#install.packages("geobr")
#install.packages("spdep")
#install.packages("igraph")

library(reshape2)
library(geobr)
library(spdep)

mainDir = "~/Downloads/br_bd_vizinhanca"

dir.create(mainDir, showWarnings = FALSE)
dir.create(file.path(mainDir, 'municipio'), showWarnings = FALSE)
setwd(mainDir)

years = c(1872, 1900, 1911, 1920, 1933, 1940, 1950, 1960, 1970, 1980, 1991, 2000, 2005, 2007, 2010, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020) # 2001
years = c(2005, 2007, 2010, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020)
for (year in years) {
  
  municipality = geobr::read_municipality(year=year)
  IDs = data.frame(municipality$code_muni)
  IDs$n = seq.int(nrow(IDs))
  
  nb = poly2nb(pl = municipality,
               row.names = municipality$code_muni)
  mat <- nb2mat(nb,
                style = "B",
                zero.policy=TRUE)
  
  df = melt(mat)
  df = df[df$value == 1,]
  df = merge(df, IDs, by.x='Var1', by.y='n')
  df = merge(df, IDs, by.x='Var2', by.y='n')
  colnames(df) = c('n1', 'n2', 'vizinho', 'id_municipio_1', 'id_municipio_2')
  df = df[ , c("id_municipio_1","id_municipio_2")]
  
  dir.create(file.path(mainDir, paste0('municipio/ano=',year)), showWarnings = FALSE)
  
  write.csv(df,
            paste0('municipio/ano=',year,'/municipio.csv'),
            row.names = FALSE)
  
}
