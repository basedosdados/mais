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

CREATE VIEW basedosdados-dev.br_inep_sinopse_estatistica_educacao_basica.etapa_ensino_serie AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(etapa_ensino AS STRING) etapa_ensino,
SAFE_CAST(serie AS INT64) serie,
SAFE_CAST(quantidade_matricula AS INT64) quantidade_matricula
FROM basedosdados-dev.br_inep_sinopse_estatistica_educacao_basica_staging.etapa_ensino_serie AS t