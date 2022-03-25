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

CREATE VIEW basedosdados-dev.br_bd_diretorios_mundo.pais AS
SELECT 
SAFE_CAST(id_pais_ocde AS STRING) id_pais_ocde,
SAFE_CAST(id_pais_fao AS STRING) id_pais_fao,
SAFE_CAST(id_pais_gaul AS STRING) id_pais_gaul,
SAFE_CAST(sigla_iso3 AS STRING) sigla_iso3,
SAFE_CAST(sigla_iso2 AS STRING) sigla_iso2,
SAFE_CAST(sigla_pnud AS STRING) sigla_pnud,
SAFE_CAST(nome_pt AS STRING) nome_pt,
SAFE_CAST(nome_en AS STRING) nome_en,
SAFE_CAST(nome_oficial_en AS STRING) nome_oficial_en,
SAFE_CAST(nacionalidade AS STRING) nacionalidade,
SAFE_CAST(sigla_continente AS STRING) sigla_continente
FROM basedosdados-dev.br_bd_diretorios_mundo_staging.pais AS t