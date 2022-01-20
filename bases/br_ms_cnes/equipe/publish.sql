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

CREATE VIEW basedosdados-dev.br_ms_cnes.equipe AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_municipio_6 AS STRING) id_municipio_6,
SAFE_CAST(id_estabelecimento_cnes AS STRING) id_estabelecimento_cnes,
SAFE_CAST(natureza_juridica AS STRING) natureza_juridica,
SAFE_CAST(id_equipe AS STRING) id_equipe,
SAFE_CAST(tipo_equipe AS STRING) tipo_equipe,
SAFE_CAST(equipe AS STRING) equipe,
SAFE_CAST(area_equipe AS STRING) area_equipe,
SAFE_CAST(area AS STRING) area,
SAFE_CAST(segmento AS STRING) segmento,
SAFE_CAST(descricao_segmento AS STRING) descricao_segmento,
SAFE_CAST(tipo_segmento AS STRING) tipo_segmento,
SAFE_CAST(ano_ativacao_equipe AS INT64) ano_ativacao_equipe,
SAFE_CAST(mes_ativacao_equipe AS INT64) mes_ativacao_equipe,
SAFE_CAST(motivo_desativacao_equipe AS STRING) motivo_desativacao_equipe,
SAFE_CAST(tipo_desativacao_equipe AS STRING) tipo_desativacao_equipe,
SAFE_CAST(ano_desativacao_equipe AS INT64) ano_desativacao_equipe,
SAFE_CAST(mes_desativacao_equipe AS INT64) mes_desativacao_equipe,
SAFE_CAST(atende_populacao_assistida_quilombolas AS STRING) atende_populacao_assistida_quilombolas,
SAFE_CAST(atende_populacao_assistida_assentados AS STRING) atende_populacao_assistida_assentados,
SAFE_CAST(atende_populacao_assistida_geral AS STRING) atende_populacao_assistida_geral,
SAFE_CAST(atende_populacao_assistida_escolares AS STRING) atende_populacao_assistida_escolares,
SAFE_CAST(atende_populacao_assistida_indigena AS STRING) atende_populacao_assistida_indigena,
SAFE_CAST(atende_populacao_assistida_pronasci AS STRING) atende_populacao_assistida_pronasci
FROM basedosdados-dev.br_ms_cnes_staging.equipe AS t