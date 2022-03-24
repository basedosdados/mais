*** Pacote basedosdados - EXEMPLO 3 - EVOLUÇÃO QUANTIDADE DE VÍNCULOS DE MULHERES NA RAIS ENTRE 1989/2019  ***
*** Isabella | Data: 18/03/2022                                                                            ***

*EXEMPLO 3 
*3.1) DADOS
cd "C:/Users/isabe/OneDrive/Documentos/GitHub/mais/stata-package/testes/" // defina a pasta onde serão salvos os arquivos

bd_read_sql, path("~/Downloads/RAIS.csv") query("SELECT ano, sexo, sum(vinculo_ativo_3112) vinculo  FROM `basedosdados.br_me_rais.microdados_vinculos` WHERE ano = 1985 OR ano = 2019 GROUP BY ano, sexo") billing_project_id("monografia-12061998")

*3.2) ANÁLISE
bysort ano: egen id = sum(vinculo)
gen percentual = (vinculo/id)

*GRÁFICO
betterbarci percentual, over(sexo) by(ano) legend(on pos(3) col(1) label(1 "Men") lab(2 "Woman")) ///
 barcolor(blue green) ///
barlab v pct ///
title("Evolução do número de vinculos na RAIS de mulheres entre 1989 e 2019", size(3.5)) ///
graphregion(fcolor(white)) 
