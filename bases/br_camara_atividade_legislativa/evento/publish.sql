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

CREATE VIEW basedosdados-364117.br_camara_atividade_legislativa.evento AS
SELECT 
SAFE_CAST(id_evento AS STRING) id_evento,
SAFE_CAST(data_inicio AS DATE) data_inicio,
SAFE_CAST(hora_inicio AS TIME) hora_inicio,
SAFE_CAST(data_fim AS DATE) data_fim,
SAFE_CAST(hora_fim AS TIME) hora_fim,
SAFE_CAST(link_pauta AS STRING) link_pauta,
SAFE_CAST(descricao AS STRING) descricao,
SAFE_CAST(situacao AS STRING) situacao,
SAFE_CAST(tipo AS STRING) tipo,
SAFE_CAST(externo AS INT64) externo,
SAFE_CAST(local AS STRING) local
FROM basedosdados-364117.br_camara_atividade_legislativa_staging.evento AS t