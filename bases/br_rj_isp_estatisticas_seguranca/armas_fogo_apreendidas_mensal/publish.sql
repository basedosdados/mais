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

CREATE VIEW basedosdados-dev.br_rj_isp_estatisticas_seguranca.armas_fogo_apreendidas_mensal AS
SELECT 
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(mes AS STRING) mes,
SAFE_CAST(id_cisp AS STRING) id_cisp,
SAFE_CAST(id_aisp AS STRING) id_aisp,
SAFE_CAST(id_risp AS STRING) id_risp,
SAFE_CAST(quantidade_arma_fabricacao_caseira AS STRING) quantidade_arma_fabricacao_caseira,
SAFE_CAST(quantidade_carabina AS STRING) quantidade_carabina,
SAFE_CAST(quantidade_espingarda AS STRING) quantidade_espingarda,
SAFE_CAST(quantidade_fuzil AS STRING) quantidade_fuzil,
SAFE_CAST(quantidade_garrucha AS STRING) quantidade_garrucha,
SAFE_CAST(quantidade_garruchao AS STRING) quantidade_garruchao,
SAFE_CAST(quantidade_metralhadora AS STRING) quantidade_metralhadora,
SAFE_CAST(quantidade_outros AS STRING) quantidade_outros,
SAFE_CAST(quantidade_pistola AS STRING) quantidade_pistola,
SAFE_CAST(quantidade_revolver AS STRING) quantidade_revolver,
SAFE_CAST(quantidade_submetralhadora AS STRING) quantidade_submetralhadora,
SAFE_CAST(total AS STRING) total
FROM basedosdados-dev.br_rj_isp_estatisticas_seguranca_staging.armas_fogo_apreendidas_mensal AS t