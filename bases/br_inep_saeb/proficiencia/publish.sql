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

CREATE VIEW basedosdados-dev.br_inep_saeb.proficiencia AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(id_regiao AS STRING) id_regiao,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_escola AS STRING) id_escola,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(localizacao AS STRING) localizacao,
SAFE_CAST(serie AS STRING) serie,
SAFE_CAST(turno AS STRING) turno,
SAFE_CAST(disciplina AS STRING) disciplina,
SAFE_CAST(id_turma AS STRING) id_turma,
SAFE_CAST(id_aluno AS STRING) id_aluno,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(raca_cor AS STRING) raca_cor,
SAFE_CAST(estrato AS INT64) estrato,
SAFE_CAST(amostra AS INT64) amostra,
SAFE_CAST(peso_aluno AS FLOAT64) peso_aluno,
SAFE_CAST(proficiencia AS FLOAT64) proficiencia,
SAFE_CAST(erro_padrao AS FLOAT64) erro_padrao,
SAFE_CAST(proficiencia_saeb AS FLOAT64) proficiencia_saeb,
SAFE_CAST(erro_padrao_saeb AS FLOAT64) erro_padrao_saeb
FROM basedosdados-dev.br_inep_saeb_staging.proficiencia AS t