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
CREATE VIEW basedosdados-dev.br_ms_vacinacao_covid19.microdados_vacinacao AS
SELECT
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_documento AS STRING) id_documento,
SAFE_CAST(id_paciente AS STRING) id_paciente,
SAFE_CAST(id_estabelecimento AS STRING) id_estabelecimento,
SAFE_CAST(grupo_atendimento AS STRING) grupo_atendimento,
SAFE_CAST(categoria AS STRING) categoria,
SAFE_CAST(lote AS STRING) lote,
SAFE_CAST(nome_fabricante AS STRING) nome_fabricante,
SAFE_CAST(referencia_fabricante AS STRING) referencia_fabricante,
SAFE_CAST(data_aplicacao AS DATE) data_aplicacao,
SAFE_CAST(dose AS STRING) dose,
SAFE_CAST(vacina AS STRING) vacina,
SAFE_CAST(data_importacao_rnds AS DATE) data_importacao_rnds,
SAFE_CAST(horario_importacao_rnds AS TIME) horario_importacao_rnds,
SAFE_CAST(sistema_origem AS STRING) sistema_origem
FROM basedosdados-dev.br_ms_vacinacao_covid19_staging.microdados_vacinacao AS t