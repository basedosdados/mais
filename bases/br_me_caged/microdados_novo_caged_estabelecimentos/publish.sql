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

CREATE VIEW basedosdados.br_me_caged.microdados_novo_caged_estabelecimentos AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(id_municipio_6 AS INT64) id_municipio_6,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(cnae_20_classe AS STRING) cnae_20_classe,
SAFE_CAST(cnae_20_subclas AS INT64) cnae_20_subclas,
SAFE_CAST(admitidos AS INT64) admitidos,
SAFE_CAST(desligados AS INT64) desligados,
SAFE_CAST(fonte_desligamento AS INT64) fonte_desligamento,
SAFE_CAST(saldo_movimentacao AS INT64) saldo_movimentacao,
SAFE_CAST(tipo_empregador AS INT64) tipo_empregador,
SAFE_CAST(tipo_estab AS INT64) tipo_estab,
SAFE_CAST(faixa_empr_inicio_jan AS INT64) faixa_empr_inicio_jan
from basedosdados-staging.br_me_caged_staging.microdados_novo_caged_estabelecimentos as t
