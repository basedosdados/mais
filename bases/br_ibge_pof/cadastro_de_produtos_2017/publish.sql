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

CREATE VIEW basedosdados-dev.br_ibge_pof.cadastro_de_produtos_2017 AS
SELECT 
SAFE_CAST(id_quadro AS STRING) id_quadro,
SAFE_CAST(id_codigo_5_bd AS STRING) id_codigo_5_bd,
SAFE_CAST(id_codigo_7_bd AS STRING) id_codigo_7_bd,
SAFE_CAST(v9001 AS STRING) v9001,
SAFE_CAST(descricao_do_produto AS STRING) descricao_do_produto,
SAFE_CAST(variavel_despesa AS STRING) variavel_despesa,
SAFE_CAST(nivel_0_despesa AS STRING) nivel_0_despesa,
SAFE_CAST(nivel_1_despesa AS STRING) nivel_1_despesa,
SAFE_CAST(nivel_2_despesa AS STRING) nivel_2_despesa,
SAFE_CAST(nivel_3_despesa AS STRING) nivel_3_despesa,
SAFE_CAST(nivel_4_despesa AS STRING) nivel_4_despesa,
SAFE_CAST(nivel_5_despesa AS STRING) nivel_5_despesa,
SAFE_CAST(nivel_0_rendimento AS STRING) nivel_0_rendimento,
SAFE_CAST(nivel_1_rendimento AS STRING) nivel_1_rendimento,
SAFE_CAST(nivel_2_rendimento AS STRING) nivel_2_rendimento,
SAFE_CAST(nivel_3_rendimento AS STRING) nivel_3_rendimento,
SAFE_CAST(nivel_0_alimentacao AS STRING) nivel_0_alimentacao,
SAFE_CAST(nivel_1_alimentacao AS STRING) nivel_1_alimentacao,
SAFE_CAST(nivel_2_alimentacao AS STRING) nivel_2_alimentacao,
SAFE_CAST(nivel_3_alimentacao AS STRING) nivel_3_alimentacao,
SAFE_CAST(nivel_1_aquisicao_alimentar AS STRING) nivel_1_aquisicao_alimentar,
SAFE_CAST(nivel_2_aquisicao_alimentar AS STRING) nivel_2_aquisicao_alimentar,
SAFE_CAST(nivel_3_aquisicao_alimentar AS STRING) nivel_3_aquisicao_alimentar,
SAFE_CAST(descricao_0_despesa AS STRING) descricao_0_despesa,
SAFE_CAST(descricao_1_despesa AS STRING) descricao_1_despesa,
SAFE_CAST(descricao_2_despesa AS STRING) descricao_2_despesa,
SAFE_CAST(descricao_3_despesa AS STRING) descricao_3_despesa,
SAFE_CAST(descricao_4_despesa AS STRING) descricao_4_despesa,
SAFE_CAST(descricao_5_despesa AS STRING) descricao_5_despesa,
SAFE_CAST(descricao_0_rendimento AS STRING) descricao_0_rendimento,
SAFE_CAST(descricao_1_rendimento AS STRING) descricao_1_rendimento,
SAFE_CAST(descricao_2_rendimento AS STRING) descricao_2_rendimento,
SAFE_CAST(descricao_3_rendimento AS STRING) descricao_3_rendimento,
SAFE_CAST(descricao_0_alimentacao AS STRING) descricao_0_alimentacao,
SAFE_CAST(descricao_1_alimentacao AS STRING) descricao_1_alimentacao,
SAFE_CAST(descricao_2_alimentacao AS STRING) descricao_2_alimentacao,
SAFE_CAST(descricao_3_alimentacao AS STRING) descricao_3_alimentacao,
SAFE_CAST(descricao_1_aquisicao_alimentar AS STRING) descricao_1_aquisicao_alimentar,
SAFE_CAST(descricao_2_aquisicao_alimentar AS STRING) descricao_2_aquisicao_alimentar,
SAFE_CAST(descricao_3_aquisicao_alimentar AS STRING) descricao_3_aquisicao_alimentar
FROM basedosdados-dev.br_ibge_pof_staging.cadastro_de_produtos_2017 AS t