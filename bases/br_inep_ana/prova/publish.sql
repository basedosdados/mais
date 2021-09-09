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

CREATE VIEW basedosdados-dev.br_inep_ana.prova AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(serie AS STRING) serie,
SAFE_CAST(tipo_prova AS STRING) tipo_prova,
SAFE_CAST(disciplina AS STRING) disciplina,
SAFE_CAST(bloco AS STRING) bloco,
SAFE_CAST(posicao AS STRING) posicao,
SAFE_CAST(item AS STRING) item,
SAFE_CAST(descritor AS STRING) descritor,
SAFE_CAST(gabarito AS STRING) gabarito
from basedosdados-dev.br_inep_ana_staging.prova as t