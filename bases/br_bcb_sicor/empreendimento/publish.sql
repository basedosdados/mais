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

CREATE VIEW basedosdados-dev.br_bcb_sicor.empreendimento AS
SELECT 
SAFE_CAST(id_empreendimento AS STRING) id_empreendimento,
SAFE_CAST(data_inicio_empreendimento AS DATE) data_inicio_empreendimento,
SAFE_CAST(data_fim_empreendimento AS DATE) data_fim_empreendimento,
SAFE_CAST(finalidade AS STRING) finalidade,
SAFE_CAST(atividade AS STRING) atividade,
SAFE_CAST(modalidade AS STRING) modalidade,
SAFE_CAST(produto AS STRING) produto,
SAFE_CAST(variedade AS STRING) variedade,
SAFE_CAST(cesta_safra AS STRING) cesta_safra,
SAFE_CAST(zoneamento AS STRING) zoneamento,
SAFE_CAST(unidade_medida AS STRING) unidade_medida,
SAFE_CAST(unidade_medida_previsao_producao AS STRING) unidade_medida_previsao_producao,
SAFE_CAST(consorcio AS STRING) consorcio,
SAFE_CAST(cedula_mae AS STRING) cedula_mae,
SAFE_CAST(id_tipo_cultura AS STRING) id_tipo_cultura
FROM basedosdados-dev.br_bcb_sicor_staging.empreendimento AS t