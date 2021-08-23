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

CREATE VIEW basedosdados-dev.br_inep_ana.aluno AS
SELECT
SAFE_CAST(ano AS INT64) ano, 
SAFE_CAST(id_regiao AS STRING) id_regiao,
SAFE_CAST(id_uf AS STRING) id_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(tipo_area AS STRING) tipo_area,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(id_escola AS STRING) id_escola,
SAFE_CAST(tipo_localizacao AS STRING) tipo_localizacao,
SAFE_CAST(id_turma AS STRING) id_turma,
SAFE_CAST(turno AS STRING) turno,
SAFE_CAST(serie AS STRING) serie,
SAFE_CAST(id_aluno AS STRING) id_aluno,
SAFE_CAST(situacao_censo AS STRING) situacao_censo,
SAFE_CAST(preenchimento_prova_lp AS STRING) preenchimento_prova_lp,
SAFE_CAST(preenchimento_prova_mt AS STRING) preenchimento_prova_mt,
SAFE_CAST(presenca_prova_lp AS STRING) presenca_prova_lp,
SAFE_CAST(presenca_prova_mt AS STRING) presenca_prova_mt,
SAFE_CAST(tipo_presenca_prova_lp AS STRING) tipo_presenca_prova_lp,
SAFE_CAST(tipo_presenca_prova_mt AS STRING) tipo_presenca_prova_mt,
SAFE_CAST(sala_separada_lp AS STRING) sala_separada_lp,
SAFE_CAST(sala_separada_mt AS STRING) sala_separada_mt,
SAFE_CAST(solicitacao_escola_auxilio_leitura AS STRING) solicitacao_escola_auxilio_leitura,
SAFE_CAST(solicitacao_escola_auxilio_transcricao AS STRING) solicitacao_escola_auxilio_transcricao,
SAFE_CAST(solicitacao_escola_interprete_libras AS STRING) solicitacao_escola_interprete_libras,
SAFE_CAST(solicitacao_escola_guia_interprete AS STRING) solicitacao_escola_guia_interprete,
SAFE_CAST(solicitacao_escola_aparelho_cd AS STRING) solicitacao_escola_aparelho_cd,
SAFE_CAST(solicitacao_escola_aparelho_dvd AS STRING) solicitacao_escola_aparelho_dvd,
SAFE_CAST(solicitacao_escola_computador AS STRING) solicitacao_escola_computador,
SAFE_CAST(solicitacao_escola_maquina_escrever AS STRING) solicitacao_escola_maquina_escrever,
SAFE_CAST(solicitacao_escola_monitor_tv AS STRING) solicitacao_escola_monitor_tv,
SAFE_CAST(solicitacao_escola_puncao AS STRING) solicitacao_escola_puncao,
SAFE_CAST(solicitacao_escola_reglete AS STRING) solicitacao_escola_reglete,
SAFE_CAST(solicitacao_escola_sorabam AS STRING) solicitacao_escola_sorabam,
SAFE_CAST(solicitacao_escola_software_tela AS STRING) solicitacao_escola_software_tela,
SAFE_CAST(solicitacao_escola_nenhuma AS STRING) solicitacao_escola_nenhuma,
SAFE_CAST(solicitacao_inep_auxilio_leitura AS STRING) solicitacao_inep_auxilio_leitura,
SAFE_CAST(solicitacao_inep_auxilio_transcricao AS STRING) solicitacao_inep_auxilio_transcricao,
SAFE_CAST(solicitacao_inep_interprete_libras AS STRING) solicitacao_inep_interprete_libras,
SAFE_CAST(solicitacao_inep_leitor_labial AS STRING) solicitacao_inep_leitor_labial,
SAFE_CAST(solicitacao_inep_guia_interprete AS STRING) solicitacao_inep_guia_interprete,
SAFE_CAST(solicitacao_inep_aplicador_extra AS STRING) solicitacao_inep_aplicador_extra,
SAFE_CAST(solicitacao_inep_prova_adaptada AS STRING) solicitacao_inep_prova_adaptada,
SAFE_CAST(solicitacao_inep_prova_ampliada AS STRING) solicitacao_inep_prova_ampliada,
SAFE_CAST(solicitacao_inep_prova_superampliada AS STRING) solicitacao_inep_prova_superampliada,
SAFE_CAST(solicitacao_inep_prova_braile AS STRING) solicitacao_inep_prova_braile,
SAFE_CAST(solicitacao_inep_nenhuma AS STRING) solicitacao_inep_nenhuma,
SAFE_CAST(caderno_lp AS STRING) caderno_lp,
SAFE_CAST(caderno_lp_leitura AS STRING) caderno_lp_leitura,
SAFE_CAST(caderno_lp_escrita AS STRING) caderno_lp_escrita,
SAFE_CAST(caderno_mt AS STRING) caderno_mt,
SAFE_CAST(respostas_lp AS STRING) respostas_lp,
SAFE_CAST(respostas_mt AS STRING) respostas_mt,
SAFE_CAST(conceito_questao_1 AS STRING) conceito_questao_1,
SAFE_CAST(conceito_questao_2 AS STRING) conceito_questao_2,
SAFE_CAST(conceito_questao_3_ortografia AS STRING) conceito_questao_3_ortografia,
SAFE_CAST(conceito_questao_3_coesao AS STRING) conceito_questao_3_coesao,
SAFE_CAST(conceito_questao_3_segmentacao AS STRING) conceito_questao_3_segmentacao,
SAFE_CAST(conceito_questao_3_pontuacao AS STRING) conceito_questao_3_pontuacao,
SAFE_CAST(conceito_questao_3_progressao_tematica AS STRING) conceito_questao_3_progressao_tematica,
SAFE_CAST(conceito_questao_3_elementos_narrativa AS STRING) conceito_questao_3_elementos_narrativa,
SAFE_CAST(peso_aluno_lp AS FLOAT64) peso_aluno_lp,
SAFE_CAST(peso_aluno_lp_leitura AS FLOAT64) peso_aluno_lp_leitura,
SAFE_CAST(nivel_lp_leitura AS STRING) nivel_lp_leitura,
SAFE_CAST(proficiencia_lp_leitura AS FLOAT64) proficiencia_lp_leitura,
SAFE_CAST(erro_padrao_lp_leitura AS FLOAT64) erro_padrao_lp_leitura,
SAFE_CAST(proficiencia_leitura_ana AS FLOAT64) proficiencia_leitura_ana,
SAFE_CAST(erro_padrao_leitura_ana AS FLOAT64) erro_padrao_leitura_ana,
SAFE_CAST(peso_aluno_lp_escrita AS FLOAT64) peso_aluno_lp_escrita,
SAFE_CAST(nivel_lp_escrita AS STRING) nivel_lp_escrita,
SAFE_CAST(proficiencia_lp_escrita AS FLOAT64) proficiencia_lp_escrita,
SAFE_CAST(erro_padrao_lp_escrita AS FLOAT64) erro_padrao_lp_escrita,
SAFE_CAST(proficiencia_escrita_ana AS FLOAT64) proficiencia_escrita_ana,
SAFE_CAST(erro_padrao_escrita_ana AS FLOAT64) erro_padrao_escrita_ana,
SAFE_CAST(peso_aluno_mt AS FLOAT64) peso_aluno_mt,
SAFE_CAST(nivel_mt AS STRING) nivel_mt,
SAFE_CAST(proficiencia_mt AS FLOAT64) proficiencia_mt,
SAFE_CAST(erro_padrao_mt AS FLOAT64) erro_padrao_mt,
SAFE_CAST(proficiencia_mt_ana AS FLOAT64) proficiencia_mt_ana,
SAFE_CAST(erro_padrao_mt_ana AS FLOAT64) erro_padrao_mt_ana
from basedosdados-dev.br_inep_ana_staging.aluno as t