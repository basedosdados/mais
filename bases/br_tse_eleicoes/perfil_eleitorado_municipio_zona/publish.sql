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

CREATE VIEW basedosdados-dev.br_tse_eleicoes.perfil_eleitorado_municipio_zona AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_municipio_tse AS STRING) id_municipio_tse,
SAFE_CAST(zona AS INT64) zona,
SAFE_CAST(situacao_biometria AS STRING) situacao_biometria,
SAFE_CAST(genero AS STRING) genero,
SAFE_CAST(estado_civil AS STRING) estado_civil,
SAFE_CAST(grupo_idade AS STRING) grupo_idade,
SAFE_CAST(instrucao AS STRING) instrucao,
SAFE_CAST(eleitores AS INT64) eleitores,
SAFE_CAST(eleitores_biometria AS INT64) eleitores_biometria,
SAFE_CAST(eleitores_deficiencia AS INT64) eleitores_deficiencia
FROM basedosdados-dev.br_tse_eleicoes_staging.perfil_eleitorado_municipio_zona AS t