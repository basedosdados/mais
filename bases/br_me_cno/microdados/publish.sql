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

CREATE VIEW basedosdados-dev.br_me_cno.microdados AS
SELECT 
SAFE_CAST(id_pais AS STRING) id_pais,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(id_municipio_rf AS STRING) id_municipio_rf,
SAFE_CAST(cep AS STRING) cep,
SAFE_CAST(id_cno AS STRING) id_cno,
SAFE_CAST(id_cno_vinculado AS STRING) id_cno_vinculado,
SAFE_CAST(data_registro AS DATE) data_registro,
SAFE_CAST(data_inicio AS DATE) data_inicio,
SAFE_CAST(data_inicio_responsabilidade AS DATE) data_inicio_responsabilidade,
SAFE_CAST(situacao AS STRING) situacao,
SAFE_CAST(data_situacao AS DATE) data_situacao,
SAFE_CAST(tipo_logradouro AS STRING) tipo_logradouro,
SAFE_CAST(logradouro AS STRING) logradouro,
SAFE_CAST(numero_logradouro AS STRING) numero_logradouro,
SAFE_CAST(bairro AS STRING) bairro,
SAFE_CAST(caixa_postal AS STRING) caixa_postal,
SAFE_CAST(complemento AS STRING) complemento,
SAFE_CAST(ni_responsavel AS STRING) ni_responsavel,
SAFE_CAST(qualificacao_responsavel AS STRING) qualificacao_responsavel,
SAFE_CAST(nome_responsavel AS STRING) nome_responsavel,
SAFE_CAST(nome_empresarial AS STRING) nome_empresarial,
SAFE_CAST(unidade_medida AS STRING) unidade_medida,
SAFE_CAST(area AS STRING) area
from basedosdados-dev.br_me_cno_staging.microdados as t