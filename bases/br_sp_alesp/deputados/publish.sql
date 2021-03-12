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

CREATE VIEW basedosdados-dev.br_sp_alesp.deputados AS
SELECT 
SAFE_CAST(matricula AS INT64) matricula,
SAFE_CAST(id_deputado AS INT64) id_deputado,
SAFE_CAST(deputado AS STRING) deputado,
SAFE_CAST(aniversario AS STRING) aniversario,
SAFE_CAST(partido AS STRING) partido,
SAFE_CAST(numero_deputados AS INT64) numero_deputados,
SAFE_CAST(situacao AS STRING) situacao,
SAFE_CAST(email AS STRING) email,
SAFE_CAST(sala AS STRING) sala,
SAFE_CAST(placa_veiculo AS STRING) placa_veiculo,
SAFE_CAST(home_page AS STRING) home_page,
SAFE_CAST(andar AS STRING) andar,
SAFE_CAST(id_spl AS STRING) id_spl
from basedosdados-dev.br_sp_alesp_staging.deputados as t