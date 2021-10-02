# -*- coding: utf-8 -*-
"""
Created on Tue Sep 14 22:20:51 2021

@author: Gustavo Aires Tiago
"""
import wget
import pandas as pd

#download
wget.download('https://sidra.ibge.gov.br/geratabela?format=br.csv&name=tabela1737.csv&terr=N&rank=-&query=t/1737/n1/all/v/all/p/all/d/v63%202,v69%202,v2263%202,v2264%202,v2265%202,v2266%2013/l/,v,t%2Bp&abreviarRotulos=True&exibirNotas=False')

#Lista para renomear e ordenar 
rename= {'IPCA - Número-índice (base: dezembro de 1993 = 100) (Número-índice)':'indice',
         'IPCA - Variação mensal (%)':'variacao_mes',
         'IPCA - Variação acumulada em 3 meses (%)':'variacao_tres_meses',
         'IPCA - Variação acumulada em 6 meses (%)':'variacao_semestral',
         'IPCA - Variação acumulada no ano (%)':'variacao_anual',
         'IPCA - Variação acumulada em 12 meses (%)':'variacao_doze_meses'}

ordem = ['ano','mes','indice','variacao_mes','variacao_tres_meses','variacao_semestral',
         'variacao_anual','variacao_doze_meses']


df = pd.read_csv('tabela1737.csv',skiprows=2,skipfooter=13,sep=';')

df['mes'] , df['ano'] = df['Mês'].str.split(' ',1).str

df['mes'] = df['mes'].map({'janeiro':'1',
                           'fevereiro':'2',
                           'março':'3',
                           'abril':'4',
                           'maio':'5',
                           'junho':'6',
                           'julho':'7',
                           'agosto':'8',
                           'setembro':'9',
                           'outubro':'10',
                           'novembro':'11',
                           'dezembro':'12',
                           })

df=df.replace('...','')
df=df.replace(',','.',regex=True)
df.rename(columns=rename, inplace=True)
df = df[ordem]

df.to_csv('ipca.csv',index=False)
