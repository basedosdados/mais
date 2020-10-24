
//----------------------------------------------------------------------------//
// build: microdados
//----------------------------------------------------------------------------//

import delimited "input/municipios.csv", clear varn(1) stringcols(_all)

keep id_municipio id_municipio_6

tempfile municipios
save `municipios'

! mkdir "output/microdados"

foreach estado in AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO {
	
	foreach ano of numlist 1996(1)2018 {
		
		di "`estado' `ano'"
		
		import delimited using "input/dados/DO`estado'`ano'.csv", clear varn(1) stringcols(_all)
		
		drop v1 
		cap drop ufinform
		cap drop origem
		
		foreach k of varlist _all {
			replace `k' = "" if `k' == "NA"
		}
		*
		
		ren contador	sequencial_obito
		ren tipobito	tipo_obito
		ren dtobito		data_obito
		ren natural		naturalidade
		ren dtnasc		data_nasc
		ren idade		idade
		ren sexo		genero
		ren racacor		raca_cor
		ren estciv		estado_civil
		ren esc			escolaridade
		ren ocup		ocupacao
		ren lococor		local_ocor
		ren idademae	idade_mae
		ren escmae		escolaridade_mae
		ren ocupmae		ocupacao_mae
		ren qtdfilvivo	qtde_filhos_vivos
		ren qtdfilmort	qtde_filhos_mortos
		ren gravidez	gravidez
		ren gestacao	gestacao
		ren parto		parto
		ren obitoparto	obito_parto
		ren peso		peso
		ren obitograv	obito_gravidez
		ren obitopuerp	obito_puerperio
		ren assistmed	assistencia_medica
		ren exame		exame
		ren cirurgia	cirurgia
		ren necropsia	necropsia
		ren causabas	causa_basica
		ren linhaa		linha_a
		ren linhab		linha_b
		ren linhac		linha_c
		ren linhad		linha_d
		ren linhaii		linha_ii
		ren circobito	circunstancia_obito
		ren acidtrab	acidente_trabalho
		ren fonte		fonte
		
		cap ren codbaires		codigo_bairro_resid
		cap ren codestab		id_estab
		cap ren atestante		atestante
		cap ren horaobito		hora_obito
		cap ren dtatestado		data_atestado
		cap ren tppos			tipo_pos
		cap ren dtinvestig		data_investigacao
		cap ren causabas_o		causa_basica_original
		cap ren dtcadastro		data_cadastro
		cap ren fonteinv		fonte_investigacao
		cap ren dtrecebim		data_recebimento
		cap ren codbaiocor		codigo_bairro_ocor			
		cap ren cb_pre			causa_basica_pre
		cap ren tpassina		tipo_assinatura
		cap ren morteparto		morte_parto
		cap ren tpobitocor		tipo_obito_ocor
		cap ren numerodn		numero_DN
		cap ren dtcadinf		data_cadastro_inf				// XX: checar
		cap ren dtcadinv		data_cadastro_investigacao
		cap ren causamat		causa_materna
		cap ren dtrecorig		data_recebimento_original
		cap ren dtrecoriga		data_recoriga					// XX entender
		cap ren esc2010			escolaridade_2010
		cap ren escmae2010		escolaridade_mae_2010
		cap ren stdoepidem		status_DO_epidem
		cap ren stdonova		status_DO_nova
		cap ren seriescfal		serie_escolar_falecido
		cap ren seriescmae		serie_escolar_mae
		cap ren semagestac		semanas_gestacao
		cap ren tpmorteoco		tipo_morte_ocor
		cap ren difdata			diferenca_data
		cap ren dtconinv		data_conclusao_investigacao
		cap ren dtconcaso		data_conclusao_caso
		cap ren nudiasobin		numero_dias_obito_investigacao
		cap ren escmaeagr1		escolaridade_mae_2010_agr
		cap ren escfalagr1		escolaridade_falecido_2010_agr
		cap ren expdifdata		exp_diferenca_data				// XX entender
		cap ren codcart			codigo_cartorio
		cap ren numregcart		numero_registro_cartorio
		cap ren dtregcart		data_registro_cartorio	
		cap ren estabdescr		descricao_estab					// XX entender
		cap ren cb_pre			causa_basica_pre_resselecao
		cap ren crm				CRM
		cap ren numerolote		numero_lote
		cap ren stcodifica		status_codificadora
		cap ren codificado		codificado
		cap ren versaosist		versao_sistema
		cap ren versaoscb		versao_SCB
		cap ren atestado		atestado
		cap ren escmaeagr1		escolaridade_mae_2010_agr
		cap ren escfalagr1		escolaridade_falecido_2010_agr
		cap ren nudiasobco		numero_dias_obito_ficha
		cap ren fontes			fontes
		cap ren tpresginfo		tipo_resgate_informacao
		cap ren tpnivelinv		tipo_nivel_investigador
		cap ren nudiasinf		numero_dias_inf					// XX entender
		cap ren fontesinf		fontes_inf						// XX entender
		cap ren altcausa		alt_causa						// XX entender
		
		//--------------------//
		// ajusta codigos IBGE
		// 6 vs 7 digitos
		// entre anos
		//--------------------//
		
		if `ano' <= 2005 {
			
			ren codmunres	id_municipio_resid
			ren codmunocor	id_municipio_ocor
			
		}
		else if `ano' >= 2006 {
			
			ren codmunres id_municipio_6
			merge m:1 id_municipio_6 using `municipios'
			drop if _merge == 2
			ren id_municipio id_municipio_resid
			order id_municipio_resid, a(id_municipio_6)
			drop _merge id_municipio_6
			
			ren codmunocor id_municipio_6
			merge m:1 id_municipio_6 using `municipios'
			drop if _merge == 2
			ren id_municipio id_municipio_ocor
			order id_municipio_ocor, a(id_municipio_6)
			drop _merge id_municipio_6
			
		}
		*
		
		cap confirm variable comunsvoim
		if !_rc {
			ren comunsvoim id_municipio_6
			merge m:1 id_municipio_6 using `municipios'
			drop if _merge == 2
			ren id_municipio id_municipio_SVO_IML
			order id_municipio_SVO_IML, a(id_municipio_6)
			drop _merge id_municipio_6
		}
		cap confirm variable codmuncart
		if !_rc {
			ren codmuncart id_municipio_6
			merge m:1 id_municipio_6 using `municipios'
			drop if _merge == 2
			ren id_municipio id_municipio_cartorio
			order id_municipio_cartorio, a(id_municipio_6)
			drop _merge id_municipio_6
		}
		cap confirm variable codmunnatu
		if !_rc {
			ren codmunnatu id_municipio_6
			merge m:1 id_municipio_6 using `municipios'
			drop if _merge == 2
			ren id_municipio id_municipio_naturalidade
			order id_municipio_naturalidade, a(id_municipio_6)
			drop _merge id_municipio_6
		}
		*
		
		gen ano				= `ano'
		gen estado_abrev	= "`estado'"
		
		tempfile DO`estado'`ano'
		save `DO`estado'`ano''
	
	}
	*
	
	//---------------//
	// append
	//---------------//
	
	use `DO`estado'1996', clear
	foreach ano of numlist 1997(1)2018 {
		append using `DO`estado'`ano''
	}
	*
	
	destring sequencial_obito id_municipio_* peso idade_mae, replace force
	
	replace local_ocor = ""				if inlist(local_ocor, "0", "6", "7", "9")
	replace genero = ""					if inlist(genero, "0", "6", "7", "9")
	replace raca_cor = ""				if inlist(raca_cor, "0", "6", "7", "9")
	replace estado_civil = ""			if inlist(estado_civil, "0", "6", "7", "9")
	replace escolaridade = ""			if inlist(escolaridade, "0", "6", "7", "9", "A")
	replace escolaridade_mae = ""		if inlist(escolaridade_mae, "0", "6", "7", "9", "A")
	replace escolaridade_2010 = ""		if inlist(escolaridade_2010, "9")
	replace escolaridade_mae_2010 = ""	if inlist(escolaridade_mae_2010, "9")
	replace gravidez = ""				if inlist(gravidez, "0", "6", "7", "9")
	replace gestacao = ""				if inlist(gestacao, "0", "9")
	replace parto = ""					if inlist(parto, "0", "3", "4", "5", "6", "7", "9")
	replace obito_parto = ""			if inlist(obito_parto, "0", "4", "5", "6", "7", "9")
	replace morte_parto = ""			if inlist(morte_parto, "0", "4", "5", "6", "7", "9")
	replace peso = .					if peso == 0
	replace obito_gravidez = ""			if inlist(obito_gravidez, "0", "3", "4", "5", "6", "7", "9")
	replace obito_puerperio = ""		if inlist(obito_puerperio, "0", "4", "5", "6", "7", "9")
	replace assistencia_medica = ""		if inlist(assistencia_medica, "0", "4", "5", "6", "7", "9")
	replace exame = ""					if inlist(exame, "0", "4", "5", "6", "7", "9")
	replace cirurgia = ""				if inlist(cirurgia, "0", "4", "5", "6", "7", "9")
	replace necropsia = ""				if inlist(necropsia, "0", "4", "5", "6", "7", "9")
	replace circunstancia_obito = ""	if inlist(circunstancia_obito, "0", "5", "6", "7", "9")
	replace acidente_trabalho = ""		if inlist(acidente_trabalho, "0", "3", "4", "5", "6", "7", "9")
	replace fonte = ""					if inlist(fonte, "0", "5", "6", "7", "9")
	replace fonte_inv = ""				if inlist(fonte_inv, "0", "9")
	replace tipo_morte_ocor = ""		if inlist(tipo_morte_ocor, "9")
	
	replace tipo_obito		= "fetal"		if tipo_obito == "1"
	replace tipo_obito		= "nao-fetal"	if tipo_obito == "2"
	
	replace genero			= "masculino"	if genero == "1"
	replace genero			= "feminino"	if genero == "2"
	
	replace raca_cor		= "branca"		if raca_cor == "1"
	replace raca_cor		= "preta"		if raca_cor == "2"
	replace raca_cor		= "amarela"		if raca_cor == "3"
	replace raca_cor		= "parda"		if raca_cor == "4"
	replace raca_cor		= "indigena"	if raca_cor == "5"
	
	replace estado_civil	= "solteiro(a)"			if estado_civil == "1"
	replace estado_civil	= "casado(a)"			if estado_civil == "2"
	replace estado_civil	= "viuvo(a)"			if estado_civil == "3"
	replace estado_civil	= "separado(a)"			if estado_civil == "4"
	replace estado_civil	= "uniao consensual"	if estado_civil == "5"
	
	foreach k in escolaridade escolaridade_mae {
		
		replace `k'	= "nenhuma"		if `k' == "1"
		replace `k'	= "1 a 3 anos"	if `k' == "2"
		replace `k'	= "4 a 7 anos"	if `k' == "3"
		replace `k'	= "8 a 11 anos"	if `k' == "4"
		replace `k'	= "12 e mais"	if `k' == "5"
		replace `k'	= "9 a 11 anos"	if `k' == "8"
		
	}
	*
	
	foreach k in escolaridade_2010 escolaridade_mae_2010 {
		
		replace `k'	= "sem escolaridade"	if `k' == "0"
		replace `k'	= "fundamental I"		if `k' == "1"
		replace `k'	= "fundamental II"		if `k' == "2"
		replace `k'	= "medio"				if `k' == "3"
		replace `k'	= "superior incompleto"	if `k' == "4"
		replace `k'	= "superior completo"	if `k' == "5"
		
	}
	*
	
	foreach k in escolaridade_mae_2010_agr escolaridade_falecido_2010_agr {
		
		replace `k'	= "sem escolaridade"							if `k' == "00"
		replace `k'	= "fundamental I incompleto"					if `k' == "01"
		replace `k'	= "fundamental I completo"						if `k' == "02"
		replace `k'	= "fundamental II incompleto"					if `k' == "03"
		replace `k'	= "fundamental II completo"						if `k' == "04"
		replace `k'	= "ensino medio incompleto"						if `k' == "05"
		replace `k'	= "ensino medio completo"						if `k' == "06"
		replace `k'	= "ensino superior incompleto"					if `k' == "07"
		replace `k'	= "ensino superior completo"					if `k' == "08"
		replace `k'	= "ignorado"									if `k' == "09"
		replace `k'	= "fundamental I incompleto ou inespecifico"	if `k' == "10"
		replace `k'	= "fundamental II incompleto ou inespecifico"	if `k' == "11"
		replace `k'	= "ensino medio incompleto ou inespecifico"		if `k' == "12"
		
	}
	*
	
	replace local_ocor	= "hospital"				if local_ocor == "1"
	replace local_ocor	= "outro estab. de saude"	if local_ocor == "2"
	replace local_ocor	= "domicilio"				if local_ocor == "3"
	replace local_ocor	= "via publica"				if local_ocor == "4"
	replace local_ocor	= "outros"					if local_ocor == "5"
	
	replace gravidez			= "unica"					if gravidez == "1"
	replace gravidez			= "dupla"					if gravidez == "2"
	replace gravidez			= "tripla ou mais"			if gravidez == "3"
	
	replace gestacao			= "21 a 27 semanas"			if gestacao == "A"
	replace gestacao			= "menos de 22 semanas"		if gestacao == "1"
	replace gestacao			= "22 a 27 semanas"			if gestacao == "2"
	replace gestacao			= "28 a 31 semanas"			if gestacao == "3"
	replace gestacao			= "32 a 36 semanas"			if gestacao == "4"
	replace gestacao			= "37 a 41 semanas"			if gestacao == "5"
	replace gestacao			= "42 semanas ou mais"		if gestacao == "6"
	replace gestacao			= "28 semanas ou mais"		if gestacao == "7"
	replace gestacao			= "28 a 36 semanas"			if gestacao == "8"
	
	replace parto				= "vaginal"	if parto == "1"
	replace parto				= "cesareo"	if parto == "2"
	
	replace obito_parto			= "antes"	if obito_parto == "1"
	replace obito_parto			= "durante"	if obito_parto == "2"
	replace obito_parto			= "depois"	if obito_parto == "3"
	
	replace obito_gravidez		= "sim" if obito_gravidez == "1"
	replace obito_gravidez		= "nao" if obito_gravidez == "2"
	
	replace obito_puerperio		= "0 a 42 dias"		if obito_puerperio == "1"
	replace obito_puerperio		= "43 dias a 1 ano" if obito_puerperio == "2"
	replace obito_puerperio		= "nao"				if obito_puerperio == "3"
	
	replace assistencia_medica	= "sim" if assistencia_medica == "1"
	replace assistencia_medica	= "nao" if assistencia_medica == "2"
	
	replace exame				= "sim" if exame == "1"
	replace exame				= "nao" if exame == "2"
	
	replace cirurgia			= "sim" if cirurgia == "1"
	replace cirurgia			= "nao" if cirurgia == "2"
	
	replace necropsia			= "sim" if necropsia == "1"
	replace necropsia			= "nao" if necropsia == "2"
	
	replace circunstancia_obito	= "acidente"	if circunstancia_obito == "1"
	replace circunstancia_obito	= "suicidio"	if circunstancia_obito == "2"
	replace circunstancia_obito	= "homicidio"	if circunstancia_obito == "3"
	replace circunstancia_obito	= "outro"		if circunstancia_obito == "4"
	
	replace acidente_trabalho	= "sim" if acidente_trabalho == "1"
	replace acidente_trabalho	= "nao" if acidente_trabalho == "2"
	
	replace fonte	= "boletim de ocorrencia"	if fonte == "1"
	replace fonte	= "hospital"				if fonte == "2"
	replace fonte	= "familia"					if fonte == "3"
	replace fonte	= "outro"					if fonte == "4"
	
	replace fonte_inv	= "comite de mortalidade materna e/ou infantil"	if fonte_inv == "1"
	replace fonte_inv	= "visita familiar / entrevista familia"		if fonte_inv == "2"
	replace fonte_inv	= "estabelecimento de saude / prontuario"		if fonte_inv == "3"
	replace fonte_inv	= "relacionamento com outros bancos de dados"	if fonte_inv == "4"
	replace fonte_inv	= "SVO"											if fonte_inv == "5"
	replace fonte_inv	= "IML"											if fonte_inv == "6"
	replace fonte_inv	= "outra fonte"									if fonte_inv == "7"
	replace fonte_inv	= "multiplas fontes"							if fonte_inv == "8"
	
	replace status_DO_epidem = "sim" if status_DO_epidem == "1"
	replace status_DO_epidem = "nao" if status_DO_epidem == "0"
	
	replace status_DO_nova = "sim" if status_DO_nova == "1"
	replace status_DO_nova = "nao" if status_DO_nova == "0"
	
	replace atestante	= "sim"			if atestante == "1"
	replace atestante	= "substituto"	if atestante == "2"
	replace atestante	= "IML"			if atestante == "3"
	replace atestante	= "SVO"			if atestante == "4"
	replace atestante	= "outros"		if atestante == "5"
	
	replace tipo_pos	= "sim" if tipo_pos == "S"
	replace tipo_pos	= "nao" if tipo_pos == "N"
	
	replace status_codificadora	= "sim" if status_codificadora == "S"
	replace status_codificadora	= "nao" if status_codificadora == "N"
	
	replace codificado	= "sim" if codificado == "S"
	replace codificado	= "nao" if codificado == "N"
	
	replace morte_parto			= "antes"	if morte_parto == "1"
	replace morte_parto			= "durante"	if morte_parto == "2"
	replace morte_parto			= "depois"	if morte_parto == "3"
	
	replace tipo_obito_ocor	= "durante a gestacao"										if tipo_obito_ocor == "1"
	replace tipo_obito_ocor	= "duranto abortamento"										if tipo_obito_ocor == "2"
	replace tipo_obito_ocor	= "apos abortamento"										if tipo_obito_ocor == "3"
	replace tipo_obito_ocor	= "no parto ou ate 1 hora apos o parto"						if tipo_obito_ocor == "4"
	replace tipo_obito_ocor	= "no puerperio (ate 42 dias do termino da gestacao)"		if tipo_obito_ocor == "5"
	replace tipo_obito_ocor	= "entre o 43º dia e ate um ano apos o termino da gestacao"	if tipo_obito_ocor == "6"
	replace tipo_obito_ocor	= "investigacao nao identificou o momento do obito"			if tipo_obito_ocor == "7"
	replace tipo_obito_ocor	= "mais de 1 ano apos o parto"								if tipo_obito_ocor == "8"
	replace tipo_obito_ocor	= "outras"													if tipo_obito_ocor == "9"
	
	replace tipo_morte_ocor	= "na gravidez"							if tipo_morte_ocor == "1"
	replace tipo_morte_ocor	= "no parto"							if tipo_morte_ocor == "2"
	replace tipo_morte_ocor	= "no aborto"							if tipo_morte_ocor == "3"
	replace tipo_morte_ocor	= "ate 42 dias apos o parto"			if tipo_morte_ocor == "4"
	replace tipo_morte_ocor	= "de 43 dias ate 1 ano apos o parto"	if tipo_morte_ocor == "5"
	replace tipo_morte_ocor	= "nao ocorreu nestes periodos"			if tipo_morte_ocor == "8"
	
	replace tipo_resgate_informacao	= "nao acrescentou nem corrigiu informacao"									if tipo_resgate_informacao == "1"
	replace tipo_resgate_informacao	= "sim, permitiu o resgate de novas informacoes"							if tipo_resgate_informacao == "2"
	replace tipo_resgate_informacao	= "sim, permitiu a correcao de alguma das causas informadas originalmente"	if tipo_resgate_informacao == "3"
	
	replace tipo_nivel_investigador	= "estadual"	if tipo_nivel_investigador == "E"
	replace tipo_nivel_investigador	= "regional"	if tipo_nivel_investigador == "R"
	replace tipo_nivel_investigador	= "municipal"	if tipo_nivel_investigador == "M"
	
	foreach k of varlist data_* {
		
		replace `k' = substr(`k', 5, 4) + "-" + substr(`k', 3, 2) + "-" + substr(`k', 1, 2) if length(`k') == 8 & `k' != "00000000"
		replace `k' = ""																	if length(`k') <  8 | `k' == "00000000"
		
	}
	*
	
	replace hora_obito = substr(hora_obito, 1, 2) + ":" + substr(hora_obito, 3, 2) + ":00" if length(hora_obito) == 4
	
	gen aux_idade = .
	replace aux_idade = 100 + real(substr(idade, 2, 2)) if substr(idade, 1, 1) == "5"
	replace aux_idade = real(substr(idade, 2, 2))		if substr(idade, 1, 1) == "4"
	replace aux_idade = real(substr(idade, 2, 2)) / 12	if substr(idade, 1, 1) == "3"
	replace aux_idade = real(substr(idade, 2, 2)) / 365	if substr(idade, 1, 1) == "2"
	replace aux_idade = 0								if substr(idade, 1, 1) == "1"
	replace aux_idade = round(aux_idade, 0.01)
	order aux_idade, a(idade)
	drop idade
	ren aux_idade idade
	
	cap gen numero_DN = ""
	cap gen exp_diferenca_data = ""
	
	tempfile `estado'_`ano'
	save ``estado'_`ano''
	
	//-------------------------//
	// valida numero e ordem
	// de colunas
	//-------------------------//
	
	clear
	
	gen ano								= .
	gen estado_abrev					= ""
	gen sequencial_obito				= .
	gen tipo_obito						= ""	
	gen causa_basica					= ""
	gen data_obito						= ""
	gen hora_obito						= ""
	gen naturalidade					= ""
	gen data_nasc						= ""
	gen idade							= .
	gen genero							= ""
	gen raca_cor						= ""
	gen estado_civil					= ""
	gen escolaridade					= ""
	gen ocupacao						= ""
	gen codigo_bairro_resid				= ""
	gen id_municipio_resid				= .
	gen local_ocor						= ""
	gen codigo_bairro_ocor				= ""
	gen id_municipio_ocor				= .
	gen idade_mae						= .
	gen escolaridade_mae				= ""
	gen ocupacao_mae					= ""
	gen qtde_filhos_vivos				= ""
	gen qtde_filhos_mortos				= ""
	gen gravidez						= ""
	gen gestacao						= ""
	gen parto							= ""
	gen obito_parto						= ""
	gen morte_parto						= ""
	gen peso							= .
	gen obito_gravidez					= ""
	gen obito_puerperio					= ""
	gen assistencia_medica				= ""
	gen exame							= ""
	gen cirurgia						= ""
	gen necropsia						= ""
	gen linha_a							= ""
	gen linha_b							= ""
	gen linha_c							= ""
	gen linha_d							= ""
	gen linha_ii						= ""
	gen circunstancia_obito				= ""
	gen acidente_trabalho				= ""
	gen fonte							= ""
	gen id_estab						= ""
	gen atestante						= ""
	gen tipo_assinatura					= ""
	gen data_atestado					= ""
	gen tipo_pos						= ""
	gen data_investigacao				= ""
	gen causa_basica_original			= ""
	gen data_cadastro					= ""
	gen fonte_investigacao				= ""
	gen data_recebimento				= ""
	gen causa_basica_pre				= ""
	gen tipo_obito_ocor					= ""
	gen tipo_morte_ocor					= ""
	gen numero_DN						= ""
	gen data_cadastro_inf				= ""
	gen data_cadastro_investigacao		= ""
	gen id_municipio_SVO_IML			= .
	gen data_recebimento_original		= ""
	gen data_recoriga					= ""
	gen causa_materna					= ""
	gen status_DO_epidem				= ""
	gen status_DO_nova					= ""
	gen id_municipio_cartorio			= .
	gen codigo_cartorio					= ""
	gen numero_registro_cartorio		= ""
	gen data_registro_cartorio			= ""
	gen serie_escolar_falecido			= ""
	gen serie_escolar_mae				= ""
	gen escolaridade_2010				= ""
	gen escolaridade_mae_2010			= ""
	gen escolaridade_falecido_2010_agr	= ""
	gen escolaridade_mae_2010_agr		= ""
	gen semanas_gestacao				= ""
	gen exp_diferenca_data				= ""
	gen diferenca_data					= ""
	gen data_conclusao_investigacao		= ""
	gen data_conclusao_caso				= ""
	gen numero_dias_obito_investigacao	= ""
	gen id_municipio_naturalidade		= .
	gen descricao_estab					= ""
	gen CRM								= ""
	gen numero_lote						= ""
	gen status_codificadora				= ""
	gen codificado						= ""
	gen versao_sistema					= ""
	gen versao_SCB						= ""
	gen atestado						= ""
	gen numero_dias_obito_ficha			= ""
	gen fontes							= ""
	gen tipo_resgate_informacao			= ""
	gen tipo_nivel_investigador			= ""
	gen numero_dias_inf					= ""
	gen fontes_inf						= ""
	gen alt_causa						= ""
	
	qui de, varlist
	local varlist = r(varlist)

	append using ``estado'_`ano'', keep(`varlist')
	
	//-------------------------//
	// particiona
	//-------------------------//
	
	foreach ano of numlist 1996(1)2018 {
		
		! mkdir "output/microdados/ano=`ano'"
		! mkdir "output/microdados/ano=`ano'/estado_abrev=`estado'"
		
		preserve
			keep if ano == `ano' & estado_abrev == "`estado'"
			drop ano estado_abrev
			export delimited "output/microdados/ano=`ano'/estado_abrev=`estado'/microdados.csv", replace
		restore
	
	}
}
*
