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

CREATE VIEW basedosdados-dev.br_inep_indicadores_educacionais.fluxo_educacao_superior AS
SELECT 
SAFE_CAST(id_ies AS INT64) id_ies,
SAFE_CAST(nome_ies AS STRING) nome_ies,
SAFE_CAST(tipo_categoria_administrativa AS INT64) tipo_categoria_administrativa,
SAFE_CAST(tipo_organizacao AS INT64) tipo_organizacao,
SAFE_CAST(id_curso AS INT64) id_curso,
SAFE_CAST(nome_curso AS STRING) nome_curso,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(tipo_grau_academico AS INT64) tipo_grau_academico,
SAFE_CAST(tipo_modalidade AS INT64) tipo_modalidade,
SAFE_CAST(id_cine_rotulo AS INT64) id_cine_rotulo,
SAFE_CAST(nome_cine_rotulo AS STRING) nome_cine_rotulo,
SAFE_CAST(id_cine_area_geral AS INT64) id_cine_area_geral,
SAFE_CAST(nome_cine_area_geral AS STRING) nome_cine_area_geral,
SAFE_CAST(ano_ingresso AS INT64) ano_ingresso,
SAFE_CAST(ano_referencia AS INT64) ano_referencia,
SAFE_CAST(prazo_integralizacao AS INT64) prazo_integralizacao,
SAFE_CAST(ano_integralizacao AS INT64) ano_integralizacao,
SAFE_CAST(prazo_acompanhamento AS INT64) prazo_acompanhamento,
SAFE_CAST(ano_max_acompanhamento AS INT64) ano_max_acompanhamento,
SAFE_CAST(quantidade_ingressante AS INT64) quantidade_ingressante,
SAFE_CAST(quantidade_permanencia AS INT64) quantidade_permanencia,
SAFE_CAST(quantidade_concluinte AS INT64) quantidade_concluinte,
SAFE_CAST(quantidade_desistencia AS INT64) quantidade_desistencia,
SAFE_CAST(quantidade_falecido AS INT64) quantidade_falecido,
SAFE_CAST(tap AS FLOAT64) tap,
SAFE_CAST(tca AS FLOAT64) tca,
SAFE_CAST(tda AS FLOAT64) tda,
SAFE_CAST(tcan AS FLOAT64) tcan,
SAFE_CAST(tada AS FLOAT64) tada
from basedosdados-dev.br_inep_indicadores_educacionais_staging.fluxo_educacao_superior as t