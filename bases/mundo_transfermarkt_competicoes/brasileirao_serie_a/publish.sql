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
CREATE VIEW basedosdados-dev.mundo_transfermarkt_competicoes.brasileirao_serie_a AS
SELECT 
SAFE_CAST(ano_campeonato AS INT64) ano_campeonato,
SAFE_CAST(data AS DATE) data,
SAFE_CAST(horario AS STRING) horario,
SAFE_CAST(rodada AS INT64) rodada,
SAFE_CAST(estadio AS STRING) estadio,
SAFE_CAST(arbitro AS STRING) arbitro,
SAFE_CAST(publico AS INT64) publico,
SAFE_CAST(publico_max AS INT64) publico_max,
SAFE_CAST(time_man AS STRING) time_man,
SAFE_CAST(time_vis AS STRING) time_vis,
SAFE_CAST(tecnico_man AS STRING) tecnico_man,
SAFE_CAST(tecnico_vis AS STRING) tecnico_vis,
SAFE_CAST(colocacao_man AS INT64) colocacao_man,
SAFE_CAST(colocacao_vis AS INT64) colocacao_vis,
SAFE_CAST(valor_equipe_titular_man AS INT64) valor_equipe_titular_man,
SAFE_CAST(valor_equipe_titular_vis AS INT64) valor_equipe_titular_vis,
SAFE_CAST(idade_media_titular_man AS FLOAT64) idade_media_titular_man,
SAFE_CAST(idade_media_titular_vis AS FLOAT64) idade_media_titular_vis,
SAFE_CAST(gols_man AS INT64) gols_man,
SAFE_CAST(gols_vis AS INT64) gols_vis,
SAFE_CAST(gols_1_tempo_man AS INT64) gols_1_tempo_man,
SAFE_CAST(gols_1_tempo_vis AS INT64) gols_1_tempo_vis,
SAFE_CAST(escanteios_man AS INT64) escanteios_man,
SAFE_CAST(escanteios_vis AS INT64) escanteios_vis,
SAFE_CAST(faltas_man AS INT64) faltas_man,
SAFE_CAST(faltas_vis AS INT64) faltas_vis,
SAFE_CAST(chutes_bola_parada_man AS INT64) chutes_bola_parada_man,
SAFE_CAST(chutes_bola_parada_vis AS INT64) chutes_bola_parada_vis,
SAFE_CAST(defesas_man AS INT64) defesas_man,
SAFE_CAST(defesas_vis AS INT64) defesas_vis,
SAFE_CAST(impedimentos_man AS INT64) impedimentos_man,
SAFE_CAST(impedimentos_vis AS INT64) impedimentos_vis,
SAFE_CAST(chutes_man AS INT64) chutes_man,
SAFE_CAST(chutes_vis AS INT64) chutes_vis,
SAFE_CAST(chutes_fora_man AS INT64) chutes_fora_man,
SAFE_CAST(chutes_fora_vis AS INT64) chutes_fora_vis
FROM basedosdados-dev.mundo_transfermarkt_competicoes_staging.brasileirao_serie_a AS t