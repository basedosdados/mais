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

CREATE VIEW basedosdados-dev.br_inep_indicadores_educacionais.uf_remuneracao_docentes AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(rede AS STRING) rede,
SAFE_CAST(escolaridade AS STRING) escolaridade,
SAFE_CAST(numero_docentes AS INT64) numero_docentes,
SAFE_CAST(prop_docentes_rais AS FLOAT64) prop_docentes_rais,
SAFE_CAST(rem_bruta_rais_1_quartil AS FLOAT64) rem_bruta_rais_1_quartil,
SAFE_CAST(rem_bruta_rais_mediana AS FLOAT64) rem_bruta_rais_mediana,
SAFE_CAST(rem_bruta_rais_media AS FLOAT64) rem_bruta_rais_media,
SAFE_CAST(rem_bruta_rais_3_quartil AS FLOAT64) rem_bruta_rais_3_quartil,
SAFE_CAST(rem_bruta_rais_desvio_padrao AS FLOAT64) rem_bruta_rais_desvio_padrao,
SAFE_CAST(carga_horaria_media_semanal AS FLOAT64) carga_horaria_media_semanal,
SAFE_CAST(rem_media_40_horas_semanais AS FLOAT64) rem_media_40_horas_semanais
from basedosdados-dev.br_inep_indicadores_educacionais_staging.uf_remuneracao_docentes as t