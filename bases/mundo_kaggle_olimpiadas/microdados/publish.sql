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

CREATE VIEW input-dados.mundo_kaggle_olimpiadas.microdados AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(edicao AS STRING) edicao,
SAFE_CAST(cidade_sede AS STRING) cidade_sede,
SAFE_CAST(pais AS STRING) pais,
SAFE_CAST(delegacao AS STRING) delegacao,
SAFE_CAST(equipe AS STRING) equipe,
SAFE_CAST(id_atleta AS STRING) id_atleta,
SAFE_CAST(nome_atleta AS STRING) nome_atleta,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(idade AS INT64) idade,
SAFE_CAST(altura AS INT64) altura,
SAFE_CAST(peso AS INT64) peso,
SAFE_CAST(esporte AS STRING) esporte,
SAFE_CAST(evento AS STRING) evento,
SAFE_CAST(medalha AS STRING) medalha
from input-dados.mundo_kaggle_olimpiadas_staging.microdados as t