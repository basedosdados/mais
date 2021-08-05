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
CREATE VIEW basedosdados-dev.br_sp_gov_orcamento.receita_prevista AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(orgao AS STRING) orgao,
SAFE_CAST(gestao AS STRING) gestao,
SAFE_CAST(unidade_gestora AS STRING) unidade_gestora,
SAFE_CAST(fonte_de_recursos AS STRING) fonte_de_recursos,
SAFE_CAST(receita AS STRING) receita,
SAFE_CAST(previsto_do_ano AS FLOAT64) previsto_do_ano
from basedosdados-dev.br_sp_gov_orcamento_staging.receita_prevista AS t
