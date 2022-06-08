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

CREATE VIEW basedosdados-dev.br_inep_saeb.aluno_ef_2ano AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(id_regiao AS STRING) id_regiao,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(area AS STRING) area,
SAFE_CAST(id_escola AS STRING) id_escola,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(localizacao AS STRING) localizacao,
SAFE_CAST(id_turma AS STRING) id_turma,
SAFE_CAST(turno AS STRING) turno,
SAFE_CAST(serie AS INT64) serie,
SAFE_CAST(id_aluno AS STRING) id_aluno,
SAFE_CAST(situacao_censo AS INT64) situacao_censo,
SAFE_CAST(disciplina AS STRING) disciplina,
SAFE_CAST(preenchimento_caderno AS INT64) preenchimento_caderno,
SAFE_CAST(presenca AS INT64) presenca,
SAFE_CAST(caderno AS STRING) caderno,
SAFE_CAST(bloco_1 AS STRING) bloco_1,
SAFE_CAST(bloco_2 AS STRING) bloco_2,
SAFE_CAST(bloco_1_aberto AS STRING) bloco_1_aberto,
SAFE_CAST(bloco_2_aberto AS STRING) bloco_2_aberto,
SAFE_CAST(respostas_bloco_1 AS STRING) respostas_bloco_1,
SAFE_CAST(respostas_bloco_2 AS STRING) respostas_bloco_2,
SAFE_CAST(conceito_q1 AS STRING) conceito_q1,
SAFE_CAST(conceito_q2 AS STRING) conceito_q2,
SAFE_CAST(resposta_texto AS STRING) resposta_texto,
SAFE_CAST(conceito_proposito AS STRING) conceito_proposito,
SAFE_CAST(conceito_elemento AS STRING) conceito_elemento,
SAFE_CAST(conceito_segmentacao AS STRING) conceito_segmentacao,
SAFE_CAST(texto_grafia AS STRING) texto_grafia,
SAFE_CAST(indicador_proficiencia AS STRING) indicador_proficiencia,
SAFE_CAST(amostra AS STRING) amostra,
SAFE_CAST(estrato AS STRING) estrato,
SAFE_CAST(peso_aluno AS FLOAT64) peso_aluno,
SAFE_CAST(proficiencia AS FLOAT64) proficiencia,
SAFE_CAST(erro_padrao AS FLOAT64) erro_padrao,
SAFE_CAST(proficiencia_saeb AS FLOAT64) proficiencia_saeb,
SAFE_CAST(erro_padrao_saeb AS FLOAT64) erro_padrao_saeb
FROM basedosdados-dev.br_inep_saeb_staging.aluno_ef_2ano AS t