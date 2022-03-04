
import delimited "~/Downloads/municipio.csv", clear encoding("utf-8") stringcols(_all)
keep id_municipio municipio sigla_uf
ren municipio nome_municipio
tempfile munic
save `munic'

import delimited "~/Downloads/Análise - Tabela da lista das escolas - Detalhado.csv", clear varn(nonames) encoding("utf-8") stringcols(_all)

drop in 1

ren v1	restricao_atendimento
ren v2	nome
ren v3	id_escola
ren v4	sigla_uf
ren v5	nome_municipio
ren v6	localizacao
ren v7	localidade_diferenciada
ren v8	categoria_administrativa
ren v9	endereco
ren v10	telefone
ren v11	dependencia_administrativa
ren v12	categoria_privada
ren v13	conveniada_poder_publico
ren v14	regulacao_conselho_educacao
ren v15	porte
ren v16	etapas_modalidades_oferecidas
ren v17	outras_ofertas_educacionais
ren v18	latitude
ren v19	longitude

replace nome_municipio = "Araças" if sigla_uf == "BA" & nome_municipio == "Araçás"
replace nome_municipio = "Iuiú" if sigla_uf == "BA" & nome_municipio == "Iuiu"
replace nome_municipio = "Muquém de São Francisco" if sigla_uf == "BA" & nome_municipio == "Muquém do São Francisco"
replace nome_municipio = "Santa Teresinha" if sigla_uf == "BA" & nome_municipio == "Santa Terezinha"
replace nome_municipio = "Ererê" if sigla_uf == "CE" & nome_municipio == "Ereré"
replace nome_municipio = "Itapagé" if sigla_uf == "CE" & nome_municipio == "Itapajé"
replace nome_municipio = "Atilio Vivacqua" if sigla_uf == "ES" & nome_municipio == "Atílio Vivacqua"
replace nome_municipio = "São Luíz do Norte" if sigla_uf == "GO" & nome_municipio == "São Luiz do Norte"
replace nome_municipio = "Dona Eusébia" if sigla_uf == "MG" & nome_municipio == "Dona Euzébia"
replace nome_municipio = "Passa-Vinte" if sigla_uf == "MG" & nome_municipio == "Passa Vinte"
replace nome_municipio = "Pingo-d'Água" if sigla_uf == "MG" & nome_municipio == "Pingo d'Água"
replace nome_municipio = "São Thomé das Letras" if sigla_uf == "MG" & nome_municipio == "São Tomé das Letras"
replace nome_municipio = "Poxoréo" if sigla_uf == "MT" & nome_municipio == "Poxoréu"
replace nome_municipio = "Eldorado dos Carajás" if sigla_uf == "PA" & nome_municipio == "Eldorado do Carajás"
replace nome_municipio = "Santa Isabel do Pará" if sigla_uf == "PA" & nome_municipio == "Santa Izabel do Pará"
replace nome_municipio = "Quixabá" if sigla_uf == "PB" & nome_municipio == "Quixaba"
replace nome_municipio = "Iguaraci" if sigla_uf == "PE" & nome_municipio == "Iguaracy"
replace nome_municipio = "São Vicente Ferrer" if sigla_uf == "PE" & nome_municipio == "São Vicente Férrer"
replace nome_municipio = "Augusto Severo" if sigla_uf == "RN" & nome_municipio == "Campo Grande"
replace nome_municipio = "Olho-d'Água do Borges" if sigla_uf == "RN" & nome_municipio == "Olho d'Água do Borges"
replace nome_municipio = "Restinga Seca" if sigla_uf == "RS" & nome_municipio == "Restinga Sêca"
replace nome_municipio = "Vespasiano Correa" if sigla_uf == "RS" & nome_municipio == "Vespasiano Corrêa"
replace nome_municipio = "Westfalia" if sigla_uf == "RS" & nome_municipio == "Westfália"
replace nome_municipio = "Lauro Muller" if sigla_uf == "SC" & nome_municipio == "Lauro Müller"
replace nome_municipio = "São Cristovão do Sul" if sigla_uf == "SC" & nome_municipio == "São Cristóvão do Sul"
replace nome_municipio = "Biritiba-Mirim" if sigla_uf == "SP" & nome_municipio == "Biritiba Mirim"
replace nome_municipio = "Florínia" if sigla_uf == "SP" & nome_municipio == "Florínea"
replace nome_municipio = "Itaóca" if sigla_uf == "SP" & nome_municipio == "Itaoca"
replace nome_municipio = "São Luís do Paraitinga" if sigla_uf == "SP" & nome_municipio == "São Luiz do Paraitinga"
replace nome_municipio = "Fortaleza do Tabocão" if sigla_uf == "TO" & nome_municipio == "Tabocão"

merge m:1 sigla_uf nome_municipio using `munic'
drop if _merge == 2
drop _merge nome_municipio

order id_escola nome id_municipio sigla_uf

export delimited "~/Downloads/escola.csv", datafmt


