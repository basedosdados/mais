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
CREATE VIEW basedosdados-dev.br_seeg_emissoes.municipio AS
SELECT
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(nivel_1 AS STRING) nivel_1,
SAFE_CAST(nivel_2 AS STRING) nivel_2,
SAFE_CAST(nivel_3 AS STRING) nivel_3,
SAFE_CAST(nivel_4 AS STRING) nivel_4,
SAFE_CAST(nivel_5 AS STRING) nivel_5,
SAFE_CAST(nivel_6 AS STRING) nivel_6,
SAFE_CAST(tipo_emissao AS STRING) tipo_emissao,
SAFE_CAST(gas AS STRING) gas,
SAFE_CAST(atividade_economica AS STRING) atividade_economica,
SAFE_CAST(produto AS STRING) produto,
SAFE_CAST(emissao AS FLOAT64) emissao
from basedosdados-dev.br_seeg_emissoes_staging.municipio as t