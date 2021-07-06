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

CREATE VIEW basedosdados-dev.br_ana_atlas_esgotos.municipio AS
SELECT 
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(populacao_urbana_2013 AS INT64) populacao_urbana_2013,
SAFE_CAST(populacao_urbana_2035 AS INT64) populacao_urbana_2035,
SAFE_CAST(prestador_servico_esgoto AS STRING) prestador_servico_esgoto,
SAFE_CAST(sigla_prestador AS STRING) sigla_prestador,
SAFE_CAST(indice_sem_atend AS FLOAT64) indice_sem_atend,
SAFE_CAST(indice_atend_solucao_ind AS FLOAT64) indice_atend_solucao_ind,
SAFE_CAST(indice_atend_col_sem_trat AS FLOAT64) indice_atend_col_sem_trat,
SAFE_CAST(indice_atend_col_trat AS FLOAT64) indice_atend_col_trat,
SAFE_CAST(vazao_sem_col_sem_trat AS FLOAT64) vazao_sem_col_sem_trat,
SAFE_CAST(vazao_solucao_ind AS FLOAT64) vazao_solucao_ind,
SAFE_CAST(vazao_col_sem_trat AS FLOAT64) vazao_col_sem_trat,
SAFE_CAST(vazao_col_trat AS FLOAT64) vazao_col_trat,
SAFE_CAST(vazao_total AS FLOAT64) vazao_total,
SAFE_CAST(parcela_carga_sem_col_sem_trat AS FLOAT64) parcela_carga_sem_col_sem_trat,
SAFE_CAST(parcela_carga_solucao_ind AS FLOAT64) parcela_carga_solucao_ind,
SAFE_CAST(parcela_carga_col_sem_trat AS FLOAT64) parcela_carga_col_sem_trat,
SAFE_CAST(parcela_carga_col_trat AS FLOAT64) parcela_carga_col_trat,
SAFE_CAST(carga_gerada AS FLOAT64) carga_gerada,
SAFE_CAST(carga_lancada_sem_col_sem_trat AS FLOAT64) carga_lancada_sem_col_sem_trat,
SAFE_CAST(carga_lancada_solucao_ind AS FLOAT64) carga_lancada_solucao_ind,
SAFE_CAST(carga_lancada_col_sem_trat AS FLOAT64) carga_lancada_col_sem_trat,
SAFE_CAST(carga_lancada_col_trat AS FLOAT64) carga_lancada_col_trat,
SAFE_CAST(carga_lancada AS FLOAT64) carga_lancada,
SAFE_CAST(indice_atend_etes_avaliado_2035 AS FLOAT64) indice_atend_etes_avaliado_2035,
SAFE_CAST(indice_atend_solucao_ind_2035 AS FLOAT64) indice_atend_solucao_ind_2035,
SAFE_CAST(carga_gerada_2035 AS FLOAT64) carga_gerada_2035,
SAFE_CAST(carga_afluente_ete_2035 AS FLOAT64) carga_afluente_ete_2035,
SAFE_CAST(carga_efluente_ete_2035 AS FLOAT64) carga_efluente_ete_2035,
SAFE_CAST(carga_afluente_solucao_ind_2035 AS FLOAT64) carga_afluente_solucao_ind_2035,
SAFE_CAST(carga_efluente_solucao_ind_2035 AS FLOAT64) carga_efluente_solucao_ind_2035,
SAFE_CAST(populacao_atendida_2035 AS INT64) populacao_atendida_2035,
SAFE_CAST(investimento_col AS FLOAT64) investimento_col,
SAFE_CAST(investimento_trat AS FLOAT64) investimento_trat,
SAFE_CAST(investimento_col_trat AS FLOAT64) investimento_col_trat,
SAFE_CAST(necessidade_remocao_dbo AS STRING) necessidade_remocao_dbo,
SAFE_CAST(tipologia_solucao AS STRING) tipologia_solucao,
SAFE_CAST(atencao_fosforo AS STRING) atencao_fosforo,
SAFE_CAST(atencao_nitrogenio AS STRING) atencao_nitrogenio
from basedosdados-dev.br_ana_atlas_esgotos_staging.municipio as t