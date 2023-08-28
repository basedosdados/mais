
clear all

cd "~/Downloads/censo_educacao_superior"

local FIRST_YEAR 2009
local LAST_YEAR 2021

local SECOND_YEAR = `FIRST_YEAR' + 1

//----------------------------------------------------------------------------//
// build: ies
//----------------------------------------------------------------------------//

foreach year of numlist `FIRST_YEAR'(1)`LAST_YEAR' {
	
	import delimited "input/microdados_censo_da_educacao_superior_`year'/Microdados do Censo da Educa‡ֶo Superior `year'/dados/MICRODADOS_CADASTRO_IES_`year'.csv", ///
		clear varn(1) case(preserve) stringcols(_all)
	
	drop NO_REGIAO_IES CO_REGIAO_IES NO_UF_IES CO_UF_IES NO_MUNICIPIO_IES IN_CAPITAL_IES NO_MESORREGIAO_IES CO_MESORREGIAO_IES NO_MICRORREGIAO_IES CO_MICRORREGIAO_IES
	
	if `year' >= 2021 drop CO_PROJETO CO_LOCAL_OFERTA NO_LOCAL_OFERTA
	
	ren NU_ANO_CENSO					ano
	ren SG_UF_IES						sigla_uf
	ren CO_MUNICIPIO_IES				id_municipio
	ren TP_ORGANIZACAO_ACADEMICA		tipo_organizacao_academica
	ren TP_CATEGORIA_ADMINISTRATIVA		tipo_categoria_administrativa
	ren NO_MANTENEDORA					nome_mantenedora
	ren CO_MANTENEDORA					id_mantenedora
	ren CO_IES							id_ies
	ren NO_IES							nome
	ren SG_IES							sigla
	ren DS_ENDERECO_IES					endereco
	ren DS_NUMERO_ENDERECO_IES			numero
	ren DS_COMPLEMENTO_ENDERECO_IES		complemento
	ren NO_BAIRRO_IES					bairro
	ren NU_CEP_IES						cep
	ren QT_TEC_TOTAL					tec
	ren QT_TEC_FUNDAMENTAL_INCOMP_FEM	tec_ef_incomp_feminino
	ren QT_TEC_FUNDAMENTAL_INCOMP_MASC	tec_ef_incomp_masculino
	ren QT_TEC_FUNDAMENTAL_COMP_FEM		tec_ef_comp_feminino
	ren QT_TEC_FUNDAMENTAL_COMP_MASC	tec_ef_comp_masculino
	ren QT_TEC_MEDIO_FEM				tec_em_feminino
	ren QT_TEC_MEDIO_MASC				tec_em_masculino
	ren QT_TEC_SUPERIOR_FEM				tec_es_feminino
	ren QT_TEC_SUPERIOR_MASC			tec_es_masculino
	ren QT_TEC_ESPECIALIZACAO_FEM		tec_especializacao_feminino
	ren QT_TEC_ESPECIALIZACAO_MASC		tec_especializacao_masculino
	ren QT_TEC_MESTRADO_FEM				tec_mestrado_feminino
	ren QT_TEC_MESTRADO_MASC			tec_mestrado_masculino
	ren QT_TEC_DOUTORADO_FEM			tec_doutorado_feminino
	ren QT_TEC_DOUTORADO_MASC			tec_doutorado_masculino
	ren IN_ACESSO_PORTAL_CAPES			bib_acesso_portal_capes
	ren IN_ACESSO_OUTRAS_BASES			bib_acesso_outras_bases
	ren IN_ASSINA_OUTRA_BASE			bib_assina_outras_bases
	ren IN_REPOSITORIO_INSTITUCIONAL	bib_repositorio_institucional
	ren IN_BUSCA_INTEGRADA				bib_busca_integrada
	ren IN_SERVICO_INTERNET				bib_internet
	ren IN_PARTICIPA_REDE_SOCIAL		bib_rede_social
	ren IN_CATALOGO_ONLINE				bib_catalogo_online
	ren QT_PERIODICO_ELETRONICO			bib_periodico_eletronico
	ren QT_LIVRO_ELETRONICO				bib_livro_eletronico
	
	if `year' == 2009 {
		ren QT_DOCENTE_TOTAL			doc
		ren QT_DOCENTE_EXE				doc_exercicio
		ren DOC_EX_FEMI					doc_exercicio_feminino
		ren DOC_EX_MASC					doc_exercicio_masculino
		ren DOC_EX_SEM_GRAD				doc_exercicio_sem_graduacao
		ren DOC_EX_GRAD					doc_exercicio_graduacao
		ren DOC_EX_ESP					doc_exercicio_especializacao
		ren DOC_EX_MEST					doc_exercicio_mestrado
		ren DOC_EX_DOUT					doc_exercicio_doutorado
		ren DOC_EX_INT					doc_exercicio_integral
		ren DOC_EX_INT_DE				doc_exercicio_integral_de
		ren DOC_EX_INT_SEM_DE			doc_exercicio_integral_sem_de
		ren DOC_EX_PARC					doc_exercicio_parcial
		ren DOC_EX_HOR					doc_exercicio_horista
		ren DOC_EX_0_29					doc_exercicio_0_29
		ren DOC_EX_30_34				doc_exercicio_30_34
		ren DOC_EX_35_39				doc_exercicio_35_39
		ren DOC_EX_40_44				doc_exercicio_40_44
		ren DOC_EX_45_49				doc_exercicio_45_49
		ren DOC_EX_50_54				doc_exercicio_50_54
		ren DOC_EX_55_59				doc_exercicio_55_59
		ren DOC_EX_60_MAIS				doc_exercicio_60_mais
		ren DOC_EX_BRANCA				doc_exercicio_branca
		ren DOC_EX_PRETA				doc_exercicio_preta
		ren DOC_EX_PARDA				doc_exercicio_parda
		ren DOC_EX_AMARELA				doc_exercicio_amarela
		ren DOC_EX_INDIGENA				doc_exercicio_indigena
		ren DOC_EX_COR_ND				doc_exercicio_cor_nd
		ren DOC_EX_BRA					doc_exercicio_brasileiro
		ren DOC_EX_EST					doc_exercicio_estrangeiro
		ren DOC_EX_COM_DEFICIENCIA		doc_exercicio_deficiencia
	}
	else {
		ren QT_DOC_TOTAL				doc
		ren QT_DOC_EXE					doc_exercicio
		ren QT_DOC_EX_FEMI				doc_exercicio_feminino
		ren QT_DOC_EX_MASC				doc_exercicio_masculino
		ren QT_DOC_EX_SEM_GRAD			doc_exercicio_sem_graduacao
		ren QT_DOC_EX_GRAD				doc_exercicio_graduacao
		ren QT_DOC_EX_ESP				doc_exercicio_especializacao
		ren QT_DOC_EX_MEST				doc_exercicio_mestrado
		ren QT_DOC_EX_DOUT				doc_exercicio_doutorado
		ren QT_DOC_EX_INT				doc_exercicio_integral
		ren QT_DOC_EX_INT_DE			doc_exercicio_integral_de
		ren QT_DOC_EX_INT_SEM_DE		doc_exercicio_integral_sem_de
		ren QT_DOC_EX_PARC				doc_exercicio_parcial
		ren QT_DOC_EX_HOR				doc_exercicio_horista
		ren QT_DOC_EX_0_29				doc_exercicio_0_29
		ren QT_DOC_EX_30_34				doc_exercicio_30_34
		ren QT_DOC_EX_35_39				doc_exercicio_35_39
		ren QT_DOC_EX_40_44				doc_exercicio_40_44
		ren QT_DOC_EX_45_49				doc_exercicio_45_49
		ren QT_DOC_EX_50_54				doc_exercicio_50_54
		ren QT_DOC_EX_55_59				doc_exercicio_55_59
		ren QT_DOC_EX_60_MAIS			doc_exercicio_60_mais
		ren QT_DOC_EX_BRANCA			doc_exercicio_branca
		ren QT_DOC_EX_PRETA				doc_exercicio_preta
		ren QT_DOC_EX_PARDA				doc_exercicio_parda
		ren QT_DOC_EX_AMARELA			doc_exercicio_amarela
		ren QT_DOC_EX_INDIGENA			doc_exercicio_indigena
		ren QT_DOC_EX_COR_ND			doc_exercicio_cor_nd
		ren QT_DOC_EX_BRA				doc_exercicio_brasileiro
		ren QT_DOC_EX_EST				doc_exercicio_estrangeiro
		ren QT_DOC_EX_COM_DEFICIENCIA	doc_exercicio_deficiencia
	}
	
	tempfile f`year'
	save `f`year''
	
}

use `f`FIRST_YEAR'', clear
foreach year of numlist `SECOND_YEAR'(1)`LAST_YEAR' {
	append using `f`year''
}

tempfile f
save `f'

!mkdir "output/ies"

foreach year of numlist `FIRST_YEAR'(1)`LAST_YEAR' {
	!mkdir "output/ies/ano=`year'"
	use `f' if ano == "`year'", clear
	drop ano
	export delimited "output/ies/ano=`year'/ies.csv", replace
}

//----------------------------------------------------------------------------//
// build: curso
//----------------------------------------------------------------------------//

foreach year of numlist `FIRST_YEAR'(1)`LAST_YEAR' {
	
	import delimited "input/microdados_censo_da_educacao_superior_`year'/Microdados do Censo da Educa‡ֶo Superior `year'/dados/MICRODADOS_CADASTRO_CURSOS_`year'.csv", ///
		clear varn(1) case(preserve) stringcols(_all) //rowr(1:10000)
	
	drop NO_REGIAO CO_REGIAO NO_UF CO_UF NO_MUNICIPIO IN_CAPITAL
	
	if `year' == 2020 ren CO_CINE_ROTULO2 CO_CINE_ROTULO
	
	ren NU_ANO_CENSO					ano
	ren SG_UF							sigla_uf
	ren CO_MUNICIPIO					id_municipio
	ren TP_DIMENSAO						tipo_dimensao
	ren TP_ORGANIZACAO_ACADEMICA		tipo_organizacao_academica
	ren TP_CATEGORIA_ADMINISTRATIVA		tipo_organizacao_administrativa
	ren TP_REDE							rede
	ren CO_IES							id_ies
	ren NO_CURSO						nome_curso
	ren CO_CURSO						id_curso
	ren NO_CINE_ROTULO					nome_curso_cine
	ren CO_CINE_ROTULO					id_curso_cine
	ren CO_CINE_AREA_GERAL				id_area_geral
	ren NO_CINE_AREA_GERAL				nome_area_geral
	ren CO_CINE_AREA_ESPECIFICA			id_area_especifica
	ren NO_CINE_AREA_ESPECIFICA			nome_area_especifica
	ren CO_CINE_AREA_DETALHADA			id_area_detalhada
	ren NO_CINE_AREA_DETALHADA			nome_area_detalhada
	ren TP_GRAU_ACADEMICO				tipo_grau_academico
	ren IN_GRATUITO						gratuito
	ren TP_MODALIDADE_ENSINO			tipo_modalidade_ensino
	ren TP_NIVEL_ACADEMICO				tipo_nivel_academico
	ren QT_CURSO						cursos
	ren QT_VG_TOTAL						vag
	ren QT_VG_TOTAL_DIURNO				vag_diurno
	ren QT_VG_TOTAL_NOTURNO				vag_noturno
	ren QT_VG_TOTAL_EAD					vag_ead
	ren QT_VG_NOVA						vag_novas
	ren QT_VG_PROC_SELETIVO				vag_processos_seletivos
	ren QT_VG_REMANESC					vag_remanescentes
	ren QT_VG_PROG_ESPECIAL				vag_programas_especiais
	ren QT_INSCRITO_TOTAL				ins
	ren QT_INSCRITO_TOTAL_DIURNO		ins_diurno
	ren QT_INSCRITO_TOTAL_NOTURNO		ins_noturno
	ren QT_INSCRITO_TOTAL_EAD			ins_ead
	ren QT_INSC_VG_NOVA					ins_vagas_novas
	ren QT_INSC_PROC_SELETIVO			ins_processos_seletivos
	ren QT_INSC_VG_REMANESC				ins_remanescentes
	ren QT_INSC_VG_PROG_ESPECIAL		ins_programas_especiais
	ren QT_ING							ing
	ren QT_ING_FEM						ing_feminino
	ren QT_ING_MASC						ing_masculino
	ren QT_ING_DIURNO					ing_diurno
	ren QT_ING_NOTURNO					ing_noturno
	ren QT_ING_VG_NOVA					ing_vagas_novas
	ren QT_ING_VESTIBULAR				ing_vestibular
	ren QT_ING_ENEM						ing_enem
	ren QT_ING_AVALIACAO_SERIADA		ing_avaliacao_seriada
	ren QT_ING_SELECAO_SIMPLIFICA		ing_selecao_simplificada
	ren QT_ING_EGR						ing_egressos
	ren QT_ING_OUTRO_TIPO_SELECAO		ing_outro_tipo_selecao
	ren QT_ING_PROC_SELETIVO			ing_processos_seletivos
	ren QT_ING_VG_REMANESC				ing_remanescentes
	ren QT_ING_VG_PROG_ESPECIAL			ing_programas_especiais
	ren QT_ING_OUTRA_FORMA				ing_outras_formas
	ren QT_ING_0_17						ing_0_17
	ren QT_ING_18_24					ing_18_24
	ren QT_ING_25_29					ing_25_29
	ren QT_ING_30_34					ing_30_34
	ren QT_ING_35_39					ing_35_39
	ren QT_ING_40_49					ing_40_49
	ren QT_ING_50_59					ing_50_59
	ren QT_ING_60_MAIS					ing_60_mais
	ren QT_ING_BRANCA					ing_branca
	ren QT_ING_PRETA					ing_preta
	ren QT_ING_PARDA					ing_parda
	ren QT_ING_AMARELA					ing_amarela
	ren QT_ING_INDIGENA					ing_indigena
	ren QT_ING_CORND					ing_cor_nd
	ren QT_MAT							mat
	ren QT_MAT_FEM						mat_feminino
	ren QT_MAT_MASC						mat_masculino
	ren QT_MAT_DIURNO					mat_diurno
	ren QT_MAT_NOTURNO					mat_noturno
	ren QT_MAT_0_17						mat_0_17
	ren QT_MAT_18_24					mat_18_24
	ren QT_MAT_25_29					mat_25_29
	ren QT_MAT_30_34					mat_30_34
	ren QT_MAT_35_39					mat_35_39
	ren QT_MAT_40_49					mat_40_49
	ren QT_MAT_50_59					mat_50_59
	ren QT_MAT_60_MAIS					mat_60_mais
	ren QT_MAT_BRANCA					mat_branca
	ren QT_MAT_PRETA					mat_preta
	ren QT_MAT_PARDA					mat_parda
	ren QT_MAT_AMARELA					mat_amarela
	ren QT_MAT_INDIGENA					mat_indigena
	ren QT_MAT_CORND					mat_cor_nd
	ren QT_CONC							con
	ren QT_CONC_FEM						con_feminino
	ren QT_CONC_MASC					con_masculino
	ren QT_CONC_DIURNO					con_diurno
	ren QT_CONC_NOTURNO					con_noturno
	ren QT_CONC_0_17					con_0_17
	ren QT_CONC_18_24					con_18_24
	ren QT_CONC_25_29					con_25_29
	ren QT_CONC_30_34					con_30_34
	ren QT_CONC_35_39					con_35_39
	ren QT_CONC_40_49					con_40_49
	ren QT_CONC_50_59					con_50_59
	ren QT_CONC_60_MAIS					con_60_mais
	ren QT_CONC_BRANCA					con_branca
	ren QT_CONC_PRETA					con_preta
	ren QT_CONC_PARDA					con_parda
	ren QT_CONC_AMARELA					con_amarela
	ren QT_CONC_INDIGENA				con_indigena
	ren QT_CONC_CORND					con_cor_nd
	ren QT_ING_NACBRAS					ing_brasileiro
	ren QT_ING_NACESTRANG				ing_estrangeiro
	ren QT_MAT_NACBRAS					mat_brasileiro
	ren QT_MAT_NACESTRANG				mat_estrangeiro
	ren QT_CONC_NACBRAS					con_brasileiro
	ren QT_CONC_NACESTRANG				con_estrangeiro
	ren QT_ALUNO_DEFICIENTE				alu_deficiencia
	ren QT_ING_DEFICIENTE				ing_deficiencia
	ren QT_MAT_DEFICIENTE				mat_deficiencia
	ren QT_CONC_DEFICIENTE				con_deficiencia
	ren QT_ING_FINANC					ing_financ
	ren QT_ING_FINANC_REEMB				ing_financ_reemb
	ren QT_ING_FIES						ing_financ_reemb_fies
	ren QT_ING_RPFIES					ing_financ_reemb_inst
	ren QT_ING_FINANC_REEMB_OUTROS		ing_financ_reemb_outros
	ren QT_ING_FINANC_NREEMB			ing_financ_nreemb
	ren QT_ING_PROUNII					ing_financ_nreemb_prouni_i
	ren QT_ING_PROUNIP					ing_financ_nreemb_prouni_p
	ren QT_ING_NRPFIES					ing_financ_nreemb_inst
	ren QT_ING_FINANC_NREEMB_OUTROS		ing_financ_nreemb_outros
	ren QT_MAT_FINANC					mat_financ
	ren QT_MAT_FINANC_REEMB				mat_financ_reemb
	ren QT_MAT_FIES						mat_financ_reemb_fies
	ren QT_MAT_RPFIES					mat_financ_reemb_inst
	ren QT_MAT_FINANC_REEMB_OUTROS		mat_financ_reemb_outros
	ren QT_MAT_FINANC_NREEMB			mat_financ_nreemb
	ren QT_MAT_PROUNII					mat_financ_nreemb_prouni_i
	ren QT_MAT_PROUNIP					mat_financ_nreemb_prouni_p
	ren QT_MAT_NRPFIES					mat_financ_nreemb_inst
	ren QT_MAT_FINANC_NREEMB_OUTROS		mat_financ_nreemb_outros
	ren QT_CONC_FINANC					con_financ
	ren QT_CONC_FINANC_REEMB			con_financ_reemb
	ren QT_CONC_FIES					con_financ_reemb_fies
	ren QT_CONC_RPFIES					con_financ_reemb_inst
	ren QT_CONC_FINANC_REEMB_OUTROS		con_financ_reemb_outros
	ren QT_CONC_FINANC_NREEMB			con_financ_nreemb
	ren QT_CONC_PROUNII					con_financ_nreemb_prouni_i
	ren QT_CONC_PROUNIP					con_financ_nreemb_prouni_p
	ren QT_CONC_NRPFIES					con_financ_nreemb_inst
	ren QT_CONC_FINANC_NREEMB_OUTROS	con_financ_nreemb_outros
	ren QT_ING_RESERVA_VAGA				ing_rv
	ren QT_ING_RVREDEPUBLICA			ing_rv_rede_publica
	ren QT_ING_RVETNICO					ing_rv_etnico
	ren QT_ING_RVPDEF					ing_rv_deficiencia
	ren QT_ING_RVSOCIAL_RF				ing_rv_social_rf
	ren QT_ING_RVOUTROS					ing_rv_outros
	ren QT_MAT_RESERVA_VAGA				mat_rv
	ren QT_MAT_RVREDEPUBLICA			mat_rv_rede_publica
	ren QT_MAT_RVETNICO					mat_rv_etnico
	ren QT_MAT_RVPDEF					mat_rv_deficiencia
	ren QT_MAT_RVSOCIAL_RF				mat_rv_social_rf
	ren QT_MAT_RVOUTROS					mat_rv_outros
	ren QT_CONC_RESERVA_VAGA			con_rv
	ren QT_CONC_RVREDEPUBLICA			con_rv_rede_publica
	ren QT_CONC_RVETNICO				con_rv_etnico
	ren QT_CONC_RVPDEF					con_rv_deficiencia
	ren QT_CONC_RVSOCIAL_RF				con_rv_social_rf
	ren QT_CONC_RVOUTROS				con_rv_outros
	ren QT_SIT_TRANCADA					alu_situacao_trancada
	ren QT_SIT_DESVINCULADO				alu_situacao_desvinculada
	ren QT_SIT_TRANSFERIDO				alu_situacao_transferida
	ren QT_SIT_FALECIDO					alu_situacao_falecidos
	ren QT_ING_PROCESCPUBLICA			ing_em_rede_publica
	ren QT_ING_PROCESCPRIVADA			ing_em_rede_privada
	ren QT_ING_PROCNAOINFORMADA			ing_em_nao_informada
	ren QT_MAT_PROCESCPUBLICA			mat_em_rede_publica
	ren QT_MAT_PROCESCPRIVADA			mat_em_rede_privada
	ren QT_MAT_PROCNAOINFORMADA			mat_em_nao_informada
	ren QT_CONC_PROCESCPUBLICA			con_em_rede_publica
	ren QT_CONC_PROCESCPRIVADA			con_em_rede_privada
	ren QT_CONC_PROCNAOINFORMADA		con_em_nao_informada
	ren QT_PARFOR						alu_parfor
	ren QT_ING_PARFOR					ing_parfor
	ren QT_MAT_PARFOR					mat_parfor
	ren QT_CONC_PARFOR					con_parfor
	ren QT_APOIO_SOCIAL					alu_apoio_social
	ren QT_ING_APOIO_SOCIAL				ing_apoio_social
	ren QT_MAT_APOIO_SOCIAL				mat_apoio_social
	ren QT_CONC_APOIO_SOCIAL			con_apoio_social
	ren QT_ATIV_EXTRACURRICULAR			alu_ativ_extracurricular
	ren QT_ING_ATIV_EXTRACURRICULAR		ing_ativ_extracurricular
	ren QT_MAT_ATIV_EXTRACURRICULAR		mat_ativ_extracurricular
	ren QT_CONC_ATIV_EXTRACURRICULAR	con_ativ_extracurricular
	ren QT_MOB_ACADEMICA				alu_mob_academica
	ren QT_ING_MOB_ACADEMICA			ing_mob_academica
	ren QT_MAT_MOB_ACADEMICA			mat_mob_academica
	ren QT_CONC_MOB_ACADEMICA			con_mob_academica
	
	replace id_curso_cine = subinstr(id_curso_cine, `"""',  "", .)
	
	tempfile f`year'
	save `f`year''
	
}

use `f`FIRST_YEAR'', clear
foreach year of numlist `SECOND_YEAR'(1)`LAST_YEAR' {
	append using `f`year''
}

tempfile f
save `f'

!mkdir "output/curso"

levelsof sigla_uf, local(ufs)
foreach year of numlist `FIRST_YEAR'(1)`LAST_YEAR' {
	!mkdir "output/curso/ano=`year'"
	foreach uf in `ufs' {
		!mkdir "output/curso/ano=`year'/sigla_uf=`uf'"
		use `f' if ano == "`year'" & sigla_uf == "`uf'", clear
		drop ano sigla_uf
		export delimited "output/curso/ano=`year'/sigla_uf=`uf'/curso.csv", replace
	}
}
