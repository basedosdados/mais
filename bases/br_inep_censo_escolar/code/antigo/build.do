
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all

cd "~/Downloads/dados_censo_escolar"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

local ufs_CO		GO MS MT DF
local ufs_NORDESTE	AL BA CE MA PB PE PI RN SE
local ufs_NORTE		AC AM AP PA RO RR TO
local ufs_SUDESTE	MG RJ ES SP
local ufs_SUL		PR RS SC

! mkdir -p "output/matricula"

foreach ano of numlist 2007(1)2020 {
	
	! mkdir -p "output/matricula/ano=`ano'"
	
	foreach regiao in CO NORDESTE NORTE SUDESTE SUL {
		
		import delimited "input/`ano'/DADOS/MATRICULA_`regiao'.csv", clear varn(1) case(preserve) stringcols(_all) //rowr(1:200000)
		
		cap drop CO_REGIAO
		cap drop CO_MESORREGIAO					
		cap drop CO_MICRORREGIAO
		cap drop TP_LOCALIZACAO
		cap drop TP_CATEGORIA_ESCOLA_PRIVADA
		cap drop IN_CONVENIADA_PP
		cap drop TP_CONVENIO_PODER_PUBLICO
		cap drop IN_MANT_ESCOLA_PRIVADA_EMP
		cap drop IN_MANT_ESCOLA_PRIVADA_ONG
		cap drop IN_MANT_ESCOLA_PRIVADA_OSCIP
		cap drop IN_MANT_ESCOLA_PRIV_ONG_OSCIP
		cap drop IN_MANT_ESCOLA_PRIVADA_SIND
		cap drop IN_MANT_ESCOLA_PRIVADA_SIST_S
		cap drop IN_MANT_ESCOLA_PRIVADA_S_FINS
		cap drop TP_REGULAMENTACAO
		cap drop TP_LOCALIZACAO_DIFERENCIADA
		cap drop IN_EDUCACAO_INDIGENA
		
		cap gen ID_ALUNO = ""
		cap gen CO_PESSOA_FISICA = ""
		cap gen NU_DIA = ""
		cap gen TP_LOCAL_RESID_DIFERENCIADA = ""
		cap gen IN_TRANSP_TREM_METRO = ""
		cap gen IN_SINDROME_ASPERGER = ""
		cap gen IN_SINDROME_RETT = ""
		cap gen IN_TRANSTORNO_DI = ""
		cap gen IN_RECURSO_AMPLIADA_16 = ""
		cap gen IN_RECURSO_AMPLIADA_18 = ""
		cap gen IN_RECURSO_AMPLIADA_20 = ""
		cap gen IN_RECURSO_CD_AUDIO = ""
		cap gen IN_RECURSO_PROVA_PORTUGUES = ""
		cap gen IN_RECURSO_VIDEO_LIBRAS = ""
		cap gen IN_AEE_LIBRAS = ""
		cap gen IN_AEE_LINGUA_PORTUGUESA = ""
		cap gen IN_AEE_INFORMATICA_ACESSIVEL = ""
		cap gen IN_AEE_BRAILLE = ""
		cap gen IN_AEE_CAA = ""
		cap gen IN_AEE_SOROBAN = ""
		cap gen IN_AEE_VIDA_AUTONOMA = ""
		cap gen IN_AEE_OPTICOS_NAO_OPTICOS = ""
		cap gen IN_AEE_ENRIQ_CURRICULAR = ""
		cap gen IN_AEE_DESEN_COGNITIVO = ""
		cap gen IN_AEE_MOBILIDADE = ""
		cap gen TP_INGRESSO_FEDERAIS = ""
		cap gen IN_ESPECIAL_EXCLUSIVA = ""
		cap gen IN_REGULAR = ""
		cap gen IN_EJA = ""
		cap gen IN_PROFISSIONALIZANTE = ""
		cap gen TP_MEDIACAO_DIDATICO_PEDAGO = ""
		cap gen TP_TIPO_ATENDIMENTO_TURMA = ""
		cap gen TP_TIPO_LOCAL_TURMA = ""
		cap gen TP_TIPO_TURMA = ""
		
		ren NU_ANO_CENSO					ano
		ren ID_ALUNO						id_aluno
		ren ID_MATRICULA					id_matricula
		ren CO_PESSOA_FISICA				id_pessoa_fisica
		ren NU_DIA							dia_nascimento
		ren NU_MES							mes_nascimento
		ren NU_ANO							ano_nascimento
		ren NU_IDADE_REFERENCIA				idade_referencia
		ren NU_IDADE						idade
		ren NU_DURACAO_TURMA				duracao_turma
		ren NU_DUR_ATIV_COMP_MESMA_REDE		duracao_ativ_comp_mesma_rede
		ren NU_DUR_ATIV_COMP_OUTRAS_REDES	duracao_ativ_comp_outras_redes
		ren NU_DUR_AEE_MESMA_REDE			duracao_aee_comp_mesma_rede
		ren NU_DUR_AEE_OUTRAS_REDES			duracao_aee_comp_outras_redes
		ren NU_DIAS_ATIVIDADE				dias_atividade
		ren TP_SEXO							sexo
		ren TP_COR_RACA						raca_cor
		ren TP_NACIONALIDADE				nacionalidade
		ren CO_PAIS_ORIGEM					id_pais_origem
		ren CO_UF_NASC						id_uf_nascimento
		ren CO_MUNICIPIO_NASC				id_municipio_nascimento
		ren CO_UF_END						id_uf_endereco
		ren CO_MUNICIPIO_END				id_municipio_endereco
		ren TP_ZONA_RESIDENCIAL				zona_residencial
		ren TP_LOCAL_RESID_DIFERENCIADA		local_residencia_diferenciada
		ren TP_OUTRO_LOCAL_AULA				outro_local_aula
		ren IN_TRANSPORTE_PUBLICO			transporte_publico
		ren TP_RESPONSAVEL_TRANSPORTE		responsavel_transporte
		ren IN_TRANSP_VANS_KOMBI			transporte_vans_kombi
		ren IN_TRANSP_MICRO_ONIBUS			transporte_micro_onibus
		ren IN_TRANSP_ONIBUS				transporte_onibus
		ren IN_TRANSP_BICICLETA				transporte_bicicleta
		ren IN_TRANSP_TR_ANIMAL				transporte_tr_animal
		ren IN_TRANSP_OUTRO_VEICULO			transporte_outro_veiculo
		ren IN_TRANSP_EMBAR_ATE5			transporte_embarcacao_ate5
		ren IN_TRANSP_EMBAR_5A15			transporte_embarcacao_5a15
		ren IN_TRANSP_EMBAR_15A35			transporte_embarcacao_15a35
		ren IN_TRANSP_EMBAR_35				transporte_embarcacao_35
		ren IN_TRANSP_TREM_METRO			transporte_trem_metro
		ren IN_NECESSIDADE_ESPECIAL			necessidade_especial
		ren IN_CEGUEIRA						cegueira
		ren IN_BAIXA_VISAO					baixa_visao
		ren IN_SURDEZ						surdez
		ren IN_DEF_AUDITIVA					deficiencia_auditiva
		ren IN_SURDOCEGUEIRA				surdocegueira
		ren IN_DEF_FISICA					deficiencia_fisica
		ren IN_DEF_INTELECTUAL				deficiencia_intelectual
		ren IN_DEF_MULTIPLA					deficiencia_multipla
		ren IN_AUTISMO						autismo
		ren IN_SINDROME_ASPERGER			sindrome_asperger
		ren IN_SINDROME_RETT				sindrome_rett
		ren IN_TRANSTORNO_DI				transtorno_di
		ren IN_SUPERDOTACAO					superdotacao
		ren IN_RECURSO_LEDOR				recurso_ledor
		ren IN_RECURSO_TRANSCRICAO			recurso_transcricao
		ren IN_RECURSO_INTERPRETE			recurso_interprete
		ren IN_RECURSO_LIBRAS				recurso_libras
		ren IN_RECURSO_LABIAL				recurso_labial
		ren IN_RECURSO_BRAILLE				recurso_braille
		ren IN_RECURSO_AMPLIADA_16		recurso_ampliada_16
		ren IN_RECURSO_AMPLIADA_18		recurso_ampliada_18
		ren IN_RECURSO_AMPLIADA_20 		recurso_ampliada_20
		ren IN_RECURSO_AMPLIADA_24			recurso_ampliada_24
		ren IN_RECURSO_CD_AUDIO			recurso_cd_audio
		ren IN_RECURSO_PROVA_PORTUGUES	recurso_prova_portugues
		ren IN_RECURSO_VIDEO_LIBRAS		recurso_video_libras
		ren IN_RECURSO_NENHUM			recurso_nenhum
		ren IN_AEE_LIBRAS				aee_libras
		ren IN_AEE_LINGUA_PORTUGUESA	aee_lingua_portuguesa
		ren IN_AEE_INFORMATICA_ACESSIVEL	aee_informatica_acessivel
		ren IN_AEE_BRAILLE				aee_braille
		ren IN_AEE_CAA					aee_caa
		ren IN_AEE_SOROBAN				aee_soroban
		ren IN_AEE_VIDA_AUTONOMA		aee_vida_autonoma
		ren IN_AEE_OPTICOS_NAO_OPTICOS	aee_opticos_nao_opticos
		ren IN_AEE_ENRIQ_CURRICULAR		aee_enriquecimento_curricular
		ren IN_AEE_DESEN_COGNITIVO		aee_desenvolvimento_cognitivo
		ren IN_AEE_MOBILIDADE			aee_mobilidade
		ren TP_INGRESSO_FEDERAIS		ingresso_federais
		ren TP_ETAPA_ENSINO				etapa_ensino
		ren IN_ESPECIAL_EXCLUSIVA		especial_exclusiva
		ren IN_REGULAR					regular
		ren IN_EJA						eja
		ren IN_PROFISSIONALIZANTE		profissionalizante
		ren ID_TURMA					id_turma
		ren CO_CURSO_EDUC_PROFISSIONAL	id_curso_educ_profissional
		ren TP_MEDIACAO_DIDATICO_PEDAGO	mediacao_didatico_pedagogica
		ren TP_UNIFICADA				unificada
		ren TP_TIPO_ATENDIMENTO_TURMA	tipo_atendimento_turma
		ren TP_TIPO_LOCAL_TURMA			tipo_local_turma
		ren TP_TIPO_TURMA				tipo_turma
		ren CO_ENTIDADE					id_escola
		ren CO_UF						id_uf
		ren CO_MUNICIPIO				id_municipio
		ren CO_DISTRITO					id_distrito
		ren TP_DEPENDENCIA				rede
		
		/*
		cap ren TP_LOCALIZACAO				
		cap ren TP_CATEGORIA_ESCOLA_PRIVADA	
		cap ren IN_CONVENIADA_PP			
		cap ren TP_CONVENIO_PODER_PUBLICO	
		cap ren IN_MANT_ESCOLA_PRIVADA_EMP	
		cap ren IN_MANT_ESCOLA_PRIVADA_ONG	
		cap ren IN_MANT_ESCOLA_PRIVADA_SIND	
		cap ren IN_MANT_ESCOLA_PRIVADA_SIST_S	
		cap ren IN_MANT_ESCOLA_PRIVADA_S_FINS	
		cap ren TP_REGULAMENTACAO			
		cap ren TP_LOCALIZACAO_DIFERENCIADA	
		cap ren IN_EDUCACAO_INDIGENA		
		*/
		
		/*
		gen NUM_IDADE_REF_DOCENTE = ""
		gen ID_ZONA_RESIDENCIAL = ""
		gen ID_POSSUI_NEC_ESPECIAL = ""
		gen ID_CEGUEIRA = ""
		gen ID_BAIXA_VISAO = ""
		gen ID_SURDEZ = ""
		gen ID_DEF_AUDITIVA = ""
		gen ID_SURDOCEGUEIRA = ""
		gen ID_DEF_FISICA = ""
		gen ID_DEF_INTELECTUAL = "" 
		gen ID_DEF_MULTIPLA = ""
		gen FK_COD_ESCOLARIDADE = ""
		gen ID_SITUACAO_CURSO_1 = ""
		gen ID_SITUACAO_CURSO_2 = ""
		gen ID_SITUACAO_CURSO_3 = ""
		gen ID_COM_PEDAGOGICA_1 = ""
		gen ID_COM_PEDAGOGICA_2 = ""
		gen ID_COM_PEDAGOGICA_3 = ""
		gen ID_ESPECIFICO_CAMPO = ""
		gen ID_ESPECIFICO_AMBIENTAL = ""
		gen ID_ESPECIFICO_DIR_HUMANOS = ""
		gen ID_ESPECIFICO_DIV_SEXUAL = ""
		gen ID_ESPECIFICO_DIR_ADOLESC = ""
		gen ID_ESPECIFICO_AFRO = ""
		gen ID_ESPECIFICO_OUTROS = ""
		*/
		
		gen sigla_uf = ""
		replace sigla_uf = "RO" if id_uf == "11"
		replace sigla_uf = "AC" if id_uf == "12"
		replace sigla_uf = "AM" if id_uf == "13"
		replace sigla_uf = "RR" if id_uf == "14"
		replace sigla_uf = "PA" if id_uf == "15"
		replace sigla_uf = "AP" if id_uf == "16"
		replace sigla_uf = "TO" if id_uf == "17"
		replace sigla_uf = "MA" if id_uf == "21"
		replace sigla_uf = "PI" if id_uf == "22"
		replace sigla_uf = "CE" if id_uf == "23"
		replace sigla_uf = "RN" if id_uf == "24"
		replace sigla_uf = "PB" if id_uf == "25"
		replace sigla_uf = "PE" if id_uf == "26"
		replace sigla_uf = "AL" if id_uf == "27"
		replace sigla_uf = "SE" if id_uf == "28"
		replace sigla_uf = "BA" if id_uf == "29"
		replace sigla_uf = "MG" if id_uf == "31"
		replace sigla_uf = "ES" if id_uf == "32"
		replace sigla_uf = "RJ" if id_uf == "33"
		replace sigla_uf = "SP" if id_uf == "35"
		replace sigla_uf = "PR" if id_uf == "41"
		replace sigla_uf = "SC" if id_uf == "42"
		replace sigla_uf = "RS" if id_uf == "43"
		replace sigla_uf = "MS" if id_uf == "50"
		replace sigla_uf = "MT" if id_uf == "51"
		replace sigla_uf = "GO" if id_uf == "52"
		replace sigla_uf = "DF" if id_uf == "53"
		
		order ano sigla_uf id_uf id_municipio id_distrito id_escola rede id_turma id_aluno id_pessoa_fisica id_matricula ///
			dia_nascimento mes_nascimento ano_nascimento idade_referencia idade sexo raca_cor nacionalidade ///
			id_pais_origem id_uf_nascimento id_municipio_nascimento id_uf_endereco id_municipio_endereco zona_residencial local_residencia_diferenciada ///
			outro_local_aula ///
			duracao_turma duracao_ativ_comp_mesma_rede duracao_ativ_comp_outras_redes duracao_aee_comp_mesma_rede duracao_aee_comp_outras_redes dias_atividade ///
			transporte_publico responsavel_transporte transporte_bicicleta transporte_micro_onibus transporte_onibus transporte_tr_animal transporte_vans_kombi transporte_outro_veiculo ///
			transporte_embarcacao_ate5 transporte_embarcacao_5a15 transporte_embarcacao_15a35 transporte_embarcacao_35 transporte_trem_metro ///
			necessidade_especial baixa_visao cegueira deficiencia_auditiva deficiencia_fisica deficiencia_intelectual surdez surdocegueira deficiencia_multipla autismo sindrome_asperger sindrome_rett transtorno_di superdotacao ///
			recurso_ledor recurso_transcricao recurso_interprete recurso_libras recurso_labial recurso_ampliada_16 recurso_ampliada_18 recurso_ampliada_20 recurso_ampliada_24 recurso_cd_audio recurso_prova_portugues recurso_video_libras recurso_braille recurso_nenhum ///
			aee_libras aee_lingua_portuguesa aee_informatica_acessivel aee_braille aee_caa aee_soroban aee_vida_autonoma aee_opticos_nao_opticos aee_enriquecimento_curricular aee_desenvolvimento_cognitivo aee_mobilidade ///
			ingresso_federais ///
			etapa_ensino especial_exclusiva regular eja profissionalizante id_curso_educ_profissional mediacao_didatico_pedagogica ///
			unificada tipo_atendimento_turma tipo_local_turma tipo_turma
		
		//--------------//
		// particiona
		//--------------//
		
		foreach uf in `ufs_`regiao'' {
			
			!mkdir -p "output/matricula/ano=`ano'/sigla_uf=`uf'"
			
			preserve
				
				keep if sigla_uf == "`uf'"
				drop ano sigla_uf id_uf
				export delimited "output/matricula/ano=`ano'/sigla_uf=`uf'/matricula.csv" , replace
			
			restore
			
		}
	}	
}

