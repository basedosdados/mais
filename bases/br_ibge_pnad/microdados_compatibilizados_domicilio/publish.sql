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

CREATE VIEW basedosdados-dev.br_ibge_pnad.microdados_compatibilizados_domicilio AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(id_regiao AS STRING) id_regiao,
SAFE_CAST(id_uf AS STRING) id_uf,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_domicilio AS STRING) id_domicilio,
SAFE_CAST(regiao_metropolitana AS INT64) regiao_metropolitana,
SAFE_CAST(zona_urbana AS STRING) zona_urbana,
SAFE_CAST(tipo_zona_domicilio AS STRING) tipo_zona_domicilio,
SAFE_CAST(total_pessoas AS INT64) total_pessoas,
SAFE_CAST(total_pessoas_10_mais AS INT64) total_pessoas_10_mais,
SAFE_CAST(especie_domicilio AS STRING) especie_domicilio,
SAFE_CAST(tipo_domicilio AS STRING) tipo_domicilio,
SAFE_CAST(tipo_parede AS STRING) tipo_parede,
SAFE_CAST(tipo_cobertura AS STRING) tipo_cobertura,
SAFE_CAST(possui_agua_rede AS STRING) possui_agua_rede,
SAFE_CAST(tipo_esgoto AS STRING) tipo_esgoto,
SAFE_CAST(possui_sanitario_exclusivo AS STRING) possui_sanitario_exclusivo,
SAFE_CAST(lixo_coletado AS STRING) lixo_coletado,
SAFE_CAST(possui_iluminacao_eletrica AS STRING) possui_iluminacao_eletrica,
SAFE_CAST(quantidade_comodos AS INT64) quantidade_comodos,
SAFE_CAST(quantidade_dormitorios AS INT64) quantidade_dormitorios,
SAFE_CAST(possui_sanitario AS STRING) possui_sanitario,
SAFE_CAST(posse_domicilio AS STRING) posse_domicilio,
SAFE_CAST(possui_filtro AS STRING) possui_filtro,
SAFE_CAST(possui_fogao AS STRING) possui_fogao,
SAFE_CAST(possui_geladeira AS STRING) possui_geladeira,
SAFE_CAST(possui_radio AS STRING) possui_radio,
SAFE_CAST(possui_tv AS STRING) possui_tv,
SAFE_CAST(renda_mensal_domiciliar AS FLOAT64) renda_mensal_domiciliar,
SAFE_CAST(renda_mensal_domiciliar_compativel_1992 AS FLOAT64) renda_mensal_domiciliar_compativel_1992,
SAFE_CAST(aluguel AS FLOAT64) aluguel,
SAFE_CAST(prestacao AS FLOAT64) prestacao,
SAFE_CAST(deflator AS INT64) deflator,
SAFE_CAST(conversor_moeda AS INT64) conversor_moeda,
SAFE_CAST(renda_domicilio_deflacionado AS FLOAT64) renda_domicilio_deflacionado,
SAFE_CAST(renda_mensal_domiciliar_compativel_1992_deflacionado AS FLOAT64) renda_mensal_domiciliar_compativel_1992_deflacionado,
SAFE_CAST(aluguel_deflacionado AS FLOAT64) aluguel_deflacionado,
SAFE_CAST(prestacao_deflacionado AS FLOAT64) prestacao_deflacionado,
SAFE_CAST(peso_amostral AS FLOAT64) peso_amostral
FROM basedosdados-dev.br_ibge_pnad_staging.microdados_compatibilizados_domicilio AS t