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

CREATE VIEW basedosdados-dev.br_ibge_ipca.mes AS
SELECT 
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(mes AS STRING) mes,
SAFE_CAST(indice AS STRING) indice,
SAFE_CAST(variacao_mensal AS STRING) variacao_mensal,
SAFE_CAST(variacao_tres_meses AS STRING) variacao_tres_meses,
SAFE_CAST(variacao_semestral AS STRING) variacao_semestral,
SAFE_CAST(variacao_anual AS STRING) variacao_anual,
SAFE_CAST(variacao_doze_meses AS STRING) variacao_doze_meses
from basedosdados-dev.br_ibge_ipca_staging.mes as t