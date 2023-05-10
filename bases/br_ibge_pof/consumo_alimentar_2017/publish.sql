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

CREATE VIEW basedosdados-dev.br_ibge_pof.consumo_alimentar_2017 AS
SELECT 
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(situacao AS STRING) situacao,
SAFE_CAST(id_estrato AS STRING) id_estrato,
SAFE_CAST(id_unidade_primaria_amostragem AS STRING) id_unidade_primaria_amostragem,
SAFE_CAST(id_domicilio AS STRING) id_domicilio,
SAFE_CAST(id_unidade_consumo AS STRING) id_unidade_consumo,
SAFE_CAST(id_informante AS STRING) id_informante,
SAFE_CAST(id_quadro AS STRING) id_quadro,
SAFE_CAST(id_codigo_5_bd AS STRING) id_codigo_5_bd,
SAFE_CAST(V9005 AS FLOAT64) V9005,
SAFE_CAST(V9007 AS STRING) V9007,
SAFE_CAST(V9001 AS STRING) V9001,
SAFE_CAST(V9015 AS STRING) V9015,
SAFE_CAST(V9016 AS STRING) V9016,
SAFE_CAST(V9017 AS STRING) V9017,
SAFE_CAST(V9018 AS STRING) V9018,
SAFE_CAST(V9019 AS INT64) V9019,
SAFE_CAST(V9020 AS INT64) V9020,
SAFE_CAST(V9021 AS INT64) V9021,
SAFE_CAST(V9022 AS INT64) V9022,
SAFE_CAST(V9023 AS INT64) V9023,
SAFE_CAST(V9024 AS INT64) V9024,
SAFE_CAST(V9025 AS INT64) V9025,
SAFE_CAST(V9026 AS INT64) V9026,
SAFE_CAST(V9027 AS INT64) V9027,
SAFE_CAST(V9028 AS INT64) V9028,
SAFE_CAST(V9029 AS INT64) V9029,
SAFE_CAST(V9030 AS INT64) V9030,
SAFE_CAST(codigo_unidade_medida AS STRING) codigo_unidade_medida,
SAFE_CAST(codigo_preparacao_final AS STRING) codigo_preparacao_final,
SAFE_CAST(gramatura_alimento AS FLOAT64) gramatura_alimento,
SAFE_CAST(quantidade_alimento AS FLOAT64) quantidade_alimento,
SAFE_CAST(codigo_alimento_tbca AS STRING) codigo_alimento_tbca,
SAFE_CAST(energia_kcal AS FLOAT64) energia_kcal,
SAFE_CAST(energia_kj AS FLOAT64) energia_kj,
SAFE_CAST(proteina AS FLOAT64) proteina,
SAFE_CAST(carboidratos AS FLOAT64) carboidratos,
SAFE_CAST(fibra AS FLOAT64) fibra,
SAFE_CAST(lipidios AS FLOAT64) lipidios,
SAFE_CAST(colesterol AS FLOAT64) colesterol,
SAFE_CAST(acidos_graxos_saturados AS FLOAT64) acidos_graxos_saturados,
SAFE_CAST(acidos_graxos_mono AS FLOAT64) acidos_graxos_mono,
SAFE_CAST(acidos_graxos_poli AS FLOAT64) acidos_graxos_poli,
SAFE_CAST(acidos_graxos_trans AS FLOAT64) acidos_graxos_trans,
SAFE_CAST(calcio AS FLOAT64) calcio,
SAFE_CAST(ferro AS FLOAT64) ferro,
SAFE_CAST(sodio AS FLOAT64) sodio,
SAFE_CAST(magnesio AS FLOAT64) magnesio,
SAFE_CAST(fosforo AS FLOAT64) fosforo,
SAFE_CAST(potassio AS FLOAT64) potassio,
SAFE_CAST(cobre AS FLOAT64) cobre,
SAFE_CAST(zinco AS FLOAT64) zinco,
SAFE_CAST(vitamina_a AS FLOAT64) vitamina_a,
SAFE_CAST(vitamina_b1 AS FLOAT64) vitamina_b1,
SAFE_CAST(vitamina_b2 AS FLOAT64) vitamina_b2,
SAFE_CAST(vitamina_b3 AS FLOAT64) vitamina_b3,
SAFE_CAST(vitamina_b6 AS FLOAT64) vitamina_b6,
SAFE_CAST(vitamina_b12 AS FLOAT64) vitamina_b12,
SAFE_CAST(vitamina_d AS FLOAT64) vitamina_d,
SAFE_CAST(vitamina_e AS FLOAT64) vitamina_e,
SAFE_CAST(vitamina_c AS FLOAT64) vitamina_c,
SAFE_CAST(folato AS FLOAT64) folato,
SAFE_CAST(dia_semana AS STRING) dia_semana,
SAFE_CAST(dia_atipico AS STRING) dia_atipico,
SAFE_CAST(peso AS FLOAT64) peso,
SAFE_CAST(peso_final AS FLOAT64) peso_final
FROM basedosdados-dev.br_ibge_pof_staging.consumo_alimentar_2017 AS t