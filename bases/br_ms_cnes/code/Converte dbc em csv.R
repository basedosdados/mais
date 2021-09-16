library(read.dbc)

uf <- c('RJ','SP','ES','MG','PR','SC','RS','MS','GO','AC',
        'AL','AP','AM','BA','CE','DF','MA','MT','PA','PB',
        'PE','PI','RN','RO','RR','SE','TO')

ano <- c('06','07','08','09','10','11','12',
                '13','14','15','16','17','18','19','20')

mes <- c('01','02','03','04','05','06','07','08','09','10','11','12')

tipo <-c('DC','EE','EF','EP','EQ','GM','HB','IN','LT','PF','RC','SR','ST')

#fazer para separadamente para os anos 2005 e para o último ano de input
ano <- c('05')
mes <- c('08','09','10','11','12')

ano <- c('21')
mes <- c('01','02','03','04','05','06')

# Laço coloca como input  (criar pasta CSV em input)
for (d in tipo){
  for (i in uf) {
    for (j in ano) {
      for (m in mes) {
              try(a <- paste0('input/',d,'/',d,i,j,m,'.dbc'))
              try(df <- read.dbc::read.dbc(a))
              try(write.csv(df,paste0('input/CSV/',d,i,j,m,'.csv')))
              try(print(paste0(d,i,j,m)))
      }
      
    }
    
  }

}