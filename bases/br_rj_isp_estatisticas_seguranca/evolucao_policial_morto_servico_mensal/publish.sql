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

CREATE VIEW basedosdados-dev.br_rj_isp_estatisticas_seguranca.evolucao_policial_morto_servico_mensal AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(id_cisp AS STRING) id_cisp,
SAFE_CAST(quantidade_policial_militar_morto_servico AS INT64) quantidade_policial_militar_morto_servico,
SAFE_CAST(quantidade_policial_civil_morto_servico AS INT64) quantidade_policial_civil_morto_servico
FROM basedosdados-dev.br_rj_isp_estatisticas_seguranca_staging.evolucao_policial_morto_servico_mensal AS t