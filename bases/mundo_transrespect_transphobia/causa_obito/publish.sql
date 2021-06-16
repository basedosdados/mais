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

CREATE VIEW basedosdados-dev.mundo_transrespect_transphobia.causa_obito AS
SELECT 
SAFE_CAST(causa_obito AS STRING) causa_obito,
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(homicidios AS STRING) homicidios
from basedosdados-dev.mundo_transrespect_transphobia_staging.causa_obito as t