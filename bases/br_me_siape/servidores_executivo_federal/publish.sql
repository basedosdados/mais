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

CREATE VIEW basedosdados-dev.br_me_siape.servidores_executivo_federal AS
SELECT 
SAFE_CAST(orgao_vinculacao AS STRING) orgao_vinculacao,
SAFE_CAST(orgao_exercicio AS STRING) orgao_exercicio,
SAFE_CAST(sexo AS STRING) sexo,
SAFE_CAST(raca_cor AS STRING) raca_cor,
SAFE_CAST(situacao_vinculo AS STRING) situacao_vinculo,
SAFE_CAST(funcao AS STRING) funcao,
SAFE_CAST(nivel_funcao AS STRING) nivel_funcao,
SAFE_CAST(atividade AS STRING) atividade,
SAFE_CAST(data_admissao AS DATE) data_admissao
FROM basedosdados-dev.br_me_siape_staging.servidores_executivo_federal AS t