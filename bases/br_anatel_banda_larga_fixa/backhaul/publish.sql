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

CREATE VIEW input-dados.br_anatel_banda_larga_fixa.backhaul AS
SELECT 
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS INT64) id_municipio,
SAFE_CAST(situacao AS STRING) situacao,
SAFE_CAST(ano_atendimento AS STRING) ano_atendimento,
SAFE_CAST(concessionaria AS STRING) concessionaria,
SAFE_CAST(tecnologia AS STRING) tecnologia,
SAFE_CAST(capacidade_backhaul AS STRING) capacidade_backhaul,
SAFE_CAST(capacidade_ocupada AS STRING) capacidade_ocupada,
SAFE_CAST(capacidade_disponivel AS STRING) capacidade_disponivel
from input-dados.br_anatel_banda_larga_fixa_staging.backhaul as t