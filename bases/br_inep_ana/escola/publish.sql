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

CREATE VIEW basedosdados-dev.br_inep_ana.escola AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(id_regiao AS STRING) id_regiao,
SAFE_CAST(id_uf AS STRING) id_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(tipo_area AS STRING) tipo_area,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(id_escola AS STRING) id_escola,
SAFE_CAST(tipo_localizacao AS STRING) tipo_localizacao,
SAFE_CAST(nivel_socio_economico AS STRING) nivel_socio_economico,
SAFE_CAST(formacao_docente_ef_anos_iniciais AS FLOAT64) formacao_docente_ef_anos_iniciais,
SAFE_CAST(numero_matriculados_censo AS INT64) numero_matriculados_censo,
SAFE_CAST(numero_presentes_lp AS INT64) numero_presentes_lp,
SAFE_CAST(numero_validos_lp AS INT64) numero_validos_lp,
SAFE_CAST(taxa_participacao_lp AS FLOAT64) taxa_participacao_lp,
SAFE_CAST(media_lp_leitura AS FLOAT64) media_lp_leitura,
SAFE_CAST(nivel_1_lp_leitura AS FLOAT64) nivel_1_lp_leitura,
SAFE_CAST(nivel_2_lp_leitura AS FLOAT64) nivel_2_lp_leitura,
SAFE_CAST(nivel_3_lp_leitura AS FLOAT64) nivel_3_lp_leitura,
SAFE_CAST(nivel_4_lp_leitura AS FLOAT64) nivel_4_lp_leitura,
SAFE_CAST(escola_similar_nivel_1_lp_leitura AS FLOAT64) escola_similar_nivel_1_lp_leitura,
SAFE_CAST(escola_similar_nivel_2_lp_leitura AS FLOAT64) escola_similar_nivel_2_lp_leitura,
SAFE_CAST(escola_similar_nivel_3_lp_leitura AS FLOAT64) escola_similar_nivel_3_lp_leitura,
SAFE_CAST(escola_similar_nivel_4_lp_leitura AS FLOAT64) escola_similar_nivel_4_lp_leitura,
SAFE_CAST(media_lp_escrita AS FLOAT64) media_lp_escrita,
SAFE_CAST(nivel_1_lp_escrita AS FLOAT64) nivel_1_lp_escrita,
SAFE_CAST(nivel_2_lp_escrita AS FLOAT64) nivel_2_lp_escrita,
SAFE_CAST(nivel_3_lp_escrita AS FLOAT64) nivel_3_lp_escrita,
SAFE_CAST(nivel_4_lp_escrita AS FLOAT64) nivel_4_lp_escrita,
SAFE_CAST(nivel_5_lp_escrita AS FLOAT64) nivel_5_lp_escrita,
SAFE_CAST(escola_similar_nivel_1_lp_escrita AS FLOAT64) escola_similar_nivel_1_lp_escrita,
SAFE_CAST(escola_similar_nivel_2_lp_escrita AS FLOAT64) escola_similar_nivel_2_lp_escrita,
SAFE_CAST(escola_similar_nivel_3_lp_escrita AS FLOAT64) escola_similar_nivel_3_lp_escrita,
SAFE_CAST(escola_similar_nivel_4_lp_escrita AS FLOAT64) escola_similar_nivel_4_lp_escrita,
SAFE_CAST(escola_similar_nivel_5_lp_escrita AS FLOAT64) escola_similar_nivel_5_lp_escrita,
SAFE_CAST(numero_presentes_mt AS INT64) numero_presentes_mt,
SAFE_CAST(numero_validos_mt AS INT64) numero_validos_mt,
SAFE_CAST(taxa_participacao_mt AS FLOAT64) taxa_participacao_mt,
SAFE_CAST(media_mt AS FLOAT64) media_mt,
SAFE_CAST(nivel_1_mt AS FLOAT64) nivel_1_mt,
SAFE_CAST(nivel_2_mt AS FLOAT64) nivel_2_mt,
SAFE_CAST(nivel_3_mt AS FLOAT64) nivel_3_mt,
SAFE_CAST(nivel_4_mt AS FLOAT64) nivel_4_mt,
SAFE_CAST(escola_similar_nivel_1_mt AS FLOAT64) escola_similar_nivel_1_mt,
SAFE_CAST(escola_similar_nivel_2_mt AS FLOAT64) escola_similar_nivel_2_mt,
SAFE_CAST(escola_similar_nivel_3_mt AS FLOAT64) escola_similar_nivel_3_mt,
SAFE_CAST(escola_similar_nivel_4_mt AS FLOAT64) escola_similar_nivel_4_mt
from basedosdados-dev.br_inep_ana_staging.escola as t