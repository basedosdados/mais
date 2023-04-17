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

CREATE VIEW basedosdados-dev.br_rj_isp_estatisticas_seguranca.taxa_letalidade AS
SELECT 
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(regiao AS STRING) regiao,
SAFE_CAST(delito AS STRING) delito,
SAFE_CAST(contagem_delito AS STRING) contagem_delito,
SAFE_CAST(populacao AS STRING) populacao,
SAFE_CAST(taxa_cem_mil_habitantes AS STRING) taxa_cem_mil_habitantes
FROM basedosdados-dev.br_rj_isp_estatisticas_seguranca_staging.taxa_letalidade AS t