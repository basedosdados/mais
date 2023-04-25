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

CREATE VIEW basedosdados-dev.br_bcb_sicor.recurso_publico_gleba AS
SELECT 
SAFE_CAST(id_referencia_bacen AS STRING) id_referencia_bacen,
SAFE_CAST(numero_ordem AS STRING) numero_ordem,
SAFE_CAST(numero_identificador_gleba AS STRING) numero_identificador_gleba,
SAFE_CAST(indice_indice_gleba AS STRING) indice_indice_gleba,
SAFE_CAST(indice_indice_ponto AS STRING) indice_indice_ponto,
SAFE_CAST(latitude AS FLOAT64) latitude,
SAFE_CAST(longitude AS FLOAT64) longitude,
SAFE_CAST(altitude AS FLOAT64) altitude
FROM basedosdados-dev.br_bcb_sicor_staging.recurso_publico_gleba AS t