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

CREATE VIEW basedosdados-dev.br_inep_censo_escolar.matricula AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_distrito AS STRING) id_distrito,
SAFE_CAST(id_escola AS STRING) id_escola,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(id_turma AS STRING) id_turma,
SAFE_CAST(id_aluno AS STRING) id_aluno,
SAFE_CAST(id_pessoa_fisica AS STRING) id_pessoa_fisica,
SAFE_CAST(id_matricula AS STRING) id_matricula,
SAFE_CAST(dia_nascimento AS INT64) dia_nascimento,
SAFE_CAST(mes_nascimento AS INT64) mes_nascimento,
SAFE_CAST(ano_nascimento AS INT64) ano_nascimento,
SAFE_CAST(idade_referencia AS INT64) idade_referencia,
SAFE_CAST(idade AS INT64) idade,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(raca_cor AS STRING) raca_cor,
SAFE_CAST(nacionalidade AS STRING) nacionalidade,
SAFE_CAST(id_pais_origem AS STRING) id_pais_origem,
SAFE_CAST(id_uf_nascimento AS STRING) id_uf_nascimento,
SAFE_CAST(id_municipio_nascimento AS STRING) id_municipio_nascimento,
SAFE_CAST(id_uf_endereco AS STRING) id_uf_endereco,
SAFE_CAST(id_municipio_endereco AS STRING) id_municipio_endereco,
SAFE_CAST(zona_residencial AS STRING) zona_residencial,
SAFE_CAST(local_residencia_diferenciada AS STRING) local_residencia_diferenciada,
SAFE_CAST(outro_local_aula AS STRING) outro_local_aula,
SAFE_CAST(duracao_turma AS STRING) duracao_turma,
SAFE_CAST(duracao_ativ_comp_mesma_rede AS INT64) duracao_ativ_comp_mesma_rede,
SAFE_CAST(duracao_ativ_comp_outras_redes AS INT64) duracao_ativ_comp_outras_redes,
SAFE_CAST(duracao_aee_comp_mesma_rede AS INT64) duracao_aee_comp_mesma_rede,
SAFE_CAST(duracao_aee_comp_outras_redes AS INT64) duracao_aee_comp_outras_redes,
SAFE_CAST(dias_atividade AS STRING) dias_atividade,
SAFE_CAST(transporte_publico AS STRING) transporte_publico,
SAFE_CAST(responsavel_transporte AS STRING) responsavel_transporte,
SAFE_CAST(transporte_bicicleta AS STRING) transporte_bicicleta,
SAFE_CAST(transporte_micro_onibus AS STRING) transporte_micro_onibus,
SAFE_CAST(transporte_onibus AS STRING) transporte_onibus,
SAFE_CAST(transporte_tr_animal AS STRING) transporte_tr_animal,
SAFE_CAST(transporte_vans_kombi AS STRING) transporte_vans_kombi,
SAFE_CAST(transporte_outro_veiculo AS STRING) transporte_outro_veiculo,
SAFE_CAST(transporte_embarcacao_ate5 AS STRING) transporte_embarcacao_ate5,
SAFE_CAST(transporte_embarcacao_5a15 AS STRING) transporte_embarcacao_5a15,
SAFE_CAST(transporte_embarcacao_15a35 AS STRING) transporte_embarcacao_15a35,
SAFE_CAST(transporte_embarcacao_35 AS STRING) transporte_embarcacao_35,
SAFE_CAST(transporte_trem_metro AS STRING) transporte_trem_metro,
SAFE_CAST(necessidade_especial AS STRING) necessidade_especial,
SAFE_CAST(baixa_visao AS STRING) baixa_visao,
SAFE_CAST(cegueira AS STRING) cegueira,
SAFE_CAST(deficiencia_auditiva AS STRING) deficiencia_auditiva,
SAFE_CAST(deficiencia_fisica AS STRING) deficiencia_fisica,
SAFE_CAST(deficiencia_intelectual AS STRING) deficiencia_intelectual,
SAFE_CAST(surdez AS STRING) surdez,
SAFE_CAST(surdocegueira AS STRING) surdocegueira,
SAFE_CAST(deficiencia_multipla AS STRING) deficiencia_multipla,
SAFE_CAST(autismo AS STRING) autismo,
SAFE_CAST(sindrome_asperger AS STRING) sindrome_asperger,
SAFE_CAST(sindrome_rett AS STRING) sindrome_rett,
SAFE_CAST(transtorno_di AS STRING) transtorno_di,
SAFE_CAST(superdotacao AS STRING) superdotacao,
SAFE_CAST(recurso_ledor AS STRING) recurso_ledor,
SAFE_CAST(recurso_transcricao AS STRING) recurso_transcricao,
SAFE_CAST(recurso_interprete AS STRING) recurso_interprete,
SAFE_CAST(recurso_libras AS STRING) recurso_libras,
SAFE_CAST(recurso_labial AS STRING) recurso_labial,
SAFE_CAST(recurso_ampliada_16 AS STRING) recurso_ampliada_16,
SAFE_CAST(recurso_ampliada_18 AS STRING) recurso_ampliada_18,
SAFE_CAST(recurso_ampliada_20 AS STRING) recurso_ampliada_20,
SAFE_CAST(recurso_ampliada_24 AS STRING) recurso_ampliada_24,
SAFE_CAST(recurso_cd_audio AS STRING) recurso_cd_audio,
SAFE_CAST(recurso_prova_portugues AS STRING) recurso_prova_portugues,
SAFE_CAST(recurso_video_libras AS STRING) recurso_video_libras,
SAFE_CAST(recurso_braille AS STRING) recurso_braille,
SAFE_CAST(recurso_nenhum AS STRING) recurso_nenhum,
SAFE_CAST(aee_libras AS STRING) aee_libras,
SAFE_CAST(aee_lingua_portuguesa AS STRING) aee_lingua_portuguesa,
SAFE_CAST(aee_informatica_acessivel AS STRING) aee_informatica_acessivel,
SAFE_CAST(aee_braille AS STRING) aee_braille,
SAFE_CAST(aee_caa AS STRING) aee_caa,
SAFE_CAST(aee_soroban AS STRING) aee_soroban,
SAFE_CAST(aee_vida_autonoma AS STRING) aee_vida_autonoma,
SAFE_CAST(aee_opticos_nao_opticos AS STRING) aee_opticos_nao_opticos,
SAFE_CAST(aee_enriquecimento_curricular AS STRING) aee_enriquecimento_curricular,
SAFE_CAST(aee_desenvolvimento_cognitivo AS STRING) aee_desenvolvimento_cognitivo,
SAFE_CAST(aee_mobilidade AS STRING) aee_mobilidade,
SAFE_CAST(ingresso_federais AS STRING) ingresso_federais,
SAFE_CAST(etapa_ensino AS STRING) etapa_ensino,
SAFE_CAST(especial_exclusiva AS STRING) especial_exclusiva,
SAFE_CAST(regular AS STRING) regular,
SAFE_CAST(eja AS STRING) eja,
SAFE_CAST(profissionalizante AS STRING) profissionalizante,
SAFE_CAST(id_curso_educ_profissional AS STRING) id_curso_educ_profissional,
SAFE_CAST(mediacao_didatico_pedagogica AS STRING) mediacao_didatico_pedagogica,
SAFE_CAST(unificada AS STRING) unificada,
SAFE_CAST(tipo_atendimento_turma AS STRING) tipo_atendimento_turma,
SAFE_CAST(tipo_local_turma AS STRING) tipo_local_turma,
SAFE_CAST(tipo_turma AS STRING) tipo_turma
FROM basedosdados-dev.br_inep_censo_escolar_staging.matricula AS t