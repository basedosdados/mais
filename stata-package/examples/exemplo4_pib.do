*** Pacote basedosdados - EXEMPLO 4 - PIB PER CAPITA DOS MUNICÍPIOS BRASILEIROS 2018 ***
*** Isabella | Data: 18/03/2022                                                      ***

*EXEMPLO 4
*4.1) DADOS
cd "C:/Users/isabe/OneDrive/Documentos/GitHub/mais/stata-package/testes/" // defina a pasta onde serão salvos os arquivos

bd_read_sql, path("~/Downloads/PIB.csv") query("SELECT pib.id_municipio, pop.ano, pib.PIB / pop.populacao as pib_pc FROM `basedosdados.br_ibge_pib.municipio` as pib INNER JOIN `basedosdados.br_ibge_populacao.municipio` as pop ON pib.id_municipio = pop.id_municipio AND pib.ano = pop.ano") billing_project_id("monografia-12061998")

keep if ano == 2018
tempfile v
save `v'

*4.2) ANÁLISE

use dadosmapa/brasildata.dta, clear
cap rename CD_GEOCODI id_municipio
cap rename CD_GEOCODM id_municipio 
cap rename CD_GEOCODS id_municipio 
destring id_municipio, replace
merge 1:1 id_municipio using `v', keep(3)

colorpalette w3 green, n(5) nograph
local colors `r(p)'

*MAPA
spmap pib_pc using brasilcoor.dta, id(id) name(m2019, replace) cln(5) ocolor(black ..) osize(0.0 ..) fcolor("`colors'") ///
  legend(pos(7) size(*1)) legstyle(2) title("Mapa PIB per capita por municípios 2018", size(small)) ///
   note("Data source: Base dos Dados." , size(tiny)) 
