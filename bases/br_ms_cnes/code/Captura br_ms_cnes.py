import wget
import ftplib


# DC,EE,EF,EP,EP,EQ,GM,HB,IN,LT,PF,RC,SR,ST - Cada uma das tabelas do CNES
# caminho estabelecimento 'dissemin/publicos/CNES/200508_/Dados/ST/' - Para Estabelecimentos 

#Verifica arquivos no caminho do folder correspondente
with ftplib.FTP("ftp.datasus.gov.br") as ftp:
    ftp.login()
    ftp.dir('dissemin/publicos/CNES/200508_/Dados/')

#define os parâmetros para o link de download
tipo = ['DC','EE','EF','EP','EQ','GM','HB','IN','LT','PF','RC','SR','ST']

uf = ['RJ','SP','ES','MG','PR','SC','RS','MS','GO','AC',
      'AL','AP','AM','BA','CE','DF','MA','MT','PA','PB',
      'PE','PI','RN','RO','RR','SE','TO']

ano = ['05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21']

mes = ['01','02','03','04','05','06','07','08','09','10','11','12']

#Laço para download
for d in tipo:
    for a in uf:
        for b in ano:
            for c in mes:
                try:
                    link = "ftp://ftp.datasus.gov.br/dissemin/publicos/CNES/200508_/Dados/{}/{}{}{}{}.dbc".format(d,d,a,b,c)
                    wget.download(link)
                    print(d,a,b,c)
                except: pass
