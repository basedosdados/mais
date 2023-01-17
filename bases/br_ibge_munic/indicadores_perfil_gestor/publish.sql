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

CREATE VIEW basedosdados-dev.br_ibge_munic.indicadores_perfil_gestor AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(tema AS STRING) tema,
SAFE_CAST(recusa AS INT64) recusa,
SAFE_CAST(sem_gestor AS STRING) sem_gestor,
SAFE_CAST(caracterizacao_orgao_gestor AS STRING) caracterizacao_orgao_gestor,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(idade AS INT64) idade,
SAFE_CAST(cor_raca AS STRING) cor_raca,
SAFE_CAST(cor_raca_autodeclarado AS INT64) cor_raca_autodeclarado,
SAFE_CAST(escolaridade AS STRING) escolaridade,
SAFE_CAST(escolaridade_formacao AS STRING) escolaridade_formacao
FROM basedosdados-dev.br_ibge_munic_staging.indicadores_perfil_gestor AS t