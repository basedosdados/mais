*** Pacote basedosdados - EXEMPLO 1 - NOTA MÉDIA IDESP MUNICÍPIOS 2019 ***
*** Isabella | Data: 18/03/2022                                        ***

*1.1) DADOS
cd "C:/Users/isabe/OneDrive/Documentos/GitHub/mais/stata-package/testes/" // defina a pasta onde serão salvos os arquivos

bd_read_sql, path("~/Downloads/SP_2019.csv") query("SELECT id_municipio, AVG(nota_idesp_em) as nota_em FROM `basedosdados.br_sp_seduc_idesp.escola` WHERE ano = 2019 GROUP BY id_municipio") billing_project_id("monografia-12061998") // não esqueça de substituir "monografia-12061998" pelo nome do seu projeto
tempfile v
save `v', replace 

*1.2) ANÁLISE
*mais como fazer mapas no stata em: https://medium.com/the-stata-guide/maps-in-stata-ii-fcb574270269
use dadosmapa/spdata.dta, clear
rename CD_GEOCODI id_municipio
destring id_municipio, replace
merge 1:1 id_municipio using `v', keep(3)

colorpalette w3 deep-orange, n(5) nograph // paleta de cores 
local colors `r(p)'

*MAPA
spmap nota_em using brasilcoor.dta, id(id) name(m2019, replace) cln(5) ocolor(black ..) osize(0.01 ..) fcolor("`colors'")   clmethod(custom) clb(0 2 3 4 5:6 ) ///
  legend(pos(7) size(*1)) legstyle(2) title("Nota Média do IDESP em 2019", size(medium)) ///
   note("Data source: Base dos Dados/SEDUC." , size(tiny)) 



