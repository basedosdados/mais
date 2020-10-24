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
SELECT 
SAFE_CAST(CNPJ AS STRING) CNPJ,
SAFE_CAST(identificador_de_socio AS INT64) identificador_de_socio,
SAFE_CAST(nome_socio AS STRING) nome_socio,
SAFE_CAST(CNPJ_CPF_do_socio AS STRING) CNPJ_CPF_do_socio,
SAFE_CAST(codigo_qualificacao_socio AS INT64) codigo_qualificacao_socio,
SAFE_CAST(percentual_capital_social AS NUMERIC) percentual_capital_social,
SAFE_CAST(data_entrada_sociedade AS DATE) data_entrada_sociedade,
SAFE_CAST(ano_entrada_sociedade AS INT64) ano_entrada_sociedade,
SAFE_CAST(CPF_representante_legal AS STRING) CPF_representante_legal,
SAFE_CAST(nome_representante_legal AS STRING) nome_representante_legal,
SAFE_CAST(codigo_qual_representante_legal AS INT64) codigo_qual_representante_legal
from basedosdados-staging.br_me_socios_staging.socio as t