
cap program drop limpa_tipo_eleicao
program limpa_tipo_eleicao
	
	local ano = `1'
	
	replace tipo_eleicao = "eleicao ordinaria"	if tipo_eleicao == ""
	replace tipo_eleicao = "eleicao ordinaria"	if tipo_eleicao == "ordinaria"
	replace tipo_eleicao = "eleicao ordinaria"	if tipo_eleicao == "eleicoes ordinarias - `ano'"
	replace tipo_eleicao = "eleicao ordinaria"	if tipo_eleicao == "eleicoes `ano'"
	replace tipo_eleicao = "eleicao ordinaria"	if tipo_eleicao == "eleicao `ano'"
	replace tipo_eleicao = "eleicao ordinaria"	if tipo_eleicao == "eleicao municipal `ano'"
	replace tipo_eleicao = "eleicao ordinaria"	if tipo_eleicao == "eleicoes gerais `ano'"
	replace tipo_eleicao = "eleicao ordinaria"	if tipo_eleicao == "eleicoes gerais `ano' primeiro turno"
	replace tipo_eleicao = "eleicao ordinaria"	if tipo_eleicao == "eleicoes gerais `ano' segundo turno"
	replace tipo_eleicao = "eleicao ordinaria"	if tipo_eleicao == "eleicoes municipais de `ano' - 1. turno"
	replace tipo_eleicao = "eleicao ordinaria"	if tipo_eleicao == "eleicoes municipais de `ano' - 2. turno"
	replace tipo_eleicao = "eleicao ordinaria"	if tipo_eleicao == "eleicoes municipais de `ano' - 1 turno"
	replace tipo_eleicao = "eleicao ordinaria"	if tipo_eleicao == "eleicoes municipais de `ano' - 2 turno"
	replace tipo_eleicao = "eleicao ordinaria"	if tipo_eleicao == "eleicoes municipais `ano'"
	replace tipo_eleicao = "eleicao ordinaria"	if tipo_eleicao == "eleicoes gerais estaduais `ano'"
	replace tipo_eleicao = "eleicao ordinaria"	if tipo_eleicao == "eleicao geral federal `ano'"
	
end
