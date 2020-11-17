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
CREATE VIEW basedosdados.br_camara_atividade_legislativa.orgaos AS
SELECT 
SAFE_CAST(id_orgao AS STRING) id_orgao,
SAFE_CAST(sigla AS STRING) sigla,
SAFE_CAST(apelido AS STRING) apelido,
SAFE_CAST(nome AS STRING) nome,
SAFE_CAST(cod_tipo_orgao AS STRING) cod_tipo_orgao,
SAFE_CAST(tipo_orgao AS STRING) tipo_orgao,
SAFE_CAST(casa AS STRING) casa,
SAFE_CAST(sala AS STRING) sala,
SAFE_CAST(cod_situacao AS STRING) cod_situacao,
SAFE_CAST(descricao_situacao AS STRING) descricao_situacao,
SAFE_CAST(data_inicio AS STRING) data_inicio,
SAFE_CAST(data_instalacao AS STRING) data_instalacao,
SAFE_CAST(data_fim AS STRING) data_fim,
SAFE_CAST(uri AS STRING) uri,
SAFE_CAST(capture_date AS STRING) capture_date
from `gabinete-compartilhado.views_publicos.br_legislativo_camara_orgaos` as t