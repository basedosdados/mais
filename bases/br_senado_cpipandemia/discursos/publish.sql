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

CREATE VIEW rfdornelles-bq.br_senado_cpipandemia.discursos AS
SELECT
SAFE_CAST(sequencial_sessao AS STRING) sequencial_sessao,
SAFE_CAST(data_sessao AS DATE) data_sessao,
SAFE_CAST(sigla_partido AS STRING) sigla_partido,
SAFE_CAST(sigla_uf_partido AS STRING) sigla_uf_partido,
SAFE_CAST(bloco_parlamentar AS STRING) bloco_parlamentar,
SAFE_CAST(nome_discursante AS STRING) nome_discursante,
SAFE_CAST(genero_discursante AS STRING) genero_discursante,
SAFE_CAST(categoria_discursante AS STRING) categoria_discursante,
SAFE_CAST(texto_discurso AS STRING) texto_discurso,
SAFE_CAST(horario_inicio_discurso AS TIME) horario_inicio_discurso,
SAFE_CAST(horario_fim_discurso AS TIME) horario_fim_discurso,
SAFE_CAST(duracao_discurso AS INT64) duracao_discurso,
SAFE_CAST(sinalizacao_pela_ordem AS STRING) sinalizacao_pela_ordem,
SAFE_CAST(sinalizacao_questao_ordem AS STRING) sinalizacao_questao_ordem,
SAFE_CAST(sinalizacao_fora_microfone AS STRING) sinalizacao_fora_microfone,
SAFE_CAST(sinalizacao_responder_questao_ordem AS STRING) sinalizacao_responder_questao_ordem,
SAFE_CAST(sinalizacao_por_videoconferencia AS STRING) sinalizacao_por_videoconferencia,
SAFE_CAST(sinalizacao_para_interpelar AS STRING) sinalizacao_para_interpelar,
SAFE_CAST(sinalizacao_para_expor AS STRING) sinalizacao_para_expor,
SAFE_CAST(sinalizacao_para_depor AS STRING) sinalizacao_para_depor,
SAFE_CAST(sinalizacao_como_presidente AS STRING) sinalizacao_como_presidente
from rfdornelles-bq.br_senado_cpipandemia_staging.discursos as t
