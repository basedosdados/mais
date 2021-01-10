
//----------------------------------------------------------------------------//
// build: microdados - vinculos
//----------------------------------------------------------------------------//

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) encoding("utf-8")

keep id_municipio id_municipio_6
tostring id_municipio id_municipio_6, replace force

tempfile dir_munic
save `dir_munic'

import delimited "input/br_bd_diretorios_brasil_municipio.csv", clear varn(1) encoding("utf-8")

keep id_uf sigla_uf
duplicates drop
tostring id_uf, replace

tempfile dir_uf
save `dir_uf'

!mkdir "output/microdados_vinculos"

foreach ano of numlist 1985(1)2019 {
	
	if `ano' >= 1985 & `ano' <= 1988	local ufs AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP
	if `ano' >= 1989 & `ano' <= 2017	local ufs AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO
	if `ano' >= 2018					local ufs NORTE NORDESTE CENTRO_OESTE MG_ES_RJ SUL SP
	
	if `ano' == 1985	local ufs `ufs' IGNORANDOS
	if `ano' == 1986	local ufs `ufs' IGNORADOS
	if `ano' == 1987	local ufs `ufs' IGNORADOS
	if `ano' == 1988	local ufs `ufs' IGNORADO
	if `ano' == 1989	local ufs `ufs' IGNORADOS
	if `ano' == 1990	local ufs `ufs' IGNORADO
	if `ano' == 1991	local ufs `ufs' IGNORADOS
	if `ano' == 1992	local ufs `ufs' IGNORADOS
	if `ano' == 1993	local ufs `ufs' IGNORADOS
	if `ano' == 1994	local ufs `ufs' IGNORADO
	if `ano' == 1995	local ufs `ufs' IGNORADO
	if `ano' == 1996	local ufs `ufs' IGNORADO
	if `ano' == 1997	local ufs `ufs' IGNORADO
	
	foreach uf in `ufs' {
		
		if `ano' <= 2017	local nome `uf'`ano'
		if `ano' >= 2018	local nome RAIS_VINC_PUB_`uf'
		
		import delimited "input/`ano'/`nome'.txt", clear varn(nonames) delim(";") case(preserve) stringcols(_all)
		drop in 1
		
		if	(`ano' == 1985 & "`uf'" == "MA") | ///	// arquivos errados com identificadores
			(`ano' == 1986 & "`uf'" == "PA") {
			
			drop v1 v4 v5 v14 v20 v26
			
			ren v2	bairros_sp
			ren v3	cbo_1994
			ren v6	distritos_sp
			ren v7	grau_instrucao_1985_2005
			ren v8	subsetor_ibge
			ren v9	mes_admissao
			ren v10	mes_desligamento
			ren v11	motivo_desligamento
			ren v12	id_municipio_6
			ren v13	nacionalidade
			ren v15	sexo_trabalhador
			ren v16	tamanho_estabelecimento
			ren v17	tempo_emprego
			ren v18	tipo_estabelecimento
			ren v19	tipo_vinculo
			ren v21	vinculo_ativo_3112
			ren v22	valor_remun_dezembro_sm
			ren v23	valor_remun_media_sm
			ren v24	faixa_etaria
			ren v25	subatividade_ibge
			
		}
		if	`ano' <= 1993 ///
			& !(`ano' == 1985 & "`uf'" == "MA") ///
			& !(`ano' == 1986 & "`uf'" == "PA") {
			
			drop v19
			
			ren v1	bairros_sp
			ren v2	motivo_desligamento
			ren v3	distritos_sp
			ren v4	vinculo_ativo_3112
			ren v5	faixa_etaria
			ren v6	faixa_remun_dezembro_sm
			ren v7	faixa_remun_media_sm
			ren v8	faixa_tempo_emprego
			ren v9	grau_instrucao_1985_2005
			ren v10	mes_admissao
			ren v11	mes_desligamento
			ren v12	id_municipio_6
			ren v13	nacionalidade
			ren v14	valor_remun_dezembro_sm
			ren v15	valor_remun_media_sm
			ren v16	sexo_trabalhador
			ren v17	tamanho_estabelecimento
			ren v18	tempo_emprego
			ren v20	tipo_estabelecimento
			ren v21	tipo_vinculo
			ren v22	subatividade_ibge
			ren v23	subsetor_ibge
			ren v24	cbo_1994
			
		}
		if `ano' >= 1994 & `ano' <= 1995 {
			
			drop v26
			
			ren v1	bairros_sp
			ren v2	motivo_desligamento
			ren v3	cbo_1994
			ren v4	cnae_1
			ren v5	distritos_sp
			ren v6	vinculo_ativo_3112
			ren v7	faixa_etaria
			ren v8	faixa_horas_contratadas
			ren v9	faixa_remun_dezembro_sm
			ren v10	faixa_remun_media_sm
			ren v11	faixa_tempo_emprego
			ren v12	grau_instrucao_1985_2005
			ren v13	qtde_horas_contratadas
			ren v14	idade
			ren v15	mes_admissao
			ren v16	mes_desligamento
			ren v17	id_municipio_6
			ren v18	nacionalidade
			ren v19	natureza_juridica
			ren v20	valor_remun_dezembro_sm
			ren v21	valor_remun_media_sm
			ren v22	sexo_trabalhador
			ren v23	tamanho_estabelecimento
			ren v24	tempo_emprego
			ren v25	tipo_admissao
			ren v27	tipo_estabelecimento
			ren v28	tipo_vinculo
			
		}
		if `ano' >= 1996 & `ano' <= 1998 {
			
			drop v29
			
			ren v1	bairros_sp
			ren v2	bairros_fortaleza
			ren v3	bairros_rj
			ren v4	motivo_desligamento
			ren v5	cbo_1994
			ren v6	cnae_1
			ren v7	distritos_sp
			ren v8	vinculo_ativo_3112
			ren v9	faixa_etaria
			ren v10	faixa_horas_contratadas
			ren v11	faixa_remun_dezembro_sm
			ren v12	faixa_remun_media_sm
			ren v13	faixa_tempo_emprego
			ren v14	grau_instrucao_1985_2005
			ren v15	qtde_horas_contratadas
			ren v16	idade
			ren v17	mes_admissao
			ren v18	mes_desligamento
			ren v19	id_municipio_6
			ren v20	nacionalidade
			ren v21	natureza_juridica
			ren v22	regioes_administrativas_df
			ren v23	valor_remun_dezembro_sm
			ren v24	valor_remun_media_sm
			ren v25	sexo_trabalhador
			ren v26	tamanho_estabelecimento
			ren v27	tempo_emprego
			ren v28	tipo_admissao
			ren v30	tipo_estabelecimento
			ren v31	tipo_vinculo
			
		}
		if `ano' >= 1999 & `ano' <= 2000 {
			
			drop v32
			
			ren v1	bairros_sp
			ren v2	bairros_fortaleza
			ren v3	bairros_rj
			ren v4	motivo_desligamento
			ren v5	cbo_1994
			ren v6	cnae_1
			ren v7	distritos_sp
			ren v8	vinculo_ativo_3112
			ren v9	faixa_etaria
			ren v10	faixa_horas_contratadas
			ren v11	faixa_remun_dezembro_sm
			ren v12	faixa_remun_media_sm
			ren v13	faixa_tempo_emprego
			ren v14	grau_instrucao_1985_2005
			ren v15	qtde_horas_contratadas
			ren v16	idade
			ren v17	indicador_cei_vinculado
			ren v18	mes_admissao
			ren v19	mes_desligamento
			ren v20	id_municipio_6
			ren v21	nacionalidade
			ren v22	natureza_juridica
			ren v23	regioes_administrativas_df
			ren v24	valor_remun_dezembro_nominal
			ren v25	valor_remun_dezembro_sm
			ren v26	valor_remun_media_nominal
			ren v27	valor_remun_media_sm
			ren v28	sexo_trabalhador
			ren v29	tamanho_estabelecimento
			ren v30	tempo_emprego
			ren v31	tipo_admissao
			ren v33	tipo_estabelecimento
			ren v34	tipo_vinculo
			
		}
		if `ano' == 2001 {
			
			drop v33
			
			ren v1	bairros_sp
			ren v2	bairros_fortaleza
			ren v3	bairros_rj
			ren v4	motivo_desligamento
			ren v5	cbo_1994
			ren v6	cnae_1
			ren v7	distritos_sp
			ren v8	vinculo_ativo_3112
			ren v9	faixa_etaria
			ren v10	faixa_horas_contratadas
			ren v11	faixa_remun_dezembro_sm
			ren v12	faixa_remun_media_sm
			ren v13	faixa_tempo_emprego
			ren v14	grau_instrucao_1985_2005
			ren v15	qtde_horas_contratadas
			ren v16	idade
			ren v17	indicador_cei_vinculado
			ren v18	indicador_simples
			ren v19	mes_admissao
			ren v20	mes_desligamento
			ren v21	id_municipio_6
			ren v22	nacionalidade
			ren v23	natureza_juridica
			ren v24	regioes_administrativas_df
			ren v25	valor_remun_dezembro_nominal
			ren v26	valor_remun_dezembro_sm
			ren v27	valor_remun_media_nominal
			ren v28	valor_remun_media_sm
			ren v29	sexo_trabalhador
			ren v30	tamanho_estabelecimento
			ren v31	tempo_emprego
			ren v32	tipo_admissao
			ren v34	tipo_estabelecimento
			ren v35	tipo_vinculo
			
		}
		if `ano' == 2002 {
			
			drop v38
			
			ren v1	bairros_sp
			ren v2	bairros_fortaleza
			ren v3	bairros_rj
			ren v4	causa_desligamento_1
			ren v5	causa_desligamento_2
			ren v6	causa_desligamento_3
			ren v7	motivo_desligamento
			ren v8	cbo_1994
			ren v9	cnae_1
			ren v10	distritos_sp
			ren v11	vinculo_ativo_3112
			ren v12	faixa_etaria
			ren v13	faixa_horas_contratadas
			ren v14	faixa_remun_dezembro_sm
			ren v15	faixa_remun_media_sm
			ren v16	faixa_tempo_emprego
			ren v17	grau_instrucao_1985_2005
			ren v18	qtde_horas_contratadas
			ren v19	idade
			ren v20	indicador_cei_vinculado
			ren v21	indicador_simples
			ren v22	mes_admissao
			ren v23	mes_desligamento
			ren v24	id_municipio_6_trabalho
			ren v25	id_municipio_6
			ren v26	nacionalidade
			ren v27	natureza_juridica
			ren v28	qtde_dias_afastamento
			ren v29	regioes_administrativas_df
			ren v30	valor_remun_dezembro_nominal
			ren v31	valor_remun_dezembro_sm
			ren v32	valor_remun_media_nominal
			ren v33	valor_remun_media_sm
			ren v34	sexo_trabalhador
			ren v35	tamanho_estabelecimento
			ren v36	tempo_emprego
			ren v37	tipo_admissao
			ren v39	tipo_estabelecimento
			ren v40	tipo_vinculo
			
		}
		if `ano' == 2003 {
			
			drop v38
			
			ren v1	bairros_sp
			ren v2	bairros_fortaleza
			ren v3	bairros_rj
			ren v4	causa_desligamento_1
			ren v5	causa_desligamento_2
			ren v6	causa_desligamento_3
			ren v7	motivo_desligamento
			ren v8	cbo_2002
			ren v9	cnae_1
			ren v10	distritos_sp
			ren v11	vinculo_ativo_3112
			ren v12	faixa_etaria
			ren v13	faixa_horas_contratadas
			ren v14	faixa_remun_dezembro_sm
			ren v15	faixa_remun_media_sm
			ren v16	faixa_tempo_emprego
			ren v17	grau_instrucao_1985_2005
			ren v18	qtde_horas_contratadas
			ren v19	idade
			ren v20	indicador_cei_vinculado
			ren v21	indicador_simples
			ren v22	mes_admissao
			ren v23	mes_desligamento
			ren v24	id_municipio_6_trabalho
			ren v25	id_municipio_6
			ren v26	nacionalidade
			ren v27	natureza_juridica
			ren v28	qtde_dias_afastamento
			ren v29	regioes_administrativas_df
			ren v30	valor_remun_dezembro_nominal
			ren v31	valor_remun_dezembro_sm
			ren v32	valor_remun_media_nominal
			ren v33	valor_remun_media_sm
			ren v34	sexo_trabalhador
			ren v35	tamanho_estabelecimento
			ren v36	tempo_emprego
			ren v37	tipo_admissao
			ren v39	tipo_estabelecimento
			ren v40	tipo_vinculo
			
		}
		if `ano' >= 2004 & `ano' <= 2005 {
			
			drop v40
			
			ren v1	bairros_sp
			ren v2	bairros_fortaleza
			ren v3	bairros_rj
			ren v4	causa_desligamento_1
			ren v5	causa_desligamento_2
			ren v6	causa_desligamento_3
			ren v7	motivo_desligamento
			ren v8	cbo_2002
			ren v9	cnae_2
			ren v10	cnae_1
			ren v11	distritos_sp
			ren v12	vinculo_ativo_3112
			ren v13	faixa_etaria
			ren v14	faixa_horas_contratadas
			ren v15	faixa_remun_dezembro_sm
			ren v16	faixa_remun_media_sm
			ren v17	faixa_tempo_emprego
			ren v18	grau_instrucao_1985_2005
			ren v19	qtde_horas_contratadas
			ren v20	idade
			ren v21	indicador_cei_vinculado
			ren v22	indicador_simples
			ren v23	mes_admissao
			ren v24	mes_desligamento
			ren v25	id_municipio_6_trabalho
			ren v26	id_municipio_6
			ren v27	nacionalidade
			ren v28	natureza_juridica
			ren v29	qtde_dias_afastamento
			ren v30	regioes_administrativas_df
			ren v31	valor_remun_dezembro_nominal
			ren v32	valor_remun_dezembro_sm
			ren v33	valor_remun_media_nominal
			ren v34	valor_remun_media_sm
			ren v35	cnae_2_subclasse
			ren v36	sexo_trabalhador
			ren v37	tamanho_estabelecimento
			ren v38	tempo_emprego
			ren v39	tipo_admissao
			ren v41	tipo_estabelecimento
			ren v42	tipo_vinculo
			
		}
		if `ano' == 2006 {
			
			drop v41
			
			ren v1	bairros_sp
			ren v2	bairros_fortaleza
			ren v3	bairros_rj
			ren v4	causa_desligamento_1
			ren v5	causa_desligamento_2
			ren v6	causa_desligamento_3
			ren v7	motivo_desligamento
			ren v8	cbo_2002
			ren v9	cnae_2
			ren v10	cnae_1
			ren v11	distritos_sp
			ren v12	vinculo_ativo_3112
			ren v13	faixa_etaria
			ren v14	faixa_horas_contratadas
			ren v15	faixa_remun_dezembro_sm
			ren v16	faixa_remun_media_sm
			ren v17	faixa_tempo_emprego
			ren v18	grau_instrucao_apos_2005
			ren v19	qtde_horas_contratadas
			ren v20	idade
			ren v21	indicador_cei_vinculado
			ren v22	indicador_simples
			ren v23	mes_admissao
			ren v24	mes_desligamento
			ren v25	id_municipio_6_trabalho
			ren v26	id_municipio_6
			ren v27	nacionalidade
			ren v28	natureza_juridica
			ren v29	qtde_dias_afastamento
			ren v30	raca_cor
			ren v31	regioes_administrativas_df
			ren v32	valor_remun_dezembro_nominal
			ren v33	valor_remun_dezembro_sm
			ren v34	valor_remun_media_nominal
			ren v35	valor_remun_media_sm
			ren v36	cnae_2_subclasse
			ren v37	sexo_trabalhador
			ren v38	tamanho_estabelecimento
			ren v39	tempo_emprego
			ren v40	tipo_admissao
			ren v42	tipo_estabelecimento
			ren v43	tipo_vinculo
			
		}
		if `ano' >= 2007 & `ano' <= 2014 {
			
			drop v42
			
			ren v1	bairros_sp
			ren v2	bairros_fortaleza
			ren v3	bairros_rj
			ren v4	causa_desligamento_1
			ren v5	causa_desligamento_2
			ren v6	causa_desligamento_3
			ren v7	motivo_desligamento
			ren v8	cbo_2002
			ren v9	cnae_2
			ren v10	cnae_1
			ren v11	distritos_sp
			ren v12	vinculo_ativo_3112
			ren v13	faixa_etaria
			ren v14	faixa_horas_contratadas
			ren v15	faixa_remun_dezembro_sm
			ren v16	faixa_remun_media_sm
			ren v17	faixa_tempo_emprego
			ren v18	grau_instrucao_apos_2005
			ren v19	qtde_horas_contratadas
			ren v20	idade
			ren v21	indicador_cei_vinculado
			ren v22	indicador_simples
			ren v23	mes_admissao
			ren v24	mes_desligamento
			ren v25	id_municipio_6_trabalho
			ren v26	id_municipio_6
			ren v27	nacionalidade
			ren v28	natureza_juridica
			ren v29	indicador_portador_deficiencia
			ren v30	qtde_dias_afastamento
			ren v31	raca_cor
			ren v32	regioes_administrativas_df
			ren v33	valor_remun_dezembro_nominal
			ren v34	valor_remun_dezembro_sm
			ren v35	valor_remun_media_nominal
			ren v36	valor_remun_media_sm
			ren v37	cnae_2_subclasse
			ren v38	sexo_trabalhador
			ren v39	tamanho_estabelecimento
			ren v40	tempo_emprego
			ren v41	tipo_admissao
			ren v43	tipo_estabelecimento
			ren v44	tipo_deficiencia
			ren v45	tipo_vinculo
			
		}
		if `ano' == 2015 {
			
			drop v42
			
			ren v1	bairros_sp
			ren v2	bairros_fortaleza
			ren v3	bairros_rj
			ren v4	causa_desligamento_1
			ren v5	causa_desligamento_2
			ren v6	causa_desligamento_3
			ren v7	motivo_desligamento
			ren v8	cbo_2002
			ren v9	cnae_2
			ren v10	cnae_1
			ren v11	distritos_sp
			ren v12	vinculo_ativo_3112
			ren v13	faixa_etaria
			ren v14	faixa_horas_contratadas
			ren v15	faixa_remun_dezembro_sm
			ren v16	faixa_remun_media_sm
			ren v17	faixa_tempo_emprego
			ren v18	grau_instrucao_apos_2005
			ren v19	qtde_horas_contratadas
			ren v20	idade
			ren v21	indicador_cei_vinculado
			ren v22	indicador_simples
			ren v23	mes_admissao
			ren v24	mes_desligamento
			ren v25	id_municipio_6_trabalho
			ren v26	id_municipio_6
			ren v27	nacionalidade
			ren v28	natureza_juridica
			ren v29	indicador_portador_deficiencia
			ren v30	qtde_dias_afastamento
			ren v31	raca_cor
			ren v32	regioes_administrativas_df
			ren v33	valor_remun_dezembro_nominal
			ren v34	valor_remun_dezembro_sm
			ren v35	valor_remun_media_nominal
			ren v36	valor_remun_media_sm
			ren v37	cnae_2_subclasse
			ren v38	sexo_trabalhador
			ren v39	tamanho_estabelecimento
			ren v40	tempo_emprego
			ren v41	tipo_admissao
			ren v43	tipo_estabelecimento
			ren v44	tipo_deficiencia
			ren v45	tipo_vinculo
			ren v46	subsetor_ibge
			ren v47	valor_remun_janeiro_nominal
			ren v48	valor_remun_fevereiro_nominal
			ren v49	valor_remun_marco_nominal
			ren v50	valor_remun_abril_nominal
			ren v51	valor_remun_maio_nominal
			ren v52	valor_remun_junho_nominal
			ren v53	valor_remun_julho_nominal
			ren v54	valor_remun_agosto_nominal
			ren v55	valor_remun_setembro_nominal
			ren v56	valor_remun_outubro_nominal
			ren v57	valor_remun_novembro_nominal
			
		}
		if `ano' == 2016 {
			
			drop v42
			
			ren v1	bairros_sp
			ren v2	bairros_fortaleza
			ren v3	bairros_rj
			ren v4	causa_desligamento_1
			ren v5	causa_desligamento_2
			ren v6	causa_desligamento_3
			ren v7	motivo_desligamento
			ren v8	cbo_2002
			ren v9	cnae_2
			ren v10	cnae_1
			ren v11	distritos_sp
			ren v12	vinculo_ativo_3112
			ren v13	faixa_etaria
			ren v14	faixa_horas_contratadas
			ren v15	faixa_remun_dezembro_sm
			ren v16	faixa_remun_media_sm
			ren v17	faixa_tempo_emprego
			ren v18	grau_instrucao_apos_2005
			ren v19	qtde_horas_contratadas
			ren v20	idade
			ren v21	indicador_cei_vinculado
			ren v22	indicador_simples
			ren v23	mes_admissao
			ren v24	mes_desligamento
			ren v25	id_municipio_6_trabalho
			ren v26	id_municipio_6
			ren v27	nacionalidade
			ren v28	natureza_juridica
			ren v29	indicador_portador_deficiencia
			ren v30	qtde_dias_afastamento
			ren v31	raca_cor
			ren v32	regioes_administrativas_df
			ren v33	valor_remun_dezembro_nominal
			ren v34	valor_remun_dezembro_sm
			ren v35	valor_remun_media_nominal
			ren v36	valor_remun_media_sm
			ren v37	cnae_2_subclasse
			ren v38	sexo_trabalhador
			ren v39	tamanho_estabelecimento
			ren v40	tempo_emprego
			ren v41	tipo_admissao
			ren v43	tipo_estabelecimento
			ren v44	tipo_deficiencia
			ren v45	tipo_vinculo
			ren v46	subsetor_ibge
			ren v47	valor_remun_janeiro_nominal
			ren v48	valor_remun_fevereiro_nominal
			ren v49	valor_remun_marco_nominal
			ren v50	valor_remun_abril_nominal
			ren v51	valor_remun_maio_nominal
			ren v52	valor_remun_junho_nominal
			ren v53	valor_remun_julho_nominal
			ren v54	valor_remun_agosto_nominal
			ren v55	valor_remun_setembro_nominal
			ren v56	valor_remun_outubro_nominal
			ren v57	valor_remun_novembro_nominal
			ren v58	ano_chegada_brasil
			
		}
		if `ano' == 2017 {
			
			drop v42
			
			ren v1	bairros_sp
			ren v2	bairros_fortaleza
			ren v3	bairros_rj
			ren v4	causa_desligamento_1
			ren v5	causa_desligamento_2
			ren v6	causa_desligamento_3
			ren v7	motivo_desligamento
			ren v8	cbo_2002
			ren v9	cnae_2
			ren v10	cnae_1
			ren v11	distritos_sp
			ren v12	vinculo_ativo_3112
			ren v13	faixa_etaria
			ren v14	faixa_horas_contratadas
			ren v15	faixa_remun_dezembro_sm
			ren v16	faixa_remun_media_sm
			ren v17	faixa_tempo_emprego
			ren v18	grau_instrucao_apos_2005
			ren v19	qtde_horas_contratadas
			ren v20	idade
			ren v21	indicador_cei_vinculado
			ren v22	indicador_simples
			ren v23	mes_admissao
			ren v24	mes_desligamento
			ren v25	id_municipio_6_trabalho
			ren v26	id_municipio_6
			ren v27	nacionalidade
			ren v28	natureza_juridica
			ren v29	indicador_portador_deficiencia
			ren v30	qtde_dias_afastamento
			ren v31	raca_cor
			ren v32	regioes_administrativas_df
			ren v33	valor_remun_dezembro_nominal
			ren v34	valor_remun_dezembro_sm
			ren v35	valor_remun_media_nominal
			ren v36	valor_remun_media_sm
			ren v37	cnae_2_subclasse
			ren v38	sexo_trabalhador
			ren v39	tamanho_estabelecimento
			ren v40	tempo_emprego
			ren v41	tipo_admissao
			ren v43	tipo_estabelecimento
			ren v44	tipo_deficiencia
			ren v45	tipo_vinculo
			ren v46	subsetor_ibge
			ren v47	valor_remun_janeiro_nominal
			ren v48	valor_remun_fevereiro_nominal
			ren v49	valor_remun_marco_nominal
			ren v50	valor_remun_abril_nominal
			ren v51	valor_remun_maio_nominal
			ren v52	valor_remun_junho_nominal
			ren v53	valor_remun_julho_nominal
			ren v54	valor_remun_agosto_nominal
			ren v55	valor_remun_setembro_nominal
			ren v56	valor_remun_outubro_nominal
			ren v57	valor_remun_novembro_nominal
			ren v58	ano_chegada_brasil
			ren v59	indicador_trabalho_parcial
			ren v60	indicador_trabalho_intermitente
			
		}
		if `ano' >= 2018 & `ano' <= 2019 {
			
			drop v42
			
			ren v1	bairros_sp
			ren v2	bairros_fortaleza
			ren v3	bairros_rj
			ren v4	causa_desligamento_1
			ren v5	causa_desligamento_2
			ren v6	causa_desligamento_3
			ren v7	motivo_desligamento
			ren v8	cbo_2002
			ren v9	cnae_2
			ren v10	cnae_1
			ren v11	distritos_sp
			ren v12	vinculo_ativo_3112
			ren v13	faixa_etaria
			ren v14	faixa_horas_contratadas
			ren v15	faixa_remun_dezembro_sm
			ren v16	faixa_remun_media_sm
			ren v17	faixa_tempo_emprego
			ren v18	grau_instrucao_apos_2005
			ren v19	qtde_horas_contratadas
			ren v20	idade
			ren v21	indicador_cei_vinculado
			ren v22	indicador_simples
			ren v23	mes_admissao
			ren v24	mes_desligamento
			ren v25	id_municipio_6_trabalho
			ren v26	id_municipio_6
			ren v27	nacionalidade
			ren v28	natureza_juridica
			ren v29	indicador_portador_deficiencia
			ren v30	qtde_dias_afastamento
			ren v31	raca_cor
			ren v32	regioes_administrativas_df
			ren v33	valor_remun_dezembro_nominal
			ren v34	valor_remun_dezembro_sm
			ren v35	valor_remun_media_nominal
			ren v36	valor_remun_media_sm
			ren v37	cnae_2_subclasse
			ren v38	sexo_trabalhador
			ren v39	tamanho_estabelecimento
			ren v40	tempo_emprego
			ren v41	tipo_admissao
			ren v43	tipo_estabelecimento
			ren v44	tipo_deficiencia
			ren v45	tipo_vinculo
			ren v46	subsetor_ibge
			ren v47	valor_remun_janeiro_nominal
			ren v48	valor_remun_fevereiro_nominal
			ren v49	valor_remun_marco_nominal
			ren v50	valor_remun_abril_nominal
			ren v51	valor_remun_maio_nominal
			ren v52	valor_remun_junho_nominal
			ren v53	valor_remun_julho_nominal
			ren v54	valor_remun_agosto_nominal
			ren v55	valor_remun_setembro_nominal
			ren v56	valor_remun_outubro_nominal
			ren v57	valor_remun_novembro_nominal
			ren v58	ano_chegada_brasil
			ren v59	indicador_trabalho_parcial
			ren v60	indicador_trabalho_intermitente
			cap ren v61	tipo_salario
			cap ren v62	valor_salario_contratual
		
		}
		*
		
		//--------------------------//
		// adiciona identificadores
		//--------------------------//
		
		merge m:1 id_municipio_6 using `dir_munic'
		drop if _merge == 2
		drop _merge
		
		gen id_uf = substr(id_municipio_6, 1, 2)
		merge m:1 id_uf using `dir_uf'
		drop if _merge == 2
		drop _merge id_uf
		
		replace sigla_uf = "IGNORADO" if sigla_uf == ""
		
		//--------------------------//
		// padroniza variáveis e dados
		//--------------------------//
		
		local vars	id_municipio id_municipio_6 ///
					tipo_vinculo vinculo_ativo_3112 tipo_admissao mes_admissao mes_desligamento motivo_desligamento causa_desligamento_1 causa_desligamento_2 causa_desligamento_3 faixa_tempo_emprego tempo_emprego ///
					faixa_horas_contratadas qtde_horas_contratadas id_municipio_6_trabalho qtde_dias_afastamento indicador_cei_vinculado indicador_trabalho_parcial indicador_trabalho_intermitente ///
					faixa_remun_media_sm valor_remun_media_sm valor_remun_media_nominal faixa_remun_dezembro_sm valor_remun_dezembro_sm ///
					valor_remun_janeiro_nominal valor_remun_fevereiro_nominal valor_remun_marco_nominal valor_remun_abril_nominal valor_remun_maio_nominal valor_remun_junho_nominal valor_remun_julho_nominal ///
					valor_remun_agosto_nominal valor_remun_setembro_nominal valor_remun_outubro_nominal valor_remun_novembro_nominal valor_remun_dezembro_nominal ///
					tipo_salario valor_salario_contratual ///
					subatividade_ibge subsetor_ibge cbo_1994 cbo_2002 cnae_1 cnae_2 cnae_2_subclasse ///
					faixa_etaria idade grau_instrucao_1985_2005 grau_instrucao_apos_2005 nacionalidade sexo_trabalhador raca_cor indicador_portador_deficiencia tipo_deficiencia ano_chegada_brasil ///
					tamanho_estabelecimento tipo_estabelecimento natureza_juridica indicador_simples bairros_sp distritos_sp bairros_fortaleza bairros_rj regioes_administrativas_df
		
		foreach var in `vars' {
			cap confirm variable `var'
			if _rc {
				gen `var' = ""
			}
		}
		*
		
		foreach k of varlist _all {
			
			replace `k' = trim(`k')
			replace `k' = "" if inlist(`k', "{ñ", "{ñ class}", "{ñ c")
			
		}
		*
		
		foreach k of varlist bairros_* distritos_sp regioes_administrativas_df {
			replace `k' = "" if inlist(`k', "0000", "00000", "000000", "0000000", "0000-1", "000-1", "9999")
		}
		*
		
		foreach k of varlist id_municipio_6 id_municipio_6_trabalho ///
			cbo_1994 cbo_2002 cnae_1 cnae_2 cnae_2_subclasse ///
			ano_chegada_brasil {
			replace `k' = "" if inlist(`k', "0000", "00000", "000000", "0000000", "0000-1", "000-1")
		}
		*
		
		foreach k of varlist mes_admissao mes_desligamento tipo_deficiencia {
			replace `k' = "" if `k' == "00"
		}
		*
		foreach k of varlist faixa_remun_* causa_desligamento_* raca_cor {
			replace `k' = "" if `k' == "99"
		}
		*
		
		destring motivo_desligamento vinculo_ativo_3112 mes_admissao mes_desligamento causa_desligamento_* qtde_dias_afastamento ///
			faixa_horas_contratadas qtde_horas_contratadas faixa_remun_dezembro_sm faixa_remun_media_sm faixa_tempo_emprego tipo_vinculo tipo_admissao id_municipio_6_trabalho indicador_trabalho_parcial indicador_trabalho_intermitente ///
			faixa_etaria idade grau_instrucao_1985_2005 grau_instrucao_apos_2005 nacionalidade sexo_trabalhador raca_cor indicador_portador_deficiencia tipo_deficiencia ano_chegada_brasil ///
			id_municipio id_municipio_6 tamanho_estabelecimento natureza_juridica indicador_cei_vinculado indicador_simples, replace
		
		foreach var of varlist valor_remun_* tempo_emprego valor_salario_contratual {
			replace `var' = subinstr(`var', ".", "", .)
			destring `var', replace dpcomma
			tostring `var', replace force
			replace `var' = "" if `var' == "."
			replace `var' = "0" + `var' if substr(`var', 1, 1) == "."
		}
		*
		
		order `vars'
		
		tempfile vinculos
		save `vinculos'
		
		//--------------------------//
		// particiona
		//--------------------------//
		
		!mkdir "output/microdados_vinculos/ano=`ano'"
		
		levelsof sigla_uf, l(intra_ufs)
		foreach intra_uf in `intra_ufs' {
			
			!mkdir "output/microdados_vinculos/ano=`ano'/sigla_uf=`intra_uf'"
			
			use `vinculos', clear
			keep if sigla_uf == "`intra_uf'"
			drop sigla_uf
			export delimited "output/microdados_vinculos/ano=`ano'/sigla_uf=`intra_uf'/microdados_vinculos.csv", replace
			
		}
	}
}
*
