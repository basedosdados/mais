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

CREATE VIEW basedosdados-dev.br_me_caged.microdados_estabelecimentos AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_municipio_6 AS STRING) id_municipio_6,
SAFE_CAST(cnae_2 AS STRING) cnae_2,
SAFE_CAST(cnae_2_subclasse AS STRING) cnae_2_subclasse,
SAFE_CAST(admitidos AS INT64) admitidos,
SAFE_CAST(desligados AS INT64) desligados,
SAFE_CAST(fonte_desligamento AS STRING) fonte_desligamento,
SAFE_CAST(saldo_movimentacao AS INT64) saldo_movimentacao,
SAFE_CAST(tipo_empregador AS STRING) tipo_empregador,
SAFE_CAST(tipo_estabelecimento AS STRING) tipo_estabelecimento,
SAFE_CAST(tamanho_estabelecimento_janeiro AS STRING) tamanho_estabelecimento_janeiro
from basedosdados-dev.br_me_caged_staging.microdados_estabelecimentos as t