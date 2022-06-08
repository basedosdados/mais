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
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(populacao_urbana_2013 AS INT64) populacao_urbana_2013,
SAFE_CAST(populacao_urbana_2035 AS INT64) populacao_urbana_2035,
SAFE_CAST(prestador_servico_esgotamento_sanitario AS STRING) prestador_servico_esgotamento_sanitario,
SAFE_CAST(sigla_prestador AS STRING) sigla_prestador,
SAFE_CAST(indice_sem_atendimento_sem_coleta_sem_tratamento AS FLOAT64) indice_sem_atendimento_sem_coleta_sem_tratamento,
SAFE_CAST(indice_atendimento_solucao_individual AS FLOAT64) indice_atendimento_solucao_individual,
SAFE_CAST(indice_atendimento_com_coleta_sem_tratamento AS FLOAT64) indice_atendimento_com_coleta_sem_tratamento,
SAFE_CAST(indice_atendimento_com_coleta_com_tratamento AS FLOAT64) indice_atendimento_com_coleta_com_tratamento,
SAFE_CAST(vazao_sem_coleta_sem_tratamento AS FLOAT64) vazao_sem_coleta_sem_tratamento,
SAFE_CAST(vazao_solucao_individual AS FLOAT64) vazao_solucao_individual,
SAFE_CAST(vazao_com_coleta_sem_tratamento AS FLOAT64) vazao_com_coleta_sem_tratamento,
SAFE_CAST(vazao_com_coleta_com_tratamento AS FLOAT64) vazao_com_coleta_com_tratamento,
SAFE_CAST(vazao_total AS FLOAT64) vazao_total,
SAFE_CAST(carga_gerada_sem_coleta_sem_tratamento AS FLOAT64) carga_gerada_sem_coleta_sem_tratamento,
SAFE_CAST(carga_gerada_encaminhada_solucao_individual AS FLOAT64) carga_gerada_encaminhada_solucao_individual,
SAFE_CAST(carga_gerada_com_coleta_sem_tratamento AS FLOAT64) carga_gerada_com_coleta_sem_tratamento,
SAFE_CAST(carga_gerada_com_coleta_com_tratamento AS FLOAT64) carga_gerada_com_coleta_com_tratamento,
SAFE_CAST(carga_gerada_total AS FLOAT64) carga_gerada_total,
SAFE_CAST(carga_lancada_sem_coleta_sem_tratamento AS FLOAT64) carga_lancada_sem_coleta_sem_tratamento,
SAFE_CAST(carga_lancada_proveniente_solucao_individual AS FLOAT64) carga_lancada_proveniente_solucao_individual,
SAFE_CAST(carga_lancada_com_coleta_sem_tratamento AS FLOAT64) carga_lancada_com_coleta_sem_tratamento,
SAFE_CAST(carga_lancada_com_coleta_com_tratamento AS FLOAT64) carga_lancada_com_coleta_com_tratamento,
SAFE_CAST(carga_lancada_total AS FLOAT64) carga_lancada_total,
SAFE_CAST(indice_atendimento_etes_2035 AS FLOAT64) indice_atendimento_etes_2035,
SAFE_CAST(indice_atendimento_solucao_individual_2035 AS FLOAT64) indice_atendimento_solucao_individual_2035,
SAFE_CAST(carga_gerada_total_2035 AS FLOAT64) carga_gerada_total_2035,
SAFE_CAST(carga_afluente_ete_2035 AS FLOAT64) carga_afluente_ete_2035,
SAFE_CAST(carga_efluente_ete_2035 AS FLOAT64) carga_efluente_ete_2035,
SAFE_CAST(carga_afluente_solucao_individual_2035 AS FLOAT64) carga_afluente_solucao_individual_2035,
SAFE_CAST(carga_efluente_solucao_individual_2035 AS FLOAT64) carga_efluente_solucao_individual_2035,
SAFE_CAST(populacao_atendida_2035 AS INT64) populacao_atendida_2035,
SAFE_CAST(investimento_coleta AS FLOAT64) investimento_coleta,
SAFE_CAST(investimento_tratamento AS FLOAT64) investimento_tratamento,
SAFE_CAST(investimento_coleta_tratatamento AS FLOAT64) investimento_coleta_tratatamento,
SAFE_CAST(necessidade_remocao_dbo AS STRING) necessidade_remocao_dbo,
SAFE_CAST(tipologia_solucao AS STRING) tipologia_solucao,
SAFE_CAST(atencao_fosforo AS STRING) atencao_fosforo,
SAFE_CAST(atencao_nitrogenio AS STRING) atencao_nitrogenio
FROM basedosdados-dev.br_ana_atlas_esgotos_staging.municipio AS t