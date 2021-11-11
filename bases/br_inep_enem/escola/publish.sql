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

CREATE VIEW basedosdados-dev.br_inep_enem.escola AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_escola AS STRING) id_escola,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(tipo_localizacao AS STRING) tipo_localizacao,
SAFE_CAST(nivel_socio_economico AS STRING) nivel_socio_economico,
SAFE_CAST(formacao_docente AS STRING) formacao_docente,
SAFE_CAST(porte_escola AS STRING) porte_escola,
SAFE_CAST(alunos_matriculados AS INT64) alunos_matriculados,
SAFE_CAST(participantes_enem AS INT64) participantes_enem,
SAFE_CAST(participantes_enem_necessidade_especial AS INT64) participantes_enem_necessidade_especial,
SAFE_CAST(media_ciencias_natureza AS FLOAT64) media_ciencias_natureza,
SAFE_CAST(media_ciencias_humanas AS FLOAT64) media_ciencias_humanas,
SAFE_CAST(media_linguagens_codigos AS FLOAT64) media_linguagens_codigos,
SAFE_CAST(media_matematica AS FLOAT64) media_matematica,
SAFE_CAST(media_redacao AS FLOAT64) media_redacao,
SAFE_CAST(media_prova_objetiva AS FLOAT64) media_prova_objetiva,
SAFE_CAST(media_total AS FLOAT64) media_total,
SAFE_CAST(taxa_participacao AS FLOAT64) taxa_participacao,
SAFE_CAST(taxa_permanencia AS FLOAT64) taxa_permanencia,
SAFE_CAST(taxa_aprovacao AS FLOAT64) taxa_aprovacao,
SAFE_CAST(taxa_reprovacao AS FLOAT64) taxa_reprovacao,
SAFE_CAST(taxa_abandono AS FLOAT64) taxa_abandono
FROM basedosdados-dev.br_inep_enem_staging.escola AS t