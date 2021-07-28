
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
clear programs
cap log close
set more off, perm
set rmsg off

cd "~/Downloads/dados_vacinacao"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

import delimited "input/municipio.csv", clear varn(1) encoding("utf-8")
keep id_municipio id_municipio_6
tostring *, replace
tempfile munic
save `munic'

! mkdir "output/microdados_vacinacao"
! mkdir "output/microdados_paciente"
! mkdir "output/microdados_estabelecimento"

local ufs AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

foreach uf in `ufs' {
	
	//--------------------//
	// vacinacao
	//--------------------//
	
	! mkdir "output/microdados_vacinacao/sigla_uf=`uf'"
	
	import delimited "input/`uf'.csv", clear case(preserve) stringcols(_all) delim(";") encoding("utf-8")
	
	keep	document_id ///
			paciente_id ///
			estabelecimento_valor ///
			vacina_grupoAtendimento_codigo ///
			vacina_grupoAtendimento_nome ///
			vacina_categoria_codigo ///
			vacina_categoria_nome ///
			vacina_lote ///
			vacina_fabricante_nome ///
			vacina_fabricante_referencia ///
			vacina_dataAplicacao ///
			vacina_descricao_dose ///
			vacina_codigo ///
			vacina_nome ///
			sistema_origem ///
			data_importacao_rnds ///
			id_sistema_origem
	
	drop vacina_grupoAtendimento_nome vacina_categoria_nome vacina_nome sistema_origem
	
	ren document_id                    id_documento
	ren paciente_id                    id_paciente
	ren estabelecimento_valor          id_estabelecimento
	ren vacina_grupoAtendimento_codigo grupo_atendimento
	ren vacina_categoria_codigo        categoria
	ren vacina_lote                    lote
	ren vacina_fabricante_nome         nome_fabricante
	ren vacina_fabricante_referencia   referencia_fabricante
	ren vacina_descricao_dose          dose
	ren vacina_codigo                  vacina
	ren id_sistema_origem              sistema_origem
	
	destring grupo_atendimento, replace
	replace grupo_atendimento = . if grupo_atendimento == 0
	
	replace dose = subinstr(dose, "    ", "", .)
	replace dose = subinstr(dose, "   ", "", .)
	replace dose = subinstr(dose, "  ", "", .)
	
	gen data_aplicacao = substr(vacina_dataAplicacao, 1, 10)
	order data_aplicacao, a(vacina_dataAplicacao)
	drop vacina_dataAplicacao
	
	gen tempo_importacao_rnds    = substr(data_importacao_rnds, 12, 8)
	replace data_importacao_rnds = substr(data_importacao_rnds, 1, 10)
	order tempo_importacao_rnds, a(data_importacao_rnds)
	
	export delimited "output/microdados_vacinacao/sigla_uf=`uf'/microdados_vacinacao.csv", replace datafmt
	
	//--------------------//
	// paciente
	//--------------------//
	
	! mkdir "output/microdados_paciente/sigla_uf_endereco=`uf'"
	
	import delimited "input/`uf'.csv", clear case(preserve) stringcols(_all) delim(";") encoding("utf-8")
	
	keep	paciente_id ///
			paciente_idade ///
			paciente_dataNascimento ///
			paciente_enumSexoBiologico ///
			paciente_racaCor_codigo ///
			paciente_racaCor_valor ///
			paciente_endereco_coIbgeMunicipi ///
			paciente_endereco_coPais ///
			paciente_endereco_nmMunicipio ///
			paciente_endereco_nmPais ///
			paciente_endereco_uf ///
			paciente_endereco_cep ///
			paciente_nacionalidade_enumNacio
	
	duplicates drop
	
	drop paciente_racaCor_valor paciente_endereco_nmMunicipio paciente_endereco_nmPais
	
	ren paciente_id                      id_paciente
	ren paciente_idade                   idade
	ren paciente_dataNascimento          data_nascimento
	ren paciente_enumSexoBiologico       sexo
	ren paciente_racaCor_codigo          raca_cor
	ren paciente_endereco_coPais         pais_endereco
	ren paciente_endereco_uf             sigla_uf_endereco
	ren paciente_endereco_cep            cep_endereco
	ren paciente_nacionalidade_enumNacio nacionalidade
	
	destring raca_cor, replace
	
	ren paciente_endereco_coIbgeMunicipi id_municipio_6
	merge m:1 id_municipio_6 using `munic'
	drop if _merge == 2
	drop _merge
	ren id_municipio id_municipio_endereco
	order id_municipio_endereco, a(id_municipio_6)
	drop id_municipio_6
	
	drop sigla_uf_endereco
	
	export delimited "output/microdados_paciente/sigla_uf_endereco=`uf'/microdados_paciente.csv", replace datafmt
	
	//--------------------//
	// estabelecimento
	//--------------------//
	
	! mkdir "output/microdados_estabelecimento/sigla_uf=`uf'"
	
	import delimited "input/`uf'.csv", clear case(preserve) stringcols(_all) delim(";") encoding("utf-8")
	
	keep	estabelecimento_valor ///
			estabelecimento_razaoSocial ///
			estalecimento_noFantasia ///
			estabelecimento_municipio_codigo ///
			estabelecimento_uf
	
	duplicates drop
	
	ren estabelecimento_valor            id_estabelecimento
	ren estabelecimento_razaoSocial      razao_social
	ren estalecimento_noFantasia         nome_fantasia
	ren estabelecimento_uf               sigla_uf
	
	ren estabelecimento_municipio_codigo id_municipio_6 
	merge m:1 id_municipio_6 using `munic'
	drop if _merge == 2
	drop _merge
	order id_municipio, a(id_municipio_6)
	drop id_municipio_6
	
	drop sigla_uf
	
	export delimited "output/microdados_estabelecimento/sigla_uf=`uf'/microdados_estabelecimento.csv", replace datafmt
	
}
*
