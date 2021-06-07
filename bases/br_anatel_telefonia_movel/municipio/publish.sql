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

CREATE VIEW input-dados.br_anatel_telefonia_movel.municipio AS
SELECT 
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(mes AS STRING) mes,
SAFE_CAST(empresa AS STRING) empresa,
SAFE_CAST(cnpj AS STRING) cnpj,
SAFE_CAST(porte_empresa AS STRING) porte_empresa,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(ddd AS STRING) ddd,
SAFE_CAST(modalidade AS STRING) modalidade,
SAFE_CAST(tecnologia AS STRING) tecnologia,
SAFE_CAST(sinal AS STRING) sinal,
SAFE_CAST(pessoa AS STRING) pessoa,
SAFE_CAST(produto AS STRING) produto,
SAFE_CAST(acessos AS STRING) acessos
from input-dados.br_anatel_telefonia_movel_staging.municipio as t