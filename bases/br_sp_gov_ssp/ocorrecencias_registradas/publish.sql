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
    - Para modificar tipos de colunas, basta substituir INT64 por outro tipo válido.
    - Exemplo: `SAFE_CAST(column_name AS NUMERIC) column_name`
    - Mais detalhes: https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types

*/

CREATE VIEW basedosdados-dev.br_sp_gov_ssp.ocorrecencias_registradas AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(id_estado AS INT64) id_estado,
SAFE_CAST(regiao_ssp AS STRING) regiao_ssp,
SAFE_CAST(homicidio_doloso AS INT64) homicidio_doloso,
SAFE_CAST(numero_de_vitimas_em_homicidio_doloso AS INT64) numero_de_vitimas_em_homicidio_doloso,
SAFE_CAST(homicidio_doloso_por_acidente_de_transito AS INT64) homicidio_doloso_por_acidente_de_transito,
SAFE_CAST(numero_de_vitimas_em_homicidio_doloso_por_acidente_de_transito AS INT64) numero_de_vitimas_em_homicidio_doloso_por_acidente_de_transito,
SAFE_CAST(homicidio_culposo_por_acidente_de_transito AS INT64) homicidio_culposo_por_acidente_de_transito,
SAFE_CAST(homicidio_culposo_outros AS INT64) homicidio_culposo_outros,
SAFE_CAST(tentativa_de_homicidio AS INT64) tentativa_de_homicidio,
SAFE_CAST(lesao_corporal_seguida_de_morte AS INT64) lesao_corporal_seguida_de_morte,
SAFE_CAST(lesao_corporal_dolosa AS INT64) lesao_corporal_dolosa,
SAFE_CAST(lesao_corporal_culposa_por_acidente_de_transito AS INT64) lesao_corporal_culposa_por_acidente_de_transito,
SAFE_CAST(lesao_corporal_culposa_outras AS INT64) lesao_corporal_culposa_outras,
SAFE_CAST(latrocinio AS INT64) latrocinio,
SAFE_CAST(numero_de_vitimas_em_latrocinio AS INT64) numero_de_vitimas_em_latrocinio,
SAFE_CAST(total_de_estupro AS INT64) total_de_estupro,
SAFE_CAST(estupro AS INT64) estupro,
SAFE_CAST(estupro_de_vulneravel AS INT64) estupro_de_vulneravel,
SAFE_CAST(total_de_roubo_outros AS INT64) total_de_roubo_outros,
SAFE_CAST(roubo_outros AS INT64) roubo_outros,
SAFE_CAST(roubo_de_veiculo AS INT64) roubo_de_veiculo,
SAFE_CAST(roubo_a_banco AS INT64) roubo_a_banco,
SAFE_CAST(roubo_de_carga AS INT64) roubo_de_carga,
SAFE_CAST(furto_outros AS INT64) furto_outros,
SAFE_CAST(furto_de_veiculo AS INT64) furto_de_veiculo
from basedosdados-dev.br_sp_gov_ssp_staging.ocorrecencias_registradas as t