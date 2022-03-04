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

CREATE VIEW basedosdados-dev.br_ms_imunizacoes.municipio AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(doses_total AS INT64) doses_total,
SAFE_CAST(cobertura_total AS FLOAT64) cobertura_total,
SAFE_CAST(doses_bcg AS INT64) doses_bcg,
SAFE_CAST(cobertura_bcg AS FLOAT64) cobertura_bcg,
SAFE_CAST(doses_dtp AS INT64) doses_dtp,
SAFE_CAST(cobertura_dtp AS FLOAT64) cobertura_dtp,
SAFE_CAST(doses_dtp_ref AS INT64) doses_dtp_ref,
SAFE_CAST(cobertura_dtp_ref AS FLOAT64) cobertura_dtp_ref,
SAFE_CAST(doses_dtpa_gestante AS INT64) doses_dtpa_gestante,
SAFE_CAST(cobertura_dtpa_gestante AS FLOAT64) cobertura_dtpa_gestante,
SAFE_CAST(doses_duplo_adulto_dtpa_gestante AS INT64) doses_duplo_adulto_dtpa_gestante,
SAFE_CAST(cobertura_duplo_adulto_dtpa_gestante AS FLOAT64) cobertura_duplo_adulto_dtpa_gestante,
SAFE_CAST(doses_febre_amarela AS INT64) doses_febre_amarela,
SAFE_CAST(cobertura_febre_amarela AS FLOAT64) cobertura_febre_amarela,
SAFE_CAST(doses_haemophilus_influenza_b AS INT64) doses_haemophilus_influenza_b,
SAFE_CAST(cobertura_haemophilus_influenza_b AS FLOAT64) cobertura_haemophilus_influenza_b,
SAFE_CAST(doses_hepatite_a AS INT64) doses_hepatite_a,
SAFE_CAST(cobertura_hepatite_a AS FLOAT64) cobertura_hepatite_a,
SAFE_CAST(doses_hepatite_b AS INT64) doses_hepatite_b,
SAFE_CAST(cobertura_hepatite_b AS FLOAT64) cobertura_hepatite_b,
SAFE_CAST(doses_hepatite_b_rn AS INT64) doses_hepatite_b_rn,
SAFE_CAST(cobertura_hepatite_b_rn AS FLOAT64) cobertura_hepatite_b_rn,
SAFE_CAST(doses_meningococo AS INT64) doses_meningococo,
SAFE_CAST(cobertura_meningococo AS FLOAT64) cobertura_meningococo,
SAFE_CAST(doses_meningococo_ref1 AS INT64) doses_meningococo_ref1,
SAFE_CAST(cobertura_meningococo_ref1 AS FLOAT64) cobertura_meningococo_ref1,
SAFE_CAST(doses_penta AS INT64) doses_penta,
SAFE_CAST(cobertura_penta AS FLOAT64) cobertura_penta,
SAFE_CAST(doses_pneumococica AS INT64) doses_pneumococica,
SAFE_CAST(cobertura_pneumococica AS FLOAT64) cobertura_pneumococica,
SAFE_CAST(doses_pneumococica_ref1 AS INT64) doses_pneumococica_ref1,
SAFE_CAST(cobertura_pneumococica_ref1 AS FLOAT64) cobertura_pneumococica_ref1,
SAFE_CAST(doses_poliomielite AS INT64) doses_poliomielite,
SAFE_CAST(cobertura_poliomielite AS FLOAT64) cobertura_poliomielite,
SAFE_CAST(doses_poliomielite_4anos AS INT64) doses_poliomielite_4anos,
SAFE_CAST(cobertura_poliomielite_4anos AS FLOAT64) cobertura_poliomielite_4anos,
SAFE_CAST(doses_poliomielite_ref1 AS INT64) doses_poliomielite_ref1,
SAFE_CAST(cobertura_poliomielite_ref1 AS FLOAT64) cobertura_poliomielite_ref1,
SAFE_CAST(doses_rotavirus AS INT64) doses_rotavirus,
SAFE_CAST(cobertura_rotavirus AS FLOAT64) cobertura_rotavirus,
SAFE_CAST(doses_sarampo AS INT64) doses_sarampo,
SAFE_CAST(cobertura_sarampo AS FLOAT64) cobertura_sarampo,
SAFE_CAST(doses_tetra_viral AS INT64) doses_tetra_viral,
SAFE_CAST(cobertura_tetra_viral AS FLOAT64) cobertura_tetra_viral,
SAFE_CAST(doses_tetravalente AS INT64) doses_tetravalente,
SAFE_CAST(cobertura_tetravalente AS FLOAT64) cobertura_tetravalente,
SAFE_CAST(doses_triplice_bacteriana AS INT64) doses_triplice_bacteriana,
SAFE_CAST(cobertura_triplice_bacteriana AS FLOAT64) cobertura_triplice_bacteriana,
SAFE_CAST(doses_triplice_viral_d1 AS INT64) doses_triplice_viral_d1,
SAFE_CAST(cobertura_triplice_viral_d1 AS FLOAT64) cobertura_triplice_viral_d1,
SAFE_CAST(doses_triplice_viral_d2 AS INT64) doses_triplice_viral_d2,
SAFE_CAST(cobertura_triplice_viral_d2 AS FLOAT64) cobertura_triplice_viral_d2,
SAFE_CAST(doses_ignorado AS INT64) doses_ignorado,
SAFE_CAST(cobertura_ignorado AS FLOAT64) cobertura_ignorado
from basedosdados-dev.br_ms_imunizacoes_staging.municipio as t