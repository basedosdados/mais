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

CREATE VIEW basedosdados-dev.br_me_cno.microdados_vinculo AS
SELECT 
SAFE_CAST(id_cno AS STRING) id_cno,
SAFE_CAST(data_inicio AS DATE) data_inicio,
SAFE_CAST(data_fim AS DATE) data_fim,
SAFE_CAST(data_registro AS DATE) data_registro,
SAFE_CAST(qualificacao_responsavel AS STRING) qualificacao_responsavel,
SAFE_CAST(ni_responsavel AS STRING) ni_responsavel
from basedosdados-dev.br_me_cno_staging.microdados_vinculo as t