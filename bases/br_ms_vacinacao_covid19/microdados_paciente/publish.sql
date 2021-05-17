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

CREATE VIEW basedosdados-dev.br_ms_vacinacao_covid19.microdados_paciente AS
SELECT 
SAFE_CAST(id_paciente AS STRING) id_paciente,
SAFE_CAST(idade AS STRING) idade,
SAFE_CAST(data_nascimento AS STRING) data_nascimento,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(raca_cor AS STRING) raca_cor,
SAFE_CAST(id_municipio_endereco AS STRING) id_municipio_endereco,
SAFE_CAST(pais_endereco AS STRING) pais_endereco,
SAFE_CAST(cep_endereco AS STRING) cep_endereco,
SAFE_CAST(nacionalidade AS STRING) nacionalidade,
SAFE_CAST(sigla_uf_endereco AS STRING) sigla_uf_endereco
from basedosdados-dev.br_ms_vacinacao_covid19_staging.microdados_paciente as t