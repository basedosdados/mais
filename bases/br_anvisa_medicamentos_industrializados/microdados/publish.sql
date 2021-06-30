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
CREATE VIEW basedosdados-dev.br_anvisa_medicamentos_industrializados.microdados AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(principio_ativo AS STRING) principio_ativo,
SAFE_CAST(descricao_apresentacao AS STRING) descricao_apresentacao,
SAFE_CAST(qtde_vendida AS INT64) quantidade_vendida,
SAFE_CAST(unidade_medida AS STRING) unidade_medida,
SAFE_CAST(conselho_prescritor AS STRING) conselho_prescritor,
SAFE_CAST(sigla_uf_conselho_prescritor AS STRING) sigla_uf_conselho_prescritor,
SAFE_CAST(tipo_receituario AS INT64) tipo_receituario,
SAFE_CAST(cid10 AS STRING) cid10,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(idade AS INT64) idade,
SAFE_CAST(unidade_idade AS INT64) unidade_idade
from basedosdados-dev.br_anvisa_medicamentos_industrializados_staging.microdados as t