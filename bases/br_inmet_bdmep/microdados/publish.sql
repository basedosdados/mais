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

CREATE VIEW basedosdados-dev.br_inmet_bdmep.microdados AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(data AS DATE) data,
SAFE_CAST(hora AS TIME) hora,
SAFE_CAST(id_estacao AS STRING) id_estacao,
SAFE_CAST(precipitacao_total AS FLOAT64) precipitacao_total,
SAFE_CAST(pressao_atm_hora AS FLOAT64) pressao_atm_hora,
SAFE_CAST(pressao_atm_max AS FLOAT64) pressao_atm_max,
SAFE_CAST(pressao_atm_min AS FLOAT64) pressao_atm_min,
SAFE_CAST(radiacao_global AS FLOAT64) radiacao_global,
SAFE_CAST(temperatura_bulbo_hora AS FLOAT64) temperatura_bulbo_hora,
SAFE_CAST(temperatura_orvalho_hora AS FLOAT64) temperatura_orvalho_hora,
SAFE_CAST(temperatura_max AS FLOAT64) temperatura_max,
SAFE_CAST(temperatura_min AS FLOAT64) temperatura_min,
SAFE_CAST(temperatura_orvalho_max AS FLOAT64) temperatura_orvalho_max,
SAFE_CAST(temperatura_orvalho_min AS FLOAT64) temperatura_orvalho_min,
SAFE_CAST(umidade_rel_max AS FLOAT64) umidade_rel_max,
SAFE_CAST(umidade_rel_min AS FLOAT64) umidade_rel_min,
SAFE_CAST(umidade_rel_hora AS FLOAT64) umidade_rel_hora,
SAFE_CAST(vento_direcao AS FLOAT64) vento_direcao,
SAFE_CAST(vento_rajada_max AS FLOAT64) vento_rajada_max,
SAFE_CAST(vento_velocidade AS FLOAT64) vento_velocidade
FROM basedosdados-dev.br_inmet_bdmep_staging.microdados AS t