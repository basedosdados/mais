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

CREATE VIEW basedosdados-dev.br_bd_diretorios_brasil.municipio AS
SELECT 
SAFE_CAST(id_municipio AS string) id_municipio,
SAFE_CAST(id_municipio_6 AS string) id_municipio_6,
SAFE_CAST(id_municipio_tse AS string) id_municipio_tse,
SAFE_CAST(id_municipio_rf AS string) id_municipio_rf,
SAFE_CAST(id_municipio_bcb AS string) id_municipio_bcb,
SAFE_CAST(nome AS string) nome,
SAFE_CAST(capital_uf AS int64) capital_uf,
SAFE_CAST(id_comarca AS string) id_comarca,
SAFE_CAST(id_regiao_saude AS string) id_regiao_saude,
SAFE_CAST(nome_regiao_saude AS string) nome_regiao_saude,
SAFE_CAST(id_regiao_imediata AS string) id_regiao_imediata,
SAFE_CAST(nome_regiao_imediata AS string) nome_regiao_imediata,
SAFE_CAST(id_regiao_intermediaria AS string) id_regiao_intermediaria,
SAFE_CAST(nome_regiao_intermediaria AS string) nome_regiao_intermediaria,
SAFE_CAST(id_microrregiao AS string) id_microrregiao,
SAFE_CAST(nome_microrregiao AS string) nome_microrregiao,
SAFE_CAST(id_mesorregiao AS string) id_mesorregiao,
SAFE_CAST(nome_mesorregiao AS string) nome_mesorregiao,
SAFE_CAST(ddd AS string) ddd,
SAFE_CAST(id_uf AS string) id_uf,
SAFE_CAST(sigla_uf AS string) sigla_uf,
SAFE_CAST(nome_uf AS string) nome_uf,
SAFE_CAST(nome_regiao AS string) nome_regiao
FROM basedosdados-dev.br_bd_diretorios_brasil_staging.municipio AS t