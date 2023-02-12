/*
Query para publicar a tabela.

Esse é o lugar para:
    - modificar nomes, ordem e tipos de colunas
    - dar join com outras tabelas
    - criar colunas extras (e.g. logs, proporções, etc.)

Qualquer coluna definida aqui deve também existir em `table_config.yaml`.

# Além disso, sinta-se à vontade para alterar alguns nomes obscuros
# para algo um pouco mais explícito.

TIPOS:
    - Para modificar tipos de colunas, basta substituir STRING por outro tipo válido.
    - Exemplo: `SAFE_CAST(column_name AS NUMERIC) column_name`
    - Mais detalhes: https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types
*/

CREATE VIEW basedosdados-dev.br_ibge_estadic.politica_mulher AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(organismo_executivo_politica_mulher AS INT64) organismo_executivo_politica_mulher,
SAFE_CAST(caracterizacao_organismo_executivo_politica_mulher AS STRING) caracterizacao_organismo_executivo_politica_mulher,
SAFE_CAST(setor_subordinado_assistencia_social AS INT64) setor_subordinado_assistencia_social,
SAFE_CAST(setor_subordinado_direito_humano AS INT64) setor_subordinado_direito_humano,
SAFE_CAST(setor_subordinado_justica AS INT64) setor_subordinado_justica,
SAFE_CAST(setor_subordinado_seguranca AS INT64) setor_subordinado_seguranca,
SAFE_CAST(setor_subordinado_saude AS INT64) setor_subordinado_saude,
SAFE_CAST(setor_subordinado_outra AS INT64) setor_subordinado_outra,
SAFE_CAST(nome_organismo_executivo_politica_mulher AS STRING) nome_organismo_executivo_politica_mulher,
SAFE_CAST(gestor_sexo AS STRING) gestor_sexo,
SAFE_CAST(gestor_idade AS INT64) gestor_idade,
SAFE_CAST(gestor_raca_cor AS STRING) gestor_raca_cor,
SAFE_CAST(gestor_raca_cor_autodeclarado AS INT64) gestor_raca_cor_autodeclarado,
SAFE_CAST(gestor_escolaridade AS STRING) gestor_escolaridade,
SAFE_CAST(acao_grupo_especifico_mulher AS INT64) acao_grupo_especifico_mulher,
SAFE_CAST(acao_mulher_idosa AS INT64) acao_mulher_idosa,
SAFE_CAST(acao_mulher_lesbica AS INT64) acao_mulher_lesbica,
SAFE_CAST(acao_mulher_negra AS INT64) acao_mulher_negra,
SAFE_CAST(acao_mulher_deficiencia AS INT64) acao_mulher_deficiencia,
SAFE_CAST(acao_mulher_indigena AS INT64) acao_mulher_indigena,
SAFE_CAST(acao_mulher_quilombola AS INT64) acao_mulher_quilombola,
SAFE_CAST(acao_outra AS INT64) acao_outra,
SAFE_CAST(capacitacao_genero_outra_area_governo AS INT64) capacitacao_genero_outra_area_governo,
SAFE_CAST(incorpora_genero_formulacao_politica AS INT64) incorpora_genero_formulacao_politica,
SAFE_CAST(politica_area_educacao AS INT64) politica_area_educacao,
SAFE_CAST(politica_area_trabalho AS INT64) politica_area_trabalho,
SAFE_CAST(politica_area_cultura AS INT64) politica_area_cultura,
SAFE_CAST(politica_area_servico_especializado AS INT64) politica_area_servico_especializado,
SAFE_CAST(politica_area_esporte AS INT64) politica_area_esporte,
SAFE_CAST(politica_area_assistencia_social AS INT64) politica_area_assistencia_social,
SAFE_CAST(politica_area_seguranca_publica AS INT64) politica_area_seguranca_publica,
SAFE_CAST(politica_area_justica AS INT64) politica_area_justica,
SAFE_CAST(politica_area_comunicacao AS INT64) politica_area_comunicacao,
SAFE_CAST(politica_area_meio_ambiente AS INT64) politica_area_meio_ambiente,
SAFE_CAST(politica_area_saude AS INT64) politica_area_saude,
SAFE_CAST(politica_area_outra AS INT64) politica_area_outra,
SAFE_CAST(politica_promocao_igualdade_genero AS INT64) politica_promocao_igualdade_genero,
SAFE_CAST(politica_enfrentamento_violencia AS INT64) politica_enfrentamento_violencia,
SAFE_CAST(politica_promocao_autonomia_mulher AS INT64) politica_promocao_autonomia_mulher,
SAFE_CAST(plano_estadual_politica_mulher AS INT64) plano_estadual_politica_mulher,
SAFE_CAST(plano_estadual_politica_mulher_instrumento AS STRING) plano_estadual_politica_mulher_instrumento,
SAFE_CAST(plano_estadual_politica_mulher_ultimo_ano AS INT64) plano_estadual_politica_mulher_ultimo_ano,
SAFE_CAST(comite_plano_estadual_politica_mulher AS INT64) comite_plano_estadual_politica_mulher,
SAFE_CAST(comite_orgao_gestor_politica_mulher AS INT64) comite_orgao_gestor_politica_mulher,
SAFE_CAST(comite_orgao_gestor_assistencia_social AS INT64) comite_orgao_gestor_assistencia_social,
SAFE_CAST(comite_orgao_gestor_saude AS INT64) comite_orgao_gestor_saude,
SAFE_CAST(comite_orgao_gestor_cultura AS INT64) comite_orgao_gestor_cultura,
SAFE_CAST(comite_orgao_gestor_educacao AS INT64) comite_orgao_gestor_educacao,
SAFE_CAST(comite_orgao_gestor_justica AS INT64) comite_orgao_gestor_justica,
SAFE_CAST(comite_orgao_gestor_politica_emprego AS INT64) comite_orgao_gestor_politica_emprego,
SAFE_CAST(comite_orgao_gestor_seguranca_publica AS INT64) comite_orgao_gestor_seguranca_publica,
SAFE_CAST(comite_outra_secretaria AS INT64) comite_outra_secretaria,
SAFE_CAST(comite_sociedade_civil AS INT64) comite_sociedade_civil,
SAFE_CAST(conselho_direito_mulher AS INT64) conselho_direito_mulher,
SAFE_CAST(conselho_direito_mulher_lei AS INT64) conselho_direito_mulher_lei,
SAFE_CAST(conselho_direito_mulher_ano AS INT64) conselho_direito_mulher_ano,
SAFE_CAST(conselho_direito_mulher_formacao AS STRING) conselho_direito_mulher_formacao,
SAFE_CAST(conselho_direito_mulher_reuniao_12_meses AS INT64) conselho_direito_mulher_reuniao_12_meses,
SAFE_CAST(conselho_direito_mulher_reuniao_12_meses_nao_soube_informar AS INT64) conselho_direito_mulher_reuniao_12_meses_nao_soube_informar,
SAFE_CAST(conselho_direito_mulher_numero_conselheiro AS INT64) conselho_direito_mulher_numero_conselheiro,
SAFE_CAST(conselho_capacitacao_membro_continua AS INT64) conselho_capacitacao_membro_continua,
SAFE_CAST(conselho_capacitacao_membro_eventual AS INT64) conselho_capacitacao_membro_eventual,
SAFE_CAST(conselho_capacitacao_membro_nao_realizada AS INT64) conselho_capacitacao_membro_nao_realizada,
SAFE_CAST(conselho_direito_mulher_infraestrutura AS INT64) conselho_direito_mulher_infraestrutura,
SAFE_CAST(infraestrutura_conselho_sala_propria AS INT64) infraestrutura_conselho_sala_propria,
SAFE_CAST(infraestrutura_conselho_computador AS INT64) infraestrutura_conselho_computador,
SAFE_CAST(infraestrutura_conselho_impressora AS INT64) infraestrutura_conselho_impressora,
SAFE_CAST(infraestrutura_conselho_internet AS INT64) infraestrutura_conselho_internet,
SAFE_CAST(infraestrutura_conselho_veiculo_proprio AS INT64) infraestrutura_conselho_veiculo_proprio,
SAFE_CAST(infraestrutura_conselho_telefone AS INT64) infraestrutura_conselho_telefone,
SAFE_CAST(infraestrutura_conselho_diaria AS INT64) infraestrutura_conselho_diaria,
SAFE_CAST(infraestrutura_conselho_dotacao_orcamentaria AS INT64) infraestrutura_conselho_dotacao_orcamentaria,
SAFE_CAST(conselho_direito_mulher_vinculado_adm AS STRING) conselho_direito_mulher_vinculado_adm,
SAFE_CAST(conselho_direito_mulher_presidente AS STRING) conselho_direito_mulher_presidente,
SAFE_CAST(casa_abrigo_mulher_risco_morte AS INT64) casa_abrigo_mulher_risco_morte,
SAFE_CAST(casa_abrigo_quantidade AS INT64) casa_abrigo_quantidade,
SAFE_CAST(casa_abrigo_endereco_sigiloso AS STRING) casa_abrigo_endereco_sigiloso,
SAFE_CAST(casa_abrigo_atendimento_psicologico_individual AS INT64) casa_abrigo_atendimento_psicologico_individual,
SAFE_CAST(casa_abrigo_atendimento_psicologico_grupo AS INT64) casa_abrigo_atendimento_psicologico_grupo,
SAFE_CAST(casa_abrigo_atividade_cultural_educativa AS INT64) casa_abrigo_atividade_cultural_educativa,
SAFE_CAST(casa_abrigo_atividade_profissional AS INT64) casa_abrigo_atividade_profissional,
SAFE_CAST(casa_abrigo_atendimento_social AS INT64) casa_abrigo_atendimento_social,
SAFE_CAST(casa_abrigo_atendimento_juridico AS INT64) casa_abrigo_atendimento_juridico,
SAFE_CAST(casa_abrigo_atendimento_medico AS INT64) casa_abrigo_atendimento_medico,
SAFE_CAST(casa_abrigo_acompanhamento_pedagogico_crianca AS INT64) casa_abrigo_acompanhamento_pedagogico_crianca,
SAFE_CAST(casa_abrigo_programa_emprego AS INT64) casa_abrigo_programa_emprego,
SAFE_CAST(casa_abrigo_permanencia_crianca_escola AS INT64) casa_abrigo_permanencia_crianca_escola,
SAFE_CAST(casa_abrigo_creche AS INT64) casa_abrigo_creche,
SAFE_CAST(casa_abrigo_outra_atividade AS INT64) casa_abrigo_outra_atividade,
SAFE_CAST(servico_especializado_enfrentamento_violencia_mulher AS INT64) servico_especializado_enfrentamento_violencia_mulher,
SAFE_CAST(servico_ceam_cram_niam AS INT64) servico_ceam_cram_niam,
SAFE_CAST(quantidade_ceam_cram_niam AS INT64) quantidade_ceam_cram_niam,
SAFE_CAST(servico_delegacia_atendimento_mulher AS INT64) servico_delegacia_atendimento_mulher,
SAFE_CAST(quantidade_delegacia_atendimento_mulher AS INT64) quantidade_delegacia_atendimento_mulher,
SAFE_CAST(servico_nucleo_mulher_delegacia_comum AS INT64) servico_nucleo_mulher_delegacia_comum,
SAFE_CAST(quantidade_nucleo_mulher_delegacia_comum AS INT64) quantidade_nucleo_mulher_delegacia_comum,
SAFE_CAST(nucleo_mulher_delegacia_comum_nao_soube_informar AS INT64) nucleo_mulher_delegacia_comum_nao_soube_informar,
SAFE_CAST(servico_juizado_violencia_domestica_mulher AS INT64) servico_juizado_violencia_domestica_mulher,
SAFE_CAST(quantidade_juizado_violencia_domestica_mulher AS INT64) quantidade_juizado_violencia_domestica_mulher,
SAFE_CAST(juizado_violencia_domestica_mulher_nao_soube_informar AS INT64) juizado_violencia_domestica_mulher_nao_soube_informar,
SAFE_CAST(servico_nucleo_genero_ministerio_publico AS INT64) servico_nucleo_genero_ministerio_publico,
SAFE_CAST(quantidade_nucleo_genero_ministerio_publico AS INT64) quantidade_nucleo_genero_ministerio_publico,
SAFE_CAST(nucleo_genero_ministerio_publico_nao_soube_informar AS INT64) nucleo_genero_ministerio_publico_nao_soube_informar,
SAFE_CAST(servico_nudem AS INT64) servico_nudem,
SAFE_CAST(quantidade_nudem AS INT64) quantidade_nudem,
SAFE_CAST(nudem_nao_soube_informar AS INT64) nudem_nao_soube_informar,
SAFE_CAST(servico_atendimento_violencia_sexual AS INT64) servico_atendimento_violencia_sexual,
SAFE_CAST(quantidade_atendimento_violencia_sexual AS INT64) quantidade_atendimento_violencia_sexual,
SAFE_CAST(atendimento_violencia_sexual_nao_soube_informar AS INT64) atendimento_violencia_sexual_nao_soube_informar,
SAFE_CAST(servico_presidio_exclusivo_feminino AS INT64) servico_presidio_exclusivo_feminino,
SAFE_CAST(quantidade_presidio_exclusivo_feminino AS INT64) quantidade_presidio_exclusivo_feminino,
SAFE_CAST(presidio_exclusivo_feminino_nao_soube_informar AS INT64) presidio_exclusivo_feminino_nao_soube_informar,
SAFE_CAST(servico_instituto_medico_legal AS INT64) servico_instituto_medico_legal,
SAFE_CAST(quantidade_instituto_medico_legal AS INT64) quantidade_instituto_medico_legal,
SAFE_CAST(instituto_medico_legal_nao_soube_informar AS INT64) instituto_medico_legal_nao_soube_informar,
SAFE_CAST(atendimento_mulher_ceam_cram_niam_levantamento AS STRING) atendimento_mulher_ceam_cram_niam_levantamento,
SAFE_CAST(atendimento_mulher_ceam_cram_niam_divulgacao AS INT64) atendimento_mulher_ceam_cram_niam_divulgacao,
SAFE_CAST(atendimento_mulher_ceam_cram_niam_2017 AS INT64) atendimento_mulher_ceam_cram_niam_2017,
SAFE_CAST(ceam_cram_niam_atendimento_psicologico_individual AS INT64) ceam_cram_niam_atendimento_psicologico_individual,
SAFE_CAST(ceam_cram_niam_atendimento_psicologico_grupo AS INT64) ceam_cram_niam_atendimento_psicologico_grupo,
SAFE_CAST(ceam_cram_niam_cultural_educativa_profissional AS INT64) ceam_cram_niam_cultural_educativa_profissional,
SAFE_CAST(ceam_cram_niam_programa_social AS INT64) ceam_cram_niam_programa_social,
SAFE_CAST(ceam_cram_niam_atendimento_juridico AS INT64) ceam_cram_niam_atendimento_juridico,
SAFE_CAST(ceam_cram_niam_programa_emprego AS INT64) ceam_cram_niam_programa_emprego,
SAFE_CAST(ceam_cram_niam_outras AS INT64) ceam_cram_niam_outras,
SAFE_CAST(ceam_cram_niam_nao_soube_informar AS INT64) ceam_cram_niam_nao_soube_informar,
SAFE_CAST(atendimento_seguranca_publica_levantamento AS INT64) atendimento_seguranca_publica_levantamento,
SAFE_CAST(atendimento_seguranca_publica_informacao_violencia AS INT64) atendimento_seguranca_publica_informacao_violencia,
SAFE_CAST(atendimento_saude_levantamento AS INT64) atendimento_saude_levantamento,
SAFE_CAST(atendimento_saude_informacao_violencia AS INT64) atendimento_saude_informacao_violencia
FROM basedosdados-dev.br_ibge_estadic_staging.politica_mulher AS t