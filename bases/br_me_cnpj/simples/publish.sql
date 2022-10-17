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

CREATE VIEW basedosdados-dev.br_me_cnpj.simples AS
SELECT 
SAFE_CAST(cnpj_basico AS STRING) cnpj_basico,
SAFE_CAST(opcao_simples AS INT64) opcao_simples,
SAFE_CAST(data_opcao_simples AS DATE) data_opcao_simples,
SAFE_CAST(data_exclusao_simples AS DATE) data_exclusao_simples,
SAFE_CAST(opcao_mei AS INT64) opcao_mei,
SAFE_CAST(data_opcao_mei AS DATE) data_opcao_mei,
SAFE_CAST(data_exclusao_mei AS DATE) data_exclusao_mei
FROM basedosdados-dev.br_me_cnpj_staging.simples AS t