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

CREATE VIEW basedosdados-dev.br_bd_diretorios_brasil.instituicao_ensino_superior AS
SELECT 
SAFE_CAST(id_ies AS STRING) id_ies,
SAFE_CAST(nome_ies AS STRING) nome_ies,
SAFE_CAST(tipo_instituicao AS STRING) tipo_instituicao,
SAFE_CAST(id_rede_ies AS STRING) id_rede_ies,
SAFE_CAST(rede_ies AS STRING) rede_ies,
SAFE_CAST(situacao_funcionamento AS STRING) situacao_funcionamento,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(sigla_uf AS STRING) sigla_uf
from basedosdados-dev.br_bd_diretorios_brasil_staging.instituicao_ensino_superior as t