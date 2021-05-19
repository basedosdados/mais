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

CREATE VIEW basedosdados-dev.br_inep_saeb.microdados_aluno_2_ensino_fund AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_escola AS STRING) id_escola,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(localizacao AS STRING) localizacao,
SAFE_CAST(id_turma AS STRING) id_turma,
SAFE_CAST(id_turno AS STRING) id_turno,
SAFE_CAST(id_serie AS STRING) id_serie,
SAFE_CAST(id_aluno AS STRING) id_aluno,
SAFE_CAST(situacao_censo AS STRING) situacao_censo,
SAFE_CAST(preenchimento_prova_lp AS STRING) preenchimento_prova_lp,
SAFE_CAST(preenchimento_prova_mt AS STRING) preenchimento_prova_mt,
SAFE_CAST(presenca_prova_lp AS STRING) presenca_prova_lp,
SAFE_CAST(presenca_prova_mt AS STRING) presenca_prova_mt,
SAFE_CAST(id_caderno_lp AS STRING) id_caderno_lp,
SAFE_CAST(id_caderno_mt AS STRING) id_caderno_mt,
SAFE_CAST(id_bloco_1_lp AS STRING) id_bloco_1_lp,
SAFE_CAST(id_bloco_2_lp AS STRING) id_bloco_2_lp,
SAFE_CAST(identificador_resposta_bloco_1_lp AS STRING) identificador_resposta_bloco_1_lp,
SAFE_CAST(identificador_resposta_bloco_2_lp AS STRING) identificador_resposta_bloco_2_lp,
SAFE_CAST(id_bloco_1_mt AS STRING) id_bloco_1_mt,
SAFE_CAST(id_bloco_2_mt AS STRING) id_bloco_2_mt,
SAFE_CAST(identificador_resposta_bloco_1_mt AS STRING) identificador_resposta_bloco_1_mt,
SAFE_CAST(identificador_resposta_bloco_2_mt AS STRING) identificador_resposta_bloco_2_mt,
SAFE_CAST(taxa_resposta_bloco_1_lp AS STRING) taxa_resposta_bloco_1_lp,
SAFE_CAST(taxa_resposta_bloco_2_lp AS STRING) taxa_resposta_bloco_2_lp,
SAFE_CAST(conceito_questao_1_lp AS STRING) conceito_questao_1_lp,
SAFE_CAST(conceito_questao_2_lp AS STRING) conceito_questao_2_lp,
SAFE_CAST(conceito_resposta_texto AS STRING) conceito_resposta_texto,
SAFE_CAST(conceito_proposito AS STRING) conceito_proposito,
SAFE_CAST(conceito_elemento AS STRING) conceito_elemento,
SAFE_CAST(conceito_segmentacao AS STRING) conceito_segmentacao,
SAFE_CAST(conceito_texto_grafia AS STRING) conceito_texto_grafia,
SAFE_CAST(taxa_resposta_bloco_1_mt AS STRING) taxa_resposta_bloco_1_mt,
SAFE_CAST(taxa_resposta_bloco_2_mt AS STRING) taxa_resposta_bloco_2_mt,
SAFE_CAST(conceito_questao_1_mt AS STRING) conceito_questao_1_mt,
SAFE_CAST(conceito_questao_2_mt AS STRING) conceito_questao_2_mt,
SAFE_CAST(indicador_proficiencia_lp AS STRING) indicador_proficiencia_lp,
SAFE_CAST(indicador_proficiencia_mt AS STRING) indicador_proficiencia_mt,
SAFE_CAST(indicador_amostra AS STRING) indicador_amostra,
SAFE_CAST(estrato AS STRING) estrato,
SAFE_CAST(peso_aluno_lp AS FLOAT64) peso_aluno_lp,
SAFE_CAST(proficiencia_lp AS FLOAT64) proficiencia_lp,
SAFE_CAST(erro_padrao_lp AS FLOAT64) erro_padrao_lp,
SAFE_CAST(proficiencia_lp_saeb AS FLOAT64) proficiencia_lp_saeb,
SAFE_CAST(erro_padrao_lp_saeb AS FLOAT64) erro_padrao_lp_saeb,
SAFE_CAST(peso_aluno_mt AS FLOAT64) peso_aluno_mt,
SAFE_CAST(proficiencia_mt AS FLOAT64) proficiencia_mt,
SAFE_CAST(erro_padrao_mt AS FLOAT64) erro_padrao_mt,
SAFE_CAST(proficiencia_mt_saeb AS FLOAT64) proficiencia_mt_saeb,
SAFE_CAST(erro_padrao_mt_saeb AS FLOAT64) erro_padrao_mt_saeb
from basedosdados-dev.br_inep_saeb_staging.microdados_aluno_2_ensino_fund as t