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
SELECT 
SAFE_CAST(35 as INT64) id_estado,
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(orgao AS STRING) orgao,
SAFE_CAST(uo AS STRING) uo,
SAFE_CAST(unidade_gestora AS STRING) unidade_gestora,
SAFE_CAST(fonte_de_recursos AS STRING) fonte_de_recursos,
SAFE_CAST(funcao AS STRING) funcao,
SAFE_CAST(subfuncao AS STRING) subfuncao,
SAFE_CAST(programa AS STRING) programa,
SAFE_CAST(acao AS STRING) acao,
SAFE_CAST(funcional_programatica AS STRING) funcional_programatica,
SAFE_CAST(elemento AS STRING) elemento,
SAFE_CAST(dotacao_inicial AS INT64) dotacao_inicial,
SAFE_CAST(dotacao_atual AS INT64) dotacao_atual,
SAFE_CAST(empenhado AS INT64) empenhado,
SAFE_CAST(liquidado AS INT64) liquidado,
SAFE_CAST(pago AS INT64) pago,
SAFE_CAST(pago_restos AS INT64) pago_restos
from basedosdados-staging.br_sp_gov_orcamento_staging.despesas as t
