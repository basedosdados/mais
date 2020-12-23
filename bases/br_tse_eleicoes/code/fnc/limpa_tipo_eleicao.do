
// author: Ricardo Dahis
// last updated: 2020/10/02

cap program drop limpa_tipo_eleicao
program limpa_tipo_eleicao
	
	local ano = `1'
	
	replace tipo_eleicao = "eleicao ordinaria"			if tipo_eleicao == "ordinaria"
	replace tipo_eleicao = "eleicao ordinaria"			if tipo_eleicao == "eleicoes `ano'"
	replace tipo_eleicao = "eleicao ordinaria"			if tipo_eleicao == "eleicao municipal 2012"
	replace tipo_eleicao = "eleicao ordinaria"			if tipo_eleicao == "eleicoes gerais 2014"
	replace tipo_eleicao = "eleicao ordinaria"			if tipo_eleicao == "eleicoes municipais 2016"
	replace tipo_eleicao = "eleicao ordinaria"			if tipo_eleicao == "eleicoes gerais estaduais 2018"
	replace tipo_eleicao = "eleicao ordinaria"			if tipo_eleicao == "eleicao geral federal 2018"
	replace tipo_eleicao = "eleicao ordinaria"			if tipo_eleicao == "eleicoes municipais 2020"
	
end
