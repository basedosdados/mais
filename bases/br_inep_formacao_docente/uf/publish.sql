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

CREATE VIEW basedosdados-dev.br_inep_formacao_docente.uf AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(regiao AS STRING) regiao,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(tipo_localizacao AS STRING) tipo_localizacao,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(modalidade AS STRING) modalidade,
SAFE_CAST(grupo AS INT64) grupo,
SAFE_CAST(percentual AS FLOAT64) percentual
FROM basedosdados-dev.br_inep_formacao_docente_staging.uf AS t