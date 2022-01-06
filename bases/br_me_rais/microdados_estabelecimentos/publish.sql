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

CREATE VIEW basedosdados-dev.br_me_rais.microdados_estabelecimentos AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(quantidade_vinculos_ativos AS INT64) quantidade_vinculos_ativos,
SAFE_CAST(quantidade_vinculos_clt AS INT64) quantidade_vinculos_clt,
SAFE_CAST(quantidade_vinculos_estatutarios AS INT64) quantidade_vinculos_estatutarios,
SAFE_CAST(natureza AS STRING) natureza,
SAFE_CAST(natureza_juridica AS STRING) natureza_juridica,
SAFE_CAST(tamanho AS STRING) tamanho,
SAFE_CAST(tipo AS STRING) tipo,
SAFE_CAST(indicador_cei_vinculado AS INT64) indicador_cei_vinculado,
SAFE_CAST(indicador_pat AS INT64) indicador_pat,
SAFE_CAST(indicador_simples AS INT64) indicador_simples,
SAFE_CAST(indicador_rais_negativa AS INT64) indicador_rais_negativa,
SAFE_CAST(indicador_atividade_ano AS INT64) indicador_atividade_ano,
SAFE_CAST(cnae_1 AS STRING) cnae_1,
SAFE_CAST(cnae_2 AS STRING) cnae_2,
SAFE_CAST(cnae_2_subclasse AS STRING) cnae_2_subclasse,
SAFE_CAST(subsetor_ibge AS STRING) subsetor_ibge,
SAFE_CAST(subatividade_ibge AS STRING) subatividade_ibge,
SAFE_CAST(cep AS STRING) cep,
SAFE_CAST(bairros_sp AS STRING) bairros_sp,
SAFE_CAST(distritos_sp AS STRING) distritos_sp,
SAFE_CAST(bairros_fortaleza AS STRING) bairros_fortaleza,
SAFE_CAST(bairros_rj AS STRING) bairros_rj,
SAFE_CAST(regioes_administrativas_df AS STRING) regioes_administrativas_df
FROM basedosdados-dev.br_me_rais_staging.microdados_estabelecimentos AS t