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
CREATE VIEW basedosdados-dev.br_ms_vacinacao_covid19.microdados AS
SELECT 
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_documento AS STRING) id_documento,
SAFE_CAST(id_paciente AS STRING) id_paciente,
SAFE_CAST(idade_paciente AS INT64) idade_paciente,
SAFE_CAST(data_nascimento_paciente AS DATE) data_nascimento_paciente,
SAFE_CAST(sexo_paciente AS STRING) sexo_paciente,
SAFE_CAST(raca_cor_paciente AS STRING) raca_cor_paciente,
SAFE_CAST(id_municipio_endereco_paciente AS STRING) id_municipio_endereco_paciente,
SAFE_CAST(pais_endereco_paciente AS STRING) pais_endereco_paciente,
SAFE_CAST(cep_endereco_paciente AS STRING) cep_endereco_paciente,
SAFE_CAST(nacionalidade_paciente AS STRING) nacionalidade_paciente,
SAFE_CAST(id_estabelecimento AS STRING) id_estabelecimento,
SAFE_CAST(razao_social_estabelecimento AS STRING) razao_social_estabelecimento,
SAFE_CAST(nome_fantasia_estabelecimento AS STRING) nome_fantasia_estabelecimento,
SAFE_CAST(id_municipio_estabelecimento AS STRING) id_municipio_estabelecimento,
SAFE_CAST(grupo_atendimento_vacina AS STRING) grupo_atendimento_vacina,
SAFE_CAST(categoria_vacina AS STRING) categoria_vacina,
SAFE_CAST(lote_vacina AS STRING) lote_vacina,
SAFE_CAST(nome_fabricante_vacina AS STRING) nome_fabricante_vacina,
SAFE_CAST(referencia_fabricante_vacina AS STRING) referencia_fabricante_vacina,
SAFE_CAST(data_aplicacao_vacina AS DATE) data_aplicacao_vacina,
SAFE_CAST(dose_vacina AS STRING) dose_vacina,
SAFE_CAST(codigo_vacina AS STRING) codigo_vacina,
SAFE_CAST(data_importacao_rnds AS DATE) data_importacao_rnds,
SAFE_CAST(sistema_origem AS STRING) sistema_origem
from basedosdados-dev.br_ms_vacinacao_covid19_staging.microdados as t