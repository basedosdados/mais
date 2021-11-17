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
SAFE_CAST(ano AS int64) ano,
SAFE_CAST(sigla_uf AS string) sigla_uf,
SAFE_CAST(id_municipio AS string) id_municipio,
SAFE_CAST(id_escola AS string) id_escola,
SAFE_CAST(rede AS string) rede,
SAFE_CAST(tipo_localizacao AS string) tipo_localizacao,
SAFE_CAST(nivel_socioeconomico AS string) nivel_socioeconomico,
SAFE_CAST(formacao_docente AS string) formacao_docente,
SAFE_CAST(porte_escola AS string) porte_escola,
SAFE_CAST(alunos_matriculados AS int64) alunos_matriculados,
SAFE_CAST(participantes_enem AS int64) participantes_enem,
SAFE_CAST(participantes_enem_necessidade_especial AS int64) participantes_enem_necessidade_especial,
SAFE_CAST(media_ciencias_natureza AS float64) media_ciencias_natureza,
SAFE_CAST(media_ciencias_humanas AS float64) media_ciencias_humanas,
SAFE_CAST(media_linguagens_codigos AS float64) media_linguagens_codigos,
SAFE_CAST(media_matematica AS float64) media_matematica,
SAFE_CAST(media_redacao AS float64) media_redacao,
SAFE_CAST(media_prova_objetiva AS float64) media_prova_objetiva,
SAFE_CAST(media_total AS float64) media_total,
SAFE_CAST(taxa_participacao AS float64) taxa_participacao,
SAFE_CAST(taxa_permanencia AS float64) taxa_permanencia,
SAFE_CAST(taxa_aprovacao AS float64) taxa_aprovacao,
SAFE_CAST(taxa_reprovacao AS float64) taxa_reprovacao,
SAFE_CAST(taxa_abandono AS float64) taxa_abandono
FROM basedosdados-dev.br_inep_enem_staging.escola AS t