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

CREATE VIEW basedosdados-dev.br_ms_atencao_basica.municipio AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_municipio_6 AS STRING) id_municipio_6,
SAFE_CAST(populacao AS INT64) populacao,
SAFE_CAST(carga_horaria_medica_atencao_basica_tradicional AS FLOAT64) carga_horaria_medica_atencao_basica_tradicional,
SAFE_CAST(carga_horaria_enfermagem_atencao_basica_tradicional AS FLOAT64) carga_horaria_enfermagem_atencao_basica_tradicional,
SAFE_CAST(quantidade_equipes_atencao_basica_equivalente AS INT64) quantidade_equipes_atencao_basica_equivalente,
SAFE_CAST(quantidade_equipes_atencao_basica_parametrizada AS INT64) quantidade_equipes_atencao_basica_parametrizada,
SAFE_CAST(quantidade_equipes_saude_familia AS INT64) quantidade_equipes_saude_familia,
SAFE_CAST(quantidade_equipes_atencao_basica_total AS INT64) quantidade_equipes_atencao_basica_total,
SAFE_CAST(populacao_coberta_estrategia_saude_familia AS INT64) populacao_coberta_estrategia_saude_familia,
SAFE_CAST(proporcao_cobertura_estrategia_saude_familia AS FLOAT64) proporcao_cobertura_estrategia_saude_familia,
SAFE_CAST(populacao_coberta_total_atencao_basica AS INT64) populacao_coberta_total_atencao_basica,
SAFE_CAST(proporcao_cobertura_total_atencao_basica AS FLOAT64) proporcao_cobertura_total_atencao_basica
FROM basedosdados-dev.br_ms_atencao_basica_staging.municipio AS t