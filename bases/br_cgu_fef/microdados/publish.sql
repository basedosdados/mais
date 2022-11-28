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

CREATE VIEW basedosdados-dev.br_cgu_fef.microdados AS
SELECT 
SAFE_CAST(sorteio_ciclo_fef AS STRING) sorteio_ciclo_fef,
SAFE_CAST(ano_evento AS INT64) ano_evento,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(numero_ordem_servico AS STRING) numero_ordem_servico,
SAFE_CAST(montante_fiscalizado AS FLOAT64) montante_fiscalizado,
SAFE_CAST(ano_exercicio_repasse AS INT64) ano_exercicio_repasse,
SAFE_CAST(unidade_examinada AS STRING) unidade_examinada,
SAFE_CAST(unidade_jurisdicionada_tcu AS STRING) unidade_jurisdicionada_tcu,
SAFE_CAST(orgao_superior AS STRING) orgao_superior,
SAFE_CAST(funcao AS STRING) funcao,
SAFE_CAST(subfuncao AS STRING) subfuncao,
SAFE_CAST(programa AS STRING) programa,
SAFE_CAST(acao AS STRING) acao,
SAFE_CAST(programacao AS STRING) programacao,
SAFE_CAST(tipo_constatacao AS STRING) tipo_constatacao
FROM basedosdados-dev.br_cgu_fef_staging.microdados AS t