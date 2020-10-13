
// author: Ricardo Dahis
// last updated: 2020/10/02

cap program drop limpa_tipo_eleicao
program limpa_tipo_eleicao
	
	local ano = `1'
	
	replace tipo_eleicao = "eleicoes 2012"				if tipo_eleicao == "eleicao municipal 2012"
	replace tipo_eleicao = "eleicoes 2014"				if tipo_eleicao == "eleicoes gerais 2014"
	replace tipo_eleicao = "eleicoes 2016"				if tipo_eleicao == "eleicoes municipais 2016"
	replace tipo_eleicao = "eleicoes 2018"				if tipo_eleicao == "eleicoes gerais estaduais 2018"
	replace tipo_eleicao = "eleicoes 2018"				if tipo_eleicao == "eleicao geral federal 2018"
	replace tipo_eleicao = "eleicoes 2020"				if tipo_eleicao == "eleicoes municipais 2020"
	replace tipo_eleicao = "eleicoes `ano'"				if tipo_eleicao == "eleicao ordinaria"
	replace tipo_eleicao = "eleicao suplementar `ano'"	if tipo_eleicao == "eleicao suplementar"
	
end
